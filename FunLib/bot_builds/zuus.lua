local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_arcane_boots",
            "item_phylactery",
            "item_magic_wand",
            "item_kaya",
            "item_ultimate_scepter",
            "item_kaya_and_sange",--
            "item_black_king_bar",--
            "item_octarine_core",--
            "item_aghanims_shard",
            "item_travel_boots",
            "item_angels_demise",--
            "item_travel_boots_2",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_magic_stick",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_wind_lace",
            "item_phylactery",
            "item_magic_wand",
            "item_aether_lens",
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_octarine_core",--
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_ethereal_blade",--
            "item_sheepstick",--
            "item_angels_demise",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_magic_stick",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_wind_lace",
            "item_phylactery",
            "item_magic_wand",
            "item_aether_lens",
            "item_force_staff",--
            "item_guardian_greaves",--
            "item_octarine_core",--
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_ethereal_blade",--
            "item_sheepstick",--
            "item_angels_demise",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
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