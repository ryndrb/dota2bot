local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_earthshaker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_pipe", "item_lotus_orb"}
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
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,1,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_quelling_blade",
                "item_double_branches",
            
                "item_bottle",
                "item_bracer",
                "item_magic_wand",
                "item_phase_boots",
                "item_blink",
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_greater_crit",--
                "item_travel_boots",
                "item_overwhelming_blink",--`
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_ultimate_scepter",
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_octarine_core",
                "item_bracer", "item_greater_crit",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_quelling_blade",
                "item_double_branches",
            
                "item_double_bracer",
                "item_magic_wand",
                "item_arcane_boots",
                "item_blink",
                "item_crimson_guard",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                sUtilityItem,--
                "item_ultimate_scepter",
                "item_overwhelming_blink",--`
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_crimson_guard",
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
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_enchanted_mango",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_blink",
                "item_ancient_janggo",
                "item_aghanims_shard",
                "item_force_staff",--
                "item_cyclone",
                "item_boots_of_bearing",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_wind_waker",--
                "item_overwhelming_blink",--
                "item_ultimate_scepter_2",
                "item_black_king_bar",--
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
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_enchanted_mango",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_blink",
                "item_mekansm",
                "item_aghanims_shard",
                "item_force_staff",--
                "item_cyclone",
                "item_guardian_greaves",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_wind_waker",--
                "item_overwhelming_blink",--
                "item_ultimate_scepter_2",
                "item_black_king_bar",--
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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local Fissure       = bot:GetAbilityByName('earthshaker_fissure')
local EnchantTotem  = bot:GetAbilityByName('earthshaker_enchant_totem')
local Aftershock    = bot:GetAbilityByName('earthshaker_aftershock')
local EchoSlam      = bot:GetAbilityByName('earthshaker_echo_slam')

local FissureDesire, FissureLocation
local EnchantTotemDesire, EnchantTotemLocation, WantToJump
local EchoSlamDesire

local BlinkSlamDesire, BlinkSlamLocation
local TotemSlamDesire, TotemSlamLocation

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    Fissure       = bot:GetAbilityByName('earthshaker_fissure')
    EnchantTotem  = bot:GetAbilityByName('earthshaker_enchant_totem')
    EchoSlam      = bot:GetAbilityByName('earthshaker_echo_slam')

    botTarget = J.GetProperTarget(bot)

    BlinkSlamDesire, BlinkSlamLocation = X.ConsiderBlinkSlam()
    if BlinkSlamDesire > 0
    then
        bot:Action_ClearActions(false)

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkSlamLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    TotemSlamDesire, TotemSlamLocation = X.ConsiderTotemSlam()
    if TotemSlamDesire > 0
    then
        local nLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')

        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, TotemSlamLocation)
        bot:ActionQueue_Delay(nLeapDuration + 0.1)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    EchoSlamDesire = X.ConsiderEchoSlam()
    if EchoSlamDesire > 0
    then
        bot:Action_UseAbility(EchoSlam)
        return
    end

    EnchantTotemDesire, EnchantTotemLocation, WantToJump = X.ConsiderEnchantTotem()
    if EnchantTotemDesire > 0
    then
        J.SetQueuePtToINT(bot, true)

        if bot:HasScepter()
        then
            if WantToJump
            then
                bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, EnchantTotemLocation)
            else
                bot:ActionQueue_UseAbilityOnEntity(EnchantTotem, bot)
            end
        else
            bot:ActionQueue_UseAbility(EnchantTotem)
        end
    end

    FissureDesire, FissureLocation = X.ConsiderFissure()
    if FissureDesire > 0
    then
        J.SetQueuePtToINT(bot, true)
        bot:ActionQueue_UseAbilityOnLocation(Fissure, FissureLocation)
        return
    end
end

function X.ConsiderFissure()
    if not J.CanCastAbility(Fissure)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Fissure:GetCastRange())
	local nCastPoint = Fissure:GetCastPoint()
	local nRadius = Fissure:GetSpecialValueInt('fissure_radius')
    local nDamage = Fissure:GetSpecialValueInt('fissure_damage')
    local nAbilityLevel = Fissure:GetLevel()

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
            end
        end
    end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.5
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nCastPoint + 0.1)
            end
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
        local target = nil
        local dmg = 0

        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local currDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, 5, DAMAGE_TYPE_ALL)
                if currDmg > dmg
                then
                    dmg = currDmg
                    target = enemyHero
                end
            end
        end

        if J.IsValidHero(target)
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(target:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(target, nCastPoint)
            end
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nRadius)
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and bot:WasRecentlyDamagedByAnyHero(4)
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(nEnemyHeroes[1]:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
            end
        end
    end

	if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(Fissure:GetManaCost())  > 0.5
    and nAbilityLevel >= 3
    and nAllyHeroes ~= nil and #nAllyHeroes == 0
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(bot)
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEnchantTotem()
    if not J.CanCastAbility(EnchantTotem)
    then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

    local _, Aftershock_ = J.HasAbility(bot, 'earthshaker_aftershock')
    local nCastRange = bot:HasScepter() and EnchantTotem:GetSpecialValueInt('distance_scepter') or 0
	local nRadius = 350
    local nLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')

    if Aftershock_ ~= nil then nRadius = Aftershock_:GetSpecialValueInt('aftershock_range') end

	if bot:HasScepter() and J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange), true
	end

	if J.IsInTeamFight(bot)
	then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        local nInRangeIllusion = J.GetIllusionsNearLoc(bot:GetLocation(), nRadius)

		if bot:HasScepter()
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nLeapDuration, 0)
            nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy), true
            end

            nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
            if  nInRangeIllusion ~= nil and #nInRangeIllusion >= 2
            and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
		else
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
            if  nInRangeIllusion ~= nil and #nInRangeIllusion >= 2
            and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if bot:HasScepter()
            then
                if  J.IsInRange(bot, botTarget, nCastRange)
                and not J.IsInRange(bot, botTarget, nRadius)
                and not botTarget:HasModifier('modifier_faceless_void_chronosphere')
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(nLeapDuration), true
                else
                    if J.IsInRange(bot, botTarget, nRadius - 50)
                    then
                        return BOT_ACTION_DESIRE_HIGH, 0, false
                    end
                end
            else
                if J.IsInRange(bot, botTarget, nRadius - 50)
                then
                    return BOT_ACTION_DESIRE_HIGH, 0, false
                end
            end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.7
    and not J.IsRealInvisible(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and bot:WasRecentlyDamagedByAnyHero(3.5)
            then
                if bot:HasScepter()
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange), true
                else
                    if J.IsInRange(bot, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, 0, false
                    end
                end
            end
        end
    end

    if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(EnchantTotem:GetManaCost()) > 0.5
    and not bot:HasModifier('modifier_earthshaker_enchant_totem')
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1400, true)

        if bot:HasScepter()
        then
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and not J.IsRunning(nEnemyLaneCreeps[1])
            then
                local nCreepCount = J.GetNearbyAroundLocationUnitCount(true, false, nRadius, nEnemyLaneCreeps[1]:GetLocation())
                if nCreepCount >= 3
                then
                    return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]:GetLocation(), true
                end
            end

            if  J.IsValidBuilding(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        else
            nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            if  J.IsValidBuilding(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        end
    end

    if J.IsFarming(bot)
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.GetManaAfter(EnchantTotem:GetManaCost()) > 0.3
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if  J.IsLaning(bot)
    and J.IsInLaningPhase()
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not nInRangeEnemy[1]:HasModifier('modifier_abaddon_borrowed_time')
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderEchoSlam()
    if not J.CanCastAbility(EchoSlam)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

	if J.IsInTeamFight(bot, 1200)
	then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius / 2)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius / 2)
        and J.IsCore(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
        and not botTarget:IsInvulnerable()
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            then
                if #nInRangeAlly <= 1 and #nInRangeEnemy <= 1
                then
                    if botTarget:IsChanneling()
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end

                    if botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                if #nInRangeEnemy > #nInRangeAlly
                then
                    if botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                if  #nInRangeAlly >= #nInRangeEnemy
                and not (#nInRangeAlly >= #nInRangeEnemy + 2)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

-- Blink > Echo
function X.ConsiderBlinkSlam()
    if X.CanDoBlinkSlam()
    then
        local nCastRange = 1199
        local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

        if J.IsGoingOnSomeone(bot)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoBlinkSlam()
    if  J.CanBlinkDagger(bot)
    and J.CanCastAbility(EchoSlam)
    then
        local nManaCost = EchoSlam:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            bot.shouldBlink = true
            return true
        end
    end

    bot.shouldBlink = false
    return false
end

-- Enchant Totem > Echo
function X.ConsiderTotemSlam()
    if X.CanDoTotemSlam()
    then
        local nETCastRange = EnchantTotem:GetSpecialValueInt('distance_scepter')
        local nETLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
        local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nETCastRange, nRadius, nETLeapDuration, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoTotemSlam()
    if  bot:HasScepter()
    and J.CanCastAbility(EnchantTotem)
    and J.CanCastAbility(EchoSlam)
    then
        local nManaCost = EnchantTotem:GetManaCost() + EchoSlam:GetManaCost()

        if  bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

return X