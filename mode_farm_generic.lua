if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or GetBot():IsIllusion() then
	return;
end

local bot = GetBot();
local X = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local botName = bot:GetUnitName()
local minute = 0
local sec = 0
local preferedCamp = nil

local bWelcomeMessageDone = false

local fLastCampUpdateTime = 0
local FARM_STATE__NONE = 0
local FARM_STATE__FARM = 1
local FARM_STATE__STACK = 2

if _G.NeutralCamps == nil then _G.NeutralCamps = {} end

local bShouldCreepAggroToStack = { check = false, attack = false }

function GetDesire()
	X.InitFarm()

    if J.GetFirstBotInTeam() == bot then
		if not bWelcomeMessageDone then
			if DotaTime() > -45 then
				bot:ActionImmediate_Chat("Check out the GitHub page to get the latest files: https://github.com/ryndrb/dota2bot", true)
				bot:ActionImmediate_Chat("If you have any feedback in improving the experience, kindly post them on the Steam Workshop page.", true)
				bWelcomeMessageDone = true
			end
		end

		X.UpdateAllCamps()
    end

	local LoneDruid = J.CheckLoneDruid()
    local botActiveMode = bot:GetActiveMode()
	local botActiveModeDesire = bot:GetActiveModeDesire()
    local botLevel = bot:GetLevel()
    local bAlive = bot:IsAlive()
	local bCore = J.IsCore(bot)
	local bWeAreStronger = J.WeAreStronger(bot, 1600)

    local vTormentorLocation = J.GetTormentorLocation(GetTeam())
	local nInRangeAlly_tormentor = J.GetAlliesNearLoc(vTormentorLocation, 1600)
	local nInRangeAlly_roshan = J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 1200)
    local bRoshanAlive = J.IsRoshanAlive()
    local teamNetworth, enemyNetworth = J.GetInventoryNetworth()
    local networthAdvantage = teamNetworth - enemyNetworth

    local nAliveEnemyCount = J.GetNumOfAliveHeroes(true)
	local nAliveAllyCount  = J.GetNumOfAliveHeroes(false)
	local bNotClone = not bot:HasModifier('modifier_arc_warden_tempest_double') and not J.IsMeepoClone(bot)

	local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

	sec = math.floor(DotaTime()) % 60

    if not bAlive
	or J.IsInLaningPhase()
	or J.IsDefending(bot)
	or (J.IsDoingRoshan(bot) and bNotClone)
	or (J.IsDoingTormentor(bot) and bNotClone)
    or DotaTime() < 50
    or ((botActiveMode == BOT_MODE_SECRET_SHOP
		or botActiveMode == BOT_MODE_RUNE
		or botActiveMode == BOT_MODE_WARD
		or botActiveMode == BOT_MODE_RETREAT
		or botActiveMode == BOT_MODE_OUTPOST) and botActiveModeDesire > 0)
	or (#nInRangeAlly_tormentor >= 2 and bot.tormentor_state == true)
    or (#nInRangeAlly_roshan >= 2 and bRoshanAlive and bNotClone)
    or (nAliveEnemyCount <= 1 and nAliveAllyCount >= 2)
    or (J.DoesTeamHaveAegis() and J.IsLateGame() and nAliveAllyCount >= 4)
	or X.IsUnitAroundLocation(GetAncient(GetTeam()):GetLocation(), 3200)
	or #nEnemyHeroes > 0
	or nAliveEnemyCount <= 1
    then
        return BOT_MODE_DESIRE_NONE
    end

	-- Retreating allies
    for i = 1, 5 do
		local member = GetTeamMember(i)
		if bot ~= member and J.IsValidHero(member) and J.IsInRange(bot, member, 2000) and J.IsRetreating(member) then
			local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, member)
			if #nEnemyHeroesTargetingAlly >= 2 or member:WasRecentlyDamagedByAnyHero(1.0) then
				return BOT_MODE_DESIRE_NONE
			end
		end
	end

    local vTeamFightLocation = J.GetTeamFightLocation(bot)
    if vTeamFightLocation ~= nil and GetUnitToLocationDistance(bot, vTeamFightLocation) < 2500 then
        if bot:GetLevel() >= 18 or not J.IsCore(bot) then
            return BOT_MODE_DESIRE_NONE
        end
    end

    if bAlive and bot:HasModifier('modifier_arc_warden_tempest_double') then
        if bRoshanAlive then
            for _, ally in pairs(nInRangeAlly_roshan) do
                if ally ~= bot
                and J.IsValidHero(ally)
                and ally:GetUnitName() == 'npc_dota_hero_arc_warden'
				and J.IsDoingRoshan(ally)
                then
                    local hTarget = ally:GetAttackTarget()
                    if (J.IsRoshan(hTarget) and J.GetHP(hTarget) < 0.4)
                    or (botActiveMode == BOT_MODE_ITEM)
                    then
						if preferedCamp == nil then preferedCamp = X.GetPreferedCampToFarm(_G.NeutralCamps) end
                        return BOT_MODE_DESIRE_ABSOLUTE
					end
                end
            end
        end
    end

    if bAlive and J.IsMeepoClone(bot) then
        if bRoshanAlive then
            for _, ally in pairs(nInRangeAlly_roshan) do
                if ally ~= bot
                and J.IsValidHero(ally)
				and not J.IsMeepoClone(ally)
                and ally:GetUnitName() == 'npc_dota_hero_meepo'
                and J.IsDoingRoshan(ally)
                then
                    local hTarget = ally:GetAttackTarget()
                    if (J.IsRoshan(hTarget) and J.GetHP(hTarget) < 0.25)
                    or (botActiveMode == BOT_MODE_ITEM)
                    then
						if preferedCamp == nil then preferedCamp = X.GetPreferedCampToFarm(_G.NeutralCamps) end
                        return BOT_MODE_DESIRE_ABSOLUTE
                    end
                end
            end
        end
    end

    local hItem = J.IsItemAvailable('item_hand_of_midas')
    if J.IsInAllyArea(bot) and J.CanCastAbility(hItem) then
        return BOT_MODE_DESIRE_ABSOLUTE
    end

	if  J.Site.IsTimeToFarm(bot)
	and (bot:GetUnitName() ~= 'npc_dota_hero_lone_druid_bear' or (bot:HasScepter() and not J.IsValid(LoneDruid.hero)))
	and (networthAdvantage < 10000 or (enemyNetworth - teamNetworth) > 10000)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(900, true)
		if #nEnemyLaneCreeps > 0 then
			local nInRangeEnemy = J.GetEnemiesNearLoc(J.GetCenterOfUnits(nEnemyLaneCreeps), 1600)
			if #nInRangeEnemy == 0 then
				return BOT_MODE_DESIRE_VERYHIGH
			end
		end

		if preferedCamp == nil then preferedCamp = X.GetPreferedCampToFarm(_G.NeutralCamps) end

		if preferedCamp then
			if not J.Site.IsModeSuitableToFarm(bot) then
				preferedCamp = nil
				return BOT_MODE_DESIRE_NONE
			elseif J.GetHP(bot) < 0.2 then
				preferedCamp = nil
				return BOT_MODE_DESIRE_VERYLOW
			elseif bot.farm.state == FARM_STATE__FARM then
				return BOT_MODE_DESIRE_ABSOLUTE
			elseif bot.farm.state == FARM_STATE__STACK then
				return BOT_MODE_DESIRE_ABSOLUTE
			else
				return BOT_MODE_DESIRE_VERYHIGH
			end
		end
	end

	if not J.IsInLaningPhase() and (bCore or J.IsLateGame() or bot:GetLevel() >= 18) then
		if preferedCamp == nil then preferedCamp = X.GetPreferedCampToFarm(_G.NeutralCamps) end
		if preferedCamp then
			return BOT_MODE_DESIRE_LOW
		end
	end

	return BOT_MODE_DESIRE_NONE
end

function OnStart()

end

function OnEnd()
	preferedCamp = nil
	bot.farm.state = FARM_STATE__NONE
end

function Think()
	if J.CanNotUseAction(bot) then return end

	local botAttackRange = bot:GetAttackRange()
	local StaticRemnant = bot:GetAbilityByName('storm_spirit_static_remnant')

	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(900, true)
	if J.IsValid(nEnemyLaneCreeps[1]) and bot.farm.state ~= FARM_STATE__STACK then
		local farmTarget = J.Site.GetMaxHPCreep(nEnemyLaneCreeps)
		if J.IsValid(farmTarget) then
			local nEnemyTowers = bot:GetNearbyTowers(1600, true)
			if J.IsValidBuilding(nEnemyTowers[1]) then
				if nEnemyTowers[1]:GetAttackTarget() == bot or bot:WasRecentlyDamagedByTower(5.0) then
					bot.farm.state = FARM_STATE__NONE
					bot:Action_MoveToLocation(J.VectorAway(bot:GetLocation(), nEnemyTowers[1]:GetLocation(), 1600))
					return
				end
			end

			local range = botAttackRange
			if J.CanCastAbility(StaticRemnant) then
				range = StaticRemnant:GetSpecialValueInt('static_remnant_radius')
			end

			if GetUnitToUnitDistance(bot, farmTarget) > range then
				bot.farm.location = farmTarget:GetLocation()
				bot.farm.state = FARM_STATE__NONE
				bot:Action_MoveToLocation(farmTarget:GetLocation())
				return
			else
				bot.farm.state = FARM_STATE__FARM
				bot:Action_AttackUnit(farmTarget, false)
				return
			end
		end
	end

	if preferedCamp == nil then preferedCamp = X.GetPreferedCampToFarm(_G.NeutralCamps) end
	if preferedCamp ~= nil then
		local farmLocation = preferedCamp.location
		local farmLocationDistance = GetUnitToLocationDistance(bot, farmLocation)

		if (X.IsLocCanBeSeen(farmLocation) and farmLocationDistance <= 600) or farmLocationDistance <= 250 then
			if not X.IsThereNeutralCreepInLocation(farmLocation, 600) then
				X.UpdateCurrentCamps(preferedCamp)
				preferedCamp = X.GetPreferedCampToFarm(_G.NeutralCamps)
				return
			end
		end

		local nEnemyCreeps = bot:GetNearbyCreeps(900, true)
		if J.IsValid(nEnemyCreeps[1]) then
			local farmTarget = J.Site.GetMaxHPCreep(nEnemyCreeps)
			if J.IsValid(farmTarget) then
				-- stack; decent; they stack quite a bit, but can die sometimes if weak hero
				local nLocationAoE_heroes = bot:FindAoELocation(false, true, farmLocation, 0, 600, 0, 0)
				local nLocationAoE_creeps = bot:FindAoELocation(false, false, farmLocation, 0, 600, 0, 0)
				if  preferedCamp
				and nLocationAoE_heroes.count <= 1
				and nLocationAoE_creeps.count == 0
				then
					local stackTime = 0
					if preferedCamp.speed == 'fast' then
						stackTime = 55
					elseif preferedCamp.speed == 'slow' then
						stackTime = 54
					else
						stackTime = 55
					end

					if stackTime > 0 then
						if sec >= stackTime then
							bot.farm.state = FARM_STATE__STACK

							if bShouldCreepAggroToStack.check == false then
								local nNeutralCreeps = bot:GetNearbyNeutralCreeps(900)
								if not X.IsThereCreepAggro(nNeutralCreeps) then
									bShouldCreepAggroToStack.attack = true
								else
									bShouldCreepAggroToStack.attack = false
									bShouldCreepAggroToStack.check = true
								end

								if bShouldCreepAggroToStack.attack then
									bot:Action_AttackUnit(farmTarget, true)
									return
								end
							end

							local vLocation = J.VectorTowards(farmLocation, ( J.GetTeamFountain() + J.GetEnemyFountain() ) / 2, 1200)

							if GetUnitToLocationDistance(bot, vLocation) + 200 < J.GetDistance(farmLocation, vLocation) then
								bot:Action_MoveToLocation(vLocation)
								return
							else
								bot:Action_MoveToLocation(J.VectorAway(bot:GetLocation(), farmLocation, 1200))
								return
							end
						else
							bShouldCreepAggroToStack.check = false
						end
					end
				end

				bot.farm.state = FARM_STATE__FARM

				if J.CanCastAbility(StaticRemnant) then
					local nRadius = StaticRemnant:GetSpecialValueInt('static_remnant_radius')
					if GetUnitToUnitDistance(bot, farmTarget) > nRadius then
						bot:Action_MoveToLocation(farmTarget:GetLocation())
						return
					end
				end

				bot:SetTarget(farmTarget)
				bot:Action_AttackUnit(farmTarget, true)
				return
			end
		end

		bot.farm.state = FARM_STATE__NONE
		if X.CouldBlade(bot, farmLocation) and J.GetAbility(bot, 'monkey_king_tree_dance') == nil then return end

		bot.farm.location = farmLocation
		bot:Action_MoveToLocation(farmLocation)
		return
	end
end

function X.InitFarm()
	if  bot.farm == nil then
		bot.farm = {
			location = nil,
			state = FARM_STATE__NONE,
		}
	end
end

function X.UpdateAllCamps()
	if DotaTime() - fLastCampUpdateTime >= 60 then
		_G.NeutralCamps = GetNeutralSpawners()
		fLastCampUpdateTime = DotaTime()
	end
end

function X.UpdateCurrentCamps(camp)
	if camp then
		for i = #_G.NeutralCamps, 1, -1 do
			if _G.NeutralCamps[i] == camp then
				table.remove(_G.NeutralCamps, i)
			end
		end
	end
end

function X.GetPreferedCampToFarm(hCampList)
	local camp = nil
	local campDistance = math.huge
	local botLevel = bot:GetLevel()
	local teamAverageLevel = J.GetAverageLevel(GetTeam())
	local botNetworth = bot:GetNetWorth()
	local botAttackDamage = bot:GetAttackDamage()

	local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1000)

	for i = #hCampList, 1, -1 do
		if not X.IsEnemyAroundLocation(hCampList[i].location, 1200) then
			local currDistance = GetUnitToLocationDistance(bot, hCampList[i].location)
			local bCanFarmEnemy = currDistance <= 900 and #nEnemyHeroes == 0 and not bot:WasRecentlyDamagedByAnyHero(4.0)

			local prefered = nil
			if teamAverageLevel <= 7 or botAttackDamage <= 80 then
				if  (hCampList[i].team == GetTeam())
				and (hCampList[i].type ~= 'large')
				and (hCampList[i].type ~= 'ancient')
				then
					prefered = hCampList[i]
				end
			elseif teamAverageLevel <= 11 then
				if  (hCampList[i].team == GetTeam() or bCanFarmEnemy)
				and (hCampList[i].type ~= 'ancient')
				then
					prefered = hCampList[i]
				end
			elseif teamAverageLevel <= 14 then
				if (hCampList[i].team == GetTeam() or bCanFarmEnemy) then
					prefered = hCampList[i]
				end
			else
				prefered = hCampList[i]
			end

			if prefered then
				local preferedDistance = GetUnitToLocationDistance(bot, prefered.location)
				if prefered.team ~= GetTeam() then
					preferedDistance = preferedDistance * 1.5
				end

				if  preferedDistance < campDistance
				and X.IsTheClosestAroundLocation(prefered.location)
				then
					camp = prefered
					campDistance = preferedDistance
				end
			end
		end
	end

	return camp
end

function X.IsThereNeutralCreepInLocation(vLocation, nRadius)
	for _, creep in pairs(GetUnitList(UNIT_LIST_NEUTRAL_CREEPS)) do
		if J.IsValid(creep) and GetUnitToLocationDistance(creep, vLocation) <= nRadius then
			return true
		end
	end

	return false
end

function X.IsTheClosestAroundLocation(vLocation)
	local closestMember = bot
	local closestMemberDistance = GetUnitToLocationDistance(bot, vLocation)

	for i = 1, 5 do
		local member = GetTeamMember(i)
		if J.IsValidHero(member) then
			if member:GetActiveMode() == BOT_MODE_FARM or J.GetPosition(member) <= 3 then
				local memberDistance = GetUnitToLocationDistance(member, vLocation)
				if memberDistance < closestMemberDistance then
					closestMember = member
					closestMemberDistance = memberDistance
				end
			end
		end
	end

	return closestMember == bot
end

function X.IsEnemyAroundLocation(vLocation, nRadius)
	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if  dInfo ~= nil
				and J.GetDistance(vLocation, dInfo.location) <= nRadius
				and dInfo.time_since_seen > 1.0
				and dInfo.time_since_seen < 15.0
				then
					return true
				end
			end
		end
	end

	return false
end

function X.IsThereCreepAggro(hCreepList)
	for _, creep in pairs(hCreepList) do
		if J.IsValid(creep) and creep:GetAttackTarget() == bot then
			return true
		end
	end

	return false
end

function X.IsUnitAroundLocation(vLoc, nRadius)
	for i, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) and i <= 3 then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if dInfo ~= nil and J.GetDistance(vLoc, dInfo.location) <= nRadius and dInfo.time_since_seen < 1.0 then
					return true
				end
			end
		end
	end
	return false;
end

function X.CouldBlade(bot,nLocation) 
	local blade = J.IsItemAvailable("item_quelling_blade");
	if blade == nil then blade = J.IsItemAvailable("item_bfury"); end
	
	if blade ~= nil 
	   and blade:IsFullyCastable() 
	then
		local trees = bot:GetNearbyTrees(380);
		local dist = GetUnitToLocationDistance(bot,nLocation);
		local vStart = J.Site.GetXUnitsTowardsLocation(bot, nLocation, 32 );
		local vEnd  = J.Site.GetXUnitsTowardsLocation(bot, nLocation, dist - 32 );
		for _,t in pairs(trees)
		do
			if t ~= nil
			then
				local treeLoc = GetTreeLocation(t);
				local tResult = PointToLineDistance(vStart, vEnd, treeLoc);
				if tResult ~= nil 
				   and tResult.within 
				   and tResult.distance <= 96
				   and J.GetLocationToLocationDistance(treeLoc,nLocation) < dist
				then
					bot:Action_UseAbilityOnTree(blade, t);
					return true;
				end
			end			
		end
	end
	
	return false;
end

function X.IsLocCanBeSeen(vLocation)
	if  GetUnitToLocationDistance(GetBot(), vLocation) < 180
	and IsRadiusVisible(vLocation, 10)
	then
		return true
	end

	local offsets = {
		Vector( 0,    10), -- up
		Vector( 5,     0), -- right
		Vector( 0,   -10), -- down
		Vector(-5,     0),  -- left
		Vector( 7.07,  7.07),  -- up-right diagonal
		Vector( 7.07, -7.07), -- down-right diagonal
		Vector(-7.07,  7.07), -- up-left diagonal
		Vector(-7.07, -7.07), -- down-left diagonal
	}

	for _, offset in ipairs(offsets) do
		local tempLoc = vLocation + offset
		if not IsLocationVisible(tempLoc) then
			return false
		end
	end

	return IsRadiusVisible(vLocation, 10)
end
