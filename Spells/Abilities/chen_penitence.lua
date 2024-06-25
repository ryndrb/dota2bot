local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Penitence

function X.Cast()
    bot = GetBot()
    Penitence = bot:GetAbilityByName('chen_penitence')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Penitence, Target)
        return
    end
end

function X.Consider()
    if not Penitence:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Penitence:GetCastRange())
    local nAttackRange = bot:GetAttackRange()

    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and allyHero:GetCurrentMovementSpeed() < nAllyInRangeEnemy[1]:GetCurrentMovementSpeed()
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsChasingTarget(bot, botTarget)
            and bot:GetCurrentMovementSpeed() < botTarget:GetCurrentMovementSpeed()
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end

            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            if  J.IsInRange(bot, botTarget, nAttackRange)
            and J.IsAttacking(bot)
            and J.GetHeroCountAttackingTarget(nInRangeAlly, botTarget) >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:GetCurrentMovementSpeed() < enemyHero:GetCurrentMovementSpeed()
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)

		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and not botTarget:IsAttackImmune()
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and nInRangeAlly ~= nil and #nInRangeAlly >= 1
        and J.GetHeroCountAttackingTarget(nInRangeAlly, botTarget) >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X