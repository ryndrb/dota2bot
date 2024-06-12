local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
        [2] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
        [2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_2'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
        [2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_3'] = {
        [1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
        [2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_bracer",
            "item_arcane_boots",
            "item_vanguard",
            "item_magic_wand",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_bloodstone",--
            "item_kaya_and_sange",--
            "item_black_king_bar",--
            "item_assault",--
            "item_basher",
            "item_travel_boots_2",--
            "item_abyssal_blade",--
            "item_moon_shard",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_bracer",
            "item_bottle",
            "item_arcane_boots",
            "item_vanguard",
            "item_magic_wand",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_bloodstone",--
            "item_kaya_and_sange",--
            "item_black_king_bar",--
            "item_assault",--
            "item_basher",
            "item_travel_boots_2",--
            "item_abyssal_blade",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_bracer",
            "item_arcane_boots",
            "item_vanguard",
            "item_magic_wand",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_bloodstone",--
            "item_pipe",--
            sUtilityItem,--
            "item_shivas_guard",--
            "item_black_king_bar",--
            "item_travel_boots",
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_moon_shard",
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
            "item_vanguard",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_bottle",
            "item_vanguard",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_vanguard",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X