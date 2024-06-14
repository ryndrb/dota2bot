local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_4'] = {
        [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
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
        }
    },
    ['pos_3'] = {
        [1] = {
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
        }
    },
    ['pos_4'] = {
        [1] = {
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
        }
    },
    ['pos_5'] = {
        [1] = {
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
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_bottle",
            "item_soul_ring",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_soul_ring",
            "item_magic_wand",
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