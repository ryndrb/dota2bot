local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SkeletonWalk

function X.Cast()
    bot = GetBot()
    SkeletonWalk = bot:GetAbilityByName('clinkz_wind_walk')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SkeletonWalk)
        return
    end
end

function X.Consider()
    if not SkeletonWalk:IsFullyCastable()
    or bot:HasModifier('modifier_clinkz_wind_walk')
    or J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local RoshanLocation = J.GetCurrentRoshanLocation()
    local TormentorLocation = J.GetTormentorLocation(GetTeam())
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local botTarget = J.GetProperTarget(bot)

    if  J.IsGoingOnSomeone(bot)
    and bot:GetActiveModeDesire() > 0.65
	then
		if  J.IsValidTarget(botTarget)
        and GetUnitToUnitDistance(bot, botTarget) > 1600
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.5
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and (bot:WasRecentlyDamagedByAnyHero(4) or J.GetHP(bot) < 0.5 or not J.WeAreStronger(bot, 1600))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsPushing(bot)
    then
        if bot.laneToPush ~= nil
        then
            if  GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0)) > 3200
            and bot:GetActiveModeDesire() > 0.65
            then
                return  BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot)
    then
        if bot.laneToDefend ~= nil
        then
            if  GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0)) > 3200
            and bot:GetActiveModeDesire() > 0.65
            then
                return  BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot)
    then
        if bot.farmLocation ~= nil
        then
            if GetUnitToLocationDistance(bot, bot.farmLocation) > 3200
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsLaning(bot)
	then
		if  J.GetManaAfter(SkeletonWalk:GetManaCost()) > 0.8
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > 1600
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if GetUnitToLocationDistance(bot, RoshanLocation) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if GetUnitToLocationDistance(bot, TormentorLocation) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X