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
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,4,4,2,4,2,2,2,6,1,1,1,4,2,6,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                
                "item_wraith_band",
                "item_magic_wand",
                "item_power_treads",
                "item_maelstrom",
                "item_black_king_bar",--
                "item_mjollnir",--
                "item_lesser_crit",
                "item_skadi",--
                "item_greater_crit",--
                "item_abyssal_blade",--
                "item_travel_boots_2",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_lesser_crit",
                "item_magic_wand", "item_skadi",
                "item_wraith_band", "item_abyssal_blade",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,4,4,2,4,2,2,2,6,1,1,1,4,2,6,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                
                "item_wraith_band",
                "item_magic_wand",
                "item_power_treads",
                "item_bfury",--
                "item_black_king_bar",--
                "item_lesser_crit",
                "item_butterfly",--
                "item_basher",
                "item_greater_crit",--
                "item_abyssal_blade",--
                "item_travel_boots_2",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_butterfly",
                "item_wraith_band", "item_basher",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {4,1,4,2,4,1,4,1,1,6,2,2,2,2,6,6},
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
                "item_black_king_bar",--
                "item_mjollnir",--
                "item_lesser_crit",
                "item_basher",
                "item_greater_crit",--
                "item_abyssal_blade",--
                "item_refresher",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_aghanims_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_lesser_crit",
                "item_bottle", "item_basher",
                "item_orb_of_corrosion", "item_refresher",
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

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    BoundlessStrike   = bot:GetAbilityByName('monkey_king_boundless_strike')
    TreeDance         = bot:GetAbilityByName('monkey_king_tree_dance')
    PrimalSpring      = bot:GetAbilityByName('monkey_king_primal_spring')
    Mischief          = bot:GetAbilityByName('monkey_king_mischief')
    RevertForm        = bot:GetAbilityByName('monkey_king_untransform')
    WukongsCommand    = bot:GetAbilityByName('monkey_king_wukongs_command')

    BoundlessStrikeDesire, BoundlessStrikeLocation = X.ConsiderBoundlessStrike()
    if BoundlessStrikeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BoundlessStrike, BoundlessStrikeLocation)
        return
    end

    WukongsCommandDesire, WukongsCommandLocation = X.ConsiderWukongsCommand()
    if WukongsCommandDesire > 0
    then
        bot:Action_UseAbilityOnLocation(WukongsCommand, WukongsCommandLocation)
        return
    end

    MischiefDesire = X.ConsiderMischief()
    if MischiefDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbility(Mischief)

        if J.CanCastAbility(RevertForm)
        then
            bot:ActionQueue_Delay(0.2)
            bot:ActionQueue_UseAbility(RevertForm)
        end

        return
    end

    TreeDanceDesire, TreeDanceTarget = X.ConsiderTreeDance()
    if TreeDanceDesire > 0
    then
        bot:Action_UseAbilityOnTree(TreeDance, TreeDanceTarget)
        return
    end

    PrimalSpringDesire, PrimalSpringLocation = X.ConsiderPrimalSpring()
    if PrimalSpringDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(PrimalSpring, PrimalSpringLocation)
        return
    end
end

function X.ConsiderBoundlessStrike()
    if not J.CanCastAbility(BoundlessStrike)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, BoundlessStrike:GetCastRange())
    local nCastPoint = BoundlessStrike:GetCastPoint()
    local nRadius = BoundlessStrike:GetSpecialValueInt('strike_radius')
    local nDamage = bot:GetAttackDamage() * (BoundlessStrike:GetSpecialValueInt('strike_crit_mult') / 100)
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanBeAttacked(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
            if  bot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses')
            and J.GetHP(enemyHero) < 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
            end

            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
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

    if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
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
		then
            if bot:HasModifier('modifier_monkey_king_quadruple_tap_bonuses')
            or (J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, 600))
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
            and J.IsInRange(bot, enemy, nCastRange * 0.75)
            and J.IsChasingTarget(enemy, bot)
            and not J.IsSuspiciousIllusion(enemy)
            then
                return BOT_ACTION_DESIRE_HIGH, enemy:GetExtrapolatedLocation(nCastPoint)
            end
        end
    end

    if (J.IsPushing(bot) and not J.IsThereCoreNearby(1000))
    or J.IsDefending(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
        if #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsDefending(bot) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if nLocationAoE.count >= 2 or #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot)
    and J.GetManaAfter(BoundlessStrike:GetManaCost()) > 0.35
    and J.IsAttacking(bot)
    then
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
        if J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if ((#nEnemyCreeps >= 3 and nLocationAoE.count >= 3)
            or (#nEnemyCreeps >= 2 and nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())) then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsLaning(bot)
	then
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
            and not J.IsRunning(creep)
			then
				if J.IsValidHero(nInRangeEnemy[1])
                and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
                and GetUnitToUnitDistance(nInRangeEnemy[1], creep) < 500
                and J.GetMP(bot) > 0.35
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end

            if  J.IsValid(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
            then
                table.insert(creepList, creep)
            end
		end

        if #creepList >= 2
        and J.CanBeAttacked(creepList[1])
        and not J.IsRunning(creepList[2])
        and GetUnitToUnitDistance(creepList[1], creepList[2]) <= nRadius
        and J.GetMP(bot) > 0.35
        and #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(creepList)
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not allyHero:IsIllusion()
        and J.GetMP(bot) > 0.5
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanBeAttacked(nAllyInRangeEnemy[1])
            and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 800)
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nCastPoint)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTreeDance()
    if not J.CanCastAbility(TreeDance)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, TreeDance:GetCastRange())
    local nRadius = PrimalSpring:GetSpecialValueInt('impact_radius')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot) and PrimalSpring ~= nil and PrimalSpring:GetCooldownTimeRemaining() <= 1
    and not J.IsInTeamFight(bot, 1200)
	then
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
			local nTrees = botTarget:GetNearbyTrees(nCastRange)
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if #nInRangeAlly >= #nInRangeEnemy and #nTrees >= 1 then
                bot.primal_spring_status = {'engage', botTarget}
                return BOT_ACTION_DESIRE_HIGH, nTrees[1]
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 700)
            and J.IsChasingTarget(enemy, bot)
            and not J.IsSuspiciousIllusion(enemy)
            then
                local nTrees = bot:GetNearbyTrees(nCastRange)
                local targetTree = X.GetFurthestTree(nTrees)
                if targetTree ~= nil then
                    bot.primal_spring_status = {'retreat', J.GetTeamFountain()}
                    return BOT_ACTION_DESIRE_HIGH, targetTree
                end
            end
        end
	end

    if  J.IsFarming(bot)
    and PrimalSpring ~= nil and PrimalSpring:GetCooldownTimeRemaining() <= 1
    and J.GetManaAfter(PrimalSpring:GetManaCost()) > 0.3
    then
        local nEnemyCreeps = bot:GetNearbyCreeps(1000, true)
        if J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if ((#nEnemyCreeps >= 3 and nLocationAoE.count >= 3)
            or (#nEnemyCreeps >= 2 and nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())) then
                local nTrees = bot:GetNearbyTrees(nCastRange)
                for _, tree in pairs(nTrees) do
                    if tree ~= nil
                    then
                        if J.GetDistance(GetTreeLocation(tree), nLocationAoE.targetloc) <= 1000 then
                            bot.primal_spring_status = {'farm', nLocationAoE.targetloc}
                            return BOT_ACTION_DESIRE_HIGH, tree
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPrimalSpring()
    if not J.CanCastAbility(PrimalSpring)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nMaxDistance = 1000

    if bot.primal_spring_status ~= nil then
        if bot.primal_spring_status[1] == 'engage' then
            if J.IsValidHero(bot.primal_spring_status[2]) then
                if J.IsInRange(bot, bot.primal_spring_status[2], nMaxDistance) then
                    return BOT_ACTION_DESIRE_HIGH, bot.primal_spring_status[2]:GetLocation()
                else
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, bot.primal_spring_status[2]:GetLocation(), nMaxDistance)
                end
            else
                local nEnemyHeroes = bot:GetNearbyHeroes(nMaxDistance, true, BOT_MODE_NONE)
                for _, enemy in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemy)
                    and J.CanBeAttacked(enemy)
                    and not J.IsSuspiciousIllusion(enemy)
                    and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                    end
                end
            end
        elseif bot.primal_spring_status[1] == 'retreat' then
            return BOT_ACTION_DESIRE_HIGH, bot.primal_spring_status[2]
        elseif bot.primal_spring_status[1] == 'farm' then
            local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
            if #nEnemyHeroes == 0 then
                return BOT_ACTION_DESIRE_HIGH, bot.primal_spring_status[2]
            end
        else
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nMaxDistance)
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMischief()
    if not J.CanCastAbility(Mischief)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsStunProjectileIncoming(bot, 350)
    or J.IsUnitTargetProjectileIncoming(bot, 350)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 400)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderWukongsCommand()
    if not J.CanCastAbility(WukongsCommand)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = WukongsCommand:GetSpecialValueInt('cast_range')
	local nRadius = WukongsCommand:GetSpecialValueInt('second_radius')
    local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		if #nInRangeEnemy >= 2 and not J.IsChasingTarget(bot, nInRangeEnemy[1])
		then
            local vLocation = J.GetCenterOfUnits(nInRangeEnemy)
            if not J.IsEnemyChronosphereInLocation(vLocation)
            and not J.IsEnemyBlackHoleInLocation(vLocation)
            then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
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
            local nAllyHeroes = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nEnemyHeroes = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if #nAllyHeroes >= #nEnemyHeroes
            and not (#nAllyHeroes >= #nEnemyHeroes + 2)
            then
                if J.IsInLaningPhase() then
                    if bot:GetEstimatedDamageToTarget(true, botTarget, 13.0, DAMAGE_TYPE_ALL) > botTarget:GetHealth() * 1.25
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

-- Helper Funcs
function X.GetFurthestTree(nTrees)
	if GetAncient(GetTeam()) == nil then return nil end

	local furthest = nil
	local fDist = 10000

	for _, tree in pairs(nTrees)
	do
		local dist = GetUnitToLocationDistance(GetAncient(GetTeam()), GetTreeLocation(tree))

		if dist < fDist
        then
			furthest = tree
			fDist = dist
		end
	end

	return furthest
end

return X