local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_lotus_orb", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
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
            "item_circlet",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_glimmer_cape",--
            "item_boots_of_bearing",--
            "item_force_staff",--
            sUtilityItem,--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_aghanims_shard",
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_blood_grenade",
            "item_circlet",
        
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_glimmer_cape",--
            "item_guardian_greaves",--
            "item_force_staff",--
            sUtilityItem,--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_aghanims_shard",
            "item_moon_shard",
            "item_ultimate_scepter_2",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
}

return X