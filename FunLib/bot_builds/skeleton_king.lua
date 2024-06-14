local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
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
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_gauntlets",
            "item_quelling_blade",
        
            "item_phase_boots",
            "item_magic_wand",
            "item_armlet",
            "item_radiance",--
            "item_blink",
            "item_aghanims_shard",
            "item_assault",--
            "item_ultimate_scepter",
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_abyssal_blade",--
            "item_travel_boots",
            "item_refresher",--
            "item_travel_boots_2",--
            "item_moon_shard",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_quelling_blade",
            "item_gauntlets",
            "item_magic_stick",
            "item_branches",
        
            "item_bracer",
            "item_magic_wand",
            "item_phase_boots",
            "item_radiance",--
            "item_blink",
            "item_ultimate_scepter",
            "item_assault",--
            "item_aghanims_shard",
            "item_overwhelming_blink",--
            "item_refresher",--
            "item_ultimate_scepter_2",
            "item_nullifier",--
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
            "item_gauntlets",
            "item_quelling_blade",
            "item_magic_wand",
            "item_armlet",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X