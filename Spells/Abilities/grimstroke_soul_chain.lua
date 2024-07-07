local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SoulBind

function X.Cast()
    bot = GetBot()
    SoulBind = bot:GetAbilityByName('grimstroke_soul_chain')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SoulBind, Target)
        return
    end
end

function X.Consider()
    if not SoulBind:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nRadius = SoulBind:GetSpecialValueInt('chain_latch_radius')
    local nDuration = SoulBind:GetSpecialValueInt('chain_duration')

    if J.IsGoingOnSomeone(bot)
    then
        local strongestTarget = J.GetStrongestUnit(1200, bot, true, true, nDuration)
        if strongestTarget == nil
        then
            strongestTarget = J.GetStrongestUnit(1200, bot, true, false, nDuration)
        end

        if  J.IsValidHero(strongestTarget)
        and not J.IsSuspiciousIllusion(strongestTarget)
        and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = strongestTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = strongestTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
            local nTargetInRangeAlly = J.GetEnemiesNearLoc(strongestTarget:GetLocation(), nRadius)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            and nTargetInRangeAlly ~= nil and #nTargetInRangeAlly >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, strongestTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X