local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {4,2,2,1,2,4,2,1,1,1,6,6,4,4,6},
    },
    ['pos_2'] = {
        [1] = {4,2,2,1,2,4,2,1,1,1,6,6,4,4,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_wraith_band",
            "item_boots_of_elves",
            "item_magic_wand",
            "item_power_treads",
            "item_lifesteal",
            "item_manta",--
            "item_angels_demise",--
            "item_black_king_bar",--
            "item_butterfly",--
            "item_aghanims_shard",
            "item_satanic",--
            "item_skadi",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_wraith_band",
            "item_bottle",
            "item_magic_wand",
            "item_boots_of_elves",
            "item_power_treads",
            "item_lifesteal",
            "item_manta",--
            "item_angels_demise",--
            "item_black_king_bar",--
            "item_butterfly",--
            "item_aghanims_shard",
            "item_satanic",--
            "item_disperser",--
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_quelling_blade",
            "item_wraith_band",
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_wraith_band",
            "item_bottle",
            "item_power_treads",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X