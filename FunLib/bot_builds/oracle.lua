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
            ['t25'] = {10, 0},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
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
        [1] = {1,3,3,2,3,6,3,2,2,2,1,6,1,1},
    },
    ['pos_5'] = {
        [1] = {1,3,3,2,3,6,3,2,2,2,1,6,1,1},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {},
    ['pos_3'] = {},
    ['pos_4'] = {
        [1] = {
            "item_tango",
            "item_double_enchanted_mango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_ring_of_basilius",
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_aether_lens",--
            "item_glimmer_cape",--
            "item_force_staff",--
            "item_aghanims_shard",
            "item_boots_of_bearing",--
            "item_ultimate_scepter",
            "item_refresher",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_tango",
            "item_double_enchanted_mango",
            "item_double_branches",
            "item_blood_grenade",
        
            "item_ring_of_basilius",
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_aether_lens",--
            "item_glimmer_cape",--
            "item_force_staff",--
            "item_aghanims_shard",
            "item_guardian_greaves",--
            "item_ultimate_scepter",
            "item_refresher",--
            "item_sheepstick",--
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
            "item_ring_of_basilius",
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_magic_wand",
        }
    },
}

return X