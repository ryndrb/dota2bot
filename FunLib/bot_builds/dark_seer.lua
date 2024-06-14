local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_magic_stick",
            "item_quelling_blade",
            "item_enchanted_mango",
        
            "item_magic_wand",
            "item_arcane_boots",
            "item_veil_of_discord",
            "item_guardian_greaves",--
            "item_blink",
            sUtilityItem,--
            "item_ultimate_scepter",
            "item_black_king_bar",--
            "item_shivas_guard",--
            "item_sheepstick",--
            "item_arcane_blink",--
            "item_ultimate_scepter_2",
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X