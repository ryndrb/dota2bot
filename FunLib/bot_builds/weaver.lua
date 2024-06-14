local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_nullifier", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {2,3,2,3,2,6,3,2,3,1,6,1,1,1,6},
    },
    ['pos_4'] = {
        [1] = {2,3,1,2,2,6,2,1,1,1,6,3,3,3,6},
    },
    ['pos_5'] = {
        [1] = {2,3,1,2,2,6,2,1,1,1,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_wraith_band",
            "item_falcon_blade",
            "item_power_treads",
            "item_magic_wand",
            "item_maelstrom",
            "item_dragon_lance",
            "item_gungir",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_greater_crit",--
            "item_hurricane_pike",--
            "item_satanic",--
            "item_butterfly",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_enchanted_mango",
            "item_double_branches",
            "item_circlet",
            "item_slippers",
        
            "item_magic_wand",
            "item_double_wraith_band",
            "item_power_treads",
            "item_maelstrom",
            "item_sphere",--
            "item_desolator",--
            sUtilityItem,--
            "item_orchid",
            "item_gungir",--
            "item_aghanims_shard",
            "item_bloodthorn",--
            "item_satanic",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_circlet",
        
            "item_spirit_vessel",--
            "item_magic_wand",
            "item_rod_of_atos",
            "item_heavens_halberd",--
            "item_boots_of_bearing",--
            "item_gungir",--
            "item_sheepstick",--
            "item_sphere",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_circlet",
        
            "item_spirit_vessel",--
            "item_magic_wand",
            "item_rod_of_atos",
            "item_heavens_halberd",--
            "item_guardian_greaves",--
            "item_gungir",--
            "item_sheepstick",--
            "item_sphere",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_wraith_band",
            "item_falcon_blade",
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_bracer",
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