local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local InkSwell

function X.Cast()
    bot = GetBot()
    InkSwell = bot:GetAbilityByName('grimstroke_spirit_walk')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(InkSwell, Target)
        bot.InkSwellCastTime = DotaTime()
        return
    end
end

function X.Consider()
    if not InkSwell:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, InkSwell:GetCastRange())
	local nRadius = InkSwell:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        and not J.IsDisabled(enemyHero)
		then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            local nInRangeAllyEnemy = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

            for _, allyEnemyHero in pairs(nInRangeAllyEnemy)
            do
                if  J.IsValidHero(allyEnemyHero)
                and J.CanCastOnNonMagicImmune(allyEnemyHero)
                and allyEnemyHero:IsChanneling()
                and not J.IsDisabled(allyEnemyHero)
                and not allyEnemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not allyEnemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyEnemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    local dist = 1600
    local targetAlly = nil

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(allyHero)
        and GetUnitToUnitDistance(allyHero, botTarget) < dist
        then
            targetAlly = allyHero
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and targetAlly ~= nil
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(targetAlly:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, targetAlly
            end
        end
    end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.75
    and bot:WasRecentlyDamagedByAnyHero(3.5) and J.GetHP(bot) < 0.75
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X