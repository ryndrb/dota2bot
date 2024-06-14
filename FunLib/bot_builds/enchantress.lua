local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
    },
    ['pos_4'] = {
        [1] = {2,3,2,3,2,6,2,1,1,1,1,6,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,3,2,3,2,6,2,1,1,1,1,6,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_magic_stick",
            "item_double_branches",
            "item_circlet",
        
            "item_bracer",
            "item_power_treads",
            "item_magic_wand",
            "item_mage_slayer",--
            "item_hurricane_pike",--
            sUtilityItem,--
            "item_pipe",--
            "item_assault",--
            "item_moon_shard",
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_blood_grenade",
        
            "item_magic_wand",
            "item_boots",
            "item_hurricane_pike",--
            "item_aghanims_shard",
            "item_mage_slayer",--
            "item_boots_of_bearing",--
            "item_moon_shard",--
            "item_bloodthorn",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_blood_grenade",
        
            "item_magic_wand",
            "item_boots",
            "item_hurricane_pike",--
            "item_aghanims_shard",
            "item_mage_slayer",--
            "item_guardian_greaves",--
            "item_moon_shard",--
            "item_bloodthorn",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_bracer",
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