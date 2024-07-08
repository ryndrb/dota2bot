local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local PierceTheVeil

function X.Cast()
    bot = GetBot()
    PierceTheVeil = bot:GetAbilityByName('muerta_pierce_the_veil')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(PierceTheVeil)
        return
    end
end

function X.Consider()
    if not PierceTheVeil:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsInTeamFight(bot, bot:GetAttackRange() + 150)
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), bot:GetAttackRange() + 300)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not bot:IsAttackImmune()
        and not bot:IsInvulnerable()
        and (not bot:IsMagicImmune() or not bot:HasModifier('modifier_black_king_bar_immune'))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and not botTarget:IsAttackImmune()
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.GetHP(bot) <= 0.75
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
            and not (#nAllyHeroes >= #nEnemyHeroes + 2)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(5)
    and bot:GetActiveModeDesire() > 0.7
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and (J.IsChasingTarget(nEnemyHeroes[1], bot) or (J.IsAttacking(nEnemyHeroes[1]) and nEnemyHeroes[1]:GetAttackTarget() == bot))
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and J.GetHP(bot) <= 0.55
        and not bot:IsAttackImmune()
        and not bot:IsInvulnerable()
        and not bot:IsMagicImmune()
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
    then
        if J.IsRoshan(botTarget) or J.IsTormentor(botTarget)
        and J.GetHP(bot) < 0.17
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X