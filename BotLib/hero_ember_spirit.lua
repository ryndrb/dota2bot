local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_ember_spirit'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,2,2,3,2,6,2,1,1,1,1,3,3,6,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
			
				"item_bottle",
				"item_boots",
				"item_magic_wand",
				"item_phase_boots",
				"item_mage_slayer",
				"item_maelstrom",
				"item_kaya",
				"item_black_king_bar",--
				"item_gungir",--
				"item_kaya_and_sange",--
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_travel_boots",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_kaya",
				"item_magic_wand", "item_black_king_bar",
				"item_bottle", "item_shivas_guard",
				"item_mage_slayer", "item_octarine_core",
			},
        },
        [2] = {-- physical
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
			
				"item_bottle",
                "item_blight_stone",
				"item_boots",
				"item_magic_wand",
				"item_phase_boots",
				"item_bfury",--
                "item_desolator",--
				"item_black_king_bar",--
                "item_greater_crit",--
				"item_aghanims_shard",
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_greater_crit",
				"item_bottle", "item_skadi",
			},
        },
    },
    ['pos_3'] = {
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
    ['pos_4'] = {
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
    ['pos_5'] = {
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
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end
end

end

local SearingChains 		= bot:GetAbilityByName( "ember_spirit_searing_chains" )
local SleightOfFist 		= bot:GetAbilityByName( "ember_spirit_sleight_of_fist" )
local FlameGuard 			= bot:GetAbilityByName( "ember_spirit_flame_guard" )
local ActivateFireRemnant 	= bot:GetAbilityByName( "ember_spirit_activate_fire_remnant" )
local FireRemnant 			= bot:GetAbilityByName( "ember_spirit_fire_remnant" )

local SearingChainsDesire
local SleightOfFistDesire, SleightOfFistLocation
local FlameGuardDesire
local ActivateFireRemnantDesire, ActivateRemnantLocation
local FireRemnantDesire, FireRemnantLocation

local SleightChainsDesire, SleightChainsLocation

local remnantCastTime = -100
local remnantCastGap  = 0.2

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    SearingChains 		    = bot:GetAbilityByName( "ember_spirit_searing_chains" )
    SleightOfFist 		    = bot:GetAbilityByName( "ember_spirit_sleight_of_fist" )
    FlameGuard 			    = bot:GetAbilityByName( "ember_spirit_flame_guard" )
    ActivateFireRemnant 	= bot:GetAbilityByName( "ember_spirit_activate_fire_remnant" )
    FireRemnant 			= bot:GetAbilityByName( "ember_spirit_fire_remnant" )

	SleightChainsDesire, SleightChainsLocation = X.ConsiderSleightChains()
	if SleightChainsDesire > 0
	then
		bot:Action_ClearActions(false)
		bot:ActionQueue_UseAbilityOnLocation(SleightOfFist, SleightChainsLocation)
        bot:ActionQueue_Delay(0.7)
		bot:ActionQueue_UseAbility(SearingChains)
		return
	end

	SleightOfFistDesire, SleightOfFistLocation = X.ConsiderSleightOfFist()
	if SleightOfFistDesire > 0
	then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SleightOfFist, SleightOfFistLocation)
		return
	end

	SearingChainsDesire = X.ConsiderSearingChains()
	if SearingChainsDesire > 0
	then
		bot:Action_UseAbility(SearingChains)
		return
	end

	FireRemnantDesire, FireRemnantLocation = X.ConsiderFireRemnant()
    if FireRemnantDesire > 0
	then
		bot:Action_UseAbilityOnLocation(FireRemnant, FireRemnantLocation)
		remnantCastTime = DotaTime()
		return
	end

	ActivateFireRemnantDesire, ActivateRemnantLocation = X.ConsiderActivateFireRemnant()
	if ActivateFireRemnantDesire > 0
	then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(ActivateFireRemnant, ActivateRemnantLocation)
		return
	end

	FlameGuardDesire = X.ConsiderFlameGuard()
	if FlameGuardDesire > 0
	then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(FlameGuard)
		return
	end
end

function X.ConsiderSearingChains()
    if not J.CanCastAbility(SearingChains)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = SearingChains:GetSpecialValueInt('radius')
	local nDamage = SearingChains:GetSpecialValueInt('damage_per_second')
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and not J.IsDisabled(enemyHero)
		then
			if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget )
        and not botTarget:IsAttackImmune()
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
			then
				if enemyHero:HasModifier('modifier_item_glimmer_cape')
				or enemyHero:HasModifier('modifier_invisible')
				or enemyHero:HasModifier('modifier_item_shadow_amulet_fade')
				then
					if  not enemyHero:HasModifier('modifier_item_dustofappearance')
					and not enemyHero:HasModifier('modifier_slardar_amplify_damage')
					and not enemyHero:HasModifier('modifier_bloodseeker_thirst_vision')
					and not enemyHero:HasModifier('modifier_sniper_assassinate')
					and not enemyHero:HasModifier('modifier_bounty_hunter_track')
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsDisarmed()
        and bot:WasRecentlyDamagedByAnyHero(3.5)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not J.IsDisabled(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(bot) > 0.2
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSleightOfFist()
	if not J.CanCastAbility(SleightOfFist)
    or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = SleightOfFist:GetSpecialValueInt('radius')
	local nCastRange = J.GetProperCastRange(false, bot, SleightOfFist:GetCastRange())
	local nCastPoint = SleightOfFist:GetCastPoint()
	local nDamage = bot:GetAttackDamage() + SleightOfFist:GetSpecialValueInt('bonus_hero_damage')
	local nAbilityLevel = SleightOfFist:GetLevel()
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsStunProjectileIncoming(bot, 300)
	then
		local nCreeps = bot:GetNearbyCreeps(nCastRange, true)

		if J.IsValid(nCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH, nCreeps[1]:GetLocation()
		elseif J.IsValidHero(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

		if nLocationAoE.count >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
        and not botTarget:IsAttackImmune()
		and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.7
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnMagicImmune(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsDisarmed()
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

    if  J.IsFarming(bot)
	and nAbilityLevel >= 3
    and J.GetManaAfter(SleightOfFist:GetManaCost()) > 0.35
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
		if nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        and J.IsAttacking(bot)
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
		end

        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end
	end

	if J.IsLaning(bot) and J.GetManaAfter(SleightOfFist:GetManaCost()) > 0.35
	then
        local kCreepList = {}

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= bot:GetAttackDamage()
			then
				if J.IsValidHero(nEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end

            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetHealth() <= bot:GetAttackDamage()
            then
                table.insert(kCreepList, creep)
            end
		end

        if #kCreepList >= 2
        and J.CanBeAttacked(kCreepList[1])
        and J.IsValidHero(nEnemyHeroes[1]) and GetUnitToUnitDistance(kCreepList[1], nEnemyHeroes[1]) <= 500
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(kCreepList)
        end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot))
	and nAbilityLevel >= 3
    and J.GetManaAfter(SleightOfFist:GetManaCost()) > 0.5
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not botTarget:IsAttackImmune()
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(bot) > 0.2
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFlameGuard()
	if not J.CanCastAbility(FlameGuard)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = FlameGuard:GetSpecialValueInt('radius')
	local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

	if J.IsInTeamFight(bot, 1200)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsGoingOnSomeone(bot)
	then
        if #nEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		if #nEnemyHeroes >= 1
        and bot:WasRecentlyDamagedByAnyHero(4)
        and bot:GetActiveModeDesire() > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot)
    and J.GetManaAfter(FlameGuard:GetManaCost()) > 0.4
    and J.IsAttacking(bot)
    and not (J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_mjollnir') or J.HasItem(bot, 'item_gungir'))
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
		if nNeutralCreeps ~= nil and #nNeutralCreeps >= 3
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius + 150, true)
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderActivateFireRemnant()
	if not J.CanCastAbility(ActivateFireRemnant)
    or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local botTarget = J.GetProperTarget(bot)

    local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
        if J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local closestRemnantToTarget = nil
            local targetDist = 100000

            for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
            do
                if  u ~= nil and u:GetUnitName() == 'npc_dota_ember_spirit_remnant'
                then
                    local dist = GetUnitToUnitDistance(u, botTarget)
                    if dist < targetDist
                    then
                        targetDist = dist
                        closestRemnantToTarget = u
                    end
                end
            end

            if closestRemnantToTarget ~= nil
            then
                if J.IsInLaningPhase()
                then
                    if botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH, closestRemnantToTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, closestRemnantToTarget:GetLocation()
                end
            end
        end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		local closestRemnantToAncient = nil
		local targetDist = 100000

		for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
		do
			if  u ~= nil and u:GetUnitName() == 'npc_dota_ember_spirit_remnant'
			then
				local dist = GetUnitToLocationDistance(u, J.GetTeamFountain())
				if dist < targetDist
				then
					targetDist = dist
					closestRemnantToAncient = u
				end
			end
		end

		if closestRemnantToAncient ~= nil
        and bot:GetActiveModeDesire() > 0.7
        and bot:WasRecentlyDamagedByAnyHero(4)
		then
			return BOT_ACTION_DESIRE_HIGH, closestRemnantToAncient:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFireRemnant()
	if not J.CanCastAbility(FireRemnant)
    or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if DotaTime() < remnantCastTime + remnantCastGap
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local remnantCount = 0
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
	do
		if  u ~= nil
		and u:GetUnitName() == 'npc_dota_ember_spirit_remnant'
		and GetUnitToUnitDistance(bot, u) < 1600
		then
			remnantCount = remnantCount + 1
		end
	end

	if remnantCount > 0
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, FireRemnant:GetCastRange())
	local nCastPoint = FireRemnant:GetCastPoint()
	local nDamage = FireRemnant:GetSpecialValueInt('damage')
	local nSpeed = bot:GetCurrentMovementSpeed() * (FireRemnant:GetSpecialValueInt('speed_multiplier') / (bot:HasScepter() and 50 or 100))
	local botTarget = J.GetProperTarget(bot)

	if nCastRange > 1600 then nCastRange = 1600 end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not J.IsInRange(bot, enemyHero, bot:GetAttackRange() + 150)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
		and GetUnitToUnitDistance(bot, enemyHero) > bot:GetAttackRange() - 25
		then
			local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
        and not botTarget:IsAttackImmune()
		and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint

			if J.IsInLaningPhase()
            then
                if botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
                end
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	and bot:GetActiveModeDesire() > 0.65
	then
		if bot:WasRecentlyDamagedByAnyHero(5)
		and nAllyHeroes ~= nil and nEnemyHeroes ~= nil
		and (#nEnemyHeroes >= #nAllyHeroes)
		and (#nEnemyHeroes >= 2 or J.GetHP(bot) < 0.5)
		and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), RandomInt(600, 1400))
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSleightChains()
	if X.CanDoSleightChains()
	then
		local nCastRange = J.GetProperCastRange(false, bot, SleightOfFist:GetCastRange())
        local botTarget = J.GetProperTarget(bot)
        local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if J.IsGoingOnSomeone(bot)
        then
            if  J.IsValidTarget(botTarget)
            and J.CanCastOnMagicImmune(botTarget)
            and not botTarget:IsAttackImmune()
            and J.IsInRange(bot, botTarget, nCastRange)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end

        if J.IsRetreating(bot)
        and not J.IsRealInvisible(bot)
        and bot:GetActiveModeDesire() > 0.7
        and bot:WasRecentlyDamagedByAnyHero(4)
        then
            if J.IsValidHero(nEnemyHeroes[1])
            and J.CanCastOnMagicImmune(nEnemyHeroes[1])
            and J.IsChasingTarget(nEnemyHeroes[1], bot)
            and not J.IsDisabled(nEnemyHeroes[1])
            and not nEnemyHeroes[1]:IsDisarmed()
            then
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoSleightChains()
	if  J.CanCastAbility(SleightOfFist)
    and J.CanCastAbility(SearingChains)
    and not bot:IsRooted()
    then
        local manaCost = SleightOfFist:GetManaCost() + SearingChains:GetManaCost()

        if  bot:GetMana() >= manaCost
        then
            return true
        end
    end

    return false
end

return X