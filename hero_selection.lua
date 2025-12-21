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

local matchups = require( GetScriptDirectory()..'/Buff/script/matchups_data' )
local U    = require( GetScriptDirectory()..'/FunLib/lua_util' )
local N    = require( GetScriptDirectory()..'/FunLib/bot_names' )
local Role = require( GetScriptDirectory()..'/FunLib/aba_role' )
local Chat = require( GetScriptDirectory()..'/FunLib/aba_chat' )
local HeroSet = {}
														-- role bias	
local sHeroList = {										-- pos    1,   2,   3,   4,   5
	{name = 'npc_dota_hero_abaddon', 					role = {100, 100, 100, 100, 100},	weak = false},
	{name = 'npc_dota_hero_abyssal_underlord', 			role = {  0,   0, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_alchemist', 					role = {100,  90,  95,   0,   0},	weak = false},
	{name = 'npc_dota_hero_ancient_apparition', 		role = {  0,   0,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_antimage', 					role = {100,   0,  85,   0,   0},	weak = false},
	{name = 'npc_dota_hero_arc_warden', 				role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_axe',	 					role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_bane', 						role = {  0,  80,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_batrider', 					role = {  0,  90,  85, 100, 100},	weak = false},
	{name = 'npc_dota_hero_beastmaster', 				role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_bloodseeker', 				role = {100,  95,  90,   0,   0},	weak = false},
	{name = 'npc_dota_hero_bounty_hunter', 				role = { 80, 100,  95, 100, 100},	weak = false},
	{name = 'npc_dota_hero_brewmaster', 				role = {  0,   0, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_bristleback', 				role = { 95,  85, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_broodmother', 				role = { 90,  95, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_centaur', 					role = {  0,  85, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_chaos_knight', 				role = {100,  80,  90,   0,   0},	weak = false},
	{name = 'npc_dota_hero_chen', 						role = {  0,   0,   0,   0, 100},	weak = false},
	{name = 'npc_dota_hero_clinkz', 					role = {100, 100,   0,  85,  80},	weak = false},
	{name = 'npc_dota_hero_crystal_maiden', 			role = {  0,  80,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_dark_seer', 					role = {  0,   0, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_dark_willow', 				role = {  0,   0,   0, 100,  80},	weak = true },
	{name = 'npc_dota_hero_dawnbreaker', 				role = { 85,  85, 100, 100,  90},	weak = false},
	{name = 'npc_dota_hero_dazzle', 					role = {  0,  95,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_disruptor', 					role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_death_prophet', 				role = {  0, 100, 100, 100, 100},	weak = false},
	{name = 'npc_dota_hero_doom_bringer', 				role = { 90,  95, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_dragon_knight', 				role = {100, 100,  90,   0,   0},	weak = false},
	{name = 'npc_dota_hero_drow_ranger', 				role = {100,  80,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_earth_spirit', 				role = {  0, 100,  90, 100,  85},	weak = false},
	{name = 'npc_dota_hero_earthshaker', 				role = {  0, 100,  90, 100,   0},	weak = false},
	{name = 'npc_dota_hero_elder_titan', 				role = {  0,   0,  80,  90, 100},	weak = true },
	{name = 'npc_dota_hero_ember_spirit', 				role = { 95, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_enchantress', 				role = {  0,  80,  90,  90, 100},	weak = false},
	{name = 'npc_dota_hero_enigma', 					role = {  0,   0,  90,  90, 100},	weak = false},
	{name = 'npc_dota_hero_faceless_void', 				role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_furion', 					role = {100, 100,  90,  85, 100},	weak = false},
	{name = 'npc_dota_hero_grimstroke', 				role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_gyrocopter', 				role = {100,  90,   0,  95,  90},	weak = false},
	{name = 'npc_dota_hero_hoodwink', 					role = {  0,  80,   0, 100,  85},	weak = true },
	{name = 'npc_dota_hero_huskar', 					role = { 90, 100,  95,   0,   0},	weak = false},
	{name = 'npc_dota_hero_invoker', 					role = {  0, 100,   0,  85,  80},	weak = false},
	{name = 'npc_dota_hero_jakiro', 					role = {  0,  85,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_juggernaut', 				role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_keeper_of_the_light', 		role = {  0,  90,   0, 100,  85},	weak = false},
	{name = 'npc_dota_hero_kez', 						role = { 85, 100,   0,   0,   0},	weak = true },
	{name = 'npc_dota_hero_kunkka', 					role = { 90, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_largo', 						role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_legion_commander', 			role = { 95,   0, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_leshrac', 					role = {  0, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_lich', 						role = {  0,   0,   0,  90, 100},	weak = false},
	{name = 'npc_dota_hero_life_stealer', 				role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_lina', 						role = {100, 100,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_lion', 						role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_lone_druid', 				role = { 85, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_luna', 						role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_lycan', 						role = {100, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_magnataur', 					role = { 90,  85, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_marci',	 					role = { 80,  80,   0,   0,   0},	weak = true },
	{name = 'npc_dota_hero_mars', 						role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_medusa', 					role = {100,  90,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_meepo', 						role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_mirana', 					role = { 90, 100,   0,  90,  95},	weak = false},
	{name = 'npc_dota_hero_monkey_king', 				role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_morphling', 					role = {100,  95,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_muerta', 				    role = {100,   0,   0,   0,   0},	weak = true },
	{name = 'npc_dota_hero_naga_siren', 				role = {100,   0,  90,   0,   0},	weak = false},
	{name = 'npc_dota_hero_necrolyte', 					role = {  0, 100, 100,  80,  80},	weak = false},
	{name = 'npc_dota_hero_nevermore', 					role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_night_stalker', 				role = {  0,   0, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_nyx_assassin', 				role = {  0,   0,   0, 100,  85},	weak = false},
	{name = 'npc_dota_hero_obsidian_destroyer', 		role = {  0, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_ogre_magi', 					role = {  0,  85, 100,  90, 100},	weak = false},
	{name = 'npc_dota_hero_omniknight', 				role = {  0,  85, 100,  90, 100},	weak = false},
	{name = 'npc_dota_hero_oracle', 					role = {  0,   0,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_pangolier', 					role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_phantom_lancer', 			role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_phantom_assassin', 			role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_phoenix', 					role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_primal_beast', 				role = {  0, 100,  90,   0,   0},	weak = false},
	{name = 'npc_dota_hero_puck', 						role = {  0, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_pudge', 						role = {  0, 100,  90,  95,  85},	weak = false},
	{name = 'npc_dota_hero_pugna', 						role = {  0,  90,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_queenofpain', 				role = {  0, 100,  90,  85,  80},	weak = false},
	{name = 'npc_dota_hero_rattletrap', 				role = {  0,   0,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_razor', 						role = {100, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_riki', 						role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_ringmaster', 				role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_rubick', 					role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_sand_king', 					role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_shadow_demon', 				role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_shadow_shaman', 				role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_shredder', 					role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_silencer', 					role = { 85,  95,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_skeleton_king', 				role = {100,   0,  90,   0,   0},	weak = false},
	{name = 'npc_dota_hero_skywrath_mage', 				role = {  0,  90,   0, 100,  95},	weak = false},
	{name = 'npc_dota_hero_slardar', 					role = {  0,  95, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_slark', 						role = {100,   0,  85,   0,   0},	weak = false},
	{name = "npc_dota_hero_snapfire", 					role = {  0, 100,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_sniper', 					role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_spectre', 					role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_spirit_breaker', 			role = {  0,  90,  95, 100,  90},	weak = false},
	{name = 'npc_dota_hero_storm_spirit', 				role = {  0, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_sven', 						role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_techies', 					role = {  0,  85,   0, 100,  95},	weak = false},
	{name = 'npc_dota_hero_terrorblade', 				role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_templar_assassin', 			role = {100, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_tidehunter', 				role = {  0,   0, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_tinker', 					role = {  0,  90,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_tiny', 						role = {100, 100,  90, 100,  95},	weak = false},
	{name = 'npc_dota_hero_treant', 					role = {  0,   0,  85,  95, 100},	weak = false},
	{name = 'npc_dota_hero_troll_warlord', 				role = {100,   0,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_tusk', 						role = {  0,  90,  85, 100, 100},	weak = false},
	{name = 'npc_dota_hero_undying', 					role = {  0,   0,  90,  85, 100},	weak = false},
	{name = 'npc_dota_hero_ursa', 						role = {100,   0,  85,   0,   0},	weak = false},
	{name = 'npc_dota_hero_vengefulspirit', 			role = { 90,  90,   0,  95, 100},	weak = false},
	{name = 'npc_dota_hero_venomancer', 				role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_viper', 						role = {  0, 100, 100,   0,   0},	weak = false},
	{name = 'npc_dota_hero_visage', 					role = {  0,  90, 100,  80,  80},	weak = false},
	{name = 'npc_dota_hero_void_spirit', 				role = {  0, 100,   0,   0,   0},	weak = false},
	{name = 'npc_dota_hero_warlock', 					role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_weaver', 					role = {100,   0,   0,  95,  95},	weak = false},
	{name = 'npc_dota_hero_windrunner', 				role = {100, 100,  85,  95,  90},	weak = false},
	{name = 'npc_dota_hero_winter_wyvern', 				role = {  0,  80,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_wisp', 						role = {  0,   0,   0,  90, 100},	weak = true },
	{name = 'npc_dota_hero_witch_doctor', 				role = {  0,   0,   0, 100, 100},	weak = false},
	{name = 'npc_dota_hero_zuus', 						role = {  0, 100,   0, 100,  95},	weak = false},
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
				or ( sHero ~= "npc_dota_hero_ringmaster"
					and sHero ~= "npc_dota_hero_kez"
					and IsCMBannedHero( sHero ) )
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
			or ( sHero ~= "npc_dota_hero_ringmaster"
				and sHero ~= "npc_dota_hero_kez"
				and IsCMBannedHero( sHero ) )
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

local tIDs = U.shuffleWeighted({1,2,3,4,5}, {1,1.5,3,6,6})
print(tIDs[1],tIDs[2],tIDs[3],tIDs[4],tIDs[5], GetTeam())
print('====')
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

	if nDelayTime == nil then nDelayTime = GameTime() fLastRand = RandomInt(12, 34) / 10 end
	if nDelayTime ~= nil and nDelayTime > GameTime() - fLastRand then return end

	local nOwnTeam = X.GetCurrentTeam(GetTeam())
	local nEnmTeam = X.GetCurrentTeam(GetOpposingTeam())

	local IDMap = {
		[1] = 3,
		[2] = 1,
		[3] = 2,
		[4] = 5,
		[5] = 4,
	}

	if #nOwnTeam <= #nEnmTeam then
		for i = 1, #nIDs do
			local botID = nIDs[IDMap[tIDs[i]]]
			local poolID = IDMap[tIDs[i]]
			local pos = tIDs[i]

			if IsPlayerBot(botID) and GetSelectedHeroName(botID) == '' then
				if (#nOwnTeam == 0 and #nEnmTeam == 0) then
					sSelectHero = X.GetNotRepeatHero(tSelectPoolList[poolID])
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

							for _, hero in pairs(sHeroList) do
								if hero.name == sName then
									score = score * (hero.role[pos] / 100)

									-- reduce chances of multiple weak heroes getting picked
									if hero.weak then
										local count = X.CountWeakHeroesSelected()
										if count.team > 0 then
											score = 0
										else
											score = score * (1 - Min(count.total / 2, 1))
										end
									end
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

					sSelectHero = X.GetNotRepeatHero(tSelectPoolList[poolID])

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
				if hero.name and hero.weak then
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
				if hero.name and hero.weak then
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