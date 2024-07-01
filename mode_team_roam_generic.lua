if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end


local bot = GetBot();
local bDebugMode = ( 1 == 10 )
local X = {}

local J = require( GetScriptDirectory()..'/FunLib/jmz_func')
local Item = require( GetScriptDirectory()..'/FunLib/aba_item')

local botName = bot:GetUnitName();

local targetUnit = nil;

local towerCreepMode = false;
local towerCreep = nil;
local towerTime =  0;
local towerCreepTime = 0;

local beInitDone = false
local IsSupport = false
local IsHeroCore = false
local beFirstStop = false
local bePvNMode = false

local DroppedShardTime = -90
local DroppedCheeseTime = -90
local SwappedCheeseTime = -90
local SwappedRefresherShardTime = -90
local PickedItem = nil

local ShouldAttackSpecialUnit = false
local SpecialUnitTarget = nil

local shouldHarass = false
local harassTarget = nil

local ShouldTryDispersingFromSpells = false

local ShouldRetreatWhenTowerTargeted = false
local RetreatWhenTowerTargetedTime = 0

local ShouldHelpWhenCoreIsTargeted = false

local TormentorLocation

function GetDesire()
	TormentorLocation = J.GetTormentorLocation(GetTeam())

	if not beInitDone
	then
		beInitDone = true
		bePvNMode = J.Role.IsPvNMode()
		IsHeroCore = J.IsCore(bot)
		IsSupport = not J.IsCore(bot)
	end

	local nDesire = 0

	-- -- Print Skills Pos
	-- if J.GetPosition(bot) == 5 and GetTeam() == TEAM_RADIANT
	-- then
	-- 	local a = J.Skill.GetAbilityList(GetTeamMember(1))
	-- 	for i = 1, #a do print(i, a[i]) end
	-- end

	-- Should not retreat if under Wraith King's scepter
	if bot:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
	then
		targetUnit = X.WeakestUnitCanBeAttacked(true, true, bot:GetCurrentVisionRange(), bot)
		if targetUnit ~= nil
		then
			bot:SetTarget(targetUnit)
			return BOT_ACTION_DESIRE_ABSOLUTE * 1.5
		end
	end

	ShouldRetreatWhenTowerTargeted = X.ConsiderRetreatWhenTowerTargeted()
	if  ShouldRetreatWhenTowerTargeted
	and DotaTime() < RetreatWhenTowerTargetedTime + 3.5
	then
		return BOT_ACTION_DESIRE_VERYHIGH
	end

	-- Consider help nearby core that's being targeted
	targetUnit, ShouldHelpWhenCoreIsTargeted = X.ConsiderHelpWhenCoreIsTargeted()
	if ShouldHelpWhenCoreIsTargeted
	then
		bot:SetTarget(targetUnit)
		return BOT_ACTION_DESIRE_ABSOLUTE
	end

	nDesire = X.ConsiderHarassInLaningPhase()
	if nDesire > 0
	then
		return nDesire
	end

	if not bot:IsAlive() or bot:GetCurrentActionType() == BOT_ACTION_TYPE_DELAY then
		return BOT_MODE_DESIRE_NONE
	end

	ShouldAttackSpecialUnit = CanAttackSpecialUnit()
	if ShouldAttackSpecialUnit
	then
		return BOT_ACTION_DESIRE_VERYHIGH
	end

	-- Disperse from Lich, Jakiro Ultimate
	ShouldTryDispersingFromSpells = X.ConsiderDispersingFromSpells()
	if ShouldTryDispersingFromSpells
	then
		return BOT_MODE_DESIRE_ABSOLUTE * 0.98
	end

	-- Pickup Neutral Item Tokens
	nDesire = TryPickupDroppedNeutralItemTokens()
	if nDesire > 0
	then
		return nDesire
	end

	-- Pickup Roshan Dropped Items
	nDesire = TryPickupRefresherShard()
	if nDesire > 0
	then
		return nDesire
	end

	nDesire = TryPickupCheese()
	if nDesire > 0
	then
		return nDesire
	end

	SwapSmokeSupport()

	TrySwapInvItemForCheese()

	TrySwapInvItemForRefresherShard()

	if J.Role['bStopAction'] then return 2.0 end

	if IsHeroCore
	then
		local botTarget, targetDesire = X.CarryFindTarget()
		if botTarget ~= nil
		then
			targetUnit = botTarget
			bot:SetTarget(botTarget)
			return targetDesire
		end
	end

	if IsSupport
	then
		local botTarget, targetDesire = X.SupportFindTarget()
		if botTarget ~= nil
		then
			targetUnit = botTarget
			bot:SetTarget(botTarget)
			return targetDesire
		end
	end

	if bot:IsAlive() and bot:DistanceFromFountain() > 4600
	then
		if towerTime ~= 0 and X.IsValid(towerCreep)
			and DotaTime() < towerTime + towerCreepTime
		then
			return BOT_MODE_DESIRE_ABSOLUTE *0.9;
		else
			towerTime = 0;
			towerCreepMode = false;
		end

		towerCreepTime,towerCreep = X.ShouldAttackTowerCreep(bot);
		if towerCreepTime ~= 0 and towerCreep ~= nil
		then
			if towerTime == 0 then 
				towerTime = DotaTime(); 
				towerCreepMode = true;
			end
			bot:SetTarget(towerCreep);
			return BOT_MODE_DESIRE_ABSOLUTE *0.9;
		end
	end
	
	
	return 0.0;
	
end


function OnStart()
	
	
end

function OnEnd()
	PickedItem = nil
	towerTime = 0
	towerCreepMode = false
	bot:SetTarget(nil)
	harassTarget = nil
end


function Think()
	if J.CanNotUseAction(bot) then return end

	if  shouldHarass
	and harassTarget ~= nil
	then
		bot:Action_AttackUnit(harassTarget, true)
		return
	end

	if  ShouldAttackSpecialUnit
	and SpecialUnitTarget ~= nil
	then
		bot:Action_AttackUnit(SpecialUnitTarget, true)
		return
	end

	-- Disperse from Lich, Jakiro Ultimate
	if ShouldTryDispersingFromSpells
	then
		bot:Action_MoveToLocation(J.GetTeamFountain() + RandomVector(1000))
		return
	end

	if ShouldRetreatWhenTowerTargeted
	then
		bot:ActionPush_MoveToLocation(J.GetTeamFountain() + RandomVector(300))
		return
	end

	if towerCreepMode
	then
		bot:Action_AttackUnit(towerCreep, true)
		return
	end

	if PickedItem ~= nil
	then
		if GetUnitToLocationDistance(bot, PickedItem.location) > 100
		then
			bot:Action_MoveToLocation(PickedItem.location)
			return
		else
			bot:Action_PickUpItem(PickedItem.item)
			return
		end
	end

	if  (IsHeroCore or IsSupport)
	and targetUnit ~= nil and not targetUnit:IsNull() and targetUnit:IsAlive()
	then
		bot:Action_AttackUnit(targetUnit, true)
		return
	end
end

function X.SupportFindTarget()
	
	if X.CanNotUseAttack(bot) or DotaTime() < 0 then return nil,0 end
	
	local IsModeSuitHit = X.IsModeSuitToHitCreep(bot);
	local nAttackRange = bot:GetAttackRange() + 50;
	if nAttackRange > 1200 then nAttackRange = 1200 end
	
	
	local nTarget = J.GetProperTarget(bot);	
	local botHP   = bot:GetHealth()/bot:GetMaxHealth();
	local botMode = bot:GetActiveMode();
	local botLV   = bot:GetLevel();
	local botAD   = bot:GetAttackDamage();
	local botBAD  = X.GetAttackDamageToCreep(bot) - 1; 
	
	
	if X.CanBeAttacked(nTarget) and nTarget == targetUnit
	   and GetUnitToUnitDistance(bot,nTarget) <= 1600
	then
	    if nTarget:GetTeam() == bot:GetTeam() 
		then
			if nTarget:GetHealth() > X.GetLastHitHealth(bot,nTarget)
			then
				return nTarget,BOT_MODE_DESIRE_VERYHIGH * 1.08;
			end
			
			return nTarget,BOT_MODE_DESIRE_VERYHIGH * 1.04;
		end	
		
		if nTarget:IsCourier() 
			and GetUnitToUnitDistance(bot,nTarget) <= nAttackRange + 300
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE *1.5;
		end
		
		if nTarget:IsHero() 
		   and (bot:GetCurrentMovementSpeed() < 300 or botLV >= 25)
		then	
		    return nTarget,BOT_MODE_DESIRE_ABSOLUTE *1.2;
		end
		
		if not nTarget:IsHero() 
		   and GetUnitToUnitDistance(bot,nTarget) < nAttackRange +50
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.98;
		end
		
		if not nTarget:IsHero() 
		   and GetUnitToUnitDistance(bot,nTarget) > nAttackRange +300
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.7;
		end
		
		return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.96;
	end
	
	
	local enemyCourier = X.GetEnemyCourier(bot, nAttackRange + botLV * 2 + 20 );
	if enemyCourier ~= nil 
		and not enemyCourier:IsAttackImmune()
		and not enemyCourier:IsInvulnerable()
	then
		return enemyCourier,BOT_MODE_DESIRE_ABSOLUTE * 1.5; 
	end		
	
	
	if botMode == BOT_MODE_RETREAT
	   and botLV > 9
	   and not X.CanBeInVisible(bot)
	   and X.ShouldNotRetreat(bot)
	then
	    nTarget = X.WeakestUnitCanBeAttacked(true, true, nAttackRange + 50, bot)
		if nTarget ~= nil 
		then 
		    return nTarget,BOT_MODE_DESIRE_ABSOLUTE * 1.09; 
		end			    
	end
		
	
	local attackDamage = botBAD - 1;
	if  IsModeSuitHit
		and not X.HasHumanAlly( bot )
		and ( botHP > 0.5 or not bot:WasRecentlyDamagedByAnyHero(2.0) )
	then
		local nBonusRange = 400;
		if botLV > 12 then nBonusRange = 300; end
		if botLV > 20 then nBonusRange = 200; end

		nTarget = X.GetNearbyLastHitCreep(false, true, attackDamage, nAttackRange + nBonusRange, bot); -----**************
		if nTarget ~= nil 
		then		
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE; 
		end		
		
		local nEnemyTowers = bot:GetNearbyTowers(nAttackRange + 150,true);
		if X.CanBeAttacked(nEnemyTowers[1])
		   and J.IsWithoutTarget(bot)
		   and X.IsLastHitCreep(nEnemyTowers[1],botAD * 2)
		then 
			return nEnemyTowers[1],BOT_MODE_DESIRE_ABSOLUTE; 
		end	
		
		local nNeutrals = bot:GetNearbyNeutralCreeps(nAttackRange + 150);
		local nAllies = bot:GetNearbyHeroes(1300,false,BOT_MODE_NONE); -----***************
		if J.IsWithoutTarget(bot)
			and botMode ~= BOT_MODE_FARM 
			and #nNeutrals > 0
			and #nAllies <= 1 ----******************
		then			
			for i = 1,#nNeutrals
			do	
				if X.CanBeAttacked(nNeutrals[i])
					and not X.IsAllysTarget(nNeutrals[i])
					and not J.IsTormentor(nNeutrals[i])
					and not J.IsRoshan(nNeutrals[i])
					and X.IsLastHitCreep(nNeutrals[i],attackDamage)
				then 
					return nNeutrals[i],BOT_MODE_DESIRE_ABSOLUTE; 
				end	
			end
		end
	end
	
	
	local denyDamage = botAD + 3
	local nNearbyEnemyHeroes = bot:GetNearbyHeroes(750,true,BOT_MODE_NONE); -----------*************
	if  IsModeSuitHit 
		and bot:GetLevel() <= 8
		and bot:GetNetWorth() < 13998   -----------*************
		and ( botHP > 0.38 or not bot:WasRecentlyDamagedByAnyHero(3.0))
		and (nNearbyEnemyHeroes[1] == nil or nNearbyEnemyHeroes[1]:GetLevel() < 10) -----------*************
		and bot:DistanceFromFountain() > 3800
		and J.GetDistanceFromEnemyFountain(bot) > 5000
	then
		local nWillAttackCreeps = X.GetExceptRangeLastHitCreep(true, attackDamage *1.5, 0, nAttackRange +60, bot);
		if nWillAttackCreeps == nil 
			or denyDamage > 130
			or not X.IsOthersTarget(nWillAttackCreeps)
			or not X.IsMostAttackDamage(bot)
		then
			nTarget = X.GetNearbyLastHitCreep(false, false, denyDamage, nAttackRange +300, bot); 
			if nTarget ~= nil then 	
				return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.97; 
			end		
		end
		
		local nAllyTowers = bot:GetNearbyTowers(nAttackRange + 300,false);
		if J.IsWithoutTarget(bot)
		   and #nAllyTowers > 0
		then
			if X.CanBeAttacked(nAllyTowers[1])
			   and J.GetHP(nAllyTowers[1]) < 0.08
			   and X.IsLastHitCreep(nAllyTowers[1],denyDamage * 3)
			then 
				return nAllyTowers[1],BOT_MODE_DESIRE_ABSOLUTE; 
			end	
		end
	end
		
	
	if  IsModeSuitHit 
		and bot:GetLevel() <= 7
		and X.CanAttackTogether(bot)
		and (nNearbyEnemyHeroes[1] == nil or nNearbyEnemyHeroes[1]:GetLevel() < 12)
		and bot:DistanceFromFountain() > 3800
		and J.GetDistanceFromEnemyFountain(bot) > 5000
	 then
	     local nAllies = bot:GetNearbyHeroes(1200,false,BOT_MODE_NONE);
		 local nNum = X.GetCanTogetherCount(nAllies)
		 local centerAlly = X.GetMostDamageUnit(nAllies);
		 if centerAlly ~= nil and nNum >= 2
		 then
			 
			local nTowerCreeps = centerAlly:GetNearbyLaneCreeps(1600,true);
			local nAllyTower = bot:GetNearbyTowers(1400,false);
			if(nAllyTower[1] ~= nil and nAllyTower[1]:GetAttackTarget() ~= nil)
			then
				local nTowerDamage = nAllyTower[1]:GetAttackDamage();
				local nTowerTarget = nAllyTower[1]:GetAttackTarget();
				for _,creep in pairs(nTowerCreeps)
				do
					if  nTowerTarget == creep
						and X.CanBeAttacked(creep)
						and creep:GetHealth() < X.GetLastHitHealth(nAllyTower[1],creep)
						and creep:GetHealth() > X.GetLastHitHealth(bot,creep)
					then
						local togetherDamage = 0;
						local togetherCount = 0;
						for _,ally in pairs(nAllies)
						do
							if X.CanAttackTogether(ally)
								and GetUnitToUnitDistance(ally,creep) <= ally:GetAttackRange() +50
							then
								togetherDamage = ally:GetAttackDamage() + togetherDamage;
								togetherCount =  togetherCount +1;
							end
						end
						if X.IsLastHitCreep(creep,togetherDamage)
						   and togetherCount >= 2
						   and GetUnitToUnitDistance(bot,creep) <= bot:GetAttackRange() +50
						then
							return creep,BOT_MODE_DESIRE_ABSOLUTE;
						end
					end
				end
		    end
			
			local nWillAttackCreeps = X.GetExceptRangeLastHitCreep(true, centerAlly:GetAttackDamage() * 1.2, 0, 800, centerAlly);
			if nWillAttackCreeps == nil 
				or not X.IsOthersTarget(nWillAttackCreeps)
			then				
				local nDenyCreeps = centerAlly:GetNearbyCreeps(1600,false);
				for _,creep in pairs(nDenyCreeps)
				do
					if X.CanBeAttacked(creep)
					and creep:GetHealth()/creep:GetMaxHealth() < 0.5
					and not X.IsLastHitCreep(creep,denyDamage)
					and not J.IsTormentor(creep)
					and not J.IsRoshan(creep)
					then
						local togetherDamage = 0;
						local togetherCount = 0;
						for _,ally in pairs(nAllies)
						do
							if X.CanAttackTogether(ally)
								and GetUnitToUnitDistance(ally,creep) <= ally:GetAttackRange() + 150 
							then
								togetherDamage = ally:GetAttackDamage() + togetherDamage;
								togetherCount = togetherCount +1;
							end
						end
						if X.IsLastHitCreep(creep,togetherDamage)
						   and togetherCount >= 2
						   and GetUnitToUnitDistance(bot,creep) <= bot:GetAttackRange() + 150
						then
							return creep,BOT_MODE_DESIRE_HIGH;
						end
					end
				end
			end
		end
		
	end
	
	local nNearbyEnemyHeroes = bot:GetNearbyHeroes(1600,true,BOT_MODE_NONE);
	local nEnemyLaneCreep = bot:GetNearbyLaneCreeps(1200, true);
	local nWillAttackCreeps = X.GetExceptRangeLastHitCreep(true, attackDamage *1.2, 0, nAttackRange + 120, bot);
	if  IsModeSuitHit
		and botLV >= 6  -----------*************
		and nNearbyEnemyHeroes[1] == nil
		and ( attackDamage > 108 or bot:GetSecondsPerAttack() < 0.7 ) -----------*************
		and ( nWillAttackCreeps == nil or not X.IsMostAttackDamage(bot) or not X.IsOthersTarget(nWillAttackCreeps))
	then
		
		local nEnemyTowers = bot:GetNearbyTowers(900,true);
		
		local nTwoHitCreeps = bot:GetNearbyLaneCreeps(nAttackRange +150, true);
		for _,creep in pairs(nTwoHitCreeps)
		do
			if X.CanBeAttacked(creep)
			   and not X.IsLastHitCreep(creep,attackDamage *1.2)
			   and not X.IsOthersTarget(creep)
			then
				local nAllyLaneCreep = bot:GetNearbyLaneCreeps(600, false);
				if X.IsLastHitCreep(creep,attackDamage *2)
				then
					return creep,BOT_MODE_DESIRE_ABSOLUTE;
				elseif X.IsLastHitCreep(creep,attackDamage *3 - 5) 
						and #nAllyLaneCreep == 0 and botLV >= 3						
					then
						return creep,BOT_MODE_DESIRE_ABSOLUTE *0.9;
				end
			end
		end
				
		if  bot:DistanceFromFountain() > 3800 
			and not bePvNMode and bot:GetLevel() <= 6
			and J.GetDistanceFromEnemyFountain(bot) > 5000
			and nEnemyTowers[1] == nil
			and bot:GetNetWorth() < 19800
			and denyDamage > 110
		then
			local nTwoHitDenyCreeps = bot:GetNearbyCreeps(nAttackRange +120, false);
			for _,creep in pairs(nTwoHitDenyCreeps)
			do
				if X.CanBeAttacked(creep)
				and creep:GetHealth()/creep:GetMaxHealth() < 0.5
				and X.IsLastHitCreep(creep,denyDamage *2)
				and ( not X.IsLastHitCreep(creep,denyDamage *1.2) or #nEnemyLaneCreep == 0 )
				and not X.IsOthersTarget(creep)
				and not J.IsTormentor(creep)
				and not J.IsRoshan(creep)
				then
					return creep,BOT_MODE_DESIRE_ABSOLUTE;
				end			
			end
		end	
		
	end	 
	 
    return nil,0;   
end	


function X.CarryFindTarget()
	
	if X.CanNotUseAttack(bot) or DotaTime() < 0 then return nil,0 end
	
	local IsModeSuitHit = X.IsModeSuitToHitCreep(bot);
	local nAttackRange = bot:GetAttackRange() + 50;
	if nAttackRange > 1170 then nAttackRange = 1170 end
	if botName == "npc_dota_hero_templar_assassin" then nAttackRange = nAttackRange + 100 end;
	
	
	local nTarget = J.GetProperTarget(bot);	
	local botHP   = bot:GetHealth()/bot:GetMaxHealth();
	local botMode = bot:GetActiveMode();
	local botLV   = bot:GetLevel();
	local botAD   = bot:GetAttackDamage() - 0.8;
	local botBAD  = X.GetAttackDamageToCreep(bot) - 1.2; 
	
	
	if  X.CanBeAttacked(nTarget) and nTarget == targetUnit
		and GetUnitToUnitDistance(bot,nTarget) <= 1600
	then
	    if nTarget:GetTeam() == bot:GetTeam() 
		then
			if nTarget:GetHealth() > X.GetLastHitHealth(bot,nTarget)
			then
				return nTarget,BOT_MODE_DESIRE_VERYHIGH * 1.08;
			end
			
			return nTarget,BOT_MODE_DESIRE_VERYHIGH * 1.04;
		end	
		
		if nTarget:IsCourier() 
			and GetUnitToUnitDistance(bot,nTarget) <= nAttackRange + 300
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE *1.5;
		end
		
		if nTarget:IsHero() 
		   and (bot:GetCurrentMovementSpeed() < 300 or botLV >= 25)
		then
			if botName == "npc_dota_hero_antimage"
			then
				local bAbility = bot:GetAbilityByName("antimage_blink");
				if bAbility ~= nil and bAbility:IsFullyCastable()
				then
					return nil,BOT_MODE_DESIRE_NONE;
				end
			end		
		    return nTarget,BOT_MODE_DESIRE_ABSOLUTE *1.2;
		end
		
		if not nTarget:IsHero() 
		   and GetUnitToUnitDistance(bot,nTarget) < nAttackRange +50
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.98;
		end
		
		if not nTarget:IsHero() 
		   and GetUnitToUnitDistance(bot,nTarget) > nAttackRange +300
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.7;
		end
		
		return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.96;
	end
	
	
	if bot:HasModifier('modifier_phantom_lancer_phantom_edge_boost')
	then
		return nil,0 
	end
	
	
	local enemyCourier = X.GetEnemyCourier(bot, nAttackRange + botLV * 2 + 30);
	if enemyCourier ~= nil
		and not enemyCourier:IsAttackImmune()
		and not enemyCourier:IsInvulnerable()
	then
		return enemyCourier,BOT_MODE_DESIRE_ABSOLUTE * 1.5; 
	end		
	
	
	if botMode == BOT_MODE_RETREAT
	   and botName ~= "npc_dota_hero_bristleback"
	   and botLV > 9
	   and not X.CanBeInVisible(bot)
	   and X.ShouldNotRetreat(bot)
	then
	    nTarget = X.WeakestUnitCanBeAttacked(true, true, nAttackRange + 50, bot)
		if nTarget ~= nil 
		then 
		    return nTarget,BOT_MODE_DESIRE_ABSOLUTE * 1.09; 
		end			    
	end
		
	
	local cItem = J.IsItemAvailable("item_echo_sabre")
    if  cItem ~= nil and (cItem:IsFullyCastable() or cItem:GetCooldownTimeRemaining() < bot:GetAttackPoint() +0.8)
		and IsModeSuitHit
		and (botHP > 0.35 or not bot:WasRecentlyDamagedByAnyHero(1.0))
	then
		
		local echoDamage = botBAD *2;
		
		if (cItem:IsFullyCastable() or cItem:GetCooldownTimeRemaining() <  bot:GetAttackPoint())
		then
			nTarget = X.GetNearbyLastHitCreep(true, true, echoDamage, 350, bot);
			if nTarget ~= nil then return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.98; end		
		end
		
		local nEnemyTowers = bot:GetNearbyTowers(1000,true);			
		if (cItem:IsFullyCastable() or cItem:GetCooldownTimeRemaining() <  bot:GetAttackPoint() +0.8)
			and #nEnemyTowers == 0
		then
			for i=400, 580, 60 do
				nTarget = X.GetExceptRangeLastHitCreep(true, echoDamage, 350, i, bot);
				if nTarget ~= nil 
				   then return nTarget,BOT_MODE_DESIRE_HIGH; end					
			end
		end
	end
	
	
	local attackDamage = botBAD;
	if  IsModeSuitHit
		and not X.HasHumanAlly( bot )
		and ( botHP > 0.5 or not bot:WasRecentlyDamagedByAnyHero(2.0))
	then
		local nBonusRange = 430;
		if botLV > 12 then nBonusRange = 380; end
		if botLV > 20 then nBonusRange = 330; end

		nTarget = X.GetNearbyLastHitCreep(true, true, attackDamage, nAttackRange + nBonusRange, bot); 
		if nTarget ~= nil 
		then
			return nTarget,BOT_MODE_DESIRE_ABSOLUTE; 
		end	
	end
		
	
	local denyDamage = botAD + 3
	local nNearbyEnemyHeroes = bot:GetNearbyHeroes(650,true,BOT_MODE_NONE);
	if  IsModeSuitHit 
		and ( botHP > 0.38 or not bot:WasRecentlyDamagedByAnyHero(3.0))
		and (nNearbyEnemyHeroes[1] == nil or nNearbyEnemyHeroes[1]:GetLevel() < 12)
		and bot:DistanceFromFountain() > 3800
		and J.GetDistanceFromEnemyFountain(bot) > 5000
	then
	
		if bot:GetLevel() <= 8
		then
			local nWillAttackCreeps = X.GetExceptRangeLastHitCreep(true, attackDamage *1.5, 0, nAttackRange +60, bot);
			if nWillAttackCreeps == nil 
				or denyDamage > 130
				or not X.IsOthersTarget(nWillAttackCreeps)
				or not X.IsMostAttackDamage(bot)
			then
				nTarget = X.GetNearbyLastHitCreep(false, false, denyDamage, nAttackRange +300, bot); 
				if nTarget ~= nil then 	
					return nTarget,BOT_MODE_DESIRE_ABSOLUTE *0.97; 
				end		
			end
		end
		

		local nAllyTowers = bot:GetNearbyTowers(nAttackRange + 300, false);
		if J.IsWithoutTarget(bot)
		   and #nAllyTowers > 0
		then
			if X.CanBeAttacked(nAllyTowers[1])
			   and J.GetHP(nAllyTowers[1]) < 0.05
			   and X.IsLastHitCreep(nAllyTowers[1],denyDamage * 3)
			then 
				return nAllyTowers[1],BOT_MODE_DESIRE_ABSOLUTE; 
			end	
		end
	end
		
	if  IsModeSuitHit 
		and bot:GetLevel() <= 8
		and X.CanAttackTogether(bot)
		and (nNearbyEnemyHeroes[1] == nil or nNearbyEnemyHeroes[1]:GetLevel() < 12)
		and bot:DistanceFromFountain() > 3800
		and J.GetDistanceFromEnemyFountain(bot) > 5000
	 then
	     local nAllies = bot:GetNearbyHeroes(1200,false,BOT_MODE_NONE);
		 local nNum = X.GetCanTogetherCount(nAllies)
		 local centerAlly = X.GetMostDamageUnit(nAllies);
		 if centerAlly ~= nil and nNum >= 2
		 then
			 
			local nTowerCreeps = centerAlly:GetNearbyLaneCreeps(1600,true);
			local nAllyTower = bot:GetNearbyTowers(1400,false);
			if(nAllyTower[1] ~= nil and nAllyTower[1]:GetAttackTarget() ~= nil)
			then
				local nTowerDamage = nAllyTower[1]:GetAttackDamage();
				local nTowerTarget = nAllyTower[1]:GetAttackTarget();
				for _,creep in pairs(nTowerCreeps)
				do
					if  nTowerTarget == creep
						and X.CanBeAttacked(creep)
						and creep:GetHealth() < X.GetLastHitHealth(nAllyTower[1],creep)
						and creep:GetHealth() > X.GetLastHitHealth(bot,creep)
					then
						local togetherDamage = 0;
						local togetherCount = 0;
						for _,ally in pairs(nAllies)
						do
							if X.CanAttackTogether(ally)
								and GetUnitToUnitDistance(ally,creep) <= ally:GetAttackRange() +50
							then
								togetherDamage = ally:GetAttackDamage() + togetherDamage;
								togetherCount =  togetherCount +1;
							end
						end
						if X.IsLastHitCreep(creep,togetherDamage)
						   and togetherCount >= 2
						   and GetUnitToUnitDistance(bot,creep) <= bot:GetAttackRange() +50
						then
							return creep,BOT_MODE_DESIRE_ABSOLUTE;
						end
					end
				end
		    end
			
			local nWillAttackCreeps = X.GetExceptRangeLastHitCreep(true, centerAlly:GetAttackDamage() *1.2, 0, 800, centerAlly);
			if nWillAttackCreeps == nil 
				or not X.IsOthersTarget(nWillAttackCreeps)
			then				
				local nDenyCreeps = centerAlly:GetNearbyCreeps(1600,false);
				for _,creep in pairs(nDenyCreeps)
				do
					if X.CanBeAttacked(creep)
					and creep:GetHealth()/creep:GetMaxHealth() < 0.5
					and not X.IsLastHitCreep(creep,denyDamage)
					and not J.IsTormentor(creep)
					and not J.IsRoshan(creep)
					then
						local togetherDamage = 0;
						local togetherCount = 0;
						for _,ally in pairs(nAllies)
						do
							if X.CanAttackTogether(ally)
								and GetUnitToUnitDistance(ally,creep) <= ally:GetAttackRange() + 150 
							then
								togetherDamage = ally:GetAttackDamage() + togetherDamage;
								togetherCount = togetherCount +1;
							end
						end
						if X.IsLastHitCreep(creep,togetherDamage)
						   and togetherCount >= 2
						   and GetUnitToUnitDistance(bot,creep) <= bot:GetAttackRange() + 150
						then
							return creep,BOT_MODE_DESIRE_HIGH;
						end
					end
				end
			end
		end
		
	end
	
	
	local nNearbyEnemyHeroes = bot:GetNearbyHeroes(1600,true,BOT_MODE_NONE);
	local nEnemyLaneCreep = bot:GetNearbyLaneCreeps(1200, true);
	local nWillAttackCreeps = X.GetExceptRangeLastHitCreep(true, attackDamage *1.2, 0, nAttackRange + 120, bot);
	if  IsModeSuitHit
		and botLV >= 8
		and nNearbyEnemyHeroes[1] == nil
		and ( attackDamage > 118 or bot:GetSecondsPerAttack() < 0.7 )
		and ( nWillAttackCreeps == nil or not X.IsMostAttackDamage(bot) or not X.IsOthersTarget(nWillAttackCreeps))
	then
		
		local nEnemyTowers = bot:GetNearbyTowers(900,true);
		if botName ~= "npc_dota_hero_templar_assassin"
		then
		
			local nTwoHitCreeps = bot:GetNearbyLaneCreeps(nAttackRange +150, true);
			for _,creep in pairs(nTwoHitCreeps)
			do
				if X.CanBeAttacked(creep)
				   and not X.IsLastHitCreep(creep,attackDamage *1.2)
				   and not X.IsOthersTarget(creep)
				then
					local nAllyLaneCreep = bot:GetNearbyLaneCreeps(600, false);
					if X.IsLastHitCreep(creep,attackDamage *2)
					then
						return creep,BOT_MODE_DESIRE_ABSOLUTE;
					elseif X.IsLastHitCreep(creep,attackDamage *3 - 5) 
							and #nAllyLaneCreep == 0 and botLV >= 3						
						then
							return creep,BOT_MODE_DESIRE_ABSOLUTE *0.9;
					end
				end
			end
			
		end
		
		if  bot:DistanceFromFountain() > 3800 
			and not bePvNMode and bot:GetLevel() <= 6
			and J.GetDistanceFromEnemyFountain(bot) > 5000
			and nEnemyTowers[1] == nil
			and bot:GetNetWorth() < 19800
			and denyDamage > 110
		then
			local nTwoHitDenyCreeps = bot:GetNearbyCreeps(nAttackRange +120, false);
			for _,creep in pairs(nTwoHitDenyCreeps)
			do
				if X.CanBeAttacked(creep)
				and creep:GetHealth()/creep:GetMaxHealth() < 0.5
				and X.IsLastHitCreep(creep,denyDamage *2)
				and ( not X.IsLastHitCreep(creep,denyDamage *1.2) or #nEnemyLaneCreep == 0 )
				and not X.IsOthersTarget(creep)
				and not J.IsTormentor(creep)
				and not J.IsRoshan(creep)
				then
					return creep,BOT_MODE_DESIRE_ABSOLUTE;
				end			
			end
		end	
		

		local nEnemysCreeps = bot:GetNearbyCreeps(1600,true)
		local nAttackAlly = J.GetSpecialModeAllies(bot, 2500, BOT_MODE_ATTACK);
		local nTeamFightLocation = J.GetTeamFightLocation(bot);
		local nDefendLane,nDefendDesire = J.GetMostDefendLaneDesire();
		if  X.CanBeAttacked(nEnemysCreeps[1])
		and bot:GetHealth() > 300
		and not X.IsAllysTarget(nEnemysCreeps[1])
		and not J.IsRoshan(nEnemysCreeps[1])
		and (nEnemysCreeps[1]:GetTeam() == TEAM_NEUTRAL or attackDamage > 110)
		and ( not nEnemysCreeps[1]:IsAncientCreep() or attackDamage > 150 )
		and ( not J.IsKeyWordUnit("warlock", nEnemysCreeps[1]) or J.GetHP(bot) > 0.58 )		
		and ( nTeamFightLocation == nil or GetUnitToLocationDistance(bot,nTeamFightLocation) >= 3000 )
		and ( nDefendDesire <= 0.8 )
		and botMode ~= BOT_MODE_FARM
		and botMode ~= BOT_MODE_RUNE
		and botMode ~= BOT_MODE_LANING
		and botMode ~= BOT_MODE_ASSEMBLE
		and botMode ~= BOT_MODE_SECRET_SHOP
		and botMode ~= BOT_MODE_SIDE_SHOP
		and botMode ~= BOT_MODE_WARD
		and GetRoshanDesire() < BOT_MODE_DESIRE_HIGH	
		and not bot:WasRecentlyDamagedByAnyHero(2.0)
		and bot:GetAttackTarget() == nil
		and botLV >= 10
		and #nAttackAlly == 0
		and #nEnemyTowers == 0
		and not J.IsTormentor(nEnemysCreeps[1])
		and not J.IsRoshan(nEnemysCreeps[1])
		then
		
			if nEnemysCreeps[1]:GetTeam() == TEAM_NEUTRAL 
			   and J.IsInRange(bot, nEnemysCreeps[1], nAttackRange + 100)
			   and ( #nEnemysCreeps <= 2 
			         or attackDamage > 220 
					 or botName == "npc_dota_hero_antimage" )
			then
				J.Role['availableCampTable'] = X.UpdateCommonCamp(nEnemysCreeps[1], J.Role['availableCampTable']);
			end
			
			return nEnemysCreeps[1],BOT_MODE_DESIRE_ABSOLUTE;
		end
		

		if bot:GetHealth() > 160 
		   and J.IsWithoutTarget(bot)
		then
			local nNeutrals = bot:GetNearbyNeutralCreeps(nAttackRange + 150);
			if #nNeutrals > 0
			   and botMode ~= BOT_MODE_FARM 
			then			
				for i = 1,#nNeutrals
				do	
					if X.CanBeAttacked(nNeutrals[i])
						and not X.IsAllysTarget(nNeutrals[i])
						and not J.IsTormentor(nNeutrals[i])
						and not J.IsRoshan(nNeutrals[i])
						and X.IsLastHitCreep(nNeutrals[i],attackDamage * 2)
					then 
						return nNeutrals[i],BOT_MODE_DESIRE_ABSOLUTE; 
					end	
				end
			end
		end			
	end	 
	 
    return nil,0;  
end	


function X.IsValid(nUnit)
	
	return nUnit ~= nil and not nUnit:IsNull() and nUnit:IsAlive() and nUnit:CanBeSeen()
	
end


function X.GetAttackDamageToCreep( bot )
	
	if bot:GetItemSlotType(bot:FindItemSlot("item_quelling_blade")) == ITEM_SLOT_TYPE_MAIN
	then
		if bot:GetAttackRange() > 310 or bot:GetUnitName() == "npc_dota_hero_templar_assassin"
		then
			return bot:GetAttackDamage() + 4;
		else
			return bot:GetAttackDamage() + 8;
		end
	end
	
	if bot:FindItemSlot("item_bfury") >= 0
	then
		return bot:GetAttackDamage() + 15;
	end
	
	return bot:GetAttackDamage();
end


function X.CanNotUseAttack(bot)

	return not bot:IsAlive()
		   or J.HasQueuedAction( bot )
		   or bot:IsInvulnerable()
		   or bot:IsCastingAbility() 
		   or bot:IsUsingAbility() 
		   or bot:IsChanneling()  
	       or bot:IsStunned()
		   or bot:IsDisarmed()
		   or bot:IsHexed()
		   or bot:IsRooted()	
		   or X.WillBreakInvisible(bot)
end


function X.WillBreakInvisible(bot)

	local botName = bot:GetUnitName()
	
	local tInvisibleHeroIndex = {
		["npc_dota_hero_riki"] = true,
		["npc_dota_hero_phantom_assassin"] = true,
		["npc_dota_hero_templar_assassin"] = true,		
		["npc_dota_hero_bounty_hunter"] = true,		
	}

	if bot:IsInvisible() 
		and tInvisibleHeroIndex[botName] == nil
	then
		return true
	end

	return false
	
end


function X.CanBeAttacked(unit)
         
	return  unit ~= nil
			and unit:IsAlive()
			and unit:CanBeSeen()
			and not unit:IsNull()
			and not unit:IsAttackImmune()
			and not unit:IsInvulnerable()
			and not unit:HasModifier("modifier_fountain_glyph")
			and (unit:GetTeam() == GetTeam() 
					or not unit:HasModifier("modifier_crystal_maiden_frostbite") )
			and (unit:GetTeam() ~= GetTeam() 
			     or ( unit:GetUnitName() ~= "npc_dota_wraith_king_skeleton_warrior" 
					  and unit:GetHealth()/unit:GetMaxHealth() < 0.5 ) )

end


local courierFindCD = 0.1;
local lastFindTime = -90;
function X.GetEnemyCourier(bot,nRadius)
	
	if GetGameMode() == 23 then return nil end
	
	if J.GetDistanceFromEnemyFountain( bot ) < 1400 then return nil end
	
	if DotaTime() > lastFindTime + courierFindCD
	then
		lastFindTime = DotaTime();
		local units = GetUnitList(UNIT_LIST_ENEMIES)
		for _,u in pairs(units) 
		do
		   if u ~= nil 
			  and u:IsCourier()
		   then
			   if u:IsAlive()
				  and GetUnitToUnitDistance(bot,u) <= nRadius
				  and not u:IsInvulnerable()
				  and not u:IsAttackImmune()
				  and not u:HasModifier( 'modifier_fountain_aura' )
			   then
				   return u;
			   end
		   end
		end	
	end
	
	return nil;
	
end


function X.WeakestUnitCanBeAttacked(bHero, bEnemy, nRadius, bot)
	local units = {};
	local weakest = nil;
	local weakestHP = 6998;
	local realHP = 0;
	if nRadius > 1600 then nRadius = 1600 end;
	if bHero then
		units = bot:GetNearbyHeroes(nRadius, bEnemy, BOT_MODE_NONE);
	else	
		units = bot:GetNearbyLaneCreeps(nRadius, bEnemy);
	end
	
	for _,u in pairs(units) 
	do
		if X.CanBeAttacked(u)
		then

			realHP = u:GetHealth() / 1;
			
			if realHP < weakestHP
			then
				weakest = u;
				weakestHP = realHP;
			end			
		end
	end
	
	return weakest;
end


function X.WeakestUnitExceptRangeCanBeAttacked(bHero, bEnemy, nRange, nRadius, bot)
	local units = {};
	local weakest = nil;
	local weakestHP = 4999;
	local realHP = 0;
	if nRadius > 1600 then nRadius = 1600 end;
	
	if bHero then
		units = bot:GetNearbyHeroes(nRadius, bEnemy, BOT_MODE_NONE);
	else	
		units = bot:GetNearbyLaneCreeps(nRadius, bEnemy);
	end
	
	for _,u in pairs(units) do
		if  X.IsValid(u)
		and GetUnitToUnitDistance(bot,u) > nRange 
		and X.CanBeAttacked(u)
		and not u:HasModifier("modifier_crystal_maiden_frostbite")
		then
			realHP = u:GetHealth() / 1;
			
			if realHP < weakestHP
			then
				weakest = u;
				weakestHP = realHP;
			end			
		end
	end
	return weakest;
end


function X.GetSpecialDamageBonus(nDamage,nCreep,bot)

		
	return 0
end


function X.GetNearbyLastHitCreep(ignorAlly, bEnemy, nDamage, nRadius, bot)

	if nRadius > 1600 then nRadius = 1600 end;
	local nNearbyCreeps = bot:GetNearbyLaneCreeps(nRadius, bEnemy);
	local nDamageType = DAMAGE_TYPE_PHYSICAL;
	local botName = bot:GetUnitName();

	
	if  bEnemy 
		and botName == "npc_dota_hero_templar_assassin" --V bug
		and bot:HasModifier("modifier_templar_assassin_refraction_damage")
	then
		local cAbility = bot:GetAbilityByName( "templar_assassin_refraction" );
		local bonusDamage = cAbility:GetSpecialValueInt( 'bonus_damage' );
		nDamage = nDamage + bonusDamage;
	end
	
	if  bEnemy
		and botName == "npc_dota_hero_kunkka"
	then
		local cAbility = bot:GetAbilityByName( "kunkka_tidebringer" );
		if cAbility:IsFullyCastable() 
		then
			local bonusDamage = cAbility:GetSpecialValueInt( 'damage_bonus' );
			nDamage = nDamage + bonusDamage;
		end
	end
	
	
	for _,nCreep in pairs(nNearbyCreeps)
	do
		if X.CanBeAttacked(nCreep) and nCreep:GetHealth() < ( nDamage + 256 )
		   and ( ignorAlly or not X.IsAllysTarget(nCreep) )
		then
		
			local nAttackProDelayTime = J.GetAttackProDelayTime(bot,nCreep) ;
			
			if bEnemy and botName == "npc_dota_hero_antimage"
				and J.IsKeyWordUnit("ranged",nCreep)
			then
				local cAbility = bot:GetAbilityByName( "antimage_mana_break" );
				if cAbility:IsTrained()
				then
					local bonusDamage = 0.5 * cAbility:GetSpecialValueInt( 'mana_per_hit' );
					nDamage = nDamage + bonusDamage;
				end
			end
		
			
			local nRealDamage = nDamage * 1
				
			if J.WillKillTarget(nCreep,nRealDamage,nDamageType,nAttackProDelayTime)
			then
				return nCreep;
			end
		
		end
	end
	
	
	return nil;
end


function X.GetExceptRangeLastHitCreep(bEnemy,nDamage,nRange,nRadius,bot)
	
	local nCreep = X.WeakestUnitExceptRangeCanBeAttacked(false, bEnemy, nRange, nRadius, bot);
	local nDamageType = DAMAGE_TYPE_PHYSICAL;

	if X.IsValid(nCreep)
	then
		if not bEnemy and nCreep:GetHealth()/nCreep:GetMaxHealth() >= 0.5
		then return nil end	
	
		nDamage = nDamage * 1 ;

		local nAttackProDelayTime = J.GetAttackProDelayTime(bot,nCreep);
		
		if J.WillKillTarget(nCreep,nDamage,nDamageType,nAttackProDelayTime)
		then		
			return nCreep;
		end

	end

	return nil;
end


function X.IsLastHitCreep(nCreep,nDamage)
	
	if nCreep ~= nil and nCreep:IsAlive()
	then
		
		nDamage = nDamage * 1;
		
		if nCreep:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_PHYSICAL) + J.GetCreepAttackProjectileWillRealDamage(nCreep,0.66) > nCreep:GetHealth() +1
		then 
		    return true;
		end
		
	end
	 
	return false;
	
end


function X.GetLastHitHealth(bot,nCreep)
	
	if nCreep ~= nil and nCreep:IsAlive()
	then
	   
       local nDamage = X.GetAttackDamageToCreep(bot) * 1
		
	   return nCreep:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_PHYSICAL);
	end
	 
	return bot:GetAttackDamage();

end


function X.IsAllysTarget(unit)
	local bot = GetBot();
	local allies = bot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
	if #allies < 2 then return false end;
	
	for _,ally in pairs(allies) 
	do
		if  ally ~= bot
			and not ally:IsIllusion()
			and ( ally:GetTarget() == unit or ally:GetAttackTarget() == unit )
		then
			return true;
		end
	end
	return false;
end


function X.IsEnemysTarget(unit)
	local bot = GetBot();
	local enemys = bot:GetNearbyHeroes(1600,true,BOT_MODE_NONE);
	for _,enemy in pairs(enemys) 
	do
		if  X.IsValid(enemy) and J.GetProperTarget(enemy) == unit 
		then
			return true;
		end
	end
	return false;
end


function X.CanAttackTogether(bot)
   
   local allies = bot:GetNearbyHeroes(1200,false,BOT_MODE_NONE);
   local nNearbyEnemyHeroes = bot:GetNearbyHeroes(600,true,BOT_MODE_NONE);
   
   return bot ~= nil and bot:IsAlive()
		  and not bot:IsIllusion()
		  and J.GetProperTarget(bot) == nil
	      and #allies >= 2
		  and (nNearbyEnemyHeroes[1] == nil or nNearbyEnemyHeroes[1]:GetLevel() < 10)
   
end


function X.GetMostDamageUnit(nUnits)
	
	local mostAttackDamage = 0;
	local mostUnit = nil;
	for _,unit in pairs(nUnits)
	do
		if unit ~= nil and unit:IsAlive()
			and J.GetProperTarget(unit) == nil
			and unit:GetAttackDamage() > mostAttackDamage
		then
			mostAttackDamage = unit:GetAttackDamage();
			mostUnit = unit;
		end
	end
	
	return mostUnit;

end


function X.GetCanTogetherCount(nAllies)
	
	local nNum = 0;
	for _,ally in pairs(nAllies)
	do
		if X.IsValid(ally) and X.CanAttackTogether(ally)
		then
			nNum = nNum +1;
		end
	end
	
	return nNum;

end


function X.IsModeSuitToHitCreep(bot)

	local botMode = bot:GetActiveMode();
	local nEnemyHeroes = J.GetEnemyList(bot,750)

	if #nEnemyHeroes >= 3 
	   or (nEnemyHeroes[1] ~= nil and nEnemyHeroes[1]:GetLevel() >= 8 )
	then
		return false;
	end

	if bot:HasModifier("modifier_axe_battle_hunger")
	then
		local nEnemyLaneCreepList = bot:GetNearbyLaneCreeps( bot:GetAttackRange() + 180, true )
		if #nEnemyLaneCreepList > 0 then return true end
	end

	if bot:GetLevel() <= 3
		and botMode ~= BOT_MODE_EVASIVE_MANEUVERS
		and ( botMode ~= BOT_MODE_RETREAT or ( botMode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() < 0.78) )
	then
		return true;
	end

    return  botMode ~= BOT_MODE_ATTACK
			and botMode ~= BOT_MODE_EVASIVE_MANEUVERS
			and ( botMode ~= BOT_MODE_RETREAT or ( botMode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() < 0.68) )
end


function X.IsMostAttackDamage(bot)

	local nAllies = bot:GetNearbyHeroes(800,false,BOT_MODE_NONE);
	for _,ally in pairs(nAllies)
	do
		if ally ~= bot
			and not X.CanNotUseAttack(ally)
			and ally:GetAttackDamage() > bot:GetAttackDamage()
		then
			return false;
		end
	end

	return true;
end


function X.IsOthersTarget(nUnit)
	local bot = GetBot();

	if X.IsValid(nUnit)
	then
		if X.IsAllysTarget(nUnit)
		then
			return true;
		end
		
		if X.IsEnemysTarget(nUnit)
		then
			return true;
		end
		
		if X.IsCreepTarget(nUnit)
		then
			return true
		end
		
		local nTowers = bot:GetNearbyTowers(1600,true);
		for _,tower in pairs(nTowers)
		do
			if J.IsValidBuilding(tower)
			   and tower:GetAttackTarget() == nUnit
			then
				return true;
			end
		end
		
		local nTowers = bot:GetNearbyTowers(1600,false);
		for _,tower in pairs(nTowers)
		do
			if J.IsValidBuilding(tower)
			   and tower:GetAttackTarget() == nUnit
			then
				return true;
			end
		end
	end
	
	return false;

end


function X.IsCreepTarget(nUnit)
	local bot = GetBot();
	local nCreeps = bot:GetNearbyCreeps(1200,true);
	for _,creep in pairs(nCreeps)
	do
		if  X.IsValid(creep)
		and creep:GetAttackTarget() == nUnit
		and not J.IsTormentor(creep)
		and not J.IsRoshan(creep)
		then
			return true;
		end
	end
	
	local nCreeps = bot:GetNearbyCreeps(1200,false);
	for _,creep in pairs(nCreeps)
	do
		if X.IsValid(creep)
		and creep:GetAttackTarget() == nUnit
		and not J.IsTormentor(creep)
		and not J.IsRoshan(creep)
		then
			return true;
		end
	end

	return false;
end


function X.CanBeInVisible(bot)

	local nEnemyTowers = bot:GetNearbyTowers(800,true);
	if #nEnemyTowers > 0 
	   or bot:HasModifier("modifier_item_dustofappearance")
	then 
		return false;
	end

	if bot:IsInvisible()
	then
		return true;
	end

	local glimer = J.IsItemAvailable("item_glimmer_cape");
	if glimer ~= nil and glimer:IsFullyCastable() 
	then
		return true;			
	end
	
	local invissword = J.IsItemAvailable("item_invis_sword");
	if invissword ~= nil and invissword:IsFullyCastable() 
	then
		return true;			
	end
	
	local silveredge = J.IsItemAvailable("item_silver_edge");
	if silveredge ~= nil and silveredge:IsFullyCastable() 
	then
		return true;			
	end

	return false;
end


local lastUpdateTime = 0
function X.UpdateCommonCamp(creep, AvailableCamp)
	if lastUpdateTime < DotaTime() - 3.0
	then
		lastUpdateTime = DotaTime();
		for i = 1, #AvailableCamp
		do
			if GetUnitToLocationDistance(creep,AvailableCamp[i].cattr.location) < 500 then
				table.remove(AvailableCamp, i);
				return AvailableCamp;
			end
		end
	end
	return AvailableCamp;
end

local fLastReturnTime = 0
function X.ShouldAttackTowerCreep(bot)

	if X.CanNotUseAttack(bot) then return 0 end
	
	if  bot:GetLevel() > 2
		and bot:GetAnimActivity() == 1502
		and bot:GetTarget() == nil 
	    and bot:GetAttackTarget() == nil
		and X.IsModeSuitToHitCreep(bot)
		and J.GetHP(bot) > 0.38
		and not bot:WasRecentlyDamagedByAnyHero(2.0)
	then
		local nRange = bot:GetAttackRange() + 150;
		if nRange > 1250 then nRange = 1250 end; 
		local allyCreeps = bot:GetNearbyLaneCreeps(800,false);
		local enemyCreeps = bot:GetNearbyLaneCreeps(800,true);
		local attackTime = bot:GetSecondsPerAttack() * 0.75;
		local attackTarget = nil;
		local nEnemyHeroes = bot:GetNearbyHeroes(800,true,BOT_MODE_NONE);
		local nEnemyTowers = bot:GetNearbyTowers(nRange,true);
		local botMoveSpeed = bot:GetCurrentMovementSpeed();
		if X.CanBeAttacked(nEnemyTowers[1]) 
			and ( nEnemyTowers[1]:GetAttackTarget() ~= bot or J.GetHP(bot) > 0.8 )
			and not nEnemyTowers[1]:HasModifier('modifier_backdoor_protection')
			and #allyCreeps > 0
			and fLastReturnTime < DotaTime() - 1.0
		then
			attackTarget = nEnemyTowers[1];
			local nDist = GetUnitToUnitDistance(bot,attackTarget) - bot:GetAttackRange();
			if nDist > 0 then attackTime = attackTime + nDist/botMoveSpeed;end
			fLastReturnTime = DotaTime();
			return attackTime,attackTarget;
		end
		
		local nEnemyBarracks = bot:GetNearbyBarracks(nRange,true);
		if X.CanBeAttacked(nEnemyBarracks[1]) and #allyCreeps > 0
			and not nEnemyBarracks[1]:HasModifier('modifier_backdoor_protection')
		then
			attackTarget = nEnemyBarracks[1];
			local nDist = GetUnitToUnitDistance(bot,attackTarget) - bot:GetAttackRange();
			if nDist > 0 then attackTime = attackTime + nDist/botMoveSpeed;end
			return attackTime,attackTarget;
		end
		
		local nEnemyAncient = GetAncient(GetOpposingTeam())
		if J.IsInRange(bot,nEnemyAncient,nRange + 80)
			and X.CanBeAttacked(nEnemyAncient) and #enemyCreeps == 0
			and not nEnemyAncient:HasModifier('modifier_backdoor_protection')
			and( nEnemyHeroes[1] == nil 
			     or nEnemyHeroes[1]:GetAttackTarget() ~= bot 
				 or J.GetHP(bot) > 0.49 )
		then
			attackTarget = nEnemyAncient;
			local nDist = GetUnitToUnitDistance(bot,attackTarget) - bot:GetAttackRange();
			if nDist > 0 then attackTime = attackTime + nDist/botMoveSpeed;end
			return attackTime,attackTarget;
		end
	end		

	local nTowers = bot:GetNearbyTowers(1600,false);
	if nTowers[1] == nil
		or not X.IsMostAttackDamage(bot)
		or bot:GetLevel() > 12
	then
		return 0,nil;
	end
	
	if nTowers[1] ~= nil
		and nTowers[1]:GetAttackTarget() ~= nil
	then
		local towerTarget = nTowers[1]:GetAttackTarget();		
		local hAllyCreepList = bot:GetNearbyLaneCreeps(500,false);
		if not towerTarget:IsHero()
			and X.CanBeAttacked(towerTarget)
			and #hAllyCreepList == 0
			and not X.IsCreepTarget(towerTarget)
			and GetUnitToUnitDistance(bot,towerTarget) < bot:GetAttackRange() + 100
		then
			local towerRealDamage = X.GetLastHitHealth(nTowers[1],towerTarget);
			local botRealDamage =	X.GetLastHitHealth(bot,towerTarget);
			local attackTime = bot:GetSecondsPerAttack() -0.3;
			local towerTargetHealth = towerTarget:GetHealth();
			
			if  towerRealDamage > botRealDamage
				and towerTargetHealth > towerRealDamage 
				and towerTargetHealth % towerRealDamage > botRealDamage 
			then
				return attackTime,towerTarget;
			end			
		end
	end
	
	
	return 0,nil;
end

function X.ShouldNotRetreat(bot)
	if bot:HasModifier('modifier_item_satanic_unholy')
	or bot:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
	or (bot:HasModifier('modifier_abaddon_borrowed_time') and J.WeAreStronger(bot, 1000))
	or (bot:GetCurrentMovementSpeed() < 240 and not bot:HasModifier('modifier_arc_warden_spark_wraith_purge'))
	then
		return true
	end

	local nInRangeAllyAttack = bot:GetNearbyHeroes(1200, false, BOT_MODE_ATTACK)

    if nInRangeAllyAttack ~= nil
    then
        if  (bot:HasModifier('modifier_item_mask_of_madness_berserk') or bot:HasModifier('modifier_oracle_false_promise_timer'))
        and (#nInRangeAllyAttack >= 1 or J.GetHP(bot) > 0.6)
        then
            return true
        end

        if  bot:HasModifier('modifier_abaddon_borrowed_time')
        and #nInRangeAllyAttack >= 1
        then
            return true
        end
    end

	local nInRangeAlly = J.GetAllyList(bot, 800)
    if nInRangeAlly ~= nil and #nInRangeAlly <= 1
	then
	    return false
	end

	if (bot:GetUnitName() == 'npc_dota_hero_medusa' or bot:FindItemSlot('item_abyssal_blade') >= 0)
    and nInRangeAlly ~= nil and nInRangeAllyAttack ~= nil
    and #nInRangeAlly >= 3 and #nInRangeAllyAttack >= 1
	then
		return true
	end

	if  bot:GetUnitName() == 'npc_dota_hero_skeleton_king'
	and bot:GetLevel() >= 6 and #nInRangeAllyAttack >= 1
	then
		local Reincarnation = bot:GetAbilityByName('skeleton_king_reincarnation')
		if  Reincarnation:GetCooldownTimeRemaining() <= 1.0
        and bot:GetMana() >= 180
		then
			return true
		end
	end

	for _, allyHero in pairs(nInRangeAlly)
	do
		if  J.IsValidHero(allyHero)
        and allyHero ~= bot
		then
			if (J.GetHP(allyHero) > 0.88 and allyHero:GetLevel() >= 10 and not J.IsRetreating(allyHero))
            or (allyHero:HasModifier('modifier_black_king_bar_immune') or allyHero:IsMagicImmune())
            or (allyHero:HasModifier('modifier_item_mask_of_madness_berserk') and allyHero:GetAttackTarget() ~= nil)
            or allyHero:HasModifier('modifier_item_satanic_unholy')
            or allyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				return true
			end
		end
	end
end

local bHumanAlly = nil
function X.HasHumanAlly( bot )

	if bHumanAlly == false then return false end

	if bHumanAlly == nil 
	then
		local teamPlayerIDList = GetTeamPlayers( GetTeam() )
		for i = 1, #teamPlayerIDList
		do 
			if not IsPlayerBot( teamPlayerIDList[i] )
			then
				bHumanAlly = true
				break
			end
		end	
		if bHumanAlly ~= true then bHumanAlly = false end		
	end
	
	local allyHeroList = bot:GetNearbyHeroes( 900, false, BOT_MODE_NONE )
	for _, npcAlly in pairs( allyHeroList )
	do 
		if not npcAlly:IsBot()
		then
			return true
		end	
	end
	
	return false 
		
end

function CanAttackSpecialUnit()
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), bot:GetCurrentVisionRange())
	local nAttackRange = bot:GetAttackRange() + 200
	local nUnits = GetUnitList(UNIT_LIST_ENEMIES)

	for _, unit in pairs(nUnits)
	do
		if J.IsValid(unit)
		then
			if string.find(unit:GetUnitName(), 'clinkz_skeleton_archer')
			or string.find(unit:GetUnitName(), 'healing_ward')
			or string.find(unit:GetUnitName(), 'forged_spirit')
			or string.find(unit:GetUnitName(), 'grimstroke_ink_creature')
			or string.find(unit:GetUnitName(), 'ignis_fatuus')
			or string.find(unit:GetUnitName(), 'lone_druid_bear')
			or string.find(unit:GetUnitName(), 'lycan_wolf')
			or string.find(unit:GetUnitName(), 'observer_ward')
			or string.find(unit:GetUnitName(), 'phoenix_sun')
			or string.find(unit:GetUnitName(), 'plague_ward')
			or string.find(unit:GetUnitName(), 'rattletrap_cog')
			or string.find(unit:GetUnitName(), 'sentry_ward')
			or string.find(unit:GetUnitName(), 'tombstone')
			or string.find(unit:GetUnitName(), 'warlock_golem')
			or string.find(unit:GetUnitName(), 'weaver_swarm')
			or string.find(unit:GetUnitName(), 'zeus_cloud')
			then
				if unit:GetUnitName() == 'npc_dota_rattletrap_cog'
				then
					local cogsCount1 = J.GetPowerCogsCountInLoc(bot:GetLocation(), 800)
					local cogsCount2 = J.GetPowerCogsCountInLoc(bot:GetLocation(), 255)
					local isClockwerkInTeam = false
					for i = 1, 5
					do
						local allyHero = GetTeamMember(i)
						if  J.IsValidHero(allyHero)
						and allyHero:GetUnitName() == 'npc_dota_hero_rattletrap'
						then
							isClockwerkInTeam = true
							break
						end
					end

					if nInRangeEnemy ~= nil
					then
						if #nInRangeEnemy >= 1
						then
							local nInRangeEnemy2 = J.GetEnemiesNearLoc(bot:GetLocation(), 255)

							-- Is stuck inside?
							if cogsCount1 == 8 and cogsCount2 >= 4
							then
								if nInRangeEnemy2 ~= nil
								then
									if #nInRangeEnemy2 == 0
									or (J.IsRetreating(bot) and #nInRangeEnemy2 >= 1)
									then
										SpecialUnitTarget = unit
										return true
									end
								end
							end
						end

						if #nInRangeEnemy == 0
						then
							if cogsCount1 == 8 and cogsCount2 >= 4
							then
								if isClockwerkInTeam
								then
									SpecialUnitTarget = unit
									return true
								end
							else
								if not isClockwerkInTeam
								then
									SpecialUnitTarget = unit
									return true
								end
							end
						end
					end
				end

				if  GetUnitToUnitDistance(bot, unit) <= nAttackRange
				and J.CanBeAttacked(unit)
				then
					SpecialUnitTarget = unit
					return true
				end
			end
		end
	end

	return false
end

function X.ConsiderHarassInLaningPhase()
	if J.IsInLaningPhase()
	then
		local nModeDesire = bot:GetActiveModeDesire()
		local nInRangeAlly = bot:GetNearbyHeroes(700, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(700, true)
		local nAttackRange = bot:GetAttackRange()

		-- Harass
		local canLastHitCount = 0

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.GetHP(creep) <= 0.5
			then
				canLastHitCount = canLastHitCount + 1
			end
		end

		if  J.GetHP(bot) > 0.61
		and ((J.IsCore(bot) and canLastHitCount <= 1)
			or (not J.IsCore(bot)))
		then
			-- MK Range
			if nAttackRange < 300
			then
				nAttackRange = 300
			end

			nInRangeEnemy = bot:GetNearbyHeroes(nAttackRange, true, BOT_MODE_NONE)
			if  J.IsValidHero(nInRangeEnemy[1])
			and J.CanBeAttacked(nInRangeEnemy[1])
			and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
			and not J.IsRetreating(bot)
			and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				local nInRangeTower = bot:GetNearbyTowers(1600, true)

				if  nInRangeTower ~= nil
				and (#nInRangeTower == 0
					or (J.IsValidBuilding(nInRangeTower[1])
						and GetUnitToUnitDistance(bot, nInRangeTower[1]) > 700
						and GetUnitToUnitDistance(nInRangeEnemy[1], nInRangeTower[1]) > 700))
				and not bot:WasRecentlyDamagedByTower(1)
				then
					shouldHarass = true
					harassTarget = nInRangeEnemy[1]

					if (J.IsHumanPlayer(nInRangeEnemy[1]) or J.IsCore(nInRangeEnemy[1]))
					then
						return RemapValClamped(J.GetPosition(bot), 1, 5, 0.5, nModeDesire + 0.1)
					else
						return RemapValClamped(J.GetPosition(bot), 1, 5, 0.45, 0.6)
					end
				else
					shouldHarass = false
				end
			end
		end
	end

	shouldHarass = false

	return BOT_ACTION_DESIRE_NONE
end

function TryPickupDroppedNeutralItemTokens()
	local item = nil
	local droppedItem = GetDroppedItemList()

	for _, drop in pairs(droppedItem)
	do
		if drop.item:GetName() == 'item_tier1_token'
		or drop.item:GetName() == 'item_tier2_token'
		or drop.item:GetName() == 'item_tier3_token'
		or drop.item:GetName() == 'item_tier4_token'
		or drop.item:GetName() == 'item_tier5_token'
		then
			item = drop
			break
		end
	end

	if  item ~= nil
	and J.GetLocationToLocationDistance(item.location, J.GetTeamFountain()) > 900
	and Item.GetEmptyInventoryAmount(bot) > 0
	then
		PickedItem = item
		return BOT_ACTION_DESIRE_VERYHIGH
	else
		PickedItem = nil
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Pickup Refresher Shard
function TryPickupRefresherShard()
	if DotaTime() >= DroppedShardTime + 2.0
	then
		local mostCDHero = J.GetMostUltimateCDUnit()

		if  mostCDHero ~= nil
		and mostCDHero:IsBot()
		and bot == mostCDHero
		and J.Item.GetEmptyInventoryAmount(bot) > 0
		then
			local refreshShard = nil
			local nDroppedItem = GetDroppedItemList()

			for _, item in pairs(nDroppedItem)
			do
				if item.item:GetName() == 'item_refresher_shard'
				then
					refreshShard = item.item
					break
				end
			end

			if refreshShard ~= nil
			then
				PickedItem = refreshShard
				return BOT_MODE_DESIRE_VERYHIGH
			else
				PickedItem = nil
			end
		end

		DroppedShardTime = DotaTime()
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Pickup Cheese
function TryPickupCheese()
	if DotaTime() >= DroppedCheeseTime + 2.0
	then
		local pos = J.GetPosition(bot)

		if  (pos == 3 or pos == 2 or pos == 1)
		and J.Item.GetEmptyInventoryAmount(bot) > 0
		and not J.HasItem(bot, 'item_aegis')
		then
			local cheese = nil
			local nDroppedItem = GetDroppedItemList()

			for _, item in pairs(nDroppedItem)
			do
				if item.item:GetName() == 'item_cheese'
				then
					cheese = item.item
					break
				end
			end

			if cheese ~= nil
			then
				PickedItem = cheese
				return BOT_MODE_DESIRE_VERYHIGH
			else
				PickedItem = nil
			end
		end

		DroppedCheeseTime = DotaTime()
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Swap Items for Cheese
function TrySwapInvItemForCheese()
	if 	DotaTime() >= SwappedCheeseTime + 2.0
	and bot:GetActiveMode() ~= BOT_MODE_WARD 
	then
		local cSlot = bot:FindItemSlot('item_cheese')

		if bot:GetItemSlotType(cSlot) == ITEM_SLOT_TYPE_BACKPACK
		then
			local lessValItem = J.Item.GetMainInvLessValItemSlot(bot)

			if lessValItem ~= -1
			then
				bot:ActionImmediate_SwapItems(cSlot, lessValItem)
			end
		end

		SwappedCheeseTime = DotaTime()
	end
end

-- Swap Items for Refresher Shard
function TrySwapInvItemForRefresherShard()
	if 	DotaTime() >= SwappedRefresherShardTime + 2.0
	and bot:GetActiveMode() ~= BOT_MODE_WARD 
	then
		local rSlot = bot:FindItemSlot('item_refresher_shard')

		if bot:GetItemSlotType(rSlot) == ITEM_SLOT_TYPE_BACKPACK
		then
			local lessValItem = J.Item.GetMainInvLessValItemSlot(bot)

			if lessValItem ~= -1
			then
				bot:ActionImmediate_SwapItems(rSlot, lessValItem)
			end
		end

		SwappedRefresherShardTime = DotaTime()
	end
end

function IsDoingTormentor()
	local nCreeps = bot:GetNearbyNeutralCreeps(700)

	for _, c in pairs(nCreeps)
	do
		if c:GetUnitName() == 'npc_dota_miniboss' or #J.GetAlliesNearLoc(TormentorLocation, 400) >= 2
		then
			return true
		end
	end

	return false
end

-- Swap smoke after killing Roshan
function SwapSmokeSupport()
	if J.IsDoingRoshan(bot)
	then
		local botTarget = bot:GetAttackTarget()

		if  J.IsRoshan(botTarget)
		and J.IsAttacking(bot)
		then
			local smokeSlot = bot:FindItemSlot('item_smoke_of_deceit')

			if bot:GetItemSlotType(smokeSlot) == ITEM_SLOT_TYPE_BACKPACK
			then
				local leastCostItem = X.FindLeastExpensiveItemSlot()
	
				if leastCostItem ~= -1
				then
					bot:ActionImmediate_SwapItems(smokeSlot, leastCostItem)
				end
			end
		end
	end
end

function X.FindLeastExpensiveItemSlot()
	local minCost = 100000
	local idx = -1

	for i = 0, 5
	do
		if  bot:GetItemInSlot(i) ~= nil
		and bot:GetItemInSlot(i):GetName() ~= 'item_aegis'
		and bot:GetItemInSlot(i):GetName() ~= 'item_rapier'
		then
			local item = bot:GetItemInSlot(i):GetName()

			if  GetItemCost(item) < minCost
			and not (item == 'item_ward_observer' or item == 'item_ward_sentry')
			then
				minCost = GetItemCost(item)
				idx = i
			end
		end
	end

	return idx
end

function X.ConsiderDispersingFromSpells()
	local isMagicImmune = false

	if bot:IsMagicImmune()
	or bot:HasModifier('modifier_black_king_bar_immune')
	or bot:HasModifier('modifier_life_stealer_rage')
	then
		isMagicImmune = true
	end

	-- Pierces Spell Immunity / Urgent
	if bot:HasModifier('modifier_dark_seer_wall_slow')
	or bot:HasModifier('modifier_jakiro_macropyre_burn')
	then
		return true
	end

	if  not isMagicImmune 
	and (  bot:HasModifier('modifier_crystal_maiden_freezing_field_slow')
		or bot:HasModifier('modifier_disruptor_static_storm')
		or bot:HasModifier('modifier_lich_chainfrost_slow')
		or bot:HasModifier('modifier_sandking_sand_storm_slow')
		or bot:HasModifier('modifier_sand_king_epicenter_slow')
		or bot:HasModifier('modifier_shredder_chakram_debuff ')
		or bot:HasModifier('modifier_skywrath_mystic_flare_aura_effect')
		or bot:HasModifier('modifier_warlock_upheaval')
		or bot:HasModifier('modifier_windrunner_gale_force'))
	then
		return true
	end

	return false
end

function X.ConsiderRetreatWhenTowerTargeted()
	local nInRangeTowers = bot:GetNearbyTowers(1000, true)
	if  nInRangeTowers ~= nil and #nInRangeTowers >= 1
	and DotaTime() > RetreatWhenTowerTargetedTime + 3.5
	and not J.IsPushing(bot)
	then
		local nTower = nInRangeTowers[1]
		if  J.IsValidBuilding(nTower)
		and (J.IsTier1(nTower) or J.IsTier2(nTower))
		then
			local nTowerTarget = nTower:GetAttackTarget()
			if nTowerTarget == bot
			or X.IsChasingSomeoneToKill()
			then
				RetreatWhenTowerTargetedTime = DotaTime()
				return true
			end
		end
	end

	return false
end

function X.IsChasingSomeoneToKill()
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
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

			local nHealth = botTarget:GetHealth()
			if botTarget:GetUnitName() == 'npc_dota_hero_medusa'
			then
				nHealth = nHealth + botTarget:GetMana()
			end

			if nHealth > J.GetTotalEstimatedDamageToTarget(nChasingAlly, botTarget)
			then
				local nEnemyTowers = botTarget:GetNearbyTowers(888, true)

				if nEnemyTowers ~= nil and #nEnemyTowers >= 1
				then
					return true
				end
			end
		end
	end

	return false
end

function X.ConsiderHelpWhenCoreIsTargeted()
	local nRadius = 3500
	local nModeDesire = bot:GetActiveModeDesire()
	local nClosestCore = J.GetClosestCore(bot, nRadius)
	local botTarget = J.GetProperTarget(bot)

	if  nClosestCore ~= nil
	and not (J.IsGoingOnSomeone(bot) and J.IsValidTarget(botTarget) and J.IsInRange(bot, botTarget, 1000))
	and not J.IsCore(bot)
	and not (J.IsRetreating(bot) and nModeDesire > 0.7)
	then
		local nInRangeAlly = J.GetAlliesNearLoc(nClosestCore:GetLocation(), nClosestCore:GetCurrentVisionRange())
		local nInRangeEnemy = J.GetEnemiesNearLoc(nClosestCore:GetLocation(), nClosestCore:GetCurrentVisionRange())

		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
			and GetUnitToUnitDistance(bot, nClosestCore) <= nRadius
			and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and (#nInRangeAlly + 1 >= #nInRangeEnemy)
			then
				if (enemyHero:GetTarget() == nClosestCore or enemyHero:GetAttackTarget() == nClosestCore)
				or nClosestCore:WasRecentlyDamagedByHero(enemyHero, 1)
				then
					return enemyHero, true
				end
			end
		end
	end

	return nil, false
end