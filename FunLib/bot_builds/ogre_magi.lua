local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
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
        [1] = {3,2,2,1,2,7,2,1,1,1,7,3,3,3,7},
    },
    ['pos_3'] = {
        [1] = {2,1,2,3,2,7,3,1,1,1,7,3,3,2,7},
    },
    ['pos_4'] = {
        [1] = {2,1,2,3,2,7,2,1,1,1,7,3,3,3,7},
    },
    ['pos_5'] = {
        [1] = {2,1,2,3,2,7,2,1,1,1,7,3,3,3,7},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_gauntlets",
        
            "item_bottle",
            "item_phase_boots",
            "item_soul_ring",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_blade_mail",
            "item_heart",--
            "item_black_king_bar",--
            "item_shivas_guard",--
            "item_ultimate_scepter",
            "item_octarine_core",--
            "item_travel_boots",
            "item_ultimate_scepter_2",
            "item_sheepstick",--
            "item_travel_boots_2",
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_gauntlets",
        
            "item_boots",
            "item_hand_of_midas",
            "item_magic_wand",
            "item_aether_lens",--
            "item_ultimate_scepter",
            sUtilityItem,--
            "item_sange_and_yasha",--
            "item_travel_boots",
            "item_shivas_guard",--
            "item_ultimate_scepter_2",
            "item_heart",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_enchanted_mango",
            "item_faerie_fire",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_aether_lens",--
            "item_boots_of_bearing",--
            "item_pipe",--
            "item_sheepstick",--
            "item_assault",--
            "item_heart",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_enchanted_mango",
            "item_faerie_fire",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_aether_lens",--
            "item_guardian_greaves",--
            "item_pipe",--
            "item_sheepstick",--
            "item_assault",--
            "item_heart",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_gauntlets",
            "item_bottle",
            "item_soul_ring",
            "item_magic_wand",
            "item_hand_of_midas",
            "item_blade_mail",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_gauntlets",
            "item_hand_of_midas",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_magic_wand",
            "item_hand_of_midas",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_magic_wand",
            "item_hand_of_midas",
        }
    },
}

return X