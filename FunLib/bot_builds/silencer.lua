local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

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
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {2,1,3,1,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_enchanted_mango",
        
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
            "item_witch_blade",
            "item_hurricane_pike",--
            "item_aghanims_shard",
            "item_black_king_bar",--
            "item_sheepstick",--
            "item_devastator",--
            "item_travel_boots",
            "item_bloodthorn",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_double_enchanted_mango",
            "item_blood_grenade",
        
            "item_tranquil_boots",
            "item_magic_wand",
            "item_force_staff",
            "item_solar_crest",--
            "item_glimmer_cape",--
            "item_boots_of_bearing",--
            "item_aghanims_shard",
            "item_hurricane_pike",--
            "item_sheepstick",--
            "item_refresher",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_double_enchanted_mango",
            "item_blood_grenade",
        
            "item_arcane_boots",
            "item_magic_wand",
            "item_force_staff",
            "item_glimmer_cape",--
            "item_solar_crest",--
            "item_guardian_greaves",--
            "item_aghanims_shard",
            "item_hurricane_pike",--
            "item_refresher",--
            "item_sheepstick",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
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