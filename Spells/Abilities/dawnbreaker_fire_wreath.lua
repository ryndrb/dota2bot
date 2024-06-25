local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Starbreaker

function X.Cast()
    bot = GetBot()
    Starbreaker = bot:GetAbilityByName('dawnbreaker_fire_wreath')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Starbreaker, Location)
        return
    end
end

function X.Consider()
    if not Starbreaker:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = Starbreaker:GetSpecialValueInt('swipe_radius')
    local nComboDuration = Starbreaker:GetSpecialValueFloat('duration')
	local nCastPoint = Starbreaker:GetCastPoint()
    local nDamage = bot:GetAttackDamage() + Starbreaker:GetSpecialValueInt('swipe_damage') + Starbreaker:GetSpecialValueInt('smash_damage')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nCreeps = bot:GetNearbyCreeps(nRadius, true)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

    for _, enemyHero in pairs(nEnemyHeroes)
	do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
            and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nComboDuration + nCastPoint)
            end
        end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, nComboDuration + nCastPoint, 0)

		if  nLocationAoE.count >= 2
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nComboDuration + nCastPoint)
		end
	end

    if J.IsFarming(bot)
    then
        if nCreeps ~= nil
        and J.CanBeAttacked(nCreeps[1])
        and not J.IsRunning(nCreeps[1])
        and ((#nCreeps >= 3)
            or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nCreeps)
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end
    end

    if  J.IsLaning(bot)
	and J.GetManaAfter(Starbreaker:GetManaCost()) > 0.25
	then
        local creepCount = 0
        local loc = nil

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and creep:GetHealth() <= nDamage
            and creep:GetHealth() > bot:GetAttackDamage()
			then
                loc = creep:GetLocation()
                creepCount = creepCount + 1
			end
		end

        if  creepCount >= 2
        and loc ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, loc
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X