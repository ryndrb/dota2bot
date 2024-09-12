local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

if GetBot():GetUnitName() == 'npc_dota_hero_abaddon'
then

local sUtility = {"item_pipe", "item_heavens_halberd", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_orb_of_venom",
                "item_circlet",

                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_phase_boots",
                "item_echo_sabre",
                "item_manta",--
                "item_harpoon",--
                "item_black_king_bar",--
                "item_skadi",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_travel_boots_2",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
            }
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_orb_of_venom",
                "item_circlet",

                "item_bottle",
                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_phase_boots",
                "item_echo_sabre",
                "item_manta",--
                "item_assault",--
                "item_harpoon",--
                "item_aghanims_shard",
                "item_basher",
                "item_heart",--
                "item_ultimate_scepter",
                "item_travel_boots",
                "item_abyssal_blade",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bottle",
                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
            }
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
    
                "item_gloves",
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_phase_boots",
                "item_radiance",--
                "item_crimson_guard",--
                "item_assault",--
                sUtilityItem,--
                "item_ultimate_scepter",
                "item_heart",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_magic_wand",
                "item_orb_of_corrosion",
            }
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
    
                "item_tranquil_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_holy_locket",--
                "item_ultimate_scepter",
                "item_force_staff",--
                "item_boots_of_bearing",--
                "item_lotus_orb",--
                "item_wind_waker",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard"
            },
            ['sell_list'] = {
                "item_circlet",
            }
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
    
                "item_arcane_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_holy_locket",--
                "item_ultimate_scepter",
                "item_force_staff",--
                "item_guardian_greaves",--
                "item_lotus_orb",--
                "item_wind_waker",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard"
            },
            ['sell_list'] = {
                "item_circlet",
            }
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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local MistCoil          = bot:GetAbilityByName( 'abaddon_death_coil' )
local AphoticShield     = bot:GetAbilityByName( 'abaddon_aphotic_shield' )
-- local CurseOfAvernus    = bot:GetAbilityByName( 'abaddon_frostmourne' )
-- local BorrowedTimelocal = bot:GetAbilityByName( 'abaddon_borrowed_time' )

local MistCoilDesire, MistCoilTarget
local AphoticShieldDesire, AphoticShieldTarget

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    MistCoil = bot:GetAbilityByName( 'abaddon_death_coil' )
    AphoticShield = bot:GetAbilityByName( 'abaddon_aphotic_shield' )

    botTarget = J.GetProperTarget(bot)

    AphoticShieldDesire, AphoticShieldTarget = X.ConsiderAphoticShield()
    if AphoticShieldDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(AphoticShield, AphoticShieldTarget)
        return
    end

    MistCoilDesire, MistCoilTarget = X.ConsiderMistCoil()
    if MistCoilDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(MistCoil, MistCoilTarget)
        return
    end
end

function X.ConsiderAphoticShield()
    if not J.CanCastAbility(AphoticShield)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, AphoticShield:GetCastRange())

    local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
	do
        if  J.IsValidHero(allyHero)
        and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull')
            or allyHero:HasModifier('modifier_legion_commander_duel'))
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

        if  J.IsValidHero(allyHero)
        and J.IsDisabled(allyHero)
        and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

		if  J.IsValidHero(allyHero)
        and not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
        and not allyHero:HasModifier('modifier_item_solar_crest_armor_addition')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and J.IsNotSelf(bot, allyHero)
		then
            if  J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(1.6)
            and not allyHero:IsIllusion()
            then
                local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(800, true, BOT_MODE_NONE)

                if  J.IsValidHero(nAllyInRangeEnemy[1])
                and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 400)
                and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
                and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
                and not J.IsDisabled(nAllyInRangeEnemy[1])
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidHero(allyTarget)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange())
                and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyTarget:HasModifier('modifier_enigma_black_hole_pull')
                and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
    then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        then
            if  J.IsValidHero(nInRangeAlly[1])
            and J.IsInRange(bot, nInRangeAlly[1], nCastRange)
            and J.IsCore(nInRangeAlly[1])
            and not nInRangeAlly[1]:HasModifier('modifier_abaddon_aphotic_shield')
            and not nInRangeAlly[1]:IsMagicImmune()
            and not nInRangeAlly[1]:IsInvulnerable()
            and not nInRangeAlly[1]:IsIllusion()
            then
                return BOT_ACTION_DESIRE_HIGH, nInRangeAlly[1]
            end

            if  not bot:HasModifier('modifier_abaddon_aphotic_shield')
            and not bot:HasModifier("modifier_abaddon_borrowed_time")
            then
                return BOT_ACTION_DESIRE_MODERATE, bot
            end
	    end

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and #nInRangeAlly == 0 and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 500)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier("modifier_abaddon_borrowed_time")
        then
            return BOT_ACTION_DESIRE_MODERATE, bot
        end
    end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.65 or bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
            and J.IsInRange(bot, enemyHero, 600)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(1600, true)
        if  J.IsValid(nCreeps[1])
        and J.CanBeAttacked(nCreeps[1])
        and J.GetHP(bot) < 0.5
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier('modifier_abaddon_borrowed_time')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            local weakestAlly = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if  weakestAlly ~= nil
            and not weakestAlly:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, weakestAlly
            end
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            local weakestAlly = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if  weakestAlly ~= nil
            and not weakestAlly:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, weakestAlly
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderMistCoil()
    if not J.CanCastAbility(MistCoil)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, MistCoil:GetCastRange())
	local nDamage = MistCoil:GetSpecialValueInt('target_damage')
    local nDamageType = DAMAGE_TYPE_MAGICAL

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, nDamageType)
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	for _, allyHero in pairs(nAllyHeroes)
	do
        if  J.IsValidHero(allyHero)
        and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull'))
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
		then
			if  J.IsRetreating(allyHero)
            and J.GetHP(allyHero) < 0.6
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero)
			then
                local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidHero(allyTarget)
				and allyHero:IsFacingLocation(allyTarget:GetLocation(), 30)
				and J.IsInRange(allyHero, allyTarget, 300)
                and J.GetHP(allyHero) < 0.8
                and J.GetHP(bot) > 0.2
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and not J.IsDisabled(enemyHero)
            and J.IsInRange(bot, enemyHero, 600)
            then
                if  nAllyHeroes ~= nil and #nEnemyHeroes ~= nil
                and ((#nAllyHeroes == 0 and #nEnemyHeroes >= 1)
                    or (#nAllyHeroes >= 1
                        and J.GetHP(bot) < 0.3
                        and bot:WasRecentlyDamagedByAnyHero(1)
                        and not bot:HasModifier('modifier_abaddon_borrowed_time')))
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
    end

    if  J.IsLaning(bot)
    and J.IsCore(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 300, true)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 500
                and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
                and botTarget ~= creep
                and J.GetHP(bot) >= 0.5
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and not J.IsDisabled(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X