local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
				[2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
	
				"item_magic_wand",
				"item_power_treads",
				"item_soul_ring",
				"item_radiance",--
				"item_blink",
				"item_black_king_bar",--
				"item_assault",--
				"item_basher",
				"item_swift_blink",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_travel_boots",
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
				"item_power_treads",
				"item_soul_ring",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
				[2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
	
				"item_bottle",
				"item_magic_wand",
				"item_phase_boots",
				"item_soul_ring",
				"item_radiance",--
				"item_blink",
				"item_manta",--
				"item_black_king_bar",--
				"item_basher",
				"item_swift_blink",--
				"item_aghanims_shard",
				"item_travel_boots",
				"item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_bottle",
				"item_quelling_blade",
				"item_magic_wand",
				"item_power_treads",
				"item_soul_ring",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
				[2] = {1,2,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
	
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_magic_wand",
				"item_radiance",--
				"item_blink",
				"item_manta",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				sUtilityItem,--
				"item_travel_boots",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_soul_ring",
				"item_magic_wand",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

return X