local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local Defend = {}
local pingTimeDelta = 5

function Defend.GetDefendDesire(bot, lane)
	if bot.laneToDefend == nil then bot.laneToDefend = lane end

	local nEnemyAroundAncient = J.GetEnemiesAroundAncient()
	local nSearchRange = 2200
	if #nEnemyAroundAncient > 0
	then
		nSearchRange = 880
	end

	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nSearchRange)
	if #nInRangeEnemy > 0 and GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), lane, 0)) < 1200
	or (bot:GetAssignedLane() ~= lane and J.GetPosition(bot) == 1 and DotaTime() < 12 * 60) -- reduce carry feeds
	or (J.IsDoingRoshan(bot) and #J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 2800) >= 3)
	or (J.IsDoingTormentor(bot) and #J.GetAlliesNearLoc(J.GetTormentorLocation(GetTeam()), 900) >= 2 and #nEnemyAroundAncient == 0)
	then
		return BOT_MODE_DESIRE_NONE
	end

	local botLevel = bot:GetLevel()
	if J.GetPosition(bot) == 1 and botLevel < 8
	or J.GetPosition(bot) == 2 and botLevel < 6
	or J.GetPosition(bot) == 3 and botLevel < 7
	or J.GetPosition(bot) == 4 and botLevel < 4
	or J.GetPosition(bot) == 5 and botLevel < 5
	then
		return BOT_MODE_DESIRE_NONE
	end

	local human, humanPing = J.GetHumanPing()
	if human ~= nil and DotaTime() > pingTimeDelta
	then
		local isPinged, pingedLane = J.IsPingCloseToValidTower(GetTeam(), humanPing)
		if isPinged and lane == pingedLane
		and DotaTime() < humanPing.time + pingTimeDelta
		then
			return BOT_MODE_DESIRE_ABSOLUTE * 0.95
		end
	end

	local furthestBuilding = Defend.GetFurthestBuildingOnLane(lane)
	if J.IsValidBuilding(furthestBuilding)
	then
		local isOnlyCreeps = Defend.IsOnlyCreepsAroundBuilding(furthestBuilding)

		if (J.IsTier1(furthestBuilding) and J.GetHP(furthestBuilding) <= 0.2
			or J.IsTier2(furthestBuilding) and J.GetHP(furthestBuilding) <= 0.2)
		and not isOnlyCreeps
		then
			return BOT_MODE_DESIRE_NONE
		end

		if (J.IsTier1(furthestBuilding) or J.IsTier2(furthestBuilding))
		and isOnlyCreeps
		and J.IsCore(bot) and GetUnitToUnitDistance(bot, furthestBuilding) > 2200
		then
			return BOT_MODE_DESIRE_NONE
		end
	end

	local nDefendDesire = 0
	local mul = Defend.GetEnemyAmountMul(lane)

	if  nEnemyAroundAncient ~= nil and #nEnemyAroundAncient >= 1
	and (GetTower(GetTeam(), TOWER_MID_3) == nil
		or (GetTower(GetTeam(), TOWER_TOP_3) == nil
			and GetTower(GetTeam(), TOWER_MID_3) == nil
			and GetTower(GetTeam(), TOWER_BOT_3) == nil))
	and lane == LANE_MID
	then
		return BOT_MODE_DESIRE_ABSOLUTE
	else
		nDefendDesire = Clamp(GetDefendLaneDesire(lane), 0.1, 1) * mul
	end

	bot.laneToDefend = lane
	return Clamp(nDefendDesire, 0, 0.98)
end

function Defend.DefendThink(bot, lane)
    if J.CanNotUseAction(bot) then return end

	local attackRange = bot:GetAttackRange()
	local vDefendLane = GetLaneFrontLocation(GetTeam(), lane, 0)
	local nSearchRange = attackRange < 900 and 900 or math.min(attackRange, 1600)
	local nEnemyAroundAncient = J.GetEnemiesAroundAncient()

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local nInRangeEnemy = bot:GetNearbyHeroes(nSearchRange, true, BOT_MODE_NONE)
	if J.IsValidHero(nInRangeEnemy[1])
	then
		bot:Action_AttackUnit(nInRangeEnemy[1], true)
		return
	end

	local nEnemyLaneCreeps = bot:GetNearbyCreeps(900, true)
	if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps > 0
	then
		local targetCreep = nil
		local attackDMG = 0
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and creep:GetAttackDamage() > attackDMG
			then
				attackDMG = creep:GetAttackDamage()
				targetCreep = creep
			end

			if targetCreep ~= nil
			then
				bot:Action_AttackUnit(creep, true)
				return
			end
		end
	end

	if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
	and J.IsValidHero(nEnemyHeroes[1])
	and (#nEnemyHeroes > #nAllyHeroes or not J.WeAreStronger(bot, 1600))
	then
		bot:Action_MoveToLocation(J.GetXUnitsTowardsLocation2(vDefendLane, nEnemyHeroes[1]:GetLocation(), 1000) + RandomVector(75))
		return
	end

	if #nEnemyAroundAncient > 0
	then
		vDefendLane = GetAncient(GetTeam()):GetLocation()
	end

	bot:Action_MoveToLocation(vDefendLane + J.RandomForwardVector(attackRange))
end

function Defend.GetFurthestBuildingOnLane(lane)
	local bot = GetBot()
	local FurthestBuilding = nil

	if lane == LANE_TOP then
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_TOP_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 0.5, 1)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_TOP_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_TOP_3)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_TOP_MELEE)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_TOP_RANGED)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 2.5
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 2.5
		end

		FurthestBuilding = GetAncient(bot:GetTeam())
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 3
		end
	end

	if lane == LANE_MID then
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_MID_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 0.5, 1)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_MID_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_MID_3)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_MID_MELEE)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_MID_RANGED)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 2.5
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 2.5
		end

		FurthestBuilding = GetAncient(bot:GetTeam())
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 3
		end
	end

	if lane == LANE_BOT then
		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BOT_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 0.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BOT_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BOT_3)
		if Defend.IsValidBuildingTarget(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_BOT_MELEE)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetBarracks(bot:GetTeam(), BARRACKS_BOT_RANGED)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_1)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 2.5
		end

		FurthestBuilding = GetTower(bot:GetTeam(), TOWER_BASE_2)
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 2.5
		end

		FurthestBuilding = GetAncient(bot:GetTeam())
		if Defend.IsValidBuildingTarget(FurthestBuilding) then
			return GetAncient(bot:GetTeam()), 3
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
	local nHeroCount = Defend.GetEnemyCountInLane(lane, true)
	local nCreepCount = Defend.GetEnemyCountInLane(lane, false)
	local _, urgent = Defend.GetFurthestBuildingOnLane(lane)
	return RemapValClamped(nHeroCount, 1, 3, 1, 2) * RemapValClamped(nCreepCount, 1, 5, 1, 1.25) * urgent
end

function Defend.GetEnemyCountInLane(lane, isHero)
	local units = {}
	local laneFrontLoc = GetLaneFrontLocation(GetTeam(), lane, 0)
	local unitList = nil

	if isHero
	then
		unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	else
		unitList = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
	end

	for _, enemy in pairs(unitList)
	do
		if J.IsValid(enemy)
		then
			local distance = GetUnitToLocationDistance(enemy, laneFrontLoc)

			if isHero
			then
				if  distance < 1600
				and not J.IsSuspiciousIllusion(enemy)
				then
					table.insert(units, enemy)
				end
			else
				if distance < 1600
				then
					table.insert(units, enemy)
				end
			end
		end
	end

	return #units
end

function Defend.IsOnlyCreepsAroundBuilding(furthestBuilding)
	local creepCount = 0
	local heroCount = 0
	for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES))
	do
		if J.IsValid(unit)
		and GetUnitToUnitDistance(furthestBuilding, unit) <= 900
		then
			if unit:IsCreep()
			or unit:IsAncientCreep()
			or unit:HasModifier('modifier_chen_holy_persuasion')
			or unit:HasModifier('modifier_dominated')
			then
				creepCount = creepCount + 1
			end

			local isIllusion = J.IsSuspiciousIllusion(unit)

			if unit:IsHero()
			and (not isIllusion
				or isIllusion and unit:HasModifier('modifier_arc_warden_tempest_double')
				or isIllusion and string.find(unit:GetUnitName(), 'chaos_knight')
				or isIllusion and string.find(unit:GetUnitName(), 'naga_siren')
			)
			then
				heroCount = heroCount + 1
			end
		end
	end

	return creepCount > 0 and heroCount == 0
end

return Defend