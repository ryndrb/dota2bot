local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FreezingField

function X.Cast()
    bot = GetBot()
    FreezingField = bot:GetAbilityByName('crystal_maiden_freezing_field')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FreezingField)
        return
    end
end

function X.Consider()
    if not FreezingField:IsFullyCastable()
    or bot:DistanceFromFountain() < 300
    then
        return BOT_ACTION_DESIRE_NONE
    end


    local nRadius = FreezingField:GetAOERadius() * 0.88

    local nAllies =  bot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )

    local nEnemysHeroesInRange = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )

    local _, CrystalNova = J.HasAbility(bot, 'crystal_maiden_crystal_nova')
    local _, Frostbite = J.HasAbility(bot, 'crystal_maiden_frostbite')

    local botTarget = J.GetProperTarget(bot)


    local aoeCanHurtCount = 0
    for _, enemy in pairs ( nEnemysHeroesInRange )
    do
        if J.IsValidHero( enemy )
            and J.CanCastOnNonMagicImmune( enemy )
            and ( J.IsDisabled( enemy )
                or J.IsInRange( bot, enemy, nRadius * 0.82 - enemy:GetCurrentMovementSpeed() ) )
        then
            aoeCanHurtCount = aoeCanHurtCount + 1
        end
    end
    if not J.IsRetreating(bot)
        or ( J.IsRetreating(bot) and bot:GetActiveModeDesire() <= 0.85 )
    then
        if ( nEnemysHeroesInRange ~= nil and #nEnemysHeroesInRange >= 3 or aoeCanHurtCount >= 2 )
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end


    if J.IsGoingOnSomeone( bot )
    then
        if J.IsValidHero( botTarget )
            and J.CanCastOnNonMagicImmune( botTarget )
            and ( J.IsDisabled( botTarget ) or J.IsInRange( bot, botTarget, 280 ) )
            and botTarget:GetHealth() <= botTarget:GetActualIncomingDamage( bot:GetOffensivePower() * 1.5, DAMAGE_TYPE_MAGICAL )
            and GetUnitToUnitDistance( botTarget, bot ) <= nRadius
            and botTarget:GetHealth() > 400
            and nAllies ~= nil and #nAllies <= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating( bot ) and J.GetHP(bot) > 0.38
    then
        local nEnemysHeroesNearby = bot:GetNearbyHeroes( 500, true, BOT_MODE_NONE )
        local nEnemysHeroesFurther = bot:GetNearbyHeroes( 1300, true, BOT_MODE_NONE )
        local npcTarget = nEnemysHeroesNearby[1]
        if J.IsValidHero( npcTarget )
            and J.CanCastOnNonMagicImmune( npcTarget )
            and (CrystalNova ~= nil and not CrystalNova:IsFullyCastable())
            and (Frostbite ~= nil and not Frostbite:IsFullyCastable())
            and J.GetHP(bot) > 0.38 * #nEnemysHeroesFurther
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X