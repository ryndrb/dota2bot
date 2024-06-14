local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {3,1,3,1,3,1,1,3,2,6,6,2,2,2,6},
        [2] = {3,2,3,1,3,6,3,2,2,2,1,1,1,6,6},
    },
    ['pos_3'] = {
        [1] = {3,1,3,1,3,1,1,3,2,6,6,2,2,2,6},
        [2] = {3,2,3,1,3,6,3,2,2,2,1,1,1,6,6},
    },
    ['pos_4'] = {
        [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",
        
            "item_double_bracer",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_phylactery",
            "item_blink",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_angels_demise",--
            "item_kaya_and_sange",--
            "item_travel_boots",
            "item_shivas_guard",--
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",
        
            "item_double_bracer",
            "item_boots",
            "item_magic_wand",
            "item_phase_boots",
            "item_phylactery",
            "item_blink",
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_angels_demise",--
            sUtilityItem,--
            "item_shivas_guard",--
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_enchanted_mango",
            "item_double_branches",
            "item_faerie_fire",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_aether_lens",
            "item_force_staff",--
            "item_ultimate_scepter",
            "item_boots_of_bearing",--
            "item_pipe",--
            "item_holy_locket",--
            "item_octarine_core",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_enchanted_mango",
            "item_double_branches",
            "item_faerie_fire",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_aether_lens",
            "item_force_staff",--
            "item_ultimate_scepter",
            "item_guardian_greaves",--
            "item_pipe",--
            "item_holy_locket",--
            "item_octarine_core",--
            "item_wind_waker",--
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
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {
        [1] = {}
    },
    ['pos_5'] = {
        [1] = {}
    },
}

return X