local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_alchemist'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_pipe", "item_nullifier"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
				[2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
	
				"item_magic_wand",
				"item_power_treads",
				"item_soul_ring",
				"item_radiance",--
				"item_blink",
				"item_black_king_bar",--
				"item_assault",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_assault",
				"item_soul_ring", "item_abyssal_blade",
				"item_power_treads", "item_travel_boots",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
				[2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
	
				"item_bottle",
				"item_magic_wand",
				"item_phase_boots",
				"item_soul_ring",
				"item_radiance",--
				"item_blink",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_abyssal_blade",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blink",
				"item_magic_wand", "item_black_king_bar",
				"item_soul_ring", "item_assault",
				"item_bottle", "item_abyssal_blade",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
				[2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
	
				"item_magic_wand",
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_radiance",--
				"item_crimson_guard",--
				"item_blink",
				sUtilityItem,--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_blink",
				"item_bracer", sUtilityItem,
				"item_soul_ring", "item_black_king_bar",
				"item_phase_boots", "item_travel_boots",
			},
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

local AcidSpray                 = bot:GetAbilityByName( "alchemist_acid_spray" )
local UnstableConcoction        = bot:GetAbilityByName( "alchemist_unstable_concoction" )
local UnstableConcoctionThrow   = bot:GetAbilityByName( "alchemist_unstable_concoction_throw" )
local ChemicalRage              = bot:GetAbilityByName( "alchemist_chemical_rage" )
local BerserkPotion             = bot:GetAbilityByName( "alchemist_berserk_potion" )

local AcidSprayDesire, AcidSprayLocation
local UnstableConcoctionDesire
local UnstableConcoctionThrowDesire, UnstableConcoctionThrowTarget
local BerserkPotionDesire, BerserkPotionTarget
local ChemicalRageDesire

local UnstableConcoctionCastTime = 0

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

	AcidSpray                 = bot:GetAbilityByName( "alchemist_acid_spray" )
	UnstableConcoction        = bot:GetAbilityByName( "alchemist_unstable_concoction" )
	UnstableConcoctionThrow   = bot:GetAbilityByName( "alchemist_unstable_concoction_throw" )
	ChemicalRage              = bot:GetAbilityByName( "alchemist_chemical_rage" )
	BerserkPotion             = bot:GetAbilityByName( "alchemist_berserk_potion" )

	botTarget = J.GetProperTarget(bot)
	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	botHP = J.GetHP(bot)
	bAttacking = J.IsAttacking(bot)

	ChemicalRageDesire = X.ConsiderChemicalRage()
	if ChemicalRageDesire > 0 then
		bot:Action_UseAbility(ChemicalRage)
		return
	end

	UnstableConcoctionThrowDesire, UnstableConcoctionThrowTarget = X.ConsiderUnstableConcoctionThrow()
	if UnstableConcoctionThrowDesire > 0 then
		bot:Action_UseAbilityOnEntity(UnstableConcoctionThrow, UnstableConcoctionThrowTarget)
		return
	end

	UnstableConcoctionDesire = X.ConsiderUnstableConcoction()
	if UnstableConcoctionDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(UnstableConcoction)
		UnstableConcoctionCastTime = DotaTime()
		return
	end

	AcidSprayDesire, AcidSprayLocation = X.ConsiderAcidSpray()
	if AcidSprayDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(AcidSpray, AcidSprayLocation)
		return
	end

	BerserkPotionDesire, BerserkPotionTarget = X.ConsiderBerserkPotion()
	if BerserkPotionDesire > 0 then
		bot:Action_UseAbilityOnEntity(BerserkPotion, BerserkPotionTarget)
		return
	end
end

function X.ConsiderAcidSpray()
	if not J.CanCastAbility(AcidSpray) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, AcidSpray:GetCastRange())
	local nCastPoint = AcidSpray:GetCastPoint()
	local nRadius = AcidSpray:GetSpecialValueInt('radius')
	local nManaCost = AcidSpray:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AcidSpray, UnstableConcoction, ChemicalRage})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {UnstableConcoction, ChemicalRage})

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end

		if nLocationAoE.count >= 3 and fManaAfter > fManaThreshold2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if not J.IsChasingTarget(bot, botTarget) and J.IsInRange(bot, botTarget, nCastRange) then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			elseif J.IsChasingTarget(bot, botTarget)
				and not J.IsInRange(bot, botTarget, nCastRange)
				and J.IsInRange(bot, botTarget, nCastRange + nRadius / 2)
				and J.GetHP(botTarget) < 0.2
			then
				return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange)
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius + nRadius / 2)
			and not J.IsDisabled(enemyHero)
			then
				local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget())
				or (#nEnemyHeroesTargetingMe >= 2 and botHP < 0.7)
				then
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and bAttacking and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		if #nEnemyHeroes <= 1 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 4) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold2 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3 and not J.HasItem(bot, 'item_radiance'))
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	local nEnemyLaneCreeps = bot:GetNearbyCreeps(800, true)
	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if J.IsLaning(bot) and J.IsInLaningPhase() and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes >= #nEnemyHeroes then
		for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
					if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToLocationDistance(nEnemyTowers[1], nLocationAoE.targetloc) > 1000) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and fManaAfter > fManaThreshold1
		and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and fManaAfter > fManaThreshold1
		and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderUnstableConcoction()
	if not J.CanCastAbility(UnstableConcoction) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, UnstableConcoction:GetCastRange())
	local nDamage = UnstableConcoction:GetSpecialValueInt('max_damage')
	local nManaCost = UnstableConcoction:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ChemicalRage, 75})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not J.IsChasingTarget(bot, enemyHero)
		and fManaAfter > fManaThreshold1
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL, GetUnitToUnitDistance(bot, enemyHero) / 900)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange - 150)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_legion_commander_duel')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			if J.IsInLaningPhase() then
				if (botTarget:GetHealth() + botTarget:GetHealthRegen() * 4.0) < J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 4.0) then
					return BOT_ACTION_DESIRE_HIGH
				end
			else
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot and botHP < 0.75)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderUnstableConcoctionThrow()
	if not J.CanCastAbility(UnstableConcoctionThrow) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, UnstableConcoctionThrow:GetCastRange())
	local nCastPoint = UnstableConcoctionThrow:GetCastPoint()
	local nDamage = UnstableConcoctionThrow:GetSpecialValueInt('max_damage')
	local nBrewTime = UnstableConcoctionThrow:GetSpecialValueInt('brew_time')

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling() and DotaTime() > UnstableConcoctionCastTime then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			local currDamage = RemapValClamped(DotaTime(), UnstableConcoctionCastTime, UnstableConcoctionCastTime + nBrewTime, 0, nDamage)

			if J.WillKillTarget(enemyHero, currDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint + (GetUnitToUnitDistance(bot, enemyHero) / 900))
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange - 150)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_legion_commander_duel')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if DotaTime() >= UnstableConcoctionCastTime + 4
			or J.IsStunProjectileIncoming(bot, 400)
			or J.IsUnitTargetProjectileIncoming(bot, 400)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if DotaTime() >= UnstableConcoctionCastTime + 2.0
				or J.IsStunProjectileIncoming(bot, 400)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsValidHero(nEnemyHeroes[1]) and DotaTime() >= UnstableConcoctionCastTime + 4.0 then
		return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBerserkPotion()
	if not J.CanCastAbility(BerserkPotion) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, BerserkPotion:GetCastRange())

	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:HasModifier('modifier_item_satanic_unholy')
		and not allyHero:IsMagicImmune()
		then
			if J.IsDisabled(allyHero) then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero)
			and J.IsRunning(allyHero)
			and J.GetHP(allyHero) < 0.5
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero) and J.IsCore(allyHero) then
				local allyTarget = J.GetProperTarget(allyHero)

				if  J.IsValidHero(allyTarget)
				and J.CanBeAttacked(allyTarget)
				and J.IsChasingTarget(allyTarget)
				and J.IsInRange(allyHero, allyTarget, 1200)
				and not J.IsSuspiciousIllusion(allyTarget)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end

				if J.GetHP(allyHero) < 0.3 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderChemicalRage()
	if not J.CanCastAbility(ChemicalRage) then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		if (bot:GetHealth() + bot:GetHealthRegen() * 5.0) < J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.0)
		and not (#nEnemyHeroes > #nAllyHeroes + 2)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking then
		if J.IsValid(botTarget) and botTarget:IsCreep() and botHP < 0.25 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) and bAttacking and bot:GetNetWorth() < 15000 then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) and bAttacking then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        then
			if bot:GetNetWorth() < 15000 or botHP < 0.3 then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X