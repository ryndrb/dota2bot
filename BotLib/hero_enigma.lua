local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_enigma'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_lotus_orb", "item_crimson_guard"}
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
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",

                "item_bracer",
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_blink",
                "item_black_king_bar",--
                "item_pipe",--
                "item_shivas_guard",--
                "item_refresher",--
                "item_travel_boots",
                "item_overwhelming_blink",--
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bracer",
                "item_magic_wand",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",

                "item_bracer",
                "item_boots",
                "item_magic_wand",
                "item_ancient_janggo",
                "item_glimmer_cape",--
                "item_blink",
                "item_boots_of_bearing",--
                "item_black_king_bar",--
                "item_refresher",--
                "item_shivas_guard",--
                "item_arcane_blink",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bracer",
                "item_magic_wand",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",

                "item_bracer",
                "item_boots",
                "item_magic_wand",
                "item_mekansm",
                "item_glimmer_cape",--
                "item_arcane_boots",
                "item_blink",
                "item_guardian_greaves",--
                "item_black_king_bar",--
                "item_refresher",--
                "item_shivas_guard",--
                "item_arcane_blink",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bracer",
                "item_magic_wand",
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

local Malefice          = bot:GetAbilityByName('enigma_malefice')
local DemonicSummoning  = bot:GetAbilityByName('enigma_demonic_conversion')
local MidnightPulse     = bot:GetAbilityByName('enigma_midnight_pulse')
local BlackHole         = bot:GetAbilityByName('enigma_black_hole')

local MaleficeDesire, MaleficeTarget
local DemonicSummoningDesire, DemonicSummoningLocation
local MidnightPulseDesire, MidnightPulseLocation
local BlackHoleDesire, BlackHoleLocation

local BlinkHoleDesire, BlinkHoleLocation
local BlinkPulseHoleDesire, BlinkPulseHoleLocation

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    Malefice          = bot:GetAbilityByName('enigma_malefice')
    DemonicSummoning  = bot:GetAbilityByName('enigma_demonic_conversion')
    MidnightPulse     = bot:GetAbilityByName('enigma_midnight_pulse')
    BlackHole         = bot:GetAbilityByName('enigma_black_hole')

    botTarget = J.GetProperTarget(bot)

    BlinkPulseHoleDesire, BlinkPulseHoleLocation = X.ConsiderBlinkPulseHole()
    if BlinkPulseHoleDesire > 0
    then
        bot:Action_ClearActions(false)

        if  J.CanBlackKingBar(bot)
        and not bot:IsMagicImmune()
        then
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkPulseHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, BlinkPulseHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlinkPulseHoleLocation)
        return
    end

    BlinkHoleDesire, BlinkHoleLocation = X.ConsiderBlinkHole()
    if BlinkHoleDesire > 0
    then
        bot:Action_ClearActions(false)

        if  J.CanBlackKingBar(bot)
        and not bot:IsMagicImmune()
        then
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlinkHoleLocation)
        return
    end

    MidnightPulseDesire, MidnightPulseLocation = X.ConsiderMidnightPulse()
    if MidnightPulseDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, MidnightPulseLocation)
        return
    end

    BlackHoleDesire, BlackHoleLocation = X.ConsiderBlackHole()
    if BlackHoleDesire > 0
    then
        if  J.CanBlackKingBar(bot)
        and not bot:IsMagicImmune()
        then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
            bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlackHoleLocation)
            return
        end

        bot:Action_UseAbilityOnLocation(BlackHole, BlackHoleLocation)
        return
    end

    MaleficeDesire, MaleficeTarget = X.ConsiderMalefice()
    if MaleficeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Malefice, MaleficeTarget)
        return
    end

    DemonicSummoningDesire, DemonicSummoningLocation = X.ConsiderDemonicSummoning()
    if DemonicSummoningDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(DemonicSummoning, DemonicSummoningLocation)
        return
    end
end

function X.ConsiderMalefice()
    if not J.CanCastAbility(Malefice)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Malefice:GetCastRange())
    local nStunInstances = Malefice:GetSpecialValueInt('value')

    if bot:GetUnitName() == 'npc_dota_hero_enigma'
    then
        local MaleficeAdditionalInstanceTalent = bot:GetAbilityByName('special_bonus_unique_enigma_2')
        if MaleficeAdditionalInstanceTalent:IsTrained()
        then
            nStunInstances = nStunInstances + Malefice:GetSpecialValueInt('value')
        end
    end

	local nDamage = Malefice:GetSpecialValueInt('damage') * nStunInstances

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.CanCastOnTargetAdvanced(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and not J.IsDisabled(nEnemyHeroes[1])
		then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
		end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and (not J.IsCore(bot) or J.IsCore(bot) and J.GetManaAfter(Malefice:GetManaCost()) > 0.66)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(5)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

	if J.IsDoingRoshan(bot)
	then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    if J.IsDoingTormentor(bot)
	then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDemonicSummoning()
    if not J.CanCastAbility(DemonicSummoning)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, DemonicSummoning:GetCastRange())
    local nHPCost = 75 + (25 * (DemonicSummoning:GetLevel() - 1))

    if  J.IsGoingOnSomeone(bot)
    and J.GetHP(bot) > 0.5
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if DotaTime() < 10 * 60
            then
                local nEnemyTowers = botTarget:GetNearbyTowers(800, false)
                if nEnemyTowers ~= nil
                then
                    if J.IsChasingTarget(bot, botTarget)
                    then
                        if  J.IsInRange(bot, botTarget, nCastRange)
                        and #nEnemyTowers == 0
                        then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        else
                            if #nEnemyTowers == 0
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                            end
                        end
                    else
                        if J.IsInRange(bot, botTarget, nCastRange)
                        then
                            return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + botTarget:GetLocation()) / 2
                        end
                    end
                end
            else
                if J.IsChasingTarget(bot, botTarget)
                then
                    if J.IsInRange(bot, botTarget, nCastRange)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                    end
                else
                    if J.IsInRange(bot, botTarget, bot:GetAttackRange())
                    then
                        return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + botTarget:GetLocation()) / 2
                    end
                end
            end
		end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)

	if (J.IsDefending(bot) or J.IsPushing(bot))
    and J.GetHealthAfter(nHPCost) > 0.5
	then
        if J.IsAttacking(bot)
        then
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end

            local nEnemyTowers = bot:GetNearbyTowers(888, true)
            local nEnemyBarracks = bot:GetNearbyBarracks(888,true)
            local nEnemyFillers = bot:GetNearbyFillers(888, true)

            if  J.IsValidBuilding(bot:GetAttackTarget())
            and (nEnemyTowers ~= nil and #nEnemyTowers >= 1
                or nEnemyBarracks ~= nil and #nEnemyBarracks >= 1
                or nEnemyFillers ~= nil and #nEnemyFillers >= 1)
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end
        end
	end

    if  J.IsFarming(bot)
    and J.GetHealthAfter(nHPCost) > 0.5
    and J.GetManaAfter(DemonicSummoning:GetManaCost()) > 0.33
    and J.IsAttacking(bot)
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end

        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
        if nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if  J.IsLaning(bot)
    and J.GetHealthAfter(nHPCost) > 0.61
    and J.GetManaAfter(DemonicSummoning:GetManaCost()) > 0.45
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if  J.IsDoingRoshan(bot)
    and J.GetHealthAfter(nHPCost) > 0.5
	then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
	end

    if  J.IsDoingTormentor(bot)
    and J.GetHealthAfter(nHPCost) > 0.63
	then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMidnightPulse()
    if not J.CanCastAbility(MidnightPulse)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, MidnightPulse:GetCastRange())
    local nRadius = MidnightPulse:GetSpecialValueInt('radius')

    if bot:GetUnitName() == 'npc_dota_hero_enigma'
    then
        local MidnightPulseRadiusTalent = bot:GetAbilityByName('special_bonus_unique_enigma_9')
        if MidnightPulseRadiusTalent:IsTrained()
        then
            nRadius = nRadius + MidnightPulse:GetSpecialValueInt('value')
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius * 0.66)
            if J.IsInRange(bot, botTarget, nCastRange)
            then
                if not J.IsRunning(bot)
                then
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                    else
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 1)
                end
            else
                if  J.IsInRange(bot, botTarget, nCastRange + nRadius)
                and not J.IsInRange(bot, botTarget, nCastRange)
                and not J.IsChasingTarget(bot, botTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                end
            end
		end
	end

    if J.IsDoingRoshan(bot)
	then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.GetHP(botTarget) > 0.35
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

    if J.IsDoingTormentor(bot)
	then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBlackHole()
    if not J.CanCastAbility(BlackHole)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BlackHole:GetCastRange())
    local nRadius = BlackHole:GetSpecialValueInt('radius')
    local nDamage = BlackHole:GetSpecialValueInt('value')
    local nDuration = BlackHole:GetSpecialValueInt('duration')

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and not (#nInRangeAlly + 3 >= #nInRangeEnemy)
            then
                if  #nInRangeEnemy >= #nInRangeAlly
                and #nInRangeEnemy <= 1
                then
                    if  J.CanKillTarget(botTarget, nDamage * nDuration, DAMAGE_TYPE_PURE)
                    and J.IsCore(botTarget)
                    and botTarget:GetHealth() > 200
                    then
                        nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                        then
                            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                        else
                            if  J.IsInRange(bot, botTarget, nCastRange + nRadius)
                            and not J.IsInRange(bot, botTarget, nCastRange)
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                            else
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        end
                    end
                end

                if  #nInRangeAlly >= #nInRangeEnemy
                and J.IsCore(botTarget)
                then
                    if  #nInRangeAlly == 0
                    and J.CanKillTarget(botTarget, nDamage * nDuration, DAMAGE_TYPE_PURE)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    else
                        nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                        then
                            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                        else
                            if  J.IsInRange(bot, botTarget, nCastRange + nRadius)
                            and not J.IsInRange(bot, botTarget, nCastRange)
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                            else
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        end
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

------------------------------
function X.ConsiderBlinkHole()
    if X.CanDoBlinkHole()
    then
        local nRadius = BlackHole:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1199, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.CanDoBlinkHole()
    if  J.CanCastAbility(BlackHole)
    and J.CanBlinkDagger(bot)
    then
        local nManaCost = BlackHole:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end
------------------------------
function X.ConsiderBlinkPulseHole()
    if X.CanDoBlinkPulseHole()
    then
        local nRadius = BlackHole:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1199, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.CanDoBlinkPulseHole()
    if  J.CanCastAbility(BlackHole)
    and J.CanCastAbility(MidnightPulse)
    and J.CanBlinkDagger(bot)
    then
        local nManaCost = BlackHole:GetManaCost() + MidnightPulse:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

return X