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
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {
        [1] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
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
            "item_faerie_fire",
            "item_quelling_blade",
            "item_circlet",
        
            "item_phase_boots",
            "item_magic_wand",
            "item_bfury",--
            "item_blink",
            "item_basher",
            "item_black_king_bar",--
            "item_abyssal_blade",--
            "item_ultimate_scepter",
            "item_satanic",--
            "item_swift_blink",--
            "item_ultimate_scepter_2",
            "item_travel_boots",
            "item_moon_shard",
            "item_aghanims_shard",
            "item_travel_boots_2",--
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X