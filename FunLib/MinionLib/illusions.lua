local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')

local X = {}
local bot

local nLanes = {
    LANE_TOP,
    LANE_MID,
    LANE_BOT,
}

local botAlive = false

function X.Think(ownerBot, hMinionUnit)
    if not U.IsValidUnit(hMinionUnit) then return end

    -- fix shared bug with common owner minions
    if hMinionUnit.fNextMovementTime == nil then hMinionUnit.fNextMovementTime = 0 end

    bot = ownerBot
    botAlive = bot:IsAlive()

	hMinionUnit.attack_desire, hMinionUnit.attack_target = X.ConsiderAttack(hMinionUnit)
    if hMinionUnit.attack_desire > 0 then
        if U.IsValidUnit(hMinionUnit.attack_target) then
            if J.IsRoshan(hMinionUnit.attack_target) and GetUnitToLocationDistance(hMinionUnit, J.GetCurrentRoshanLocation()) > 200 then
                hMinionUnit:Action_MoveToLocation(J.GetCurrentRoshanLocation())
                return
            else
                hMinionUnit:Action_AttackUnit(hMinionUnit.attack_target, false)
                return
            end
        end
    end

    if DotaTime() > hMinionUnit.fNextMovementTime then
        hMinionUnit.fNextMovementTime = DotaTime() + RandomFloat(0.1, 0.5)
        hMinionUnit.move_desire, hMinionUnit.move_location = X.ConsiderMove(hMinionUnit)
        if hMinionUnit.move_desire > 0 then
            hMinionUnit:Action_MoveToLocation(hMinionUnit.move_location)
            return
        end

        -- Default
        if botAlive
        then
            local heroLocation = bot:GetLocation()
            local tempRadians = bot:GetFacing() * math.pi / 180
            local rightVector = Vector(math.sin(tempRadians), -math.cos(tempRadians), 0)
            hMinionUnit:Action_MoveToLocation(heroLocation + 300 * rightVector)
        else
            hMinionUnit:Action_MoveToLocation(J.GetClosestEnemyLaneFront(hMinionUnit))
        end
    end
end

function X.ConsiderAttack(hMinionUnit)
	if U.CantAttack(hMinionUnit)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local hTarget = X.GetAttackTarget(hMinionUnit)

	if hTarget ~= nil and not U.IsNotAllowedToAttack(hTarget)
	then
		return BOT_ACTION_DESIRE_HIGH, hTarget
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

local hSpecialUnit = nil
function X.GetAttackTarget(hMinionUnit)
	local target = nil
    local hMinionUnitName = hMinionUnit:GetUnitName()

	if bot:HasModifier('modifier_bane_nightmare') and not bot:IsInvulnerable()
    and GetUnitToUnitDistance(bot, hMinionUnit) < 2000
    then
        target = bot
    end

    if U.IsValidTarget(hSpecialUnit) then
        return hSpecialUnit
    else
        for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
            if U.IsValidUnit(unit) and J.IsInRange(hMinionUnit, unit, 1200) then
                local sUnitName = unit:GetUnitName()
                if string.find(sUnitName, 'observer_wards')
                or string.find(sUnitName, 'sentry_wards')
                or string.find(sUnitName, 'shadow_shaman_ward')
                or string.find(sUnitName, 'phoenix_sun')
                or string.find(sUnitName, 'tombstone')
                or string.find(sUnitName, 'warlock_golem')
                or string.find(sUnitName, 'lone_druid_bear')
                or string.find(sUnitName, 'lycan_wolf')
                or string.find(sUnitName, 'beastmaster_boar')
                or string.find(sUnitName, 'beastmaster_greater_boar')
                or string.find(sUnitName, 'eidolon')
                or string.find(sUnitName, 'venomancer_plague_ward')
                or string.find(sUnitName, 'necronomicon')
                or string.find(sUnitName, 'pugna_nether_ward')
                or string.find(sUnitName, 'weaver_swarm')
                or string.find(sUnitName, 'gyrocopter_homing_missile')
                or string.find(sUnitName, 'furion_treant')
                or string.find(sUnitName, 'broodmother_spiderling')
                or string.find(sUnitName, 'broodmother_spiderite')
                or string.find(sUnitName, 'wraith_king_skeleton_warrior')
                or string.find(sUnitName, 'ignis_fatuus')
                or string.find(sUnitName, 'invoker_forged_spirit')
                or string.find(sUnitName, 'clinkz_skeleton_archer')
                or string.find(sUnitName, 'juggernaut_healing_ward')
                or string.find(sUnitName, 'zeus_cloud')
                or string.find(sUnitName, 'rattletrap_cog')
                then
                    hSpecialUnit = unit
                    return unit
                end
            end
        end
    end

    if botAlive and bot:GetLevel() < 8 then
        if (string.find(hMinionUnitName, 'forge_spirit')
            or string.find(hMinionUnitName, 'eidolon')
            or string.find(hMinionUnitName, 'beastmaster_boar')
            or string.find(hMinionUnitName, 'lycan_wolf')
        )
        and U.IsTargetedByTower(hMinionUnit)
        then
            return nil
        end
    end

    if botAlive and GetUnitToUnitDistance(bot, hMinionUnit) < 1600
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeEnemy > 0 then
            target = bot:GetAttackTarget()
            if target == nil then target = bot:GetTarget() end
        end
    end

	if not botAlive
    or target == nil
    or (target ~= nil and not J.IsInRange(hMinionUnit, target, 1600))
    or (U.IsTargetedByHero(bot))
	then
		target = U.GetWeakestHero(1600, hMinionUnit)
		if target == nil then target = U.GetWeakestCreep(1600, hMinionUnit) end
		if target == nil then target = U.GetWeakestTower(1600, hMinionUnit) end
	end

	return target
end

function X.ConsiderMove(hMinionUnit)
	if J.CanNotUseAction(hMinionUnit) or U.CantMove(hMinionUnit) then return BOT_MODE_DESIRE_NONE, nil end

    -- Have Naga or TB farm lanes
    local hMinionUnitName = hMinionUnit:GetUnitName()
    if string.find(hMinionUnitName, 'terrorblade')
    or string.find(hMinionUnitName, 'naga_siren')
    then
        for i = 1, #nLanes
        do
            local laneFrontLoc = J.GetClosestTeamLane(hMinionUnit)
            if not X.IsMinionInLane(hMinionUnit, nLanes[i])
            then
                laneFrontLoc = GetLaneFrontLocation(GetTeam(), nLanes[i], 0)
            end

            if not J.IsInLaningPhase()
            -- and GetUnitToLocationDistance(hMinionUnit, laneFrontLoc) <= 2500
            then
                hMinionUnit.to_farm_lane = nLanes[i]
                return BOT_ACTION_DESIRE_HIGH, laneFrontLoc
            end
        end
    end

    if botAlive and bot:GetLevel() < 8 then
        if (string.find(hMinionUnitName, 'forge_spirit')
            or string.find(hMinionUnitName, 'eidolon')
            or string.find(hMinionUnitName, 'beastmaster_boar')
            or string.find(hMinionUnitName, 'lycan_wolf')
        )
        and U.IsTargetedByTower(hMinionUnit)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end

    if U.IsTargetedByTower(hMinionUnit)
    and (string.find(hMinionUnitName, 'warlock_golem')
        or hMinionUnit:HasModifier('modifier_dominated')
        or hMinionUnit:HasModifier('modifier_chen_holy_persuasion')
        or hMinionUnit:IsDominated())
    then
        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
    end

    if not botAlive
    or GetUnitToUnitDistance(bot, hMinionUnit) > 1600
    or bot:HasModifier('modifier_teleporting')
    then
        local nTeamFightLocation = J.GetTeamFightLocation(hMinionUnit)
        if nTeamFightLocation and GetUnitToLocationDistance(hMinionUnit, nTeamFightLocation) < 2200
        then
            return BOT_ACTION_DESIRE_HIGH, nTeamFightLocation
        end

        return BOT_ACTION_DESIRE_HIGH, J.GetClosestEnemyLaneFront(hMinionUnit)
    else
        if botAlive then
            local heroLocation = bot:GetLocation()
            local tempRadians = bot:GetFacing() * math.pi / 180
            local rightVector = Vector(math.sin(tempRadians), -math.cos(tempRadians), 0)
            return BOT_ACTION_DESIRE_HIGH, heroLocation + 300 * rightVector
        else
            return BOT_ACTION_DESIRE_HIGH, J.GetClosestTeamLane(hMinionUnit)
        end
    end
end

function X.IsTargetUnderEnemyTower(hMinionUnit, unit)
    local nEnemyTowers = hMinionUnit:GetNearbyTowers(1600, true)
    if J.IsValidBuilding(nEnemyTowers[1])
    and U.IsValidUnit(unit)
    and J.IsInRange(unit, nEnemyTowers[1], 880)
    then
        return true
    end

    return false
end

function X.IsMinionInLane(hMinionUnit, lane)
    for _, ally in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if J.IsValid(ally)
        and hMinionUnit ~= ally
        and ally:IsIllusion()
        and string.find(bot:GetUnitName(), ally:GetUnitName())
        then
            if ally.to_farm_lane == lane
            or GetUnitToLocationDistance(ally, GetLaneFrontLocation(GetTeam(), lane, 0)) < 1600
            then
                return true
            end
        end
    end

    return false
end

function J.GetClosestEnemyLaneFront(unit)
	local v_top_lane = GetLocationAlongLane(LANE_TOP, GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, false))
	local v_mid_lane = GetLocationAlongLane(LANE_MID, GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, false))
	local v_bot_lane = GetLocationAlongLane(LANE_BOT, GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, false))

	local dist_from_top = GetUnitToLocationDistance(unit, v_top_lane)
	local dist_from_mid = GetUnitToLocationDistance(unit, v_mid_lane)
	local dist_from_bot = GetUnitToLocationDistance(unit, v_bot_lane)

	if dist_from_top < dist_from_mid and dist_from_top < dist_from_bot
	then
		return v_top_lane
	elseif dist_from_mid < dist_from_top and dist_from_mid < dist_from_bot
	then
		return v_mid_lane
	elseif dist_from_bot < dist_from_top and dist_from_bot < dist_from_mid
	then
		return v_bot_lane
	end

	return v_mid_lane
end

return X
