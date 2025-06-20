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

local defDuration = 2
local offDuration = 4.25
local ConcoctionThrowTime = 0

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

	AcidSpray                 = bot:GetAbilityByName( "alchemist_acid_spray" )
	UnstableConcoction        = bot:GetAbilityByName( "alchemist_unstable_concoction" )
	UnstableConcoctionThrow   = bot:GetAbilityByName( "alchemist_unstable_concoction_throw" )
	ChemicalRage              = bot:GetAbilityByName( "alchemist_chemical_rage" )
	BerserkPotion             = bot:GetAbilityByName( "alchemist_berserk_potion" )

	ChemicalRageDesire = X.ConsiderChemicalRage()
	if ChemicalRageDesire > 0
	then
		bot:Action_UseAbility(ChemicalRage)
		return
	end

	UnstableConcoctionThrowDesire, UnstableConcoctionThrowTarget = X.ConsiderUnstableConcoctionThrow()
	if UnstableConcoctionThrowDesire > 0
	then
		bot:Action_UseAbilityOnEntity(UnstableConcoctionThrow, UnstableConcoctionThrowTarget)
		return
	end

	UnstableConcoctionDesire = X.ConsiderUnstableConcoction()
	if UnstableConcoctionDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(UnstableConcoction)
		ConcoctionThrowTime = DotaTime()
		return
	end

	AcidSprayDesire, AcidSprayLocation = X.ConsiderAcidSpray()
	if AcidSprayDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(AcidSpray, AcidSprayLocation)
		return
	end

	BerserkPotionDesire, BerserkPotionTarget = X.ConsiderBerserkPotion()
	if BerserkPotionDesire > 0
	then
		bot:Action_UseAbilityOnEntity(BerserkPotion, BerserkPotionTarget)
		return
	end
end

function X.ConsiderAcidSpray()
	if not J.CanCastAbility(AcidSpray)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, AcidSpray:GetCastRange())
	local nCastPoint = AcidSpray:GetCastPoint()
	local nRadius = AcidSpray:GetSpecialValueInt('radius')
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)
	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
		if nLocationAoE.count >= 2
		then
			local realEnemyCount = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if realEnemyCount ~= nil and #realEnemyCount >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and J.IsAttacking(botTarget)
		and botTarget:IsFacingLocation(bot:GetLocation(), 45)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nCastRange + nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                if GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nInRangeEnemy)) > nCastRange
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            end

            if not J.IsInRange(bot, botTarget, nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if bot:GetActiveModeDesire() > 0.85
			and J.IsValidHero(enemyHero)
			and not J.IsDisabled(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, 600)
			and J.IsChasingTarget(enemyHero, bot)
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if (J.IsDefending(bot) or J.IsPushing(bot))
	then
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 5
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and not J.IsRunning(nEnemyLaneCreeps[1])
		and J.GetMP(bot) > 0.48
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if J.IsFarming(bot)
	then
		if  J.IsAttacking(bot)
		and J.GetMP(bot) > 0.35
		then
			local nNeutralCreeps = bot:GetNearbyNeutralCreeps(600)
			if  J.IsValid(nNeutralCreeps[1])
			and ((#nNeutralCreeps >= 3)
				or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
			end

			if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
			and J.CanBeAttacked(nEnemyLaneCreeps[1])
			and not J.IsRunning(nEnemyLaneCreeps[1])
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

	if J.IsLaning(bot)
	then
		if  J.IsAttacking(bot)
		and J.GetMP(bot) > 0.65
		then
			if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
			and J.CanBeAttacked(nEnemyLaneCreeps[1])
			and not J.IsRunning(nEnemyLaneCreeps[1])
			and J.IsValidBuilding(nEnemyTowers[1])
			and GetUnitToLocationDistance(nEnemyTowers[1], J.GetCenterOfUnits(nEnemyLaneCreeps)) > 800
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderUnstableConcoction()
	if not J.CanCastAbility(UnstableConcoction)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, UnstableConcoction:GetCastRange())
	local nDamage = UnstableConcoction:GetSpecialValueInt('max_damage')

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange - 150)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidTarget(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange - 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_legion_commander_duel')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if bot:GetLevel() < 6
				then
					if enemyHero:GetHealth() <= bot:GetEstimatedDamageToTarget(true, enemyHero, 3.5, DAMAGE_TYPE_ALL)
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				else
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
			and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
			and J.IsInRange(bot, enemyHero, nCastRange - 175)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderUnstableConcoctionThrow()
	if not J.CanCastAbility(UnstableConcoctionThrow)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, UnstableConcoctionThrow:GetCastRange())
	local nDamage = UnstableConcoction:GetSpecialValueInt("max_damage")

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		and DotaTime() >= ConcoctionThrowTime + offDuration
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidTarget(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange - 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_legion_commander_duel')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and DotaTime() >= ConcoctionThrowTime + offDuration
			then
				if bot:GetLevel() < 6
				then
					if enemyHero:GetHealth() <= bot:GetEstimatedDamageToTarget(true, enemyHero, 3.5, DAMAGE_TYPE_ALL)
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				else
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
			and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
			and J.IsInRange(bot, enemyHero, nCastRange - 175)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and DotaTime() >= ConcoctionThrowTime + defDuration
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
	and J.IsValidHero(nEnemyHeroes[1])
	and DotaTime() >= ConcoctionThrowTime + defDuration
	then
		return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBerserkPotion()
	if not J.CanCastAbility(BerserkPotion)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, BerserkPotion:GetCastRange())

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:HasModifier('modifier_item_satanic_unholy')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
		and not allyHero:IsIllusion()
		then
			if J.IsDisabled(allyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if  J.IsRetreating(allyHero)
			and J.IsRunning(allyHero)
			and J.GetHP(allyHero) < 0.6
			and allyHero:WasRecentlyDamagedByAnyHero(2.5)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = J.GetProperTarget(allyHero)

				if  J.IsValidHero(allyTarget)
				and allyHero:IsFacingLocation(allyTarget:GetLocation(), 20)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange() + 150)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end

				if J.GetHP(allyHero) < 0.33
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderChemicalRage()
	if not J.CanCastAbility(ChemicalRage)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
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
			if (bot:GetActiveModeDesire() > 0.5 and J.GetHP(bot) < 0.35)
			and J.IsValidHero(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot)
	then
		if  J.IsAttacking(bot)
		and J.IsValid(botTarget)
		and botTarget:IsCreep()
		and J.GetHP(bot) < 0.3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		and (J.IsModeTurbo() and DotaTime() < 15 * 60 or DotaTime() < 30 * 60)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
		and (J.IsModeTurbo() and DotaTime() < 16 * 60 or DotaTime() < 32 * 60)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X