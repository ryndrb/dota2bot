local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FireRemnant

local remnantCastTime = -100
local remnantCastGap  = 0.2

function X.Cast()
    bot = GetBot()
    FireRemnant = bot:GetAbilityByName('ember_spirit_fire_remnant')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(FireRemnant, Target)
        remnantCastTime = DotaTime()
        return
    end
end

function X.Consider()
    if not FireRemnant:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if DotaTime() < remnantCastTime + remnantCastGap
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local remnantCount = 0
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
	do
		if  u ~= nil
		and u:GetUnitName() == 'npc_dota_ember_spirit_remnant'
		and GetUnitToUnitDistance(bot, u) < 1600
		then
			remnantCount = remnantCount + 1
		end
	end

	if remnantCount > 0
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, FireRemnant:GetCastRange())
	local nCastPoint = FireRemnant:GetCastPoint()
	local nDamage = FireRemnant:GetSpecialValueInt('damage')
	local nSpeed = bot:GetCurrentMovementSpeed() * (FireRemnant:GetSpecialValueInt('speed_multiplier') / (bot:HasScepter() and 50 or 100))
	local botTarget = J.GetProperTarget(bot)

	if nCastRange > 1600 then nCastRange = 1600 end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not J.IsInRange(bot, enemyHero, bot:GetAttackRange() + 150)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
		and GetUnitToUnitDistance(bot, enemyHero) > bot:GetAttackRange() - 25
		then
			local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
        and not botTarget:IsAttackImmune()
		and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint

			if J.IsInLaningPhase()
            then
                if botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
                end
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	and bot:GetActiveModeDesire() > 0.65
	then
		if bot:WasRecentlyDamagedByAnyHero(5)
		and nAllyHeroes ~= nil and nEnemyHeroes ~= nil
		and (#nEnemyHeroes >= #nAllyHeroes)
		and (#nEnemyHeroes >= 2 or J.GetHP(bot) < 0.5)
		and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), RandomInt(600, 1400))
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X