local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {},
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
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {3,2,3,1,3,6,3,2,2,2,6,1,1,1,6},
    },
    ['pos_4'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_blight_stone",
            "item_tango",
            "item_faerie_fire",
            "item_double_branches",
        
            "item_power_treads",
            "item_magic_wand",
            "item_gungir",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_orchid",
            "item_satanic",--
            "item_assault",--
            "item_bloodthorn",--
            "item_monkey_king_bar",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_blight_stone",
            "item_tango",
            "item_faerie_fire",
            "item_double_branches",
        
            "item_power_treads",
            "item_magic_wand",
            "item_gungir",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            sUtilityItem,--
            "item_assault",--
            "item_satanic",--
            "item_sheepstick",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_double_circlet",
        
            "item_urn_of_shadows",
            "item_magic_wand",
            "item_spirit_vessel",--
            "item_boots",
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_orchid",
            "item_boots_of_bearing",--
            "item_heavens_halberd",--
            "item_bloodthorn",--
            "item_black_king_bar",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_double_circlet",
        
            "item_urn_of_shadows",
            "item_magic_wand",
            "item_spirit_vessel",--
            "item_boots",
            "item_aghanims_shard",
            "item_ultimate_scepter",
            "item_orchid",
            "item_guardian_greaves",--
            "item_heavens_halberd",--
            "item_bloodthorn",--
            "item_black_king_bar",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_blight_stone",
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_blight_stone",
            "item_power_treads",
            "item_magic_wand",
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