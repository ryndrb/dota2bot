local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {2,1,2,1,2,6,2,3,3,3,6,3,1,1,6},
    },
    ['pos_5'] = {
        [1] = {1,2,2,3,2,6,3,1,1,1,6,3,3,3,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_ring_of_basilius",
            "item_magic_wand",
            "item_vladmir",--
            "item_ancient_janggo",
            "item_boots",
            "item_solar_crest",--
            "item_aghanims_shard",
            "item_boots_of_bearing",--
            "item_glimmer_cape",--
            "item_holy_locket",--
            "item_assault",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_ring_of_basilius",
            "item_magic_wand",
            "item_vladmir",--
            "item_mekansm",
            "item_boots",
            "item_pipe",--
            "item_aghanims_shard",
            "item_guardian_greaves",--
            "item_glimmer_cape",--
            "item_holy_locket",--
            "item_assault",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {}
    },
    ['pos_5'] = {
        [1] = {}
    },
}

return X