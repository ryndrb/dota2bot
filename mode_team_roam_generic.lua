----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
--- Refactor: 决明子 Email: dota2jmz@163.com 微博@Dota2_决明子
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1573671599
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1627071163
----------------------------------------------------------------------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end


local bot = GetBot();
local bDebugMode = ( 1 == 10 )
local X = {}

local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local botName = bot:GetUnitName();
local cAbility = nil;

local targetUnit = nil;

local towerCreepMode = false;
local towerCreep = nil;
local towerTime =  0;
local towerCreepTime = 0;

local beInitDone = false
local IsSupport = false
local IsHeroCore = false
local beTechies = false
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

local PhoenixMoveSunRay = false

local ShouldMoveMortimerKisses = false

if bot.shouldShukuchiTagCreeps == nil then bot.shouldShukuchiTagCreeps = false end
local ShukuchiCreepList = {}

local ShouldMoveCloseTowerForEdict = false
local EdictTowerTarget = nil

local TormentorLocation
if GetTeam() == TEAM_RADIANT
then
	TormentorLocation = Vector(-8075, -1148, 1000)
else
	TormentorLocation = Vector(8132, 1102, 1000)
end

local DontMove = false

function GetDesire()

	if not beInitDone
	then
		beInitDone = true
		bePvNMode = J.Role.IsPvNMode()
		IsHeroCore = X.IsSpecialCore(bot)
		IsSupport = X.IsSpecialSupport(bot)
	end

	local nDesire = 0

	SwapSmokeSupport()

	nDesire = ConsiderHarassInLaningPhase()
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

	-- Batrider
	if  bot:GetUnitName() == 'npc_dota_hero_batrider'
	and bot:HasModifier('modifier_batrider_flaming_lasso_self')
	then
		return BOT_MODE_DESIRE_ABSOLUTE
	end

	if  bot.canVendettaKill
	and bot:HasModifier('modifier_nyx_assassin_vendetta')
	then
		return BOT_MODE_DESIRE_ABSOLUTE
	end

	-- Pangolier
	if  (bot.rollingThunderTeamFight or bot.rollingThunderRetreat)
	and bot:HasModifier('modifier_pangolier_gyroshell')
	then
		return BOT_MODE_DESIRE_ABSOLUTE
	end

	-- Phoenix
	if  bot:GetUnitName() == 'npc_dota_hero_phoenix'
	and bot:HasModifier('modifier_phoenix_sun_ray')
	and not bot:HasModifier('modifier_phoenix_supernova_hiding')
	then
		PhoenixMoveSunRay = true
		return BOT_ACTION_DESIRE_ABSOLUTE
	else
		PhoenixMoveSunRay = false
	end

	-- Snapfire
	if  bot:GetUnitName() == 'npc_dota_hero_snapfire'
	and bot:HasModifier('modifier_snapfire_mortimer_kisses')
	then
		ShouldMoveMortimerKisses = true
		return BOT_ACTION_DESIRE_ABSOLUTE
	else
		ShouldMoveMortimerKisses = false
	end

	-- Spirit Breaker
	if  bot:GetUnitName() == "npc_dota_hero_spirit_breaker"
	and bot:HasModifier("modifier_spirit_breaker_charge_of_darkness")
	then
		return BOT_MODE_DESIRE_ABSOLUTE
	end

	-- Weaver
	if  bot:GetUnitName() == "npc_dota_hero_weaver"
	and bot:HasModifier("modifier_weaver_shukuchi")
	and bot.tryShukuchiKill
	then
		if  J.IsValidHero(bot.ShukuchiKillTarget)
		and J.IsInLaningPhase()
		then
			local nInRangeTower = bot.ShukuchiKillTarget:GetNearbyTowers(700, false)
			if nInRangeTower ~= nil and #nInRangeTower == 0
			then
				return BOT_ACTION_DESIRE_ABSOLUTE
			end
		else
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end

	if  bot:GetUnitName() == "npc_dota_hero_weaver"
	and bot:HasModifier("modifier_weaver_shukuchi")
	then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 1000, 175, 0, 0)
		local nCreeps = bot:GetNearbyCreeps(bot:GetAttackRange() + 200, true)

		if  J.IsFarming(bot)
		and nCreeps ~= nil and #nCreeps >= 2
		and J.CanBeAttacked(nCreeps[1])
		and nLocationAoE.count >= 2
		then
			bot.shouldShukuchiTagCreeps = true
			ShukuchiCreepList = nCreeps
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end

	-- Leshrac
	ShouldMoveCloseTowerForEdict = ConsiderLeshracEdictTower()
	if ShouldMoveCloseTowerForEdict
	then
		return BOT_ACTION_DESIRE_ABSOLUTE
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

	TrySwapInvItemForCheese()

	TrySwapInvItemForRefresherShard()

	if beTechies or J.Role['bStopAction'] then return 2.0 end

	if botName == "npc_dota_hero_pugna" 
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName( "pugna_life_drain" ) end;
		if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
			DontMove = true
			return BOT_MODE_DESIRE_ABSOLUTE;
		end	
	elseif botName == "npc_dota_hero_drow_ranger"
		then
			if cAbility == nil then cAbility = bot:GetAbilityByName( "drow_ranger_multishot" ) end;
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE;
			end	
	elseif botName == "npc_dota_hero_shadow_shaman"
		then
			if cAbility == nil then cAbility = bot:GetAbilityByName( "shadow_shaman_shackles" ) end;
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE;
			end
	elseif botName == "npc_dota_hero_clinkz"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("clinkz_burning_barrage") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_tiny"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("tiny_tree_channel") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_void_spirit"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("void_spirit_dissimilate") end
		if cAbility:IsTrained()
		then
			if  bot:HasModifier("modifier_void_spirit_dissimilate_phase")
			then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_enigma"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("enigma_black_hole") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_keeper_of_the_light"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("keeper_of_the_light_illuminate") end
		if cAbility:IsInAbilityPhase() or bot:IsChanneling() or bot:HasModifier('modifier_keeper_of_the_light_illuminate') then
			DontMove = true
			return BOT_MODE_DESIRE_ABSOLUTE
		end
	elseif botName == "npc_dota_hero_meepo"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("meepo_poof") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_monkey_king"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("monkey_king_primal_spring") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_phoenix"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("phoenix_supernova") end
		if cAbility:IsTrained()
		then
			if bot:HasModifier('modifier_phoenix_supernova_hiding') then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_puck"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("puck_phase_shift") end
		if cAbility:IsTrained()
		then
			if bot:HasModifier('modifier_puck_phase_shift') then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_windrunner"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("windrunner_powershot") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_tinker"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("tinker_rearm") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() or bot:HasModifier('modifier_tinker_rearm') then
				DontMove = true
				return BOT_MODE_DESIRE_ABSOLUTE * 1.6
			end
		end
	end

	if IsHeroCore
	then
		local botTarget, targetDesire = X.CarryFindTarget()
		if J.IsValidTarget(botTarget)
		then
			targetUnit = botTarget
			bot:SetTarget(botTarget)
			return targetDesire
		end
	end

	if IsSupport
	then
		local botTarget, targetDesire = X.SupportFindTarget()
		if J.IsValidTarget(botTarget)
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
	bot.shouldShukuchiTagCreeps = false
	ShukuchiCreepList = {}
	DontMove = false
end


function Think()
	if J.CanNotUseAction(bot) then return end

	if DontMove
	then
		bot:Action_ClearActions(true)
		return
	end

	if bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
	then
		bot:Action_ClearActions(false)
		local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		if  bot.chargeRetreat
		and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
		then
			bot:Action_MoveToLocation(bot:GetLocation() + RandomVector(150))
			bot.chargeRetreat = false
		end

		return
	end

	if  bot:GetUnitName() == 'npc_dota_hero_batrider'
	and bot:HasModifier('modifier_batrider_flaming_lasso_self')
	then
		bot:Action_MoveToLocation(J.GetTeamFountain())
		return
	end

	if bot.canVendettaKill
	then
		if bot.vendettaTarget ~= nil
		then
			if GetUnitToUnitDistance(bot, bot.vendettaTarget) > bot:GetAttackRange()
			then
				bot:Action_MoveToLocation(bot.vendettaTarget:GetLocation())
				return
			else
				bot:Action_AttackUnit(bot.vendettaTarget, true)
				return
			end
		end
	end

	-- Pangolier
	if bot.rollingThunderTeamFight
	then
		local weakestTarget = J.GetVulnerableWeakestUnit(bot, true, true, 1200)

        if  J.IsValidTarget(weakestTarget)
        and not J.IsSuspiciousIllusion(weakestTarget)
        then
			bot:Action_MoveToLocation(weakestTarget:GetLocation())
            return
        end
	elseif bot.rollingThunderRetreat
	then
		bot:Action_MoveToLocation(J.GetEscapeLoc())
        return
	end

	-- Phoenix
	if PhoenixMoveSunRay
	then
		if J.IsValidHero(bot.targetSunRay)
		then
			bot:Action_MoveToLocation(bot.targetSunRay:GetLocation())
			return
		end
	end

	-- Snapfire
	if ShouldMoveMortimerKisses
	then
		local nKissesTarget = GetMortimerKissesTarget()

		if nKissesTarget ~= nil
		then
			local eta = (GetUnitToUnitDistance(bot, nKissesTarget) / 1300) + 0.3
			bot:Action_MoveToLocation(nKissesTarget:GetExtrapolatedLocation(eta))
			return
		end
	end

	-- Weaver
	if bot.tryShukuchiKill
	then
		if J.IsValidHero(bot.ShukuchiKillTarget)
		then
			bot:Action_MoveToLocation(bot.ShukuchiKillTarget:GetLocation())
			return
		end
	end

	if  bot.shouldShukuchiTagCreeps
	and #ShukuchiCreepList > 0
	then
		bot:Action_MoveToLocation(J.GetCenterOfUnits(ShukuchiCreepList))
		return
	end

	-- Leshrac
	if ShouldMoveCloseTowerForEdict
	then
		if EdictTowerTarget ~= nil
		then
			if GetUnitToUnitDistance(bot, EdictTowerTarget) > 350
			then
				bot:Action_MoveToLocation(EdictTowerTarget:GetLocation())
				return
			end
		end
	end

	if  shouldHarass
	and harassTarget ~= nil
	then
		bot:Action_AttackUnit(harassTarget, false)
		return
	end

	if  ShouldAttackSpecialUnit
	and SpecialUnitTarget ~= nil
	then
		bot:Action_AttackUnit(SpecialUnitTarget, false)
		return
	end

	if  bot:GetUnitName() == 'npc_dota_hero_void_spirit'
	and bot:HasModifier('modifier_void_spirit_dissimilate_phase')
	then
		local botTarget = J.GetProperTarget(bot)

		if J.IsGoingOnSomeone(bot)
		then
			if J.IsValidTarget(botTarget)
			then
				bot:Action_MoveToLocation(botTarget:GetLocation())
			end
		end

		if J.IsRetreating(bot)
		then
			bot:Action_MoveToLocation(J.GetEscapeLoc())
		end

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
	and targetUnit ~= nil
	and (J.IsValid(targetUnit)
		or J.IsValidTarget(targetUnit)
		or J.IsValidBuilding(targetUnit))
	then
		bot:Action_AttackUnit(targetUnit, false)
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
		if GetUnitToUnitDistance(bot,u) > nRange 
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

	if nCreep ~= nil and nCreep:IsAlive()
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
		if tower ~= nil and tower:IsAlive()
		   and tower:GetAttackTarget() == nUnit
		then
			return true;
		end
	end
	
	local nTowers = bot:GetNearbyTowers(1600,false);
	for _,tower in pairs(nTowers)
	do
		if tower ~= nil and tower:IsAlive()
		   and tower:GetAttackTarget() == nUnit
		then
			return true;
		end
	end
	
	return false;

end


function X.IsCreepTarget(nUnit)
	local bot = GetBot();
	local nCreeps = bot:GetNearbyCreeps(1200,true);
	for _,creep in pairs(nCreeps)
	do
		if creep ~= nil and creep:IsAlive()
		   and creep:GetAttackTarget() == nUnit
		then
			return true;
		end
	end
	
	local nCreeps = bot:GetNearbyCreeps(1200,false);
	for _,creep in pairs(nCreeps)
	do
		if creep ~= nil and creep:IsAlive()
		   and creep:GetAttackTarget() == nUnit
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


function X.IsSpecialCore(bot)
    if J.GetPosition(bot) == 1
	or J.GetPosition(bot) == 2
	or J.GetPosition(bot) == 3
	then
		local botName = bot:GetUnitName();
		
		local tSpecialCarryList = {
			["npc_dota_hero_abyssal_underlord"] = true,
			["npc_dota_hero_alchemist"] = true,
			["npc_dota_hero_antimage"] = true,
			["npc_dota_hero_arc_warden"] = true,
			["npc_dota_hero_axe"] = true,
			["npc_dota_hero_batrider"] = true,
			["npc_dota_hero_beastmaster"] = true,
			["npc_dota_hero_brewmaster"] = true,
			["npc_dota_hero_bloodseeker"] = true,
			["npc_dota_hero_bounty_hunter"] = true,
			["npc_dota_hero_bristleback"] = true,
			["npc_dota_hero_broodmother"] = true,
			["npc_dota_hero_centaur"] = true,
			["npc_dota_hero_chaos_knight"] = true,
			["npc_dota_hero_clinkz"] = true,
			["npc_dota_hero_dark_seer"] = true,
			["npc_dota_hero_dawnbreaker"] = true,
			["npc_dota_hero_death_prophet"] = true,
			["npc_dota_hero_doom_bringer"] = true,
			["npc_dota_hero_dragon_knight"] = true,
			["npc_dota_hero_drow_ranger"] = true,
			["npc_dota_hero_earth_spirit"] = true,
			["npc_dota_hero_ember_spirit"] = true,
			["npc_dota_hero_enigma"] = true,
			["npc_dota_hero_faceless_void"] = true,
			["npc_dota_hero_furion"] = true,
			["npc_dota_hero_gyrocopter"] = true,
			["npc_dota_hero_huskar"] = true,
			["npc_dota_hero_invoker"] = true,
			["npc_dota_hero_juggernaut"] = true,
			["npc_dota_hero_keeper_of_the_light"] = true,
			["npc_dota_hero_kunkka"] = true,
			["npc_dota_hero_legion_commander"] = true,
			["npc_dota_hero_leshrac"] = true,
			["npc_dota_hero_life_stealer"] = true,
			["npc_dota_hero_lina"] = true,
			["npc_dota_hero_lone_druid"] = true,
			["npc_dota_hero_luna"] = true,
			["npc_dota_hero_lycan"] = true,
			["npc_dota_hero_magnataur"] = true,
			["npc_dota_hero_marci"] = true,
			["npc_dota_hero_mars"] = true,
			["npc_dota_hero_medusa"] = true,
			["npc_dota_hero_meepo"] = true,
			["npc_dota_hero_mirana"] = true,
			["npc_dota_hero_monkey_king"] = true,
			["npc_dota_hero_muerta"] = true,
			["npc_dota_hero_naga_siren"] = true,
			["npc_dota_hero_necrolyte"] = true,
			["npc_dota_hero_nevermore"] = true,
			["npc_dota_hero_night_stalker"] = true,
			["npc_dota_hero_obsidian_destroyer"] = true,
			["npc_dota_hero_ogre_magi"] = true,
			["npc_dota_hero_omniknight"] = true,
			["npc_dota_hero_pangolier"] = true,
			["npc_dota_hero_phantom_assassin"] = true,
			["npc_dota_hero_phantom_lancer"] = true,
			["npc_dota_hero_puck"] = true,
			["npc_dota_hero_pudge"] = true,
			["npc_dota_hero_queenofpain"] = true,
			["npc_dota_hero_razor"] = true,
			["npc_dota_hero_riki"] = true,
			["npc_dota_hero_skeleton_king"] = true,
			["npc_dota_hero_sand_king"] = true,
			["npc_dota_hero_shredder"] = true,
			["npc_dota_hero_slardar"] = true,
			["npc_dota_hero_slark"] = true,
			["npc_dota_hero_snapfire"] = true,
			["npc_dota_hero_sniper"] = true,
			["npc_dota_hero_spectre"] = true,
			["npc_dota_hero_spirit_breaker"] = true,
			["npc_dota_hero_storm_spirit"] = true,
			["npc_dota_hero_sven"] = true,
			["npc_dota_hero_templar_assassin"] = true,
			["npc_dota_hero_terrorblade"] = true,
			["npc_dota_hero_tidehunter"] = true,
			["npc_dota_hero_tinker"] = true,
			["npc_dota_hero_tiny"] = true,
			["npc_dota_hero_troll_warlord"] = true,
			["npc_dota_hero_ursa"] = true,
			["npc_dota_hero_viper"] = true,
			["npc_dota_hero_visage"] = true,
			["npc_dota_hero_void_spirit"] = true,
			["npc_dota_hero_weaver"] = true,
			["npc_dota_hero_windrunner"] = true,
			["npc_dota_hero_zuus"] = true,
		}

		return tSpecialCarryList[botName] == true
	end

	return false
end


function X.IsSpecialSupport(bot)
    
	local botName = bot:GetUnitName();
	
	local tSpecialSupportList = {	  
		["npc_dota_hero_crystal_maiden"] = true,
		["npc_dota_hero_jakiro"] = true,
		["npc_dota_hero_lich"] = true,
		["npc_dota_hero_oracle"] = true,
		["npc_dota_hero_pugna"] = true,
		["npc_dota_hero_shadow_shaman"] = true,
		["npc_dota_hero_silencer"] = true,
		["npc_dota_hero_skywrath_mage"] = true,
		["npc_dota_hero_warlock"] = true,
		["npc_dota_hero_witch_doctor"] = true,
		["npc_dota_hero_lion"] = true,
		["npc_dota_hero_dazzle"] = true,
		["npc_dota_hero_bane"] = true,

		["npc_dota_hero_abaddon"] = true,
		["npc_dota_hero_ancient_apparition"] = true,
		["npc_dota_hero_chen"] = true,
		["npc_dota_hero_rattletrap"] = true,
		["npc_dota_hero_dark_willow"] = true,
		["npc_dota_hero_disruptor"] = true,
		["npc_dota_hero_earthshaker"] = true,
		["npc_dota_hero_enchantress"] = true,
		["npc_dota_hero_grimstroke"] = true,
		["npc_dota_hero_hoodwink"] = true,
		["npc_dota_hero_nyx_assassin"] = true,
		["npc_dota_hero_phoenix"] = true,
		["npc_dota_hero_shadow_demon"] = true,
		["npc_dota_hero_treant"] = true,
		["npc_dota_hero_tusk"] = true,
		["npc_dota_hero_undying"] = true,
		["npc_dota_hero_vengefulspirit"] = true,
		["npc_dota_hero_venomancer"] = true,
		["npc_dota_hero_winter_wyvern"] = true,
	}
	
	return tSpecialSupportList[botName] == true
			
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
	
	if bot:HasModifier("modifier_item_satanic_unholy")
	   or bot:HasModifier("modifier_abaddon_borrowed_time")
	   or ( bot:GetCurrentMovementSpeed() < 240 and not bot:HasModifier("modifier_arc_warden_spark_wraith_purge") )
	then 
		return true; 
	end
	
	local nAttackAlly = bot:GetNearbyHeroes(1000,false,BOT_MODE_ATTACK);
	if  ( bot:HasModifier("modifier_item_mask_of_madness_berserk")
			or bot:HasModifier("modifier_oracle_false_promise_timer") )
		and ( #nAttackAlly >= 1 or J.GetHP(bot) > 0.6 )
	then
		return true;
	end		
	
	local nAllies = J.GetAllyList(bot,800);
    if #nAllies <= 1 
	then 
	    return false;
	end
	
	if ( botName == "npc_dota_hero_medusa" 
	     or bot:FindItemSlot("item_abyssal_blade") >= 0 )
		and #nAllies >= 3 and #nAttackAlly >= 1
	then
		return true;
	end
	
	if botName == "npc_dota_hero_skeleton_king"
		and bot:GetLevel() >= 6 and #nAttackAlly >= 1 
	then
		local abilityR = bot:GetAbilityByName( "skeleton_king_reincarnation" );
		if abilityR:GetCooldownTimeRemaining() <= 1.0 and bot:GetMana() >= 160
		then
			return true;
		end
	end
	
	for _,ally in pairs(nAllies)
	do
		if J.IsValid(ally) 
		then
			if  ( J.GetHP(ally) > 0.88 and ally:GetLevel() >= 12 and ally:GetActiveMode() ~= BOT_MODE_RETREAT)
			    or ( ally:HasModifier("modifier_black_king_bar_immune") or ally:IsMagicImmune() )
				or ( ally:HasModifier("modifier_item_mask_of_madness_berserk") and ally:GetAttackTarget() ~= nil )
				or ally:HasModifier("modifier_abaddon_borrowed_time")
				or ally:HasModifier("modifier_item_satanic_unholy")
				or ally:HasModifier("modifier_oracle_false_promise_timer")
			then
				return true;
			end
		end
	end
	
	return false;
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
	local nAttackRange = bot:GetAttackRange() + 200
	local nUnits = GetUnitList(UNIT_LIST_ENEMIES)

	for _, unit in pairs(nUnits)
	do
		if J.IsValid(unit)
		then
			if string.find(unit:GetUnitName(), 'healing_ward')
			or string.find(unit:GetUnitName(), 'forged_spirit')
			or string.find(unit:GetUnitName(), 'grimstroke_ink_creature')
			or string.find(unit:GetUnitName(), 'lone_druid_bear')
			or string.find(unit:GetUnitName(), 'observer_ward')
			or string.find(unit:GetUnitName(), 'phoenix_sun')
			or string.find(unit:GetUnitName(), 'plague_ward')
			or string.find(unit:GetUnitName(), 'sentry_ward')
			or string.find(unit:GetUnitName(), 'tombstone')
			or string.find(unit:GetUnitName(), 'warlock_golem')
			or string.find(unit:GetUnitName(), 'weaver_swarm')
			then
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

function ConsiderHarassInLaningPhase()
	if J.IsInLaningPhase()
	then
		local nModeDesire = bot:GetActiveModeDesire()
		local nInRangeAlly = bot:GetNearbyHeroes(700, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(700, true)
		local nAttackRange = bot:GetAttackRange()

		-- Harass
		if not shouldHarass
		then
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

			if  J.GetHP(bot) > 0.41
			and ((J.IsCore(bot) and not canLastHitCount == 0)
				or (not J.IsCore(bot)))
			then
				-- MK Range
				if nAttackRange < 300
				then
					nAttackRange = 300
				end

				nInRangeEnemy = bot:GetNearbyHeroes(nAttackRange, true, BOT_MODE_NONE)
				if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
				then
					if  J.IsValidHero(nInRangeEnemy[1])
					and J.CanBeAttacked(nInRangeEnemy[1])
					and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
					and not J.IsRetreating(bot)
					and nInRangeAlly ~= nil and nInRangeEnemy
					and #nInRangeAlly >= #nInRangeEnemy
					then
						local nInRangeTower = bot:GetNearbyTowers(700, true)
						local nTargetInRangeTower = nInRangeEnemy[1]:GetNearbyTowers(700, false)

						if (nInRangeTower ~= nil and #nInRangeTower == 0
							or nTargetInRangeTower ~= nil and #nTargetInRangeTower == 0)
						and not bot:WasRecentlyDamagedByAnyHero(2.2)
						and not bot:WasRecentlyDamagedByTower(2)
						and not bot:WasRecentlyDamagedByCreep(1.5)
						then
							shouldHarass = true
							harassTarget = nInRangeEnemy[1]

							if J.IsLaning(bot)
							then
								if (J.IsHumanPlayer(nInRangeEnemy[1]) or J.IsCore(nInRangeEnemy[1])) then return nModeDesire + 0.1 end
								return BOT_MODE_DESIRE_MODERATE * 1.15
							else
								return BOT_MODE_DESIRE_MODERATE * 1.16
							end
						end
					end
				end
			end
		else
			shouldHarass = false
		end
	end

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
	then
		PickedItem = item
		return BOT_ACTION_DESIRE_VERYHIGH
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
					refreshShard = item
					break
				end
			end

			if refreshShard ~= nil
			then
				PickedItem = refreshShard
				return BOT_MODE_DESIRE_VERYHIGH
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
					cheese = item
					break
				end
			end

			if cheese ~= nil
			then
				PickedItem = cheese
				return BOT_MODE_DESIRE_VERYHIGH
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
				local leastCostItem = J.FindLeastExpensiveItemSlot()
	
				if leastCostItem ~= -1
				then
					bot:ActionImmediate_SwapItems(smokeSlot, leastCostItem)
				end
			end
		end
	end
end

function J.FindLeastExpensiveItemSlot()
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

function GetMortimerKissesTarget()
	local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nInRangeEnemy)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsInRange(bot, enemyHero, 600)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if J.IsLocationInChrono(enemyHero:GetLocation())
			or J.IsLocationInBlackHole(enemyHero:GetLocation())
			then
				return enemyHero
			end
		end

		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsInRange(bot, enemyHero, 600)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return enemyHero
		end
	end

	local nCreeps = bot:GetNearbyCreeps(1600, true)
	if nCreeps ~= nil and #nCreeps >= 1
	then
		return nCreeps[1]
	end

	return nil
end

function ConsiderLeshracEdictTower()
	if  bot:GetUnitName() == "npc_dota_hero_leshrac"
	and bot:HasModifier("modifier_leshrac_diabolic_edict")
	then
		local DiabolicEdict = bot:GetAbilityByName('leshrac_diabolic_edict')
		if DiabolicEdict:IsTrained()
		then
			local nRadius = DiabolicEdict:GetSpecialValueInt('radius')
			if J.IsPushing(bot)
			then
				local nEnemyTowers = bot:GetNearbyTowers(1600, true)
				local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
				if  nEnemyTowers ~= nil and #nEnemyTowers >= 1
				and J.IsValidBuilding(nEnemyTowers[1])
				and J.CanBeAttacked(nEnemyTowers[1])
				and not J.IsInRange(bot, nEnemyTowers[1], nRadius - 75)
				and nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps <= 2
				then
					EdictTowerTarget = nEnemyTowers[1]
					return true
				end
			end
		end
	end

	return false
end