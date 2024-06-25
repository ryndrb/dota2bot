local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local WorkHorse

function X.Cast()
    bot = GetBot()
    WorkHorse = bot:GetAbilityByName('centaur_work_horse')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(WorkHorse)
        return
    end
end

function X.Consider()
    if not WorkHorse:IsTrained()
    or not WorkHorse:IsFullyCastable()
    or bot:HasModifier('modifier_centaur_stampede')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    if J.IsInTeamFight(bot, 1200)
	then
        local nTeamFightLocation = J.GetTeamFightLocation(bot)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and nTeamFightLocation ~= nil
        then
            if J.GetLocationToLocationDistance(bot:GetLocation(), nTeamFightLocation) < 600
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 600)
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and #nTargetInRangeAlly > #nInRangeAlly
            and #nTargetInRangeAlly >= 2
            and #nInRangeAlly <= 1
            and J.GetHP(bot) < 0.5
            then
		        return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X