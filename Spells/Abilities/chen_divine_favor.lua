local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DivineFavor

function X.Cast()
    bot = GetBot()
    DivineFavor = bot:GetAbilityByName('chen_divine_favor')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DivineFavor, Target)
        return
    end
end

function X.Consider()
    if not DivineFavor:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DivineFavor:GetCastRange())
    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local botTarget = J.GetProperTarget(bot)

	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
        and not allyHero:IsIllusion()
		and not allyHero:IsInvulnerable()
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_chen_penitence_attack_speed_buff')
        and not allyHero:HasModifier('modifier_chen_divine_favor_armor_buff')
		then
			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidTarget(allyTarget)
                and J.IsCore(allyHero)
				and J.IsInRange(allyHero, allyTarget, 1200)
                and not J.IsSuspiciousIllusion(allyTarget)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

            if  J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3)
            then
                local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

                if J.IsValidHero(nAllyInRangeEnemy[1])
                and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 700)
                and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
                and not J.IsDisabled(nAllyInRangeEnemy[1])
                and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
		end
	end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
            local target = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if target ~= nil
            then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
	end

    if J.IsInTeamFight(bot, 1200)
    then
        local totDist = 0

        if bot.ChenCreepList ~= nil
        then
            for _, creep in pairs(bot.ChenCreepList)
            do
                local dist = GetUnitToUnitDistance(bot, creep)
                if dist > 1600
                then
                    totDist = totDist + dist
                end
            end

            if bot.ChenCreepList ~= nil and #bot.ChenCreepList > 0
            then
                if (totDist / #bot.ChenCreepList) > 1600
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and bot:WasRecentlyDamagedByAnyHero(3.5)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X