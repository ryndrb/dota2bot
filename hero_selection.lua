local X = {}
local sSelectHero = "npc_dota_hero_zuus"
local fLastSlectTime, fLastRand = -100, 0
local nDelayTime = nil
local nHumanCount = 0
local sBanList = {}
local tSelectPoolList = {}
local tLaneAssignList = {}

local bUserMode = false
local bLaneAssignActive = true
local bLineupReserve = false

require(GetScriptDirectory()..'/API/api_global')

local synergy = require( GetScriptDirectory()..'/FunLib/aba_synergy' )
local matchups = require( GetScriptDirectory()..'/Buff/script/matchups_data' )
local U    = require( GetScriptDirectory()..'/FunLib/lua_util' )
local N    = require( GetScriptDirectory()..'/FunLib/bot_names' )
local Role = require( GetScriptDirectory()..'/FunLib/aba_role' )
local Chat = require( GetScriptDirectory()..'/FunLib/aba_chat' )
local HeroSet = {}
														-- role bias	                    -- bot "quality"
local sHeroList = {										-- pos    1,   2,   3,   4,   5
	{name = 'npc_dota_hero_abaddon', 					role = {100, 100, 100, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_abyssal_underlord', 			role = {  0,   0, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_alchemist', 					role = {100,  90,  95,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_ancient_apparition', 		role = {  0,   0,   0,  95, 100},	quality = 1.2 },
	{name = 'npc_dota_hero_antimage', 					role = {100,   0,  85,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_arc_warden', 				role = {100, 100,   0,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_axe',	 					role = {  0, 100, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_bane', 						role = {  0,  80,   0, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_batrider', 					role = {  0,  90,  85, 100, 100},	quality = 1.0 },
	{name = 'npc_dota_hero_beastmaster', 				role = { 90, 100, 100,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_bloodseeker', 				role = {100,  95,  90,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_bounty_hunter', 				role = { 80, 100,  95, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_brewmaster', 				role = {  0,   0, 100,   0,   0},	quality = 1.1 },
	{name = 'npc_dota_hero_bristleback', 				role = { 95,  85, 100,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_broodmother', 				role = { 90,  95, 100,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_centaur', 					role = {  0,  85, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_chaos_knight', 				role = {100,  80,  90,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_chen', 						role = {  0,   0,   0,   0, 100},	quality = 1.0 },
	{name = 'npc_dota_hero_clinkz', 					role = {100, 100,   0,  85,  80},	quality = 1.2 },
	{name = 'npc_dota_hero_crystal_maiden', 			role = {  0,  80,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_dark_seer', 					role = {  0,   0, 100,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_dark_willow', 				role = {  0,   0,   0, 100,  80},	quality = 0.8 },
	{name = 'npc_dota_hero_dawnbreaker', 				role = { 85,  85, 100, 100,  90},	quality = 1.3 },
	{name = 'npc_dota_hero_dazzle', 					role = {  0,  95,   0, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_death_prophet', 				role = {  0, 100, 100, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_disruptor', 					role = {  0,   0,   0, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_doom_bringer', 				role = { 90,  95, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_dragon_knight', 				role = {100, 100,  90,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_drow_ranger', 				role = {100,  80,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_earth_spirit', 				role = {  0, 100,  90, 100,  85},	quality = 1.4 },
	{name = 'npc_dota_hero_earthshaker', 				role = {  0, 100,  90, 100,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_elder_titan', 				role = {  0,   0,  80,  90, 100},	quality = 0.7 },
	{name = 'npc_dota_hero_ember_spirit', 				role = { 95, 100,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_enchantress', 				role = {  0,  80,  90,  90, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_enigma', 					role = {  0,   0,  90,  90, 100},	quality = 1.0 },
	{name = 'npc_dota_hero_faceless_void', 				role = {100,   0,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_furion', 					role = {100, 100,  90,  85, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_grimstroke', 				role = {  0,   0,   0, 100, 100},	quality = 1.2 },
	{name = 'npc_dota_hero_gyrocopter', 				role = {100,  90,   0,  95,  90},	quality = 1.4 },
	{name = 'npc_dota_hero_hoodwink', 					role = {  0,  80,   0, 100,  85},	quality = 0.8 },
	{name = 'npc_dota_hero_huskar', 					role = { 90, 100,  95,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_invoker', 					role = {  0, 100,   0,  85,  80},	quality = 1.2 },
	{name = 'npc_dota_hero_jakiro', 					role = {  0,  85,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_juggernaut', 				role = {100,   0,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_keeper_of_the_light', 		role = {  0,  90,   0, 100,  85},	quality = 1.0 },
	{name = 'npc_dota_hero_kez', 						role = { 85, 100,   0,   0,   0},	quality = 0.9 },
	{name = 'npc_dota_hero_kunkka', 					role = { 90, 100, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_largo', 						role = {  0,   0,   0, 100, 100},	quality = 1.0 },
	{name = 'npc_dota_hero_legion_commander', 			role = { 95,   0, 100,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_leshrac', 					role = {  0, 100,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_lich', 						role = {  0,   0,   0,  90, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_life_stealer', 				role = {100,   0,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_lina', 						role = {100, 100,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_lion', 						role = {  0,   0,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_lone_druid', 				role = { 85, 100,   0,   0,   0},	quality = 0.9 },
	{name = 'npc_dota_hero_luna', 						role = {100,   0,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_lycan', 						role = {100, 100, 100,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_magnataur', 					role = { 90,  85, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_marci',	 					role = { 80,  80,   0,   0,   0},	quality = 0.6 },
	{name = 'npc_dota_hero_mars', 						role = {  0, 100, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_medusa', 					role = {100,  90,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_meepo', 						role = {100, 100,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_mirana', 					role = { 90, 100,   0,  90,  95},	quality = 1.3 },
	{name = 'npc_dota_hero_monkey_king', 				role = {100, 100,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_morphling', 					role = {100,  95,   0,   0,   0},	quality = 1.1 },
	{name = 'npc_dota_hero_muerta', 				    role = {100,   0,   0,  90,  80},	quality = 1.2 },
	{name = 'npc_dota_hero_naga_siren', 				role = {100,   0,  90,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_necrolyte', 					role = {  0, 100, 100,  80,  80},	quality = 1.4 },
	{name = 'npc_dota_hero_nevermore', 					role = {100, 100,   0,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_night_stalker', 				role = {  0,   0, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_nyx_assassin', 				role = {  0,   0,   0, 100,  85},	quality = 1.3 },
	{name = 'npc_dota_hero_obsidian_destroyer', 		role = { 90, 100,   0,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_ogre_magi', 					role = {  0,  85, 100,  90, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_omniknight', 				role = {  0,  85, 100,  90, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_oracle', 					role = {  0,   0,   0,  95, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_pangolier', 					role = {  0, 100, 100,   0,   0},	quality = 0.9 },
	{name = 'npc_dota_hero_phantom_lancer', 			role = {100,   0,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_phantom_assassin', 			role = {100,   0,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_phoenix', 					role = {  0,  80,   0, 100, 100},	quality = 1.2 },
	{name = 'npc_dota_hero_primal_beast', 				role = {  0, 100,  90,   0,   0},	quality = 0.8 },
	{name = 'npc_dota_hero_puck', 						role = {  0, 100,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_pudge', 						role = {  0, 100,  90,  95,  85},	quality = 1.2 },
	{name = 'npc_dota_hero_pugna', 						role = {  0,  90,   0, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_queenofpain', 				role = {  0, 100,  90,  85,  80},	quality = 1.4 },
	{name = 'npc_dota_hero_rattletrap', 				role = {  0,   0,   0,  95, 100},	quality = 1.2 },
	{name = 'npc_dota_hero_razor', 						role = {100, 100, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_riki', 						role = {100, 100,   0,  85,  80},	quality = 1.3 },
	{name = 'npc_dota_hero_ringmaster', 				role = {  0,   0,   0, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_rubick', 					role = {  0,   0,   0, 100, 100},	quality = 1.0 },
	{name = 'npc_dota_hero_sand_king', 					role = {  0, 100, 100,  85,  80},	quality = 1.3 },
	{name = 'npc_dota_hero_shadow_demon', 				role = {  0,   0,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_shadow_shaman', 				role = {  0,   0,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_shredder', 					role = {  0, 100, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_silencer', 					role = { 85,  95,   0,  95, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_skeleton_king', 				role = {100,   0,  90,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_skywrath_mage', 				role = {  0,  90,   0, 100,  95},	quality = 1.4 },
	{name = 'npc_dota_hero_slardar', 					role = { 90,  95, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_slark', 						role = {100,   0,  85,   0,   0},	quality = 1.3 },
	{name = "npc_dota_hero_snapfire", 					role = {  0, 100,   0,  95, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_sniper', 					role = {100, 100,   0,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_spectre', 					role = {100,   0,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_spirit_breaker', 			role = {  0,  90,  95, 100,  90},	quality = 1.0 },
	{name = 'npc_dota_hero_storm_spirit', 				role = {  0, 100,   0,   0,   0},	quality = 1.2 },
	{name = 'npc_dota_hero_sven', 						role = {100,   0,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_techies', 					role = {  0,  85,   0, 100,  95},	quality = 1.3 },
	{name = 'npc_dota_hero_templar_assassin', 			role = {100, 100,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_terrorblade', 				role = {100,   0,   0,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_tidehunter', 				role = {  0,   0, 100,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_tinker', 					role = {  0,  90,   0,  95, 100},	quality = 0.9 },
	{name = 'npc_dota_hero_tiny', 						role = {100, 100,  90, 100,  95},	quality = 1.3 },
	{name = 'npc_dota_hero_treant', 					role = {  0,   0,  85,  95, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_troll_warlord', 				role = {100,   0,   0,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_tusk', 						role = {  0,  90,  85, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_undying', 					role = {  0,   0,  90,  85, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_ursa', 						role = {100,   0,  85,   0,   0},	quality = 1.3 },
	{name = 'npc_dota_hero_vengefulspirit', 			role = { 90,  90,   0,  95, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_venomancer', 				role = {  0,  90,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_viper', 						role = {  0, 100, 100,   0,   0},	quality = 1.4 },
	{name = 'npc_dota_hero_visage', 					role = {  0,  90, 100,  80,  80},	quality = 1.1 },
	{name = 'npc_dota_hero_void_spirit', 				role = {  0, 100,   0,   0,   0},	quality = 1.0 },
	{name = 'npc_dota_hero_warlock', 					role = {  0,   0,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_weaver', 					role = {100,   0,   0,  95,  95},	quality = 1.3 },
	{name = 'npc_dota_hero_windrunner', 				role = {100, 100,  85,  95,  90},	quality = 1.3 },
	{name = 'npc_dota_hero_winter_wyvern', 				role = {  0,  80,   0, 100, 100},	quality = 1.4 },
	{name = 'npc_dota_hero_wisp', 						role = {  0,   0,   0,  90, 100},	quality = 0.6 },
	{name = 'npc_dota_hero_witch_doctor', 				role = {  0,   0,   0, 100, 100},	quality = 1.3 },
	{name = 'npc_dota_hero_zuus', 						role = {  0, 100,   0, 100,  95},	quality = 1.4 },
}

local sWeakHeroes = {
	['npc_dota_hero_dark_willow'] = true,
	['npc_dota_hero_elder_titan'] = true,
	['npc_dota_hero_hoodwink'] = true,
	['npc_dota_hero_kez'] = true,
	['npc_dota_hero_marci'] = true,
	-- ['npc_dota_hero_muerta'] = true,
	['npc_dota_hero_primal_beast'] = true,
	['npc_dota_hero_wisp'] = true,
}

local function GetHeroList(pos)
	local heroList = {}

	for _, hero in pairs(sHeroList) do
		if hero and hero.role[pos] > 0 then
			table.insert(heroList, hero.name)
		end
	end

	return heroList
end

local sPos1List = GetHeroList(1)
local sPos2List = GetHeroList(2)
local sPos3List = GetHeroList(3)
local sPos4List = GetHeroList(4)
local sPos5List = GetHeroList(5)

tSelectPoolList = {
	[1] = sPos2List,
	[2] = sPos3List,
	[3] = sPos1List,
	[4] = sPos5List,
	[5] = sPos4List,
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

function X.GetNotRepeatHero( nTable, bExcludeWeak )

	if bExcludeWeak then
		for i = #nTable, 1, -1 do
			if sWeakHeroes[nTable[i]] == true then
				table.remove(nTable, i)
			end
		end
	end

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

local IDMap = {
	[1] = 3,
	[2] = 1,
	[3] = 2,
	[4] = 5,
	[5] = 4,
}

local tIDs = {}
local bShuffleSelection = false
function Think()
	if not bShuffleSelection and GetTeamPlayers(GetTeam()) ~= nil then
		local posWeights = { [1] = 1, [2] = 1.5, [3] = 3, [4] = 6, [5] = 6, }
		local available = { pos = {}, weights = {}}
		for i = 1, #GetTeamPlayers(GetTeam()) do
			for k, v in pairs(IDMap) do
				if i == v then
					available.pos[#available.pos + 1] = k
					available.weights[#available.weights + 1] = posWeights[k]
				end
			end
		end

		tIDs = U.shuffleWeighted(available.pos, available.weights)
		for i = 1, #tIDs do print(tIDs[i]) end
		print('====')
		bShuffleSelection = true
	end

	if #tIDs == 0 then return end

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
	if GetTeam() == TEAM_DIRE then
		-- Update Lane Roles
		local pRoles = {}
		local laneOrder = { LANE_MID, LANE_BOT, LANE_TOP, LANE_TOP, LANE_BOT }
		for i = 1, #nIDs do pRoles[nIDs[i]] = laneOrder[i] end

		local temp = {}
		for i, v in ipairs(nIDs) do temp[i] = v end

		table.sort(temp)

		for i = 1, #pRoles do
			if temp[i] then tLaneAssignList[i] = pRoles[temp[i]] end
		end
	end

	if nDelayTime == nil then nDelayTime = GameTime() fLastRand = RandomInt(12, 34) / 10 end
	if nDelayTime ~= nil and nDelayTime > GameTime() - fLastRand then return end

	local nOwnTeam = X.GetCurrentTeam(GetTeam())
	local nEnmTeam = X.GetCurrentTeam(GetOpposingTeam())
	local ownMax = #GetTeamPlayers(GetTeam())
	local enmMax = #GetTeamPlayers(GetOpposingTeam())
	local ownRatio = #nOwnTeam / ownMax
	local enmRatio = #nEnmTeam / enmMax

	if ownRatio <= enmRatio or (--[[GetGameMode() == 23 and]] ownMax ~= enmMax) then -- if imbalance, just pick; scoring below will be useless if not early picking though
		for i = 1, #nIDs do
			local botID = nIDs[IDMap[tIDs[i]]]
			local poolID = IDMap[tIDs[i]]
			local pos = tIDs[i]

			if IsPlayerBot(botID) and GetSelectedHeroName(botID) == '' then
				if (#nOwnTeam == 0 and #nEnmTeam == 0) then
					sSelectHero = X.GetNotRepeatHero(tSelectPoolList[poolID], true)
				else
					local hSelectionTable = {}
					local topHeroes = {}
					for _, sName in ipairs(tSelectPoolList[poolID]) do
						if not X.IsRepeatHero(sName) then
							local score = 0
							if not hSelectionTable[sName] then hSelectionTable[sName] = 0 end

							for m = 1, #nEnmTeam do
								if matchups[sName] and matchups[sName][nEnmTeam[m]] then
									local advantageScore = matchups[sName][nEnmTeam[m]] * -1
									score = score + math.sqrt(math.abs(advantageScore)) * (advantageScore >= 0 and 1 or -1) -- reduce usual suspects
								end
							end

							-- trim scuff lineups

							-- try
							local tagNudge = X.GetRoleTagsNudge(nOwnTeam, sName, pos)
							score = score + tagNudge

							-- amplifier
							local synergyMult = X.GetSynergyMult(nOwnTeam, sName, pos)
							score = score + math.abs(score) * (synergyMult - 1)

							for _, hero in pairs(sHeroList) do
								if hero.name == sName then
									-- favor (usually) good performing bots
									local quality = hero.quality or 1.0
									score = score + math.abs(score) * (quality - 1)

									-- reduce chances of multiple weak heroes getting picked
									if sWeakHeroes[hero.name] == true then
										local count = X.CountWeakHeroesSelected()
										if count.team > 0 then
											score = 0
										else
											score = score * (1 - Min(count.total / 2, 1))
										end
									end

									if score > 0 then score = score * (hero.role[pos] / 100) end
									break
								end
							end

							if score > 0 then
								table.insert(topHeroes, {name = sName, score = score})
							end
						end
					end

					table.sort(topHeroes, function (a, b) return a.score > b.score end)

					-- print
					print('=====')
					for q = 1, #topHeroes do
						print(q, tonumber(string.format("%.3f", topHeroes[q].score)), topHeroes[q].name)
					end
					print('=====')

					sSelectHero = X.GetNotRepeatHero(tSelectPoolList[poolID], true)

					-- 'fuzz'
					if #topHeroes >= 1 then
						local total = 0
						for j = 1, #topHeroes do total = total + topHeroes[j].score end

						local pAccum = 0
						local pRoll = (RandomInt(0, 100) / 100)
						for j = 1, #topHeroes do
							if topHeroes[j].score >= 0 and not X.IsRepeatHero(topHeroes[j].name) then
								pAccum = pAccum + (topHeroes[j].score / total)
								if pRoll <= pAccum then
									sSelectHero = topHeroes[j].name
									break
								end
							end
						end
					end
				end

				SelectHero(botID, sSelectHero)
				local sTeam = GetTeam() == TEAM_RADIANT and 'RADIANT' or 'DIRE'
				print('^^^ team: ' .. sTeam .. ' ^^^ ' .. tostring('pos: ' .. pos) .. ' ^^^ ' ..
					  #tSelectPoolList[3] .. ' ' .. #tSelectPoolList[1] .. ' ' .. #tSelectPoolList[2] .. ' ' .. #tSelectPoolList[5] .. ' ' .. #tSelectPoolList[4] .. ' ^^^'
				)

				if Role["bLobbyGame"] == false then Role["bLobbyGame"] = true end
				fLastSlectTime = GameTime()
				fLastRand = RandomInt( 8, 28 )/10
				break
			end
		end
	end
end

function X.GetCurrentTeam(nTeam)
	local nHeroList = {}
	for _, id in pairs(GetTeamPlayers(nTeam)) do
		local hName = GetSelectedHeroName(id)
		if hName ~= nil and hName ~= '' then
			table.insert(nHeroList, hName)
		end
	end

	return nHeroList
end

function X.CountWeakHeroesSelected()
	local count = {total = 0, team = 0, opponent = 0}
	for _, id in pairs(GetTeamPlayers(GetTeam())) do
		local sHeroName = GetSelectedHeroName(id)
		if sHeroName ~= nil then
			for _, hero in pairs(sHeroList) do
				if hero.name and sWeakHeroes[hero.name] == true then
					if hero.name == sHeroName then
						count.team = count.team + 1
					end
				end
			end
		end
	end
	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		local sHeroName = GetSelectedHeroName(id)
		if sHeroName ~= nil then
			for _, hero in pairs(sHeroList) do
				if hero.name and sWeakHeroes[hero.name] == true then
					if hero.name == sHeroName then
						count.opponent = count.opponent + 1
					end
				end
			end
		end
	end

	count.total = count.team + count.opponent

	return count
end

function X.GetSynergyMult(nOwnTeam, sName, pos)
	local synergyMult = 1
	for m = 1, #nOwnTeam do
		local syn = synergy['synergy']
		if syn and syn[sName] then
			local sTeammate = nOwnTeam[m]
			local teammate = syn[sName][sTeammate]
			if teammate then
				local synergyBlock = pos <= 3 and teammate.oCore or teammate.oSupp
				if synergyBlock then
					local function teammatePos(name)
						for j, id in pairs(GetTeamPlayers(GetTeam())) do
							local hName = GetSelectedHeroName(id)
							if hName ~= nil and hName == name then
								return ({ [1] = 2, [2] = 3, [3] = 1, [4] = 5, [5] = 4 })[j]
							end
						end
						return nil
					end

					local isCoreTeammate = teammatePos(sTeammate) <= 3
					synergyMult = isCoreTeammate and synergyBlock.iCore or synergyBlock.iSupp
				end
			end
		end
	end

	return synergyMult
end

function X.GetRoleTagsNudge(nOwnTeam, sName, pos)
	-- local function GetTeamRoleProfile(team)
	-- 	local profile = {
	-- 		carry = 0, disabler = 0, durable = 0, escape = 0,
	-- 		initiator = 0, jungler = 0, nuker = 0, support = 0, pusher = 0
	-- 	}
	-- 	for _, heroName in ipairs(team) do
	-- 		if Role['hero_roles'][heroName] then
	-- 			for role, val in pairs(Role['hero_roles'][heroName]) do
	-- 				profile[role] = profile[role] + val
	-- 			end
	-- 		end
	-- 	end
	-- 	return profile
	-- end

	local compNudge = 0

	if Role['hero_roles'] and Role['hero_roles'][sName] then
		local scale = 0.75
		local hRoles = Role['hero_roles'][sName]
		-- local teamRoles = GetTeamRoleProfile(nOwnTeam)

		-- mult: how much this role matters
		local roleImportance = {
			['carry']     = { mult = 1.0 },
			['disabler']  = { mult = 1.4 },
			['durable']   = { mult = 1.3 },
			['escape']    = { mult = 0.5 },
			['initiator'] = { mult = 1.0 },
			['jungler']   = { mult = 0.3 },
			['nuker']     = { mult = 1.1 },
			['support']   = { mult = 0.8 },
			['pusher']    = { mult = 0.8 },
		}

		-- pos-to-role relevance: which roles matter when picking for this pos
		local posRoleRelevance = {
			[1] = { carry = 1.2, disabler = 0.5, durable = 0.5, escape = 0.5, initiator = 0.6, jungler = 0.4, nuker = 0.8, support = 0.2, pusher = 0.8 },
			[2] = { carry = 0.7, disabler = 0.6, durable = 0.3, escape = 0.6, initiator = 0.8, jungler = 0.2, nuker = 1.0, support = 0.3, pusher = 0.5 },
			[3] = { carry = 0.4, disabler = 0.8, durable = 1.0, escape = 0.5, initiator = 0.9, jungler = 0.2, nuker = 0.5, support = 0.5, pusher = 0.4 },
			[4] = { carry = 0.2, disabler = 1.3, durable = 0.3, escape = 0.4, initiator = 0.6, jungler = 0.1, nuker = 0.6, support = 1.3, pusher = 0.3 },
			[5] = { carry = 0.2, disabler = 1.3, durable = 0.3, escape = 0.4, initiator = 0.5, jungler = 0.1, nuker = 0.6, support = 1.3, pusher = 0.3 },
		}

        for role, cfg in pairs(roleImportance) do
            local heroVal = hRoles[role] or 0
            local posRel  = (posRoleRelevance[pos] and posRoleRelevance[pos][role]) or 0.0
			compNudge = compNudge + heroVal * scale * cfg.mult * posRel
        end

		local tagSum = 0
		for _, v in pairs(Role['hero_roles'][sName]) do tagSum = tagSum + v end
		compNudge = compNudge^2 / Max(tagSum, 1)
	end

	return compNudge
end

function GetBotNames()
	return N.GetBotNames()
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