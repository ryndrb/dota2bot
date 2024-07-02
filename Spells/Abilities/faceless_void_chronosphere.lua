local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Chronosphere

function X.Cast()
    bot = GetBot()
    Chronosphere = bot:GetAbilityByName('faceless_void_chronosphere')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Chronosphere, Target)
        return
    end
end

function X.Consider()
    if not Chronosphere:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Chronosphere:GetCastRange())
	local nCastPoint = Chronosphere:GetCastPoint()
	local nRadius = Chronosphere:GetSpecialValueInt('radius')
	local nDuration = Chronosphere:GetSpecialValueInt('duration')
	local nAttackDamage = bot:GetAttackDamage()
	local nAttackSpeed = bot:GetAttackSpeed()
	local nBotKills = GetHeroKills(bot:GetPlayerID())
	local nBotDeaths = GetHeroDeaths(bot:GetPlayerID())
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius / 1.2, nCastPoint, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 1.2)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			local targetHero = nil
			local currHeroHP = 10000

			for _, enemyHero in pairs(nInRangeEnemy)
			do
				if  J.IsValidHero(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not enemyHero:IsAttackImmune()
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				and enemyHero:GetHealth() < currHeroHP
				then
					currHeroHP = enemyHero:GetHealth()
					targetHero = enemyHero
				end
			end

			if targetHero ~= nil
			then
                local targetLoc = X.GetBestChrono(nAllyHeroes, nEnemyHeroes, nCastRange, nRadius)
                if targetLoc == 0 then targetLoc = nLocationAoE.targetloc end
                bot:SetTarget(targetHero)
                bot.ChronoTarget = targetHero
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end

		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and not botTarget:IsAttackImmune()
        and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			if  nAllyHeroes ~= nil and nEnemyHeroes ~= nil
			and #nAllyHeroes >= #nEnemyHeroes
			and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
			then
				local loc = J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)

				if  J.CanKillTarget(botTarget, nAttackDamage * nAttackSpeed * nDuration, DAMAGE_TYPE_PHYSICAL)
				and not J.IsLocationInChrono(loc)
				and not J.IsLocationInBlackHole(loc)
				and not J.IsLocationInArena(loc, nRadius)
				then
					if J.IsCore(botTarget)
					then
						bot:SetTarget(botTarget)
                        bot.ChronoTarget = botTarget
						return BOT_ACTION_DESIRE_HIGH, loc
					end

					if  not J.IsCore(botTarget)
					and nBotDeaths > nBotKills + 4
					then
						bot:SetTarget(botTarget)
                        bot.ChronoTarget = botTarget
						return BOT_ACTION_DESIRE_HIGH, loc
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(5)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_legion_commander_duel')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = nEnemyHeroes[1]:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nEnemyHeroes[1]:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil and nInRangeAlly ~= nil
            and #nTargetInRangeAlly > #nInRangeAlly + 2
            and #nInRangeAlly <= 1
            then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
                local nTargetLocInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

                if not J.IsLocationInChrono(nLocationAoE.targetloc)
                and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
                and not J.IsLocationInArena(nLocationAoE.targetloc, nRadius)
                then
                    if #nTargetLocInRangeEnemy >= 2
                    then
                        bot.ChronoTarget = nil
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    else
                        bot.ChronoTarget = nil
                        return nEnemyHeroes[1]:GetLocation()
                    end
                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.GetBestChrono(hAllyList, hEnemyList, nCastRange, nRadius)
    local vLoc = 0
    local maxEnemies = 0
    local minAllies = math.huge

    for _, enemyHero in pairs(hEnemyList)
    do
        local enemyLoc = J.GetCorrectLoc(enemyHero, 0.35)

        if GetUnitToUnitDistance(bot, enemyHero) <= nCastRange
        then
            local enemyCount = 0
            local allyCount = 0

            for _, e in pairs(hEnemyList)
            do
                if GetUnitToLocationDistance(e, enemyLoc) <= nRadius
                then
                    enemyCount = enemyCount + 1
                end
            end

            for _, a in pairs(hAllyList)
            do
                if GetUnitToLocationDistance(a, enemyLoc) <= nRadius
                then
                    allyCount = allyCount + 1
                end
            end

            if (enemyCount > maxEnemies) or (enemyCount == maxEnemies and allyCount < minAllies)
            then
                vLoc = enemyLoc
                maxEnemies = enemyCount
                minAllies = allyCount
            end
        end
    end

    return vLoc
end

return X