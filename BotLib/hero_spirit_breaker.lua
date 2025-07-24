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

local sUtility = {"item_nullifier", "item_lotus_orb"}
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
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {3,1,2,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_circlet",
				"item_gauntlets",
            
                "item_magic_wand",
                "item_bracer",
                "item_phase_boots",
                "item_echo_sabre",
                "item_black_king_bar",--
                "item_harpoon",--
                "item_aghanims_shard",
                "item_assault",--
                "item_bloodthorn",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_harpoon",
                "item_magic_wand", "item_assault",
                "item_bracer", "item_bloodthorn",
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
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_circlet",
				"item_gauntlets",
            
                "item_magic_wand",
                "item_bracer",
                "item_phase_boots",
                "item_blade_mail",
                "item_crimson_guard",--
                "item_black_king_bar",--
                sUtilityItem,--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", sUtilityItem,
                "item_bracer", "item_shivas_guard",
                "item_blade_mail", "item_wind_waker",
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
                "item_blade_mail",
                "item_cyclone",
                "item_boots_of_bearing",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_wind_waker",--
                "item_silver_edge",--
                "item_black_king_bar",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_yasha_and_kaya",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
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
                "item_blade_mail",
                "item_cyclone",
                "item_guardian_greaves",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_wind_waker",--
                "item_silver_edge",--
                "item_black_king_bar",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_yasha_and_kaya",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    ChargeOfDarkness  = bot:GetAbilityByName('spirit_breaker_charge_of_darkness')
    Bulldoze          = bot:GetAbilityByName('spirit_breaker_bulldoze')
    PlanarPocket      = bot:GetAbilityByName('spirit_breaker_planar_pocket')
    NetherStrike      = bot:GetAbilityByName('spirit_breaker_nether_strike')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    ChargeOfDarknessDesire, ChargeOfDarknessTarget, bShouldTryBulldoze = X.ConsiderChargeOfDarkness()
    if ChargeOfDarknessDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if bShouldTryBulldoze and J.CanCastAbility(Bulldoze) and bot:GetMana() > (ChargeOfDarkness:GetManaCost() + Bulldoze:GetManaCost() + 75) then
            bot:ActionQueue_UseAbility(Bulldoze)
            bot:ActionQueue_UseAbilityOnEntity(ChargeOfDarkness, ChargeOfDarknessTarget)
            return
        else
            bot:ActionQueue_UseAbilityOnEntity(ChargeOfDarkness, ChargeOfDarknessTarget)
            return
        end
    end

    BulldozeDesire = X.ConsiderBulldoze()
    if BulldozeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Bulldoze)
        return
    end

    PlanarPocketDesire = X.ConsiderPlanarPocket()
    if PlanarPocketDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(PlanarPocket)
        return
    end

    NetherStrikeDesire, NetherStrikeTarget = X.ConsiderNetherStrike()
    if NetherStrikeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(NetherStrike, NetherStrikeTarget)
        return
    end
end

function X.ConsiderChargeOfDarkness()
    if not J.CanCastAbility(ChargeOfDarkness)
    or bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
    then
        return BOT_ACTION_DESIRE_NONE, nil, false
    end

    local nRadius = ChargeOfDarkness:GetSpecialValueInt('bash_radius')
    local nManaCost = ChargeOfDarkness:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BulldozeDesire, PlanarPocket, NetherStrike})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ChargeOfDarkness, BulldozeDesire, PlanarPocket, NetherStrike})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 800
        and not J.IsLocationInChrono(enemyHero:GetLocation())
        and not enemyHero:HasModifier('modifier_kunkka_x_marks_the_spot')
        then
            local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
            if #nInRangeAlly >= #nInRangeEnemy + 1 then
                if enemyHero:HasModifier('modifier_teleporting') then
                    local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed())
                    if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, false
                    end
                end
            end
        end
    end

    local vTeamFightLocation = J.GetTeamFightLocation(bot)
    if  vTeamFightLocation ~= nil
    and GetUnitToLocationDistance(bot, vTeamFightLocation) > 1600
    and not J.IsInLaningPhase()
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(vTeamFightLocation, 1200)
        if  J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnTargetAdvanced(nInRangeEnemy[1])
        and GetUnitToLocationDistance(nInRangeEnemy[1], J.GetEnemyFountain()) > 800
        and not J.IsLocationInChrono(vTeamFightLocation)
        then
            return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1], false
        end
    end

	if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 1600)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 800
            and not J.IsDisabled(enemyHero)
            and not J.IsLocationInChrono(enemyHero:GetLocation())
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if #nAllyHeroes <= 1 then
                    if  J.GetHP(enemyHero) < 0.5
                    and (bot:GetEstimatedDamageToTarget(true, bot, 5.0, DAMAGE_TYPE_ALL) / (enemyHero:GetHealth() + bot:GetHealthRegen() * 5.0)) > 0.5
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, false
                    end
                else
                    local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
                    if #nAllyHeroesAttackingTarget >= 2 or J.IsInTeamFight(bot, 1200) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, true
                    end
                end
            end
        end

        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 3200)
        and J.CanCastOnTargetAdvanced(botTarget)
        and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
        and not J.IsDisabled(botTarget)
        and not J.IsLocationInChrono(botTarget:GetLocation())
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if #nAllyHeroes <= 1 then
                if  J.GetHP(botTarget) < 0.5
                and (bot:GetEstimatedDamageToTarget(true, bot, 5.0, DAMAGE_TYPE_ALL) / (botTarget:GetHealth() + bot:GetHealthRegen() * 5.0)) > 0.5
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget, false
                end
            else
                local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
                if #nAllyHeroesAttackingTarget >= 2 or J.IsInTeamFight(bot, 1200) then
                    return BOT_ACTION_DESIRE_HIGH, botTarget, true
                end
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot) or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot) then
                    local hTarget = nil
                    local hTargetDistance = math.huge
                    for _, creep in pairs(GetUnitList(UNIT_LIST_ENEMY_CREEPS)) do
                        if  J.IsValid(creep)
                        and J.CanCastOnTargetAdvanced(creep)
                        and GetUnitToUnitDistance(creep, bot) > 800
                        then
                            local nInRangeAlly = J.GetAlliesNearLoc(creep:GetLocation(), 800)
                            local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 800)
                            local creepFountainDistance = GetUnitToLocationDistance(creep, J.GetTeamFountain())
                            if (#nInRangeAlly >= #nInRangeEnemy) and creepFountainDistance < hTargetDistance then
                                hTarget = creep
                                hTargetDistance = creepFountainDistance
                            end
                        end
                    end

                    if hTarget == nil then
                        for _, creep in pairs(GetUnitList(UNIT_LIST_NEUTRAL_CREEPS)) do
                            if J.IsValid(creep)
                            and J.CanCastOnTargetAdvanced(creep)
                            and GetUnitToUnitDistance(creep, bot) > 800
                            then
                                local nInRangeAlly = J.GetAlliesNearLoc(creep:GetLocation(), 800)
                                local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 800)
                                local creepFountainDistance = GetUnitToLocationDistance(creep, J.GetTeamFountain())
                                if (#nInRangeAlly >= #nInRangeEnemy) and creepFountainDistance < hTargetDistance then
                                    hTarget = creep
                                    hTargetDistance = creepFountainDistance
                                end
                            end
                        end
                    end

                    if hTarget ~= nil then
                        bot.chargeRetreat = true
                        return BOT_ACTION_DESIRE_HIGH, hTarget, true
                    end
                end
            end
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)
    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, creep, false
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, creep, false
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 500 and fManaAfter > 0.75)
                then
                    if nLocationAoE.count >= 4 and J.CanCastAbility(Bulldoze) then
                        if fManaAfter > 0.75 then
                            return BOT_ACTION_DESIRE_HIGH, creep, true
                        end
                    else
                        return BOT_ACTION_DESIRE_HIGH, creep, false
                    end
                end
            end
        end
    end

    if  J.IsLaning(bot) and J.IsInLaningPhase()
    and (J.IsCore(bot) or not J.IsThereCoreNearby(1200))
    and (GreaterBash and GreaterBash:IsTrained() and GreaterBash:GetLevel() >= 2)
    and #nEnemyHeroes == 0
    and fManaAfter > fManaThreshold1
	then
        local nEnemyTowers = bot:GetNearbyTowers(1600, true)
        for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and J.GetHP(creep) < 0.3 then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, creep:GetHealth())
                if (nLocationAoE.count >= 2) then
                    if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToLocationDistance(nEnemyTowers[1], nLocationAoE.targetloc) > 888) then
                        return BOT_ACTION_DESIRE_HIGH, creep, false
                    end
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and J.CanCastOnTargetAdvanced(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, false
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, false
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.ConsiderBulldoze()
    if not J.CanCastAbility(Bulldoze)
    or bot:HasModifier('modifier_spirit_breaker_bulldoze')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nManaCost = Bulldoze:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ChargeOfDarkness, NetherStrike})
    local nEnemyHeroesAttackingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    if bot:HasModifier('modifier_spirit_breaker_charge_of_darkness') and fManaAfter > fManaThreshold1 + 0.2 then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and bot:WasRecentlyDamagedByAnyHero(1)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
		then
            if (J.IsDisabled(bot) or #nEnemyHeroes > #nAllyHeroes) and #nEnemyHeroesAttackingMe >= 1 then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        if botHP < 0.6 and #nEnemyHeroesAttackingMe > 0 and fManaAfter > fManaThreshold1 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPlanarPocket()
    if not J.CanCastAbility(PlanarPocket)
    or bot:HasModifier('modifier_spirit_breaker_charge_of_darkness')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, PlanarPocket:GetCastRange())
    local nRadius = PlanarPocket:GetSpecialValueInt('radius')

    for _, allyHero in ipairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and allyHero ~= bot
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and (J.IsCore(allyHero) or (J.GetHP(allyHero) > 0.25 and not J.IsThereCoreNearby(800)))
        then
            local nInRangeEnemy = allyHero:GetNearbyHeroes(900, true, BOT_MODE_NONE)
            local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nInRangeEnemy, allyHero)
            local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

            if  #nEnemyHeroesTargetingAlly >= 2
            and #nEnemyHeroesTargetingMe <= 1
            and botHP >= 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if botHP > 0.5 and #nEnemyHeroesTargetingMe <= 1 then
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

            if J.IsInTeamFight(bot, 1200) and botHP < 0.65 and #nAllyHeroes >= 2 then
                if #nEnemyHeroesTargetingMe >= 3
                or bot:HasModifier('modifier_jakiro_macropyre_burn') and #nEnemyHeroesTargetingMe >= 1
                or bot:HasModifier('modifier_sand_king_epicenter_slow') and #nEnemyHeroesTargetingMe >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
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

    local nCastRange = J.GetProperCastRange(false, bot, NetherStrike:GetCastRange())
    local nCastPoint = NetherStrike:GetCastPoint()
	local nDamage = NetherStrike:GetSpecialValueInt('damage')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = enemyHero:GetNearbyHeroes(800, true, BOT_MODE_NONE)
            local nInRangeEnemy = enemyHero:GetNearbyHeroes(800, false, BOT_MODE_NONE)
            local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nInRangeAlly, enemyHero)

            if #nInRangeAlly >= #nInRangeEnemy then
                if enemyHero:IsChanneling() and #nAllyHeroesAttackingTarget >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end

                if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(800, true, BOT_MODE_NONE)
                local nInRangeEnemy = enemyHero:GetNearbyHeroes(800, false, BOT_MODE_NONE)
                if #nInRangeAlly >= #nInRangeEnemy then
                    local enemyHeroScore = math.sqrt(enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)) * math.sqrt(enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed() * 5.0)
                    if enemyHeroScore > hTargetScore then
                        hTarget = enemyHero
                        hTargetScore = enemyHeroScore
                    end
                end
            end
        end

        if hTarget ~= nil then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X