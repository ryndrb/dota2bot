local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
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
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
    },
    ['pos_4'] = {
        [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_circlet",
        
            "item_magic_wand",
            "item_vladmir",
            "item_boots",
            "item_blink",
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_octarine_core",--
            sUtilityItem,--
            "item_refresher",--
            "item_travel_boots",
            "item_arcane_blink",--
            "item_travel_boots_2",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_enchanted_mango",
            "item_double_tango",
            "item_circlet",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_magic_wand",
            "item_boots",
            "item_vladmir",--
            "item_tranquil_boots",
            "item_blink",
            "item_boots_of_bearing",--
            "item_black_king_bar",--
            "item_pipe",--
            "item_refresher",--
            "item_arcane_blink",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_enchanted_mango",
            "item_double_tango",
            "item_circlet",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_magic_wand",
            "item_boots",
            "item_vladmir",--
            "item_arcane_boots",
            "item_blink",
            "item_guardian_greaves",--
            "item_black_king_bar",--
            "item_pipe",--
            "item_refresher",--
            "item_arcane_blink",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
            "item_vladmir",
        }
    },
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