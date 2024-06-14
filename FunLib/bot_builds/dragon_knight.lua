local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
        [2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
        [3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
    },
    ['pos_2'] = {
        [1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
        [2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
        [3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
        [2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
        [3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_double_branches",
            "item_tango",
        
            "item_bracer",
            "item_power_treads",
            "item_magic_wand",
            "item_mage_slayer",--
            "item_manta",--
            "item_ultimate_scepter",
            "item_orchid",
            "item_black_king_bar",--
            "item_bloodthorn",--
            "item_greater_crit",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",
        
            "item_bottle",
            "item_double_bracer",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_hand_of_midas",
            "item_blink",
            "item_manta",--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_octarine_core",--
            "item_assault",--
            "item_travel_boots",
            "item_ultimate_scepter_2",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_gauntlets",
            "item_circlet",
        
            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_hand_of_midas",
            "item_blink",
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_assault",--
            "item_octarine_core",--
            "item_bloodthorn",--
            "item_ultimate_scepter_2",
            "item_travel_boots",
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
        
            "item_moon_shard",
            "item_aghanims_shard",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bottle",
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
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X