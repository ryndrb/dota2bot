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
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
				
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
                "item_bfury",--
                "item_desolator",--
                "item_black_king_bar",--
                "item_butterfly",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_greater_crit",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_ultimate_scepter",
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
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
				
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
                "item_falcon_blade",
                "item_desolator",--
                "item_black_king_bar",--
                "item_butterfly",--
                "item_ultimate_scepter",
                "item_greater_crit",--
                "item_skadi",--
				"item_ultimate_scepter_2",
                "item_aghanims_shard",
				"item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_ultimate_scepter",
                "item_falcon_blade", "item_greater_crit",
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
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
				
                "item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
                "item_falcon_blade",
                "item_desolator",--
                "item_black_king_bar",--
                "item_butterfly",--
                "item_ultimate_scepter",
                "item_greater_crit",--
                "item_skadi",--
				"item_ultimate_scepter_2",
                "item_aghanims_shard",
				"item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_desolator",
				"item_magic_wand", "item_black_king_bar",
				"item_wraith_band", "item_butterfly",
                "item_bottle", "item_ultimate_scepter",
                "item_falcon_blade", "item_greater_crit",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if bot:GetUnitName() == 'npc_dota_hero_kez' then
        if bot:GetAbilityInSlot(0) then
            if bot:GetAbilityInSlot(0):GetName() == 'kez_echo_slash' then
                bot.kez_mode = 'katana'
            else
                if bot:GetAbilityInSlot(0):GetName() == 'kez_falcon_rush' then
                    bot.kez_mode = 'sai'
                end
            end
        end
    end

    if J.CanNotUseAbility(bot)
    or bot:HasModifier('modifier_kez_raptor_dance_immune')
    then
        return
    end

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

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    FalconRushDesire = X.ConsiderFalconRush()
    if FalconRushDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FalconRush)
        return
    end

    RavensVeilDesire = X.ConsiderRavensVeil()
    if RavensVeilDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(RavensVeil)
        return
    end

    SwitchDisciplineDesire = X.ConsiderSwitchDiscipline()
    if SwitchDisciplineDesire > 0 then
        bot:Action_UseAbility(SwitchDiscipline)
        return
    end

    GrapplingClawDesire, GrapplingClawTarget, Type = X.ConsiderGrapplingClaw()
    if GrapplingClawDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if Type == 'unit' then
            bot:ActionQueue_UseAbilityOnEntity(GrapplingClaw, GrapplingClawTarget)
            return
        elseif Type == 'tree' then
            bot:ActionQueue_UseAbilityOnTree(GrapplingClaw, GrapplingClawTarget)
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
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(RaptorDance)
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
    local nManaCost = EchoSlash:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {RaptorDance, FalconRush, TalonToss, RavensVeil})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EchoSlash, RaptorDance, FalconRush, TalonToss, RavensVeil})

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.CanBeAttacked(enemy)
        and J.IsInRange(bot, enemy, nDistance * 0.8)
        and bot:IsFacingLocation(enemy:GetLocation(), 15)
        and J.CanKillTarget(enemy, (nDamage + nBonusHeroDamage) * nStrikeCount, DAMAGE_TYPE_PHYSICAL)
        and not J.IsSuspiciousIllusion(enemy)
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
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nDistance)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        then
            if not J.IsChasingTarget(bot, botTarget)
            or J.IsDisabled(botTarget)
            or botTarget:GetCurrentMovementSpeed() <= 200
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) and J.CanBeAttacked(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if J.IsChasingTarget(enemyHero, bot) or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot) then
                    local vAwayLocation = J.VectorAway(bot:GetLocation(), enemyHero:GetLocation(), 800)
                    if bot:IsFacingLocation(J.GetTeamFountain(), 45) or bot:IsFacingLocation(vAwayLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nDistance, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold2 and #nEnemyHeroes <= 1 and #nAllyHeroes <= 3 then
        local count = 0
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local tResult = PointToLineDistance(bot:GetLocation(), J.GetFaceTowardDistanceLocation(bot, nDistance), creep:GetLocation())
                if tResult and tResult.within and tResult.distance <= nRadius then
                    count = count + 1
                    if count >= 4 then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold2 then
        local count = 0
        if #nEnemyHeroes == 0 and #nAllyHeroes <= 2 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local tResult = PointToLineDistance(bot:GetLocation(), J.GetFaceTowardDistanceLocation(bot, nDistance), creep:GetLocation())
                    if tResult and tResult.within and tResult.distance <= nRadius then
                        count = count + 1
                        if count >= 4 then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end
            end
        end

        count = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero) and J.CanBeAttacked(enemyHero) and not J.IsRunning(enemyHero) then
                local tResult = PointToLineDistance(bot:GetLocation(), J.GetFaceTowardDistanceLocation(bot, nDistance), enemyHero:GetLocation())
                if tResult and tResult.within and tResult.distance <= nRadius then
                    count = count + 1
                    if count >= 3 then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
        local count = 0
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local tResult = PointToLineDistance(bot:GetLocation(), J.GetFaceTowardDistanceLocation(bot, nDistance), creep:GetLocation())
                if tResult and tResult.within and tResult.distance <= nRadius then
                    count = count + 1
                    if count >= 3 or (count >= 2 and creep:IsAncientCreep()) then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and J.IsInRange(bot, botTarget, nDistance)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.CanBeAttacked(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and J.IsInRange(bot, botTarget, nDistance)
        and bAttacking
        and fManaAfter > fManaThreshold2
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
    local nManaCost = GrapplingClaw:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 200)
        and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if J.IsInRange(bot, botTarget, nCastRange) then
                return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
            else
                if  J.IsInRange(bot, botTarget, nCastRange + 600)
                and not J.IsInRange(bot, botTarget, nCastRange + 150)
                then
                    local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, botTarget:GetLocation(), nCastRange * 0.5, 45, true, true)
                    if hTarget  then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                end
            end
        end
    end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	then
        local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, J.GetTeamFountain(), nCastRange * 0.75, 60, true, false)

        for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					if hTarget then
						return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
					end
				end
			end
		end

        if  #nEnemyHeroes == 0
		and bot:IsFacingLocation(J.GetTeamFountain(), 45)
		and J.IsRunning(bot)
		and fManaAfter > 0.4
		and hTarget
		then
			return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
		end

		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		if not J.IsInLaningPhase() and (fManaAfter > 0.4 or botHP < 0.2) then
			if #nEnemyHeroes >= #nInRangeAlly + 2 and hTarget then
                if sTargetType == 'tree' then
                    local vTreeLocation = GetTreeLocation(hTarget)
                    if bot:IsFacingLocation(vTreeLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                elseif sTargetType == 'unit' then
                    if bot:IsFacingLocation(hTarget:GetLocation(), 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                end
			end
		end
	end

	if J.IsStuck(bot) then
		local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, J.GetTeamFountain(), nCastRange * 0.75, 60, true, false)
		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > 0.8 and DotaTime() > 0 then
		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and #nEnemyHeroes <= 1 then
            local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, vLaneFrontLocation, nCastRange * 0.80, 45, true, false)
            if hTarget then
                if sTargetType == 'tree' then
                    local vTreeLocation = GetTreeLocation(hTarget)
                    if bot:IsFacingLocation(vTreeLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                elseif sTargetType == 'unit' then
                    if bot:IsFacingLocation(hTarget:GetLocation(), 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                end
            end
		end
	end

	if J.IsPushing(bot) and fManaAfter > 0.5 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
            local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, vLaneFrontLocation, nCastRange * 0.75, 30, true, false)
            if hTarget then
                if sTargetType == 'tree' then
                    local vTreeLocation = GetTreeLocation(hTarget)
                    if bot:IsFacingLocation(vTreeLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                elseif sTargetType == 'unit' then
                    if bot:IsFacingLocation(hTarget:GetLocation(), 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                end
            end
		end
	end

	if J.IsDefending(bot) and fManaAfter > 0.5 and #nEnemyHeroes <= 1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
            local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, vLaneFrontLocation, nCastRange * 0.75, 30, true, false)
            if hTarget then
                if sTargetType == 'tree' then
                    local vTreeLocation = GetTreeLocation(hTarget)
                    if bot:IsFacingLocation(vTreeLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                elseif sTargetType == 'unit' then
                    if bot:IsFacingLocation(hTarget:GetLocation(), 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                end
            end
		end
	end

	if J.IsFarming(bot) and fManaAfter > 0.5 and #nEnemyHeroes == 0 then
		if bot.farm and bot.farm.location then
            local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, bot.farm.location, nCastRange * 0.75, 30, true, false)
            if hTarget and J.IsRunning(bot) then
                if sTargetType == 'tree' then
                    return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                end
            end
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > 0.4
		then
            local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, vRoshanLocation, nCastRange * 0.75, 30, true, false)
            if hTarget then
                if sTargetType == 'tree' then
                    local vTreeLocation = GetTreeLocation(hTarget)
                    if bot:IsFacingLocation(vTreeLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                elseif sTargetType == 'unit' then
                    if bot:IsFacingLocation(hTarget:GetLocation(), 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                end
            end
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > 0.4
		then
            local hTarget, sTargetType = X.GetBestGrapplingTargetTowardsLocation(nCastRange, vTormentorLocation, nCastRange / 2, 30, false, false)
            if hTarget then
                if sTargetType == 'tree' then
                    local vTreeLocation = GetTreeLocation(hTarget)
                    if bot:IsFacingLocation(vTreeLocation, 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
                elseif sTargetType == 'unit' then
                    if bot:IsFacingLocation(hTarget:GetLocation(), 45) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget, sTargetType
                    end
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
    local nDuration = KazuraiKatana:GetSpecialValueFloat('impale_duration')

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, enemy, nCastRange + 300)
        and J.CanCastOnTargetAdvanced(enemy)
        then
            if enemy:IsChanneling() and J.GetHP(enemy) < 0.5 then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end

            local nDamage = J.GetModifierCount(bot, 'modifier_kez_katana_bleed')
            if J.WillKillTarget(enemy, nDamage, DAMAGE_TYPE_PHYSICAL, nDuration)
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
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_ursa_enrage')
        then
            local nDamage = J.GetModifierCount(bot, 'modifier_kez_katana_bleed')
            if nDamage > 300 and J.GetHP(botTarget) < 0.5 then
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

    local nCastPoint = RaptorDance:GetCastPoint()
    local nRadius = RaptorDance:GetSpecialValueInt('radius')
    local nBaseDamage = RaptorDance:GetSpecialValueInt('base_damage')
    local fMaxHealthAsDamagePercentage = RaptorDance:GetSpecialValueInt('max_health_damage_pct') / 100
    local nStrikesCount = RaptorDance:GetSpecialValueInt('strikes')
    local nStrikesInterval = RaptorDance:GetSpecialValueFloat('strike_interval')
    local nManaCost = RaptorDance:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EchoSlash, FalconRush, TalonToss, RavensVeil})

    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, nRadius * 0.8)
        and J.CanBeAttacked(enemy)
        and not J.IsChasingTarget(bot, enemy)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
        and not enemy:HasModifier('modifier_ursa_enrage')
        and not (#nAllyHeroes >= #nEnemyHeroes + 3)
        then
            if J.WillKillTarget(enemy, (nBaseDamage + fMaxHealthAsDamagePercentage * enemy:GetMaxHealth()) * nStrikesCount, DAMAGE_TYPE_PURE, nCastPoint + (nStrikesCount * nStrikesInterval)) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        if #nEnemyHeroesTargetingMe <= 2
        or bot:IsMagicImmune()
        or bot:IsInvulnerable()
        or bot:HasModifier('modifier_dazzle_shallow_grave')
        or bot:HasModifier('modifier_oracle_false_promise_timer')
        then
            local count = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
                and J.IsInRange(bot, enemyHero, nRadius * 0.8)
                and J.CanBeAttacked(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
                and not enemyHero:HasModifier('modifier_ursa_enrage')
                then
                    count = count + 1
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nRadius * 0.75)
        and J.CanBeAttacked(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_ursa_enrage')
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius * 0.8)
            local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            local nDamage = bot:GetEstimatedDamageToTarget(true, botTarget, nCastPoint + (nStrikesCount * nStrikesInterval), DAMAGE_TYPE_ALL)
            if #nAllyHeroesAttackingTarget >= 2
            or (nDamage / botTarget:GetHealth() > 0.5)
            or (botHP < 0.5 and #nInRangeEnemy >= 3)
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
        and bAttacking
        and fManaAfter > fManaThreshold1
        and not J.IsLateGame()
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
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
    local nManaCost = FalconRush:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EchoSlash, RaptorDance, TalonToss, RavensVeil})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EchoSlash, RaptorDance, FalconRush, TalonToss, RavensVeil})

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRushRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 then
        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and bAttacking
        and fManaAfter > fManaThreshold2
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
    local nCastPoint = TalonToss:GetCastPoint()
    local nRadius = TalonToss:GetSpecialValueInt('radius')
    local nDamage = TalonToss:GetSpecialValueInt('damage')
    local nSpeed = TalonToss:GetSpecialValueInt('speed')
    local nManaCost = TalonToss:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.CanBeAttacked(enemy)
        and J.CanCastOnNonMagicImmune(enemy)
        and J.CanCastOnTargetAdvanced(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        then
            if enemy:IsChanneling() and fManaAfter > 0.3 and not enemy:IsSilenced() then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end

            if J.WillKillTarget(enemy, nDamage, DAMAGE_TYPE_PHYSICAL, (GetUnitToUnitDistance(bot, enemy) / nSpeed) + nCastPoint)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_oracle_false_promise_timer')
            and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
            then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsSilenced()
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsLaning(bot) and not J.IsInLaningPhase() and fManaAfter > 0.3 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsInRange(bot, creep, bot:GetAttackRange() * 2.5)
			and J.IsKeyWordUnit('ranged', creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint)
			then
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
				if nLocationAoE.count > 0
                or J.IsUnitTargetedByTower(creep, false)
                or not J.IsOtherAllysTarget(creep)
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

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeAlly >= 1 then
			local numFacing = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and bot:IsFacingLocation(enemyHero:GetLocation(), 30)
				and not J.IsDisabled(enemyHero)
				and enemyHero:GetAttackTarget() == bot
				then
					numFacing = numFacing + 1
                    if numFacing >= 1 and #nInRangeEnemy > #nInRangeAlly then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
				end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShodoSaiCancel()
    if not J.CanCastAbility(ShodoSaiCancel) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeAlly >= 1 then
			local numFacing = 0
			for _, enemy in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemy)
				and J.CanCastOnMagicImmune(enemy)
				and bot:IsFacingLocation(enemy:GetLocation(), 15)
				and not J.IsDisabled(enemy)
				then
					numFacing = numFacing + 1
				end
			end

			if  numFacing < 1
            and (  #nEnemyHeroes < #nAllyHeroes
                or J.CanCastAbility(RaptorDance)
                or J.CanCastAbility(RavensVeil)
                or J.CanCastAbility(GrapplingClaw))
            then
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
    local nManaCost = RavensVeil:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {EchoSlash, RaptorDance, FalconRush})

    if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1 then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius * 0.6)
        if (J.IsLateGame() and #nInRangeEnemy >= 3)
        or (J.GetMP(bot) > 0.5 and #nInRangeEnemy >= 2)
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
        and J.GetMP(bot) > 0.25
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

function X.GetBestGrapplingTargetTowardsLocation(nCastRange, vTargetLocation, nMinDistance, nConeAngle, bCheckCreep, bCheckHero)
	local nTrees = bot:GetNearbyTrees(math.min(nCastRange, 1600))
    local bestTarget = nil
    local bestTargetDistance = 0

    local botLocation = bot:GetLocation()
    local targetDir = (vTargetLocation - botLocation):Normalized()

    -- tree
    for i = #nTrees , 1, -1 do
        if nTrees[i] then
            local vTreeLocation = GetTreeLocation(nTrees[i])
            local treeDir = (vTreeLocation - botLocation):Normalized()
            local dot = J.DotProduct(targetDir, treeDir)
            local nAngle = J.GetAngleFromDotProduct(dot)
            local nBotTreeDistance = GetUnitToLocationDistance(bot, vTreeLocation)

            if nAngle <= nConeAngle and nBotTreeDistance > nMinDistance then
                local nBotTargetDistance = GetUnitToLocationDistance(bot, vTargetLocation)
                local nTreeTargetDistance = J.GetDistance(vTreeLocation, vTargetLocation)
                if nTreeTargetDistance < nBotTargetDistance and nBotTreeDistance > bestTargetDistance then
                    bestTarget = nTrees[i]
                    bestTargetDistance = nBotTreeDistance
                end
            end
        end
    end

    if bestTarget ~= nil then
        return bestTarget, 'tree'
    end

    -- creep
    if bCheckCreep then
        local nEnemyCreeps = bot:GetNearbyCreeps(math.min(nCastRange, 1600), true)

        bestTarget = nil
        bestTargetDistance = 0
        for i = #nEnemyCreeps, 1, -1 do
            if J.IsValid(nEnemyCreeps[i]) and J.CanCastOnTargetAdvanced(nEnemyCreeps[i]) then
                local vCreepLocation = nEnemyCreeps[i]:GetLocation()
                local creepDir = (vCreepLocation - botLocation):Normalized()
                local dot = J.DotProduct(targetDir, creepDir)
                local nAngle = J.GetAngleFromDotProduct(dot)
                local nBotCreepDistance = GetUnitToUnitDistance(bot, nEnemyCreeps[i])

                if nAngle <= nConeAngle and nBotCreepDistance > nMinDistance then
                    local nBotTargetDistance = GetUnitToLocationDistance(bot, vTargetLocation)
                    local nCreepTargetDistance = GetUnitToLocationDistance(nEnemyCreeps[i], vTargetLocation)
                    if nCreepTargetDistance < nBotTargetDistance and nBotCreepDistance > bestTargetDistance then
                        bestTarget = nEnemyCreeps[i]
                        bestTargetDistance = nBotCreepDistance
                    end
                end
            end
        end

        if bestTarget ~= nil then
            return bestTarget, 'unit'
        end
    end

    -- hero
    if bCheckHero then
        local nInRangeAlly = J.GetAlliesNearLoc(vTargetLocation, 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(vTargetLocation, 1200)
        if #nInRangeAlly >= #nInRangeEnemy then
            bestTarget = nil
            bestTargetDistance = 0
            for i = #nEnemyHeroes, 1, -1 do
                if J.IsValid(nEnemyHeroes[i])
                and J.IsInRange(bot, nEnemyHeroes[i], nCastRange)
                and J.CanCastOnTargetAdvanced(nEnemyHeroes[i])
                and not nEnemyHeroes[i]:HasModifier('modifier_faceless_void_chronosphere_freeze')
                then
                    local vEnemyLocation = nEnemyHeroes[i]:GetLocation()
                    local enemyDir = (vEnemyLocation - botLocation):Normalized()
                    local dot = J.DotProduct(targetDir, enemyDir)
                    local nAngle = J.GetAngleFromDotProduct(dot)
                    local nBotEnemyDistance = GetUnitToUnitDistance(bot, nEnemyHeroes[i])

                    if nAngle <= nConeAngle and nBotEnemyDistance > nMinDistance then
                        local nBotTargetDistance = GetUnitToLocationDistance(bot, vTargetLocation)
                        local nEnemyTargetDistance = GetUnitToLocationDistance(nEnemyHeroes[i], vTargetLocation)
                        if nEnemyTargetDistance < nBotTargetDistance and nBotEnemyDistance > bestTargetDistance then
                            bestTarget = nEnemyHeroes[i]
                            bestTargetDistance = nBotEnemyDistance
                        end
                    end
                end
            end
        end

        if bestTarget ~= nil then
            return bestTarget, 'unit'
        end
    end

	return nil
end

return X
