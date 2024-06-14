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
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
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
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_aghanims_shard",
            "item_blink",
            "item_force_staff",--
            "item_boots_of_bearing",--
            "item_pipe",--
            "item_sheepstick",--
            "item_aeon_disk",--
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_enchanted_mango",
            "item_blood_grenade",
            "item_wind_lace",
        
            "item_boots",
            "item_ring_of_basilius",
            "item_magic_wand",
            "item_arcane_boots",
            "item_aghanims_shard",
            "item_blink",
            "item_glimmer_cape",--
            "item_guardian_greaves",--
            "item_pipe",--
            "item_sheepstick",--
            "item_aeon_disk",--
            "item_overwhelming_blink",--
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
        [1] = {
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_magic_wand",
            "item_wind_lace",
        }
    },
}

return X