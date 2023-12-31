local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local Defend = {}

function Defend.GetDefendDesire(bot, lane)

	local max = 0.9
	-- if J.IsCore(bot)
	-- and bot:GetActiveMode() == BOT_MODE_ROSHAN
	-- and bot:GetActiveModeDesire() > 0.75
	-- and not J.CanBeAttacked(GetAncient(GetTeam()))
	-- then
	-- 	max = 0.7
	-- end

	-- Laning Defend
	if (J.IsModeTurbo() and DotaTime() < 8 * 60)
	or DotaTime() < 12 * 60
	then
		local tFront = 1 - GetLaneFrontAmount(GetTeam(), lane, true)
		local eFront = 1 - GetLaneFrontAmount(GetOpposingTeam(), lane, true)

		if bot:GetHealth() / bot:GetMaxHealth() < 0.3
		then
			return 0.25
		end

		if Defend.ShouldGoDefend(bot, lane) then
			return Clamp(eFront, 0.1, max)
		end

		return 0.1
    end

	local mul = Defend.GetEnemyAmountMul(lane)
	-- print(bot:GetUnitName()..": "..tostring(lane)..": ", RemapValClamped(GetLaneFrontAmount(GetTeam(), lane, true), 0, 1, max, 0) * (1 - GetLaneFrontAmount(GetOpposingTeam(), lane, true)) * mul[lane])
	-- print(tostring(max).." remappedddd "..bot:GetUnitName()..": "..tostring(lane)..": ", RemapValClamped(GetLaneFrontAmount(GetTeam(), lane, false), 0.0, 1, max, 0))
	-- print(tostring(max).." lane frontE "..bot:GetUnitName()..": "..tostring(lane)..": ", 1 - GetLaneFrontAmount(GetOpposingTeam(), lane, true))
	-- print(tostring(max).." lane frontA "..bot:GetUnitName()..": "..tostring(lane)..": ", GetLaneFrontAmount(GetTeam(), lane, true))

	local tFront = GetLaneFrontAmount(GetTeam(), lane, true)
	local eFront = 1 - GetLaneFrontAmount(GetOpposingTeam(), lane, true)

	if bot:GetHealth() / bot:GetMaxHealth() < 0.3
	then
		return 0.25
	end

    if Defend.WhichLaneToDefend(lane) == lane
    then
        if Defend.ShouldGoDefend(bot, lane)
        then
			local amount = --[[RemapValClamped(tFront, 0, 1, max, 0) *]] eFront * mul[lane]
			return Clamp(amount, 0.1, max)
        end
	end

	return 0.1
end

function Defend.WhichLaneToDefend(lane)

	local mul = Defend.GetEnemyAmountMul(lane)

	local laneAmountEnemyTop = (1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, true))
	local laneAmountEnemyMid = (1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, true))
	local laneAmountEnemyBot = (1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, true))

	local laneAmountTop = GetLaneFrontAmount(GetTeam(), LANE_TOP, true) * laneAmountEnemyTop * mul[LANE_TOP]
    local laneAmountMid = GetLaneFrontAmount(GetTeam(), LANE_MID, true) * laneAmountEnemyMid * mul[LANE_MID]
    local laneAmountBot = GetLaneFrontAmount(GetTeam(), LANE_BOT, true) * laneAmountEnemyBot * mul[LANE_BOT]


    if laneAmountTop < laneAmountBot
    and laneAmountTop < laneAmountMid
    then
        return LANE_TOP
    end

    if laneAmountBot < laneAmountTop
    and laneAmountBot < laneAmountMid
    then
        return LANE_BOT
    end

    if laneAmountMid < laneAmountTop
    and laneAmountMid < laneAmountBot
    then
        return LANE_MID
    end

    return nil
end

function Defend.TeamDefendLane()

    local team = GetTeam()

    if GetTower(team, TOWER_MID_1) ~= nil then
        return LANE_MID
    end
    if GetTower(team, TOWER_BOT_1) ~= nil then
        return LANE_BOT
    end
    if GetTower(team, TOWER_TOP_1) ~= nil then
        return LANE_TOP
    end

    if GetTower(team, TOWER_MID_2) ~= nil then
        return LANE_MID
    end
    if GetTower(team, TOWER_BOT_2) ~= nil then
        return LANE_BOT
    end
    if GetTower(team, TOWER_TOP_2) ~= nil then
        return LANE_TOP
    end

    if GetTower(team, TOWER_MID_3) ~= nil
    or GetBarracks(team, BARRACKS_MID_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_MID_RANGED) ~= nil then
        return LANE_MID
    end

    if GetTower(team, TOWER_BOT_3) ~= nil 
    or GetBarracks(team, BARRACKS_BOT_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_BOT_RANGED) ~= nil then
        return LANE_BOT
    end

    if GetTower(team, TOWER_TOP_3) ~= nil
    or GetBarracks(team, BARRACKS_TOP_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_TOP_RANGED) ~= nil then
        return LANE_TOP
    end

    return LANE_MID
end

function Defend.ShouldGoDefend(bot, lane)
	local Enemies = Defend.GetEnemyCountInLane(lane, true)
	local building, mul = Defend.GetFurthestBuildingOnLane(lane)
	local pos = J.GetPosition(bot)

	if (J.IsModeTurbo() and DotaTime() < 8 * 60)
	or DotaTime() < 12 * 60
	then
		if GetTeam() == TEAM_RADIANT then
			if lane == LANE_TOP
			and (pos == 3 or pos == 4) then
				return true
			elseif lane == LANE_MID
			and pos == 2 then
				return true
			elseif lane == LANE_BOT
			and (pos == 1 or pos == 5) then
				return true
			end
		elseif GetTeam() == TEAM_DIRE then
			if lane == LANE_TOP
			and (pos == 1 or pos == 5) then
				return true
			elseif lane == LANE_MID
			and pos == 2 then
				return true
			elseif lane == LANE_BOT
			and (pos == 3 or pos == 4) then
				return true
			end
		end

		return false
	end

	if Enemies == 1 then
		if pos == 2
        or pos == 4
        then
			return true
		end
	elseif Enemies == 2 then
		if pos == 2
        or pos == 3
        or pos == 5
        then
			return true
		end
	elseif Enemies == 3 then
		if pos == 2
        or pos == 3
        or pos == 4
        or pos == 5
        then
			return true
		end
	end

	if Enemies == 0
	and J.IsCore(bot)
	and bot:GetActiveMode() == BOT_MODE_FARM
	then
		return false
	end

    return true
end

function Defend.GetFurthestBuildingOnLane(lane)
	local bot = GetBot()
	local FurthestBuilding = nil

	if lane == LANE_TOP then
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_TOP_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_TOP_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_TOP_3)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_TOP_MELEE)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_TOP_RANGED)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
		
		FurthestBuilding = GetAncient(bot:GetTeam())
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
	end
	
	if lane == LANE_MID then
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_MID_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_MID_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_MID_3)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_MID_MELEE)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_MID_RANGED)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
		
		FurthestBuilding = GetAncient(bot:GetTeam())
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
	end
	
	if lane == LANE_BOT then
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BOT_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BOT_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BOT_3)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_BOT_MELEE)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_BOT_RANGED)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
		
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
		
		FurthestBuilding = GetAncient(bot:GetTeam())
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 1
		end
	end
	
	return nil, 1
end

function Defend.IsValidBuildingTarget(unit)
	return unit ~= nil 
	and unit:IsAlive() 
	and unit:IsBuilding()
	and unit:CanBeSeen()
end

function Defend.GetEnemyAmountMul(lane)
	local Enemies = Defend.GetEnemyCountInLane(lane, true)
	local _, urgent = Defend.GetFurthestBuildingOnLane(lane)

	local mulTop = 1
	local mulMid = 1
	local mulBot = 1

	if lane == LANE_TOP then
		if Enemies == 1 then
			mulTop = 1.1
		elseif Enemies == 2 then
			mulTop = 1.2
		elseif Enemies == 3 then
			mulTop = 1.3
		elseif Enemies > 3 then
			mulTop = 1.5
		end
		mulTop = mulTop * urgent
	elseif lane == LANE_MID then
		if Enemies == 1 then
			mulMid = 1.1
		elseif Enemies == 2 then
			mulMid = 1.2
		elseif Enemies == 3 then
			mulMid = 1.3
		elseif Enemies > 3 then
			mulMid = 1.5
		end
		mulMid = mulMid * urgent
	elseif lane == LANE_BOT then
		if Enemies == 1 then
			mulBot = 1.1
		elseif Enemies == 2 then
			mulBot = 1.2
		elseif Enemies == 3 then
			mulBot = 1.3
		elseif Enemies > 3 then
			mulBot = 1.5
		end
		mulBot = mulBot * urgent
	end

	return {mulTop, mulMid, mulBot}
end

function Defend.GetEnemyCountInLane(lane, isHero)
	local units = {}
	local building = Defend.GetFurthestBuildingOnLane(lane)
	local unitList = nil

	if isHero
	then
		unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	else
		unitList = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
	end

	for _, enemy in pairs(unitList) do
		local distance = GetUnitToUnitDistance(building, enemy)
		local lanefrontloc = GetLaneFrontLocation(GetTeam(), lane, 0)

		if distance <= 1600
		and GetUnitToLocationDistance(building, lanefrontloc) <= 1600
		then
			table.insert(units, enemy)
		end
	end

	return #units
end

function Defend.DefendThink(bot, lane)

    if bot:IsChanneling() or bot:IsUsingAbility() then
        return
    end

	if Defend.ShouldGoDefend(bot, lane)
    then
		-- if J.HasItem(bot, "item_tpscroll") then
		-- 	print("BOT TRYING TO TP DO DEFEND")
		-- 	bot:Action_UseAbilityOnLocation( "item_tpscroll", GetLaneFrontLocation(GetTeam(), lane, -100))
		-- else
		-- 	print("BOT TRYING DEFEND")
		-- 	bot:ActionPush_MoveToLocation(GetLaneFrontLocation(GetTeam(), lane, 0))
		-- end

		local enemies = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
		if enemies ~= nil and #enemies > 0
		and J.WeAreStronger(bot, 1600)
		then
			return bot:ActionPush_AttackUnit(enemies[1], false)
		end

		local creeps = bot:GetNearbyLaneCreeps(1600, true);
		if creeps ~= nil and #creeps > 0 then
			return bot:ActionPush_AttackUnit(creeps[1], false)
		end
    end
end

return Defend