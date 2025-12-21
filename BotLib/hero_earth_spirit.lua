local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_earth_spirit'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_bottle",
				"item_magic_wand",
				"item_double_bracer",
				"item_urn_of_shadows",
				"item_power_treads",
				"item_blade_mail",
				"item_spirit_vessel",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_kaya_and_sange",--
				"item_ultimate_scepter_2",
				"item_octarine_core",--
				"item_heart",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_power_treads",
				"item_magic_wand", "item_blade_mail",
				"item_bracer", "item_black_king_bar",
				"item_bracer", "item_shivas_guard",
				"item_bottle", "item_kaya_and_sange",
				"item_spirit_vessel", "item_octarine_core",
				"item_blade_mail", "item_travel_boots_2",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_gauntlets",
			
				"item_magic_wand",
				"item_boots",
				"item_double_bracer",
				"item_blade_mail",
				"item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_heart",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", sUtilityItem,
				"item_bracer", "item_shivas_guard",
				"item_blade_mail", "item_travel_boots_2",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,2,1,3,2,6,2,2,3,3,6,3,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_magic_stick",
			
				"item_boots",
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_force_staff",--
				"item_spirit_vessel",--
				"item_ancient_janggo",
				"item_black_king_bar",--
				"item_boots_of_bearing",--
				"item_shivas_guard",--
				"item_lotus_orb",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_lotus_orb",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,2,1,3,2,6,2,2,3,3,6,3,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_magic_stick",
			
				"item_boots",
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_force_staff",--
				"item_spirit_vessel",--
				"item_mekansm",
				"item_black_king_bar",--
				"item_guardian_greaves",--
				"item_shivas_guard",--
				"item_lotus_orb",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_lotus_orb",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

local bReadyToRoll = false

local BoulderSmash = bot:GetAbilityByName( "earth_spirit_boulder_smash" )
local RollingBoulder = bot:GetAbilityByName( "earth_spirit_rolling_boulder" )
local GeomagneticGrip = bot:GetAbilityByName( "earth_spirit_geomagnetic_grip" )
local StoneRemnant = bot:GetAbilityByName( "earth_spirit_stone_caller" )
local Magnetize = bot:GetAbilityByName( "earth_spirit_magnetize" )
local GripAllies = bot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )
local EnchantRemnant = bot:GetAbilityByName( "earth_spirit_petrify" )

local BoulderSmashDesire, BoulderSmashLocation, CanRemnantSmashCombo, CanKickNearbyStone
local RollingBoulderDesire, RollingBoulderLocation, CanRemnantRollCombo
local GeomagneticGripDesire, GeomagneticGripLocation, CanRemnantGrip
local EnchantRemnantDesire
local MagnetizeDesire
local GripAlliesDesire

local fBoulderSmashFarmTime = 0

local nStone = 0

local bAttacking = false
local botTarget, botHP, botLocation
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

	BoulderSmash = bot:GetAbilityByName( "earth_spirit_boulder_smash" )
	RollingBoulder = bot:GetAbilityByName( "earth_spirit_rolling_boulder" )
	GeomagneticGrip = bot:GetAbilityByName( "earth_spirit_geomagnetic_grip" )
	StoneRemnant = bot:GetAbilityByName( "earth_spirit_stone_caller" )
	Magnetize = bot:GetAbilityByName( "earth_spirit_magnetize" )
	-- GripAllies = bot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )
	EnchantRemnant = bot:GetAbilityByName( "earth_spirit_petrify" )

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
	botLocation = bot:GetLocation()
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.CanCastAbility(StoneRemnant) then
        nStone = 1
    else
        nStone = 0
    end

	X.RefreshMagnetize()

	local nLocationAoE1 = bot:FindAoELocation(true, false, bot:GetLocation(), 0, 200, 0, 0)
	local nLocationAoE2 = bot:FindAoELocation(true, true, bot:GetLocation(), 0, 200, 0, 0)
	local nLocationAoE3 = bot:FindAoELocation(false, false, bot:GetLocation(), 0, 200, 0, 0)
	local nLocationAoE4 = bot:FindAoELocation(false, true, bot:GetLocation(), 0, 200, 0, 0)
	local bUnitNearby = nLocationAoE1.count > 0 or nLocationAoE2.count > 0 or nLocationAoE3.count > 0 or nLocationAoE4.count > 1

	-- Enchant -> Boulder Smash doesn't work for ES
	EnchantRemnantDesire, EnchantTarget, ShouldBoulderSmash = X.ConsiderEnchantRemnant()
    if EnchantRemnantDesire > 0 then
		if ShouldBoulderSmash then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbilityOnEntity(EnchantRemnant, EnchantTarget)
			bot:ActionQueue_Delay(0.2 + 0.57)
			bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), 800))
			return
		else
			bot:Action_UseAbilityOnEntity(EnchantRemnant, EnchantTarget)
			return
		end
    end

	if bot:HasModifier('modifier_earthspirit_petrify') then return end

	RollingBoulderDesire, RollingBoulderLocation, CanRemnantRollCombo = X.ConsiderRollingBoulder()
    if RollingBoulderDesire > 0 then
		if CanRemnantRollCombo then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, RollingBoulderLocation)
			return
		else
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, RollingBoulderLocation)
			return
		end
	end

	MagnetizeDesire = X.ConsiderMagnetize()
    if MagnetizeDesire > 0 then
        bot:Action_UseAbility(Magnetize)
		return
    end

	GeomagneticGripDesire, GeomagneticGripLocation, CanRemnantGrip = X.ConsiderGeomagneticGrip()
    if GeomagneticGripDesire > 0 then
        if CanRemnantGrip then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, GeomagneticGripLocation)
			bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, GeomagneticGripLocation)
			return
		else
			J.SetQueuePtToINT(bot, false)
            bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, GeomagneticGripLocation)
			return
		end
	end

	BoulderSmashDesire, BoulderSmashLocation, CanRemnantSmashCombo, CanKickNearby = X.ConsiderBoulderSmash()
    if BoulderSmashDesire > 0 then
		if CanRemnantSmashCombo then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, BoulderSmashLocation)
			return
		else
			if CanKickNearby and bUnitNearby then
				J.SetQueuePtToINT(bot, false)
				bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, BoulderSmashLocation)
				return
			end
		end
	end
end

function X.ConsiderBoulderSmash()
    if not J.CanCastAbility(BoulderSmash) then
		return BOT_ACTION_DESIRE_NONE, 0, false, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, BoulderSmash:GetCastRange())
	local nSpeed = BoulderSmash:GetSpecialValueInt('speed')
	local nDamage = BoulderSmash:GetSpecialValueInt('rock_damage')
	local nRadius = BoulderSmash:GetSpecialValueInt('radius')
    local nRockKickDist = BoulderSmash:GetSpecialValueInt('rock_distance')
    local nUnitKickDist = BoulderSmash:GetSpecialValueInt('unit_distance')
	local bStoneNearby = X.IsStoneNearby(botLocation, nCastRange)
	local nManaCost = BoulderSmash:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {RollingBoulder, Magnetize})

	local nEnemyTowers = bot:GetNearbyTowers(1600, false)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and fManaAfter > fManaThreshold1
		then
			if J.IsInRange(bot, enemyHero, nRockKickDist) and not J.IsInRange(bot, enemyHero, nCastRange) then
				local eta = GetUnitToUnitDistance(bot, enemyHero) / nSpeed
				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local vLocation = J.GetCorrectLoc(enemyHero, eta)
					if bStoneNearby then
						return BOT_ACTION_DESIRE_HIGH, vLocation, false, true
					elseif nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, vLocation, true, false
					else
						local nInRangeAlly = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
						if #nInRangeAlly <= 1 then
							local unitList = GetUnitList(UNIT_LIST_ALL)
							for _, unit in ipairs(unitList) do
								if bot ~= unit and J.IsValid(unit) and J.IsInRange(bot, unit, nCastRange) then
									if unit:IsCreep() or J.IsValidHero(unit) then
										if X.IsUnitClosestToUnit(unit, bot) then
											return BOT_ACTION_DESIRE_HIGH, vLocation, false, true
										end
									end
								end
							end
						end
					end
				end
			end

			if J.IsInRange(bot, enemyHero, nRadius) and J.IsInLaningPhase() and fManaAfter > 0.5 then
				if J.IsValidBuilding(nEnemyTowers[1])
				and J.IsInRange(bot, nEnemyTowers[1], nUnitKickDist + 350)
				and nEnemyTowers[1]:GetAttackTarget() == nil
				and X.IsUnitClosestToUnit(enemyHero, bot)
				then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, nEnemyTowers[1]:GetLocation(), Min(nUnitKickDist, GetUnitToUnitDistance(bot, nEnemyTowers[1]))), false, true
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) and fManaAfter > fManaThreshold1 then
		if not bStoneNearby then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1200
				and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
					local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
					if #nInRangeAlly >= #nInRangeEnemy then
						local hTarget = X.GetFurthestUnitFromUnit(nAllyHeroes, bot)
						if J.IsValidHero(hTarget)
						and J.IsGoingOnSomeone(hTarget)
						and J.IsInRange(bot, hTarget, nUnitKickDist)
						and X.IsUnitClosestToUnit(hTarget, bot)
						and not J.IsInRange(bot, hTarget, nUnitKickDist * 0.4)
						then
							nInRangeAlly = J.GetAlliesNearLoc(hTarget:GetLocation(), 1200)
							nInRangeEnemy = J.GetEnemiesNearLoc(hTarget:GetLocation(), 1200)
							if #nInRangeAlly >= #nInRangeEnemy then
								local nDistance = Min(GetUnitToUnitDistance(bot, hTarget), nUnitKickDist)
								return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, hTarget:GetLocation(), nDistance), false, true
							end
						end
					end
				end
			end
		end

		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRockKickDist)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
		and not J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, 400)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			local bChasing = J.IsChasingTarget(bot, botTarget)
			local bMagicImmune = bot:IsMagicImmune()
			local eta = GetUnitToUnitDistance(bot, botTarget) / nSpeed
			local vLocation = J.GetCorrectLoc(botTarget, eta)

			if bStoneNearby and bChasing then
				if not bMagicImmune then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false, true
				end
			elseif nStone >= 1 and bChasing then
				if not bMagicImmune then
					return BOT_ACTION_DESIRE_HIGH, vLocation, true, false
				end
			elseif nStone == 0 and not bStoneNearby then
				local nInRangeAlly = J.GetSpecialModeAllies(bot, nCastRange, BOT_MODE_ATTACK)
				for _, allyHero in pairs(nInRangeAlly) do
					if bot ~= allyHero
					and J.IsValidHero(allyHero)
					and GetUnitToLocationDistance(allyHero, vLocation) <= nUnitKickDist
					and allyHero:GetAttackTarget() == botTarget
					and X.IsUnitClosestToUnit(allyHero, bot)
					then
						local nInRangeAlly2 = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
						local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
						if #nInRangeAlly2 >= #nInRangeEnemy
						and (botTarget:GetHealth() * 0.6) < J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 5.0)
						then
							return BOT_ACTION_DESIRE_HIGH, vLocation, false, true
						end
					end
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, 700)
			and J.IsChasingTarget(enemy, bot)
			then
				if (J.IsChasingTarget(enemy, bot))
				or ((#nEnemyHeroes > #nAllyHeroes or botHP < 0.5) and enemy:GetAttackTarget() == bot)
				then
					-- don't use stone
					local vEnemyLocation = enemy:GetLocation()
					if bStoneNearby then
						return BOT_ACTION_DESIRE_HIGH, vEnemyLocation, false, true
					else
						if J.IsInRange(bot, enemy, nCastRange) then
							return BOT_ACTION_DESIRE_HIGH, J.VectorAway(vEnemyLocation, botLocation, nUnitKickDist), false, true
						end
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and J.IsInRange(bot, creep, 800) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
					if X.IsUnitClosestToUnit(creep, bot) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
					elseif bStoneNearby then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
					elseif nStone > 0 and DotaTime() > fBoulderSmashFarmTime + 15 then
						fBoulderSmashFarmTime = DotaTime()
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true, false
					end
                end
            end
        end
	end

	if J.IsDefending(bot) and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 and fManaAfter > 0.4 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and J.IsInRange(bot, creep, 800) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
					if X.IsUnitClosestToUnit(creep, bot) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
					elseif bStoneNearby then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
					elseif nStone > 0 and DotaTime() > fBoulderSmashFarmTime + 15 then
						fBoulderSmashFarmTime = DotaTime()
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true, false
					end
                end
            end
        end
	end

	if J.IsFarming(bot) and fManaAfter > 0.4 and bAttacking then
		nEnemyCreeps = bot:GetNearbyCreeps(800, true)
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and J.IsInRange(bot, creep, 800) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 2 and fManaAfter > 0.6)
				then
					if X.IsUnitClosestToUnit(creep, bot) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
					elseif bStoneNearby then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
					elseif nStone > 0 and DotaTime() > fBoulderSmashFarmTime + 15 then
						fBoulderSmashFarmTime = DotaTime()
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true, false
					end
                end
            end
        end
	end

	if  J.IsLaning(bot)
	and J.IsInLaningPhase()
	and (J.IsCore(bot) or not J.IsThereCoreNearby(1000))
	and fManaAfter > 0.5
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsInRange(bot, creep, bot:GetAttackRange() * 2.5)
			and J.IsKeyWordUnit('ranged', creep)
			and not J.IsRunning(creep)
			then
				local eta = GetUnitToUnitDistance(bot, creep) / nSpeed
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					if (J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) and J.IsInRange(creep, nEnemyHeroes[1], 550))
					or J.IsUnitTargetedByTower(creep, false)
					then
						if bStoneNearby then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), false, true
						elseif nStone >= 1 then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true, false
						end
					end
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, false, botLocation, 800, nRadius, 0, nDamage)
		if nLocationAoE.count >= 3 then
			if bStoneNearby then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true, false
			end
		end
	end

	if fManaAfter > 0.5 and #nEnemyHeroes == 0 and (J.IsCore(bot) or not J.IsThereCoreNearby(1000)) then
		local nLocationAoE = bot:FindAoELocation(true, false, botLocation, 800, nRadius, 0, nDamage)
		if nLocationAoE.count >= 3 then
			if bStoneNearby then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false, true
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true, false
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false, false
end

function X.ConsiderRollingBoulder()
    if not J.CanCastAbility(RollingBoulder)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nDistance = RollingBoulder:GetSpecialValueInt('distance')
	local nDelay = RollingBoulder:GetSpecialValueFloat('delay')
	local nSpeed = RollingBoulder:GetSpecialValueInt('rock_speed')
	local nDamage = RollingBoulder:GetSpecialValueInt('damage') + bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
	local nRadius = RollingBoulder:GetSpecialValueInt('radius')
	local nManaCost = RollingBoulder:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BoulderSmash, GeomagneticGrip, EnchantRemnant, Magnetize})

	local nNearbyEnemySearchRange = nDistance
	if nStone >= 1 then
		nNearbyEnemySearchRange = nDistance * 2
    end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nDelay
			local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)

			if J.IsInRange(bot, enemyHero, nDistance) and #nInRangeAlly >= #nInRangeEnemy then
				if enemyHero:HasModifier('modifier_teleporting') then
					if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
						return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), false
					end
				elseif enemyHero:IsChanneling() then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), false
				end
			end

			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				local vLocation = J.GetCorrectLoc(enemyHero, eta)
				nInRangeAlly = J.GetAlliesNearLoc(vLocation, 1200)
				nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1200)
				if #nInRangeAlly >= #nInRangeEnemy then
					if bReadyToRoll then
						if X.ShouldRollThroughAlly(bot, enemyHero, enemyHero:GetLocation(), nRadius, 600) then
							return BOT_ACTION_DESIRE_HIGH, vLocation, false
						end
					end

					local nBotToEnemyDistance = GetUnitToLocationDistance(bot, vLocation)
					if nBotToEnemyDistance > nDistance then
						if X.IsStoneInPath(botLocation, vLocation, nRadius, nDistance) then
							return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), false
						elseif nStone >= 1 then
							vLocation = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, enemyHero) / (nSpeed + 600)) + nDelay)
							nBotToEnemyDistance = GetUnitToLocationDistance(bot, vLocation)
							if not X.IsStoneInPath(bot:GetLocation(), vLocation, nRadius, nDistance) then
								return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), true
							else
								return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), false
							end
						elseif nStone == 0 then
							return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), false
						end
					else
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end
				end
			end
		end
	end

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, J.GetTeamFountain(), nDistance), false
	end

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local vLocation = J.GetCorrectLoc(botTarget, (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nDelay)
			local nInRangeAlly = J.GetAlliesNearLoc(vLocation, 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1200)

			if #nInRangeAlly >= #nInRangeEnemy then
				if bReadyToRoll then
					if X.ShouldRollThroughAlly(bot, botTarget, botTarget:GetLocation(), nRadius, 600) then
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end
				end

				local nBotToEnemyDistance = GetUnitToLocationDistance(bot, vLocation)
				if X.IsStoneInPath(botLocation, vLocation, nRadius, nDistance) then
					if nBotToEnemyDistance < nDistance * 2 and not J.IsEnemyBlackHoleInLocation(vLocation) then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), false
					end
				elseif nStone >= 1 then
					vLocation = J.GetCorrectLoc(botTarget, (GetUnitToUnitDistance(bot, botTarget) / (nSpeed + 600)) + nDelay)
					nBotToEnemyDistance = GetUnitToLocationDistance(bot, vLocation)
					if nBotToEnemyDistance < nNearbyEnemySearchRange then
						if not J.IsEnemyBlackHoleInLocation(vLocation) then
							if not X.IsStoneInPath(botLocation, vLocation, nRadius, nDistance) then
								return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), true
							else
								return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), false
							end
						end
					end
				elseif nStone == 0 then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vLocation, Min(nBotToEnemyDistance, nDistance)), false
				end
			end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local vLocation = J.VectorTowards(botLocation, J.GetTeamFountain(), nDistance)
		if IsLocationPassable(vLocation) then
			for _, enemy in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemy)
				and not J.IsSuspiciousIllusion(enemy)
				and not J.IsRealInvisible(bot)
				then
					if (J.IsChasingTarget(enemy, bot) and bot:WasRecentlyDamagedByAnyHero(4.0))
					or ((#nEnemyHeroes > #nAllyHeroes or botHP < 0.6) and enemy:GetAttackTarget() == bot)
					then
						if X.IsStoneInPath(botLocation, vLocation, nRadius, nDistance) then
							return BOT_ACTION_DESIRE_HIGH, vLocation, false
						elseif nStone >= 1 then
							if J.IsInRange(bot, enemy, 700) then
								return BOT_ACTION_DESIRE_HIGH, vLocation, true
							else
								return BOT_ACTION_DESIRE_HIGH, vLocation, false
							end
						elseif nStone == 0 then
							return BOT_ACTION_DESIRE_HIGH, vLocation, false
						end
					end
				end
			end

			if #nEnemyHeroes == 0
			and bot:IsFacingLocation(J.GetTeamFountain(), 45)
			and J.IsRunning(bot)
			then
				return BOT_ACTION_DESIRE_HIGH, vLocation, false
			end

			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			if not J.IsInLaningPhase() then
				if #nEnemyHeroes >= #nInRangeAlly + 2 then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end
			end
		end
	end

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nDistance then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation, false
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nDistance then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation, false
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			local vLocation = J.VectorTowards(bot:GetLocation(), bot.farm.location, Min(nDistance, distance))
			if J.IsRunning(bot) and distance > nDistance / 2 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation, false
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold1 then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			local vLocation = J.VectorTowards(bot:GetLocation(), bot.rune.location, Min(nDistance, distance))
			if J.IsRunning(bot) and distance > nDistance / 2 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation, false
			end
		end
	end

	if J.IsDoingRoshan(bot) and fManaAfter > 0.5 then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		local distance = GetUnitToLocationDistance(bot, vRoshanLocation)
		if distance > 1600 then
			return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), vRoshanLocation, Min(distance, nDistance))
		end
	end

	if J.IsDoingTormentor(bot) and fManaAfter > 0.5 then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		local distance = GetUnitToLocationDistance(bot, vTormentorLocation)
		if distance > 1600 then
			return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), vTormentorLocation, Min(distance, nDistance))
		end
	end

	if fManaAfter > 0.85
	and bot:DistanceFromFountain() > 700
	and bot:DistanceFromFountain() < 6000
	and DotaTime() > 0
	and #nEnemyHeroes == 0
	and not J.IsDoingTormentor(bot)
	then
		if J.IsRunning(bot) and bot:GetMovementDirectionStability() >= 0.9 then
			local vLaneFrontLocationT = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)
			local vLaneFrontLocationM = GetLaneFrontLocation(GetTeam(), LANE_MID, 0)
			local vLaneFrontLocationB = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, bot:GetLocation())
			local vLaneFrontLocationTarget = Vector(0, 0, 0)

			if bot:IsFacingLocation(vLaneFrontLocationT, 45) then
				nDistFromLane = GetUnitToLocationDistance(bot, vLaneFrontLocationT)
				vLaneFrontLocationTarget = vLaneFrontLocationT
			elseif bot:IsFacingLocation(vLaneFrontLocationM, 45) then
				nDistFromLane = GetUnitToLocationDistance(bot, vLaneFrontLocationM)
				vLaneFrontLocationTarget = vLaneFrontLocationM
			elseif bot:IsFacingLocation(vLaneFrontLocationB, 45) then
				vLaneFrontLocationTarget = vLaneFrontLocationB
			end

			local vLocation = J.VectorTowards(bot:GetLocation(), vLaneFrontLocationTarget, nDistance)

			if IsLocationPassable(vLocation) then
				if nDistFromLane > 1200 then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end
			end
		end

	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderGeomagneticGrip()
    if not J.CanCastAbility(GeomagneticGrip) then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, GeomagneticGrip:GetCastRange())
	local nCastRange_ally = GeomagneticGrip:GetSpecialValueInt('cast_range_heroes')
	local nDamage = GeomagneticGrip:GetSpecialValueInt('rock_damage')
	local nRadius = GeomagneticGrip:GetSpecialValueInt('radius')
	local fManaAfter = J.GetManaAfter(GeomagneticGrip:GetManaCost())

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and bot ~= allyHero
		and J.IsInRange(bot, allyHero, nCastRange_ally + 300)
		and not J.IsInRange(bot, allyHero, nCastRange_ally * 0.8)
		and not J.IsDisabled(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not J.IsRealInvisible(allyHero)
		and not X.IsStoneNearLocation(allyHero:GetLocation(), nRadius)
		and not allyHero:IsChanneling()
		then
			if J.IsGoingOnSomeone(allyHero) then
				local allyHeroTarget = J.GetProperTarget(allyHero)
				if  J.IsValidHero(allyHeroTarget)
				and allyHeroTarget:IsFacingLocation(allyHeroTarget:GetLocation(), 15)
				and GetUnitToUnitDistance(allyHero, allyHeroTarget) > allyHero:GetAttackRange() + 50
				and GetUnitToUnitDistance(allyHero, allyHeroTarget) < allyHero:GetAttackRange() + 700
				and not J.IsSuspiciousIllusion(allyHeroTarget)
				and not allyHeroTarget:IsFacingLocation(allyHero:GetLocation(), 40)
				and #nAllyHeroes >= 3
				then
					local tResult = PointToLineDistance(allyHeroTarget:GetLocation(), allyHero:GetLocation(), bot:GetLocation())
					if tResult and tResult.within and tResult.distance <= 600 then
						return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation(), false
					end

					tResult = PointToLineDistance(bot:GetLocation(), allyHero:GetLocation(), allyHeroTarget:GetLocation())
					if tResult and tResult.within and tResult.distance <= 600 then
						return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation(), false
					end
				end
			end

			local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 900)
			if  J.IsRetreating(allyHero)
			and #nInRangeEnemy > 0
			and allyHero:IsFacingLocation(J.GetTeamFountain(), 30)
			and allyHero:DistanceFromFountain() > 1200
			and allyHero:WasRecentlyDamagedByAnyHero(5.0)
			then
				local tResult = PointToLineDistance(J.GetTeamFountain(), allyHero:GetLocation(), bot:GetLocation())
				if tResult and tResult.within and tResult.distance <= 600 then
					return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation(), false
				end
			end

			if J.IsStuck(allyHero) then
				return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation(), false
			end
		end
	end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not J.IsInRange(bot, enemyHero, bot:GetAttackRange() + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            if X.IsStoneNearLocation(enemyHero:GetLocation(), nRadius) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), false
			end

			local bEnemyBetween, vLocation = X.IsEnemyInBetweenMeAndStone(botLocation, enemyHero:GetLocation(), nRadius, nCastRange)
			if bEnemyBetween then
				return BOT_ACTION_DESIRE_HIGH, vLocation, false
			end

            if nStone >= 1 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), true
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and fManaAfter > 0.5 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and J.IsInRange(bot, nEnemyCreeps[1], 800)
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				if X.IsStoneNearLocation(nLocationAoE.targetloc, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
				end

				local bLocationBetween, vLocation = X.IsEnemyInBetweenMeAndStone(botLocation, nLocationAoE.targetloc, nRadius, nCastRange)
				if bLocationBetween then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end

				if nStone >= 1 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
				end
			end
		end
	end

	if J.IsDefending(bot) and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 and fManaAfter > 0.4 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and J.IsInRange(bot, nEnemyCreeps[1], 800)
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				if X.IsStoneNearLocation(nLocationAoE.targetloc, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
				end

				local bLocationBetween, vLocation = X.IsEnemyInBetweenMeAndStone(botLocation, nLocationAoE.targetloc, nRadius, nCastRange)
				if bLocationBetween then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end

				if nStone >= 1 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
				end
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > 0.4 and bAttacking then
		nEnemyCreeps = bot:GetNearbyCreeps(800, true)
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE.count >= 3)
			or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			or (nLocationAoE.count >= 2 and fManaAfter > 0.6)
			then
				if X.IsStoneNearLocation(nLocationAoE.targetloc, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
				end

				local bLocationBetween, vLocation = X.IsEnemyInBetweenMeAndStone(botLocation, nLocationAoE.targetloc, nRadius, nCastRange)
				if bLocationBetween then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end

				if nStone >= 1 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
				end
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > 0.3 then
        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and J.IsKeyWordUnit('ranged', creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                if (J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600)
				or J.IsUnitTargetedByTower(creep, false)
                then
					if X.IsStoneNearLocation(creep:GetLocation(), nRadius) then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), false
					end

					local bCreepBetween, vLocation = X.IsEnemyInBetweenMeAndStone(botLocation, creep:GetLocation(), nRadius, nCastRange)
					if bCreepBetween then
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end

					if nStone >= 1 then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true
					end
                end
            end
        end
	end

	if fManaAfter > 0.3 and #nAllyHeroes <= 2 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, nDamage)
			if nLocationAoE.count >= 3 then
				if X.IsStoneNearLocation(nLocationAoE.targetloc, nRadius) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
				end

				local bCreepBetween, vLocation = X.IsEnemyInBetweenMeAndStone(botLocation, nLocationAoE.targetloc, nRadius, nCastRange)
				if bCreepBetween then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end

				if nStone >= 1 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderEnchantRemnant()
	if not J.CanCastAbility(EnchantRemnant) then
		return BOT_ACTION_DESIRE_NONE, nil, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, EnchantRemnant:GetCastRange())
	local nCastRange_Ally = EnchantRemnant:GetSpecialValueInt('ally_cast_range')
	local fDuration = EnchantRemnant:GetSpecialValueFloat('duration')

	local nEnemyHeroesAttackingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	if J.IsInTeamFight(bot, 1200) then
		if #nEnemyHeroesAttackingMe >= 2 and botHP < 0.5 then
			return BOT_ACTION_DESIRE_HIGH, bot, false
		end
	end

	for _, ally in pairs(nAllyHeroes) do
        if J.IsValidHero(ally)
        and not J.IsRealInvisible(ally)
        and J.IsInRange(bot, ally, nCastRange_Ally)
        and not J.IsSuspiciousIllusion(ally)
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        and J.CanBeAttacked(ally)
        then
            if ally:HasModifier('modifier_legion_commander_duel')
            or ally:HasModifier('modifier_enigma_black_hole_pull')
            or ally:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
				return BOT_ACTION_DESIRE_HIGH, ally, false
            end

            local nInRangeAlly = J.GetAlliesNearLoc(ally:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(ally:GetLocation(), 1200)
			for _, enemy in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemy)
				and not J.IsSuspiciousIllusion(enemy)
				and not ally:HasModifier('modifier_teleporting')
				and not J.IsInEtherealForm(ally)
				and J.GetHP(ally) < 0.5
				then
					if #nInRangeEnemy >= #nInRangeAlly + 2
					and #nEnemyHeroesAttackingMe >= 2
					and J.IsInRange(bot, ally, 600)
					then
						if J.CanCastAbility(BoulderSmash) and bot:GetMana() > 350 and false then
							local nBSCastRange = BoulderSmash:GetCastRange()
							if J.IsInRange(bot, ally, nBSCastRange) then
								if ally ~= bot then
									return BOT_ACTION_DESIRE_HIGH, ally, true
								else
									return BOT_ACTION_DESIRE_HIGH, ally, false
								end
							end
						else
							return BOT_ACTION_DESIRE_HIGH, ally, false
						end
					end
				end
			end
        end
    end

	if botHP < 0.5
	and #nEnemyHeroesAttackingMe >= 1
    and not J.IsRealInvisible(bot)
    then
		if (GetUnitToUnitDistance(bot, nEnemyHeroesAttackingMe[1]) / nEnemyHeroesAttackingMe[1]:GetCurrentMovementSpeed()) > fDuration
		or #nAllyHeroes > #nEnemyHeroes
		then
			if J.IsStunProjectileIncoming(bot, 400)
			or (J.IsUnitTargetProjectileIncoming(bot, 400) and botHP < 0.2)
			or (J.IsAttackProjectileIncoming(bot, 400) and botHP < 0.1)
			then
				return BOT_ACTION_DESIRE_HIGH, bot, false
			end
		end
    end

	return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.ConsiderMagnetize()
	if not J.CanCastAbility(Magnetize) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Magnetize:GetSpecialValueInt('cast_radius')
	local nDamage = Magnetize:GetSpecialValueInt('damage_per_second')
	local fDuration = Magnetize:GetSpecialValueFloat('damage_duration')

	if J.IsInTeamFight(bot, 1200) then
		local nEnemyCount = 0
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, nRadius)
			and J.CanBeAttacked(enemy)
			and (J.IsLateGame() or not enemy:IsMagicImmune())
			and not J.IsSuspiciousIllusion(enemy)
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				nEnemyCount = nEnemyCount + 1
			end
		end

		if nEnemyCount >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.45
		and J.IsInRange(bot, botTarget, nRadius)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
		and not botTarget:IsMagicImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				if #nInRangeAlly <= 1 then
					if bot:GetEstimatedDamageToTarget(true, botTarget, fDuration, DAMAGE_TYPE_ALL) > (botTarget:GetHealth() + bot:GetHealthRegen() * fDuration * 0.75) then
						return BOT_ACTION_DESIRE_HIGH
					end
				else
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3) and botHP < 0.4 and not J.IsInTeamFight(bot, 1200) and #nAllyHeroes <= 2 then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, nRadius)
			and J.CanBeAttacked(enemy)
			and not enemy:IsMagicImmune()
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(enemy:GetLocation(), nRadius)
				if #nInRangeEnemy >= 2 then
					if J.IsChasingTarget(enemy, bot) or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot) then
						if J.WillKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL, fDuration) then
							return BOT_ACTION_DESIRE_HIGH
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local fRefreshTime = 0
function X.RefreshMagnetize()
	if nStone > 0 and Magnetize ~= nil and DotaTime() > fRefreshTime + 1 then
		local fDuration = Magnetize:GetSpecialValueFloat('damage_duration')

		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.IsInRange(bot, enemy, 1100)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.GetHP(enemy) > 0.2
			and enemy:HasModifier('modifier_earth_spirit_magnetize')
			and GetUnitToLocationDistance(enemy, J.GetEnemyFountain()) > 1200
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				if J.GetModifierTime(enemy, 'modifier_earth_spirit_magnetize') <= fDuration * 0.45 then
					bot:ActionPush_UseAbilityOnLocation(StoneRemnant, enemy:GetLocation())
					fRefreshTime = DotaTime()
					return
				end
			end
		end
	end
end

function X.IsStoneNearby(vLocation, nRadius)
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
	do
		if u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(u, vLocation) <= nRadius
		then
			return true
		end
	end

	return false
end

function X.IsStoneInPath(vStartLocation, vEndLocation, nRadius, nDistance)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValid(unit)
		and GetUnitToLocationDistance(unit, vStartLocation) <= nDistance
		and unit:GetUnitName() == "npc_dota_earth_spirit_stone"
		then
			local tResult = PointToLineDistance(vStartLocation, vEndLocation, unit:GetLocation())
			if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
				return true
			end
		end
	end

	return false
end

function X.IsStoneNearLocation(vLocation, nRadius)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if  J.IsValid(unit)
		and unit:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(unit, vLocation) <= nRadius
		then
			return true
		end
	end

	return false
end

function X.IsEnemyInBetweenMeAndStone(vLocation1, vLocation2, nRadius, nCastRange)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValid(unit)
		and unit:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(unit, vLocation1) <= nCastRange
		then
			local tResult = PointToLineDistance(vLocation1, unit:GetLocation(), vLocation2)
			if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
				return true, unit:GetLocation()
			end
		end
	end

	return false, nil
end

function X.GetFurthestUnitFromUnit(hUnitList, hUnit)
	local target = nil
	local targetDist = 0
	for _, ally in pairs(hUnitList) do
		if J.IsValidHero(ally) and hUnit ~= ally then
			local allyDist = GetUnitToUnitDistance(hUnit, ally)
			if allyDist > targetDist then
				target = ally
				targetDist = allyDist
			end
		end
	end

	return target
end

function X.ShouldRollThroughAlly(hSource, hTarget, vLocation, nRadius, nAllyRadius)
	if J.IsValidHero(hTarget) then
		local nInRangeAlly = hSource:GetNearbyHeroes(nAllyRadius, false, BOT_MODE_NONE)
		for _, allyHero in pairs(nInRangeAlly) do
			if allyHero ~= hSource
			and J.IsValidHero(allyHero)
			and (not J.IsRunning(allyHero) or J.IsChasingTarget(allyHero, hTarget))
			then
				local tResult = PointToLineDistance(hSource:GetLocation(), vLocation, allyHero:GetLocation())
				if tResult ~= nil and tResult.within and tResult.distance <= nRadius then return true end
			end
		end
	end

	return false
end

function X.IsUnitClosestToUnit(hUnit1, hUnit2)
	local nAllyCreeps = hUnit2:GetNearbyCreeps(1600, false)
	for _, creep in ipairs(nAllyCreeps) do
		if J.IsValid(creep) and creep ~= hUnit2 then
			if GetUnitToUnitDistance(creep, hUnit2) < GetUnitToUnitDistance(hUnit1, hUnit2) then
				return true
			end
		end
	end

	local nEnemyCreeps = hUnit2:GetNearbyCreeps(1600, true)
	for _, creep in ipairs(nEnemyCreeps) do
		if J.IsValid(creep) and creep ~= hUnit2 then
			if GetUnitToUnitDistance(creep, hUnit2) < GetUnitToUnitDistance(hUnit1, hUnit2) then
				return true
			end
		end
	end

	local nInRangeAlly = hUnit2:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	for _, hero in ipairs(nInRangeAlly) do
		if J.IsValidHero(hero) and hero ~= hUnit2 then
			if GetUnitToUnitDistance(hero, hUnit2) < GetUnitToUnitDistance(hUnit1, hUnit2) then
				return true
			end
		end
	end

	local nInRangeEnemy = hUnit2:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	for _, hero in ipairs(nInRangeEnemy) do
		if J.IsValidHero(hero) and hero ~= hUnit2 then
			if GetUnitToUnitDistance(hero, hUnit2) < GetUnitToUnitDistance(hUnit1, hUnit2) then
				return true
			end
		end
	end

	return false
end

return X