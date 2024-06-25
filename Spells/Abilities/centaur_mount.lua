local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local HitchARide

function X.Cast()
    bot = GetBot()
    HitchARide = bot:GetAbilityByName('centaur_mount')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HitchARide, Target)
        return
    end
end

function X.Consider()
    if HitchARide:IsHidden()
    or not HitchARide:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, HitchARide:GetCastRange())

    if J.IsGoingOnSomeone(bot)
    or J.IsInTeamFight(bot, 1200)
    then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
        for _, allyHero in pairs(nInRangeAlly)
        do
            if  J.IsValidHero(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(4)
            and J.GetHP(allyHero) < 0.5
            and not allyHero:IsIllusion()
            and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

    if J.IsRetreating(bot)
    then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
        for _, allyHero in pairs(nInRangeAlly)
        do
            if  J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(4)
            and not allyHero:IsIllusion()
            and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X