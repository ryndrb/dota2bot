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
local WolfBite      = bot:GetAbilityByName('lycan_wolf_bite')
local ShapeShift    = bot:GetAbilityByName('lycan_shapeshift')

local SummonWolvesDesire
local HowlDesire
local WoflBiteDesire, WoflBiteTarget
local ShapeShiftDesire

local bAttacking = false
local botTarget, botHP, botMaxMana, botManaRegen
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    SummonWolves  = bot:GetAbilityByName('lycan_summon_wolves')
    Howl          = bot:GetAbilityByName('lycan_howl')
    ShapeShift    = bot:GetAbilityByName('lycan_shapeshift')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
	botMaxMana = bot:GetMaxMana()
    botManaRegen = bot:GetManaRegen()
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    ShapeShiftDesire = X.ConsiderShapeShift()
    if ShapeShiftDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ShapeShift)
        return
    end

    HowlDesire = X.ConsiderHowl()
    if HowlDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Howl)
        return
    end

    SummonWolvesDesire = X.ConsiderSummonWolves()
    if SummonWolvesDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SummonWolves)
        return
    end

    WoflBiteDesire, WoflBiteTarget = X.ConsiderWolfBite()
    if WoflBiteDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(WolfBite, WoflBiteTarget)
        return
    end
end

function X.ConsiderSummonWolves()
    if not J.CanCastAbility(SummonWolves) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nManaCost = SummonWolves:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SummonWolves, Howl, ShapeShift})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Howl, ShapeShift})

    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if J.IsValid(unit) then
            local sUnitName = unit:GetUnitName()
            if string.find(sUnitName, 'lycan_wolf') then
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
		then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if J.CanBeAttacked(botTarget)
            or #nInRangeEnemy >= 2
            then
                if #nInRangeAlly >= #nInRangeEnemy then
                    if fManaAfter > fManaThreshold2 then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes <= 1 and #nAllyHeroes <= 2 then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.GetHP(enemyHero) < 0.5
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if enemyHero:GetAttackTarget() == bot and fManaAfter > fManaThreshold2 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and fManaAfter > 0.3 and bAttacking and #nAllyHeroes <= 3 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end

            if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) and #nAllyHeroes >= 2 and fManaAfter > 0.5 and #nEnemyHeroes == 0 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and fManaAfter > 0.5 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 3 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, 800, 0, 0)
        if #nInRangeEnemy == 0 and nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > 0.55
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > 0.55
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHowl()
    if not J.CanCastAbility(Howl) then
        return BOT_ACTION_DESIRE_NONE
    end

    local timeOfDay = J.CheckTimeOfDay()
    local nManaCost = Howl:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShapeShift})

    if timeOfDay == 'night' then
        if not J.IsGoingOnSomeone(bot) and #nEnemyHeroes <= 1 then
            for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
                if bot ~= allyHero
                and J.IsValidHero(allyHero)
                and not J.IsSuspiciousIllusion(allyHero)
                then
                    if J.IsCore(allyHero) and J.IsGoingOnSomeone(allyHero) then
                        local allyTarget = allyHero:GetAttackTarget()
                        if  J.IsValidTarget(allyTarget)
                        and J.CanBeAttacked(allyTarget)
                        and J.IsInRange(bot, allyTarget, allyHero:GetAttackRange() + 300)
                        and J.IsAttacking(allyHero)
                        and not J.IsSuspiciousIllusion(allyTarget)
                        and not allyTarget:HasModifier('modifier_lycan_howl')
                        then
                            local nInRangeAlly = J.GetAlliesNearLoc(allyTarget:GetLocation(), 1200)
                            local nInRangeEnemy = J.GetEnemiesNearLoc(allyTarget:GetLocation(), 1200)
                            if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                                return BOT_ACTION_DESIRE_HIGH
                            end
                        end
                    end
                end
            end

            local vTeamFightLocation = J.GetTeamFightLocation(bot)

            if vTeamFightLocation ~= nil and GetUnitToLocationDistance(bot, vTeamFightLocation) > 1600 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
		then
            if fManaAfter > fManaThreshold1 then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and enemyHero:IsFacingLocation(bot:GetLocation(), 45)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if enemyHero:GetAttackTarget() == bot and (botHP < 0.5 or #nEnemyHeroes > #nAllyHeroes) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) and fManaAfter > 0.6 and #nAllyHeroes <= 2 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > 0.6 and bAttacking and #nEnemyHeroes == 0 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking and #nEnemyHeroes == 0 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3 and not J.CanKillTarget(nEnemyCreeps[1], bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL))
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.GetHP(botTarget) > 0.25
        and bAttacking
        and fManaAfter > fManaThreshold1
        and fManaAfter > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and fManaAfter > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderWolfBite()
    if not J.CanCastAbility(WolfBite) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, WolfBite:GetCastRange())
    local nManaCost = WolfBite:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShapeShift})

    if J.IsInTeamFight(bot, 800) and fManaAfter > fManaThreshold1 then
        local hTarget = nil
        local hTargetScore = 0
        for _, allyHero in pairs(nAllyHeroes) do
            if bot ~= allyHero
            and J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange + 300)
            and J.IsCore(allyHero)
            and not allyHero:IsInvulnerable()
            and not J.IsSuspiciousIllusion(allyHero)
            and not J.IsRetreating(allyHero)
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and allyHero:GetUnitName() ~= 'npc_dota_hero_templar_assassin'
            and allyHero:GetAttackRange() <= 300
            then
                local allyHeroScore = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed() * Max(0.5, J.GetHP(allyHero))
                if allyHeroScore > hTargetScore then
                    hTarget = allyHero
                    hTargetScore = allyHeroScore
                end
            end
        end

        if hTarget ~= nil then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShapeShift()
    if not J.CanCastAbility(ShapeShift) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if not (#nInRangeAlly >= #nInRangeEnemy + 2)
            or (J.IsInTeamFight(bot, 1200) and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X