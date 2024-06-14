local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
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
        [1] = {2,3,6,1,2,2,2,3,3,6,3,1,1,1,6,6},
    },
    ['pos_2'] = {
        [1] = {2,3,6,1,2,2,2,3,3,6,3,1,1,1,6,6},
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
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_diffusal_blade",
            "item_blink",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_disperser",--
            "item_skadi",--
            "item_basher",
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_abyssal_blade",--
            "item_swift_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
        
            "item_wraith_band",
            "item_boots",
            "item_magic_wand",
            "item_power_treads",
            "item_diffusal_blade",
            "item_blink",
            "item_ultimate_scepter",
            "item_aghanims_shard",
            "item_disperser",--
            "item_skadi",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_nullifier",--
            "item_swift_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X