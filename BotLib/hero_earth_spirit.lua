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
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
			
				"item_bottle",
				"item_magic_wand",
				"item_double_bracer",
				"item_urn_of_shadows",
				"item_power_treads",
				"item_veil_of_discord",
				"item_spirit_vessel",
				"item_blade_mail",
				"item_kaya",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_kaya_and_sange",--
				"item_heart",--
				"item_ultimate_scepter",
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_power_treads",
				"item_magic_wand", "item_veil_of_discord",
				"item_bottle", "item_blade_mail",
				"item_bracer", "item_kaya",
				"item_bracer", "item_black_king_bar",
				"item_spirit_vessel", "item_heart",
				"item_blade_mail", "item_sheepstick",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
			
				"item_double_bracer",
				"item_magic_wand",
				"item_boots",
				"item_veil_of_discord",
				"item_blade_mail",
				"item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_shivas_guard",--
				"item_heart",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blade_mail",
				"item_magic_wand", "item_crimson_guard",
				"item_bracer", "item_black_king_bar",
				"item_bracer", sUtilityItem,
				"item_blade_mail", "item_travel_boots",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
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
			
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_boots",
				"item_spirit_vessel",--
				"item_force_staff",--
				"item_boots_of_bearing",--
				"item_black_king_bar",--
				"item_lotus_orb",--
				"item_shivas_guard",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_boots_of_bearing",
				"item_magic_wand", "item_black_king_bar",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
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
			
				"item_magic_wand",
				"item_urn_of_shadows",
				"item_boots",
				"item_spirit_vessel",--
				"item_force_staff",--
				"item_guardian_greaves",--
				"item_black_king_bar",--
				"item_lotus_orb",--
				"item_shivas_guard",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_boots_of_bearing",
				"item_magic_wand", "item_black_king_bar",
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

local bReadyToRoll = true

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

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

	BoulderSmash = bot:GetAbilityByName( "earth_spirit_boulder_smash" )
	RollingBoulder = bot:GetAbilityByName( "earth_spirit_rolling_boulder" )
	GeomagneticGrip = bot:GetAbilityByName( "earth_spirit_geomagnetic_grip" )
	StoneRemnant = bot:GetAbilityByName( "earth_spirit_stone_caller" )
	Magnetize = bot:GetAbilityByName( "earth_spirit_magnetize" )
	-- GripAllies = bot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )
	EnchantRemnant = bot:GetAbilityByName( "earth_spirit_petrify" )

    if J.CanCastAbility(StoneRemnant)
    then
        nStone = 1
    else
        nStone = 0
    end

	X.RefreshMagnetize()

	-- Enchant -> Boulder Smash doesn't work for ES
	EnchantRemnantDesire, EnchantTarget, ShouldBoulderSmash = X.ConsiderEnchantRemnant()
    if EnchantRemnantDesire > 0
    then
		if ShouldBoulderSmash then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnEntity(EnchantRemnant, EnchantTarget)
			bot:ActionQueue_Delay(0.2 + 0.57)
			bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), 800))
			return
		else
			bot:Action_UseAbilityOnEntity(EnchantRemnant, EnchantTarget)
			return
		end
    end

	RollingBoulderDesire, RollingBoulderLocation, CanRemnantRollCombo = X.ConsiderRollingBoulder()
    if RollingBoulderDesire > 0
	then
		if CanRemnantRollCombo
		then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, RollingBoulderLocation)
			return
		else
			bot:Action_UseAbilityOnLocation(RollingBoulder, RollingBoulderLocation)
			return
		end
	end

	MagnetizeDesire = X.ConsiderMagnetize()
    if MagnetizeDesire > 0
    then
        bot:Action_UseAbility(Magnetize)
		return
    end

	BoulderSmashDesire, BoulderSmashLocation, CanRemnantSmashCombo, CanKickNearby = X.ConsiderBoulderSmash()
    if BoulderSmashDesire > 0
	then
		if CanRemnantSmashCombo
		then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, BoulderSmashLocation)
			return
		else
			if CanKickNearby
			then
				bot:Action_UseAbilityOnLocation(BoulderSmash, BoulderSmashLocation)
				return
			end
		end
	end

	GeomagneticGripDesire, GeomagneticGripLocation, CanRemnantGrip = X.ConsiderGeomagneticGrip()
    if GeomagneticGripDesire > 0
	then
		bot:Action_ClearActions(false)

        if CanRemnantGrip
		then
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, GeomagneticGripLocation)
			bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, GeomagneticGripLocation)
			return
		else
            bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, GeomagneticGripLocation)
			return
		end
	end
end

function X.ConsiderBoulderSmash()
    if not J.CanCastAbility(BoulderSmash)
	then
		return BOT_ACTION_DESIRE_NONE, 0, false, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, BoulderSmash:GetCastRange())
	local nSpeed = BoulderSmash:GetSpecialValueInt('speed')
	local nDamage = BoulderSmash:GetSpecialValueInt('rock_damage')
	local nRadius = BoulderSmash:GetSpecialValueInt('radius')
    local nRockKickDist = BoulderSmash:GetSpecialValueInt('rock_distance')
    local nUnitKickDist = BoulderSmash:GetSpecialValueInt('unit_distance')
	local bStoneNearby = X.IsStoneNearby(bot:GetLocation(), nCastRange)
    local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and J.IsInRange(bot, enemyHero, nRockKickDist)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local loc = J.GetCorrectLoc(enemyHero, GetUnitToUnitDistance(bot, enemyHero) / nSpeed)
			if bStoneNearby then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, loc, true, false
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local hFurthestAlly = X.GetFurthestAllyFromBot(nAllyHeroes)
				if J.IsValidHero(hFurthestAlly)
				and J.IsInRange(bot, hFurthestAlly, nUnitKickDist)
				and not J.IsInRange(bot, hFurthestAlly, nUnitKickDist * 0.4)
				then
					return BOT_ACTION_DESIRE_HIGH, hFurthestAlly:GetLocation(), false, true
				end
			end
		end

		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRockKickDist)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			local loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / nSpeed)

			if bStoneNearby and not J.IsInRange(bot, botTarget, nCastRange)
			then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true
			elseif nStone >= 1
			then
				if J.IsChasingTarget(bot, botTarget)
				and not J.IsDisabled(botTarget)
				and not J.IsInRange(bot, botTarget, 500)
				then
					return BOT_ACTION_DESIRE_HIGH, loc, true, false
				end
			elseif nStone == 0 and not bStoneNearby
			then
				for _, allyHero in pairs(nAllyHeroes) do
					if J.IsValidHero(allyHero)
					and J.IsInRange(bot, allyHero, nCastRange)
					and bot ~= allyHero
					and not J.IsInRange(bot, botTarget, 600)
					and GetUnitToLocationDistance(allyHero, loc) <= nUnitKickDist
					and J.IsChasingTarget(allyHero, botTarget)
					and (botTarget:GetHealth() <= (allyHero:GetEstimatedDamageToTarget(true, botTarget, 8.0, DAMAGE_TYPE_ALL)
												+  bot:GetEstimatedDamageToTarget(true, botTarget, 8.0, DAMAGE_TYPE_ALL)))
					then
						return BOT_ACTION_DESIRE_HIGH, loc, false, true
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, 700)
			and J.IsChasingTarget(enemy, bot)
			and bot:WasRecentlyDamagedByAnyHero(4)
			then
				if J.IsInRange(bot, enemy, nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetEnemyFountain(), nUnitKickDist), false, true
				else
					if bStoneNearby and X.IsStoneInPath(bot:GetLocation(), enemy:GetLocation(), nRadius)
					then
						return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), false, true
					end
				end
			end
		end
	end

	if  J.IsLaning(bot)
	and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1000)))
	and J.GetManaAfter(BoulderSmash:GetManaCost()) > 0.3
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsInRange(bot, creep, bot:GetAttackRange() * 2.5)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			and not J.IsRunning(creep)
			then
				if J.IsValidHero(nEnemyHeroes[1])
				and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
				and J.IsInRange(creep, nEnemyHeroes[1], 550)
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

	if J.IsFarming(bot)
	and J.GetManaAfter(BoulderSmash:GetManaCost()) > 0.35
	and nStone > 0
	and DotaTime() > fBoulderSmashFarmTime + 18
	and J.IsAttacking(bot)
	then
		local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
		if J.CanBeAttacked(nEnemyCreeps[1])
		and not J.IsRunning(nEnemyCreeps[1])
		then
			local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
			if ((#nEnemyCreeps >= 3 and nLocationAoE.count >= 3)
			or (#nEnemyCreeps >= 2 and nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
			then
				fBoulderSmashFarmTime = DotaTime()
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
    local botTarget = J.GetProperTarget(bot)

	local nNearbyEnemySearchRange = nDistance
	if nStone >= 1
	then
		nNearbyEnemySearchRange = nDistance * 2
    end

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not bot:HasModifier('modifier_earth_spirit_rolling_boulder_caster')
		then
            if (enemyHero:IsChanneling() and J.IsInRange(bot, enemyHero, nDistance))
            or (J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
				and J.IsInRange(bot, enemyHero, nNearbyEnemySearchRange)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				)
            then
                local vLocation = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nDelay)

				if bReadyToRoll then
					if X.ShouldRollThroughAlly(bot, enemyHero, enemyHero:GetLocation(), nRadius, 600) then
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end
				end

				if X.IsStoneInPath(bot:GetLocation(), vLocation, nRadius)
				then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				elseif nStone >= 1
				then
					vLocation = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, enemyHero) / (nSpeed + 600)) + nDelay)
					if not X.IsStoneInPath(bot:GetLocation(), vLocation, nRadius)
					and GetUnitToLocationDistance(bot, vLocation) > nDistance
					then
						return BOT_ACTION_DESIRE_HIGH, vLocation, true
					else
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end
				elseif nStone == 0
				then
					if GetUnitToLocationDistance(bot, vLocation) > nDistance
					then
						return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, vLocation, nDistance), false
					else
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end
				end
            end
		end
	end

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nDistance), false
	end

	if J.IsGoingOnSomeone(bot)
	then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local vLocation = J.GetCorrectLoc(botTarget, (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nDelay)
			if bReadyToRoll then
				if X.ShouldRollThroughAlly(bot, botTarget, botTarget:GetLocation(), nRadius, 600) then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end
			end

			if X.IsStoneInPath(bot:GetLocation(), vLocation, nRadius) and J.IsInRange(bot, botTarget, nNearbyEnemySearchRange)
			then
				if not J.IsEnemyBlackHoleInLocation(vLocation) and not J.IsEnemyChronosphereInLocation(vLocation) then
					return BOT_ACTION_DESIRE_HIGH, vLocation, false
				end
            elseif nStone >= 1 and J.IsInRange(bot, botTarget, nNearbyEnemySearchRange)
			then
                vLocation = J.GetCorrectLoc(botTarget, (GetUnitToUnitDistance(bot, botTarget) / (nSpeed + 600)) + nDelay)
				if not J.IsEnemyBlackHoleInLocation(vLocation) and not J.IsEnemyChronosphereInLocation(vLocation) then
					if not X.IsStoneInPath(bot:GetLocation(), vLocation, nRadius)
					and GetUnitToLocationDistance(bot, vLocation) > nDistance
					then
						return BOT_ACTION_DESIRE_HIGH, vLocation, true
					else
						return BOT_ACTION_DESIRE_HIGH, vLocation, false
					end
				end
            elseif nStone == 0
            then
                if GetUnitToLocationDistance(bot, vLocation) > nDistance
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, vLocation, nDistance), false
                else
                    return BOT_ACTION_DESIRE_HIGH, vLocation, false
                end
            end
        end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		local vLocation = J.GetTeamFountain()
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and not J.IsSuspiciousIllusion(enemy)
			and (bot:WasRecentlyDamagedByHero(enemy, 3.0) or (J.GetHP(bot) < 0.5 and J.IsChasingTarget(enemy, bot)))
			then
				if nStone >= 1 then
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

        if #nEnemyHeroes == 0
        and bot:IsFacingLocation(J.GetTeamFountain(), 30)
        and J.IsRunning(bot)
        and bot:GetActiveModeDesire() > 0.7
        then
            return BOT_ACTION_DESIRE_HIGH, vLocation, false
        end

		local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		if not J.IsInLaningPhase() then
			if #nEnemyHeroes >= #nAllyHeroes + 2 then
				return BOT_ACTION_DESIRE_HIGH, vLocation, false
			end
		end
	end

	if  J.GetMP(bot) > 0.88
	and bot:DistanceFromFountain() > 100
	and bot:DistanceFromFountain() < 6000
	and DotaTime() > 0
	and #nEnemyHeroes == 0
	and not J.IsDoingTormentor(bot)
	then
		local nLaneFrontLocationT = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)
		local nLaneFrontLocationM = GetLaneFrontLocation(GetTeam(), LANE_MID, 0)
		local nLaneFrontLocationB = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)
		local nDistFromLane = GetUnitToLocationDistance(bot, bot:GetLocation())
		local facingFrontLoc = Vector(0, 0, 0)

		if bot:IsFacingLocation(nLaneFrontLocationT, 45)
		then
			nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocationT)
			facingFrontLoc = nLaneFrontLocationT
		elseif bot:IsFacingLocation(nLaneFrontLocationM, 45)
		then
			nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocationM)
			facingFrontLoc = nLaneFrontLocationM
		elseif bot:IsFacingLocation(nLaneFrontLocationB, 45)
		then
			nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocationB)
			facingFrontLoc = nLaneFrontLocationB
		end

		if nDistFromLane > 1600
		then
			local location = J.Site.GetXUnitsTowardsLocation(bot, facingFrontLoc, nDistance)

			if IsLocationPassable(location)
			then
				return BOT_ACTION_DESIRE_HIGH, location, false
			end
		end
	end

	if DotaTime() > 0 and bot:GetActiveMode() == BOT_MODE_RUNE then
		if J.IsRunning(bot) and bot:GetMovementDirectionStability() >= 0.9 then

			return BOT_ACTION_DESIRE_HIGH, J.GetFaceTowardDistanceLocation(bot, nDistance), false
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderGeomagneticGrip()
    if not J.CanCastAbility(GeomagneticGrip)
	then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, GeomagneticGrip:GetCastRange())
	local nDamage = GeomagneticGrip:GetSpecialValueInt('rock_damage')

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not J.IsInRange(bot, enemyHero, bot:GetAttackRange())
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if X.IsStoneNearTarget(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), false
            elseif nStone >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), true
            end
        end
    end

	if J.IsLaning(bot)
    and J.GetMP(bot) > 0.33
	then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and J.IsKeyWordUnit('ranged', creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                if J.IsValidHero(nEnemyHeroes[1])
				and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
                then
					if X.IsStoneNearTarget(creep)
					then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), false
					elseif nStone >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true
					end
                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderEnchantRemnant()
	if not J.CanCastAbility(EnchantRemnant)
	then
		return BOT_ACTION_DESIRE_NONE, nil, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, EnchantRemnant:GetCastRange())
	local nCastRange_Ally = EnchantRemnant:GetSpecialValueInt('ally_cast_range')

	local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)

	for _, ally in pairs(nAllyHeroes)
    do
        if J.IsValidHero(ally)
        and not J.IsRealInvisible(ally)
        and J.IsInRange(bot, ally, nCastRange_Ally)
        and not ally:IsIllusion()
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        and J.CanBeAttacked(ally)
        then
            if ally:HasModifier('modifier_legion_commander_duel')
            or ally:HasModifier('modifier_enigma_black_hole_pull')
            or ally:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
				return BOT_ACTION_DESIRE_HIGH, ally, false
            end

            local nAllyInRangeAlly = ally:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
            local nAllyInRangeEnemy = ally:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and (nAllyInRangeEnemy[1]:GetAttackTarget() == ally or J.IsChasingTarget(nAllyInRangeEnemy[1], ally))
            and #nAllyInRangeEnemy >= #nAllyInRangeAlly
            and not ally:HasModifier('modifier_teleporting')
            and not J.IsInEtherealForm(ally)
            and J.GetHP(ally) < 0.5
            then
				if J.CanCastAbility(BoulderSmash) and bot:GetMana() > 350 then
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

	if J.GetHP(bot) < 0.45 and X.IsBeingAttackedByRealHero(bot)
    and not J.IsRealInvisible(bot)
	and bot:IsFacingLocation(J.GetTeamFountain(), 30)
    then
		return BOT_ACTION_DESIRE_HIGH, bot, false
    end

	return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.ConsiderMagnetize()
	if not J.CanCastAbility(Magnetize)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Magnetize:GetSpecialValueInt('cast_radius')
	local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

	if J.IsInTeamFight(bot, 1200)
	then
		local nEnemyCount = 0
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				nEnemyCount = nEnemyCount + 1
			end
		end

		if nEnemyCount >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.GetHP(botTarget) > 0.45
		and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3)
	and J.GetHP(bot) < 0.4
	then
		if #nEnemyHeroes >= 2
		and J.IsValidHero(nEnemyHeroes[1])
		and bot:GetActiveModeDesire() > 0.8
		and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
		and J.CanBeAttacked(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local fRefreshTime = 0
function X.RefreshMagnetize()
	if nStone > 0 and Magnetize ~= nil and DotaTime() > fRefreshTime + 1 then
		local fDuration = Magnetize:GetSpecialValueFloat('damage_duration')
		local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1100)

		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.GetHP(enemy) > 0.2
			and enemy:HasModifier('modifier_earth_spirit_magnetize')
			and not enemy:HasModifier('modifier_abaddon_borrowed_time')
			and not enemy:HasModifier('modifier_dazzle_shallow_grave')
			and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				if J.GetModifierTime(enemy, 'modifier_earth_spirit_magnetize') <= fDuration * 0.45
				then
					bot:SetTarget(enemy)
					bot:Action_UseAbilityOnLocation(StoneRemnant, enemy:GetLocation())
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

function X.IsStoneInPath(vStartLocation, vEndLocation, nRadius)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES))
	do
		if unit ~= nil
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

function X.IsStoneNearTarget(target)
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
	do
		if  u ~= nil
		and u:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(u, target:GetLocation()) < 180
		then
			return true
		end
	end

	return false
end

function X.GetFurthestAllyFromBot(hAllyList)
	local target = nil
	local targetDist = 0
	for _, ally in pairs(hAllyList) do
		if J.IsValidHero(ally) and bot ~= ally then
			local allyDist = GetUnitToUnitDistance(bot, ally)
			if allyDist > targetDist then
				target = ally
				targetDist = allyDist
			end
		end
	end

	return target
end

function X.IsBeingAttackedByRealHero(unit)
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, 1600)
        and not J.IsSuspiciousIllusion(enemy)
        and (enemy:GetAttackTarget() == unit or J.IsChasingTarget(enemy, unit))
        then
            return true
        end
    end

    return false
end

function X.ShouldRollThroughAlly(hSource, hTarget, vLocation, nRadius, nAllyRadius)
	if J.IsValidHero(hTarget) then
		local nAllyHeroes = hSource:GetNearbyHeroes(nAllyRadius, false, BOT_MODE_NONE)
		for _, allyHero in pairs(nAllyHeroes) do
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

return X