local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_lycan'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_nullifier", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                -- [1] = {1,3,1,3,1,6,1,3,1,2,6,1,2,2,6}, -- +1 Summon Wolves
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_double_wraith_band",
                "item_power_treads",
                "item_echo_sabre",
                "item_orchid",
                "item_black_king_bar",--
                "item_harpoon",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_satanic",--
                "item_abyssal_blade",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
                "item_magic_wand", "item_black_king_bar",
                "item_wraith_band", "item_satanic",
                "item_wraith_band", "item_abyssal_blade",
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
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                -- [1] = {1,3,1,3,1,6,1,3,1,2,6,1,2,2,6}, -- +1 Summon Wolves
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_double_wraith_band",
                "item_power_treads",
                "item_echo_sabre",
                "item_orchid",
                "item_black_king_bar",--
                "item_harpoon",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_satanic",--
                "item_abyssal_blade",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
                "item_magic_wand", "item_black_king_bar",
                "item_wraith_band", "item_satanic",
                "item_wraith_band", "item_abyssal_blade",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                -- [1] = {1,3,1,3,1,6,1,3,1,2,6,1,2,2,6}, -- +1 Summon Wolves
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_quelling_blade",
            
                "item_helm_of_the_dominator",
                "item_magic_wand",
                "item_boots",
                "item_crimson_guard",--
                "item_helm_of_the_overlord",--
                "item_black_king_bar",--
                sUtilityItem,--
                "item_assault",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", sUtilityItem,
                "item_magic_wand", "item_assault",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                -- [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6}, -- +1 Summon Wolves
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_power_treads",
                "item_orchid",
                "item_crimson_guard",--
                "item_black_king_bar",--
                "item_assault",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_crimson_guard",
                "item_magic_wand", "item_black_king_bar",
                "item_bracer", "item_assault",
                "item_bracer", "item_abyssal_blade",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local SummonWolves  = bot:GetAbilityByName('lycan_summon_wolves')
local Howl          = bot:GetAbilityByName('lycan_howl')
local FeralImpulse  = bot:GetAbilityByName('lycan_feral_impulse')
local WoflBite      = bot:GetAbilityByName('lycan_wolf_bite')
local ShapeShift    = bot:GetAbilityByName('lycan_shapeshift')

local SummonWolvesDesire
local HowlDesire
local WoflBiteDesire, WoflBiteTarget
local ShapeShiftDesire

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    SummonWolves  = bot:GetAbilityByName('lycan_summon_wolves')
    Howl          = bot:GetAbilityByName('lycan_howl')
    ShapeShift    = bot:GetAbilityByName('lycan_shapeshift')

    ShapeShiftDesire = X.ConsiderShapeShift()
    if ShapeShiftDesire > 0
    then
        bot:Action_UseAbility(ShapeShift)
        return
    end

    HowlDesire = X.ConsiderHowl()
    if HowlDesire > 0
    then
        bot:Action_UseAbility(Howl)
        return
    end

    SummonWolvesDesire = X.ConsiderSummonWolves()
    if SummonWolvesDesire > 0
    then
        bot:Action_UseAbility(SummonWolves)
        return
    end

    -- WoflBiteDesire, WoflBiteTarget = X.ConsiderWoflBite()
end

function X.ConsiderSummonWolves()
    if not J.CanCastAbility(SummonWolves)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if  J.IsValid(unit)
        and (unit:GetUnitName() == 'npc_dota_lycan_wolf1'
            or unit:GetUnitName() == 'npc_dota_lycan_wolf2'
            or unit:GetUnitName() == 'npc_dota_lycan_wolf3'
            or unit:GetUnitName() == 'npc_dota_lycan_wolf4')
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
        and nInRangeAlly ~= nil and nInRangeEnemy
        and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsLaning(bot))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)

        if J.IsAttacking(bot)
        then
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 0
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            local nEnemyTowers = bot:GetNearbyTowers(600, true)
            if nEnemyTowers ~= nil and #nEnemyTowers >= 1
            and J.CanBeAttacked(nEnemyTowers[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsFarming(bot)
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(600)
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)

        if J.IsAttacking(bot)
        then
            if (nNeutralCreeps ~= nil and #nNeutralCreeps >= 2)
            or (nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHowl()
    if not J.CanCastAbility(Howl)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local timeOfDay = J.CheckTimeOfDay()
    local botTarget = J.GetProperTarget(bot)

    if timeOfDay == 'night'
    then
        for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
        do
            if  J.IsValidHero(allyHero)
            and not allyHero:IsIllusion()
            then
                if  J.IsCore(allyHero)
                and J.IsGoingOnSomeone(allyHero)
                then
                    local allyTarget = allyHero:GetAttackTarget()

                    if  J.IsValidTarget(allyTarget)
                    and J.IsInRange(bot, allyTarget, allyHero:GetAttackRange())
                    and allyHero:IsFacingLocation(allyTarget:GetLocation(), 30)
                    and J.IsAttacking(allyHero)
                    and not J.IsSuspiciousIllusion(allyTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end

        local nTeamFightLocation = J.GetTeamFightLocation(bot)

        if nTeamFightLocation ~= nil
        then
            if GetUnitToLocationDistance(bot, nTeamFightLocation) > 1600
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
        and nInRangeAlly ~= nil and nInRangeEnemy
        and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and ((#nInRangeEnemy > #nInRangeAlly)
            or (J.GetHP(bot) < 0.75 and bot:WasRecentlyDamagedByAnyHero(1.7)))
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 450)
        and bot:IsFacingLocation(J.GetEscapeLoc(), 30)
        and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot))
	then
		local nEnemyLaneCreeps = bot:GetNearbyCreeps(600, true)

        if J.IsAttacking(bot)
        then
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            local nEnemyTowers = bot:GetNearbyTowers(600, true)
            if nEnemyTowers ~= nil and #nEnemyTowers >= 1
            and J.CanBeAttacked(nEnemyTowers[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsFarming(bot)
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(300)
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)

        if J.IsAttacking(bot)
        then
            if (nNeutralCreeps ~= nil and #nNeutralCreeps >= 2)
            or (nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderShapeShift()
    if not J.CanCastAbility(ShapeShift)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsInTeamFight(bot, 1200)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

return X