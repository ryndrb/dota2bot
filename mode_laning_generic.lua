local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

if bot.isInLanePhase == nil then bot.isInLanePhase = false end
function GetDesire()

	local currentTime = DotaTime()
	local botLV = bot:GetLevel()
	local networth = bot:GetNetWorth()
	local isBotCore = J.IsCore(bot)
	local isEarlyGame = J.IsModeTurbo() and DotaTime() < 8 * 60 or DotaTime() < 12 * 60

	if currentTime < 0 then
		return BOT_ACTION_DESIRE_NONE
	end

    if  J.IsGoingOnSomeone(bot)
	and J.IsInLaningPhase()
	and bot:GetLevel() < 8
	then
		if bot:WasRecentlyDamagedByTower(1)
		then
			return BOT_MODE_DESIRE_VERYHIGH
		end

		local botTarget = J.GetProperTarget(bot)
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and J.IsChasingTarget(bot, botTarget)
		then
			local nChasingAlly = {}
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
			for _, allyHero in pairs(nInRangeAlly)
			do
				if  J.IsValidHero(allyHero)
				and J.IsChasingTarget(allyHero, botTarget)
				and allyHero ~= bot
				and not J.IsRetreating(allyHero)
				and not J.IsSuspiciousIllusion(allyHero)
				then
					table.insert(nChasingAlly, allyHero)
				end
			end

			table.insert(nChasingAlly, bot)

			-- Consider stop chasing if can't kill and need to CS
			local nHealth = botTarget:GetHealth()
			if botTarget:GetUnitName() == 'npc_dota_hero_medusa'
			then
				nHealth = nHealth + botTarget:GetMana()
			end

			if nHealth > J.GetTotalEstimatedDamageToTarget(nChasingAlly, botTarget)
			then
				local nEnemyTowers = botTarget:GetNearbyTowers(888, true)
				local nEnemyLaneFrontAmount = 1 - GetLaneFrontAmount(GetOpposingTeam(), bot:GetAssignedLane(), true)

				if nEnemyTowers ~= nil and #nEnemyTowers >= 1
				or nEnemyLaneFrontAmount > 0
				then
					return BOT_MODE_DESIRE_VERYHIGH
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

	return BOT_MODE_DESIRE_NONE
end

-- others later since they need to engage, otherwise they feed
-- muerta still sometimes does not engage; not lane related
if bot:GetUnitName() == 'npc_dota_hero_muerta'
then

local function GetBestLastHitCreep(hCreepList)
	for _, creep in pairs(hCreepList)
	do
		if J.IsValid(creep) and J.CanBeAttacked(creep)
		then
			local nAttackDelayTime = J.GetAttackProDelayTime(bot, creep)
			if J.WillKillTarget(creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL, nAttackDelayTime)
			then
				return creep
			end
		end
	end

	return nil
end

local function GetBestDenyCreep(hCreepList)
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

-- local function GetSafePosition(hAllyList, vLaneFront)
-- 	local vSafe = vLaneFront
-- 	for _, allyHero in pairs(hAllyList)
-- 	do
-- 		if J.IsValidHero(allyHero)
-- 		and J.IsInRange(bot, allyHero, 1600)
-- 		and bot:DistanceFromFountain() > allyHero:DistanceFromFountain()
-- 		then
-- 			vSafe = allyHero:GetLocation()
-- 			break
-- 		end
-- 	end

-- 	if J.GetDistance(bot:GetLocation(), vSafe) > 1600
-- 	then
-- 		vSafe = J.GetTeamFountain()
-- 	end

-- 	return vSafe + RandomVector(200)
-- end

local function HarassEnemyHero(hEnemyList)
    for _, enemyHero in pairs(hEnemyList)
    do
        if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
        then
            return enemyHero
        end
    end

    return nil
end

function Think()
	if not bot:IsAlive() or J.CanNotUseAction(bot) then return end

	local LowHealthThreshold = 0.35
	local RetreatThreshold = 0.15

	local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
	local nAllyCreeps = bot:GetNearbyCreeps(800, false)
	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
	local nAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

	if (J.GetHP(bot) < RetreatThreshold and nEnemyHeroes ~= nil and #nEnemyHeroes > 0)
	or (bot:WasRecentlyDamagedByAnyHero(2) and (bot:GetAttackTarget() ~= nil and not (bot:GetAttackTarget()):IsHero()))
	or (J.GetHP(bot) < RetreatThreshold and (bot:WasRecentlyDamagedByCreep(2) or bot:WasRecentlyDamagedByTower(2)))
	then
		bot:Action_MoveToLocation(J.GetTeamFountain() + RandomVector(600))
		return
	end

	local hitCreep = GetBestLastHitCreep(nEnemyCreeps)
	if J.IsValid(hitCreep)
	then
		local nLanePartner = J.GetLanePartner(bot)
		if nLanePartner == nil
		or J.IsCore(bot)
		or (not J.IsCore(bot)
			and J.IsCore(nLanePartner)
			and (not nLanePartner:IsAlive()
				or not J.IsInRange(bot, nLanePartner, 800)))
		then
			bot:Action_AttackUnit(hitCreep, true)
			return
		end
	end

	local denyCreep = GetBestDenyCreep(nAllyCreeps)
	if J.IsValid(denyCreep)
	then
		bot:Action_AttackUnit(denyCreep, true)
		return
	end

	local vLaneFront = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), -(bot:GetAttackRange() - 50))
	local vEnemyLaneFront = GetLaneFrontLocation(GetOpposingTeam(), bot:GetAssignedLane(), -(bot:GetAttackRange() - 50))
	local nEnemyLaneAmount = 1 - GetLaneFrontAmount(GetOpposingTeam(), bot:GetAssignedLane(), true)

	if J.GetDistance(vLaneFront, vEnemyLaneFront) <= 100
	and nEnemyLaneAmount > 0
	then
		vLaneFront = vEnemyLaneFront
	end

	-- print(vLaneFront, vEnemyLaneFront)

	if J.GetHP(bot) > LowHealthThreshold
	then
		nEnemyHeroes = bot:GetNearbyHeroes(bot:GetAttackRange() + 50, true, BOT_MODE_NONE)
		local harassTarget = HarassEnemyHero(nEnemyHeroes)
		if not J.IsCore(bot) and J.IsValidHero(harassTarget)
		then
			bot:Action_AttackUnit(harassTarget, true)
		else
			bot:Action_MoveToLocation(vLaneFront + RandomVector(200))
		end
	else
		vLaneFront = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), -RemapValClamped(J.GetHP(bot), 0, 1, 1200, bot:GetAttackRange()))
		bot:Action_MoveToLocation(vLaneFront)
	end
end

end