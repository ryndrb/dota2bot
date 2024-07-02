local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CurseOfTheOldGrowth

function X.Cast()
    bot = GetBot()
    CurseOfTheOldGrowth = bot:GetAbilityByName('furion_curse_of_the_forest')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CurseOfTheOldGrowth)
        return
    end
end

function X.Consider()
    if not CurseOfTheOldGrowth:IsTrained()
    or not CurseOfTheOldGrowth:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = CurseOfTheOldGrowth:GetSpecialValueInt('range')

    if J.IsInTeamFight(bot, 1200)
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

        if #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X