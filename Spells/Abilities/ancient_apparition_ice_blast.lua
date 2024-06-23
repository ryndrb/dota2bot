local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local IceBlast

function X.Cast()
    bot = GetBot()
    IceBlast = bot:GetAbilityByName('ancient_apparition_ice_blast')

    if bot.IceBlastReleaseLocation == nil then bot.IceBlastReleaseLocation = bot:GetLocation() end

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(IceBlast, Location)
        bot.IceBlastReleaseLocation = Location
        return
    end
end

function X.Consider()
    if not IceBlast:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nMinRadius = IceBlast:GetSpecialValueInt('radius_min')
    local nGrowSpeed = IceBlast:GetSpecialValueInt('radius_grow')
    local nMaxRadius = IceBlast:GetSpecialValueInt('radius_max')

    if J.IsInTeamFight(bot, 1600)
    then
        local nTeamFightLocation = J.GetTeamFightLocation(bot)

        if nTeamFightLocation ~= nil
        then
            local dist = GetUnitToLocationDistance(bot, nTeamFightLocation)
            local nRadius = math.min(nMinRadius + (dist * nGrowSpeed), nMaxRadius)
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1600, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    if nTeamFightLocation ~= nil
    and GetUnitToLocationDistance(bot, nTeamFightLocation) > 1600
    then
        local dist = GetUnitToLocationDistance(bot, nTeamFightLocation)
        local nRadius = math.min(nMinRadius + (dist * nGrowSpeed), nMaxRadius)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nTeamFightLocation, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nTeamFightLocation
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X