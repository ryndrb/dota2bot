local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_kez'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,1,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_quelling_blade",
				"item_tango",
				
				"item_wraith_band",
				"item_magic_wand",
				"item_power_treads",
                "item_bfury",--
                "item_manta",--
                "item_black_king_bar",--
                "item_ultimate_scepter",
                "item_lesser_crit",
                "item_aghanims_shard",
                "item_butterfly",--
                "item_greater_crit",--
				"item_ultimate_scepter_2",
                "item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_wraith_band", "item_lesser_crit",
			},
        },
        [2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,1,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_quelling_blade",
				"item_tango",
				
				"item_wraith_band",
				"item_magic_wand",
				"item_power_treads",
                "item_maelstrom",
                "item_manta",--
                "item_black_king_bar",--
                "item_ultimate_scepter",
                "item_mjollnir",--
                "item_lesser_crit",
                "item_butterfly",--
                "item_aghanims_shard",
                "item_greater_crit",--
				"item_ultimate_scepter_2",
                "item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_ultimate_scepter",
				"item_wraith_band", "item_lesser_crit",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,1,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_quelling_blade",
				"item_tango",
				
				"item_wraith_band",
                "item_bottle",
				"item_magic_wand",
				"item_power_treads",
                "item_maelstrom",
                "item_manta",--
                "item_black_king_bar",--
                "item_ultimate_scepter",
                "item_mjollnir",--
                "item_lesser_crit",
                "item_butterfly",--
                "item_aghanims_shard",
                "item_greater_crit",--
				"item_ultimate_scepter_2",
                "item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_manta",
				"item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_ultimate_scepter",
				"item_wraith_band", "item_lesser_crit",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

-- Discipline 1
local EchoSlash = bot:GetAbilityByName('kez_echo_slash')
local GrapplingClaw = bot:GetAbilityByName('kez_grappling_claw')
local KazuraiKatana = bot:GetAbilityByName('kez_kazurai_katana')
local RaptorDance = bot:GetAbilityByName('kez_raptor_dance')

-- Discipline 2
local FalconRush = bot:GetAbilityByName('kez_falcon_rush')
local TalonToss = bot:GetAbilityByName('kez_talon_toss')
local ShodoSai = bot:GetAbilityByName('kez_shodo_sai')
local ShodoSaiCancel = bot:GetAbilityByName('kez_shodo_sai_parry_cancel')
local RavensVeil = bot:GetAbilityByName('kez_ravens_veil')

local SwitchDiscipline = bot:GetAbilityByName('kez_switch_weapons')

local EchoSlashDesire
local GrapplingClawDesire, GrapplingClawTarget
local KazuraiKatanaDesire, KazuraiKatanaTarget
local RaptorDanceDesire

local FalconRushDesire
local TalonTossDesire, TalonTossTarget
local ShodoSaiDesire, ShodoSaiLocation
local ShodoSaiCancelDesire
local RavensVeilDesire

local SwitchDisciplineDesire

local botTarget

local nKezMode = 1

function X.SkillsComplement()
    if nKezMode % 2 == 0 then
        bot.kez_mode = 'sai'
    else
        bot.kez_mode = 'katana'
    end

    if J.CanNotUseAbility(bot)
    or bot:HasModifier('modifier_kez_raptor_dance_immune')
    then return end

    -- modifier_kez_falcon_rush
    -- modifier_kez_shodo_sai_parry
    -- modifier_kez_ravens_veil_buff

    EchoSlash = bot:GetAbilityByName('kez_echo_slash')
    GrapplingClaw = bot:GetAbilityByName('kez_grappling_claw')
    KazuraiKatana = bot:GetAbilityByName('kez_kazurai_katana')
    RaptorDance = bot:GetAbilityByName('kez_raptor_dance')
    FalconRush = bot:GetAbilityByName('kez_falcon_rush')
    TalonToss = bot:GetAbilityByName('kez_talon_toss')
    ShodoSai = bot:GetAbilityByName('kez_shodo_sai')
    RavensVeil = bot:GetAbilityByName('kez_ravens_veil')
    SwitchDiscipline = bot:GetAbilityByName('kez_switch_weapons')

    botTarget = J.GetProperTarget(bot)

    X.DoCombo()

    FalconRushDesire = X.ConsiderFalconRush()
    if FalconRushDesire > 0 then
        bot:Action_UseAbility(FalconRush)
        return
    end

    RavensVeilDesire = X.ConsiderRavensVeil()
    if RavensVeilDesire > 0 then
        bot:Action_UseAbility(RavensVeil)
        return
    end

    SwitchDisciplineDesire = X.ConsiderSwitchDiscipline()
    if SwitchDisciplineDesire > 0 then
        bot:Action_UseAbility(SwitchDiscipline)
        nKezMode = nKezMode + 1
        return
    end

    GrapplingClawDesire, GrapplingClawTarget, Type = X.ConsiderGrapplingClaw()
    if GrapplingClawDesire > 0 then
        if Type == 'unit' then
            bot:Action_UseAbilityOnEntity(GrapplingClaw, GrapplingClawTarget)
            return
        elseif Type == 'tree' then
            bot:Action_UseAbilityOnTree(GrapplingClaw, GrapplingClawTarget)
            return
        end
    end

    EchoSlashDesire = X.ConsiderEchoSlash()
    if EchoSlashDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(EchoSlash)
        return
    end

    KazuraiKatanaDesire, KazuraiKatanaTarget = X.ConsiderKazuraiKatana()
    if KazuraiKatanaDesire > 0 then
        bot:Action_UseAbilityOnEntity(KazuraiKatana, KazuraiKatanaTarget)
        return
    end

    RaptorDanceDesire = X.ConsiderRaptorDance()
    if RaptorDanceDesire > 0 then
        bot:Action_UseAbility(RaptorDance)
        return
    end

    TalonTossDesire, TalonTossTarget = X.ConsiderTalonToss()
    if TalonTossDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(TalonToss, TalonTossTarget)
        return
    end

    ShodoSaiCancelDesire = X.ConsiderShodoSaiCancel()
    if ShodoSaiCancelDesire > 0 then
        bot:Action_UseAbility(ShodoSaiCancel)
        return
    end

    ShodoSaiDesire, ShodoSaiLocation = X.ConsiderShodoSai()
    if ShodoSaiDesire > 0 then
        bot:Action_UseAbilityOnLocation(ShodoSai, ShodoSaiLocation)
        return
    end
end

function X.ConsiderEchoSlash()
    if not J.CanCastAbility(EchoSlash) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nDistance = EchoSlash:GetSpecialValueInt('katana_distance')
    local nFrontTravelDistance = EchoSlash:GetSpecialValueInt('travel_distance')
    local nRadius = EchoSlash:GetSpecialValueInt('katana_radius')
    local nAttackDamagePercentage = EchoSlash:GetSpecialValueInt('katana_echo_damage') / 100
    local nBonusHeroDamage = EchoSlash:GetSpecialValueInt('echo_hero_damage')
    local nDamage = bot:GetAttackDamage() * nAttackDamagePercentage
    local nStrikeCount = EchoSlash:GetSpecialValueInt('katana_strikes')
    local nManaAfter = J.GetManaAfter(EchoSlash:GetManaCost())

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, nDistance * 0.8)
        and bot:IsFacingLocation(enemy:GetLocation(), 15)
        and J.CanBeAttacked(enemy)
        and not J.IsSuspiciousIllusion(enemy)
        and J.CanKillTarget(enemy, (nDamage + nBonusHeroDamage) * nStrikeCount, DAMAGE_TYPE_PHYSICAL)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nDistance)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsChasingTarget(bot, botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
    then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 400)
        and bot:IsFacingLocation(J.GetTeamFountain(), 30)
        and J.CanBeAttacked(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_abaddon_borrowed_time')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
        end
    end

    if (J.IsPushing(bot) or J.IsDefending(bot))
    and not J.IsThereCoreNearby(1200)
    and nManaAfter > 0.4
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nDistance, true)
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 and bot:IsFacingLocation(nLocationAoE.targetloc, 15) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot)
    and not J.IsThereCoreNearby(1200)
    and nManaAfter > 0.3
    then
        local nCreeps = bot:GetNearbyCreeps(nDistance, true)
        if J.IsValid(nCreeps[1])
        and J.CanBeAttacked(nCreeps[1])
        and not J.IsRunning(nCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if (nLocationAoE.count >= 3 or (nLocationAoE.count >= 3 and nCreeps[1]:IsAncientCreep()))
            and bot:IsFacingLocation(nLocationAoE.targetloc, 15)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and J.IsInRange(bot, botTarget, nDistance)
        and J.IsAttacking(bot)
        and nManaAfter > 0.25
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.CanBeAttacked(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and J.IsInRange(bot, botTarget, nDistance)
        and J.IsAttacking(bot)
        and nManaAfter > 0.25
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGrapplingClaw()
    if not J.CanCastAbility(GrapplingClaw) or bot:IsRooted() then
        return BOT_ACTION_DESIRE_NONE, nil, ''
    end

    local nCastRange = J.GetProperCastRange(false, bot, GrapplingClaw:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 200)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsEnemyBlackHoleInLocation(botTarget:GetLocation())
        and not J.IsEnemyChronosphereInLocation(botTarget:GetLocation())
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if #nInRangeAlly >= #nInRangeEnemy then
                return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
            end
        end
    end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], 800)
		and J.IsChasingTarget(nEnemyHeroes[1], bot)
        then
            if (bot:WasRecentlyDamagedByAnyHero(3.0) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]))
            or (#nAllyHeroes + 2 <= #nEnemyHeroes)
            then
                local hTarget, sType = X.GetBestRetreatGrapplingTarget(nCastRange)
                if hTarget ~= nil then
                    return BOT_ACTION_DESIRE_HIGH, hTarget, sType
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

function X.ConsiderKazuraiKatana()
    if not J.CanCastAbility(KazuraiKatana) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = KazuraiKatana:GetSpecialValueInt('katana_attack_range')
    local fBonusDamagePercentage = KazuraiKatana:GetSpecialValueInt('katana_bonus_damage') / 100

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and J.CanCastOnTargetAdvanced(enemy)
        then
            if enemy:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end

            local nDamage = J.GetModifierCount(bot, 'modifier_kez_katana_bleed')
            if J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_PHYSICAL)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_oracle_false_promise_timer')
            and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
            and not enemy:HasModifier('modifier_ursa_enrage')
            then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_ursa_enrage')
        then
            local nDamage = J.GetModifierCount(bot, 'modifier_kez_katana_bleed')
            if (nDamage / bot:GetHealth()) > RemapValClamped(KazuraiKatana:GetLevel(), 2, 4, 0.1, 0.25)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end

            if nDamage > RemapValClamped(KazuraiKatana:GetLevel(), 2, 4, 75, 300)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderRaptorDance()
    if not J.CanCastAbility(RaptorDance) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = RaptorDance:GetSpecialValueInt('radius')
    local nBaseDamage = RaptorDance:GetSpecialValueInt('base_damage')
    local fMaxHealthAsDamagePercentage = RaptorDance:GetSpecialValueInt('max_health_damage_pct') / 100
    local nStikesCount = RaptorDance:GetSpecialValueInt('strikes')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, nRadius)
        and J.CanBeAttacked(enemy)
        and not J.IsChasingTarget(bot, enemy)
        and J.CanKillTarget(enemy, (nBaseDamage + fMaxHealthAsDamagePercentage * enemy:GetMaxHealth()) * nStikesCount, DAMAGE_TYPE_PURE)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
        and not enemy:HasModifier('modifier_ursa_enrage')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius * 0.8)
        if #nInRangeEnemy >= 2 and not J.IsChasingTarget(bot, nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nRadius * 0.8)
        and J.CanBeAttacked(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_ursa_enrage')
        then
            local nDamage = (nBaseDamage + fMaxHealthAsDamagePercentage * botTarget:GetMaxHealth()) * nStikesCount
            if (botTarget:GetHealth() > nDamage * 0.5)
            or (J.GetHP(bot) < 0.4 and bot:WasRecentlyDamagedByAnyHero(2.0))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(botTarget) > 0.25
        and J.IsAttacking(bot)
        and (J.IsEarlyGame() or J.IsMidGame())
        and bot:GetMana() > 250
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and bot:GetMana() > 250
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFalconRush()
    if not J.CanCastAbility(FalconRush) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRushRange = FalconRush:GetSpecialValueInt('rush_range')

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRushRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsEnemyBlackHoleInLocation(botTarget:GetLocation())
        and not J.IsEnemyChronosphereInLocation(botTarget:GetLocation())
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsPushing(bot) then
        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
        and J.IsAttacking(botTarget)
        and J.GetManaAfter(botTarget) > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and J.GetManaAfter(botTarget) > 0.3
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and J.GetManaAfter(botTarget) > 0.3
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTalonToss()
    if not J.CanCastAbility(TalonToss) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, TalonToss:GetCastRange())
    local nRadius = TalonToss:GetSpecialValueInt('radius')
    local nDamage = TalonToss:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.CanCastOnNonMagicImmune(enemy)
        and J.CanCastOnTargetAdvanced(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
        then
            return BOT_ACTION_DESIRE_HIGH, enemy
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)
        for _, enemy in pairs(nInRangeEnemy) do
            if J.IsValidHero(enemy)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.CanCastOnTargetAdvanced(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and not J.IsDisabled(enemy)
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
            then
                nEnemyHeroes = J.GetEnemiesNearLoc(enemy:GetLocation(), nRadius)
                if #nEnemyHeroes >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, enemy
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsLaning(bot)
	and J.GetManaAfter(TalonToss:GetManaCost()) > 0.3
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsInRange(bot, creep, bot:GetAttackRange() * 2.5)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				if J.IsValidHero(nEnemyHeroes[1])
				and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
				and J.IsInRange(creep, nEnemyHeroes[1], 550)
				then
                    return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShodoSai()
    if not J.CanCastAbility(ShodoSai) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot)
	then
		local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 900)
		if #nAllyHeroes >= 1 then
			local numFacing = 0
			local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			for _, enemy in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemy)
				and J.CanCastOnMagicImmune(enemy)
				and bot:IsFacingLocation(enemy:GetLocation(), 30)
                and (enemy:GetAttackTarget() == bot or J.IsChasingTarget(enemy, bot))
				and not J.IsDisabled(enemy)
				then
					numFacing = numFacing + 1
				end
			end

			if numFacing >= 1 and #nEnemyHeroes > #nAllyHeroes then
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShodoSaiCancel()
    if not J.CanCastAbility(ShodoSaiCancel) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot)
	then
		local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 900)
		if #nAllyHeroes >= 1 then
			local nFacing = 0
			local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			for _, enemy in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemy)
				and J.CanCastOnMagicImmune(enemy)
				and bot:IsFacingLocation(enemy:GetLocation(), 15)
				and not J.IsDisabled(enemy)
				then
					nFacing = nFacing + 1
				end
			end

			if nFacing < 1 and #nEnemyHeroes < #nAllyHeroes then
                return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRavensVeil()
    if not J.CanCastAbility(RavensVeil) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = RavensVeil:GetSpecialValueInt('blast_radius')

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius * 0.6)
        if (J.IsLateGame() and #nInRangeEnemy >= 3)
        or (not J.IsLateGame() and #nInRangeEnemy >= 2)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSwitchDiscipline()
    if not J.CanCastAbility(SwitchDiscipline) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if bot.kez_mode == 'sai' then
            if J.CanCastAbility(TalonToss) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsLaning(bot) or J.IsPushing(bot) then
        if bot.kez_mode == 'katana' then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot)
    or J.IsDoingRoshan(bot)
    or J.IsDoingTormentor(bot)
    then
        if bot.kez_mode == 'sai' then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.DoCombo()
    if bot.kez_mode == 'sai' then
        if bot:HasScepter() then
            if J.CanCastAbility(FalconRush) and J.CanCastAbility(RavensVeil) and not bot:IsRooted() then
                local nManaCost_falconRush = FalconRush:GetManaCost()
                local nManaCost_ravensVeil = RavensVeil:GetManaCost()
                local nManaCost_grapplingClaw = 50
                local nManaCost_echoSlash = 85 + (15 * (FalconRush:GetLevel() - 1))

                if J.GetManaAfter(nManaCost_falconRush + nManaCost_ravensVeil + nManaCost_grapplingClaw + nManaCost_echoSlash) > 0.1 then
                    local nCastRange = 700 + (100 * (TalonToss:GetLevel() - 1))

                    local target = nil
                    local targetDamage = 0

                    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)

                    for _, enemy in pairs(nEnemyHeroes) do
                        if J.IsGoingOnSomeone(bot) then
                            if J.IsValidHero(enemy)
                            and J.IsInRange(bot, enemy, nCastRange)
                            and J.CanBeAttacked(enemy)
                            and J.CanCastOnTargetAdvanced(enemy)
                            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                            and not enemy:HasModifier('modifier_enigma_black_hole_pull')
                            and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
                            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                            and not enemy:HasModifier('modifier_oracle_false_promise_timer')
                            and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
                            and not enemy:HasModifier('modifier_ursa_enrage')
                            then
                                local nInRangeAlly = enemy:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                                local nInRangeEnemy = enemy:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                                local enemyDamage = enemy:GetAttackDamage() * enemy:GetAttackSpeed() + enemy:GetEstimatedDamageToTarget(false, bot, 4.0, DAMAGE_TYPE_ALL)
                                if enemyDamage > targetDamage and #nInRangeAlly >= #nInRangeEnemy and not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                                    target = enemy
                                    targetDamage = enemyDamage
                                end
                            end
                        end
                    end

                    if J.IsValidHero(target) then
                        local nDistFromTarget = GetUnitToUnitDistance(bot, target)
                        local eta = nDistFromTarget / 1800 + nDistFromTarget / 3000

                        bot:Action_ClearActions(false)
                        bot:ActionQueue_UseAbility(FalconRush)
                        bot:ActionQueue_UseAbility(RavensVeil)
                        bot:ActionQueue_Delay(0.3)
                        bot:ActionQueue_UseAbility(SwitchDiscipline)
                        bot:ActionQueue_UseAbilityOnEntity(GrapplingClaw, target)
                        bot:ActionQueue_Delay(eta)
                        bot:ActionQueue_UseAbility(EchoSlash)
                        return
                    end
                end
            end
        end
    end
end

function X.GetBestRetreatGrapplingTarget(nCastRange)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))

	local bestRetreatTree = nil
	local bestRetreatTreeDist = 0
	local bestRetreatTreeFountainDist = 100000

	local vTeamFountain = J.GetTeamFountain()
	local botLoc = bot:GetLocation()

	local vToFountain = (vTeamFountain - botLoc):Normalized()

    -- Tree
	for i = #nTrees, 1, -1 do
		if nTrees[i] then
			local vTreeLoc = GetTreeLocation(nTrees[i])

            local currDist1 = GetUnitToLocationDistance(bot, vTreeLoc)
            local currDist2 = J.GetDistance(vTeamFountain, vTreeLoc)
            local vToTree = (vTreeLoc - botLoc):Normalized()
            local fDot = J.DotProduct(vToTree, vToFountain)

            if fDot >= math.cos(45)
            and currDist1 > bestRetreatTreeDist
            and currDist2 < bestRetreatTreeFountainDist then
                bestRetreatTreeDist = currDist1
                bestRetreatTreeFountainDist = currDist2
                bestRetreatTree = nTrees[i]
            end
		end
	end

	if bestRetreatTree ~= nil and bestRetreatTreeDist > nCastRange * 0.4 then
		return bestRetreatTree, 'tree'
	end

    -- Unit
    local bestRetreatCreep = nil
	local bestRetreatCreepDist = 0
	local bestRetreatCreepFountainDist = 100000
    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
    for i = #nEnemyCreeps, 1, -1 do
		if J.IsValid(nEnemyCreeps[i]) and not J.IsInRange(bot, nEnemyCreeps[1], nCastRange * 0.4) then
			local vCreepLoc = nEnemyCreeps[i]:GetLocation()

            local currDist1 = GetUnitToLocationDistance(bot, vCreepLoc)
            local currDist2 = J.GetDistance(vTeamFountain, vCreepLoc)
            local vToTree = (vCreepLoc - botLoc):Normalized()
            local fDot = J.DotProduct(vToTree, vToFountain)

            if fDot >= math.cos(45)
            and currDist1 > bestRetreatCreepDist
            and currDist2 < bestRetreatCreepFountainDist then
                bestRetreatCreepDist = currDist1
                bestRetreatCreepFountainDist = currDist2
                bestRetreatCreep = nEnemyCreeps[i]
            end
		end
	end

    if bestRetreatCreep ~= nil then
		return bestRetreatCreep, 'unit'
	end

	return nil, ''
end

return X
