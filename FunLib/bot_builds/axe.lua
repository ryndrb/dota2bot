local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_pipe", "item_lotus_orb", "item_crimson_guard", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
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
        [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
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
            "item_quelling_blade",
            "item_gauntlets",
            "item_ring_of_protection",

            "item_bracer",
            "item_boots",
            "item_chainmail",
            "item_phase_boots",
            "item_magic_wand",
            "item_blade_mail",
            "item_blink",
            "item_black_king_bar",--
            sUtilityItem,--
            "item_shivas_guard",--
            "item_travel_boots",
            "item_heart",--
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
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
            "item_ring_of_protection",
            "item_bracer",
            "item_chainmail",
            "item_magic_wand",
            "item_blade_mail",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X