local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,3,1,3,6,3,2,2,2,6,1,1,1,6},
    },
    ['pos_2'] = {
        [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
        
            "item_magic_wand",
            "item_falcon_blade",
            "item_boots",
            "item_maelstrom",
            "item_travel_boots",
            "item_gungir",--
            "item_dragon_lance",
            "item_black_king_bar",--
            "item_greater_crit",--
            "item_satanic",--
            "item_hurricane_pike",--
            "item_aghanims_shard",
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_null_talisman",
            "item_boots",
            "item_magic_wand",
            "item_travel_boots",
            "item_aether_lens",--
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_ethereal_blade",--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_blood_grenade",
            "item_double_circlet",
            "item_double_branches",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_aether_lens",
            "item_cyclone",
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_boots_of_bearing",--
            "item_ghost",
            "item_maelstrom",
            "item_ethereal_blade",--
            "item_wind_waker",--
            "item_gungir",--
            "item_sheepstick",--
            "item_hurricane_pike",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_blood_grenade",
            "item_double_circlet",
            "item_double_branches",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_aether_lens",
            "item_cyclone",
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_guardian_greaves",--
            "item_ghost",
            "item_maelstrom",
            "item_ethereal_blade",--
            "item_wind_waker",--
            "item_gungir",--
            "item_sheepstick",--
            "item_hurricane_pike",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_magic_wand",
            "item_falcon_blade",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_bottle",
            "item_null_talisman",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
}

return X