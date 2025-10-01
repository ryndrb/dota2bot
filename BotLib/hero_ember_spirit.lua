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
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_maelstrom",
				"item_kaya_and_sange",--
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_wraith_band", "item_shivas_guard",
				"item_magic_wand", "item_ultimate_scepter",
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
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_bfury",--
                "item_desolator",--
				"item_black_king_bar",--
                "item_greater_crit",--
				"item_aghanims_shard",
				"item_skadi",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_wraith_band", "item_greater_crit",
				"item_magic_wand", "item_skadi",
			},
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
				"item_magic_wand",
				"item_phase_boots",
				"item_maelstrom",
				"item_mage_slayer",
				"item_kaya",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_kaya_and_sange",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_octarine_core",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_travel_boots_2",--
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
				"item_magic_wand",
				"item_boots",
                "item_blight_stone",
				"item_phase_boots",
				"item_bfury",--
                "item_desolator",--
				"item_black_king_bar",--
                "item_greater_crit",--
				"item_aghanims_shard",
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
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

local remnantCast = { time = math.huge, initialLocation = nil, targetLocation = nil }

local SoFLocation = nil

local bHasFarmingItem = false
local bHasFacet_ChainGang = false

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

    if J.CanNotUseAbility(bot) and not bot:HasModifier('modifier_ember_spirit_sleight_of_fist_caster') then return end

    SearingChains 		    = bot:GetAbilityByName( "ember_spirit_searing_chains" )
    SleightOfFist 		    = bot:GetAbilityByName( "ember_spirit_sleight_of_fist" )
    FlameGuard 			    = bot:GetAbilityByName( "ember_spirit_flame_guard" )
    ActivateFireRemnant 	= bot:GetAbilityByName( "ember_spirit_activate_fire_remnant" )
    FireRemnant 			= bot:GetAbilityByName( "ember_spirit_fire_remnant" )

	bHasFarmingItem = J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_mjollnir') or J.HasItem(bot, 'item_bfury') or J.HasItem(bot, 'item_radiance')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SleightOfFistDesire, SleightOfFistLocation, bTrySearingChains = X.ConsiderSleightOfFist()
	if SleightOfFistDesire > 0
	then
		SoFLocation = bTrySearingChains and SleightOfFistLocation or nil

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

	ActivateFireRemnantDesire, ActivateRemnantLocation = X.ConsiderActivateFireRemnant()
	if ActivateFireRemnantDesire > 0
	then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(ActivateFireRemnant, ActivateRemnantLocation)
		return
	end

	FireRemnantDesire, FireRemnantLocation = X.ConsiderFireRemnant()
    if FireRemnantDesire > 0
	then
		remnantCast.time = DotaTime()
		remnantCast.initialLocation = bot:GetLocation()
		remnantCast.targetLocation = FireRemnantLocation
		bot:Action_UseAbilityOnLocation(FireRemnant, FireRemnantLocation)
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
    if not J.CanCastAbility(SearingChains) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = SearingChains:GetSpecialValueInt('radius')
	local nDPS = SearingChains:GetSpecialValueInt('damage_per_second')
	local nDuration = SearingChains:GetSpecialValueFloat('duration')
	local nManaCost = SearingChains:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SearingChains, SleightOfFist, FlameGuard, ActivateFireRemnant})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SleightOfFist, FlameGuard, ActivateFireRemnant})

	if bot:HasModifier('modifier_ember_spirit_sleight_of_fist_caster') and SoFLocation ~= nil then
		if GetUnitToLocationDistance(bot, SoFLocation) <= nRadius then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and (J.IsInRange(bot, enemyHero, nRadius) or (bHasFacet_ChainGang and X.IsThereRemnantInLocation(enemyHero:GetLocation(), nRadius)))
		then
			if enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.CanKillTarget(enemyHero, nDPS * nDuration, DAMAGE_TYPE_MAGICAL)
			and not J.CanCastAbility(SleightOfFist)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and fManaAfter > fManaThreshold2
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) and not J.CanCastAbilitySoon(SleightOfFist, 3.0) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and (J.IsInRange(bot, botTarget, nRadius) or (bHasFacet_ChainGang and X.IsThereRemnantInLocation(botTarget:GetLocation(), nRadius)))
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
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

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and (J.IsInRange(bot, enemy, nRadius) or (not J.IsInRange(bot, enemy, nRadius) and bHasFacet_ChainGang and X.IsThereRemnantInLocation(enemy:GetLocation(), nRadius)))
			and not enemy:IsDisarmed()
			then
				local nInRangeEnemy = bot:GetNearbyHeroes(nRadius - 50, true, BOT_MODE_NONE)
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or #nInRangeEnemy >= 2
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if not bHasFarmingItem then
		if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes <= 1 then
			if J.IsValid(nEnemyCreeps[1])
			and J.CanBeAttacked(nEnemyCreeps[1])
			and #nEnemyCreeps >= 4
			and not J.CanCastAbility(SleightOfFist)
			and not bot:HasModifier('modifier_ember_spirit_flame_guard')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
			if J.IsValid(nEnemyCreeps[1])
			and J.CanBeAttacked(nEnemyCreeps[1])
			and #nEnemyCreeps >= 4
			and not J.CanCastAbility(SleightOfFist)
			and not bot:HasModifier('modifier_ember_spirit_flame_guard')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold2 then
			if J.IsValid(nEnemyCreeps[1])
			and J.CanBeAttacked(nEnemyCreeps[1])
			and not J.CanCastAbility(SleightOfFist)
			and not bot:HasModifier('modifier_ember_spirit_flame_guard')
			then
				if #nEnemyCreeps >= 4 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
        and J.GetHP(botTarget) > 0.2
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSleightOfFist()
	if not J.CanCastAbility(SleightOfFist)
    or bot:IsRooted()
	or bot:HasModifier('modifier_ember_spirit_sleight_of_fist_caster')
	then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, SleightOfFist:GetCastRange())
	local nCastPoint = SleightOfFist:GetCastPoint()
	local nRadius = SleightOfFist:GetSpecialValueInt('radius')
	local nDamage = SleightOfFist:GetSpecialValueInt('bonus_hero_damage')
	local nHeroDamage = bot:GetAttackDamage() + nDamage
	local nAbilityLevel = SleightOfFist:GetLevel()
	local nManaCost = SleightOfFist:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SearingChains, SleightOfFist, FlameGuard, ActivateFireRemnant})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SearingChains, FlameGuard, ActivateFireRemnant})

	local bHaveEnoughForCombo = false
	if SearingChains and SearingChains:IsTrained() then
		bHaveEnoughForCombo = bot:GetMana() > (SearingChains:GetManaCost() + SleightOfFist:GetManaCost() + 75)
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
		and J.CanKillTarget(enemyHero, nHeroDamage, DAMAGE_TYPE_PHYSICAL)
		and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local vLocation = (J.IsInRange(bot, enemyHero, nCastRange) and enemyHero:GetLocation()) or (J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange))
			return BOT_ACTION_DESIRE_HIGH, vLocation, false
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsStunProjectileIncoming(bot, 300) then
		if J.IsValid(nEnemyCreeps[1]) then
			return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]:GetLocation(), false
		end

		if J.IsValidHero(nEnemyHeroes[1]) and J.IsInRange(bot, nEnemyHeroes[1], nCastRange + nRadius) then
			local vLocation = (J.IsInRange(bot, nEnemyHeroes[1], nCastRange) and nEnemyHeroes[1]:GetLocation()) or (J.VectorTowards(bot:GetLocation(), nEnemyHeroes[1]:GetLocation(), nCastRange))
			return BOT_ACTION_DESIRE_HIGH, vLocation, false
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if (nLocationAoE.count >= 3 or #nInRangeEnemy >= 2) then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local bShouldChains =   not botTarget:IsMagicImmune()
								and not botTarget:IsStunned()
								and not botTarget:IsHexed()
								and not botTarget:IsRooted()
								and not botTarget:IsNightmared()

			if not J.CanCastAbility(SearingChains) and J.CanCastAbilitySoon(SearingChains, 3.0) and J.GetHP(botTarget) > 0.25 and bHaveEnoughForCombo then
				return BOT_ACTION_DESIRE_NONE
			end

			if J.CanCastAbility(SearingChains) and bHaveEnoughForCombo then
				if J.IsInRange(bot, botTarget, nCastRange + nRadius / 2) then
					local vLocation = (J.IsInRange(bot, botTarget, nCastRange) and botTarget:GetLocation()) or (J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange))
					return BOT_ACTION_DESIRE_HIGH, vLocation, bShouldChains
				end
			else
				if J.IsInRange(bot, botTarget, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), bShouldChains
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, 400)
            and not enemyHero:IsDisarmed()
            then
				local bIsIllusion = J.IsSuspiciousIllusion(enemyHero)
				local bShouldChains =   not enemyHero:IsMagicImmune()
									and not enemyHero:IsStunned()
									and not enemyHero:IsHexed()
									and not enemyHero:IsRooted()
									and not enemyHero:IsNightmared()

				if (J.IsChasingTarget(enemyHero, bot) and not bIsIllusion and J.CanCastAbility(SearingChains) and bHaveEnoughForCombo)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), bShouldChains
				end
            end
        end
	end

	if J.IsPushing(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold1 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            end
        end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking and nAbilityLevel >= 3 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase(bot) and fManaAfter > 0.3 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged') then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), false
					end
				end
			end
		end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, bot:GetAttackDamage())
		if nLocationAoE.count >= 2 and (fManaAfter > fManaThreshold2 or #nEnemyHeroes > 0) then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
		end
	end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.2
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), false
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), false
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderFlameGuard()
	if not J.CanCastAbility(FlameGuard)
	or bot:HasModifier('modifier_ember_spirit_sleight_of_fist_caster')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = FlameGuard:GetSpecialValueInt('radius')
	local nManaCost = FlameGuard:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SearingChains, SleightOfFist, ActivateFireRemnant})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SleightOfFist, ActivateFireRemnant})

	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	if J.IsInTeamFight(bot, 1200) then
		if #nEnemyHeroesTargetingMe >= 2 and fManaAfter > fManaThreshold2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if J.CanBeAttacked(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.IsInRange(bot, botTarget, nRadius)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if (#nEnemyHeroesTargetingMe > 0 and bot:WasRecentlyDamagedByAnyHero(2.0))
			or (#nEnemyHeroesTargetingMe > 1)
			or (botHP < 0.5 and bot:WasRecentlyDamagedByTower(2.0) and fManaAfter > fManaThreshold1)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		if (#nEnemyHeroesTargetingMe > 0 and botHP < 0.6)
		or (#nEnemyHeroes > #nAllyHeroes and bot:WasRecentlyDamagedByAnyHero(1.0))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and #nEnemyCreeps >= 4
		and not bot:HasModifier('modifier_ember_spirit_flame_guard')
		and not bHasFarmingItem
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not bot:HasModifier('modifier_ember_spirit_flame_guard')
		then
			if (#nEnemyCreeps >= 4 and not bHasFarmingItem) or #nEnemyCreeps >= 6 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking and #nEnemyHeroes <= 1 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and not bot:HasModifier('modifier_ember_spirit_flame_guard')
		then
			if (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) and bHasFarmingItem)
			or (#nEnemyCreeps >= 5)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold1
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

	if remnantCast.initialLocation ~= nil and FireRemnant then
		local nSpeed_1 = bot:GetCurrentMovementSpeed() * (FireRemnant:GetSpecialValueInt('speed_multiplier') / (bot:HasScepter() and 50 or 100))
		local nSpeed_2 = (ActivateFireRemnant:GetSpecialValueInt('speed')) * (ActivateFireRemnant:GetSpecialValueInt('speed_multiplier') / (bot:HasScepter() and 50 or 100))

		if DotaTime() < remnantCast.time + (J.GetDistance(remnantCast.initialLocation, remnantCast.targetLocation) / nSpeed_1) + FireRemnant:GetCastPoint()
					                    - ((J.GetDistance(remnantCast.initialLocation, remnantCast.targetLocation) / nSpeed_2) + ActivateFireRemnant:GetCastPoint())
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 600
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local hTarget = nil
            local hTargetDistance = math.huge
            for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
                if J.IsValid(unit) and unit:GetUnitName() == 'npc_dota_ember_spirit_remnant' then
					local nUnitDistToTarget = GetUnitToUnitDistance(unit, botTarget)
					if  hTargetDistance > nUnitDistToTarget
					and nUnitDistToTarget <= 600
					and GetUnitToUnitDistance(bot, unit) >= GetUnitToUnitDistance(bot, botTarget)
					then
						hTarget = unit
						hTargetDistance = nUnitDistToTarget
					end
                end
            end

			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)

			if hTarget ~= nil then
				if J.IsEarlyGame() then
					local fDuration = 6.0
					if (J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, fDuration) / (botTarget:GetHealth() + botTarget:GetHealthRegen() * fDuration)) >= 0.5
					or (J.GetHP(botTarget) < 0.3)
					or (J.GetHP(botTarget) < 0.5 and #nInRangeAlly >= 2)
					then
						return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
					end
				else
					return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
				end
			end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local hTarget = nil
		local hTargetDistance = -math.huge
		for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
			if J.IsValid(unit) and unit:GetUnitName() == 'npc_dota_ember_spirit_remnant' then
				local nUnitDistToFountain = GetUnitToLocationDistance(unit, J.GetTeamFountain())
				local nBotDistToFountain = GetUnitToLocationDistance(bot, J.GetTeamFountain())
				local nBotDistToUnit = GetUnitToUnitDistance(bot, unit)

				if nUnitDistToFountain < nBotDistToFountain and hTargetDistance < nBotDistToUnit then
					hTarget = unit
					hTargetDistance = nUnitDistToFountain
				end
			end
		end

		if hTarget ~= nil then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.IsInRange(bot, enemyHero, 1200)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not enemyHero:IsDisarmed()
				then
					if J.IsChasingTarget(enemyHero, bot)
					or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
					or botHP < 0.5
					then
						return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
					end
				end
			end
		end
	end

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValid(unit) and unit:GetUnitName() == 'npc_dota_ember_spirit_remnant' then
			local nInRangeAlly = J.GetAlliesNearLoc(unit:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(unit:GetLocation(), 1200)
			local nBotDistFromRemnant = GetUnitToUnitDistance(bot, unit)

			if J.IsGoingOnSomeone(bot) and #nInRangeAlly + 1 >= #nInRangeEnemy then
				local nCastPoint = FireRemnant:GetCastPoint()
				local nSpeed = ActivateFireRemnant:GetSpecialValueInt('speed')
				local nDamage = FireRemnant:GetSpecialValueInt('damage')
				local nRadius = FireRemnant:GetSpecialValueInt('radius')
				local bCanKill = X.CanRemnantKill(unit, nDamage, nCastPoint, nSpeed, nRadius, 1400)
				if bCanKill then
					return BOT_ACTION_DESIRE_HIGH, unit:GetLocation()
				end
			end

			if not J.IsRetreating(bot) and bot:HasModifier('modifier_fountain_aura_buff') and botHP > 0.9 and J.GetMP(bot) > 0.9 then
				if #nInRangeEnemy == 0 and nBotDistFromRemnant > 4000 then
					return BOT_ACTION_DESIRE_HIGH, unit:GetLocation()
				end
			end

			local vTeamFightLocation = J.GetTeamFightLocation(bot)
			if J.IsGoingOnSomeone(bot) and #nEnemyHeroes == 0 and vTeamFightLocation ~= nil and GetUnitToLocationDistance(bot, vTeamFightLocation) > 1600 then
				if GetUnitToLocationDistance(unit, vTeamFightLocation) <= 1200 then
					return BOT_ACTION_DESIRE_HIGH, unit:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFireRemnant()
	if not J.CanCastAbility(FireRemnant)
	or not J.CanCastAbility(ActivateFireRemnant)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = FireRemnant:GetCastRange()
	local nCastPoint = FireRemnant:GetCastPoint()
	local nDamage = FireRemnant:GetSpecialValueInt('damage')
	local nSpeed = bot:GetCurrentMovementSpeed() * (FireRemnant:GetSpecialValueInt('speed_multiplier') / (bot:HasScepter() and 50 or 100))

	if remnantCast.initialLocation ~= nil then
		if DotaTime() < remnantCast.time + (J.GetDistance(remnantCast.initialLocation, remnantCast.targetLocation) / nSpeed) + nCastPoint then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and GetUnitToLocationDistance(enemyHero, J.GetTeamFountain()) > 600
        and J.IsInRange(bot, enemyHero, 1400)
        and not J.IsInRange(bot, enemyHero, 400)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay) then
				if J.IsChasingTarget(bot, enemyHero) and enemyHero:GetMovementDirectionStability() >= 0.9 then
					local vLocation = J.VectorAway(enemyHero:GetLocation(), bot:GetLocation(), 500)
					if GetUnitToLocationDistance(bot, vLocation) <= 1400 and not X.IsThereRemnantInLocation(vLocation, 500) then
						return BOT_ACTION_DESIRE_HIGH, vLocation
					end
				else
					if not X.IsThereRemnantInLocation(enemyHero:GetLocation(), 500) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and GetUnitToLocationDistance(botTarget, J.GetTeamFountain()) > 600
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local bIsChasingTarget = J.IsChasingTarget(bot, botTarget)
			local nAllyHeroesTargetingEnemy = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint

			if (J.CanCastAbility(SearingChains) and J.CanCastAbility(SleightOfFist))
			or (#nAllyHeroesTargetingEnemy >= 2 and (bIsChasingTarget or not J.IsInRange(bot, botTarget, 550)))
			or (botHP > 0.3 and J.GetHP(botTarget) < 0.15)
			then
				local vLocation = J.VectorAway(J.GetCorrectLoc(botTarget, nDelay), bot:GetLocation(), 400)
				if GetUnitToLocationDistance(bot, vLocation) <= nCastRange and not X.IsThereRemnantInLocation(vLocation, 500) then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if (J.IsChasingTarget(enemyHero, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.4)
				then
					local vLocation = J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), RandomInt(nCastRange * 0.75, nCastRange))
					if not X.IsThereRemnantInLocation(bot:GetLocation(), nCastRange) then
						return BOT_ACTION_DESIRE_HIGH, vLocation
					end
				end
			end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsThereRemnantInLocation(vLocation, nRadius)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if  unit ~= nil
		and unit:GetUnitName() == 'npc_dota_ember_spirit_remnant'
		and GetUnitToLocationDistance(unit, vLocation) <=  nRadius
		then
			return true
		end
	end

	return false
end

function X.CanRemnantKill(unit, nDamage, nCastPoint, nSpeed, nDamageRadius, nRadius)
	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and GetUnitToLocationDistance(enemyHero, J.GetTeamFountain()) > 600
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			local vLocation = J.GetCorrectLoc(enemyHero, nDelay)
			if GetUnitToLocationDistance(bot, vLocation) <= nRadius then
				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay) then
					local tResult = PointToLineDistance(bot:GetLocation(), unit:GetLocation(), vLocation)
					if tResult and tResult.within and tResult.distance <= nDamageRadius then
						return true
					end
				end
			end
		end
	end

	return false
end

return X