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
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,1,3,3,6,3,3,1,1,6,2,2,2,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_double_branches",
            "item_circlet",
            "item_faerie_fire",
            "item_tango",
        
            "item_bottle",
            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_maelstrom",
            "item_dragon_lance",
            "item_gungir",--
            "item_travel_boots",
            "item_greater_crit",--
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_hurricane_pike",--
            "item_sheepstick",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_boots_of_bearing",--
            "item_aghanims_shard",
            "item_force_staff",--
            "item_rod_of_atos",
            "item_heavens_halberd",--
            "item_shivas_guard",--
            "item_gungir",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_guardian_greaves",--
            "item_aghanims_shard",
            "item_force_staff",--
            "item_rod_of_atos",
            "item_heavens_halberd",--
            "item_shivas_guard",--
            "item_gungir",--
            "item_wind_waker",--
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
            "item_bracer",
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