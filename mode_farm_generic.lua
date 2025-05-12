if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or GetBot():IsIllusion() then
	return;
end

local bot = GetBot();
local X = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')
local RB = Vector(-7174.000000, -6671.00000, 0.000000)
local DB = Vector(7023.000000, 6450.000000, 0.000000)

local botName = bot:GetUnitName();
local minute = 0;
local sec = 0;
local preferedCamp = nil;
local availableCamp = {};
local hLaneCreepList = {};
local numCamp = 18;
local farmState = 0;
local teamPlayers = nil;
local nLaneList = {LANE_TOP, LANE_MID, LANE_BOT};
local nTpSolt = 15

local pushTime = 0;
local laningTime = 0;
local assembleTime = 0;
local teamTime = 0;

local countTime = 0;
local countCD = 5.0;
local allyKills = 0;
local enemyKills = 0;

local nLostCount = RandomInt(35,45);
local nWinCount = RandomInt(24,34);

local bInitDone = false;
local beNormalFarmer = false;
local beHighFarmer = false;
local beVeryHighFarmer = false;

local isWelcomeMessageDone = false

if bot.farmLocation == nil then bot.farmLocation = bot:GetLocation() end

function GetDesire()

    if not isWelcomeMessageDone and J.GetFirstBotInTeam() == bot
    then
        if DotaTime() > -45 then
			bot:ActionImmediate_Chat("Check out the GitHub page to get the latest files: https://github.com/ryndrb/dota2bot", true)
			bot:ActionImmediate_Chat("If you have any feedback in improving the experience, kindly post them on the Steam Workshop page.", true)
			isWelcomeMessageDone = true
		end
    end

	if not bInitDone
	then
		bInitDone = true
		beNormalFarmer = J.GetPosition(bot) == 3
		beHighFarmer = J.GetPosition(bot) == 2
		beVeryHighFarmer = J.GetPosition(bot) == 1
	end

    local botActiveMode = bot:GetActiveMode()
	local botActiveModeDesire = bot:GetActiveModeDesire()
    local botLevel = bot:GetLevel()
    local bAlive = bot:IsAlive()

    local vTormentorLocation = J.GetTormentorLocation(GetTeam())
	local nInRangeAlly_tormentor = J.GetAlliesNearLoc(vTormentorLocation, 1600)
	local nInRangeAlly_roshan = J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 1200)
    local bRoshanAlive = J.IsRoshanAlive()
    local teamNetworth, enemyNetworth = J.GetInventoryNetworth()
    local networthAdvantage = teamNetworth - enemyNetworth

    local nAliveEnemyCount = J.GetNumOfAliveHeroes(true)
	local nAliveAllyCount  = J.GetNumOfAliveHeroes(false)
	local bNotClone = not bot:HasModifier('modifier_arc_warden_tempest_double') and not J.IsMeepoClone(bot)

    if J.IsInLaningPhase()
	or (J.IsDoingRoshan(bot) and bNotClone)
	or (J.IsDoingTormentor(bot) and bNotClone)
    or DotaTime() < 50
    or ((botActiveMode == BOT_MODE_SECRET_SHOP
		or botActiveMode == BOT_MODE_RUNE
		or botActiveMode == BOT_MODE_OUTPOST) and botActiveModeDesire > 0)
	or (#nInRangeAlly_tormentor >= 2 and bot.tormentor_state == true)
    or (#nInRangeAlly_roshan >= 2 and bRoshanAlive and bNotClone)
    or (nAliveEnemyCount <= 1 and nAliveAllyCount >= 2)
    or (J.DoesTeamHaveAegis() and J.IsLateGame() and nAliveAllyCount >= 4)
    or not bAlive
    then
        return BOT_MODE_DESIRE_NONE
    end
	
	if teamPlayers == nil then teamPlayers = GetTeamPlayers(GetTeam()) end

	if DotaTime() < 50 or botActiveMode == BOT_MODE_RUNE then
		return 0.0
	end
	
	if X.IsUnitAroundLocation(GetAncient(GetTeam()):GetLocation(), 3000) 
	-- and aliveAllyCount >= aliveEnemyCount
	then
		return BOT_MODE_DESIRE_NONE;
	end
	
	sec = math.floor(DotaTime()) % 60;
	
	if not J.Role.IsCampRefreshDone()
	   and J.Role.GetAvailableCampCount() < J.Role.GetCampCount()
	   and ( DotaTime() > 20 and  sec > 0 and sec < 2 )  
	then
		J.Role['availableCampTable'], J.Role['campCount'] = J.Site.RefreshCamp(bot);
		J.Role['hasRefreshDone'] = true;
	end
	
	if J.Role.IsCampRefreshDone() and sec > 52
	then
		J.Role['hasRefreshDone'] = false;
	end
	
	availableCamp = J.Role['availableCampTable'];

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
    if #nEnemyHeroes > 0 then
        return BOT_MODE_DESIRE_NONE
    end

    local nAllyHeroes_attacking = {}
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if bot ~= member and J.IsValidHero(member) and J.IsInRange(bot, member, 1600) then
            local hTarget = member:GetAttackTarget()
			if J.IsGoingOnSomeone(member)
            or (J.IsValidHero(hTarget) and J.IsChasingTarget(member, hTarget) and J.IsInRange(member, hTarget, 1000))
			then
				table.insert(nAllyHeroes_attacking, member)
			end
		end
	end

    if #nAllyHeroes_attacking > 0 then
        local nInRangeEnemy = J.GetEnemiesNearLoc(J.GetCenterOfUnits(nAllyHeroes_attacking), 1200)
        if #nAllyHeroes_attacking + 1 >= #nInRangeEnemy then
            return BOT_MODE_DESIRE_NONE
        end
    end

	-- Retreating allies
    for i = 1, 5 do
		local member = GetTeamMember(i)
		if bot ~= member and J.IsValidHero(member) and J.IsInRange(bot, member, 2000) and J.IsRetreating(member) then
            local nInRangeEnemy = J.GetEnemiesNearLoc(member:GetLocation(), 1200)
            for _, enemy in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemy)
                and (J.IsChasingTarget(enemy, bot) or enemy:GetAttackTarget() == member and J.GetHP(member) < 0.4)
                then
                    return BOT_MODE_DESIRE_NONE
                end
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
						if preferedCamp == nil then preferedCamp = J.Site.GetClosestNeutralSpwan(bot, availableCamp) end
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
						if preferedCamp == nil then preferedCamp = J.Site.GetClosestNeutralSpwan(bot, availableCamp) end
                        return BOT_MODE_DESIRE_ABSOLUTE
                    end
                end
            end
        end
    end
	
	if not J.Role.IsAllyHaveAegis() and J.IsHaveAegis(bot) then J.Role['aegisHero'] = bot end;
	if J.Role.IsAllyHaveAegis() and nAliveAllyCount >= 4 and J.IsLateGame()
	then
		return BOT_MODE_DESIRE_NONE;
	end
		
	if DotaTime() > countTime + countCD
	then
		countTime  = DotaTime();
		allyKills  = J.GetNumOfTeamTotalKills(false);
		enemyKills = J.GetNumOfTeamTotalKills(true);

		
		if enemyKills > allyKills + nLostCount and J.Role.NotSayRate() 
		then
			J.Role['sayRate'] = true;
			if RandomInt(1,6) < 3 
			then
				bot:ActionImmediate_Chat("We estimate that the probability of winning is less than 1%, so we are resigned to losing! Well played! ",true);
			else
				bot:ActionImmediate_Chat("We estimate the probability of winning to be below 1%.Well played!",true);
			end
		end
		if allyKills > enemyKills + nWinCount and J.Role.NotSayRate() 
		then
		    J.Role['sayRate'] = true;
			if RandomInt(1,6) < 3 
			then
				bot:ActionImmediate_Chat("We estimate that the probability of winning a team battle is over 90%",true);
			else
				bot:ActionImmediate_Chat("We estimate the probability of winning to above 90%.",true);
			end
		end
	
	end
	if allyKills > enemyKills + 20 and nAliveAllyCount >= 4 and networthAdvantage > 15000
	then return BOT_MODE_DESIRE_NONE; end

	local nAlliesCount = J.GetAllyCount(bot,1400);
	if nAlliesCount >= 4
	   or (bot:GetLevel() >= 23 and nAlliesCount >= 3)
	   or GetRoshanDesire() > BOT_MODE_DESIRE_VERYHIGH
	then
		local nNeutrals = bot:GetNearbyNeutralCreeps( bot:GetAttackRange() ); 
		if #nNeutrals == 0 
		then 
		    teamTime = DotaTime();
		end
	end

    local hItem = J.IsItemAvailable('item_hand_of_midas')
    if J.IsInAllyArea(bot) and J.CanCastAbility(hItem) then
        if preferedCamp == nil then preferedCamp = J.Site.GetClosestNeutralSpwan(bot, availableCamp) end;
        return BOT_MODE_DESIRE_ABSOLUTE
    end

	if J.IsDefending(bot) and botActiveModeDesire >= 0.75 then
		local nDefendLane, nDefendDesire = J.GetMostDefendLaneDesire()
		local vDefendLocation  = GetLaneFrontLocation(GetTeam(), nDefendLane, -600)
		local nDefendAllies = J.GetAlliesNearLoc(vDefendLocation, 2200)

		local nNeutrals = bot:GetNearbyNeutralCreeps(Min(bot:GetAttackRange(), 1600))

		if #nNeutrals == 0 and #nDefendAllies >= 2 and (not beVeryHighFarmer or bot:GetLevel() >= 15 or J.IsLateGame()) then
		    teamTime = DotaTime()
		end
	end

	if teamTime > DotaTime() - 3.0 then return BOT_MODE_DESIRE_NONE end

	local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)
    local aAliveCoreCount = J.GetAliveCoreCount(false)
    local eAliveCoreCount = J.GetAliveCoreCount(true)
	if eAliveCount == 0
	or aAliveCoreCount >= eAliveCoreCount
	or (aAliveCoreCount >= 1 and aAliveCount >= eAliveCount + 2)
	or J.IsLateGame()
	then
		if (beHighFarmer or (beNormalFarmer and J.IsMidGame()) or J.IsLateGame() or bot:GetNetWorth() >= 15000) then
			if bot:GetActiveMode() == BOT_MODE_ASSEMBLE then assembleTime = DotaTime() end
			if DotaTime() - assembleTime < 15.0 then return BOT_MODE_DESIRE_NONE end
			if J.IsTeamActivityCount(bot, 3)	then return BOT_MODE_DESIRE_NONE end
		end
	end


	if GetGameMode() ~= GAMEMODE_MO 
	-- and (J.Site.IsTimeToFarm(bot) or pushTime > DotaTime() - 8.0)
	and (J.Site.IsTimeToFarm(bot) and (J.IsCore(bot) and bot:GetLastHits() < (J.IsModeTurbo() and 400 or 200) and not J.IsDefending(bot)))
	-- and J.Site.IsTimeToFarm(bot)
	-- and (not J.IsHumanPlayerInTeam() or enemyKills > allyKills + 16)
	-- and ( bot:GetNextItemPurchaseValue() > 0 or not bot:HasModifier("modifier_item_moon_shard_consumed") )
	and (DotaTime() > 8 * 60 or bot:GetLevel() >= 8 or ( bot:GetAttackRange() < 220 and bot:GetLevel() >= 6 ))
	then
		if J.GetDistanceFromEnemyFountain(bot) > 4000 
		then
			hLaneCreepList = bot:GetNearbyLaneCreeps(1600, true);
			-- if #hLaneCreepList == 0	
			--    and J.IsInAllyArea( bot )
			--    and X.IsNearLaneFront( bot )
			-- then
			-- 	hLaneCreepList = bot:GetNearbyLaneCreeps(1600, false);
			-- end
		end;		
		
		if #hLaneCreepList > 0 
		then
			bot.farmLocation = J.GetCenterOfUnits(hLaneCreepList)
			return BOT_MODE_DESIRE_ABSOLUTE
		else
			if preferedCamp == nil then preferedCamp = J.Site.GetClosestNeutralSpwan(bot, availableCamp);end
			
			if preferedCamp ~= nil then
				if not J.Site.IsModeSuitableToFarm(bot) 
				then 
					preferedCamp = nil;
					return BOT_MODE_DESIRE_NONE;
				elseif bot:GetHealth() <= 200 
					then 
						preferedCamp = nil;
						teamTime = DotaTime();
						return BOT_MODE_DESIRE_VERYLOW;
				-- elseif farmState == 1
				--     then 
				-- 		bot.farmLocation = preferedCamp.cattr.location
				-- 	    return BOT_MODE_DESIRE_ABSOLUTE
				else
					
					if nAliveAllyCount >= 3
					then
						if pushTime > DotaTime() - 8.0
						then
							if preferedCamp == nil then preferedCamp = J.Site.GetClosestNeutralSpwan(bot, availableCamp);end
							bot.farmLocation = preferedCamp.cattr.location
							return BOT_MODE_DESIRE_MODERATE;
						end
						
						if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
							or bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
							or bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
						then
							local enemyAncient = GetAncient(GetOpposingTeam());
							local allies       = bot:GetNearbyHeroes(1400,false,BOT_MODE_NONE);
							local enemyAncientDistance = GetUnitToUnitDistance(bot,enemyAncient);
							if enemyAncientDistance < 2800
								and enemyAncientDistance > 1600
								and bot:GetActiveModeDesire() < BOT_MODE_DESIRE_HIGH
								and #allies < 2
							then
								pushTime = DotaTime();
								bot.farmLocation = preferedCamp.cattr.location
								return  BOT_MODE_DESIRE_ABSOLUTE *0.93;
							end
							
							if beHighFarmer or bot:GetAttackRange() < 310
							then
								if  bot:GetActiveModeDesire() <= BOT_MODE_DESIRE_MODERATE 
									and enemyAncientDistance > 1600
									and enemyAncientDistance < 5800
									and #allies < 2
								then
									pushTime = DotaTime();
									bot.farmLocation = preferedCamp.cattr.location
									return  BOT_MODE_DESIRE_ABSOLUTE *0.98;
								end
							end
						
						end
					end
					
					local farmDistance = GetUnitToLocationDistance(bot,preferedCamp.cattr.location);
					bot.farmLocation = preferedCamp.cattr.location
					return RemapValClamped(farmDistance, 600, 6400, 0.9, BOT_MODE_DESIRE_MODERATE)
				end
			end
		end
	end
	
	return BOT_MODE_DESIRE_NONE;
	
end


function OnStart()

end


function OnEnd()
	preferedCamp = nil;
	farmState = 0;
	hLaneCreepList  = {};
	bot:SetTarget(nil);
end


function Think()
	if J.CanNotUseAction(bot)
	then return end

	if J.IsValid(hLaneCreepList[1]) then
		local farmTarget = J.Site.GetFarmLaneTarget(hLaneCreepList);
		local nSearchRange = bot:GetAttackRange() + 180
		if nSearchRange > 1600 then nSearchRange = 1600 end
		local nNeutrals = bot:GetNearbyNeutralCreeps(nSearchRange);
		if J.IsValid(farmTarget) and #nNeutrals == 0 then
						
			if farmTarget:GetTeam() == bot:GetTeam() 
			   and J.IsInAllyArea(farmTarget)
			then
				bot:Action_MoveToLocation(farmTarget:GetLocation() + RandomVector(300));
				return
			end
			
			if farmTarget:GetTeam() ~= bot:GetTeam()
			then
				--如果小兵正在被友方小兵攻击且生命值略高于自己的击杀线则S自己的出手
				local allyTower = bot:GetNearbyTowers(1000,true)[1];
				if bot:GetAttackTarget() == farmTarget
				   and ( J.GetAttackEnemysAllyCreepCount(farmTarget, 800) > 0
						   or ( J.IsValidBuilding(allyTower) and allyTower:GetAttackTarget() == farmTarget ) )
				then
					local botDamage = bot:GetAttackDamage();
					local nDamageReduce = 1
					if bot:FindItemSlot("item_quelling_blade") > 0
						or bot:FindItemSlot("item_bfury") > 0
					then
						botDamage = botDamage + 13;
					end
					
					if not J.CanKillTarget(farmTarget, botDamage * nDamageReduce, DAMAGE_TYPE_PHYSICAL)
					   and J.CanKillTarget(farmTarget, (botDamage +99) * nDamageReduce, DAMAGE_TYPE_PHYSICAL)
					then
						bot:Action_ClearActions( true );
					    return
					end
				end
			
				if bot:GetAttackRange() > 310 
				then
					if GetUnitToUnitDistance(bot,farmTarget) > bot:GetAttackRange() + 180
					then
						bot:Action_MoveToLocation(farmTarget:GetLocation());
						return
					else
						bot:Action_AttackUnit(farmTarget, true);
						return
					end
				else
					if ( GetUnitToUnitDistance(bot,farmTarget) > bot:GetAttackRange() + 100 )
						or bot:GetAttackDamage() > 200
					then
						bot:Action_AttackUnit(hLaneCreepList[1], true);
						return
					else
						bot:Action_AttackUnit(farmTarget, true);
						return
					end
				end
			end
		end
	end
	
	
	if preferedCamp == nil then preferedCamp = J.Site.GetClosestNeutralSpwan(bot, availableCamp);end
	if preferedCamp ~= nil then
		local targetFarmLoc = preferedCamp.cattr.location;
		local cDist = GetUnitToLocationDistance(bot, targetFarmLoc);
		local nNeutrals = bot:GetNearbyCreeps(1600, true);
		if #nNeutrals >= 3 and cDist <= 600 and cDist > 240
		   and ( bot:GetLevel() >= 10 or not nNeutrals[1]:IsAncientCreep())
		then farmState = 1 end;
		
		if farmState == 0 
		   and ( J.IsValid(nNeutrals[1]) or #nNeutrals > 1)
		   and not J.IsRoshan(nNeutrals[1])
		   and ( bot:GetLevel() >= 10 or not nNeutrals[1]:IsAncientCreep())
		then
		
			if GetUnitToUnitDistance(bot,nNeutrals[1]) < bot:GetAttackRange() + 150
				and J.HasNotActionLast(4.0,'creep')
			then
				J.Role['availableCampTable'] = J.Site.UpdateCommonCamp(nNeutrals[1],J.Role['availableCampTable']);
			end

			local farmTarget = J.Site.FindFarmNeutralTarget(nNeutrals)
			if J.IsValid(farmTarget)
			then
				bot:SetTarget(farmTarget);
				bot:Action_AttackUnit(farmTarget, true);
				return;
			elseif J.IsValid(nNeutrals[1]) then
				bot:SetTarget(nNeutrals[1]);
				bot:Action_AttackUnit(nNeutrals[1], true);
				return;
			end
			
		elseif  farmState == 0 
				and #nNeutrals == 0
		        and cDist > 240
		        and ( not X.IsLocCanBeSeen(targetFarmLoc) or cDist > 600 )
			then
				
				-- bot:SetTarget(nil);
				
				-- if bot:GetLevel() >= 12
				-- 	 and J.Role.ShouldTpToFarm() 
				-- then
				-- 	local mostFarmDesireLane,mostFarmDesire = J.GetMostFarmLaneDesire();
				-- 	local tps = bot:GetItemInSlot(nTpSolt);
				-- 	local tpLoc = GetLaneFrontLocation(GetTeam(),mostFarmDesireLane,0);
				-- 	local bestTpLoc = J.GetNearbyLocationToTp(tpLoc);
				-- 	local nAllies = J.GetAlliesNearLoc(tpLoc, 1400);
				-- 	if mostFarmDesire > BOT_MODE_DESIRE_VERYHIGH 
				-- 		and J.IsLocHaveTower(1850,false,tpLoc)
				-- 		and bestTpLoc ~= nil					
				-- 		and #nAllies == 0
				-- 	then
				-- 		if tps ~= nil and tps:IsFullyCastable() 
				-- 		   and GetUnitToLocationDistance(bot,bestTpLoc) > 4200
				-- 		then
				-- 			preferedCamp = nil;
				-- 			J.Role['lastFarmTpTime'] = DotaTime();
				-- 			bot:Action_UseAbilityOnLocation(tps, bestTpLoc);
				-- 			return;
				-- 		end
				-- 	end	
					
				-- 	local tBoots = J.IsItemAvailable("item_travel_boots_2");
				-- 	if tBoots == nil then tBoots = J.IsItemAvailable("item_travel_boots"); end;
				-- 	if tBoots ~= nil and tBoots:IsFullyCastable()
				-- 	then
				-- 		local tpLoc = GetLaneFrontLocation(GetTeam(),mostFarmDesireLane,-600);
				-- 		local nAllies = J.GetAlliesNearLoc(tpLoc, 1600);
				-- 		if mostFarmDesire > BOT_MODE_DESIRE_HIGH * 1.12		
				-- 		   and #nAllies == 0
				-- 		   and GetUnitToLocationDistance(bot,tpLoc) > 3500
				-- 		then
				-- 			preferedCamp = nil;
				-- 			J.Role['lastFarmTpTime'] = DotaTime();
				-- 			bot:Action_UseAbilityOnLocation(tBoots, tpLoc);
				-- 			return;							
				-- 		end
				-- 	end					
				-- end
				
				if J.IsValid(hLaneCreepList[1])
				then
					bot:Action_MoveToLocation( hLaneCreepList[1]:GetLocation() );
					return;
				end
				
				if X.CouldBlink(bot,targetFarmLoc) then return end;
				
				if X.CouldBlade(bot,targetFarmLoc) then return end;
							
				bot:Action_MoveToLocation(targetFarmLoc);
				return;
		else
			local neutralCreeps = bot:GetNearbyCreeps(1600, true); 
			
			if #neutralCreeps >= 2 then
				
				farmState = 1;
				
				local farmTarget = J.Site.FindFarmNeutralTarget(neutralCreeps)
				if J.IsValid(farmTarget)
				then
					bot:SetTarget(farmTarget);
					bot:Action_AttackUnit(farmTarget, true);
					return;
				end
				
			elseif ( X.IsLocCanBeSeen(targetFarmLoc) and cDist <= 600 ) or cDist <= 240
				then
					
					farmState = 0;
					J.Role['availableCampTable'], preferedCamp = J.Site.UpdateAvailableCamp(bot, preferedCamp, J.Role['availableCampTable']);
					availableCamp = J.Role['availableCampTable'];	
					preferedCamp  = J.Site.GetClosestNeutralSpwan(bot, availableCamp);


					local farmTarget = J.Site.FindFarmNeutralTarget(neutralCreeps)
					if J.IsValid(farmTarget)
					then
						bot:SetTarget(farmTarget);
						bot:Action_AttackUnit(farmTarget, true);
						return;
					end
			else
			
				local farmTarget = J.Site.FindFarmNeutralTarget(neutralCreeps)
				if J.IsValid(farmTarget)
				then
					bot:SetTarget(farmTarget);
					bot:Action_AttackUnit(farmTarget, true);
					return;
				end
				
				bot:SetTarget(nil);
				
				if cDist > 200 then bot:Action_MoveToLocation(targetFarmLoc) return end
			end
		end			
	end
	
	
	
	bot:SetTarget(nil);
	bot:Action_MoveToLocation( ( RB + DB )/2 );
	return;
end

function X.IsNearLaneFront( bot )
	local testDist = 1600;
	for _,lane in pairs(nLaneList)
	do
		local tFLoc = GetLaneFrontLocation(GetTeam(), lane, 0);
		if GetUnitToLocationDistance(bot,tFLoc) <= testDist
		then
		    return true;
		end		
	end
	return false;
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


function X.CouldBlink(bot,nLocation)
	
	
	local maxBlinkDist = 1199;
	local blink = J.IsItemAvailable("item_blink");
	
	if botName == "npc_dota_hero_antimage"
	then
		blink = bot:GetAbilityByName( "antimage_blink" );
		maxBlinkDist = blink:GetSpecialValueInt('AbilityCastRange')
	end
	
	if botName == "npc_dota_hero_queenofpain"
	then
		blink = bot:GetAbilityByName( "queenofpain_blink" );
		maxBlinkDist = J.GetProperCastRange(false, bot, blink:GetCastRange())
	end
	
	if blink ~= nil 
	   and blink:IsFullyCastable() 
       and J.IsRunning(bot)
	then
		local bDist = GetUnitToLocationDistance(bot,nLocation);
		local maxBlinkLoc = J.Site.GetXUnitsTowardsLocation(bot, nLocation, maxBlinkDist );
		if bDist <= 600  -- recommend by oyster 2019/4/16
		then
			return false;
		elseif bDist < maxBlinkDist +1
			then
				if botName == "npc_dota_hero_antimage"
				then
					bot:Action_ClearActions(true);
		
					if not J.IsPTReady(bot,ATTRIBUTE_INTELLECT) 
					then
						J.SetQueueSwitchPtToINT(bot);
					end
							
					bot:ActionQueue_UseAbilityOnLocation(blink, nLocation);
									
					return true;
				end
			
				bot:Action_UseAbilityOnLocation(blink, nLocation);
				return true;
		elseif IsLocationPassable(maxBlinkLoc)
			then
				
				if botName == "npc_dota_hero_antimage"
				then
					bot:Action_ClearActions(true);
		
					if not J.IsPTReady(bot,ATTRIBUTE_INTELLECT) 
					then
						J.SetQueueSwitchPtToINT(bot);
					end
							
					bot:ActionQueue_UseAbilityOnLocation(blink, maxBlinkLoc);
									
					return true;
				end
				
				bot:Action_UseAbilityOnLocation(blink, maxBlinkLoc);
				return true;
		end
	end

	return false;
end


function X.IsLocCanBeSeen(vLoc)

	if GetUnitToLocationDistance(GetBot(),vLoc) < 180 then return true end
	
	local tempLocUp    = vLoc + Vector(5  ,0  );
	local tempLocDown  = vLoc + Vector(0  ,10 );
	local tempLocLeft  = vLoc + Vector(-15,0  );
	local tempLocRight = vLoc + Vector(0  ,-20);
	
	return IsLocationVisible(tempLocRight) 
		   and IsLocationVisible(tempLocLeft) 
	       and IsLocationVisible(tempLocUp) 
		   and IsLocationVisible(tempLocDown)
		   and IsRadiusVisible(vLoc,10)

end
