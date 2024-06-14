local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,2,2,1,2,6,2,1,1,3,6,3,3,3,6},
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_faerie_fire",
            "item_double_circlet",
        
            "item_bottle",
            "item_double_null_talisman",
            "item_magic_wand",
            "item_blink",--
            "item_ultimate_scepter",
            "item_arcane_blink",--
            "item_shivas_guard",--
            "item_sphere",--
            "item_octarine_core",--
            "item_cyclone",
            "item_sheepstick",--
            "item_wind_waker",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_magic_wand",
            "item_bottle",
            "item_null_talisman",
        }
    },
    ['pos_3'] = {},
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X