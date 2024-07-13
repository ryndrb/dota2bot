local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_branches",
				"item_faerie_fire",
			
				"item_bottle",
				"item_magic_wand",
				"item_travel_boots",
				"item_blink",
				"item_black_king_bar",--
				"item_octarine_core",--
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_refresher",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_branches",
				"item_bottle",
				"item_magic_wand",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,3,3,3,2,6,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_gauntlets",
				"item_circlet",
				"item_double_branches",
			
				"item_bracer",
				"item_boots",
				"item_magic_wand",
				"item_wind_lace",
				"item_veil_of_discord",
				"item_blink",
				"item_black_king_bar",--
				"item_travel_boots",
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_refresher",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_circlet",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_blink",
				"item_force_staff",--
				"item_black_king_bar",--
				"item_boots_of_bearing",--
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_arcane_blink",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_magic_wand",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_circlet",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_blink",
				"item_force_staff",--
				"item_black_king_bar",--
				"item_guardian_greaves",--
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_arcane_blink",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_magic_wand",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

return X