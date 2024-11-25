local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_beastmaster'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd", "item_lotus_orb"}
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
				}
            },
            ['ability'] = {
                [1] = {1,2,2,1,1,6,1,2,2,4,6,4,4,4,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
			
				"item_magic_wand",
                "item_helm_of_the_dominator",
				"item_boots",
				"item_helm_of_the_overlord",--
				"item_blink",
                "item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_crimson_guard",
                "item_circlet", "item_black_king_bar",
				"item_magic_wand", sUtilityItem,
			},
        },
        [2] = { --non zoo
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,1,1,6,1,2,2,4,6,4,4,4,6},
                [2] = {2,1,2,1,1,6,1,2,2,4,6,4,4,4,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
			
                "item_double_bracer",
				"item_magic_wand",
				"item_arcane_boots",
                "item_ultimate_scepter",
				"item_blink",
                "item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
                "item_shivas_guard",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_crimson_guard",
                "item_bracer", "item_black_king_bar",
                "item_bracer", sUtilityItem,
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
	Minion.MinionThink(hMinionUnit)
end

end

local WildAxes          = bot:GetAbilityByName('beastmaster_wild_axes')
local CallOfTheWildBoar = bot:GetAbilityByName('beastmaster_call_of_the_wild_boar')
local CallOfTheWildHawk = bot:GetAbilityByName('beastmaster_call_of_the_wild_hawk')
-- local InnerBeast        = bot:GetAbilityByName('beastmaster_inner_beast')
-- local DrumsOfSlom        = bot:GetAbilityByName('beastmaster_drums_of_slom')
local PrimalRoar        = bot:GetAbilityByName('beastmaster_primal_roar')

local WildAxesDesire, WildAxesLocation
local CallOfTheWildBoarDesire
local CallOfTheWildHawkDesire
local PrimalRoarDesire, PrimalRoarTarget

local BlinkRoarDesire, BlinkRoarTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    WildAxes          = bot:GetAbilityByName('beastmaster_wild_axes')
    CallOfTheWildBoar = bot:GetAbilityByName('beastmaster_call_of_the_wild_boar')
    CallOfTheWildHawk = bot:GetAbilityByName('beastmaster_call_of_the_wild_hawk')
    PrimalRoar        = bot:GetAbilityByName('beastmaster_primal_roar')

    BlinkRoarDesire, BlinkRoarTarget = X.ConsiderBlinkRoar()
    if BlinkRoarDesire > 0
    then
        bot:Action_ClearActions(false)

        if J.CanBlackKingBar(bot)
        then
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
            bot:ActionQueue_Delay(0.1)
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkRoarTarget:GetLocation())
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnEntity(PrimalRoar, BlinkRoarTarget)
        return
    end

    PrimalRoarDesire, PrimalRoarTarget = X.ConsiderPrimalRoar()
    if PrimalRoarDesire > 0
    then
        bot:Action_UseAbilityOnEntity(PrimalRoar, PrimalRoarTarget)
        return
    end

    CallOfTheWildBoarDesire = X.ConsiderCallOfTheWildBoar()
    if CallOfTheWildBoarDesire > 0
    then
        bot:Action_UseAbility(CallOfTheWildBoar)
        return
    end

    CallOfTheWildHawkDesire = X.ConsiderCallOfTheWildHawk()
    if CallOfTheWildHawkDesire > 0
    then
        bot:Action_UseAbility(CallOfTheWildHawk)
        return
    end

    WildAxesDesire, WildAxesLocation = X.ConsiderWildAxes()
    if WildAxesDesire > 0
    then
        bot:Action_UseAbilityOnLocation(WildAxes, WildAxesLocation)
        return
    end
end

function X.ConsiderWildAxes()
    if not J.CanCastAbility(WildAxes)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, WildAxes:GetCastRange())
    local nCastPoint = WildAxes:GetCastPoint()
    local nRadius = WildAxes:GetSpecialValueInt('radius')
    local nDamage = WildAxes:GetSpecialValueInt('axe_damage')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint)
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.65 and bot:WasRecentlyDamagedByAnyHero(4))
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, 600)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
            end
        end
    end

    if (J.IsPushing(bot) or J.IsDefending(bot))
	then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end

        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
		if nLocationAoE.count >= 2
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

    if J.IsFarming(bot)
    then
        if J.IsAttacking(bot)
        then
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and not J.IsRunning(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
            end

            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(600)
            if  J.IsValid(nNeutralCreeps[1])
            and ((#nNeutralCreeps >= 3)
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
            and J.GetMP(bot) > 0.33
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
            end
        end
    end

    if J.IsLaning(bot)
	then
        local canKill = 0
        local creepList = {}

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
            and creep:GetHealth() > bot:GetAttackDamage()
            and J.CanBeAttacked(creep)
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 500
                and J.GetMP(bot) > 0.33
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                canKill = canKill + 1
                table.insert(creepList, creep)
            end
		end

        if  canKill >= 2
        and J.GetMP(bot) > 0.33
        and nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(creepList)
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
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

function X.ConsiderCallOfTheWildBoar()
    if not J.CanCastAbility(CallOfTheWildBoar)
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 800)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    local nCreeps = bot:GetNearbyCreeps(700, true)

	if (J.IsPushing(bot) or J.IsDefending(bot))
	then
        if J.IsAttacking(bot)
        then
            if nCreeps ~= nil and #nCreeps >= 4
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            local nEnemyTowers = bot:GetNearbyTowers(700, true)
            if  nEnemyTowers ~= nil and #nEnemyTowers > 0
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if  J.IsFarming(bot)
    and J.GetMP(bot) > 0.33
    then
        if J.IsAttacking(bot)
        then
            if  J.IsValid(nCreeps[1])
            and (#nCreeps >= 2
                or (#nCreeps >= 1 and nCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCallOfTheWildHawk()
    if not J.CanCastAbility(CallOfTheWildHawk)
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local botTarget = J.GetProperTarget(bot)

    local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsInTeamFight(bot, 1200)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 500, 500, 0, 0)
        if nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 450)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL)
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if (bot:GetActiveModeDesire() > 0.58 or bot:WasRecentlyDamagedByAnyHero(3))
            and J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, 450)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPrimalRoar()
    if not J.CanCastAbility(PrimalRoar)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, PrimalRoar:GetCastRange())
    local nDuration = PrimalRoar:GetSpecialValueInt('duration')
    local nDamage = PrimalRoar:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and J.IsChasingTarget(bot, enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
        local strongestTarget = J.GetStrongestUnit(nCastRange, bot, true, false, nDuration)

        if strongestTarget == nil
        then
            strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
        end

        if  J.IsValidTarget(strongestTarget)
        and J.CanCastOnMagicImmune(strongestTarget)
        and J.CanCastOnTargetAdvanced(strongestTarget)
        and J.GetHP(strongestTarget) > 0.5
        and not J.IsDisabled(strongestTarget)
        and not J.IsHaveAegis(strongestTarget)
        and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not strongestTarget:HasModifier('modifier_legion_commander_duel')
        and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			return BOT_ACTION_DESIRE_HIGH, strongestTarget
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidTarget(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.GetHP(enemyHero) > 0.5
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and enemyHero:GetHealth() <= bot:GetEstimatedDamageToTarget(true, enemyHero, nDuration, DAMAGE_TYPE_ALL)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkRoar()
    if J.CanCastAbility(PrimalRoar) and J.CanBlinkDagger(bot) and bot:GetMana() >= PrimalRoar:GetManaCost()
    then
        local nDuration = PrimalRoar:GetSpecialValueInt('duration')

        if J.IsInTeamFight(bot, 1600)
        then
            local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
            local strongestTarget = J.GetStrongestUnit(1199, bot, true, false, nDuration)

            if strongestTarget == nil
            then
                strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
            end

            if  J.IsValidTarget(strongestTarget)
            and J.CanCastOnNonMagicImmune(strongestTarget)
            and J.CanCastOnTargetAdvanced(strongestTarget)
            and J.IsInRange(bot, strongestTarget, 1199)
            and J.GetHP(strongestTarget) > 0.5
            and not J.IsDisabled(strongestTarget)
            and not J.IsHaveAegis(strongestTarget)
            and not strongestTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not strongestTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not strongestTarget:HasModifier('modifier_legion_commander_duel')
            and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if nInRangeAlly ~= nil and J.IsValidHero(nInRangeAlly[1]) and nInRangeAlly[1] ~= bot and not nInRangeAlly[1]:IsIllusion()
                then
                    bot.shouldBlink = true
                    return BOT_ACTION_DESIRE_HIGH, strongestTarget
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE, nil
end

return X