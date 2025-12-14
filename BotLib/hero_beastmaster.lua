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
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,4,2,4,2,6,2,4,4,1,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
                "item_faerie_fire",
			
                "item_bottle",
				"item_magic_wand",
				"item_phase_boots",
                "item_double_bracer",
                "item_ultimate_scepter",
				"item_black_king_bar",--
                "item_harpoon",--
				"item_blink",
                "item_aghanims_shard",
                "item_satanic",--
                "item_skadi",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
                "item_bracer", "item_harpoon",
                "item_bracer", "item_blink",
                "item_bottle", "item_satanic",
			},
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
                "item_faerie_fire",
			
				"item_magic_wand",
                "item_helm_of_the_dominator",
				"item_boots",
				"item_blink",
				"item_helm_of_the_overlord",--
                "item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_aghanims_shard",
                "item_ultimate_scepter",
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
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
					['t15'] = {10, 0},
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
                "item_faerie_fire",
			
				"item_magic_wand",
				"item_arcane_boots",
                "item_double_bracer",
                "item_ultimate_scepter",
				"item_blink",
                "item_crimson_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_nullifier",--
                "item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_crimson_guard",
                "item_bracer", "item_black_king_bar",
                "item_bracer", "item_nullifier",
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
local InnerBeast        = bot:GetAbilityByName('beastmaster_inner_beast')
-- local DrumsOfSlom        = bot:GetAbilityByName('beastmaster_drums_of_slom')
local PrimalRoar        = bot:GetAbilityByName('beastmaster_primal_roar')

local WildAxesDesire, WildAxesLocation
local CallOfTheWildBoarDesire
local CallOfTheWildHawkDesire
local InnerBeastDesire
local PrimalRoarDesire, PrimalRoarTarget

local BlinkRoarDesire, BlinkRoarTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    WildAxes          = bot:GetAbilityByName('beastmaster_wild_axes')
    CallOfTheWildBoar = bot:GetAbilityByName('beastmaster_call_of_the_wild_boar')
    CallOfTheWildHawk = bot:GetAbilityByName('beastmaster_call_of_the_wild_hawk')
    InnerBeast        = bot:GetAbilityByName('beastmaster_inner_beast')
    PrimalRoar        = bot:GetAbilityByName('beastmaster_primal_roar')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    BlinkRoarDesire, BlinkRoarTarget = X.ConsiderBlinkRoar()
    if BlinkRoarDesire > 0 and BlinkRoarTarget and bot.Blink then
        bot:Action_ClearActions(true)

        local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
		if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (PrimalRoar:GetManaCost() + BlackKingBar:GetManaCost() + 75)) then
			bot:ActionQueue_UseAbility(BlackKingBar)
			bot:ActionQueue_Delay(0.1)
		end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkRoarTarget:GetLocation())
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnEntity(PrimalRoar, BlinkRoarTarget)
        return
    end

    PrimalRoarDesire, PrimalRoarTarget = X.ConsiderPrimalRoar()
    if PrimalRoarDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(PrimalRoar, PrimalRoarTarget)
        return
    end

    CallOfTheWildBoarDesire = X.ConsiderCallOfTheWildBoar()
    if CallOfTheWildBoarDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CallOfTheWildBoar)
        return
    end

    InnerBeastDesire = X.ConsiderInnerBeast()
    if InnerBeastDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(InnerBeast)
        return
    end

    CallOfTheWildHawkDesire = X.ConsiderCallOfTheWildHawk()
    if CallOfTheWildHawkDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CallOfTheWildHawk)
        return
    end

    WildAxesDesire, WildAxesLocation = X.ConsiderWildAxes()
    if WildAxesDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WildAxes, WildAxesLocation)
        return
    end
end

function X.ConsiderWildAxes()
    if not J.CanCastAbility(WildAxes) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = WildAxes:GetCastRange()
    local nCastPoint = WildAxes:GetCastPoint()
    local nRadius = WildAxes:GetSpecialValueInt('spread')
    local nDamage = WildAxes:GetSpecialValueInt('axe_damage')
    local fThrowDurationMin = WildAxes:GetSpecialValueFloat('min_throw_duration')
    local fThrowDurationMax = WildAxes:GetSpecialValueFloat('max_throw_duration')
    local nManaCost = WildAxes:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {CallOfTheWildBoar, CallOfTheWildHawk, PrimalRoar})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = RemapValClamped(GetUnitToUnitDistance(bot, enemyHero), 0, nCastRange, fThrowDurationMin, fThrowDurationMax)
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local eta = RemapValClamped(GetUnitToUnitDistance(bot, botTarget), 0, nCastRange, fThrowDurationMin, fThrowDurationMax)
            local vLocation = J.GetCorrectLoc(botTarget, eta)
            if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                vLocation = J.VectorAway(vLocation, bot:GetLocation(), 350)
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, 400)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
			and not J.IsOtherAllysTarget(creep)
			then
				local eta = RemapValClamped(GetUnitToUnitDistance(bot, creep), 0, nCastRange, fThrowDurationMin, fThrowDurationMax)
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

					if string.find(sCreepName, 'ranged') then
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
						end
					end

					local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
					if #nInRangeEnemy > 0 then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
					end

					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
						and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
						then
							if X.IsUnitBetweenLocation(creep, bot:GetLocation(), enemyHero:GetLocation(), nRadius) then
								return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
							end
						end
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderCallOfTheWildBoar()
    if not J.CanCastAbility(CallOfTheWildBoar) then
		return BOT_ACTION_DESIRE_NONE
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, 600)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(700, true)

    if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 2 then
        if #nEnemyCreeps >= 4 then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and bAttacking then
        if #nEnemyCreeps >= 4 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and bAttacking then
        if (#nEnemyCreeps >= 2)
        or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 500)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 600)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 600)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCallOfTheWildHawk()
    if not J.CanCastAbility(CallOfTheWildHawk) then
		return BOT_ACTION_DESIRE_NONE
	end

    local nRadius = CallOfTheWildHawk:GetSpecialValueInt('attack_radius')

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderInnerBeast()
    if not J.CanCastAbility(InnerBeast) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 300)
        and not J.IsChasingTarget(bot, botTarget)
        and not bot:HasModifier('modifier_abaddon_borrowed_time')
        and not bot:HasModifier('modifier_dazzle_shallow_grave')
        and not bot:HasModifier('modifier_necrolyte_reapers_scythe')
        and not bot:HasModifier('modifier_oracle_false_promise_timer')
        and not bot:HasModifier('modifier_troll_warlord_battle_trance')
        and not bot:HasModifier('modifier_ursa_enrage')
        and not bot:HasModifier('modifier_item_blade_mail_reflect')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 300)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 300)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPrimalRoar()
    if not J.CanCastAbility(PrimalRoar) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, PrimalRoar:GetCastRange())
    local nCastPoint = PrimalRoar:GetCastPoint()
    local nDuration = PrimalRoar:GetSpecialValueFloat('duration')
    local nDamage = PrimalRoar:GetSpecialValueInt('damage')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if J.IsCastingUltimateAbility(enemyHero) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint then
                if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, nDuration + 1) > enemyHero:GetHealth() then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
            and J.IsChasingTarget(bot, enemyHero)
            and #nAllyHeroes <= 2
            and not J.IsInRange(bot, enemyHero, bot:GetAttackRange() + 150)
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

	if J.IsInTeamFight(bot, 1200) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.GetHP(enemyHero) > 0.2
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_ice_blast')
            then
                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                if enemyHeroDamage > hTargetDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and J.CanCastOnTargetAdvanced(botTarget)
        and botTarget:GetHealth() > nDamage
        and not J.IsDisabled(botTarget)
        and not J.IsHaveAegis(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_ice_blast')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
            if not (#nInRangeAlly >= #nInRangeEnemy + 3) then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkRoar()
    if J.CanCastAbility(PrimalRoar) and J.CanBlinkDagger(bot) and (bot:GetMana() > (PrimalRoar:GetManaCost() + 75)) then
        if J.IsGoingOnSomeone(bot) then
            local hTarget = nil
            local hTargetDamage = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, 1200)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and J.GetHP(enemyHero) > 0.2
                and not J.IsDisabled(enemyHero)
                and not J.IsHaveAegis(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_ice_blast')
                then
                    local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

                    if enemyHeroDamage > hTargetDamage and #nInRangeAlly >= #nInRangeEnemy then
                        hTarget = enemyHero
                        hTargetDamage = enemyHeroDamage
                    end
                end
            end

            if hTarget then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsUnitBetweenLocation(hUnit, vStart, vEnd, nRadius)
	if J.IsValid(hUnit) then
		local tResult = PointToLineDistance(vStart, vEnd, hUnit:GetLocation())
		if tResult and tResult.within and tResult.distance <= nRadius then
			return true
		end
	end

	return false
end

return X