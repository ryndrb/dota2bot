local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local PrimalSplit

function X.Cast()
    bot = GetBot()
    PrimalSplit = bot:GetAbilityByName('brewmaster_primal_split')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(PrimalSplit)
        return
    end
end

function X.Consider()
    if not PrimalSplit:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
    local botTarget = J.GetProperTarget(bot)

    if nAllyHeroes ~= nil and #nAllyHeroes == 0
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if  J.GetHP(bot) < 0.33
    and nEnemyHeroes ~= nil and #nEnemyHeroes >= 2
    and nAllyHeroes ~= nil and #nAllyHeroes == 0
    then
        return BOT_ACTION_DESIRE_HIGH
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
        and J.IsInRange(bot, botTarget, 888)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not J.IsMeepoClone(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not J.IsLocationInChrono(botTarget:GetLocation())
		then
            if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
            and (#nAllyHeroes >= #nEnemyHeroes or J.WeAreStronger(bot, 1200))
            and J.IsCore(botTarget)
            and not (#nAllyHeroes >= 2 and #nEnemyHeroes <= 1)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		if  nEnemyHeroes ~= nil and nAllyHeroes ~= nil
        and #nEnemyHeroes >= 3 and #nAllyHeroes <= 1
        then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X