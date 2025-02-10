local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local clearMode = false
local botName = bot:GetUnitName()

if bot.isInLanePhase == nil then bot.isInLanePhase = false end
function GetDesire()

	local currentTime = DotaTime()
	local botLV = bot:GetLevel()

	if currentTime < 0 then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsNonStableHero(botName) then
		if clearMode then
			clearMode = false
			return 0
		end

		-- last hit
		if J.IsInLaningPhase() then
			local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(bot:GetAttackRange() + 150, true)
			local hitCreep = GetBestLastHitCreep(nEnemyLaneCreeps)
			if J.IsValid(hitCreep) then
				local nLanePartner = J.GetLanePartner(bot)
				if nLanePartner == nil
				or J.IsCore(bot)
				or (not J.IsCore(bot)
					and J.IsCore(nLanePartner)
					and (not nLanePartner:IsAlive()
						or not J.IsInRange(bot, nLanePartner, 800)))
				then
					return 0.9
				end
			end
		end
	end

	if  currentTime <= 9 * 60
	and botLV <= 7
	then
		bot.isInLanePhase = true
		return 0.444
	end

	bot.isInLanePhase = false

	if  currentTime <= 12 * 60
	and botLV <= 11
	then
		if botLV <= 7 then bot.isInLanePhase = true end
		return 0.333
	end

	if botLV <= 17
	then
		return 0.222
	end

	return BOT_MODE_DESIRE_LOW
end

if J.IsNonStableHero(botName)
then

function GetBestLastHitCreep(hCreepList)
	local attackDamage = bot:GetAttackDamage()

	if bot:GetItemSlotType(bot:FindItemSlot("item_quelling_blade")) == ITEM_SLOT_TYPE_MAIN then
		if bot:GetAttackRange() > 310 or bot:GetUnitName() == "npc_dota_hero_templar_assassin" then
			attackDamage = attackDamage + 4
		else
			attackDamage = attackDamage + 8
		end
	end

	for _, creep in pairs(hCreepList) do
		if J.IsValid(creep) and J.CanBeAttacked(creep) then
			local nDelay = J.GetAttackProDelayTime(bot, creep)
			if J.WillKillTarget(creep, attackDamage, DAMAGE_TYPE_PHYSICAL, nDelay) then
				return creep
			end
		end
	end

	return nil
end

function GetBestDenyCreep(hCreepList)
	for _, creep in pairs(hCreepList)
	do
		if J.IsValid(creep)
		and J.GetHP(creep) < 0.49
		and J.CanBeAttacked(creep)
		and creep:GetHealth() <= bot:GetAttackDamage()
		then
			return creep
		end
	end

	return nil
end

function GetHarassTarget(hEnemyList)
	for _, enemyHero in pairs(hEnemyList) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, bot:GetAttackRange() + 150)
		and J.CanBeAttacked(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			return enemyHero
		end
	end

	return nil
end

local fNextMovementTime = 0
function Think()
	if not bot:IsAlive() or J.CanNotUseAction(bot) then
		clearMode = true
		return
	end

	local botAttackRange = bot:GetAttackRange()
	local botAssignedLane = bot:GetAssignedLane()
	local nAllyCreeps = bot:GetNearbyLaneCreeps(1200, false)
	local nEnemyCreeps = bot:GetNearbyLaneCreeps(1200, true)

	local nFurthestEnemyAttackRange = GetFurthestEnemyAttackRange()

	if bot:WasRecentlyDamagedByAnyHero(2.0)
	or bot:WasRecentlyDamagedByTower(2.0)
	or (bot:WasRecentlyDamagedByCreep(2.0) and not (bot:HasModifier('modifier_tower_aura') or bot:HasModifier('modifier_tower_aura_bonus')) and #nAllyCreeps > 0) then
		nFurthestEnemyAttackRange = nFurthestEnemyAttackRange + 450
	end

	local tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)
	local tEnemyTowers = bot:GetNearbyTowers(800, true)

	if bot:WasRecentlyDamagedByTower(1.0) and #tEnemyLaneCreeps > 0 then
		if DropTowerAggro(bot, tEnemyLaneCreeps) then
			return
		end
	elseif bot:WasRecentlyDamagedByTower(1.0) then
		if #tEnemyTowers > 0 then
			local dist = GetUnitToUnitDistance(bot, tEnemyTowers[1])
			if dist < 800 then
				bot:Action_MoveToLocation(J.GetXUnitsTowardsLocation2(bot:GetLocation(), J.GetTeamFountain(), 800 - dist))
				return
			end
		end
	end

	if #tEnemyTowers > 0 then
		local dist = GetUnitToUnitDistance(bot , tEnemyTowers[1])
		if dist < 800 then
			bot:Action_MoveToLocation(J.GetXUnitsTowardsLocation2(bot:GetLocation(), J.GetTeamFountain(), 800 - dist))
			return
		end
	end

	local hitCreep = GetBestLastHitCreep(nEnemyCreeps)
	if J.IsValid(hitCreep) then
		local nLanePartner = J.GetLanePartner(bot)
		if nLanePartner == nil
		or J.IsCore(bot)
		or (not J.IsCore(bot)
			and J.IsCore(nLanePartner)
			and (not nLanePartner:IsAlive()
				or not J.IsInRange(bot, nLanePartner, 800)))
		then
			if GetUnitToUnitDistance(bot, hitCreep) > botAttackRange then
				bot:Action_MoveToUnit(hitCreep)
				return
			else
				bot:Action_AttackUnit(hitCreep, true)
				return
			end
		end
	end

	local denyCreep = GetBestDenyCreep(nAllyCreeps)
	if J.IsValid(denyCreep) then
		bot:Action_AttackUnit(denyCreep, true)
		return
	end

	-- support harass (later ie. willow, hoodwink etc); don't strong creep aggro
	tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)
	local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	if #tEnemyLaneCreeps <= 1 and not J.IsCore(bot) then
		local harassTarget = GetHarassTarget(tEnemyHeroes)
		if J.IsValidHero(harassTarget) then
			bot:Action_AttackUnit(harassTarget, true)
			return
		end
	end

	local fLaneFrontAmount = GetLaneFrontAmount(GetTeam(), botAssignedLane, false)
	local fLaneFrontAmount_enemy = GetLaneFrontAmount(GetOpposingTeam(), botAssignedLane, false)
	if nFurthestEnemyAttackRange == 0 then
		nFurthestEnemyAttackRange = Max(botAttackRange, 330)
	end

	local target_loc = GetLaneFrontLocation(GetTeam(), botAssignedLane, -nFurthestEnemyAttackRange)
	if fLaneFrontAmount_enemy < fLaneFrontAmount then
		target_loc = GetLaneFrontLocation(GetOpposingTeam(), botAssignedLane, -nFurthestEnemyAttackRange)
	end

	if DotaTime() >= fNextMovementTime then
		bot:Action_MoveToLocation(target_loc)
		fNextMovementTime = DotaTime() + math.random(0.05, 0.2)
	end
end

function GetFurthestEnemyAttackRange()
	local attackRange = 0
	local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	for _, enemy in pairs(nInRangeEnemy) do
		if J.IsValidHero(enemy) and not J.IsSuspiciousIllusion(enemy) then
			local enemyAttackRange = enemy:GetAttackRange()
			if enemyAttackRange > attackRange then
				attackRange = enemyAttackRange
			end
		end
	end

	return attackRange
end

function DropTowerAggro(hUnit, nearbyCrepsAlly)
	if J.IsValid(hUnit) then
		local nearbyTowers = hUnit:GetNearbyTowers(750, true)
		if #nearbyCrepsAlly > 0 and #nearbyTowers == 1 then
			for _, creep in pairs(nearbyCrepsAlly) do
				if J.IsValid(creep) and GetUnitToUnitDistance(creep, nearbyTowers[1]) < 700 then
					hUnit:Action_AttackUnit(creep, true)
					return true
				end
			end
		end
	end

	return false
end

end