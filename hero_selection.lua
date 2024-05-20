local X = {}
local sSelectHero = "npc_dota_hero_zuus"
local fLastSlectTime, fLastRand = -100, 0
local nDelayTime = nil
local nHumanCount = 0
local sBanList = {}
local sSelectList = {}
local tSelectPoolList = {}
local tLaneAssignList = {}

local bUserMode = false
local bLaneAssignActive = true
local bLineupReserve = false

local nDireFirstLaneType = 1
if pcall( require,  'game/bot_dire_first_lane_type' )
then
	nDireFirstLaneType = require( 'game/bot_dire_first_lane_type' )
end

local Role = require( GetScriptDirectory()..'/FunLib/aba_role' )
local Chat = require( GetScriptDirectory()..'/FunLib/aba_chat' )
local HeroSet = {}

local sPos1List = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_antimage",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_lina",
	"npc_dota_hero_luna",
	"npc_dota_hero_lycan",
	-- "npc_dota_hero_marci", -- DOESN'T WORK
	"npc_dota_hero_medusa",
	"npc_dota_hero_meepo",
	"npc_dota_hero_morphling",
	-- "npc_dota_hero_muerta", -- DOESN'T WORK
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_razor",
	"npc_dota_hero_riki",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_slark",
	"npc_dota_hero_spectre",
	"npc_dota_hero_sniper",
	"npc_dota_hero_sven",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_ursa",
	"npc_dota_hero_weaver",
	"npc_dota_hero_windrunner",
}

local sPos2List = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_bane",
	"npc_dota_hero_batrider",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_bounty_hunter",
	'npc_dota_hero_bristleback',
	"npc_dota_hero_broodmother",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_earth_spirit",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_huskar",
	"npc_dota_hero_invoker",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_lina",
	-- "npc_dota_hero_lone_druid", -- DOESN'T WORK
	"npc_dota_hero_lycan",
	"npc_dota_hero_meepo",
	"npc_dota_hero_monkey_king",
	"npc_dota_hero_morphling",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_pangolier",
	-- "npc_dota_hero_primal_beast", -- DOESN'T WORK
	"npc_dota_hero_puck",
	"npc_dota_hero_pugna",
	"npc_dota_hero_pudge",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_razor",
	"npc_dota_hero_riki",
	"npc_dota_hero_silencer",
	"npc_dota_hero_slardar",
	"npc_dota_hero_snapfire",
	"npc_dota_hero_sniper",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_storm_spirit",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_tinker",
	"npc_dota_hero_tiny",
	"npc_dota_hero_tusk",
	"npc_dota_hero_viper",
	"npc_dota_hero_visage",
	"npc_dota_hero_void_spirit",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_zuus",
}

local sPos3List = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_abyssal_underlord",
	"npc_dota_hero_axe",
	"npc_dota_hero_batrider",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_brewmaster",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_centaur",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_dark_seer",
	"npc_dota_hero_dawnbreaker",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_earthshaker",
	'npc_dota_hero_enchantress',
	"npc_dota_hero_enigma",
	"npc_dota_hero_furion",
	"npc_dota_hero_huskar",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_lycan",
	"npc_dota_hero_magnataur",
	-- "npc_dota_hero_marci", -- DOESN'T WORK
	"npc_dota_hero_mars",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_pangolier",
	-- "npc_dota_hero_primal_beast", -- DOESN'T WORK
	"npc_dota_hero_pudge",
	"npc_dota_hero_razor",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_shredder",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_slardar",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_tiny",
	"npc_dota_hero_tusk",
	"npc_dota_hero_viper",
	"npc_dota_hero_visage",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_winter_wyvern",
}

local sPos4List = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_bane",
	"npc_dota_hero_batrider",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_chen",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_crystal_maiden",
	-- "npc_dota_hero_dark_willow", -- DOESN'T WORK
	"npc_dota_hero_dawnbreaker",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_earthshaker",
	'npc_dota_hero_earth_spirit',
	-- "npc_dota_hero_elder_titan", -- DOESN'T WORK
	"npc_dota_hero_enchantress",
	"npc_dota_hero_enigma",
	"npc_dota_hero_furion",
	"npc_dota_hero_grimstroke",
	"npc_dota_hero_gyrocopter",
	-- "npc_dota_hero_hoodwink", -- DOESN'T WORK
	"npc_dota_hero_jakiro",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_lich",
	"npc_dota_hero_lina",
	"npc_dota_hero_lion",
	"npc_dota_hero_mirana",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_oracle",
	"npc_dota_hero_phoenix",
	"npc_dota_hero_pudge",
	"npc_dota_hero_pugna",
	"npc_dota_hero_rattletrap",
	"npc_dota_hero_rubick",
	"npc_dota_hero_shadow_demon",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_silencer",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_snapfire",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_techies",
	"npc_dota_hero_tiny",
	"npc_dota_hero_treant",
	"npc_dota_hero_tusk",
	"npc_dota_hero_undying",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_warlock",
	"npc_dota_hero_weaver",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_zuus",
}

local sPos5List = {
	"npc_dota_hero_abaddon",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_bane",
	"npc_dota_hero_batrider",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_chen",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_crystal_maiden",
	-- "npc_dota_hero_dark_willow", -- DOESN'T WORK
	"npc_dota_hero_dawnbreaker",
	"npc_dota_hero_dazzle",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_earth_spirit",
	-- "npc_dota_hero_elder_titan", -- DOESN'T WORK
	"npc_dota_hero_enchantress",
	"npc_dota_hero_enigma",
	"npc_dota_hero_furion",
	"npc_dota_hero_grimstroke",
	"npc_dota_hero_gyrocopter",
	-- "npc_dota_hero_hoodwink", -- DOESN'T WORK
	"npc_dota_hero_jakiro",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_lich",
	"npc_dota_hero_lina",
	"npc_dota_hero_lion",
	"npc_dota_hero_mirana",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_oracle",
	"npc_dota_hero_phoenix",
	"npc_dota_hero_pudge",
	"npc_dota_hero_pugna",
	"npc_dota_hero_rattletrap",
	"npc_dota_hero_rubick",
	"npc_dota_hero_shadow_demon",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_silencer",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_snapfire",
	"npc_dota_hero_spirit_breaker",
	"npc_dota_hero_techies",
	"npc_dota_hero_tiny",
	"npc_dota_hero_treant",
	"npc_dota_hero_tusk",
	"npc_dota_hero_undying",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_warlock",
	"npc_dota_hero_weaver",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_zuus",
}

-- Role weight for now, heroes synergy later
-- Might take DotaBuff or others role weights once other pos are added
function X.GetAdjustedPool(heroList, pos)
	local sTempList = {}
	local sHeroList = {										-- pos  1, 2, 3, 4, 5
		{name = 'npc_dota_hero_abaddon', 					role = {5, 5, 25, 15, 50}},
		{name = 'npc_dota_hero_abyssal_underlord', 			role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_alchemist', 					role = {50, 30, 20, 0, 0}},
		{name = 'npc_dota_hero_ancient_apparition', 		role = {0, 5, 0, 25, 70}},
		{name = 'npc_dota_hero_antimage', 					role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_arc_warden', 				role = {20, 80, 0, 0, 0}},
		{name = 'npc_dota_hero_axe',	 					role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_bane', 						role = {0, 15, 0, 25, 60}},
		{name = 'npc_dota_hero_batrider', 					role = {0, 10, 10, 50, 30}},
		{name = 'npc_dota_hero_beastmaster', 				role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_bloodseeker', 				role = {65, 20, 15, 0, 0}},
		{name = 'npc_dota_hero_bounty_hunter', 				role = {0, 25, 10, 50, 15}},
		{name = 'npc_dota_hero_brewmaster', 				role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_bristleback', 				role = {10, 10, 80, 0, 0}},
		{name = 'npc_dota_hero_broodmother', 				role = {0, 80, 20, 0, 0}},
		{name = 'npc_dota_hero_centaur', 					role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_chaos_knight', 				role = {60, 0, 40, 0, 0}},
		{name = 'npc_dota_hero_chen', 						role = {0, 0, 0, 0, 100}},
		{name = 'npc_dota_hero_clinkz', 					role = {45, 30, 0, 20, 5}},
		{name = 'npc_dota_hero_crystal_maiden', 			role = {0, 0, 0, 15, 85}},
		{name = 'npc_dota_hero_dark_seer', 					role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_dark_willow', 				role = {0, 0, 0, 100, 10}},--nil
		{name = 'npc_dota_hero_dawnbreaker', 				role = {0, 5, 70, 15, 10}},
		{name = 'npc_dota_hero_dazzle', 					role = {0, 20, 0, 20, 60}},
		{name = 'npc_dota_hero_disruptor', 					role = {0, 0, 0, 25, 75}},
		{name = 'npc_dota_hero_death_prophet', 				role = {0, 50, 50, 0, 0}},
		{name = 'npc_dota_hero_doom_bringer', 				role = {0, 10, 90, 0, 0}},
		{name = 'npc_dota_hero_dragon_knight', 				role = {5, 35, 60, 0, 0}},
		{name = 'npc_dota_hero_drow_ranger', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_earth_spirit', 				role = {0, 45, 10, 40, 5}},
		{name = 'npc_dota_hero_earthshaker', 				role = {0, 15, 25, 50, 10}},
		{name = 'npc_dota_hero_elder_titan', 				role = {0, 0, 0, 100, 100}},--nil
		{name = 'npc_dota_hero_ember_spirit', 				role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_enchantress', 				role = {0, 0, 10, 30, 60}},
		{name = 'npc_dota_hero_enigma', 					role = {0, 0, 60, 25, 15}},
		{name = 'npc_dota_hero_faceless_void', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_furion', 					role = {0, 0, 10, 60, 30}},
		{name = 'npc_dota_hero_grimstroke', 				role = {0, 0, 0, 45, 55}},
		{name = 'npc_dota_hero_gyrocopter', 				role = {50, 0, 0, 30, 20}},
		{name = 'npc_dota_hero_hoodwink', 					role = {0, 0, 0, 100, 20}},--nil
		{name = 'npc_dota_hero_huskar', 					role = {0, 90, 10, 0, 0}},
		{name = 'npc_dota_hero_invoker', 					role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_jakiro', 					role = {0, 0, 0, 30, 70}},
		{name = 'npc_dota_hero_juggernaut', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_keeper_of_the_light', 		role = {0, 75, 0, 20, 5}},
		{name = 'npc_dota_hero_kunkka', 					role = {0, 40, 60, 0, 0}},
		{name = 'npc_dota_hero_legion_commander', 			role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_leshrac', 					role = {0, 90, 10, 0, 0}},
		{name = 'npc_dota_hero_lich', 						role = {0, 0, 0, 20, 80}},
		{name = 'npc_dota_hero_life_stealer', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_lina', 						role = {5, 75, 0, 15, 5}},
		{name = 'npc_dota_hero_lion', 						role = {0, 0, 0, 35, 65}},
		{name = 'npc_dota_hero_lone_druid', 				role = {50, 100, 50, 0, 0}},--nil
		{name = 'npc_dota_hero_luna', 						role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_lycan', 						role = {5, 25, 70, 0, 0}},
		{name = 'npc_dota_hero_magnataur', 					role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_marci',	 					role = {50, 0, 100, 0, 0}},--nil
		{name = 'npc_dota_hero_mars', 						role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_medusa', 					role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_meepo', 						role = {20, 80, 0, 0, 0}},
		{name = 'npc_dota_hero_mirana', 					role = {0, 0, 0, 60, 40}},
		{name = 'npc_dota_hero_morphling', 					role = {95, 5, 0, 0, 0}},
		{name = 'npc_dota_hero_monkey_king', 				role = {70, 30, 0, 0, 0}},
		{name = 'npc_dota_hero_naga_siren', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_necrolyte', 					role = {0, 70, 30, 0, 0}},
		{name = 'npc_dota_hero_nevermore', 					role = {35, 65, 0, 0, 0}},
		{name = 'npc_dota_hero_night_stalker', 				role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_nyx_assassin', 				role = {0, 0, 0, 85, 15}},
		{name = 'npc_dota_hero_obsidian_destroyer', 		role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_ogre_magi', 					role = {0, 5, 15, 30, 50}},
		{name = 'npc_dota_hero_omniknight', 				role = {0, 15, 75, 5, 5}},
		{name = 'npc_dota_hero_oracle', 					role = {0, 0, 0, 20, 80}},
		{name = 'npc_dota_hero_pangolier', 					role = {0, 80, 20, 0, 0}},
		{name = 'npc_dota_hero_phantom_lancer', 			role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_phantom_assassin', 			role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_phoenix', 					role = {0, 0, 0, 50, 50}},
		{name = 'npc_dota_hero_primal_beast', 				role = {0, 100, 100, 0, 0}},--nil
		{name = 'npc_dota_hero_puck', 						role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_pudge', 						role = {0, 20, 25, 35, 20}},
		{name = 'npc_dota_hero_pugna', 						role = {0, 20, 0, 45, 35}},
		{name = 'npc_dota_hero_queenofpain', 				role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_rattletrap', 				role = {0, 0, 0, 55, 45}},
		{name = 'npc_dota_hero_razor', 						role = {30, 20, 50, 0, 0}},
		{name = 'npc_dota_hero_riki', 						role = {65, 35, 0, 0, 0}},
		{name = 'npc_dota_hero_rubick', 					role = {0, 0, 0, 70, 30}},
		{name = 'npc_dota_hero_sand_king', 					role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_shadow_demon', 				role = {0, 0, 0, 45, 55}},
		{name = 'npc_dota_hero_shadow_shaman', 				role = {0, 0, 0, 35, 65}},
		{name = 'npc_dota_hero_shredder', 					role = {0, 40, 60, 0, 0}},
		{name = 'npc_dota_hero_silencer', 					role = {0, 10, 0, 35, 55}},
		{name = 'npc_dota_hero_skeleton_king', 				role = {100, 0, 50, 0, 0}},
		{name = 'npc_dota_hero_skywrath_mage', 				role = {0, 0, 0, 70, 30}},
		{name = 'npc_dota_hero_slardar', 					role = {0, 10, 90, 0, 0}},
		{name = 'npc_dota_hero_slark', 						role = {100, 0, 0, 0, 0}},
		{name = "npc_dota_hero_snapfire", 					role = {0, 20, 0, 50, 30}},
		{name = 'npc_dota_hero_sniper', 					role = {25, 75, 0, 0, 0}},
		{name = 'npc_dota_hero_spectre', 					role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_spirit_breaker', 			role = {0, 10, 35, 50, 5}},
		{name = 'npc_dota_hero_storm_spirit', 				role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_sven', 						role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_techies', 					role = {0, 0, 0, 60, 40}},
		{name = 'npc_dota_hero_terrorblade', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_templar_assassin', 			role = {45, 55, 0, 0, 0}},
		{name = 'npc_dota_hero_tidehunter', 				role = {0, 0, 100, 0, 0}},
		{name = 'npc_dota_hero_tinker', 					role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_tiny', 						role = {0, 25, 15, 55, 5}},
		{name = 'npc_dota_hero_treant', 					role = {0, 0, 0, 20, 80}},
		{name = 'npc_dota_hero_troll_warlord', 				role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_tusk', 						role = {0, 10, 15, 55, 20}},
		{name = 'npc_dota_hero_undying', 					role = {0, 0, 0, 25, 75}},
		{name = 'npc_dota_hero_ursa', 						role = {100, 0, 0, 0, 0}},
		{name = 'npc_dota_hero_vengefulspirit', 			role = {0, 0, 0, 35, 65}},
		{name = 'npc_dota_hero_venomancer', 				role = {0, 0, 0, 35, 65}},
		{name = 'npc_dota_hero_viper', 						role = {0, 60, 40, 0, 0}},
		{name = 'npc_dota_hero_visage', 					role = {0, 50, 50, 0, 0}},
		{name = 'npc_dota_hero_void_spirit', 				role = {0, 100, 0, 0, 0}},
		{name = 'npc_dota_hero_warlock', 					role = {0, 0, 0, 25, 75}},
		{name = 'npc_dota_hero_weaver', 					role = {70, 0, 10, 15, 5}},
		{name = 'npc_dota_hero_windrunner', 				role = {15, 30, 30, 20, 5}},
		{name = 'npc_dota_hero_winter_wyvern', 				role = {0, 15, 25, 30, 30}},
		{name = 'npc_dota_hero_wisp', 						role = {0, 0, 0, 50, 100}},
		{name = 'npc_dota_hero_witch_doctor', 				role = {0, 0, 0, 30, 70}},
		{name = 'npc_dota_hero_zuus', 						role = {0, 80, 0, 15, 5}},
	}

	for i = 1, #heroList
	do
		for _, hero in pairs(sHeroList)
		do
			if  hero.name == heroList[i]
			and hero.role[pos] >= RandomInt(0, 100)
			then
				table.insert(sTempList, hero.name)
			end
		end
	end

	if #sTempList == 0
	then
		table.insert(sTempList, heroList[RandomInt(1, #heroList)])
	end

	return sTempList
end

sPos1List = X.GetAdjustedPool(sPos1List, 1)
sPos2List = X.GetAdjustedPool(sPos2List, 2)
sPos3List = X.GetAdjustedPool(sPos3List, 3)
sPos4List = X.GetAdjustedPool(sPos4List, 4)
sPos5List = X.GetAdjustedPool(sPos5List, 5)

tSelectPoolList = {
	[1] = sPos2List,
	[2] = sPos3List,
	[3] = sPos1List,
	[4] = sPos5List,
	[5] = sPos4List,
}

sSelectList = {
	[1] = tSelectPoolList[1][RandomInt( 1, #tSelectPoolList[1] )],
	[2] = tSelectPoolList[2][RandomInt( 1, #tSelectPoolList[2] )],
	[3] = tSelectPoolList[3][RandomInt( 1, #tSelectPoolList[3] )],
	[4] = tSelectPoolList[4][RandomInt( 1, #tSelectPoolList[4] )],
	[5] = tSelectPoolList[5][RandomInt( 1, #tSelectPoolList[5] )],
}

if GetTeam() == TEAM_RADIANT
then
	local nRadiantLane = {
							[1] = LANE_MID,
							[2] = LANE_TOP,
							[3] = LANE_BOT,
							[4] = LANE_BOT,
							[5] = LANE_TOP,
						}

	tLaneAssignList = nRadiantLane

else
	local nDireLane = {
						[1] = LANE_MID,
						[2] = LANE_BOT,
						[3] = LANE_TOP,
						[4] = LANE_TOP,
						[5] = LANE_BOT,
					  }				

	tLaneAssignList = nDireLane
end

if nDireFirstLaneType == 2 and GetTeam() == TEAM_DIRE
then
	sSelectList[1], sSelectList[2] = sSelectList[2], sSelectList[1]
	tSelectPoolList[1], tSelectPoolList[2] = tSelectPoolList[2], tSelectPoolList[1]
	tLaneAssignList[1], tLaneAssignList[2] = tLaneAssignList[2], tLaneAssignList[1]
end

if nDireFirstLaneType == 3 and GetTeam() == TEAM_DIRE
then
	sSelectList[1], sSelectList[3] = sSelectList[3], sSelectList[1]
	tSelectPoolList[1], tSelectPoolList[3] = tSelectPoolList[3], tSelectPoolList[1]
	tLaneAssignList[1], tLaneAssignList[3] = tLaneAssignList[3], tLaneAssignList[1]
end

function X.GetMoveTable( nTable )

	local nLenth = #nTable
	local temp = nTable[nLenth]

	table.remove( nTable, nLenth )
	table.insert( nTable, 1, temp )

	return nTable

end

function X.IsExistInTable( sString, sStringList )

	for _, sTemp in pairs( sStringList )
	do
		if sString == sTemp then return true end
	end

	return false
end

function X.IsHumanNotReady( nTeam )

	if GameTime() > 20 or bLineupReserve then return false end

	local humanCount, readyCount = 0, 0
	local nIDs = GetTeamPlayers( nTeam )
	for i, id in pairs( nIDs )
	do
        if not IsPlayerBot( id )
		then
			humanCount = humanCount + 1
			if GetSelectedHeroName( id ) ~= ""
			then
				readyCount = readyCount + 1
			end
		end
    end

	if( readyCount >= humanCount )
	then
		return false
	end

	return true
end

function X.GetNotRepeatHero( nTable )

	local sHero = nTable[1]
	local maxCount = #nTable
	local nRand = 0
	local bRepeated = false

	for count = 1, maxCount
	do
		nRand = RandomInt( 1, #nTable )
		sHero = nTable[nRand]
		bRepeated = false
		for id = 0, 20
		do
			if ( IsTeamPlayer( id ) and GetSelectedHeroName( id ) == sHero )
				or ( IsCMBannedHero( sHero ) )
				or ( X.IsBanByChat( sHero ) )
			then
				bRepeated = true
				table.remove( nTable, nRand )
				break
			end
		end
		if not bRepeated then break end
	end

	return sHero
end

function X.IsRepeatHero( sHero )

	for id = 0, 20
	do
		if ( IsTeamPlayer( id ) and GetSelectedHeroName( id ) == sHero )
			or ( IsCMBannedHero( sHero ) )
			or ( X.IsBanByChat( sHero ) )
		then
			return true
		end
	end

	return false
end

if bUserMode and HeroSet['JinYongAI'] ~= nil
then
	sBanList = Chat.GetHeroSelectList( HeroSet['JinYongAI'] )
end

function X.SetChatHeroBan( sChatText )
	sBanList[#sBanList + 1] = string.lower( sChatText )
end

function X.IsBanByChat( sHero )

	for i = 1, #sBanList
	do
		if sBanList[i] ~= nil
		   and string.find( sHero, sBanList[i] )
		then
			return true
		end
	end

	return false
end

local TIWinners =
{
	-- Winners
	{--ti1
		"Na'Vi.Dendi",
		"Na'Vi.XBOCT",
		"Na'Vi.Artsyle",
		"Na'Vi.LighTofHeaveN",
		"Na'Vi.Puppey",
	},
	{--ti2
		"iG.Ferrari_430",
		"iG.YYF",
		"iG.Zhou",
		"iG.Faith",
		"iG.ChuaN",
	},
	{--ti3
		"Alliance.s4",
		"Alliance.AdmiralBulldog",
		"Alliance.Loda",
		"Alliance.Akke",
		"Alliance.EGM",
	},
	{--ti4
		"Newbee.Mu",
		"Newbee.xiao8",
		"Newbee.Hao",
		"Newbee.SanSheng",
		"Newbee.Banana",
	},
	{--ti5
		"EG.SumaiL",
		"EG.UNiVeRsE",
		"EG.Fear",
		"EG.ppd",
		"EG.Aui_2000",
	},
	{--ti6
		"Wings.bLink",
		"Wings.Faith_bian",
		"Wings.shadow",
		"Wings.iceice",
		"Wings.y`",
	},
	{--ti7
		"Liquid.Miracle-",
		"Liquid.MinD_ContRoL",
		"Liquid.MATUMBAMAN",
		"Liquid.KurokY",
		"Liquid.Gh",
	},
	{--ti8,9
		"OG.Topson",
		"OG.Ceb",
		"OG.ana",
		"OG.N0tail",
		"OG.JerAx",
	},
	{--ti10
		"TSpirit.TORONTOTOKYO",
		"TSpirit.Collapse",
		"TSpirit.Yatoro",
		"TSpirit.Miposhka",
		"TSpirit.Mira",
	},
	{--ti11
		"Tundra.Nine",
		"Tundra.33",
		"Tundra.skiter",
		"Tundra.Sneyking",
		"Tundra.Saksa",
	},
	{--ti12
		"TSpirit.Larl",
		"TSpirit.Collapse",
		"TSpirit.Yatoro雨",
		"TSpirit.Miposhka",
		"TSpirit.Mira",
	},
}

local TIRunnerUps =
{
-- Runner-Ups
	{--ti1
		"EHOME.QQQ",
		"EHOME.X!!",
		"EHOME.820",
		"EHOME.SJQ",
		"EHOME.LaNm",
	},
	{--ti2
		"Na'Vi.Dendi",
		"Na'Vi.LighTofHeaveN",
		"Na'Vi.XBOCT",
		"Na'Vi.ARS-ART",
		"Na'Vi.Puppey",
	},
	{--ti3
		"Na'Vi.Dendi",
		"Na'Vi.Funn1k",
		"Na'Vi.XBOCT",
		"Na'Vi.KuroKy",
		"Na'Vi.Puppey",
	},
	{--ti4
		"VG.Super",
		"VG.rOtk",
		"VG.Sylar",
		"VG.fy",
		"VG.Fenrir",
	},
	{--ti5
		"CDEC.Shiki",
		"CDEC.Xz",
		"CDEC.Agressif",
		"CDEC.Q",
		"CDEC.Garder",
	},
	{--ti6
		"DC.w33",
		"DC.Moo",
		"DC.Resolut1on",
		"DC.MiSeRy",
		"DC.Saksa",
	},
	{--ti7
		"Newbee.Sccc",
		"Newbee.kpii",
		"Newbee.Moogy",
		"Newbee.Faith",
		"Newbee.Kaka",
	},
	{--ti8
		"PSG.LGD.Somnus` M",
		"PSG.LGD.Chalice",
		"PSG.LGD.Ame",
		"PSG.LGD.xNova",
		"PSG.LGD.fy",
	},
	{--ti9
		"Liquid.w33",
		"Liquid.MinD_ContRoL",
		"Liquid.Miracle-",
		"Liquid.KuroKy",
		"Liquid.Gh",
	},
	{--ti10
		"PSG.LGD.NothingToSay",
		"PSG.LGD.Faith_bian",
		"PSG.LGD.Ame",
		"PSG.LGD.y`",
		"PSG.LGD.XinQ",
	},
	{--ti11
		"Secret.Nisha",
		"Secret.Resolut1on",
		"Secret.Crystallis",
		"Secret.Puppey",
		"Secret.Zayac",
	},
	{--ti12
		"GG.Quinn",
		"GG.Ace",
		"GG.dyrachyo",
		"GG.Seleri",
		"GG.tOfu",
	},
}

function X.GetRandomNameList( sStarList )
	local sNameList = {sStarList[1]}
	table.remove( sStarList, 1 )

	for i = 1, 4
	do
	    local nRand = RandomInt( 1, #sStarList )
		table.insert( sNameList, sStarList[nRand] )
		table.remove( sStarList, nRand )
	end

	return sNameList
end

function Think()
	if GetGameState() == GAME_STATE_HERO_SELECTION then
		InstallChatCallback( function ( tChat ) X.SetChatHeroBan( tChat.string ) end )
	end

	if ( GameTime() < 3.0 and not bLineupReserve )
	   or fLastSlectTime > GameTime() - fLastRand
	   or X.IsHumanNotReady( GetTeam() )
	   or X.IsHumanNotReady( GetOpposingTeam() )
	then
		if GetGameMode() ~= 23 then return end
	end

	-- init IDs for Dire
	local nIDs = GetTeamPlayers(GetTeam())
	if GetTeam() == TEAM_DIRE
	then
		local sHuman = {}
		for _, id in pairs(GetTeamPlayers(GetTeam()))
		do
			if not IsPlayerBot(id)
			then
				table.insert(sHuman, id)
			end
		end

		if #sHuman > 0
		then
			local nBotIDs = {5, 6, 7, 8, 9}
			nIDs = {}

			for i = 1, #nBotIDs do table.insert(nIDs, nBotIDs[i]) end

			-- Map it directly
			for i = 1, #sHuman
			do
				for j = 1, 5
				do
					if sHuman[i] + 5 == nBotIDs[j]
					then
						nIDs[j] = sHuman[i]
					end
				end
			end

			-- "Shift" > 4 to the right
			for i = #nIDs, 1, -1
			do
				local hCount = 0
				if nIDs[i] > 4
				then
					for j = 1, #nIDs
					do
						if  nIDs[j + i] ~= nil
						and nIDs[j + i] < 5
						then
							hCount = hCount + 1
						end
					end

					nIDs[i] = nIDs[i] + hCount
				end
			end

			-- Update Lane Roles
			local pRoles = {
				[nIDs[1]] = LANE_MID,
				[nIDs[2]] = LANE_BOT,
				[nIDs[3]] = LANE_TOP,
				[nIDs[4]] = LANE_TOP,
				[nIDs[5]] = LANE_BOT,
			}

			local temp = {}
			for i, v in ipairs(nIDs) do temp[i] = v end

			table.sort(temp)

			tLaneAssignList = {
				[1] = pRoles[temp[1]],
				[2] = pRoles[temp[2]],
				[3] = pRoles[temp[3]],
				[4] = pRoles[temp[4]],
				[5] = pRoles[temp[5]],
			}
		end
	end

	if nDelayTime == nil then nDelayTime = GameTime() fLastRand = RandomInt( 12, 34 )/10 end
	if nDelayTime ~= nil and nDelayTime > GameTime() - fLastRand then return end

	for i, id in pairs( nIDs )
	do
		if IsPlayerBot( id ) and GetSelectedHeroName( id ) == ""
		then
			if X.IsRepeatHero( sSelectList[i] ) 
				or ( nHumanCount == 0
					 and RandomInt( 1, 99 ) <= 75)
			then
				sSelectHero = X.GetNotRepeatHero( tSelectPoolList[i] )
			else
				sSelectHero = sSelectList[i]
			end

			SelectHero( id, sSelectHero )
			if Role["bLobbyGame"] == false then Role["bLobbyGame"] = true end

			fLastSlectTime = GameTime()
			fLastRand = RandomInt( 8, 28 )/10
			break
		end
	end
end

function GetBotNames()
	return GetTeam() == TEAM_RADIANT and TIWinners[RandomInt(1, #TIWinners)] or TIRunnerUps[RandomInt(1, #TIRunnerUps)]
end

local bPvNLaneAssignDone = false
function UpdateLaneAssignments()

	if DotaTime() > 0
		and nHumanCount == 0
		and Role.IsPvNMode()
		and not bLaneAssignActive
		and not bPvNLaneAssignDone
	then
		if RandomInt( 1, 8 ) > 4 then tLaneAssignList[4] = LANE_MID else tLaneAssignList[5] = LANE_MID end
		bPvNLaneAssignDone = true
	end

	return tLaneAssignList
end