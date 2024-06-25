local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Glacier

function X.Cast()
    bot = GetBot()
    Glacier = bot:GetAbilityByName('drow_ranger_glacier')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Glacier)
        return
    end
end

function X.Consider()
    if not Glacier:IsTrained()
	or not Glacier:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

    local _, Multishot = J.HasAbility(bot, 'drow_ranger_multishot')
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local botTarget = J.GetProperTarget(bot)

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and (bot:GetActiveModeDesire() > 0.7 or bot:WasRecentlyDamagedByHero(nEnemyHeroes[1], 2) or J.GetHP(bot) < 0.3 or #nEnemyHeroes >= 2)
        and bot:IsFacingLocation(J.GetTeamFountain(), 30)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and not botTarget:IsAttackImmune()
		and ((Multishot ~= nil and Multishot:IsFullyCastable())
            or botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 3.5, DAMAGE_TYPE_PHYSICAL))
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X