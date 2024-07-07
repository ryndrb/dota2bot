local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DarkPortrait

function X.Cast()
    bot = GetBot()
    DarkPortrait = bot:GetAbilityByName('grimstroke_dark_portrait')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DarkPortrait, Target)
        return
    end
end

function X.Consider()
    if not DarkPortrait:IsTrained()
    or not DarkPortrait:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    if J.IsGoingOnSomeone(bot)
    then
        local strongestTarget = J.GetStrongestUnit(1600, bot, true, true, 5)
        if strongestTarget == nil
        then
            strongestTarget = J.GetStrongestUnit(1600, bot, true, false, 5)
        end

        if  J.IsValidHero(strongestTarget)
        and not J.IsSuspiciousIllusion(strongestTarget)
        and not J.IsDisabled(strongestTarget)
        and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = strongestTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = strongestTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            then
                return BOT_ACTION_DESIRE_HIGH, strongestTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X