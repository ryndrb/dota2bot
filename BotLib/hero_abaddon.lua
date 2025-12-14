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

local sUtility = {"item_crimson_guard", "item_nullifier", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
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
                "item_circlet",
                "item_mantle",

                "item_magic_wand",
                "item_null_talisman",
                "item_phase_boots",
                "item_echo_sabre",
                "item_manta",--
                "item_harpoon",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_bloodthorn",
                "item_null_talisman", "item_abyssal_blade",
            }
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
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
                "item_circlet",
                "item_mantle",

                "item_magic_wand",
                "item_null_talisman",
                "item_phase_boots",
                "item_radiance",--
                "item_manta",--
                "item_orchid",
                "item_aghanims_shard",
                "item_basher",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_sphere",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
                "item_quelling_blade", "item_bloodthorn",
                "item_magic_wand", "item_bloodthorn",
                "item_null_talisman", "item_abyssal_blade",
            }
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
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
                "item_circlet",
                "item_mantle",

                "item_magic_wand",
                "item_null_talisman",
                "item_phase_boots",
                "item_echo_sabre",
                "item_manta",--
                "item_harpoon",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_bloodthorn",
                "item_null_talisman", "item_abyssal_blade",
            }
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
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
                "item_circlet",
                "item_mantle",

                "item_magic_wand",
                "item_null_talisman",
                "item_phase_boots",
                "item_radiance",--
                "item_manta",--
                "item_orchid",
                "item_aghanims_shard",
                "item_basher",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_sphere",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
                "item_quelling_blade", "item_bloodthorn",
                "item_magic_wand", "item_bloodthorn",
                "item_null_talisman", "item_abyssal_blade",
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
                "item_magic_stick",
                "item_faerie_fire",
    
                "item_phase_boots",
                "item_magic_wand",
                "item_blade_mail",
                "item_radiance",--
                "item_pipe",--
                "item_aghanims_shard",
                "item_assault",--
                sUtilityItem,--
                "item_ultimate_scepter_2",
                "item_abyssal_blade",--
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_assault",
                "item_magic_wand", sUtilityItem,
                "item_blade_mail", "item_travel_boots_2",
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
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
    
                "item_tranquil_boots",
                "item_magic_wand",
                "item_blade_mail",
                "item_solar_crest",--
                "item_glimmer_cape",--
                "item_boots_of_bearing",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_lotus_orb",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_moon_shard"
            },
            ['sell_list'] = {
                "item_magic_wand", "item_lotus_orb",
                "item_blade_mail", "item_wind_waker",
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
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
    
                "item_arcane_boots",
                "item_magic_wand",
                "item_blade_mail",
                "item_solar_crest",--
                "item_glimmer_cape",--
                "item_guardian_greaves",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_lotus_orb",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_moon_shard"
            },
            ['sell_list'] = {
                "item_magic_wand", "item_lotus_orb",
                "item_blade_mail", "item_wind_waker",
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
local CurseOfAvernus    = bot:GetAbilityByName( 'abaddon_frostmourne' )
local BorrowedTimelocal = bot:GetAbilityByName( 'abaddon_borrowed_time' )

local MistCoilDesire, MistCoilTarget
local AphoticShieldDesire, AphoticShieldTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    MistCoil = bot:GetAbilityByName( 'abaddon_death_coil' )
    AphoticShield = bot:GetAbilityByName( 'abaddon_aphotic_shield' )

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    AphoticShieldDesire, AphoticShieldTarget = X.ConsiderAphoticShield()
    if AphoticShieldDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(AphoticShield, AphoticShieldTarget)
        return
    end

    MistCoilDesire, MistCoilTarget = X.ConsiderMistCoil()
    if MistCoilDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(MistCoil, MistCoilTarget)
        return
    end
end

function X.ConsiderMistCoil()
    if not J.CanCastAbility(MistCoil) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, MistCoil:GetCastRange())
    local nCastPoint = MistCoil:GetCastPoint()
	local nDamage = MistCoil:GetSpecialValueInt('target_damage')
    local nSpeed = MistCoil:GetSpecialValueInt('missile_speed')
    local nManaCost = MistCoil:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AphoticShield})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    local hTargetAlly = nil
    local hTargetAllyHealth = math.huge
	for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange + 200)
        and allyHero ~= bot
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_ice_blast')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_fountain_aura_buff')
        and not allyHero:HasModifier('modifier_rune_regen')
        then
            local allyHP = J.GetHP(allyHero)
            if allyHP < hTargetAllyHealth and allyHP <= 0.8 then
                hTargetAlly = allyHero
                hTargetAllyHealth = allyHP
            end

            if allyHero:WasRecentlyDamagedByAnyHero(2.0) and J.IsDisabled(allyHero) and allyHero < 0.8 then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
	end

    if hTargetAlly then
        return BOT_ACTION_DESIRE_HIGH, hTargetAlly
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 + 0.1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(Min(nCastRange + 300, 1600), true)

		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 800, 0, 0)
                    if string.find(sCreepName, 'ranged') then
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end

                    if J.IsEnemyTargetUnit(creep, 1200) and fManaAfter > fManaThreshold1 + 0.2 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsDisabled(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderAphoticShield()
    if not J.CanCastAbility(AphoticShield) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, AphoticShield:GetCastRange())
    local nManaCost = AphoticShield:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {MistCoil})

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange + 300)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
        and not allyHero:HasModifier("modifier_abaddon_borrowed_time")
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_ice_blast')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_fountain_aura_buff')
        and not allyHero:HasModifier('modifier_rune_regen')
        then
            local allyHP = J.GetHP(allyHero)

            if allyHero:HasModifier('modifier_legion_commander_duel') then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsDisabled(allyHero) then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsGoingOnSomeone(allyHero) then
                local allyTarget = J.GetProperTarget(allyHero)
                if J.IsValidHero(allyTarget)
                and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange() + 300)
                and not J.IsSuspiciousIllusion(allyTarget)
                then
                    if allyHP < 0.4 or fManaAfter > fManaThreshold1 + 0.1 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                if allyHero:WasRecentlyDamagedByAnyHero(2.0) and allyHP < 0.75 then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if J.IsDoingRoshan(bot) then
                if  J.IsRoshan(botTarget)
                and J.IsInRange(bot, botTarget, 800)
                and bAttacking
                then
                    if allyHP < 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end

            if J.IsDoingTormentor(bot) then
                if  J.IsTormentor(botTarget)
                and J.IsInRange(bot, botTarget, 800)
                and bAttacking
                then
                    if allyHP < 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end

            if allyHero:WasRecentlyDamagedByAnyHero(2.0) and allyHP < 0.4 and fManaAfter > fManaThreshold1 + 0.1 then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if bot:WasRecentlyDamagedByAnyHero(2.0) and botHP < 0.75 then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
        if  #nEnemyCreeps > 0
        and botHP < 0.5
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier('modifier_abaddon_borrowed_time')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X