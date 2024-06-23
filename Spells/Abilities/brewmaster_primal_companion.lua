local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local PrimalCompanion

function X.Cast()
    bot = GetBot()
    PrimalCompanion = bot:GetAbilityByName('brewmaster_primal_companion')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(PrimalCompanion)
        return
    end
end

function X.Consider()
    if not bot:HasScepter()
    or not PrimalCompanion:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local _, PrimalSplit = J.HasAbility(bot, 'brewmaster_primal_split')
    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
    local botTarget = J.GetProperTarget(bot)

    if PrimalSplit ~= nil and (PrimalSplit:IsFullyCastable() or PrimalSplit:GetCooldownTimeRemaining() < 5)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	if J.IsInTeamFight(bot, 1200)
	then
        if nEnemyHeroes ~= nil and #nEnemyHeroes >= 2
        then
			return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and not botTarget:IsAttackImmune()
        and J.IsInRange(bot, botTarget, 600)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not J.IsMeepoClone(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not J.IsLocationInChrono(botTarget:GetLocation())
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X