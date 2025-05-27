local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_spirit_breaker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_lotus_orb"}
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {3,1,2,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_tango",
                "item_double_branches",
            
                "item_double_bracer",
                "item_magic_wand",
                "item_wind_lace",
                "item_phase_boots",
                "item_blade_mail",
                "item_cyclone",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_yasha_and_kaya",--
                "item_wind_waker",--
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_blade_mail",
                "item_magic_wand", "item_black_king_bar",
                "item_bracer", "item_octarine_core",
                "item_bracer", "item_ultimate_scepter",
                "item_blade_mail", "item_yasha_and_kaya",
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
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {3,1,2,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_tango",
                "item_double_branches",
            
                "item_double_bracer",
                "item_magic_wand",
                "item_wind_lace",
                "item_phase_boots",
                "item_heavens_halberd",--
                "item_black_king_bar",--
                sUtilityItem,--
                "item_ultimate_scepter",
                "item_cyclone",
                "item_yasha_and_kaya",--
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_heavens_halberd",
                "item_magic_wand", "item_black_king_bar",
                "item_bracer", sUtilityItem,
                "item_bracer", "item_ultimate_scepter",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_boots",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_ancient_janggo",
                "item_invis_sword",
                "item_cyclone",
                "item_boots_of_bearing",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_silver_edge",--
                "item_wind_waker",--
                sUtilityItem,--
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_cyclone",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_mekansm",
                "item_invis_sword",
                "item_cyclone",
                "item_guardian_greaves",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_silver_edge",--
                "item_wind_waker",--
                sUtilityItem,--
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_cyclone",
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
	Minion.MinionThink(hMinionUnit)
end

end

local ChargeOfDarkness  = bot:GetAbilityByName('spirit_breaker_charge_of_darkness')
local Bulldoze          = bot:GetAbilityByName('spirit_breaker_bulldoze')
local GreaterBash       = bot:GetAbilityByName('spirit_breaker_greater_bash')
local PlanarPocket      = bot:GetAbilityByName('spirit_breaker_planar_pocket')
local NetherStrike      = bot:GetAbilityByName('spirit_breaker_nether_strike')

local ChargeOfDarknessDesire, ChargeOfDarknessTarget
local BulldozeDesire
local PlanarPocketDesire
local NetherStrikeDesire, NetherStrikeTarget

if bot.chargeRetreat == nil then bot.chargeRetreat = false end

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    ChargeOfDarkness  = bot:GetAbilityByName('spirit_breaker_charge_of_darkness')
    Bulldoze          = bot:GetAbilityByName('spirit_breaker_bulldoze')
    PlanarPocket      = bot:GetAbilityByName('spirit_breaker_planar_pocket')
    NetherStrike      = bot:GetAbilityByName('spirit_breaker_nether_strike')

    ChargeOfDarknessDesire, ChargeOfDarknessTarget = X.ConsiderChargeOfDarkness()
    if ChargeOfDarknessDesire > 0
    then
        if  ChargeOfDarkness:GetLevel() >= 3
        and J.CanCastAbility(Bulldoze)
        then
            bot:Action_UseAbility(Bulldoze)
        end

        bot:Action_UseAbilityOnEntity(ChargeOfDarkness, ChargeOfDarknessTarget)
        return
    end

    BulldozeDesire = X.ConsiderBulldoze()
    if BulldozeDesire > 0
    then
        bot:Action_UseAbility(Bulldoze)
        return
    end

    PlanarPocketDesire = X.ConsiderPlanarPocket()
    if PlanarPocketDesire > 0
    then
        bot:Action_UseAbility(PlanarPocket)
        return
    end

    NetherStrikeDesire, NetherStrikeTarget = X.ConsiderNetherStrike()
    if NetherStrikeDesire > 0
    then
        bot:Action_UseAbilityOnEntity(NetherStrike, NetherStrikeTarget)
        return
    end
end

function X.ConsiderChargeOfDarkness()
    if not J.CanCastAbility(ChargeOfDarkness)
    or bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nRadius = ChargeOfDarkness:GetSpecialValueInt('bash_radius')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not J.IsLocationInChrono(enemyHero:GetLocation())
        then
            local nInRangeAlly = enemyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = enemyHero:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy
            and #nInRangeAlly >= #nInRangeEnemy
            then
                if enemyHero:IsChanneling()
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)
    if  nTeamFightLocation ~= nil
    and GetUnitToLocationDistance(bot, nTeamFightLocation) > 1600
    and not J.IsInLaningPhase()
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(nTeamFightLocation, 1200)
        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and not J.IsLocationInChrono(nTeamFightLocation)
        then
            return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        local target = nil
        local dmg = 0
		local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsLocationInChrono(enemyHero:GetLocation())
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, 5, DAMAGE_TYPE_ALL)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly
                and #nInRangeAlly >= #nTargetInRangeAlly
                and currDmg > dmg
                then
                    dmg = currDmg
                    target = enemyHero
                end
            end
        end

        if target ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

	if J.IsRetreating(bot)
	then
		for _, creep in pairs(GetUnitList(UNIT_LIST_ENEMY_CREEPS))
		do
			if  J.IsValid(creep)
            and GetUnitToUnitDistance(creep, bot) > 1600
            then
                local nInRangeAlly = J.GetAlliesNearLoc(creep:GetLocation(), 1000)
                local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 1000)

                if  (nInRangeAlly ~= nil and nInRangeEnemy ~= nil)
                and (#nInRangeEnemy == 0
                    or #nInRangeAlly >= #nInRangeEnemy)
                then
                    bot.chargeRetreat = true
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
			end
		end

        for _, creep in pairs(GetUnitList(UNIT_LIST_NEUTRAL_CREEPS))
		do
			if  J.IsValid(creep)
            and GetUnitToUnitDistance(creep, bot) > 1600
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 100)
                if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
                then
                    bot.chargeRetreat = true
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
			end
		end
	end

    if J.IsPushing(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), bot:GetCurrentVisionRange(), nRadius, 0, 0)
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and nLocationAoE.count >= 4
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[4]
        end
    end

    if J.IsFarming(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), bot:GetCurrentVisionRange(), nRadius, 0, 0)

        if  J.IsAttacking(bot)
        and J.GetMP(bot) > 0.25
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
            if nNeutralCreeps ~= nil
            and ((#nNeutralCreeps >= 3 and nLocationAoE.count >= 3)
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep() and nLocationAoE.count >= 2))
            then
                if J.CanBeAttacked(nNeutralCreeps[1])
                then
                    return BOT_ACTION_DESIRE_HIGH, nNeutralCreeps[2]
                end
            end

            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and nLocationAoE.count >= 3
            then
                if J.CanBeAttacked(nEnemyLaneCreeps[1])
                then
                    return BOT_ACTION_DESIRE_HIGH, nNeutralCreeps[3]
                end
            end
        end
    end

    if  J.IsLaning(bot)
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
	then
        local canKill = 0
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
            if  J.IsValid(creep)
            and J.GetHP(creep) <= 0.33
            then
                local nNearbyTower = bot:GetNearbyTowers(1600, true)

                if nNearbyTower ~= nil and (#nNearbyTower == 0 or J.IsValidBuilding(nNearbyTower[1]) and GetUnitToUnitDistance(nNearbyTower[1], creep) > 700)
                then
                    canKill = canKill + 1
                    table.insert(creepList, creep)
                end
            end
		end

        if  canKill >= 2
        and J.GetMP(bot) > 0.25
        and J.CanBeAttacked(creepList[1])
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and GreaterBash:IsTrained() and GreaterBash:GetLevel() >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, creepList[2]
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    do
        if  J.IsValidHero(allyHero)
        and J.IsGoingOnSomeone(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
        then
            local allyTarget = allyHero:GetAttackTarget()
            if  J.IsValidTarget(allyTarget)
            and J.CanCastOnNonMagicImmune(allyTarget)
            and not J.IsSuspiciousIllusion(allyTarget)
            and not J.IsLocationInChrono(allyTarget:GetLocation())
            then
                local nInRangeAlly = allyTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nInRangeEnemy = allyTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nInRangeEnemy
                and #nInRangeAlly >= #nInRangeEnemy
                and (J.IsChasingTarget(allyHero, allyTarget) or J.IsAttacking(allyHero))
                and GetUnitToUnitDistance(bot, allyTarget) > 600
                and GetUnitToUnitDistance(bot, allyTarget) < 1900
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBulldoze()
    if not J.CanCastAbility(Bulldoze)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botTarget = J.GetProperTarget(bot)

    if bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 600)
        and bot:WasRecentlyDamagedByAnyHero(1)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 600)
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        then
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or (bot:WasRecentlyDamagedByAnyHero(1.5)))
            then
		        return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderNetherStrike()
    if not J.CanCastAbility(NetherStrike)
    or bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = NetherStrike:GetCastRange()
	local nDamage = NetherStrike:GetAbilityDamage()

    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not J.IsLocationInChrono(enemyHero:GetLocation())
        then
            local nInRangeAlly = enemyHero:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
            local nInRangeEnemy = enemyHero:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy
            and #nInRangeAlly >= #nInRangeEnemy
            then
                if enemyHero:IsChanneling()
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end

                if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        local target = nil
        local dmg = 0
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsLocationInChrono(enemyHero:GetLocation())
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, 5, DAMAGE_TYPE_ALL)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly
                and #nInRangeAlly >= #nTargetInRangeAlly
                and currDmg > dmg
                then
                    dmg = currDmg
                    target = enemyHero
                end
            end
        end

        if target ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPlanarPocket()
    if not J.CanCastAbility(PlanarPocket)
    or bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, PlanarPocket:GetCastRange())
    local nRadius = PlanarPocket:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)
    local botHP = J.GetHP(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in ipairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and allyHero ~= bot
        and J.CanBeAttacked(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and (J.IsCore(allyHero)
            or (not J.IsCore(allyHero) and J.GetHP(allyHero) > 0.25 and not J.IsThereCoreNearby(800)))
        then
            local nEnemyHeroes = allyHero:GetNearbyHeroes(900, true, BOT_MODE_NONE)
            if  #J.GetEnemyHeroesTargetingUnit(nEnemyHeroes, allyHero) >= 2
            and #J.GetEnemyHeroesTargetingUnit(nEnemyHeroes, bot) <= 1
            and botHP >= 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if botHP > 0.5 then
                if (J.IsUnitTargetProjectileIncoming(allyHero, 400))
                or (J.IsStunProjectileIncoming(allyHero, 400))
                or (not allyHero:HasModifier('modifier_sniper_assassinate'))
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if botHP < 0.25 then
                if (J.IsUnitTargetProjectileIncoming(bot, 400))
                or (J.IsStunProjectileIncoming(bot, 400))
                or (not bot:HasModifier('modifier_sniper_assassinate'))
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if J.IsInTeamFight(bot, 1200) and botHP < 0.65 then
                local attackingCount = #J.GetEnemyHeroesTargetingUnit(nEnemyHeroes, bot)
                nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if attackingCount >= 3
                or bot:HasModifier('modifier_jakiro_macropyre_burn') and attackingCount >= 1
                or bot:HasModifier('modifier_sand_king_epicenter_slow') and attackingCount >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X