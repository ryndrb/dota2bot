local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_monkey_king'
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
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,4,4,2,4,6,4,1,1,1,6,2,2,2,2,6},
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
                "item_maelstrom",
                "item_black_king_bar",--
                "item_mjollnir",--
                "item_greater_crit",--
                "item_abyssal_blade",--
                "item_butterfly",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_greater_crit",
                "item_magic_wand", "item_abyssal_blade",
                "item_wraith_band", "item_butterfly",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,4,4,2,4,6,4,1,1,1,6,2,2,2,2,6},
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
                "item_black_king_bar",--
                "item_greater_crit",--
                "item_basher",
                "item_butterfly",--
                "item_abyssal_blade",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_basher",
                "item_wraith_band", "item_butterfly",
            },
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
                [1] = {4,1,4,2,4,6,1,4,1,1,6,2,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_orb_of_frost",
            
                "item_bottle",
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_power_treads",
                "item_maelstrom",
                "item_black_king_bar",--
                "item_mjollnir",--
                "item_basher",
                "item_greater_crit",--
                "item_refresher",--
                "item_abyssal_blade",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_basher",
                "item_orb_of_corrosion", "item_greater_crit",
                "item_bottle", "item_refresher",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local TD_MODE_ENGAGE = 1
local TD_MODE_RETREAT = 2
local TD_MODE_FARM = 3
local TD_MODE_MOVE_AROUND = 4

local BoundlessStrike   = bot:GetAbilityByName('monkey_king_boundless_strike')
local TreeDance         = bot:GetAbilityByName('monkey_king_tree_dance')
local PrimalSpring      = bot:GetAbilityByName('monkey_king_primal_spring')
local SpringEarly       = bot:GetAbilityByName('monkey_king_primal_spring_early')
-- local JinguMastery      = bot:GetAbilityByName('monkey_king_jingu_mastery')
local Mischief          = bot:GetAbilityByName('monkey_king_mischief')
local RevertForm        = bot:GetAbilityByName('monkey_king_untransform')
local WukongsCommand    = bot:GetAbilityByName('monkey_king_wukongs_command')

local BoundlessStrikeDesire, BoundlessStrikeLocation
local TreeDanceDesire, TreeDanceTarget
local PrimalSpringDesire, PrimalSpringLocation
local SpringEarlyDesire
local MischiefDesire
local WukongsCommandDesire, WukongsCommandLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local tLastWukongsCommand = { cast_time = math.huge, location = Vector(0, 0) }

function X.SkillsComplement()
    bot = GetBot()
    if  bot.tree_dance_status == nil then
        bot.tree_dance_status = { mode = nil, location = nil, cast_time = 0, eta = 0, prevTree = nil }
    end

    if J.CanNotUseAbility(bot) then return end

    BoundlessStrike   = bot:GetAbilityByName('monkey_king_boundless_strike')
    TreeDance         = bot:GetAbilityByName('monkey_king_tree_dance')
    PrimalSpring      = bot:GetAbilityByName('monkey_king_primal_spring')
    Mischief          = bot:GetAbilityByName('monkey_king_mischief')
    RevertForm        = bot:GetAbilityByName('monkey_king_untransform')
    WukongsCommand    = bot:GetAbilityByName('monkey_king_wukongs_command')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    BoundlessStrikeDesire, BoundlessStrikeLocation = X.ConsiderBoundlessStrike()
    if BoundlessStrikeDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BoundlessStrike, BoundlessStrikeLocation)
        return
    end

    WukongsCommandDesire, WukongsCommandLocation = X.ConsiderWukongsCommand()
    if WukongsCommandDesire > 0 then
        tLastWukongsCommand.cast_time = DotaTime()
        tLastWukongsCommand.location = WukongsCommandLocation
        bot:Action_UseAbilityOnLocation(WukongsCommand, WukongsCommandLocation)
        return
    end

    MischiefDesire = X.ConsiderMischief()
    if MischiefDesire > 0 then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbility(Mischief)

        if J.CanCastAbility(RevertForm) then
            bot:ActionQueue_UseAbility(RevertForm)
        end

        return
    end

    PrimalSpringDesire, PrimalSpringLocation = X.ConsiderPrimalSpring()
    if PrimalSpringDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(PrimalSpring, PrimalSpringLocation)
        return
    end

    TreeDanceDesire, TreeDanceTarget = X.ConsiderTreeDance()
    if TreeDanceDesire > 0 then
        local nCastPoint = TreeDance:GetCastPoint()
        local nSpeed = TreeDance:GetSpecialValueInt('leap_speed')

        bot.tree_dance_status.cast_time = DotaTime()
        bot.tree_dance_status.eta = (GetUnitToLocationDistance(bot, GetTreeLocation(TreeDanceTarget)) / nSpeed) + nCastPoint
        bot.tree_dance_status.prevTree = TreeDanceTarget
        bot:Action_UseAbilityOnTree(TreeDance, TreeDanceTarget)
        return
    end
end

function X.ConsiderBoundlessStrike()
    if not J.CanCastAbility(BoundlessStrike) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, BoundlessStrike:GetCastRange())
    local nCastPoint = BoundlessStrike:GetCastPoint()
    local nRadius = BoundlessStrike:GetSpecialValueInt('strike_radius')
    local nDamage = bot:GetAttackDamage() * (BoundlessStrike:GetSpecialValueInt('strike_crit_mult') / 100)
    local nManaCost = BoundlessStrike:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PrimalSpring, WukongsCommand})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BoundlessStrike, PrimalSpring, WukongsCommand})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {WukongsCommand})

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanBeAttacked(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
            if  bot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses')
            and J.GetHP(enemyHero) < 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
            end

            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint)
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

    if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold3 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsDisabled(botTarget)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold3
		then
            if bot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses')
            or (J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150))
            or J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint)
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
    then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and not J.IsSuspiciousIllusion(enemy)
            then
                if J.IsChasingTarget(enemy, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
                or botHP < 0.6
                then
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and #nEnemyHeroes == 0 then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(500)) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
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
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
            and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
            and not J.IsRunning(creep)
			then
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count > 0
                or J.IsUnitTargetedByTower(creep, false)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
			end

            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    if #nEnemyHeroes > 0 or nLocationAoE.count >= 3 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if fManaAfter > fManaThreshold3 and not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsRetreating(allyHero)
            and bot ~= allyHero
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsSuspiciousIllusion(allyHero)
            and not J.IsMeepoClone(allyHero)
            then
                for _, enemy in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemy)
                    and J.CanBeAttacked(enemy)
                    and J.IsInRange(bot, enemy, nCastRange)
                    and J.IsChasingTarget(enemy, bot)
                    and not J.IsSuspiciousIllusion(enemy)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemy, nCastPoint)
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTreeDance()
    if not J.CanCastAbility(TreeDance) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = TreeDance:GetSpecialValueInt('perched_jump_distance')
    local nCastPoint = TreeDance:GetCastPoint()
    local nCooldown = TreeDance:GetCooldown()
    local nSpeed = TreeDance:GetSpecialValueInt('leap_speed')
    local nLeapDistance = TreeDance:GetSpecialValueInt('ground_jump_distance')
    local fManaAfter, fManaThreshold1, fManaThreshold2 = 0, 0, 0

    local nRadius = 0
    if PrimalSpring then
        nRadius = PrimalSpring:GetSpecialValueInt('impact_radius')
        local nManaCost = PrimalSpring:GetManaCost()
        fManaAfter = J.GetManaAfter(nManaCost)
        fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BoundlessStrike, WukongsCommand})
        fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BoundlessStrike, PrimalSpring, WukongsCommand})
    end

    if J.IsStuck(bot) then
        local bestTree = X.GetClosestTreeToLocation(J.GetTeamFountain(), nCastRange)
        if bestTree then
            bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
            bot.tree_dance_status.location = J.GetTeamFountain()
            return BOT_ACTION_DESIRE_HIGH, bestTree
        end
    end

	if J.IsGoingOnSomeone(bot) and not J.IsInTeamFight(bot, 1200) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1000)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(botTarget, 1.5 + eta)

            if not J.IsInRange(bot, botTarget, 1600) then
                local bestTree = X.GetClosestTreeToLocation(vLocation, nCastRange)
                if bestTree then
                    bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
                    bot.tree_dance_status.location = vLocation
                    return BOT_ACTION_DESIRE_HIGH, bestTree
                end
            end

            local nTrees = botTarget:GetNearbyTrees(nCastRange)

            if fManaAfter > fManaThreshold1 and J.CanCastAbilitySoon(PrimalSpring, eta) and #nTrees > 0 then
                local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                if #nInRangeAlly >= #nInRangeEnemy then
                    for _, tree in pairs(nTrees) do
                        if tree then
                            local vTreeLocation = GetTreeLocation(tree)
                            if GetUnitToLocationDistance(botTarget, vTreeLocation) <= nCastRange / 2 then
                                bot.tree_dance_status.mode = TD_MODE_ENGAGE
                                bot.tree_dance_status.location = vLocation
                                return BOT_ACTION_DESIRE_HIGH, tree
                            end
                        end
                    end
                end
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 1200)
            and not J.IsSuspiciousIllusion(enemy)
            then
                if (J.IsChasingTarget(enemy, bot))
                or (#nEnemyHeroes > #nAllyHeroes)
                then
                    local bestTree = X.GetClosestTreeToLocation(J.GetTeamFountain(), nCastRange)
                    if bestTree ~= nil then
                        bot.tree_dance_status.mode = TD_MODE_RETREAT
                        bot.tree_dance_status.location = J.GetTeamFountain()
                        return BOT_ACTION_DESIRE_HIGH, bestTree
                    end
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) then
        if #nEnemyHeroes == 0 and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 3 and J.CanCastAbilitySoon(PrimalSpring, 0.5) then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE_creeps = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    local nLocationAoE_allyHeroes = bot:FindAoELocation(false, true, creep:GetLocation(), 0, 1000, 0, 0)
                    if (nLocationAoE_creeps.count >= 4) and nLocationAoE_allyHeroes.count <= 2 then
                        local nTrees = bot:GetNearbyTrees(nCastRange / 2)
                        for _, tree in pairs(nTrees) do
                            if tree then
                                if J.GetDistance(GetTreeLocation(tree), nLocationAoE_creeps.targetloc) <= nLeapDistance / 2 then
                                    bot.tree_dance_status.mode = TD_MODE_FARM
                                    bot.tree_dance_status.location = nLocationAoE_creeps.targetloc
                                    return BOT_ACTION_DESIRE_HIGH, tree
                                end
                            end
                        end
                    end
                end
            end
        end

        if #nEnemyHeroes <= 1 and nCooldown == 0 then
            local nLane = LANE_MID
            if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
            if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

            local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
            if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and bot:DistanceFromFountain() > 4500 then
                local bestTree = X.GetClosestTreeToLocation(vLaneFrontLocation, nCastRange)
                if bestTree then
                    bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
                    bot.tree_dance_status.location = vLaneFrontLocation
                    return BOT_ACTION_DESIRE_HIGH, bestTree
                end
            end
        end
    end

    if J.IsDefending(bot) then
        if #nEnemyHeroes == 0 and bAttacking and fManaAfter > fManaThreshold1 and J.CanCastAbilitySoon(PrimalSpring, 0.5) then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE_creeps = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    local nLocationAoE_allyHeroes = bot:FindAoELocation(false, true, creep:GetLocation(), 0, 1000, 0, 0)
                    if (nLocationAoE_creeps.count >= 4) and nLocationAoE_allyHeroes.count <= 2 then
                        local nTrees = bot:GetNearbyTrees(nCastRange)
                        for _, tree in pairs(nTrees) do
                            if tree then
                                if J.GetDistance(GetTreeLocation(tree), nLocationAoE_creeps.targetloc) <= nLeapDistance / 2 then
                                    bot.tree_dance_status.mode = TD_MODE_FARM
                                    bot.tree_dance_status.location = nLocationAoE_creeps.targetloc
                                    return BOT_ACTION_DESIRE_HIGH, tree
                                end
                            end
                        end
                    end
                end
            end
        end

        if nCooldown == 0 then
            local nLane = LANE_MID
            if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
            if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

            local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
            if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and bot:DistanceFromFountain() > 4500 then
                local bestTree = X.GetClosestTreeToLocation(vLaneFrontLocation, nCastRange)
                if bestTree then
                    bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
                    bot.tree_dance_status.location = vLaneFrontLocation
                    return BOT_ACTION_DESIRE_HIGH, bestTree
                end
            end
        end
    end

    if J.IsFarming(bot) then
        if fManaAfter > fManaThreshold1 and J.CanCastAbilitySoon(PrimalSpring, 0.5) and bAttacking then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3)
                    or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                    then
                        local nTrees = bot:GetNearbyTrees(nCastRange)
                        for _, tree in pairs(nTrees) do
                            if tree then
                                if J.GetDistance(GetTreeLocation(tree), nLocationAoE.targetloc) <= nLeapDistance / 2 then
                                    bot.tree_dance_status.mode = TD_MODE_FARM
                                    bot.tree_dance_status.location = nLocationAoE.targetloc
                                    return BOT_ACTION_DESIRE_HIGH, tree
                                end
                            end
                        end
                    end
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() then
		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 1600 and #nEnemyHeroes <= 1 then
            local bestTree = X.GetClosestTreeToLocation(vLaneFrontLocation, nCastRange)
            if bestTree then
                bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
                bot.tree_dance_status.location = vLaneFrontLocation
                return BOT_ACTION_DESIRE_HIGH, bestTree
            end
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and #nEnemyHeroes == 0
        and nCooldown == 0
		then
            local bestTree = X.GetClosestTreeToLocation(vRoshanLocation, nCastRange)
            if bestTree then
                bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
                bot.tree_dance_status.location = vRoshanLocation
                return BOT_ACTION_DESIRE_HIGH, bestTree
            end
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and #nEnemyHeroes == 0
        and nCooldown == 0
		then
            local bestTree = X.GetClosestTreeToLocation(vTormentorLocation, nCastRange)
            if bestTree then
                bot.tree_dance_status.mode = TD_MODE_MOVE_AROUND
                bot.tree_dance_status.location = vTormentorLocation
                return BOT_ACTION_DESIRE_HIGH, bestTree
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPrimalSpring()
    if not J.CanCastAbility(PrimalSpring) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, PrimalSpring:GetCastRange())
    local nRadius = PrimalSpring:GetSpecialValueInt('impact_radius')
    local nDamage = PrimalSpring:GetSpecialValueInt('impact_damage')
    local nManaCost = PrimalSpring:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BoundlessStrike, WukongsCommand})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BoundlessStrike, PrimalSpring, WukongsCommand})

    if bot.tree_dance_status then
        if bot.tree_dance_status.mode == TD_MODE_ENGAGE then
            if bot.tree_dance_status.location then
                if GetUnitToLocationDistance(bot, bot.tree_dance_status.location) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, bot.tree_dance_status.location
                else
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), bot.tree_dance_status.location, Min(GetUnitToLocationDistance(bot, bot.tree_dance_status.location), nCastRange))
                end
            else
                if J.IsGoingOnSomeone(bot) then
                    for _, enemy in pairs(nEnemyHeroes) do
                        if J.IsValidHero(enemy)
                        and J.CanBeAttacked(enemy)
                        and J.IsInRange(bot, enemy, nCastRange)
                        and GetUnitToLocationDistance(enemy, J.GetEnemyFountain()) > 800
                        and not J.IsChasingTarget(bot, enemy)
                        and not J.IsSuspiciousIllusion(enemy)
                        and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                        end
                    end
                end
            end
        end

        if bot.tree_dance_status.mode == TD_MODE_MOVE_AROUND then
            local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

            if J.IsPushing(bot) and #nEnemyHeroes <= 1 then
                local nLane = LANE_MID
                if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
                if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

                local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
                if GetUnitToLocationDistance(bot, vLaneFrontLocation) < 1600 then
                    if #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
                        for _, creep in pairs(nEnemyCreeps) do
                            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                                if (nLocationAoE.count >= 4) then
                                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.location
                                end
                            end
                        end
                    end
                end
            end

            if J.IsDefending(bot) then
                local nLane = LANE_MID
                if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
                if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

                local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
                if GetUnitToLocationDistance(bot, vLaneFrontLocation) < 1600 then
                    if #nEnemyHeroes == 0 and fManaAfter > fManaThreshold1 then
                        for _, creep in pairs(nEnemyCreeps) do
                            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                                if (nLocationAoE.count >= 4) then
                                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.location
                                end
                            end
                        end
                    end
                end
            end

            if J.IsFarming(bot) then
                if bot.farm and bot.farm.location then
                    local distance = GetUnitToLocationDistance(bot, bot.farm.location)
                    if distance < nCastRange then
                        if fManaAfter > fManaThreshold1 then
                            for _, creep in pairs(nEnemyCreeps) do
                                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                                    if (nLocationAoE.count >= 3)
                                    or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                                    then
                                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.location
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if bot.tree_dance_status.mode == TD_MODE_RETREAT and bot.tree_dance_status.location then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), bot.tree_dance_status.location, Min(GetUnitToLocationDistance(bot, bot.tree_dance_status.location), nCastRange))
        end

        if bot.tree_dance_status.mode == TD_MODE_FARM and bot.tree_dance_status.location then
            if #nEnemyHeroes == 0 then
                return BOT_ACTION_DESIRE_HIGH, bot.tree_dance_status.location
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMischief()
    if not J.CanCastAbility(Mischief) then
        return BOT_ACTION_DESIRE_NONE
    end

    if not bot:IsMagicImmune() then
        if (J.IsStunProjectileIncoming(bot, 350))
        or (J.IsUnitTargetProjectileIncoming(bot, 350))
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderWukongsCommand()
    if not J.CanCastAbility(WukongsCommand) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = WukongsCommand:GetSpecialValueInt('cast_range')
	local nRadius = WukongsCommand:GetSpecialValueInt('second_radius')
    local nDuration = WukongsCommand:GetSpecialValueInt('duration')

    if  DotaTime() < tLastWukongsCommand.cast_time * nDuration * 0.8
    and GetUnitToLocationDistance(bot, tLastWukongsCommand.location) <= nRadius
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsCore(botTarget)
        and J.GetHP(botTarget) > 0.4
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            if #nAllyHeroes >= #nEnemyHeroes and not (#nAllyHeroes >= #nEnemyHeroes + 2) then
                if J.IsInLaningPhase() then
                    if ((bot:GetEstimatedDamageToTarget(true, botTarget, nDuration, DAMAGE_TYPE_ALL) / (botTarget:GetHealth() + botTarget:GetHealthRegen() * nDuration)) > 0.55 and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150))
                    or (#nAllyHeroesTargetingTarget >= 3)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    if J.GetHP(botTarget) < 0.6 or #nAllyHeroesTargetingTarget >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.GetClosestTreeToLocation(vLocation, nCastRange)
    local nTrees = bot:GetNearbyTrees(nCastRange)
    local bestTree = nil
    local bestTreeDistance = math.huge

    local botLocation = bot:GetLocation()
    local targetDir = (vLocation - botLocation):Normalized()

    for _, tree in pairs(nTrees) do
        if tree and tree ~= bot.tree_dance_status.prevTree then
            local vTreeLocation = GetTreeLocation(tree)
            local treeDistance = J.GetDistance(vLocation, vTreeLocation)

            if  treeDistance < bestTreeDistance
            and treeDistance < GetUnitToLocationDistance(bot, vLocation)
            then
                -- same dir, front wise
                local treeDir = (vTreeLocation - botLocation):Normalized()
                local dot = J.DotProduct(targetDir, treeDir)
                local nAngle = J.GetAngleFromDotProduct(dot)
                if nAngle <= 60 then
                    bestTree = tree
                    bestTreeDistance = treeDistance
                end
            end
        end
    end

    return bestTree
end

return X