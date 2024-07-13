local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
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
            
                "item_bracer",
                "item_bottle",
                "item_soul_ring",
                "item_arcane_boots",
                "item_magic_wand",
                "item_blink",
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_greater_crit",--
                "item_travel_boots",
                "item_overwhelming_blink",--`
                "item_wind_waker",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_bracer",
                "item_bottle",
                "item_soul_ring",
                "item_magic_wand",
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
            
                "item_bracer",
                "item_soul_ring",
                "item_arcane_boots",
                "item_magic_wand",
                "item_blink",
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_black_king_bar",--
                sUtilityItem,--
                "item_octarine_core",--
                "item_greater_crit",--
                "item_travel_boots",
                "item_overwhelming_blink",--`
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_bracer",
                "item_soul_ring",
                "item_magic_wand",
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
                }
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
                "item_aether_lens",--
                "item_cyclone",
                "item_boots_of_bearing",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_wind_waker",--
                "item_overwhelming_blink",--
                "item_black_king_bar",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand",
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
                }
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
                "item_aether_lens",--
                "item_cyclone",
                "item_guardian_greaves",--
                "item_octarine_core",--
                "item_ultimate_scepter",
                "item_wind_waker",--
                "item_overwhelming_blink",--
                "item_black_king_bar",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
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

return X