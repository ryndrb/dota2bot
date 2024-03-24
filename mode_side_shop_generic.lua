local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local Tormentor = nil

local tormentorMessageTime = DotaTime()
local canDoTormentor = false

local RadiantTormentorLoc = Vector(-8075, -1148, 1000)
local DireTormentorLoc = Vector(8132, 1102, 1000)

local loc
if GetTeam() == TEAM_RADIANT
then
	loc = RadiantTormentorLoc
else
	loc = DireTormentorLoc
end

if bot.tormentorState == nil then bot.tormentorState = false end
if bot.lastKillTime == nil then bot.lastKillTime = 0 end
if bot.wasAttackingTormentor == nil then bot.wasAttackingTormentor = false end

function GetDesire()
    local nAllyInLoc = J.GetAlliesNearLoc(loc, 700)
	local aliveAlly = J.GetNumOfAliveHeroes(false)
	local aveDistance, heroCount = GetAveTeamDistance()
    local healthPercentage = bot:GetHealth() / bot:GetMaxHealth()
	local spawnTime = J.IsModeTurbo() and 10 or 20
	local topFrontP = GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, true)
	local midFrontP = GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, true)
	local botFrontP = GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, true)
	local topFrontD = 1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, true)
	local midFrontD = 1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, true)
	local botFrontD = 1 - GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, true)
	local aveCoreLevel = 0
	local aveSuppLevel = 0

    local currTime = DotaTime()
    local startTimer = J.IsModeTurbo() and 15 * 60 or 35 * 60
    local timeForLowDesire = J.IsModeTurbo() and 20 * 60 or 45 * 60
    local nModeDesire = RemapValClamped(currTime, startTimer, timeForLowDesire, BOT_ACTION_DESIRE_HIGH, BOT_MODE_DESIRE_VERYLOW)

	local enemyAncient = GetAncient(GetOpposingTeam())
	if GetUnitToUnitDistance(bot, enemyAncient) < 3200
	or (topFrontP > 0.9 or midFrontP > 0.9 or botFrontP > 0.9)
	or (topFrontD > 0.9 or midFrontD > 0.9 or botFrontD > 0.9)
	or J.IsPushing(bot)
	or J.IsDefending(bot)
	or J.IsDoingRoshan(bot)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if DidSomeoneSeeTormentorAlive()
	then
		bot.tormentorState = true
	end

	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if member ~= nil
		and member.lastKillTime ~= nil
		and member.lastKillTime > 0
		and member.lastKillTime ~= bot.lastKillTime
		and member.lastKillTime > bot.lastKillTime
		then
			bot.lastKillTime = member.lastKillTime
		end
	end

	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if  member ~= nil
		and not member:IsIllusion()
		and not member:HasModifier("modifier_arc_warden_tempest_double")
		then
			if J.IsCore(member)
			then
				aveCoreLevel = aveCoreLevel + member:GetLevel()
			else
				aveSuppLevel = aveSuppLevel + member:GetLevel()
			end
		end
	end

	aveCoreLevel = aveCoreLevel / 3
	aveSuppLevel = aveSuppLevel / 2

	if DotaTime() >= spawnTime * 60
	and (DotaTime() - bot.lastKillTime) >= (spawnTime / 2) * 60
	then
		-- Go check
		if not IsTormentorAlive()
		then
			if not J.IsCore(bot)
			and (GetUnitToUnitDistance(bot, enemyAncient) > 2000
			or (topFrontP < 0.9 or midFrontP < 0.9 or botFrontP < 0.9)
			or (topFrontD < 0.9 or midFrontD < 0.9 or botFrontD < 0.9))
			then
                local closestAlly = nil
                local dist = 100000
                for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
                do
                    if  J.IsValidHero(allyHero)
                    and allyHero:IsAlive()
                    and not allyHero:IsIllusion()
                    and not J.IsCore(allyHero)
                    then
                        if GetUnitToLocationDistance(allyHero, loc) < dist
                        then
                            closestAlly = allyHero
                            dist = GetUnitToLocationDistance(allyHero, loc)
                        end
                    end
                end

                if  closestAlly ~= nil
                and bot == closestAlly
                and bot.tormentorState == false
                then
                    return nModeDesire
                end
			end
		else
			bot.tormentorState = true
		end
	else
		bot.tormentorState = false
	end

	if  bot.tormentorState
	and aveCoreLevel > 12.9
	and aveSuppLevel > 9.9
    and (((bot.lastKillTime == 0 and aliveAlly >= 5)
        or (bot.lastKillTime > 0 and aliveAlly >= 3)
		or (GetAttackingCount() >= 3)))
	and J.GetAliveAllyCoreCount() >= 2
	then
		canDoTormentor = true

        if  healthPercentage < 0.3
        and J.IsValid(Tormentor)
		and J.GetHP(Tormentor) > 0.2
        then
            return BOT_ACTION_DESIRE_NONE
        end

        if IsEnoughAllies()
        then
            return BOT_ACTION_DESIRE_VERYHIGH
        end

		if nAllyInLoc ~= nil and #nAllyInLoc >= 2
		or IsHumanInLoc()
		then
			return BOT_ACTION_DESIRE_VERYHIGH
		else
			return nModeDesire
		end
	end

	if not IsTormentorAlive()
	then
		bot.wasAttackingTormentor = false
	end

	canDoTormentor = false

	return BOT_MODE_DESIRE_NONE
end

function Think()
	if GetUnitToLocationDistance(bot, loc) > 100
	then
		bot:Action_MoveToLocation(loc)
		return
	else
		local nCreeps = bot:GetNearbyNeutralCreeps(700)

		for _, c in pairs(nCreeps)
		do
			if c:GetUnitName() == "npc_dota_miniboss"
			then
				Tormentor = c

				if IsEnoughAllies()
				or J.GetHP(c) < 0.25
				then
					bot.wasAttackingTormentor = true
					bot:Action_AttackUnit(c, false)
				end

				if  (DotaTime() - tormentorMessageTime) > 15
				and canDoTormentor
				then
					tormentorMessageTime = DotaTime()
					bot:ActionImmediate_Chat("let's try tormentor?", false)
					bot:ActionImmediate_Ping(c:GetLocation().x, c:GetLocation().y, true)
				end
			end
		end
	end
end

function IsTormentorAlive()
	if IsLocationVisible(loc)
	and GetUnitToLocationDistance(bot, loc) <= 100
	then
		local nCreeps = bot:GetNearbyNeutralCreeps(700)
		for _, c in pairs(nCreeps)
		do
			if c:GetUnitName() == "npc_dota_miniboss"
			then
				return true
			end
		end

		bot.lastKillTime = DotaTime()
	end

	return false
end

function IsEnoughAllies()
	local heroCount = 0
    local coreCount = 0

	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if member ~= nil
		and member:IsAlive()
		and not member:IsIllusion()
		and not member:HasModifier("modifier_arc_warden_tempest_double")
		and GetUnitToLocationDistance(member, loc) <= 700
		then
            if J.IsCore(member)
            then
                coreCount = coreCount + 1
            end

			heroCount = heroCount + 1
		end
	end

	return (((bot.lastKillTime == 0 and heroCount >= 5) or (bot.lastKillTime > 0 and heroCount >= 3))) and coreCount >= 2
end

function DoesAllHaveShard()
	local heroCount = 0

	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if member ~= nil
		and J.HasAghanimsShard(member)
		then
			heroCount = heroCount + 1
		end
	end

	return heroCount == 5
end

function GetAveTeamDistance()
	local heroCount = 0
	local aveDistance = 0
    local coreCount = 0

	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if member ~= nil
		and member:IsAlive()
		and not member:IsIllusion()
		and not member:HasModifier("modifier_arc_warden_tempest_double")
		and GetUnitToLocationDistance(member, loc) <= 2400
		then
			heroCount = heroCount + 1
			aveDistance = aveDistance + GetUnitToLocationDistance(member, loc)

            if J.IsCore(member)
            then
                coreCount = coreCount + 1
            end
		end
	end

	if  heroCount > 0
    and coreCount >= 2
	then
		return aveDistance / heroCount, heroCount
	end

	return 0, 0
end

function DidSomeoneSeeTormentorAlive()
	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if member ~= nil
		and member.tormentorState
		then
			return true
		end
	end

	return false
end

function GetAttackingCount()
	local count = 0

	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if  member ~= nil
		and member:IsAlive()
		and member.wasAttackingTormentor
		then
			count = count + 1
		end
	end

	return count
end

function IsHumanInLoc()
	for i = 1, 5
	do
		local member = GetTeamMember(i)

		if  member ~= nil
		and member:IsAlive()
		and not member:IsBot()
		and not member:IsIllusion()
		and not member:HasModifier("modifier_arc_warden_tempest_double")
		and not J.IsMeepoClone(member)
		and GetUnitToLocationDistance(member, loc) <= 700
		then
			return true
		end
	end

	return false
end