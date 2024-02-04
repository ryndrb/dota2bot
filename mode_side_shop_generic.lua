-- local bot = GetBot()
-- local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

-- local Tormentor = nil
-- local shardCount = 0

-- local tormentorMessageTime = DotaTime()
-- local humanPingTime = DotaTime()
-- local humanPing = nil

-- local RadiantTormentorLoc = Vector(-8075, -1148, 1000)
-- local DireTormentorLoc = Vector(8132, 1102, 1000)

-- local loc
-- if GetTeam() == TEAM_RADIANT
-- then
-- 	loc = RadiantTormentorLoc
-- else
-- 	loc = DireTormentorLoc
-- end

-- if bot.tormentorState == nil
-- then
-- 	bot.tormentorState = false
-- end

-- if bot.lastKillTime == nil
-- then
-- 	bot.lastKillTime = 0
-- end

-- function GetDesire()
-- 	local aliveAlly = J.GetNumOfAliveHeroes(false)
--     local aliveEnemy = J.GetNumOfAliveHeroes(true)
-- 	local nModeDesire = bot:GetActiveModeDesire()
-- 	local aveDistance, heroCount = GetAveTeamDistance()
--     local healthPercentage = bot:GetHealth() / bot:GetMaxHealth()
-- 	local spawnTime = J.IsModeTurbo() and 10 or 20
-- 	local topFrontP = GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, true)
-- 	local midFrontP = GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, true)
-- 	local botFrontP = GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, true)
-- 	local topFrontD = 1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, true)
-- 	local midFrontD = 1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, true)
-- 	local botFrontD = 1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, true)
-- 	local aveLevel = 0

-- 	if DidSomeoneSeeTormentorAlive()
-- 	then
-- 		bot.tormentorState = true
-- 	end

-- 	for i = 1, 5
-- 	do
-- 		local member = GetTeamMember(i)

-- 		if member ~= nil
-- 		and member.lastKillTime ~= nil
-- 		and member.lastKillTime > 0
-- 		and member.lastKillTime ~= bot.lastKillTime
-- 		and member.lastKillTime > bot.lastKillTime
-- 		then
-- 			bot.lastKillTime = member.lastKillTime
-- 		end
-- 	end

-- 	for i = 1, 5
-- 	do
-- 		local member = GetTeamMember(i)

-- 		if member ~= nil
-- 		and not member:IsIllusion()
-- 		and not member:HasModifier("modifier_arc_warden_tempest_double")
-- 		and J.IsCore(member)
-- 		then
-- 			aveLevel = aveLevel + member:GetLevel()
-- 		end
-- 	end

-- 	aveLevel = aveLevel / 3

-- 	if DotaTime() >= spawnTime * 60
-- 	and (DotaTime() - bot.lastKillTime) >= (spawnTime / 2) * 60
-- 	then
-- 		-- for i = 1, 5
-- 		-- do
-- 		-- 	local member = GetTeamMember(i)
-- 		-- 	if member ~= nil
-- 		-- 	and not IsPlayerBot(member)
-- 		-- 	and not member:IsIllusion()
-- 		-- 	and member:IsAlive()
-- 		-- 	then
-- 		-- 		humanPing = member:GetMostRecentPing()

-- 		-- 		if DotaTime() - humanPing.time < 30
-- 		-- 		and J.GetLocationToLocationDistance(humanPing.location, loc) < 600
-- 		-- 		and humanPing.normal_ping
-- 		-- 		then
-- 		-- 			return BOT_ACTION_DESIRE_VERYHIGH
-- 		-- 		end
-- 		-- 	end
-- 		-- end

-- 		-- Go check
-- 		if not IsTormentorAlive()
-- 		then
-- 			if not J.IsCore(bot)
-- 			and (GetUnitToUnitDistance(bot, enemyAncient) > 2000
-- 			or (topFrontP < 0.9 or midFrontP < 0.9 or botFrontP < 0.9)
-- 			or (topFrontD < 0.9 or midFrontD < 0.9 or botFrontD < 0.9))
-- 			then
-- 				return BOT_ACTION_DESIRE_HIGH
-- 			end
-- 		else
-- 			bot.tormentorState = true
-- 		end
-- 	else
-- 		bot.tormentorState = false
-- 	end

-- 	-- The one close to base for now.
-- 	-- Try to do it if close. (It's rare)
-- 	-- Tricky to harmonize with other desires since it can be griefing.
-- 	if bot.tormentorState
-- 	and aveLevel > 12
-- 	then
-- 		-- if healthPercentage < 0.3
-- 		-- and Tormentor ~= nil and J.GetHP(Tormentor) > 0.2
--         -- then
--         --     return BOT_ACTION_DESIRE_NONE
--         -- end

-- 		if IsEnoughAllies()
-- 		then
-- 			return BOT_ACTION_DESIRE_ABSOLUTE
-- 		end

-- 		local enemyAncient = GetAncient(GetOpposingTeam())
-- 		if GetUnitToUnitDistance(bot, enemyAncient) < 3200
-- 		or (topFrontP > 0.9 or midFrontP > 0.9 or botFrontP > 0.9)
-- 		or (topFrontD > 0.9 or midFrontD > 0.9 or botFrontD > 0.9)
-- 		then
-- 			return BOT_ACTION_DESIRE_NONE
-- 		else
-- 			return BOT_ACTION_DESIRE_HIGH
-- 		end
-- 	end

-- 	return BOT_MODE_DESIRE_NONE
-- end

-- function Think()
-- 	if GetUnitToLocationDistance(bot, loc) > 100
-- 	then
-- 		bot:Action_MoveToLocation(loc)
-- 		return
-- 	else
-- 		local nCreeps = bot:GetNearbyNeutralCreeps(700)

-- 		for _, c in pairs(nCreeps)
-- 		do
-- 			if c:GetUnitName() == "npc_dota_miniboss"
-- 			then
-- 				Tormentor = c

-- 				if IsEnoughAllies()
-- 				or J.GetHP(c) < 0.25
-- 				then
-- 					bot:Action_AttackUnit(c, false)
-- 				end

-- 				if (DotaTime() - tormentorMessageTime) > 15
-- 				then
-- 					tormentorMessageTime = DotaTime()
-- 					bot:ActionImmediate_Chat("tormentor?", false)
-- 					bot:ActionImmediate_Ping(c:GetLocation().x, c:GetLocation().y, true)
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- function IsTormentorAlive()
-- 	if IsLocationVisible(loc)
-- 	and GetUnitToLocationDistance(bot, loc) <= 100
-- 	then
-- 		local nCreeps = bot:GetNearbyNeutralCreeps(700)
-- 		for _, c in pairs(nCreeps)
-- 		do
-- 			if c:GetUnitName() == "npc_dota_miniboss"
-- 			then
-- 				return true
-- 			end
-- 		end

-- 		bot.lastKillTime = DotaTime()
-- 	end

-- 	return false
-- end

-- function IsEnoughAllies()
-- 	local heroCount = 0

-- 	for i = 1, 5
-- 	do
-- 		local member = GetTeamMember(i)

-- 		if member ~= nil
-- 		and member:IsAlive()
-- 		and not member:IsIllusion()
-- 		and not member:HasModifier("modifier_arc_warden_tempest_double")
-- 		and GetUnitToLocationDistance(member, loc) <= 700
-- 		then
-- 			heroCount = heroCount + 1
-- 		end
-- 	end

-- 	return heroCount >= 4
-- end

-- function DoesAllHaveShard()
-- 	local heroCount = 0

-- 	for i = 1, 5
-- 	do
-- 		local member = GetTeamMember(i)

-- 		if member ~= nil
-- 		and J.HasAghanimsShard(member)
-- 		then
-- 			heroCount = heroCount + 1
-- 		end
-- 	end

-- 	shardCount = heroCount

-- 	return heroCount == 5
-- end

-- function GetAveTeamDistance()
-- 	local heroCount = 0
-- 	local aveDistance = 0

-- 	for i = 1, 5
-- 	do
-- 		local member = GetTeamMember(i)

-- 		if member ~= nil
-- 		and member:IsAlive()
-- 		and not member:IsIllusion()
-- 		and not member:HasModifier("modifier_arc_warden_tempest_double")
-- 		and GetUnitToLocationDistance(member, loc) <= 3200
-- 		then
-- 			heroCount = heroCount + 1
-- 			aveDistance = aveDistance + GetUnitToLocationDistance(member, loc)
-- 		end
-- 	end

-- 	if heroCount > 0
-- 	then
-- 		return aveDistance / heroCount, heroCount
-- 	end

-- 	return 0, 0
-- end

-- function DidSomeoneSeeTormentorAlive()
-- 	for i = 1, 5
-- 	do
-- 		local member = GetTeamMember(i)

-- 		if member ~= nil
-- 		and member.tormentorState
-- 		then
-- 			return true
-- 		end
-- 	end

-- 	return false
-- end

function GetDesire()
    return 0
end