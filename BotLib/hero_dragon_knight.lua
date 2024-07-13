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
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
				[2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
				[3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_quelling_blade",
				"item_double_branches",
				"item_tango",
			
				"item_bracer",
				"item_power_treads",
				"item_magic_wand",
				"item_mage_slayer",--
				"item_manta",--
				"item_ultimate_scepter",
				"item_orchid",
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_greater_crit",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
				[2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
				[3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_bottle",
				"item_double_bracer",
				"item_boots",
				"item_magic_wand",
				"item_power_treads",
				"item_hand_of_midas",
				"item_blink",
				"item_manta",--
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_octarine_core",--
				"item_assault",--
				"item_travel_boots",
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bottle",
				"item_bracer",
				"item_magic_wand",
				"item_hand_of_midas",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
				[2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
				[3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_gauntlets",
				"item_circlet",
			
				"item_bracer",
				"item_boots",
				"item_magic_wand",
				"item_power_treads",
				"item_hand_of_midas",
				"item_blink",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_assault",--
				"item_octarine_core",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_travel_boots",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
			
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_hand_of_midas",
			},
        },
    },
    ['pos_4'] = {
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
    ['pos_5'] = {
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
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )


X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

return X