local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Fireball

function X.Cast()
    bot = GetBot()
    Fireball = bot:GetAbilityByName('dragon_knight_fireball')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Fireball, Location)
        return
    end
end

function X.Consider()
    if not Fireball:IsTrained()
    or not Fireball:IsFullyCastable() 
    or Fireball:IsHidden()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = Fireball:GetSpecialValueInt('radius')
    local nCastRange = J.GetProperCastRange(false, bot, Fireball:GetCastRange())

    local enemyHeroList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )

    if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
    then
        local targetHero = enemyHeroList[1]
        if J.IsValidHero( targetHero )
        and J.IsInRange(bot, targetHero, nRadius)
        and J.CanCastOnNonMagicImmune( targetHero )
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
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
        local targetHero = J.GetProperTarget( bot )
        if J.IsValidHero( targetHero )
        and J.IsInRange( bot, targetHero, nCastRange )
        and J.CanCastOnNonMagicImmune( targetHero )
        then
            return BOT_ACTION_DESIRE_HIGH, targetHero:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X