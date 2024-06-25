local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Surge

function X.Cast()
    bot = GetBot()
    Surge = bot:GetAbilityByName('dark_seer_surge')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Surge, Target)
        return
    end
end

function X.Consider()
	if not Surge:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Surge:GetCastRange())
    local nAbilityLevel = Surge:GetLevel()
    local RoshanLocation = J.GetCurrentRoshanLocation()
    local TormentorLocation = J.GetTormentorLocation(GetTeam())

    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local tToMeDist = GetUnitToUnitDistance(bot, botTarget)
			local targetHero = bot

			for _, allyHero in pairs(nAllyHeroes)
            do
                if J.IsValidHero(bot, allyHero, nCastRange + 150)
                then
                    local allyTarget = J.GetProperTarget(allyHero)
                    local dist = GetUnitToUnitDistance(allyHero, botTarget)

                    if  dist < tToMeDist
                    and dist < nCastRange
                    and J.IsValidTarget(allyTarget)
                    and not J.IsSuspiciousIllusion(allyTarget)
                    and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                    and allyHero:IsFacingLocation(allyTarget:GetLocation(), 30)
                    then
                        tToMeDist = dist
                        targetHero = allyHero
                    end
                end
			end

			return BOT_ACTION_DESIRE_HIGH, targetHero
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.75
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and (J.IsChasingTarget(nEnemyHeroes[1], bot) or bot:WasRecentlyDamagedByAnyHero(3))
        and J.IsInRange(bot, nEnemyHeroes[1], 600)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingRoshan(bot)
	then
        if  GetUnitToLocationDistance(bot, RoshanLocation) > 1600
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and nAbilityLevel >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingTormentor(bot)
	then
        if  GetUnitToLocationDistance(bot, TormentorLocation) > 1600
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and nAbilityLevel >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and (allyHero:GetCurrentMovementSpeed() < nAllyInRangeEnemy[1]:GetCurrentMovementSpeed() or J.IsDisabled(allyHero))
            and allyHero:IsFacingLocation(J.GetTeamFountain(), 30)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X