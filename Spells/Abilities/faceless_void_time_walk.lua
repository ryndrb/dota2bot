local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local TimeWalk

function X.Cast()
    bot = GetBot()
    TimeWalk = bot:GetAbilityByName('faceless_void_time_walk')

    if bot.TimeWalkPrevLocation == nil then bot.TimeWalkPrevLocation = bot:GetLocation() end

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(TimeWalk, Target)
        bot.TimeWalkPrevLocation = Target
        return
    end
end

function X.Consider()
    if not TimeWalk:IsFullyCastable()
	or bot:HasModifier("modifier_faceless_void_chronosphere_speed")
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = TimeWalk:GetSpecialValueInt('range')
	local nCastPoint = TimeWalk:GetCastPoint()
	local nSpeed = TimeWalk:GetSpecialValueInt('speed')
	local nDamageWindow = TimeWalk:GetSpecialValueInt('backtrack_duration')
    local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(888, true)

	if bot.InfoBuffer ~= nil
	then
		-- try to backtrack ~^40% of damage
		for i = 1, math.ceil(nDamageWindow)
		do
			local prevHealth = bot.InfoBuffer[i].health
			if prevHealth and (prevHealth / bot:GetMaxHealth()) - J.GetHP(bot) >= 0.4
			then
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
			end
		end
	end

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
	end

	if J.IsStunProjectileIncoming(bot, 350)
	or J.IsUnitTargetProjectileIncoming(bot, 350)
    then
        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
    end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 350)
		then
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:IsAttackImmune()
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			local loc = J.GetCorrectLoc(botTarget, eta)

			if IsLocationPassable(loc)
			and not J.IsLocationInArena(loc, 600)
			then
				if GetUnitToLocationDistance(bot, loc) > bot:GetAttackRange() * 2
				then
					if J.IsInLaningPhase()
					then
						local nInRangeAlly = bot:GetNearbyHeroes(888, false, BOT_MODE_NONE)
						if nEnemyTowers ~= nil
                        and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToLocationDistance(botTarget, loc) > 888)
						and botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget)
						then
                            if GetUnitToLocationDistance(bot, loc) > nCastRange
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
                            else
                                return BOT_ACTION_DESIRE_HIGH, loc
                            end
						end
					else
						if GetUnitToLocationDistance(bot, loc) > nCastRange
                        then
                            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
                        else
                            return BOT_ACTION_DESIRE_HIGH, loc
                        end
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(nDamageWindow)
	and bot:GetActiveModeDesire() > 0.8
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 600)
        and (not J.IsSuspiciousIllusion(nEnemyHeroes[1]) or J.GetHP(bot) < 0.4)
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

	if J.IsPushing(bot)
    and J.GetManaAfter(TimeWalk:GetManaCost()) > 0.45
	then
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) > 500
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if J.IsFarming(bot)
    and J.GetManaAfter(TimeWalk:GetManaCost()) > 0.33
	then
		if  J.IsValid(botTarget)
		and GetUnitToUnitDistance(bot, botTarget) > 500
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsLaning(bot)
	then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and GetUnitToUnitDistance(creep, bot) > 500
			then
				local nTime = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				local nDamage = bot:GetAttackDamage()

				if  J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nTime)
				and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
				and nEnemyTowers ~= nil and #nEnemyTowers == 0
				then
					bot:SetTarget(creep)
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end

		if  J.GetManaAfter(TimeWalk:GetManaCost()) > 0.85
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > nCastRange
			then
				local nLocation = J.Site.GetXUnitsTowardsLocation(bot, nLaneFrontLocation, nCastRange)
				if IsLocationPassable(nLocation)
                and bot:IsFacingLocation(nLocation, 30)
				then
					return BOT_ACTION_DESIRE_HIGH, nLocation
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)
    and bot:GetActiveModeDesire() > 0.7
    then
		local roshLoc = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, roshLoc) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, roshLoc, nCastRange)

			if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end
        end
    end

    if J.IsDoingTormentor(bot)
    and bot:GetActiveModeDesire() > 0.7
    then
		local tormentorLoc = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, tormentorLoc) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, tormentorLoc, nCastRange)

			if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end

        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X