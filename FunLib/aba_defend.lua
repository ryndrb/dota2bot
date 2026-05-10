local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local Defend = {}
local pingTimeDelta = 5

local nTeam = GetTeam()
local hTowerTable = {
	[LANE_TOP] = {
		[1] = GetTower(nTeam, TOWER_TOP_1),
		[2] = GetTower(nTeam, TOWER_TOP_2),
		[3] = GetTower(nTeam, TOWER_TOP_3),
	},
	[LANE_MID] = {
		[1] = GetTower(nTeam, TOWER_MID_1),
		[2] = GetTower(nTeam, TOWER_MID_2),
		[3] = GetTower(nTeam, TOWER_MID_3),
	},
	[LANE_BOT] = {
		[1] = GetTower(nTeam, TOWER_BOT_1),
		[2] = GetTower(nTeam, TOWER_BOT_2),
		[3] = GetTower(nTeam, TOWER_BOT_3),
	},
}

function Defend.GetDefendDesire(bot, lane)
	local hTeamAncient = GetAncient(GetTeam())
	local nUnitCount__Total, nUnitCount__Hero, nUnit__Creep = Defend.GetEnemiesAroundLocation(hTeamAncient:GetLocation(), 1800)
	local botPosition = J.GetPosition(bot)
	local botActiveMode = bot:GetActiveMode()
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1400)
	local bMyLane = bot:GetAssignedLane() == lane
	local bIsCore = J.IsCore(bot)
	local aAliveCount = J.GetNumOfAliveHeroes(false)

	if (not bMyLane and (botPosition == 1 or botPosition == 3) and J.IsEarlyGame()) -- reduce feeds
	or (J.IsDoingRoshan(bot) and #J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 2800) >= 3)
	or (J.IsDoingTormentor(bot) and ((#J.GetAlliesNearLoc(J.GetTormentorLocation(GetTeam()), 1600) >= 2) or #J.GetAlliesNearLoc(J.GetTormentorWaitingLocation(GetTeam()), 2500) >= 2) and nUnitCount__Total == 0)
	or (J.IsGoingToRune(bot))
	then
		return BOT_MODE_DESIRE_NONE
	end

	local botLevel = bot:GetLevel()

	if not bMyLane then
		if botPosition == 1 and botLevel < 8
		or botPosition == 2 and botLevel < 6
		or botPosition == 3 and botLevel < 7
		or botPosition == 4 and botLevel < 4
		or botPosition == 5 and botLevel < 5
		then
			return BOT_MODE_DESIRE_NONE
		end
	end

	-- finish camps
	if J.IsFarming(bot) and (J.IsCore(bot) or bot:GetNetWorth() >= 15500) then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(Min(bot:GetAttackRange() + 200, 1600))
		if #nNeutralCreeps > 0 then
			return BOT_MODE_DESIRE_NONE
		end
	end

	local human, humanPing = J.GetHumanPing()
	if human ~= nil and humanPing ~= nil and not humanPing.normal_ping and DotaTime() > 0 then
		local isPinged, pingedLane = J.IsPingCloseToValidTower(GetTeam(), humanPing, 700, 5.0)
		if isPinged and lane == pingedLane and GameTime() < humanPing.time + pingTimeDelta then
			return BOT_MODE_DESIRE_VERYHIGH
		end
	end

	local furthestBuilding = Defend.GetFurthestBuildingOnLane(nTeam, lane)
	if furthestBuilding == nil then return 0 end

	if  lane == LANE_MID
	and nUnitCount__Total >= 2
	and (  furthestBuilding == hTeamAncient
		or furthestBuilding == GetTower(nTeam, TOWER_BASE_1)
		or furthestBuilding == GetTower(nTeam, TOWER_BASE_2))
	then
		return BOT_MODE_DESIRE_VERYHIGH
	end

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1400)

	if J.IsPushing(bot) and #nInRangeAlly >= #nInRangeEnemy then
		local pushingLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then pushingLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then pushingLane = LANE_BOT end
		local furthestBuildingEnemy = Defend.GetFurthestBuildingOnLane(GetOpposingTeam(), pushingLane)
		if furthestBuildingEnemy and GetUnitToUnitDistance(bot, furthestBuildingEnemy) < 1600 then
			local nPushingNearbyAllies = 0
			for _, allyHero in pairs(nInRangeAlly) do
				if J.IsValidHero(allyHero) then
					if bot:GetActiveMode() == allyHero:GetActiveMode() then
						nPushingNearbyAllies = nPushingNearbyAllies + 1
					end

					if nPushingNearbyAllies >= 3 then
						return BOT_MODE_DESIRE_NONE
					end
				end
			end
		end
	end

	local nDesire = RemapValClamped(GetDefendLaneDesire(lane), 0, 1, 0, BOT_MODE_DESIRE_ABSOLUTE)
	local hTier1Tower = hTowerTable[lane][1]
	local hTier2Tower = hTowerTable[lane][2]
	local hTier3Tower = hTowerTable[lane][3]
	local bDefendingOtherLane = IsDefendingOtherLane(bot, lane)

	local nDistanceFromBuilding = GetUnitToUnitDistance(bot, furthestBuilding)
	local fWalkTimeToLaneFront = nDistanceFromBuilding / Max(1, bot:GetCurrentMovementSpeed())
	nUnitCount__Total, nUnitCount__Hero, nUnit__Creep = Defend.GetEnemiesAroundLocation(furthestBuilding:GetLocation(), 1600)

	if J.IsTier1(furthestBuilding, GetTeam()) or J.IsTier2(furthestBuilding, GetTeam()) then
		if aAliveCount < nUnitCount__Hero then
			return BOT_MODE_DESIRE_NONE
		end
	end

	local bCanGetThereFast = false
	local hItem = bot:GetItemInSlot(15)
	if J.CanCastAbility(hItem) then bCanGetThereFast = true end

	local hAbility = bot:GetAbilityByName('tinker_keen_teleport')
	if J.CanCastAbility(hAbility) then bCanGetThereFast = true end

	if fWalkTimeToLaneFront <= 11 then bCanGetThereFast = true end

	hAbility = bot:GetAbilityByName('furion_teleportation')
	if J.CanCastAbility(hAbility) then bCanGetThereFast = true end

	local fMultiplier = 0
	if J.IsValidBuilding(hTier1Tower) then
		if (J.GetHP(hTier1Tower) < 0.25 and nUnitCount__Hero > 0)
		or (not bCanGetThereFast)
		then
			fMultiplier = 0
		else
			if Defend.ShouldDefend(bot, furthestBuilding, 1600) and not bDefendingOtherLane then
				fMultiplier = 1
			end
		end
	elseif J.IsValidBuilding(hTier2Tower) then
		if (J.GetHP(hTier2Tower) < 0.25 and nUnitCount__Hero > 0)
		or (not bCanGetThereFast)
		then
			fMultiplier = 0
		else
			if Defend.ShouldDefend(bot, furthestBuilding, 1600) and not bDefendingOtherLane then
				fMultiplier = 3
			end
		end
	else
		if J.IsValidBuilding(hTier3Tower) then
			if (nUnitCount__Hero == 0 and not bDefendingOtherLane and (not bIsCore or fWalkTimeToLaneFront <= 11))
			or (nUnitCount__Hero  > 0)
			then
				fMultiplier = 5
			end
		else
			fMultiplier = 5
		end
	end

	nDesire = nDesire * fMultiplier

	local _, closestLane = J.GetClosestTeamLane(bot)
	if closestLane == lane and nDesire < BOT_MODE_DESIRE_MODERATE then
		nDesire = Max(BOT_MODE_DESIRE_VERYLOW, nDesire)
	end

	return Clamp(nDesire, 0, BOT_MODE_DESIRE_VERYHIGH)
end

-- valve tinkered the default with 7.41
local fNextMovementTime = 0
function Defend.DefendThink(bot, nLane)
    if J.CanNotUseAction(bot) then return end

	local botAttackRange = bot:GetAttackRange()

	local furthestBuilding = Defend.GetFurthestBuildingOnLane(GetTeam(), nLane)
	if furthestBuilding == nil then return end

	local hAncient = GetAncient(GetTeam())
	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1500)
	local nInRangeEnemy = J.GetEnemiesNearLoc(furthestBuilding:GetLocation(), 1500)

	local countNearbyAlly, countNearbyEnemy = 0, 0
    for _, ally in pairs(nInRangeAlly) do
        if J.IsValidHero(ally) then countNearbyAlly = countNearbyAlly + ((J.IsCore(ally) and 1) or 0.5) end
    end

    for _, enemy in pairs(nInRangeEnemy) do
		if J.IsValidHero(enemy) then countNearbyEnemy = countNearbyEnemy + ((J.IsCore(enemy) and 1) or 0.5) end
    end

	if #nInRangeEnemy > 0 then
		if (countNearbyAlly >= countNearbyEnemy)
		or (furthestBuilding == hAncient and J.CanBeAttacked(hAncient) and J.GetHP(hAncient) < 0.7) -- just go
		then
			local target = nil
			local targetScore = math.huge
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero) then
					local enemyHeroScore = GetUnitToLocationDistance(enemyHero, J.GetTeamFountain())
					if enemyHeroScore < targetScore then
						target = enemyHero
						targetScore = enemyHeroScore
					end
				end
			end

			if target then
				bot:Action_AttackUnit(target, false)
				return
			end
		end
	end

	local nFurthestEnemyAttackRange = 0
	nInRangeEnemy = J.GetEnemiesNearLoc(furthestBuilding:GetLocation(), 2200)
	if #nInRangeEnemy > 0 then
		local target = furthestBuilding
		for _, enemyHero in pairs(nInRangeEnemy) do
			if J.IsValidHero(enemyHero) and not enemyHero:HasModifier('modifier_teleporting') then
				local enemyHeroAttackRange = enemyHero:GetAttackRange()
				if J.HasItem(enemyHero, 'item_blink')
				or J.HasItem(enemyHero, 'item_overwhelming_blink')
				or J.HasItem(enemyHero, 'item_swift_blink')
				or J.HasItem(enemyHero, 'item_arcane_blink')
				or J.HasItem(enemyHero, 'item_fallen_sky')
				then
					enemyHeroAttackRange = Max(enemyHeroAttackRange, 1200)
				end

				if enemyHeroAttackRange > nFurthestEnemyAttackRange then
					nFurthestEnemyAttackRange = enemyHeroAttackRange
				end

				local enemyHeroDistance = GetUnitToLocationDistance(enemyHero, J.GetTeamFountain())
				if enemyHeroDistance < GetUnitToLocationDistance(furthestBuilding, J.GetTeamFountain()) then
					target = enemyHero
				end
			end
		end

		if nFurthestEnemyAttackRange > 0 and target then
			local vLocation = J.VectorTowards(target:GetLocation(), J.GetTeamFountain(), nFurthestEnemyAttackRange + 150)
			local dist = GetUnitToLocationDistance(bot, vLocation)

			-- TODO: divert

			if dist < 350 then
				if Defend.Attack(bot, vLocation, botAttackRange + 150) then return end
			end

			if DotaTime() >= fNextMovementTime then
				bot:Action_MoveToLocation(vLocation + RandomVector(100))
				fNextMovementTime = DotaTime() + RandomFloat(0.3, 0.9)
			end

			return
		end
	end

	local nRadius = 1200
	if not J.IsValidBuilding(hTowerTable[nLane][1]) and not J.IsValidBuilding(hTowerTable[nLane][2]) then
		nRadius = 2400
	end

	local offset = (nFurthestEnemyAttackRange > 0 and (nFurthestEnemyAttackRange + 100)) or Max(150, botAttackRange / 2)
	local vLocation = J.VectorTowards(furthestBuilding:GetLocation(), J.GetTeamFountain(), offset)

	local vLaneFrontLocation_Enemy = GetLaneFrontLocation(GetOpposingTeam(), nLane, 0)
	if GetUnitToLocationDistance(furthestBuilding, vLaneFrontLocation_Enemy) <= 3200 then
		local nLocationAoE = bot:FindAoELocation(true, false, vLaneFrontLocation_Enemy, 0, 900, 0, 0)
		if nLocationAoE.count >= 2 and not J.IsEnemyHeroAroundLocation(vLaneFrontLocation_Enemy, 1200, 3.0) then
			vLocation = vLaneFrontLocation_Enemy
		end
	end

	if Defend.Attack(bot, vLocation, nRadius) then return end

	-- temporarily try a different loc if there's an enemy in between me and vLocation
	-- to avoid feeding
	local vBuildingLocation = furthestBuilding:GetLocation()
	nInRangeEnemy = J.GetEnemiesNearLoc(vBuildingLocation, 1600)
	if #nInRangeEnemy > 0 then
		if Defend.IsEnemiesBlockingPath(bot:GetLocation(), vLocation, nInRangeEnemy, 800) then
			vLocation = Defend.GetDivertLocation(bot, vLocation, 1200)
		end
	end

	if DotaTime() >= fNextMovementTime then
		bot:Action_MoveToLocation(vLocation + RandomVector(100))
		fNextMovementTime = DotaTime() + RandomFloat(0.3, 0.9)
		return
	end
end

function Defend.Attack(bot, vAnchorPoint, nRadius)
	local nUnitList = GetUnitList(UNIT_LIST_ENEMIES)
	local target = { creep = nil, creepScore = 0, hero = nil, heroScore = 0 }
	for _, unit in pairs(nUnitList) do
		if  J.IsValid(unit)
		and J.CanBeAttacked(unit)
		and not J.IsRoshan(unit)
		and not J.IsTormentor(unit)
		then
			if GetUnitToLocationDistance(unit, vAnchorPoint) <= nRadius then
				local sUnitName = unit:GetUnitName()
				if unit:IsCreep() then
					if string.find(sUnitName, 'siege')
					or string.find(sUnitName, 'shadow_shaman_ward')
					or string.find(sUnitName, 'warlock_golem')
					then
						bot:Action_AttackUnit(unit, false)
						return true
					end

					local unitScore = (unit:GetAttackDamage() / unit:GetSecondsPerAttack()) * (1 - J.GetHP(unit))
					if J.IsValidBuilding(unit:GetAttackTarget()) then
						unitScore = unitScore * 2
					end

					if unitScore > target.creepScore then
						target.creep = unit
						target.creepScore = unitScore
					end
				end

				if J.IsValidHero(unit) and J.IsInRange(bot, unit, bot:GetAttackRange() + 300) then
					local unitScore = unit:GetActualIncomingDamage(5000, DAMAGE_TYPE_PHYSICAL) / unit:GetHealth()
					if unitScore > target.heroScore then
						target.hero = unit
						target.heroScore = unitScore
					end
				end
			end
		end
	end

	if target.hero then
		bot:Action_AttackUnit(target.hero, false)
		return true
	end

	if target.creep then
		bot:Action_AttackUnit(target.creep, false)
		return true
	end

	return false
end

function Defend.ShouldDefend(bot, hBuilding, nRadius)
	local nEnemyHeroNearbyCount = 0
	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if dInfo ~= nil then
					if GetUnitToLocationDistance(hBuilding, dInfo.location) <= 1600
					and dInfo.time_since_seen <= 5.0
					then
						nEnemyHeroNearbyCount = nEnemyHeroNearbyCount + 1
					end
				end
			end
		end
	end

	local nEnemyCreepNearbyCount = 0
	local unitList = GetUnitList(UNIT_LIST_ENEMIES)
	for _, unit in pairs(unitList) do
		if J.IsValid(unit) and GetUnitToUnitDistance(hBuilding, unit) <= nRadius and not unit:HasModifier('modifier_teleporting') then
			local sUnitName = unit:GetUnitName()
			if string.find(sUnitName, 'siege') and not string.find(sUnitName, 'upgraded')
			then
				nEnemyCreepNearbyCount = nEnemyCreepNearbyCount + 0.5
			elseif string.find(sUnitName, 'upgraded_mega')
			then
				nEnemyCreepNearbyCount = nEnemyCreepNearbyCount + 0.6
			elseif string.find(sUnitName, 'upgraded')
			then
				nEnemyCreepNearbyCount = nEnemyCreepNearbyCount + 0.4
			elseif string.find(sUnitName, 'warlock_golem')
				or string.find(sUnitName, 'shadow_shaman_ward') and unit:GetAttackDamage() >= 500
			then
				nEnemyCreepNearbyCount = nEnemyCreepNearbyCount + 1
			elseif string.find(sUnitName, 'lone_druid_bear')
			then
				nEnemyHeroNearbyCount = nEnemyHeroNearbyCount + 1
			elseif unit:IsCreep()
				or unit:IsAncientCreep()
				or unit:IsDominated()
				or unit:HasModifier('modifier_chen_holy_persuasion')
				or unit:HasModifier('modifier_dominated')
			then
				nEnemyCreepNearbyCount = nEnemyCreepNearbyCount + 0.2
			end
		end
	end

	nEnemyHeroNearbyCount = nEnemyHeroNearbyCount
	nEnemyCreepNearbyCount = nEnemyCreepNearbyCount

	local botPosition = J.GetPosition(bot)
	local nEnemyNearbyCount = nEnemyHeroNearbyCount + nEnemyCreepNearbyCount

	if nEnemyNearbyCount >= 4 then
		return true
	elseif nEnemyNearbyCount >= 3 then
		if (botPosition == 2)
		or (botPosition == 3)
		or (botPosition == 4)
		or (botPosition == 5)
		or (botPosition == 1 and GetUnitToUnitDistance(bot, hBuilding) <= 3200)
		then
			return true
		end
	elseif nEnemyNearbyCount >= 2 then
		if (botPosition == 2)
		or (botPosition == 3)
		or (botPosition == Defend.GetClosestAlly({4, 5}, hBuilding:GetLocation()))
		or (botPosition == 1 and GetUnitToUnitDistance(bot, hBuilding) <= 3200)
		then
			return true
		end
	elseif nEnemyNearbyCount >= 1 then
		if (botPosition == 2)
		or (botPosition == Defend.GetClosestAlly({4, 5}, hBuilding:GetLocation()))
		then
			return true
		end
	end

	if botPosition == Defend.GetClosestAlly({2,3}, hBuilding:GetLocation()) then
		return true
	end

	return false
end

function Defend.GetFurthestBuildingOnLane(team, lane)
	local botTeam = team
	local FurthestBuilding = nil

	if lane == LANE_TOP then
		FurthestBuilding = GetTower(botTeam, TOWER_TOP_1)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 0.5, 1)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(botTeam, TOWER_TOP_2)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(botTeam, TOWER_TOP_3)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetBarracks(botTeam, BARRACKS_TOP_MELEE)
		if J.IsValidBuilding(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetBarracks(botTeam, BARRACKS_TOP_RANGED)
		if J.IsValidBuilding(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetAncient(botTeam)
		if J.IsValidBuilding(FurthestBuilding) then
			return GetAncient(botTeam), 3
		end
	end

	if lane == LANE_MID then
		FurthestBuilding = GetTower(botTeam, TOWER_MID_1)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 0.5, 1)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(botTeam, TOWER_MID_2)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(botTeam, TOWER_MID_3)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetBarracks(botTeam, BARRACKS_MID_MELEE)
		if J.IsValidBuilding(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetBarracks(botTeam, BARRACKS_MID_RANGED)
		if J.IsValidBuilding(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetTower(botTeam, TOWER_BASE_1)
		if J.IsValidBuilding(FurthestBuilding) then
			return GetAncient(botTeam), 2.5
		end

		FurthestBuilding = GetTower(botTeam, TOWER_BASE_2)
		if J.IsValidBuilding(FurthestBuilding) then
			return GetAncient(botTeam), 2.5
		end

		FurthestBuilding = GetAncient(botTeam)
		if J.IsValidBuilding(FurthestBuilding) then
			return GetAncient(botTeam), 3
		end
	end

	if lane == LANE_BOT then
		FurthestBuilding = GetTower(botTeam, TOWER_BOT_1)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 0.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(botTeam, TOWER_BOT_2)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetTower(botTeam, TOWER_BOT_3)
		if J.IsValidBuilding(FurthestBuilding)
		then
			local nHealth = FurthestBuilding:GetHealth() / FurthestBuilding:GetMaxHealth()
			local mul = RemapValClamped(nHealth, 0.25, 1, 1.5, 2)
			return FurthestBuilding, mul
		end

		FurthestBuilding = GetBarracks(botTeam, BARRACKS_BOT_MELEE)
		if J.IsValidBuilding(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetBarracks(botTeam, BARRACKS_BOT_RANGED)
		if J.IsValidBuilding(FurthestBuilding) then
			return FurthestBuilding, 2.5
		end

		FurthestBuilding = GetAncient(botTeam)
		if J.IsValidBuilding(FurthestBuilding) then
			return GetAncient(botTeam), 3
		end
	end

	return nil, 1
end

local nBuildings = {
    TOWER_BASE_1, TOWER_BASE_2,
    BARRACKS_TOP_MELEE, BARRACKS_TOP_RANGED,
    BARRACKS_MID_MELEE, BARRACKS_MID_RANGED,
    BARRACKS_BOT_MELEE, BARRACKS_BOT_RANGED,
    TOWER_TOP_3, TOWER_MID_3, TOWER_BOT_3,
    TOWER_TOP_2, TOWER_MID_2, TOWER_BOT_2,
    TOWER_TOP_1, TOWER_MID_1, TOWER_BOT_1,
}
local function GetFurthestTeamBuildings(team)
    local buildings = { GetAncient(team) }
    for _, id in ipairs(nBuildings) do table.insert(buildings, GetTower(team, id)) end
    return buildings
end

function Defend.GetDivertLocation(bot, vLocation, nRadius)
	local buildings = GetFurthestTeamBuildings(nTeam)
	local botLocation = bot:GetLocation()
	local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1600)

	local bestBuilding = nil
	local bestBuildingDistance = 99999
    for _, building in ipairs(buildings) do
        if building and building:IsAlive() then
			local vBuildingLocation = building:GetLocation()
			local nearbyEnemies = J.GetEnemiesNearLoc(vBuildingLocation, 1200)
			-- if not likely under threat or blocked
			if #nearbyEnemies == 0 and not Defend.IsEnemiesBlockingPath(botLocation, vBuildingLocation, nInRangeEnemy, nRadius) then
				local buildingDistance = J.GetDistance(botLocation, vBuildingLocation)
				if buildingDistance < bestBuildingDistance then
					bestBuilding = building
					bestBuildingDistance = buildingDistance
				end
			end
        end
    end
	return bestBuilding and bestBuilding:GetLocation() or vLocation
end

function Defend.IsEnemiesBlockingPath(botLocation, vDestination, hUnitList, nBlockRadius)
    for _, enemyHero in ipairs(hUnitList) do
		if J.IsValidHero(enemyHero) then
			local tResult = PointToLineDistance(botLocation, vDestination, enemyHero:GetLocation())
			if tResult and tResult.within and tResult.distance <= nBlockRadius then
				return true
			end
		end
    end
    return false
end

function Defend.IsOnlyCreepsAroundBuilding(hBuilding, nRadius)
	local creepCount = 0
	local heroCount = 0

	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if dInfo ~= nil
				and J.GetDistance(hBuilding:GetLocation(), dInfo.location) <= nRadius
				and dInfo.time_since_seen < 3.0
				then
					heroCount = heroCount + 1
				end
			end
		end
	end

	for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES))
	do
		if J.IsValid(unit)
		and GetUnitToUnitDistance(hBuilding, unit) <= nRadius
		then
			if unit:IsCreep()
			or unit:IsAncientCreep()
			or unit:HasModifier('modifier_chen_holy_persuasion')
			or unit:HasModifier('modifier_dominated')
			then
				creepCount = creepCount + 1
			end

			if string.find(unit:GetUnitName(), 'warlock_golem')
			or string.find(unit:GetUnitName(), 'lone_druid_bear') then
				heroCount = heroCount + 1
			end
		end
	end

	return creepCount > 0 and heroCount == 0
end

function Defend.GetEnemiesAroundLocation(vLocation, nRadius)
	local nUnitCount = 0
	local nHeroCount = 0
	local nCreepCount = 0

	for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
		if J.IsValid(unit) and GetUnitToLocationDistance(unit, vLocation) <= nRadius and not unit:HasModifier('modifier_teleporting') then
			local sUnitName = unit:GetUnitName()

			if J.IsValidHero(unit) and not J.IsSuspiciousIllusion(unit) then
				nHeroCount = nHeroCount + 1
				if not J.IsCore(unit) then
					nUnitCount = nUnitCount + 0.5
				else
					nUnitCount = nUnitCount + 1
				end
			elseif string.find(sUnitName, 'siege') and not string.find(sUnitName, 'upgraded') then
				nUnitCount = nUnitCount + 0.3
				nCreepCount = nCreepCount + 0.3
			elseif string.find(sUnitName, 'upgraded_mega') then
				nUnitCount = nUnitCount + 0.4
				nCreepCount = nCreepCount + 0.4
			elseif string.find(sUnitName, 'warlock_golem')
				or string.find(sUnitName, 'shadow_shaman_ward') and unit:GetAttackDamage() >= 500
			then
				nUnitCount = nUnitCount + 1
				nCreepCount = nCreepCount + 1
			elseif string.find(sUnitName, 'lone_druid_bear') then
				nHeroCount = nHeroCount + 1
				nUnitCount = nUnitCount + 1
			elseif unit:IsCreep()
				or unit:IsAncientCreep()
				or unit:IsDominated()
				or unit:HasModifier('modifier_chen_holy_persuasion')
				or unit:HasModifier('modifier_dominated')
			then
				nUnitCount = nUnitCount + 0.2
				nCreepCount = nCreepCount + 0.2
			end
		end
	end

	return nUnitCount, nHeroCount, nCreepCount
end

function Defend.IsImportantBuilding(hBuilding)
	if hBuilding == GetTower(GetTeam(), TOWER_TOP_1)
	or hBuilding == GetTower(GetTeam(), TOWER_MID_1)
	or hBuilding == GetTower(GetTeam(), TOWER_BOT_1)
	or hBuilding == GetTower(GetTeam(), TOWER_TOP_2)
	or hBuilding == GetTower(GetTeam(), TOWER_MID_2)
	or hBuilding == GetTower(GetTeam(), TOWER_BOT_2)
	then
		return false
	end

	return true
end

function Defend.GetClosestAlly(tPosList, vLocation)
	local pos = nil
	local allyDistance = math.huge
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if J.IsValidHero(member) then
			local memberPosition = J.GetPosition(member)
			for j = 1, #tPosList do
				if memberPosition == tPosList[j] then
					local memberDistance = GetUnitToLocationDistance(member, vLocation)
					if memberDistance < allyDistance then
						pos = memberPosition
						allyDistance = memberDistance
					end
				end
			end
		end
	end

	return pos or tPosList[1]
end

function IsDefendingOtherLane(hUnit, nLane)
	if nLane == LANE_TOP then
		if hUnit:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
		or hUnit:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT
		then
			return true
		end
	elseif nLane == LANE_MID then
		if hUnit:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
		or hUnit:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT
		then
			return true
		end
	elseif nLane == LANE_BOT then
		if hUnit:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
		or hUnit:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
		then
			return true
		end
	end

	return false
end

return Defend