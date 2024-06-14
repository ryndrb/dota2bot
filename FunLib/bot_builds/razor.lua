local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
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
        [1] = {2,1,2,1,2,6,2,3,1,1,6,3,3,3,6},
    },
    ['pos_2'] = {
        [1] = {2,1,2,1,2,6,2,3,1,1,6,3,3,3,6},
    },
    ['pos_3'] = {
        [1] = {1,2,2,1,1,6,1,3,3,3,6,3,2,2,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
            "item_quelling_blade",
        
            "item_power_treads",
            "item_magic_wand",
            "item_falcon_blade",
            "item_manta",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_butterfly",--
            "item_satanic",--
            "item_assault",--
            "item_skadi",--
            "item_refresher",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
            "item_quelling_blade",
        
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
            "item_falcon_blade",
            "item_manta",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_butterfly",--
            "item_satanic",--
            "item_assault",--
            "item_skadi",--
            "item_refresher",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_slippers",
            "item_circlet",
        
            "item_wraith_band",
            "item_boots",
            "item_magic_wand",
            "item_falcon_blade",
            "item_power_treads",
            "item_manta",--
            "item_black_king_bar",--
            "item_aghanims_shard",
            "item_shivas_guard",--
            "item_assault",--
            "item_refresher",--
            "item_satanic",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_power_treads",
            "item_magic_wand",
            "item_falcon_blade",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_quelling_blade",
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
            "item_falcon_blade",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_wraith_band",
            "item_magic_wand",
            "item_falcon_blade",
            "item_power_treads",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X