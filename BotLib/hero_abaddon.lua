local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_crimson_guard", "item_heavens_halberd", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_orb_of_venom",
                "item_circlet",

                "item_wraith_band",
                "item_orb_of_corrosion",
                "item_magic_wand",
                "item_power_treads",
                "item_echo_sabre",
                "item_manta",--
                "item_harpoon",--
                "item_black_king_bar",--
                "item_skadi",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_travel_boots_2",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
            }
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_orb_of_venom",
                "item_circlet",

                "item_bottle",
                "item_wraith_band",
                "item_boots",
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_phase_boots",
                "item_echo_sabre",
                "item_yasha",
                "item_harpoon",--
                "item_manta",--
                "item_ultimate_scepter_2",
                "item_assault",--
                "item_black_king_bar",--
                "item_basher",
                "item_aghanims_shard",
                "item_travel_boots",
                "item_abyssal_blade",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bottle",
                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
            }
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
                },
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
    
                "item_wraith_band",
                "item_orb_of_venom",
                "item_boots",
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_phase_boots",
                "item_echo_sabre",
                "item_manta",--
                "item_harpoon",--
                "item_blink",
                sUtilityItem,--
                "item_skadi",--
                "item_aghanims_shard",
                "item_travel_boots",
                "item_overwhelming_blink",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_wraith_band",
                "item_magic_wand",
                "item_orb_of_corrosion",
            }
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_enchanted_mango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
    
                "item_tranquil_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_holy_locket",--
                "item_ultimate_scepter",
                "item_force_staff",--
                "item_boots_of_bearing",--
                "item_lotus_orb",--
                "item_wind_waker",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard"
            },
            ['sell_list'] = {
                "item_magic_wand",
            }
        },
    },
    ['pos_5'] = {
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
                [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_enchanted_mango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
    
                "item_arcane_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_holy_locket",--
                "item_ultimate_scepter",
                "item_force_staff",--
                "item_guardian_greaves",--
                "item_lotus_orb",--
                "item_wind_waker",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard"
            },
            ['sell_list'] = {
                "item_magic_wand",
            }
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