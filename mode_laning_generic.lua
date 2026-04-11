local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local clearMode = false
local botName = bot:GetUnitName()

if bot.isInLanePhase == nil then bot.isInLanePhase = false end

local botAssignedLane, botAttackRange, botLocation

function GetDesire()

	local currentTime = DotaTime()
	local botActiveMode = bot:GetActiveMode()
	local botActiveModeDesire = bot:GetActiveMode()
	botAssignedLane = bot:GetAssignedLane()
	botAttackRange = bot:GetAttackRange()
	botLocation = bot:GetLocation()

	if currentTime < 0
	or not bot:IsAlive()
	or J.IsGoingToRune(bot)
	or botActiveMode == BOT_MODE_WATCHER
	or botActiveMode == BOT_MODE_WISDOM_SHRINE
	or botActiveMode == BOT_MODE_LOTUS_POOL
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local bCore = J.IsCore(bot)
	local botLevel = bot:GetLevel()
	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

	if (currentTime <= 9 * 60 and botLevel <= 7)
	or (botAssignedLane == LANE_MID and currentTime <= 6 * 60)
	then
		bot.isInLanePhase = true

		if (bCore and ((#nInRangeEnemy == 0 or bot:HasModifier('modifier_tower_aura_bonus')) and not bot:WasRecentlyDamagedByAnyHero(5.0)) and not J.IsRetreating(bot)) then
			return BOT_MODE_DESIRE_VERYHIGH - 0.01
		end

		return BOT_MODE_DESIRE_MODERATE - 0.05
	end

	local nTower = TOWER_TOP_1
	if botAssignedLane == LANE_MID then
		nTower = TOWER_MID_1
	elseif botAssignedLane == LANE_BOT then
		nTower = TOWER_BOT_1
	end

	-- try stay in lane to get the farming item
	if bot.sItemBuyList and not string.find(botName, 'lone_druid') and GetTower(GetTeam(), nTower) ~= nil then
		local bHaveEarlyFarmingItem = false
		local sItemName = ''
		for i = 1, #bot.sItemBuyList do
			if bot.sItemBuyList[i] == 'item_maelstrom'
			or bot.sItemBuyList[i] == 'item_mjollnir'
			or bot.sItemBuyList[i] == 'item_bfury'
			then
				if i <= (#bot.sItemBuyList / 2) then
					sItemName = bot.sItemBuyList[i]
					bHaveEarlyFarmingItem = true
					break
				end
			end
		end

		if  bHaveEarlyFarmingItem
		and (  (sItemName == 'item_maelstrom' and not J.HasItemInInventory(sItemName) and not J.HasItemInInventory('item_mjollnir'))
			or (sItemName == 'item_mjollnir' and not J.HasItemInInventory(sItemName))
			or (sItemName == 'item_bfury' and not J.HasItemInInventory(sItemName))
		)
		then
			bot.isInLanePhase = true
			return BOT_MODE_DESIRE_LOW
		end
	end

	bot.isInLanePhase = false

	if currentTime <= 12 * 60 and botLevel <= 11 then
		return BOT_MODE_DESIRE_MODERATE - 0.15
	end

	return 0
end

if J.IsNonStableHero(botName)
then

local function GetBestLastHitCreep(hCreepList)
	local botAttackDamage = bot:GetAttackDamage()

	if bot:GetItemSlotType(bot:FindItemSlot('item_quelling_blade')) == ITEM_SLOT_TYPE_MAIN then
		if bot:GetAttackRange() > 310 or bot:GetUnitName() == 'npc_dota_hero_templar_assassin' then
			botAttackDamage = botAttackDamage + 4
		else
			botAttackDamage = botAttackDamage + 8
		end
	end

	if botName == 'npc_dota_hero_jakiro' then
		botAttackDamage = botAttackDamage * 2
	end

	local hTarget = nil
	local hTargetScore = 0
	for _, creep in pairs(hCreepList) do
		if J.IsValid(creep) and J.CanBeAttacked(creep) then
			local nDelay = J.GetAttackProDelayTime(bot, creep)
			if J.WillKillTarget(creep, botAttackDamage - 3, DAMAGE_TYPE_PHYSICAL, nDelay) then
				local sCreepName = creep:GetUnitName()
				local creepScore = 0
				if string.find(sCreepName, 'ranged') then
					creepScore = 2
				elseif string.find(sCreepName, 'flagbearer') then
					creepScore = 1
				else
					creepScore = 0.5
				end

				if creepScore > hTargetScore then
					hTarget = creep
					hTargetScore = creepScore
				end
			end
		end
	end

	return hTarget
end

local function GetBestDenyCreep(hCreepList)
	local botAttackDamage = bot:GetAttackDamage()

	if botName == 'npc_dota_hero_jakiro' then
		botAttackDamage = botAttackDamage * 2
	end

	local hTarget = nil
	local hTargetScore = 0
	for _, creep in pairs(hCreepList) do
		if  J.IsValid(creep)
		and J.CanBeAttacked(creep)
		and J.IsInRange(bot, creep, botAttackRange + 150)
		and J.GetHP(creep) < 0.49
		and creep:GetHealth() <= botAttackDamage
		then
			local sCreepName = creep:GetUnitName()
			local creepScore = 0
			if string.find(sCreepName, 'ranged') then
				creepScore = 2
			elseif string.find(sCreepName, 'flagbearer') then
				creepScore = 1
			else
				creepScore = 0.5
			end

			if creepScore > hTargetScore then
				hTarget = creep
				hTargetScore = creepScore
			end
		end
	end

	return hTarget
end

local function GetHarassTarget(hEnemyList)
	for _, enemyHero in pairs(hEnemyList) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, bot:GetAttackRange() + 150)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			return enemyHero
		end
	end

	return nil
end

local function GetCreepInLocation(sCreepName, vLocation, nRadius, bEnemy)
	local nUnitList = (bEnemy and GetUnitList(UNIT_LIST_ENEMY_CREEPS)) or GetUnitList(UNIT_LIST_ALLIED_CREEPS)
	for _, creep in pairs(nUnitList) do
		if  J.IsValid(creep)
		and GetUnitToLocationDistance(creep, vLocation) <= nRadius
		and string.find(creep:GetUnitName(), sCreepName)
		then
			return creep
		end
	end

	return nil
end

local fNextMovementTime = 0
function Think()
	if J.CanNotUseAction(bot) then
		return
	end

	local nAllyCreeps = bot:GetNearbyLaneCreeps(1200, false)
	local nEnemyCreeps = bot:GetNearbyLaneCreeps(1200, true)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyTowers = bot:GetNearbyTowers(1200, true)

	local nInRangeAlly = J.GetAlliesNearLoc(botLocation, 1200)
	local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, 1200)

	local vLaneFrontLocation_Ally = GetLaneFrontLocation(GetTeam(), botAssignedLane, 0)
	local vLaneFrontLocation_Enemy = GetLaneFrontLocation(GetOpposingTeam(), botAssignedLane, 0)

	local nFurthestEnemyAttackRange = GetFurthestAttackRange(nInRangeEnemy)

	DropTowerAggro(bot, nAllyCreeps)

	if J.IsValidBuilding(nEnemyTowers[1]) then
		local distanceFromNearestTower = GetUnitToUnitDistance(bot, nEnemyTowers[1])
		if distanceFromNearestTower < 800 and #nEnemyCreeps < 3 then
			if DotaTime() >= fNextMovementTime then
				bot:Action_MoveToLocation(J.VectorAway(botLocation, nEnemyTowers[1]:GetLocation(), 950) + RandomVector(75))
				fNextMovementTime = DotaTime() + RandomFloat(1, 3)
				return
			end
		end
	end

	local lastHitCreep = GetBestLastHitCreep(nEnemyCreeps)
	if J.IsValid(lastHitCreep) and lastHitCreep then
		local distanceFromCreep = GetUnitToUnitDistance(bot, lastHitCreep)

		if J.IsValidBuilding(nEnemyTowers[1])
		and GetUnitToUnitDistance(nEnemyCreeps[1], nEnemyTowers[1]) < 700
		and GetUnitToLocationDistance(nEnemyCreeps[1], J.GetEnemyFountain()) < GetUnitToLocationDistance(nEnemyTowers[1], J.GetEnemyFountain())
		and GetUnitToUnitDistance(nEnemyCreeps[1], bot) > botAttackRange
		then
			local nLocationAoE_CreepsAlly  = bot:FindAoELocation(false, false, nEnemyTowers[1]:GetLocation(), 0, 650, 0, 0)
			local nLocationAoE_CreepsEnemy = bot:FindAoELocation(true , false, nEnemyTowers[1]:GetLocation(), 0, 650, 0, 0)
			if nLocationAoE_CreepsAlly.count <= 3 and distanceFromCreep > botAttackRange then goto gNoLastHit end
		end

		local hLanePartner = J.GetLanePartner(bot)
		if hLanePartner == nil
		or J.IsCore(bot)
		or (not J.IsCore(bot)
				and J.IsCore(hLanePartner)
				and (not hLanePartner:IsAlive() or GetUnitToLocationDistance(hLanePartner, vLaneFrontLocation_Enemy) > hLanePartner:GetAttackRange() + 400))
		then
			if distanceFromCreep > botAttackRange then
				bot:Action_MoveDirectly(J.VectorTowards(lastHitCreep:GetLocation(), botLocation, botAttackRange - lastHitCreep:GetBoundingRadius()))
				return
			else
				bot:Action_AttackUnit(lastHitCreep, false)
				return
			end
		end

		::gNoLastHit::
	end

	local denyCreep = GetBestDenyCreep(nAllyCreeps)
	if J.IsValid(denyCreep) then
		bot:Action_AttackUnit(denyCreep, true)
		return
	end

	if J.IsValidBuilding(nEnemyTowers[1]) and J.CanBeAttacked(nEnemyTowers[1]) and J.IsValid(nEnemyTowers[1]:GetAttackTarget()) and nEnemyTowers[1]:GetAttackTarget():IsCreep() and #nInRangeAlly >= #nInRangeEnemy then
		local creep = GetCreepInLocation('siege', nEnemyTowers[1]:GetLocation(), 800)
		if J.IsValid(creep) and creep and J.GetHP(creep) >= 0.5 and creep:GetAttackTarget() == nEnemyTowers[1] then
			local nLocationAoE_CreepsAlly  = bot:FindAoELocation(false, false, nEnemyTowers[1]:GetLocation(), 0, 700, 0, 0)
			if nLocationAoE_CreepsAlly.count >= 3 then
				bot:Action_AttackUnit(nEnemyTowers[1], true)
				return
			end
		end
	end

	-- support harass; don't strong creep aggro
	nEnemyCreeps = bot:GetNearbyLaneCreeps(600, true)
	if #nEnemyCreeps <= 1 and not J.IsCore(bot) then
		local harassTarget = GetHarassTarget(nInRangeEnemy)
		if J.IsValidHero(harassTarget) then
			bot:Action_AttackUnit(harassTarget, true)
			return
		end
	end

	nFurthestEnemyAttackRange = Max(botAttackRange * 0.85, nFurthestEnemyAttackRange)
	local vLocation = GetLaneFrontLocation(GetTeam(), botAssignedLane, -nFurthestEnemyAttackRange)

	if J.GetDistance(vLaneFrontLocation_Ally, J.GetTeamFountain()) > J.GetDistance(vLaneFrontLocation_Enemy, J.GetTeamFountain()) then
		vLocation = GetLaneFrontLocation(GetOpposingTeam(), botAssignedLane, -nFurthestEnemyAttackRange)
	end

	if DotaTime() >= fNextMovementTime then
		bot:Action_MoveToLocation(vLocation + RandomVector(100))
		fNextMovementTime = DotaTime() + RandomFloat(0.3, 0.9)
	end
end

function GetFurthestAttackRange(nUnitList)
	local attackRange = 0
	for _, enemy in pairs(nUnitList) do
		if J.IsValidHero(enemy) and not J.IsSuspiciousIllusion(enemy) then
			local enemyAttackRange = enemy:GetAttackRange()
			if enemyAttackRange > attackRange then
				attackRange = enemyAttackRange
			end
		end
	end

	return attackRange
end

function DropTowerAggro(hUnit, nUnitList)
	if J.IsValid(hUnit) then
		local nEnemyTowers = hUnit:GetNearbyTowers(800, true)
		if J.IsValidBuilding(nEnemyTowers[1]) and nEnemyTowers[1]:GetAttackTarget() == hUnit then
			for _, creep in pairs(nUnitList) do
				if J.IsValid(creep) and GetUnitToUnitDistance(creep, nEnemyTowers[1]) < 700 then
					hUnit:Action_AttackUnit(creep, false)
					return
				end
			end

			hUnit:Action_MoveToLocation(J.GetTeamFountain())
			return
		end
	end
end

end