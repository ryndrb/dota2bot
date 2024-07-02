local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Sproink

function X.Cast()
    bot = GetBot()
    Sproink = bot:GetAbilityByName('enchantress_bunny_hop')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Sproink)
        return
    end
end

function X.Consider()
    if not Sproink:IsTrained()
    or not Sproink:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nImpetusMul = 0
    local botTarget = J.GetProperTarget(bot)

    local _, Impetus = J.HasAbility(bot, 'enchantress_impetus')
    if Impetus ~= nil
    then
        nImpetusMul = Impetus:GetSpecialValueFloat('value') / 100
    end

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and not enemyHero:IsAttackImmune()
        and J.CanKillTarget(enemyHero, nImpetusMul * GetUnitToUnitDistance(bot, enemyHero), DAMAGE_TYPE_PURE)
        and bot:IsFacingLocation(enemyHero:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
        and (#nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByAnyHero(4))
        and J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nAttackRange)
        and bot:IsFacingLocation(nEnemyHeroes[1]:GetLocation(), 30)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X