local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_lotus_orb", "item_pipe", "item_crimson_guard", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {3,1,2,3,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {3,1,2,3,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_4'] = {
        [1] = {3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},
    },
    ['pos_5'] = {
        [1] = {3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_tango",
            "item_double_branches",
        
            "item_bottle",
            "item_bracer",
            "item_wind_lace",
            "item_phase_boots",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_octarine_core",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_cyclone",
            "item_ultimate_scepter_2",
            "item_wind_waker",--
            "item_travel_boots",
            "item_heart",--
            "item_yasha_and_kaya",--
            "item_aghanims_shard",
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_tango",
            "item_double_branches",
        
            "item_bracer",
            "item_wind_lace",
            "item_phase_boots",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_octarine_core",--
            "item_black_king_bar",--
            sUtilityItem,--
            "item_ultimate_scepter",
            "item_cyclone",
            "item_ultimate_scepter_2",
            "item_wind_waker",--
            "item_travel_boots",
            "item_yasha_and_kaya",--
            "item_aghanims_shard",
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_ancient_janggo",
            "item_invis_sword",
            "item_cyclone",
            "item_octarine_core",--
            "item_boots_of_bearing",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_silver_edge",--
            "item_wind_waker",--
            sUtilityItem,--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_mekansm",
            "item_invis_sword",
            "item_cyclone",
            "item_octarine_core",--
            "item_guardian_greaves",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_silver_edge",--
            "item_wind_waker",--
            sUtilityItem,--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_hand_of_midas",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
            "item_hand_of_midas",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_magic_wand",
        }
    },
}

return X