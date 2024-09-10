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
			
				"item_double_bracer",
				"item_bottle",
				"item_urn_of_shadows",
				"item_magic_wand",
				"item_boots",
				"item_veil_of_discord",
				"item_spirit_vessel",
				"item_blade_mail",
				"item_kaya",
				"item_black_king_bar",--
				"item_heart",--
				"item_kaya_and_sange",--
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_bottle",
				"item_magic_wand",
				"item_spirit_vessel",
				"item_blade_mail",
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
				"item_heart",--
				sUtilityItem,--
				"item_shivas_guard",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_blade_mail",
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
			
				"item_urn_of_shadows",
				"item_boots",
				"item_magic_wand",
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
				"item_circlet",
				"item_magic_wand",
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
			
				"item_urn_of_shadows",
				"item_boots",
				"item_magic_wand",
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
				"item_circlet",
				"item_magic_wand",
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

local BoulderSmash = bot:GetAbilityByName( "earth_spirit_boulder_smash" )
local RollingBoulder = bot:GetAbilityByName( "earth_spirit_rolling_boulder" )
local GeomagneticGrip = bot:GetAbilityByName( "earth_spirit_geomagnetic_grip" )
local StoneRemnant = bot:GetAbilityByName( "earth_spirit_stone_caller" )
local Magnetize = bot:GetAbilityByName( "earth_spirit_magnetize" )
local GripAllies = bot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )
local EchantRemnant = bot:GetAbilityByName( "earth_spirit_petrify" )

local BoulderSmashDesire, BoulderSmashLocation, CanRemnantSmashCombo, CanKickNearbyStone
local RollingBoulderDesire, RollingBoulderLocation, CanRemnantRollCombo
local GeomagneticGripDesire, GeomagneticGripLocation, CanRemnantGrip
local StoneRemnantDesire
local EchantRemnantDesire
local MagnetizeDesire
local GripAlliesDesire

local nStone = 0

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

	BoulderSmash = bot:GetAbilityByName( "earth_spirit_boulder_smash" )
	RollingBoulder = bot:GetAbilityByName( "earth_spirit_rolling_boulder" )
	GeomagneticGrip = bot:GetAbilityByName( "earth_spirit_geomagnetic_grip" )
	StoneRemnant = bot:GetAbilityByName( "earth_spirit_stone_caller" )
	Magnetize = bot:GetAbilityByName( "earth_spirit_magnetize" )
	-- GripAllies = bot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )
	EchantRemnant = bot:GetAbilityByName( "earth_spirit_petrify" )

    if J.CanCastAbility(StoneRemnant)
    then
        nStone = 1
    else
        nStone = 0
    end

	EchantRemnantDesire, EnchantTarget = X.ConsiderEchantRemnant()
    if EchantRemnantDesire > 0
    then
		bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnEntity(EchantRemnant, EnchantTarget)
		bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, bot:GetLocation() + RandomVector(800))
		return
    end

	RollingBoulderDesire, RollingBoulderLocation, CanRemnantRollCombo = X.ConsiderRollingBoulder()
    if RollingBoulderDesire > 0
	then
		bot:Action_ClearActions(false)

		if CanRemnantRollCombo
		then
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, RollingBoulderLocation)
			return
		else
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, RollingBoulderLocation)
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
				bot:Action_ClearActions(false)
				bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, BoulderSmashLocation)
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
    local nRockKickDist = BoulderSmash:GetSpecialValueInt('rock_distance')
    local nUnitKickDist = BoulderSmash:GetSpecialValueInt('unit_distance')
	local stoneNearby = X.IsStoneNearby(bot:GetLocation(), nCastRange)
    local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRockKickDist)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local loc = J.GetCorrectLoc(enemyHero, GetUnitToUnitDistance(bot, enemyHero) / nSpeed)

			if stoneNearby
			then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true
			elseif nStone >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, loc, true, false
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				if nAllyHeroes ~= nil and #nAllyHeroes >= 2
				and J.IsValidHero(nAllyHeroes[#nAllyHeroes])
				and J.IsInRange(bot, nAllyHeroes[#nAllyHeroes], nUnitKickDist)
				and not J.IsInRange(bot, nAllyHeroes[#nAllyHeroes], nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, nAllyHeroes[#nAllyHeroes]:GetLocation(), false, true
				else
					return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nUnitKickDist), false, true
				end
			end
		end

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRockKickDist)
		then
			local loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / nSpeed)

            if not J.IsLocationInChrono(loc) and IsLocationPassable(loc)
			and ((J.IsInLaningPhase() and botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL) and nAllyHeroes ~= nil and #nAllyHeroes <= 1)
				or (not J.IsInLaningPhase() or nAllyHeroes ~= nil and #nAllyHeroes >= 2))
            then
                if stoneNearby
                and not J.IsInRange(bot, botTarget, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, false, true
                elseif nStone >= 1
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, true, false
                elseif nStone == 0
                then
                    for _, allyHero in pairs(nAllyHeroes)
                    do
                        if J.IsValidHero(allyHero)
                        and bot ~= allyHero
                        and not J.IsInRange(bot, botTarget, 600)
                        and GetUnitToLocationDistance(allyHero, loc) <= 800
                        and J.IsInRange(bot, allyHero, nCastRange)
                        and J.IsChasingTarget(allyHero, botTarget)
                        and botTarget:GetHealth() <= (allyHero:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                                                    + bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL))
                        then
                            return BOT_ACTION_DESIRE_HIGH, loc, false, true
                        end
                    end
                end
            end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 880)
        and bot:WasRecentlyDamagedByAnyHero(4)
        then
            if J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetEnemyFountain(), nUnitKickDist), false, true
            else
                if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
                and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
                then
                    if stoneNearby
                    then
                        return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation(), false, true
                    elseif nStone >= 1
                    then
                        if bot:IsFacingLocation(J.GetTeamFountain(), 30)
                        then
                            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation(), true, false
                        end
                    end
                end
            end
        end
	end

	if  J.IsLaning(bot)
	and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1600)))
	then
		if  nStone >= 1
		and J.GetMP(bot) > 0.35
		then
			local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

			for _, creep in pairs(nEnemyLaneCreeps)
			do
				if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
				and J.IsKeyWordUnit('ranged', creep)
				and creep:GetHealth() <= nDamage
                and not J.IsRunning(creep)
				then
					if J.IsValidHero(nEnemyHeroes[1])
					and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
					then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true, false
					end
				end
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
	local nDamage = RollingBoulder:GetSpecialValueInt('damage')
    local botTarget = J.GetProperTarget(bot)

	local nNearbyEnemySearchRange = nDistance
	if nStone >= 1
	then
		nNearbyEnemySearchRange = nDistance * 2
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nNearbyEnemySearchRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not bot:HasModifier('modifier_earth_spirit_rolling_boulder_caster')
		then
            if enemyHero:IsChanneling()
            or (J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe'))
            then
                local loc = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, target) / nSpeed) + nDelay)

                if X.IsStoneInPath(loc, GetUnitToLocationDistance(bot, loc))
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, false
                elseif nStone >= 1
                then
                    loc = J.GetCorrectLoc(enemyHero, (GetUnitToUnitDistance(bot, target) / (nSpeed + 600)) + nDelay)
                    return BOT_ACTION_DESIRE_HIGH, loc, true
                elseif nStone == 0
                then
                    if GetUnitToLocationDistance(bot, loc) > nDistance
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nDistance), false
                    else
                        return BOT_ACTION_DESIRE_HIGH, loc, false
                    end
                end
            end
		end
	end

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nDistance), false
	end

	if J.IsGoingOnSomeone(bot)
	then
        if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nNearbyEnemySearchRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / nSpeed)

            if nStone >= 1
            then
                loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / (nSpeed + 600))
                if X.IsStoneInPath(loc, GetUnitToUnitDistance(bot, botTarget))
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, false
                else
                    return BOT_ACTION_DESIRE_HIGH, loc, true
                end
            elseif nStone == 0
            then
                if GetUnitToLocationDistance(bot, loc) > nDistance
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nDistance), false
                else
                    return BOT_ACTION_DESIRE_HIGH, loc, false
                end
            end
        end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
        and (#nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) and bot:WasRecentlyDamagedByAnyHero(4)))
        then
            local loc = J.Site.GetXUnitsTowardsLocation(bot, J.GetEscapeLoc(), nDistance)

            if nStone >= 1
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and J.IsInRange(bot, nEnemyHeroes[1], 600)
				then
					return BOT_ACTION_DESIRE_HIGH, loc, true
				else
					return BOT_ACTION_DESIRE_HIGH, loc, false
				end
			elseif nStone == 0
			then
				return BOT_ACTION_DESIRE_HIGH, loc, false
			end
        end

        if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and bot:IsFacingLocation(J.GetTeamFountain(), 30)
        and J.IsRunning(bot)
        and bot:GetActiveModeDesire() > 0.7
        then
            local loc = J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nDistance)
            return BOT_ACTION_DESIRE_HIGH, loc, false
        end
	end

	if  J.GetMP(bot) > 0.88
	and bot:DistanceFromFountain() > 100
	and bot:DistanceFromFountain() < 6000
	and DotaTime() > 0
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

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderGeomagneticGrip()
    if not J.CanCastAbility(GeomagneticGrip)
	then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, GeomagneticGrip:GetCastRange())
	local nCastPoint = GeomagneticGrip:GetCastPoint()
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
            local loc = J.GetCorrectLoc(enemyHero, nCastPoint)

            if X.IsStoneNearTarget(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, loc, false
            elseif nStone >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, loc, true
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
            and creep:GetHealth() <= nDamage
            then
                if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
                then
                    if nStone >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true
                    elseif X.IsStoneNearTarget(creep)
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), false
                    end

                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderEchantRemnant()
	if not J.CanCastAbility(EchantRemnant)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	return BOT_ACTION_DESIRE_NONE, nil
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
		if #nEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if #nEnemyHeroes >= 2
            and bot:WasRecentlyDamagedByAnyHero(3)
            and bot:GetActiveModeDesire() > 0.8
            and J.GetHP(bot) < 0.4
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanBeAttacked(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- HELPER FUNCS --
function X.IsStoneNearby(vLoc, nRadius)
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_OTHER))
	do
		if  u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(u, vLoc) < nRadius
		then
			return true
		end
	end

	return false
end

function X.IsStoneInPath(vLoc, dist)
	if bot:IsFacingLocation(vLoc, 15)
	then
		for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_OTHER))
		do
			if  u ~= nil
			and u:GetUnitName() == "npc_dota_earth_spirit_stone"
			and bot:IsFacingLocation(u:GetLocation(), 15)
			and GetUnitToUnitDistance(u, bot) < dist
			then
				return true
			end
		end
	end

	return false
end

function X.IsStoneNearTarget(target)
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_OTHER))
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

return X