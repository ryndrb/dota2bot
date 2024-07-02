local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local LittleFriends

function X.Cast()
    bot = GetBot()
    LittleFriends = bot:GetAbilityByName('enchantress_little_friends')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LittleFriends, Target)
        return
    end
end

function X.Consider()
    if not LittleFriends:IsTrained()
    or not LittleFriends:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, LittleFriends:GetCastRange())
    local nRadius = LittleFriends:GetSpecialValueInt('radius')
    local nDuration = LittleFriends:GetSpecialValueInt('duration')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.GetHP(enemyHero) < 0.33
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            bot:SetTarget(enemyHero)
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot, 1200)
    then
        local botTarget = J.GetStrongestUnit(nCastRange, bot, true, false, nDuration)
        local nTargetInRangeEnemy = botTarget:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

        if  J.IsValidTarget(botTarget)
        and nTargetInRangeEnemy ~= nil and #nTargetInRangeEnemy >= 1
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
        end
    end

    if J.IsDoingRoshan(bot)
    then
        local botTarget = bot:GetAttackTarget()

        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X