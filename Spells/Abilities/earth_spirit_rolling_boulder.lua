local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local RollingBoulder

local nStone

function X.Cast()
    bot = GetBot()
    RollingBoulder = bot:GetAbilityByName('earth_spirit_rolling_boulder')

    local _, StoneRemnant = J.HasAbility(bot, 'earth_spirit_stone_caller')

    if StoneRemnant ~= nil and StoneRemnant:IsFullyCastable()
    then
        nStone = 1
    else
        nStone = 0
    end

    Desire, Location, CanRemnantRollCombo = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if CanRemnantRollCombo
		then
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, Location)
			return
		else
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, Location)
			return
		end
    end
end

function X.Consider()
    if not RollingBoulder:IsFullyCastable() or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nDistance = RollingBoulder:GetSpecialValueInt('distance')
	local nDelay = RollingBoulder:GetSpecialValueFloat('delay')
	local nSpeed = RollingBoulder:GetSpecialValueInt('rock_speed')
	local nDamage = RollingBoulder:GetSpecialValueInt('damage')
    local botTarget = J.GetProperTarget(bot)

	local nNearbyEnemySearchRange = nDistance
	if nStone >= 1
	then
		nNearbyEnemySearchRange = nDistance * 2
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nNearbyEnemySearchRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not bot:HasModifier('modifier_earth_spirit_rolling_boulder_caster')
		then
            if enemyHero:IsChanneling()
            or (J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe'))
            then
                local loc = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, target) / nSpeed) + nDelay)

                if X.IsStoneInPath(loc, GetUnitToLocationDistance(bot, loc))
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, false
                elseif nStone >= 1
                then
                    loc = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, target) / (nSpeed + 600)) + nDelay)
                    return BOT_ACTION_DESIRE_HIGH, loc, true
                elseif nStone == 0
                then
                    if GetUnitToLocationDistance(bot, loc) > nDistance
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nDistance), false
                    else
                        return BOT_ACTION_DESIRE_HIGH, loc, false
                    end
                end
            end
		end
	end

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nDistance)
	end

	if J.IsGoingOnSomeone(bot)
	then
        if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nNearbyEnemySearchRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / nSpeed)

            if nStone >= 1
            then
                loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / (nSpeed + 600))
                if X.IsStoneInPath(loc, GetUnitToUnitDistance(bot, botTarget))
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, false
                else
                    return BOT_ACTION_DESIRE_HIGH, loc, true
                end
            elseif nStone == 0
            then
                if GetUnitToLocationDistance(bot, loc) > nDistance
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nDistance), false
                else
                    return BOT_ACTION_DESIRE_HIGH, loc, false
                end
            end
        end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
        and (#nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) and bot:WasRecentlyDamagedByAnyHero(4)))
        then
            local loc = J.Site.GetXUnitsTowardsLocation(bot, J.GetEscapeLoc(), nDistance)

            if nStone >= 1
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and J.IsInRange(bot, nEnemyHeroes[1], 600)
				then
					return BOT_ACTION_DESIRE_HIGH, loc, true
				else
					return BOT_ACTION_DESIRE_HIGH, loc, false
				end
			elseif nStone == 0
			then
				return BOT_ACTION_DESIRE_HIGH, loc, false
			end
        end

        if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and bot:IsFacingLocation(J.GetTeamFountain(), 30)
        and J.IsRunning(bot)
        and bot:GetActiveModeDesire() > 0.7
        then
            local loc = J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nDistance)
            return BOT_ACTION_DESIRE_HIGH, loc, false
        end
	end

	if  J.GetMP(bot) > 0.88
	and bot:DistanceFromFountain() > 100
	and bot:DistanceFromFountain() < 6000
	and DotaTime() > 0
	and not J.IsDoingTormentor(bot)
	then
		local nLaneFrontLocationT = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)
		local nLaneFrontLocationM = GetLaneFrontLocation(GetTeam(), LANE_MID, 0)
		local nLaneFrontLocationB = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)
		local nDistFromLane = GetUnitToLocationDistance(bot, bot:GetLocation())
		local facingFrontLoc = Vector(0, 0, 0)

		if bot:IsFacingLocation(nLaneFrontLocationT, 45)
		then
			nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocationT)
			facingFrontLoc = nLaneFrontLocationT
		elseif bot:IsFacingLocation(nLaneFrontLocationM, 45)
		then
			nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocationM)
			facingFrontLoc = nLaneFrontLocationM
		elseif bot:IsFacingLocation(nLaneFrontLocationB, 45)
		then
			nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocationB)
			facingFrontLoc = nLaneFrontLocationB
		end

		if nDistFromLane > 1600
		then
			local location = J.Site.GetXUnitsTowardsLocation(bot, facingFrontLoc, nDistance)

			if IsLocationPassable(location)
			then
				return BOT_ACTION_DESIRE_HIGH, location, false
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.IsStoneInPath(vLoc, dist)
	if bot:IsFacingLocation(vLoc, 5)
	then
		for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_OTHER))
		do
			if  u ~= nil
			and u:GetUnitName() == "npc_dota_earth_spirit_stone"
			and bot:IsFacingLocation(u:GetLocation(), 5)
			and GetUnitToUnitDistance(u, bot) < dist
			then
				return true
			end
		end
	end

	return false
end

return X