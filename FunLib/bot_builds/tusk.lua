local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe", "item_nullifier"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_4'] = {
        [1] = {3,1,2,3,3,6,3,2,2,2,6,1,1,1,6},
    },
    ['pos_5'] = {
        [1] = {3,1,2,3,3,6,3,2,2,2,6,1,1,1,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_magic_wand",
            "item_phase_boots",
            "item_blink",
            "item_desolator",--
            "item_black_king_bar",--
            "item_cyclone",
            "item_greater_crit",--
            "item_wind_waker",--
            "item_travel_boots",
            "item_arcane_blink",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
            -- "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_magic_wand",
            "item_phase_boots",
            "item_blink",
            "item_cyclone",
            "item_black_king_bar",--
            sUtilityItem,--
            "item_wind_waker",--
            "item_sheepstick",--
            "item_travel_boots",
            "item_arcane_blink",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
            -- "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_faerie_fire",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_blink",
            -- "item_ultimate_scepter",
            "item_solar_crest",--
            "item_cyclone",
            "item_boots_of_bearing",--
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_lotus_orb",--
            "item_wind_waker",--
            -- "item_ultimate_scepter_2",
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_faerie_fire",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_blink",
            -- "item_ultimate_scepter",
            "item_solar_crest",--
            "item_cyclone",
            "item_guardian_greaves",--
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_lotus_orb",--
            "item_wind_waker",--
            -- "item_ultimate_scepter_2",
            "item_overwhelming_blink",--
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
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
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