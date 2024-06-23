local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local HairBall

function X.Cast()
    bot = GetBot()
    HairBall = bot:GetAbilityByName('bristleback_hairball')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(HairBall, Location)
        return
    end
end

function X.Consider()
    if not HairBall:IsTrained()
    or not HairBall:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = HairBall:GetSpecialValueInt('radius')
    local nCastRange = J.GetProperCastRange(false, bot, HairBall:GetCastRange())

    local botTarget = J.GetProperTarget( bot )

    if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
        if J.IsValidHero( nInRangeEnemy[1] )
        and J.CanCastOnNonMagicImmune( nInRangeEnemy[1] )
        then
            return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + nInRangeEnemy[1]:GetLocation()) / 2
        end
    end

    if J.IsInTeamFight( bot, 1400 )
    then
        local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
        if nAoeLoc ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, nAoeLoc
        end
    end

    if J.IsGoingOnSomeone( bot )
    then
        if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange )
        and J.CanCastOnNonMagicImmune( botTarget )
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X