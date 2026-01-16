local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_lone_druid'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        -- bear build first
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
                [1] = {1,2,1,2,1,2,1,2,6,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",

                "item_magic_wand",
                "item_wraith_band",
                "item_phase_boots",--bear
                "item_diffusal_blade",
                "item_desolator",--bear
                "item_power_treads",
                "item_assault",--bear
                "item_black_king_bar",--ld
                "item_basher",
                "item_bloodthorn",--bear
                
                "item_eagle",
                "item_recipe_disperser",
                -- "item_disperser",--bear
                
                "item_sange",
                "item_recipe_abyssal_blade",
                -- "item_abyssal_blade",--bear

                "item_ultimate_scepter",
                "item_recipe_ultimate_scepter_2",
                
                "item_vladmir",--ld
                "item_butterfly",--ld
                "item_nullifier",--ld
                "item_moon_shard",
                "item_sheepstick",--ld
                "item_moon_shard",
                "item_travel_boots_2",--ld
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_butterfly",
                "item_magic_wand", "item_nullifier",
                "item_wraith_band", "item_sheepstick",
            },
        },
        -- ld build first
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,2,1,2,6,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",

                "item_magic_wand",
                "item_wraith_band",
                "item_power_treads",
                "item_maelstrom",
                "item_lesser_crit",
                "item_phase_boots",--bear
                "item_black_king_bar",--ld
                "item_mjollnir",--ld
                "item_butterfly",--ld
                "item_greater_crit",--ld
                "item_aghanims_shard",

                "item_desolator",--bear
                "item_assault",--bear

                "item_satanic",--ld

                "item_nullifier",--bear
                "item_basher",
                "item_skadi",--bear

                "item_sange",
                "item_recipe_abyssal_blade",
                -- "item_abyssal_blade",--bear

                "item_ultimate_scepter",
                "item_recipe_ultimate_scepter_2",

                "item_moon_shard",
                "item_moon_shard",
                "item_travel_boots_2",--ld
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_butterfly",
                "item_wraith_band", "item_satanic",
            },
        },
    },
    ['pos_2'] = {
        -- bear build first
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
                [1] = {1,2,1,2,1,2,1,2,6,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",

                "item_magic_wand",
                "item_wraith_band",
                "item_phase_boots",--bear
                "item_diffusal_blade",
                "item_desolator",--bear
                "item_power_treads",
                "item_assault",--bear
                "item_black_king_bar",--ld
                "item_basher",
                "item_bloodthorn",--bear
                
                "item_eagle",
                "item_recipe_disperser",
                -- "item_disperser",--bear
                
                "item_sange",
                "item_recipe_abyssal_blade",
                -- "item_abyssal_blade",--bear

                "item_ultimate_scepter",
                "item_recipe_ultimate_scepter_2",
                
                "item_vladmir",--ld
                "item_butterfly",--ld
                "item_nullifier",--ld
                "item_moon_shard",
                "item_sheepstick",--ld
                "item_moon_shard",
                "item_travel_boots_2",--ld
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_butterfly",
                "item_magic_wand", "item_nullifier",
                "item_wraith_band", "item_sheepstick",
            },
        },
        -- ld build first
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,2,1,2,6,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",

                "item_magic_wand",
                "item_wraith_band",
                "item_power_treads",
                "item_maelstrom",
                "item_lesser_crit",
                "item_phase_boots",--bear
                "item_black_king_bar",--ld
                "item_mjollnir",--ld
                "item_butterfly",--ld
                "item_greater_crit",--ld
                "item_aghanims_shard",

                "item_desolator",--bear
                "item_assault",--bear

                "item_satanic",--ld

                "item_nullifier",--bear
                "item_basher",
                "item_skadi",--bear

                "item_sange",
                "item_recipe_abyssal_blade",
                -- "item_abyssal_blade",--bear

                "item_ultimate_scepter",
                "item_recipe_ultimate_scepter_2",

                "item_moon_shard",
                "item_moon_shard",
                "item_travel_boots_2",--ld
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_butterfly",
                "item_wraith_band", "item_satanic",
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

local sSelectedBuild = {}

local buildNum = RandomInt(1, 2)
GLOBAL_bBearBuildFirst = true
if buildNum == 2 then
    GLOBAL_bBearBuildFirst = false
    sSelectedBuild = HeroBuild[sRole][2]
else
    sSelectedBuild = HeroBuild[sRole][1]
end

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

local Entangle          = bot:GetAbilityByName('lone_druid_entangle')
-- local SpiritLink        = bot:GetAbilityByName('lone_druid_spirit_link')
local SavageRoar        = bot:GetAbilityByName('lone_druid_savage_roar')
local SummonSpiritBear  = bot:GetAbilityByName('lone_druid_spirit_bear')
local TrueForm          = bot:GetAbilityByName('lone_druid_true_form')

local EntangleDesire, EntangleLocation
local SavageRoarDesire
local SummonSpiritBearDesire
local TrueFormDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Entangle          = bot:GetAbilityByName('lone_druid_entangle')
    SavageRoar        = bot:GetAbilityByName('lone_druid_savage_roar')
    SummonSpiritBear  = bot:GetAbilityByName('lone_druid_spirit_bear')
    TrueForm          = bot:GetAbilityByName('lone_druid_true_form')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    TrueFormDesire = X.ConsiderTrueForm()
    if TrueFormDesire > 0 then
        bot:Action_UseAbility(TrueForm)
        return
    end

    EntangleDesire, EntangleLocation = X.ConsiderEntangle()
    if EntangleDesire > 0 then
        bot:Action_UseAbilityOnLocation(Entangle, EntangleLocation)
        return
    end

    SavageRoarDesire = X.ConsiderSavageRoar()
    if SavageRoarDesire > 0 then
        bot:Action_UseAbility(SavageRoar)
        return
    end

    SummonSpiritBearDesire = X.ConsiderSummonSpiritBear()
    if SummonSpiritBearDesire > 0 then
        bot:Action_UseAbility(SummonSpiritBear)
        return
    end
end

function X.ConsiderEntangle()
    if not J.CanCastAbility(Entangle) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = Entangle:GetCastRange()
    local nRadius = Entangle:GetSpecialValueInt('active_radius')

    if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSummonSpiritBear()
    if not J.CanCastAbility(SummonSpiritBear) then
        return BOT_ACTION_DESIRE_NONE
    end

    local IsBearAlive = false

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if J.IsValid(unit) then
            if string.find(unit:GetUnitName(), 'npc_dota_hero_lone_druid_bear') then
                IsBearAlive = true
                break
            end
        end
	end

	if not IsBearAlive
    and not (  (botHP < 0.2 and bot:WasRecentlyDamagedByAnyHero(2.0))
            or (J.IsRetreating(bot) and #nEnemyHeroes >= #nAllyHeroes + 2))
    then
		return BOT_ACTION_DESIRE_HIGH
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSavageRoar()
    if not J.CanCastAbility(SavageRoar) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = SavageRoar:GetSpecialValueInt('radius')
    local nManaCost = SavageRoar:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TrueForm})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and fManaAfter > fManaThreshold1
		then
			if enemyHero:HasModifier('modifier_teleporting') then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
		then
            if #nAllyHeroes >= #nEnemyHeroes and not (#nAllyHeroes >= #nEnemyHeroes + 2) then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTrueForm()
    if not J.CanCastAbility(TrueForm) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if botHP < 0.75 or J.IsInTeamFight(bot, 1200) then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) and botHP < 0.7 then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

local function HasHaveNotItem(unit, hasList, notList)
    for _, sItemName in ipairs(hasList) do
        if unit:FindItemSlot(sItemName) < 0 then
            return false
        end
    end

    if not notList then return true end

    for _, sItemName in ipairs(notList) do
        if unit:FindItemSlot(sItemName) >= 0 then
            return false
        end
    end

    return true
end

-- Items to give; with rules
-- bear build first
GLOBAL_hBearItemList_FirstBear = {
	item_phase_boots = function (bear, druid) return nil end,--bear
	item_diffusal_blade = function (bear, druid) return nil end,
    item_desolator = function (bear, druid) return nil end,
	item_assault = function (bear, druid) return nil end,--bear
    item_basher = function (bear, druid) return nil end,
    item_bloodthorn = function (bear, druid) return nil end,--bear

	item_eagle = function (bear, druid) return nil end,
	item_recipe_disperser = function (bear, druid) return nil end,
	item_disperser = function (bear, druid) return nil end,--bear

    item_sange = function (bear, druid) return nil end,
    item_recipe_abyssal_blade = function (bear, druid) return nil end,
    item_abyssal_blade = function (bear, druid) return nil end,--bear

	item_ultimate_scepter = function (bear, druid)
        return not HasHaveNotItem(bear, {'item_ultimate_scepter'})
    end,
	item_recipe_ultimate_scepter_2 = function (bear, druid)
        return HasHaveNotItem(bear, {'item_ultimate_scepter'})
    end,

	item_moon_shard = function (bear, druid)
        return (not bear:HasModifier('modifier_item_moon_shard_consumed') or not J.HasItem(bear, 'item_moon_shard'))
    end,
}
-- ld build first
GLOBAL_hBearItemList_FirstDruid = {
    item_phase_boots = function (bear, druid) return nil end,
	item_desolator = function (bear, druid) return nil end,
	item_assault = function (bear, druid) return nil end,
    item_nullifier = function (bear, druid) return nil end,
    item_basher = function (bear, druid) return nil end,
    item_skadi = function (bear, druid) return nil end,

    item_sange = function (bear, druid) return nil end,
    item_recipe_abyssal_blade = function (bear, druid) return nil end,
    item_abyssal_blade = function (bear, druid) return nil end,--bear

	item_ultimate_scepter = function (bear, druid)
        return not HasHaveNotItem(bear, {'item_ultimate_scepter'})
    end,
    item_recipe_ultimate_scepter_2 = function (bear, druid)
        return HasHaveNotItem(bear, {'item_ultimate_scepter'})
    end,

    item_moon_shard = function (bear, druid)
        return (not bear:HasModifier('modifier_item_moon_shard_consumed') or not J.HasItem(bear, 'item_moon_shard'))
    end,
}

return X