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

local MU   = require( GetScriptDirectory()..'/FunLib/aba_matchups' )
local U    = require( GetScriptDirectory()..'/FunLib/lua_util' )
local Role = require( GetScriptDirectory()..'/FunLib/aba_role' )
local Chat = require( GetScriptDirectory()..'/FunLib/aba_chat' )
local HeroSet = {}

local sHeroList = {										-- pos  1, 2, 3, 4, 5
	{name = 'npc_dota_hero_abaddon', 					role = {5, 5, 25, 15, 50}},
	{name = 'npc_dota_hero_abyssal_underlord', 			role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_alchemist', 					role = {80, 10, 10, 0, 0}},
	{name = 'npc_dota_hero_ancient_apparition', 		role = {0, 5, 0, 25, 70}},
	{name = 'npc_dota_hero_antimage', 					role = {95, 0, 5, 0, 0}},
	{name = 'npc_dota_hero_arc_warden', 				role = {20, 80, 0, 0, 0}},
	{name = 'npc_dota_hero_axe',	 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_bane', 						role = {0, 10, 0, 30, 60}},
	{name = 'npc_dota_hero_batrider', 					role = {0, 10, 10, 50, 30}},
	{name = 'npc_dota_hero_beastmaster', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_bloodseeker', 				role = {65, 20, 15, 0, 0}},
	{name = 'npc_dota_hero_bounty_hunter', 				role = {0, 25, 10, 50, 15}},
	{name = 'npc_dota_hero_brewmaster', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_bristleback', 				role = {10, 5, 85, 0, 0}},
	{name = 'npc_dota_hero_broodmother', 				role = {0, 85, 15, 0, 0}},
	{name = 'npc_dota_hero_centaur', 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_chaos_knight', 				role = {70, 0, 30, 0, 0}},
	{name = 'npc_dota_hero_chen', 						role = {0, 0, 0, 0, 100}},
	{name = 'npc_dota_hero_clinkz', 					role = {60, 30, 0, 5, 5}},
	{name = 'npc_dota_hero_crystal_maiden', 			role = {0, 0, 0, 15, 85}},
	{name = 'npc_dota_hero_dark_seer', 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_dark_willow', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_dawnbreaker', 				role = {0, 5, 80, 5, 10}},
	{name = 'npc_dota_hero_dazzle', 					role = {0, 20, 0, 20, 60}},
	{name = 'npc_dota_hero_disruptor', 					role = {0, 0, 0, 25, 75}},
	{name = 'npc_dota_hero_death_prophet', 				role = {0, 50, 50, 0, 0}},
	{name = 'npc_dota_hero_doom_bringer', 				role = {0, 10, 90, 0, 0}},
	{name = 'npc_dota_hero_dragon_knight', 				role = {5, 35, 60, 0, 0}},
	{name = 'npc_dota_hero_drow_ranger', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_earth_spirit', 				role = {0, 45, 10, 40, 5}},
	{name = 'npc_dota_hero_earthshaker', 				role = {0, 5, 25, 60, 10}},
	{name = 'npc_dota_hero_elder_titan', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_ember_spirit', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_enchantress', 				role = {0, 0, 15, 5, 80}},
	{name = 'npc_dota_hero_enigma', 					role = {0, 0, 60, 25, 15}},
	{name = 'npc_dota_hero_faceless_void', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_furion', 					role = {25, 0, 25, 20, 30}},
	{name = 'npc_dota_hero_grimstroke', 				role = {0, 0, 0, 45, 55}},
	{name = 'npc_dota_hero_gyrocopter', 				role = {55, 0, 0, 25, 20}},
	{name = 'npc_dota_hero_hoodwink', 					role = {0, 0, 0, 0, 0}},--nil
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
	{name = 'npc_dota_hero_lion', 						role = {0, 0, 0, 65, 35}},
	{name = 'npc_dota_hero_lone_druid', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_luna', 						role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_lycan', 						role = {5, 25, 70, 0, 0}},
	{name = 'npc_dota_hero_magnataur', 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_marci',	 					role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_mars', 						role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_medusa', 					role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_meepo', 						role = {20, 80, 0, 0, 0}},
	{name = 'npc_dota_hero_mirana', 					role = {0, 0, 0, 40, 60}},
	{name = 'npc_dota_hero_monkey_king', 				role = {70, 30, 0, 0, 0}},
	{name = 'npc_dota_hero_morphling', 					role = {95, 5, 0, 0, 0}},
	{name = 'npc_dota_hero_muerta', 				    role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_naga_siren', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_necrolyte', 					role = {0, 70, 30, 0, 0}},
	{name = 'npc_dota_hero_nevermore', 					role = {35, 65, 0, 0, 0}},
	{name = 'npc_dota_hero_night_stalker', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_nyx_assassin', 				role = {0, 0, 0, 85, 15}},
	{name = 'npc_dota_hero_obsidian_destroyer', 		role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_ogre_magi', 					role = {0, 5, 15, 30, 50}},
	{name = 'npc_dota_hero_omniknight', 				role = {0, 15, 75, 5, 5}},
	{name = 'npc_dota_hero_oracle', 					role = {0, 0, 0, 5, 95}},
	{name = 'npc_dota_hero_pangolier', 					role = {0, 80, 20, 0, 0}},
	{name = 'npc_dota_hero_phantom_lancer', 			role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_phantom_assassin', 			role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_phoenix', 					role = {0, 0, 0, 50, 50}},
	{name = 'npc_dota_hero_primal_beast', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_puck', 						role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_pudge', 						role = {0, 40, 45, 10, 5}},
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
	{name = 'npc_dota_hero_skeleton_king', 				role = {80, 0, 20, 0, 0}},
	{name = 'npc_dota_hero_skywrath_mage', 				role = {0, 0, 0, 70, 30}},
	{name = 'npc_dota_hero_slardar', 					role = {0, 10, 90, 0, 0}},
	{name = 'npc_dota_hero_slark', 						role = {100, 0, 0, 0, 0}},
	{name = "npc_dota_hero_snapfire", 					role = {0, 20, 0, 50, 30}},
	{name = 'npc_dota_hero_sniper', 					role = {25, 75, 0, 0, 0}},
	{name = 'npc_dota_hero_spectre', 					role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_spirit_breaker', 			role = {0, 5, 35, 55, 5}},
	{name = 'npc_dota_hero_storm_spirit', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_sven', 						role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_techies', 					role = {0, 0, 0, 60, 40}},
	{name = 'npc_dota_hero_terrorblade', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_templar_assassin', 			role = {45, 55, 0, 0, 0}},
	{name = 'npc_dota_hero_tidehunter', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_tinker', 					role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_tiny', 						role = {15, 25, 5, 50, 5}},
	{name = 'npc_dota_hero_treant', 					role = {0, 0, 0, 20, 80}},
	{name = 'npc_dota_hero_troll_warlord', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_tusk', 						role = {0, 5, 20, 70, 5}},
	{name = 'npc_dota_hero_undying', 					role = {0, 0, 0, 25, 75}},
	{name = 'npc_dota_hero_ursa', 						role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_vengefulspirit', 			role = {0, 0, 0, 35, 65}},
	{name = 'npc_dota_hero_venomancer', 				role = {0, 0, 0, 35, 65}},
	{name = 'npc_dota_hero_viper', 						role = {0, 60, 40, 0, 0}},
	{name = 'npc_dota_hero_visage', 					role = {0, 50, 50, 0, 0}},
	{name = 'npc_dota_hero_void_spirit', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_warlock', 					role = {0, 0, 0, 25, 75}},
	{name = 'npc_dota_hero_weaver', 					role = {80, 0, 0, 15, 5}},
	{name = 'npc_dota_hero_windrunner', 				role = {15, 50, 5, 25, 5}},
	{name = 'npc_dota_hero_winter_wyvern', 				role = {0, 5, 25, 40, 30}},
	{name = 'npc_dota_hero_wisp', 						role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_witch_doctor', 				role = {0, 0, 0, 30, 70}},
	{name = 'npc_dota_hero_zuus', 						role = {0, 80, 0, 15, 5}},
}

local function GetHeroList(pos)
	local sTempList = {}

	for i = 1, #sHeroList
	do
		if sHeroList[i] ~= nil and sHeroList[i].role[pos] > 0
		then
			table.insert(sTempList, sHeroList[i].name)
		end
	end

	return sTempList
end

-- p(x)=(weight)*(1/#adjPoolList)
local function GetAdjustedPool(pos)
	local sTempList = {}

	local heroList = GetHeroList(pos)

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

local sPos1List = GetAdjustedPool(1)
local sPos2List = GetAdjustedPool(2)
local sPos3List = GetAdjustedPool(3)
local sPos4List = GetAdjustedPool(4)
local sPos5List = GetAdjustedPool(5)

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

	if nDelayTime == nil then nDelayTime = GameTime() fLastRand = RandomInt(12, 34) / 10 end
	if nDelayTime ~= nil and nDelayTime > GameTime() - fLastRand then return end

	local nOwnTeam = X.GetCurrentTeam(GetTeam())
	local nEnmTeam = X.GetCurrentTeam(GetOpposingTeam())

	-- If in Turbo, the game randomly picks remaining bots who's yet to pick their heroes if a human chooses their hero.
	-- So a human must always pick last in Turbo. <^ This isn't the case in All Pick.

	-- Alternate; Cores pick firsts
	if #nOwnTeam <= #nEnmTeam
	then
		for i, id in pairs(nIDs)
		do
			sSelectHero = X.GetNotRepeatHero(tSelectPoolList[i])
			if IsPlayerBot(id) and GetSelectedHeroName(id) == ""
			then
				local forCounter = RandomInt(1, 2) == 1 -- might change

				if #nOwnTeam == 0 and #nEnmTeam == 0
				then
					sSelectHero = X.GetNotRepeatHero(tSelectPoolList[i])
				else
					local didCounter = false
					local didExhaust = false

					if  forCounter
					and #X.GetCurrEnmCores(nEnmTeam) >= 1
					then
						-- Pick a random core in the current enemy comp to counter
						local nCurrEnmCores = X.GetCurrEnmCores(nEnmTeam)
						local nHeroToCounter = nCurrEnmCores[RandomInt(1, #nCurrEnmCores)]
						local sPoolList = U.deepCopy(tSelectPoolList[i])

						for j = 1, #tSelectPoolList[i], 1
						do
							local idx = RandomInt(1, #sPoolList)
							local heroName = sPoolList[idx]
							if  MU.IsCounter(heroName, nHeroToCounter) -- so it's not 'samey'; since bots don't really put pressure like a human would
							and not X.IsRepeatHero(heroName)
							then
								print(heroName, nHeroToCounter)
								didCounter = true
								sSelectHero = heroName
								break
							end

							table.remove(sPoolList, idx)
							if j == #tSelectPoolList[i] or #sPoolList == 0 then didExhaust = true end
						end
					else
						if not forCounter
						or (didExhaust and not didCounter)
						then
							local heroName = X.GetBestHeroFromPool(i, nOwnTeam)
							if heroName ~= nil
							then
								sSelectHero = heroName
							end
						end
					end
				end

				SelectHero(id, sSelectHero)
				if Role["bLobbyGame"] == false then Role["bLobbyGame"] = true end
				fLastSlectTime = GameTime()
				fLastRand = RandomInt( 8, 28 )/10
				break
			end
		end
	end
end

function X.GetBestHeroFromPool(i, nTeamList)
	local sBestHero = ''
	local nHeroes = {}

	for j = 1, #nTeamList
	do
		local hName = nTeamList[j].name
		for _, sName in pairs(tSelectPoolList[i])
		do
			if  (MU.IsSynergy(hName, sName) or MU.IsSynergy(sName, hName))
			and not X.IsRepeatHero(sName)
			then
				if nHeroes[sName] == nil then nHeroes[sName] = {} end
				if nHeroes[sName]['count'] == nil then nHeroes[sName]['count'] = 1 end
				nHeroes[sName]['count'] = nHeroes[sName]['count'] + 1
			end
		end
	end

	local c = -1
	for k1, v1 in pairs(nHeroes)
	do
		for k2, v2 in pairs(nHeroes[k1])
		do
			if not X.IsRepeatHero(k1)
			then
				if  v2 > 0 and c > 0 and v2 == c
				and RandomInt(1, 2) == 1
				then
					sBestHero = k1
				end

				if v2 > c
				then
					c = v2
					sBestHero = k1
				end
			end
		end
	end

	if sBestHero ~= ''
	then
		print('synergy ', sBestHero)
		return sBestHero
	else
		return X.GetNotRepeatHero(tSelectPoolList[i])
	end
end

function X.GetCurrEnmCores(nEnmTeam)
	local nCurrCores = {}
	for i = 1, #nEnmTeam
	do
		if nEnmTeam[i].pos >= 1 and nEnmTeam[i].pos <= 3
		then
			table.insert(nCurrCores, nEnmTeam[i].name)
		end
	end

	return nCurrCores
end

function X.GetCurrentTeam(nTeam)
	local nHeroList = {}
	for i, id in pairs(GetTeamPlayers(nTeam))
	do
		local hName = GetSelectedHeroName(id)
		if hName ~= nil and hName ~= ''
		then
			table.insert(nHeroList, {name=hName, pos=i}) -- since the script chooses cores first; might change in the future
		end
	end

	return nHeroList
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