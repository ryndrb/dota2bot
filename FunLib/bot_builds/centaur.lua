local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
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
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {
        [1] = {1,2,2,1,2,6,2,1,1,3,3,6,3,3,6},
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
            "item_ring_of_protection",
        
            "item_helm_of_iron_will",
            "item_phase_boots",
            "item_magic_wand",
            "item_veil_of_discord",
            "item_blink",
            "item_eternal_shroud",--
            "item_shivas_guard",--
            sUtilityItem,
            "item_aghanims_shard",
            "item_kaya_and_sange",--
            "item_heart",--
            "item_overwhelming_blink",--
            "item_travel_boots_2",--
            "item_moon_shard",
            "item_ultimate_scepter",
            "item_ultimate_scepter_2",
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
            "item_helm_of_iron_will",
            "item_magic_wand",
        }
    },
    ['pos_4'] = {},
    ['pos_5'] = {},
}

return X