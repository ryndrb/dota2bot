if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or GetBot():IsIllusion() then
	return
end

local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')
local Item = require( GetScriptDirectory()..'/FunLib/aba_item' )

local hAbilityCapture = bot:GetAbilityByName('ability_capture')
local Outposts = {}
local DidWeGetOutpost = false
local ClosestOutpost = nil
local ClosestOutpostDist = 10000

local IsEnemyTier2Down = false

local TinkerShouldWaitInBaseToHeal = false

local ShouldWaitInBaseToHeal = false
local TPScroll = nil

local botName = bot:GetUnitName()
local cAbility = nil

local ShouldMoveCloseTowerForEdict = false
local EdictTowerTarget = nil

local ShouldHuskarMoveOutsideFountain = false
local ShouldHeroMoveOutsideFountain = false

local fDissimilateTime = 0

local fNextMovementTime = -math.huge
local LoneDruid = {}

function GetDesire()
	if not IsEnemyTier2Down
	then
		if GetTower(GetOpposingTeam(), TOWER_TOP_2) == nil
		or GetTower(GetOpposingTeam(), TOWER_MID_2) == nil
		or GetTower(GetOpposingTeam(), TOWER_BOT_2) == nil
		then
			IsEnemyTier2Down = true
		end
	end

	LoneDruid = J.CheckLoneDruid()

	-- 7.37 change
	-- if bot:GetUnitName() == 'npc_dota_hero_broodmother'
	-- and J.GetPosition(bot) ~= 2
	-- then
	-- 	if bot.shouldWebMid == nil then bot.shouldWebMid = true end

	-- 	if DotaTime() < 0 and bot.shouldWebMid == true
	-- 	then
	-- 		return BOT_ACTION_DESIRE_ABSOLUTE * 0.99
	-- 	end
	-- end

	------------------------------
	-- Hero Channel/Kill/CC abilities
	------------------------------

	if botName == "npc_dota_hero_rubick"
	then
		if bot:IsChanneling() or bot:IsUsingAbility() or bot:IsCastingAbility()
		then
			return BOT_MODE_DESIRE_ABSOLUTE
		end
	end

	if botName == "npc_dota_hero_pugna" 
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName( "pugna_life_drain" ) end;
		if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
			return BOT_MODE_DESIRE_ABSOLUTE;
		end	
	elseif botName == "npc_dota_hero_drow_ranger"
		then
			if cAbility == nil then cAbility = bot:GetAbilityByName( "drow_ranger_multishot" ) end;
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE;
			end	
	elseif botName == "npc_dota_hero_shadow_shaman"
		then
			if cAbility == nil then cAbility = bot:GetAbilityByName( "shadow_shaman_shackles" ) end;
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE;
			end
	elseif botName == "npc_dota_hero_clinkz"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("clinkz_burning_barrage") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_tiny"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("tiny_tree_channel") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_void_spirit"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("void_spirit_dissimilate") end
		if cAbility:IsTrained()
		then
			if DotaTime() < fDissimilateTime + 1.15 then
				return BOT_MODE_DESIRE_ABSOLUTE
			end

			if cAbility:IsInAbilityPhase()
			then
				fDissimilateTime = DotaTime()
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_batrider"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("batrider_flaming_lasso") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier("modifier_batrider_flaming_lasso_self")
			then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_enigma"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("enigma_black_hole") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_keeper_of_the_light"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("keeper_of_the_light_illuminate") end
		if cAbility:IsChanneling() then
			return BOT_MODE_DESIRE_ABSOLUTE
		end
	elseif botName == "npc_dota_hero_meepo"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("meepo_poof") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_monkey_king"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("monkey_king_primal_spring") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_nyx_assassin"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("nyx_assassin_vendetta") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_nyx_assassin_vendetta')
			then
				if bot.canVendettaKill
				then
					return BOT_MODE_DESIRE_ABSOLUTE
				end
			end
		end
	elseif botName == "npc_dota_hero_pangolier"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("pangolier_gyroshell") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_pangolier_gyroshell')
			then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_phoenix"
	then
		cAbility = bot:GetAbilityByName("phoenix_supernova")
		if cAbility:IsTrained()
		then
			if bot:HasModifier('modifier_phoenix_supernova_hiding') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end

		cAbility = bot:GetAbilityByName("phoenix_sun_ray")
		if cAbility:IsTrained()
		then
			if bot:HasModifier('modifier_phoenix_sun_ray')
			then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_puck"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("puck_phase_shift") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_puck_phase_shift') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_ringmaster"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("ringmaster_tame_the_beasts") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier("modifier_ringmaster_tame_the_beasts") then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_snapfire"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("snapfire_mortimer_kisses") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_snapfire_mortimer_kisses') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_spirit_breaker"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("spirit_breaker_charge_of_darkness") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_spirit_breaker_charge_of_darkness') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_windrunner"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("windrunner_powershot") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_tinker"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("tinker_rearm") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_tinker_rearm') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_primal_beast"
	then
		cAbility = bot:GetAbilityByName("primal_beast_onslaught")
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_primal_beast_onslaught_windup') or bot:HasModifier('modifier_prevent_taunts') or bot:HasModifier('modifier_primal_beast_onslaught_movement_adjustable') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end

		cAbility = bot:GetAbilityByName("primal_beast_trample")
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_primal_beast_trample') then
				return 6.66
			end
		end

		cAbility = bot:GetAbilityByName("primal_beast_pulverize")
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_primal_beast_pulverize_self') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_hoodwink"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("hoodwink_sharpshooter") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_hoodwink_sharpshooter_windup') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_nevermore"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("nevermore_requiem") end
		if cAbility:IsTrained()
		then
			if cAbility:IsInAbilityPhase() or bot:HasModifier('modifier_nevermore_requiem_invis_break') then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_elder_titan"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("elder_titan_echo_stomp") end
		if cAbility:IsTrained()
		then
			if cAbility:IsChanneling() then
				return BOT_MODE_DESIRE_ABSOLUTE
			end
		end
	elseif botName == "npc_dota_hero_wisp"
	then
		if cAbility == nil then cAbility = bot:GetAbilityByName("wisp_tether") end
		if cAbility:IsTrained()
		then
			if bot:HasModifier('modifier_wisp_tether') and bot.tethered_ally ~= nil and not (J.IsRetreating(bot) and J.GetHP(bot) < 0.25) then
				if GetUnitToUnitDistance(bot, bot.tethered_ally) > 550 then
					return BOT_MODE_DESIRE_ABSOLUTE
				end
			end
		end
	end

	TPScroll = J.GetItem2(bot, 'item_tpscroll')

	-- if  ConsiderWaitInBaseToHeal()
	-- and GetUnitToLocationDistance(bot, J.GetTeamFountain()) > 5500
	-- then
	-- 	return BOT_ACTION_DESIRE_ABSOLUTE
	-- end

	TinkerShouldWaitInBaseToHeal = TinkerWaitInBaseAndHeal()
	if TinkerShouldWaitInBaseToHeal
	then
		return BOT_ACTION_DESIRE_ABSOLUTE
	end

	ShouldHuskarMoveOutsideFountain = ConsiderHuskarMoveOutsideFountain()
	if ShouldHuskarMoveOutsideFountain
	then
		return bot:GetActiveModeDesire() + 0.1
	end

	-- If in item mode
	ShouldHeroMoveOutsideFountain = ConsiderHeroMoveOutsideFountain()
	if ShouldHeroMoveOutsideFountain
	then
		return bot:GetActiveModeDesire() + 0.1
	end

	-- -- Leshrac
	-- ShouldMoveCloseTowerForEdict = ConsiderLeshracEdictTower()
	-- if ShouldMoveCloseTowerForEdict
	-- then
	-- 	return BOT_ACTION_DESIRE_ABSOLUTE
	-- end

	-- Bear Necessities
	-- facet fix
	if GLOBAL_bHaveBearNecessitiesFacet and J.IsValid(LoneDruid.hero) and bot == LoneDruid.hero then
		for i = 0, 8 do
			local hItem = bot:GetItemInSlot(i)
			if hItem ~= nil and i >= 3 then
				local sItemName = hItem:GetName()
				for j = 0, 2 do
					local hItem2 = bot:GetItemInSlot(j)
					if  hItem2 == nil
					or (hItem2 ~= nil and sItemName == 'item_maelstrom' and hItem2:GetName() == 'item_magic_wand')
					or (hItem2 ~= nil and sItemName == 'item_lesser_crit' and hItem2:GetName() == 'item_wraith_band')
					or (hItem2 ~= nil and sItemName == 'item_greater_crit' and hItem2:GetName() == 'item_wraith_band')
					then
						bot:ActionImmediate_SwapItems(i, j)
					end
				end
			end
		end
	end

	if DotaTime() > -30 and J.IsValid(LoneDruid.hero) and J.IsValid(LoneDruid.bear) and bot == LoneDruid.hero and J.IsInRange(bot, LoneDruid.bear, 1600) then
		local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if not J.IsInTeamFight(bot, 1600) and #nEnemyHeroes == 0 then
			for i = 0, 8 do
				local hItem = bot:GetItemInSlot(i)
				if hItem ~= nil then
					local hItemName = hItem:GetName()

					if GLOBAL_bHaveBearNecessitiesFacet then
						for _, itemName in pairs(GLOBAL_hBearItemList_BearNecessities) do
							if hItemName == itemName then
								if itemName == 'item_hyperstone' then
									if J.HasItem(LoneDruid.bear, 'item_assault') then
										bot.dropItem = hItem
										bot.isGiveItem = true
										return BOT_MODE_DESIRE_ABSOLUTE
									end
								elseif itemName == 'item_eagle' then
									if J.HasItem(LoneDruid.hero, 'item_butterfly') then
										bot.dropItem = hItem
										bot.isGiveItem = true
										return BOT_MODE_DESIRE_ABSOLUTE
									end
								elseif itemName == 'item_power_treads' then
									if (J.HasItem(LoneDruid.hero, 'item_lesser_crit') or J.HasItem(LoneDruid.hero, 'item_greater_crit')) then
										bot.dropItem = hItem
										bot.isGiveItem = true
										return BOT_MODE_DESIRE_ABSOLUTE
									end
								else
									bot.dropItem = hItem
									bot.isGiveItem = true
									return BOT_MODE_DESIRE_ABSOLUTE
								end
							end
						end
					else
						for _, itemName in pairs(GLOBAL_hBearItemList_BearWithMe) do
							if hItemName == itemName then
								if itemName == 'item_moon_shard' then
									if not LoneDruid.bear:HasModifier('modifier_item_moon_shard_consumed') or not J.HasItem(LoneDruid.bear, 'item_moon_shard') then
										bot.dropItem = hItem
										bot.isGiveItem = true
										return BOT_MODE_DESIRE_ABSOLUTE
									end
								elseif itemName == 'item_hyperstone' then
									if J.HasItem(LoneDruid.bear, 'item_assault') then
										bot.dropItem = hItem
										bot.isGiveItem = true
										return BOT_MODE_DESIRE_ABSOLUTE
									end
								else
									bot.dropItem = hItem
									bot.isGiveItem = true
									return BOT_MODE_DESIRE_ABSOLUTE
								end
							end
						end
					end
				end
			end
		else
			bot.isGiveItem = false
		end
	end

	-- LD Bear
	if J.IsValid(LoneDruid.bear) and J.IsValid(LoneDruid.hero) and bot == LoneDruid.bear then
		return 3
	end

	----------
	-- Outpost
	----------

	if not IsEnemyTier2Down then return BOT_ACTION_DESIRE_NONE end

	if not DidWeGetOutpost
	then
		for _, unit in pairs(GetUnitList(UNIT_LIST_ALL))
		do
			if unit:GetUnitName() == '#DOTA_OutpostName_North'
			or unit:GetUnitName() == '#DOTA_OutpostName_South'
			then
				table.insert(Outposts, unit)
			end
		end

		DidWeGetOutpost = true
	end

	ClosestOutpost, ClosestOutpostDist = GetClosestOutpost()
	if  ClosestOutpost ~= nil and ClosestOutpostDist < 2200
	and not IsEnemyCloserToOutpostLoc(ClosestOutpost:GetLocation(), ClosestOutpostDist, 15)
	and IsSuitableToCaptureOutpost()
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(ClosestOutpost:GetLocation(), 1200)
		if J.IsRealInvisible(bot) then
			return BOT_MODE_DESIRE_VERYHIGH
		else
			return BOT_MODE_DESIRE_VERYHIGH - (#nInRangeEnemy * (0.9 / 5))
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function OnStart()

end

function OnEnd()
	ClosestOutpost = nil
	ClosestOutpostDist = 10000
	ShouldWaitInBaseToHeal = false
end

function Think()
	if bot:HasModifier('modifier_tinker_rearm')
	or bot:HasModifier('modifier_primal_beast_pulverize_self') then
		return
	end

	PrimalBeastTrample()
	HoodwinkSharpshooter()

	-- Void Spirit Dissimilate;
	-- modifier_void_spirit_dissimilate_phase returns false
	if DotaTime() < fDissimilateTime + 1.15
	then
		-- static locs, for now
		if bot.dissimilate_status ~= nil then
			if bot.dissimilate_status[1] == 'engaging' then
				if J.IsValidHero(bot.dissimilate_status[2]) then
					bot:Action_MoveToLocation(bot.dissimilate_status[2]:GetLocation())
					return
				else
					local target = nil
					local hp = 0
					local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
						and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						and hp < enemyHero:GetHealth()
						then
							hp = enemyHero:GetHealth()
							target = enemyHero
						end
					end

					if target ~= nil then
						bot:Action_MoveToLocation(target:GetLocation())
						return
					end
				end
			elseif bot.dissimilate_status[1] == 'farming' then
				local tEnemyCreeps = bot:GetNearbyCreeps(520, true)
				if J.CanBeAttacked(tEnemyCreeps[1])
				and (#tEnemyCreeps >= 4 or (#tEnemyCreeps >= 2 and tEnemyCreeps[1]:IsAncientCreep()))
				and not J.IsRunning(tEnemyCreeps[1])
				and J.IsAttacking(bot)
				then
					local nLocationAoE = bot:FindAoELocation(true, false, tEnemyCreeps[1]:GetLocation(), 0, 300, 0, 0)
					if nLocationAoE.count >= 2 then
						bot:Action_MoveToLocation(nLocationAoE.targetloc)
						return
					end
				end
			elseif bot.dissimilate_status[1] == 'miniboss' then
				bot:Action_MoveToLocation(bot.dissimilate_status[2]:GetLocation())
				return
			elseif bot.dissimilate_status[1] == 'retreating' then
				bot:Action_MoveToLocation(bot.dissimilate_status[2])
				return
			end
		end
	end

	-- Primal Beast (Onslaught)
	if bot:HasModifier('modifier_primal_beast_onslaught_windup') or bot:HasModifier('modifier_prevent_taunts') or bot:HasModifier('modifier_primal_beast_onslaught_movement_adjustable') then
		if bot.onslaught_status ~= nil then
			if bot.onslaught_status[1] == 'engage' then
				if J.IsValidHero(bot.onslaught_status[2]) then
					bot:Action_MoveToLocation(bot.onslaught_status[2]:GetLocation())
					return
				else
					local target = nil
					local targetHealth = math.huge
					for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
						if J.IsValidHero(enemy)
						and J.IsInRange(bot, enemy, 1600)
						and J.CanBeAttacked(enemy)
						and not J.IsEnemyBlackHoleInLocation(enemy:GetLocation())
						and not J.IsEnemyChronosphereInLocation(enemy:GetLocation())
						and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
						then
							local enemyHealth = enemy:GetHealth()
							if enemyHealth < targetHealth then
								targetHealth = enemyHealth
								target = enemy
							end
						end
					end

					if target ~= nil then
						bot:Action_MoveToLocation(target:GetLocation())
						return
					end

					for i = 1, 5 do
						local member = GetTeamMember(i)
						if J.IsValidHero(member)
						and J.IsInRange(bot, member, 1600)
						then
							local memberTarget = member:GetAttackTarget()
							if J.IsValidHero(memberTarget)
							and J.IsInRange(bot, memberTarget, 1600)
							and not J.IsEnemyBlackHoleInLocation(memberTarget:GetLocation())
							and not J.IsEnemyChronosphereInLocation(memberTarget:GetLocation())
							and not memberTarget:HasModifier('modifier_necrolyte_reapers_scythe')
							then
								bot:Action_MoveToLocation(memberTarget:GetLocation())
								return
							end
						end
					end
				end
			end
		elseif bot.onslaught_status[1] == 'retreat' then
			bot:Action_MoveToLocation(bot.onslaught_status[2])
			return
		elseif bot.onslaught_status[1] == 'farm' then
			local nCreeps = bot:GetNearbyCreeps(800, true)
			if J.IsValid(nCreeps[1])
			and not J.IsRunning(nCreeps[1])
			and J.CanBeAttacked(nCreeps[1])
			then
				local nLocationAoE = bot:FindAoELocation(true, false, nCreeps[1]:GetLocation(), 0, 200, 0, 0)
				if ((#nCreeps >= 4 and nLocationAoE.count >= 4))
				or (#nCreeps >= 2 and nLocationAoE.count >= 2 and nCreeps[1]:IsAncientCreep())
				then
					bot:Action_MoveToLocation(nLocationAoE.targetloc)
					return
				end
			end
		end
	end

	-- Spirit Breaker
	if bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		if  bot.chargeRetreat
		and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
		then
			bot:Action_MoveToLocation(bot:GetLocation() + RandomVector(150))
			bot.chargeRetreat = false
		end

		return
	end

	-- Batrider
	if bot:HasModifier('modifier_batrider_flaming_lasso_self')
	then
		bot:Action_MoveToLocation(J.GetTeamFountain())
		return
	end

	-- Rolling Thunder
	if bot:HasModifier('modifier_pangolier_gyroshell')
	then
		if J.IsInTeamFight(bot, 1600)
		then
			local target = nil
			local hp = 0
			for _, enemyHero in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES))
			do
				if J.IsValidHero(enemyHero)
				and J.IsInRange(bot, enemyHero, 2200)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and hp < enemyHero:GetHealth()
				then
					hp = enemyHero:GetHealth()
					target = enemyHero
				end
			end

			if target ~= nil
			then
				bot:Action_MoveToLocation(target:GetLocation())
				return
			end
		end

		local tAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		local tEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #tEnemyHeroes > #tAllyHeroes
		or (not J.WeAreStronger(bot, 1200) and J.GetHP(bot) < 0.55)
		or (#tEnemyHeroes > 0 and J.GetHP(bot) < 0.3) then
			bot:Action_MoveToLocation(J.GetTeamFountain())
			return
		end

		if J.IsValidHero(tEnemyHeroes[1])
		and not tEnemyHeroes[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			bot:Action_MoveToLocation(tEnemyHeroes[1]:GetLocation())
			return
		end

		local tCreeps = bot:GetNearbyCreeps(880, true)
		if J.IsValid(tCreeps[1])
		then
			bot:Action_MoveToLocation(tCreeps[1]:GetLocation())
			return
		end
	end

	-- Phoenix
	if bot:HasModifier('modifier_phoenix_sun_ray')
	then
		local nRadius = 130
		local nBeamDistance = 1150
		local vBeamEndLoc = J.GetFaceTowardDistanceLocation(bot, nBeamDistance)

		if J.IsValidHero(bot.sun_ray_target) then
			bot:Action_MoveToLocation(bot.sun_ray_target:GetLocation())
			return
		end

		-- beam other enemy
		local tEnemyHeroes = bot:GetNearbyHeroes(nBeamDistance, true, BOT_MODE_NONE)
		for _, enemy in pairs(tEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_necrolyte_reapers_scythe') then
				bot.sun_ray_target = enemy
				bot:Action_MoveToLocation(enemy:GetLocation())
				return
			end
		end

		-- heal ally
		local tInRangeAlly = bot:GetNearbyHeroes(nBeamDistance, false, BOT_MODE_NONE)
		for _, ally in pairs(tInRangeAlly)
		do
			if J.IsValidHero(ally)
			and J.GetHP(ally) < 0.5
			and ally:WasRecentlyDamagedByAnyHero(3.5)
			and not ally:IsIllusion()
			then
				if not J.IsRunning(ally)
				or ally:HasModifier('modifier_faceless_void_chronosphere_freeze')
				or ally:HasModifier('modifier_enigma_black_hole_pull') then
					bot.sun_ray_target = ally
					bot:Action_MoveToLocation(ally:GetLocation())
					return
				end
			end
		end
	end

	-- Snapfire
	if bot:HasModifier('modifier_snapfire_mortimer_kisses')
	then
		local nKissesTarget = GetMortimerKissesTarget()

		if nKissesTarget ~= nil
		then
			local eta = (GetUnitToUnitDistance(bot, nKissesTarget) / 1300) + 0.3
			bot:Action_MoveToLocation(J.GetCorrectLoc(nKissesTarget, eta))
			return
		end
	end

	-- IO Tether
	if bot:HasModifier('modifier_wisp_tether') and bot.tethered_ally ~= nil then
		local attackTarget = bot.tethered_ally:GetAttackTarget()
		if J.IsValid(attackTarget) and J.IsInRange(bot, attackTarget, bot:GetAttackRange() + 300)
		and not J.IsGoingOnSomeone(bot)
		then
			bot:SetTarget(attackTarget)
			bot:Action_AttackUnit(attackTarget, true)
			return
		end

		-- TODO: Less frontlining when engaging sometimes
		bot:Action_MoveToLocation(bot.tethered_ally:GetLocation())
		return
	end

	if J.CanNotUseAction(bot) then return end

	-- Lone Druid Bear
	if J.IsValid(LoneDruid.hero) and J.IsValid(LoneDruid.bear) then
		if bot.dropItem ~= nil and bot == LoneDruid.hero  then
			if GetUnitToUnitDistance(bot, LoneDruid.bear) > 80 then
				bot:Action_MoveDirectly(LoneDruid.bear:GetLocation())
				return
			else
				bot:Action_DropItem(bot.dropItem, LoneDruid.bear:GetLocation())
				LoneDruid.hero.isGiveItem = false
				return
			end
		end

		if bot == LoneDruid.bear then
			if LoneDruid.hero.isGiveItem == true then
				bot:Action_MoveDirectly(LoneDruid.hero:GetLocation())
				return
			else
				for _, droppedItem in pairs(GetDroppedItemList()) do
					if droppedItem ~= nil and droppedItem.owner == LoneDruid.hero then
						if droppedItem.item == LoneDruid.hero.dropItem then
							bot:Action_PickUpItem(LoneDruid.hero.dropItem)
							LoneDruid.hero.dropItem = nil
							return
						end
					end
				end
			end

			local botTarget = J.GetProperTarget(LoneDruid.hero)

			local nInRangeAlly = J.GetAlliesNearLoc(LoneDruid.hero:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(LoneDruid.hero:GetLocation(), 1200)
			local nEnemyCreeps = LoneDruid.hero:GetNearbyCreeps(700, true)

			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					if J.WillKillTarget(creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL, GetUnitToUnitDistance(bot, creep) / bot:GetCurrentMovementSpeed()) then
						bot:Action_AttackUnit(creep, true)
						return
					end
				end
			end

			if J.IsRetreating(LoneDruid.hero) then
				if #nInRangeEnemy > #nInRangeAlly then
					for _, enemy in pairs(nInRangeEnemy) do
						if J.IsValidHero(enemy)
						and J.IsInRange(LoneDruid.hero, enemy, 500)
						and J.CanBeAttacked(enemy)
						then
							bot:Action_AttackUnit(enemy, true)
							return
						end
					end
				end
			end

			if J.IsValid(botTarget) and not LoneDruid.hero:IsChanneling() and J.IsInRange(bot, LoneDruid.hero, 1100) then
				bot:Action_AttackUnit(botTarget, true)
				return
			else
				if DotaTime() >= fNextMovementTime then
					local heroLocation = LoneDruid.hero:GetLocation()
					local tempRadians = LoneDruid.hero:GetFacing() * math.pi / 180
					local rightVector = Vector(math.sin(tempRadians), -math.cos(tempRadians), 0)
					bot:Action_MoveToLocation(heroLocation + 150 * rightVector)
					fNextMovementTime = DotaTime() + RandomFloat(0.2, 0.5)
					return
				end
			end
		end
	end

	-- Huskar
	if ShouldHuskarMoveOutsideFountain
	then
		bot:Action_MoveToLocation(J.GetEnemyFountain())
		return
	end

	-- Get out of fountain if in item mode
	if ShouldHeroMoveOutsideFountain
	then
		bot:Action_MoveToLocation(J.GetEnemyFountain())
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

	-- Nyx Assassin
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

	-- Heal in Base
	-- Just for TP. Too much back and forth when "forcing" them try to walk to fountain; <- not reliable and misses farm.
	if ShouldWaitInBaseToHeal
	then
		if GetUnitToLocationDistance(bot, J.GetTeamFountain()) > 150
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
			if  J.Item.GetItemCharges(bot, 'item_tpscroll') >= 1
			and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			then
				if bot:GetUnitName() == 'npc_dota_hero_furion'
				then
					local Teleportation = bot:GetAbilityByName('furion_teleportation')
					if  Teleportation:IsTrained()
					and Teleportation:IsFullyCastable()
					then
						bot:Action_UseAbilityOnLocation(Teleportation, J.GetTeamFountain())
						return
					end
				end

				if J.CanCastAbility(TPScroll)
				then
					bot:Action_UseAbilityOnLocation(TPScroll, J.GetTeamFountain())
					return
				end
			end
		else
			if J.GetHP(bot) < 0.85 or J.GetMP(bot) < 0.85
			then
				if  J.Item.GetItemCharges(bot, 'item_tpscroll') <= 1
				and not J.IsMeepoClone(bot)
				and bot:GetGold() >= GetItemCost('item_tpscroll')
				and not string.find(bot:GetUnitName(), 'bear')
				then
					bot:ActionImmediate_PurchaseItem('item_tpscroll')
					return
				end

				bot:Action_MoveToLocation(bot:GetLocation() + 150)
				return
			else
				ShouldWaitInBaseToHeal = false
			end
		end
	end

	-- Tinker
	if TinkerShouldWaitInBaseToHeal
	then
		if J.GetHP(bot) < 0.8 or J.GetMP(bot) < 0.8 then
			return
		end
	end

	-- Broodmother web mid at the start of game; 7.37 change
	-- if bot.shouldWebMid == true
	-- then
	-- 	local targetLoc = Vector(-277, -139, 49)
    --     if GetTeam() == TEAM_DIRE
    --     then
    --         targetLoc = Vector(-768, -621, 56)
    --     end

	-- 	bot:Action_MoveToLocation(targetLoc)
	-- 	return
	-- end

	if ClosestOutpost ~= nil
	then
		if GetUnitToUnitDistance(bot, ClosestOutpost) > 300
		then
			bot:Action_MoveToLocation(ClosestOutpost:GetLocation())
			return
		else
			-- works
			if hAbilityCapture then
				bot:Action_UseAbilityOnEntity(hAbilityCapture, ClosestOutpost)
				return
			end
		end
	end
end

function GetClosestOutpost()
	local closest = nil
	local dist = 10000

	for i = 1, 2
	do
		if  Outposts[i] ~= nil
		and Outposts[i]:GetTeam() ~= GetTeam()
		and GetUnitToUnitDistance(bot, Outposts[i]) < dist
		and not Outposts[i]:IsNull()
		and not Outposts[i]:IsInvulnerable()
		then
			closest = Outposts[i]
			dist = GetUnitToUnitDistance(bot, Outposts[i])
		end
	end

	return closest, dist
end

function IsEnemyCloserToOutpostLoc(opLoc, botDist, fTime)
	for _, id in pairs(GetTeamPlayers(GetOpposingTeam()))
	do
		local info = GetHeroLastSeenInfo(id)

		if info ~= nil
		then
			local dInfo = info[1]
			if dInfo ~= nil
			then
				if  dInfo ~= nil
				and dInfo.time_since_seen < fTime
				and J.GetDistance(dInfo.location, opLoc) < botDist
				then
					return true
				end
			end
		end
	end

	return false
end

function IsSuitableToCaptureOutpost()
	local botTarget = J.GetProperTarget(bot)

	if (J.IsGoingOnSomeone(bot) and J.IsValidTarget(botTarget) and GetUnitToUnitDistance(bot, botTarget) < 1200)
	or J.IsDefending(bot)
	or (J.IsDoingTormentor(bot) and J.IsTormentor(botTarget))
	or (J.IsDoingRoshan(bot) and J.IsRoshan(botTarget))
	or J.IsRetreating(bot)
	or bot:WasRecentlyDamagedByAnyHero(5.0)
	or bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY
	then
		return false
	end

	return true
end

function TinkerWaitInBaseAndHeal()
	if  bot:GetUnitName() == 'npc_dota_hero_tinker'
	and bot.healInBase
	and GetUnitToLocationDistance(bot, J.GetTeamFountain()) < 500
	then
		return true
	end

	return false
end

function GetMortimerKissesTarget()
	for _, enemyHero in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES))
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, 3000 + (275 / 2))
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsInRange(bot, enemyHero, 600)
		then
			if J.IsLocationInChrono(enemyHero:GetLocation())
			or J.IsLocationInBlackHole(enemyHero:GetLocation())
			then
				return enemyHero
			end
		end

		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, 3000 + (275 / 2))
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsInRange(bot, enemyHero, 600)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return enemyHero
		end
	end

	local nCreeps = bot:GetNearbyCreeps(1600, true)
	if J.IsValid(nCreeps[1])
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

-- Just for TP. Too much back and forth when "forcing" them try to walk to fountain; <- not reliable and misses farm.
function ConsiderWaitInBaseToHeal()
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

	local ProphetTP = nil
	if bot:GetUnitName() == 'npc_dota_hero_furion'
	then
		ProphetTP = bot:GetAbilityByName('furion_teleportation')
	end

	if  not J.IsInLaningPhase()
	and not (J.IsFarming(bot) and J.IsAttacking(bot))
	and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
	and GetUnitToUnitDistance(bot, GetAncient(GetOpposingTeam())) > 2400
	and (  (TPScroll ~= nil and TPScroll:IsFullyCastable())
		or (ProphetTP ~= nil and ProphetTP:IsTrained() and ProphetTP:IsFullyCastable()))
	then
		if  (J.GetHP(bot) < 0.25
			and bot:GetHealthRegen() < 15
			and bot:GetUnitName() ~= 'npc_dota_hero_huskar'
			and bot:GetUnitName() ~= 'npc_dota_hero_slark'
			and bot:GetUnitName() ~= 'npc_dota_hero_necrolyte'
			and not bot:HasModifier('modifier_tango_heal')
			and not bot:HasModifier('modifier_flask_healing')
			and not bot:HasModifier('modifier_alchemist_chemical_rage')
			and not bot:HasModifier('modifier_arc_warden_tempest_double')
			and not bot:HasModifier('modifier_juggernaut_healing_ward_heal')
			and not bot:HasModifier('modifier_oracle_purifying_flames')
			and not bot:HasModifier('modifier_warlock_fatal_bonds')
			and not bot:HasModifier('modifier_item_satanic_unholy')
			and not bot:HasModifier('modifier_item_spirit_vessel_heal')
			and not bot:HasModifier('modifier_item_urn_heal'))
		or (((J.IsCore(bot) and J.GetMP(bot) < 0.25 and (J.GetHP(bot) < 0.75 and bot:GetHealthRegen() < 10))
				or ((not J.IsCore(bot) and J.GetMP(bot) < 0.25 and bot:GetHealthRegen() < 10)))
			and bot:GetUnitName() ~= 'npc_dota_hero_necrolyte'
			and not (J.IsPushing(bot) and #J.GetAlliesNearLoc(bot:GetLocation(), 900) >= 3))
		then
			ShouldWaitInBaseToHeal = true
			return true
		end
	end

	return false
end

function ConsiderHuskarMoveOutsideFountain()
	if bot:GetUnitName() == 'npc_dota_hero_huskar'
	then
		if  bot:HasModifier('modifier_fountain_aura_buff')
		and J.GetHP(bot) > 0.95
		then
			return true
		end
	end

	return false
end

function ConsiderHeroMoveOutsideFountain()
	if bot:GetActiveMode() == BOT_MODE_ITEM
	and bot:HasModifier('modifier_fountain_aura_buff')
	and J.GetHP(bot) > 0.95
	and J.GetMP(bot) > 0.95
	then
		return true
	end

	return false
end

-- Primal Beast Trample
local trample_step = 12
local trample = {}
local function DoTrample(vLoc)
	trample = J.GetPointsAroundVector(vLoc, 300, 12) -- go in circles
	if trample_step < 12 then
		bot:Action_MoveToLocation(trample[trample_step])
		trample_step = trample_step + 1
	else
		trample_step = 1
	end
end

local function TrampleToBase()
	trample_step = 12
	trample = {}
	bot:Action_MoveToLocation(J.GetTeamFountain())
end

function PrimalBeastTrample()
	if bot:HasModifier('modifier_primal_beast_trample') then
		local tAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		local tEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

		if #tEnemyHeroes > #tAllyHeroes + 1
		or (not J.WeAreStronger(bot, 800) and J.GetHP(bot) < 0.55)
		or (#tEnemyHeroes > 0 and J.GetHP(bot) < 0.3) then
			TrampleToBase()
			return
		end

		-- bot.trample_status {1 - type, 2 - location, 3 - target, if any}
		if bot.trample_status ~= nil and type(bot.trample_status) == "table" then
			if bot.trample_status[1] == 'engaging' then
				if J.IsValidHero(bot.trample_status[3]) then
					DoTrample(bot.trample_status[3]:GetLocation())
					return
				elseif #tEnemyHeroes > 0 then
					local target = nil
					local hp = 0
					for _, enemyHero in pairs(tEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.IsInRange(bot, enemyHero, 2200)
						and J.CanBeAttacked(enemyHero)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
						and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						and hp < enemyHero:GetHealth()
						then
							hp = enemyHero:GetHealth()
							target = enemyHero
						end
					end

					if target ~= nil then
						DoTrample(target:GetLocation())
						return
					end
				else
					if #tAllyHeroes >= #tEnemyHeroes and J.WeAreStronger(bot, 800) then
						for _, ally in pairs(tAllyHeroes) do
							if J.IsValidHero(ally) and not J.IsSuspiciousIllusion(ally) then
								local allyTarget = ally:GetAttackTarget()
								if J.IsValidHero(allyTarget) then
									DoTrample(allyTarget:GetLocation())
									return
								end
							end
						end
					end
				end
				TrampleToBase()
				return
			elseif bot.trample_status[1] == 'retreating' then
				TrampleToBase()
				return
			elseif bot.trample_status[1] == 'farming' or bot.trample_status[1] == 'laning' then
				local tCreeps = bot:GetNearbyCreeps(1200, true)
				if J.IsValid(tCreeps[1]) and J.CanBeAttacked(tCreeps[1])
				then
					local nLocationAoE = bot:FindAoELocation(true, false, tCreeps[1]:GetLocation(), 0, 300, 0, 0)
					if nLocationAoE.count > 0 then
						DoTrample(nLocationAoE.targetloc)
						return
					end
				else
					TrampleToBase()
					return
				end
			elseif bot.trample_status[1] == 'miniboss' then
				if J.IsValid(bot.trample_status[3]) then
					DoTrample(bot.trample_status[2])
					return
				else
					TrampleToBase()
					return
				end
			end
		end
		TrampleToBase()
		return
	end
end

-- Hoodwink Sharpshooter
function HoodwinkSharpshooter()
	if bot:HasModifier('modifier_hoodwink_sharpshooter_windup') then
		local Sharpshooter = bot:GetAbilityByName('hoodwink_sharpshooter')
		local nCastRange = Sharpshooter:GetCastRange()

		if J.IsValidHero(bot.sharpshooter_target) then
			bot:Action_MoveToLocation(bot.sharpshooter_target:GetLocation())
			return
		else
			local target = nil
			local targetHealth = math.huge
			for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
				if J.IsValidHero(enemy)
				and J.IsInRange(bot, enemy, nCastRange * 0.8)
				and J.CanCastOnNonMagicImmune(enemy)
				and not enemy:HasModifier('modifier_abaddon_borrowed_time')
				and not enemy:HasModifier('modifier_dazzle_shallow_grave')
				and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemy:HasModifier('modifier_item_aeon_disk_buff')
				and not enemy:HasModifier('modifier_item_blade_mail_reflect')
				then
					local enemyHealth = enemy:GetHealth()
					if enemyHealth < targetHealth then
						targetHealth = enemyHealth
						target = enemy
					end
				end
			end

			if target ~= nil then
				bot:Action_MoveToLocation(target:GetLocation())
				return
			end

			--
			for i = 1, 5 do
				local member = GetTeamMember(i)
				if J.IsValidHero(member)
				and J.IsInRange(bot, member, 1600)
				then
					local memberTarget = member:GetAttackTarget()
					if J.IsValidHero(memberTarget)
					and J.IsInRange(bot, memberTarget, nCastRange)
					and J.CanCastOnNonMagicImmune(memberTarget)
					and not memberTarget:HasModifier('modifier_abaddon_borrowed_time')
					and not memberTarget:HasModifier('modifier_dazzle_shallow_grave')
					and not memberTarget:HasModifier('modifier_necrolyte_reapers_scythe')
					and not memberTarget:HasModifier('modifier_item_aeon_disk_buff')
					and not memberTarget:HasModifier('modifier_item_blade_mail_reflect')
					then
						bot:Action_MoveToLocation(memberTarget:GetLocation())
						return
					end
				end
			end
		end
	end
end
