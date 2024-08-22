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

require(GetScriptDirectory()..'/API/api_global')

local MU   = require( GetScriptDirectory()..'/FunLib/aba_matchups' )
local U    = require( GetScriptDirectory()..'/FunLib/lua_util' )
local N    = require( GetScriptDirectory()..'/FunLib/bot_names' )
local Role = require( GetScriptDirectory()..'/FunLib/aba_role' )
local Chat = require( GetScriptDirectory()..'/FunLib/aba_chat' )
local HeroSet = {}

local sHeroList = {										-- pos  1, 2, 3, 4, 5
	{name = 'npc_dota_hero_abaddon', 					role = {10, 5, 80, 5, 100}},
	{name = 'npc_dota_hero_abyssal_underlord', 			role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_alchemist', 					role = {100, 100, 30, 0, 0}},
	{name = 'npc_dota_hero_ancient_apparition', 		role = {0, 5, 0, 5, 100}},
	{name = 'npc_dota_hero_antimage', 					role = {100, 0, 25, 0, 0}},
	{name = 'npc_dota_hero_arc_warden', 				role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_axe',	 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_bane', 						role = {0, 10, 0, 100, 100}},
	{name = 'npc_dota_hero_batrider', 					role = {0, 25, 5, 100, 100}},
	{name = 'npc_dota_hero_beastmaster', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_bloodseeker', 				role = {100, 25, 50, 0, 0}},
	{name = 'npc_dota_hero_bounty_hunter', 				role = {0, 50, 10, 100, 5}},
	{name = 'npc_dota_hero_brewmaster', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_bristleback', 				role = {80, 80, 100, 0, 0}},
	{name = 'npc_dota_hero_broodmother', 				role = {100, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_centaur', 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_chaos_knight', 				role = {100, 0, 50, 0, 0}},
	{name = 'npc_dota_hero_chen', 						role = {0, 0, 0, 0, 100}},
	{name = 'npc_dota_hero_clinkz', 					role = {100, 50, 0, 50, 5}},
	{name = 'npc_dota_hero_crystal_maiden', 			role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_dark_seer', 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_dark_willow', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_dawnbreaker', 				role = {0, 5, 100, 50, 50}},
	{name = 'npc_dota_hero_dazzle', 					role = {0, 50, 0, 100, 100}},
	{name = 'npc_dota_hero_disruptor', 					role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_death_prophet', 				role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_doom_bringer', 				role = {0, 80, 100, 0, 0}},
	{name = 'npc_dota_hero_dragon_knight', 				role = {50, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_drow_ranger', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_earth_spirit', 				role = {0, 100, 50, 100, 0}},
	{name = 'npc_dota_hero_earthshaker', 				role = {0, 50, 100, 100, 0}},
	{name = 'npc_dota_hero_elder_titan', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_ember_spirit', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_enchantress', 				role = {0, 0, 100, 0, 100}},
	{name = 'npc_dota_hero_enigma', 					role = {0, 0, 50, 80, 100}},
	{name = 'npc_dota_hero_faceless_void', 				role = {0, 0, 0, 0, 0}},-- DISABLED; facet bug.
	{name = 'npc_dota_hero_furion', 					role = {100, 0, 100, 5, 100}},
	{name = 'npc_dota_hero_grimstroke', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_gyrocopter', 				role = {100, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_hoodwink', 					role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_huskar', 					role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_invoker', 					role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_jakiro', 					role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_juggernaut', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_keeper_of_the_light', 		role = {0, 50, 0, 100, 25}},
	{name = 'npc_dota_hero_kunkka', 					role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_legion_commander', 			role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_leshrac', 					role = {0, 100, 50, 0, 0}},
	{name = 'npc_dota_hero_lich', 						role = {0, 0, 0, 5, 100}},
	{name = 'npc_dota_hero_life_stealer', 				role = {0, 0, 0, 0, 0}},-- DISABLED; facet bug.
	{name = 'npc_dota_hero_lina', 						role = {100, 100, 0, 100, 5}},
	{name = 'npc_dota_hero_lion', 						role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_lone_druid', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_luna', 						role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_lycan', 						role = {50, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_magnataur', 					role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_marci',	 					role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_mars', 						role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_medusa', 					role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_meepo', 						role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_mirana', 					role = {0, 0, 0, 50, 100}},
	{name = 'npc_dota_hero_monkey_king', 				role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_morphling', 					role = {100, 5, 0, 0, 0}},
	{name = 'npc_dota_hero_muerta', 				    role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_naga_siren', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_necrolyte', 					role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_nevermore', 					role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_night_stalker', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_nyx_assassin', 				role = {0, 0, 0, 100, 5}},
	{name = 'npc_dota_hero_obsidian_destroyer', 		role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_ogre_magi', 					role = {0, 80, 100, 30, 100}},
	{name = 'npc_dota_hero_omniknight', 				role = {0, 5, 100, 0, 100}},
	{name = 'npc_dota_hero_oracle', 					role = {0, 0, 0, 5, 100}},
	{name = 'npc_dota_hero_pangolier', 					role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_phantom_lancer', 			role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_phantom_assassin', 			role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_phoenix', 					role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_primal_beast', 				role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_puck', 						role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_pudge', 						role = {0, 100, 100, 5, 5}},
	{name = 'npc_dota_hero_pugna', 						role = {0, 50, 0, 100, 100}},
	{name = 'npc_dota_hero_queenofpain', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_rattletrap', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_razor', 						role = {100, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_riki', 						role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_rubick', 					role = {0, 50, 0, 100, 100}},
	{name = 'npc_dota_hero_sand_king', 					role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_shadow_demon', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_shadow_shaman', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_shredder', 					role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_silencer', 					role = {0, 80, 0, 100, 100}},
	{name = 'npc_dota_hero_skeleton_king', 				role = {100, 0, 40, 0, 0}},
	{name = 'npc_dota_hero_skywrath_mage', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_slardar', 					role = {0, 50, 100, 0, 0}},
	{name = 'npc_dota_hero_slark', 						role = {100, 0, 0, 0, 0}},
	{name = "npc_dota_hero_snapfire", 					role = {0, 100, 0, 100, 100}},
	{name = 'npc_dota_hero_sniper', 					role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_spectre', 					role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_spirit_breaker', 			role = {0, 5, 100, 100, 0}},
	{name = 'npc_dota_hero_storm_spirit', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_sven', 						role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_techies', 					role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_terrorblade', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_templar_assassin', 			role = {100, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_tidehunter', 				role = {0, 0, 100, 0, 0}},
	{name = 'npc_dota_hero_tinker', 					role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_tiny', 						role = {100, 100, 50, 100, 5}},
	{name = 'npc_dota_hero_treant', 					role = {0, 0, 0, 80, 100}},
	{name = 'npc_dota_hero_troll_warlord', 				role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_tusk', 						role = {0, 5, 100, 100, 5}},
	{name = 'npc_dota_hero_undying', 					role = {0, 0, 0, 0, 100}},
	{name = 'npc_dota_hero_ursa', 						role = {100, 0, 0, 0, 0}},
	{name = 'npc_dota_hero_vengefulspirit', 			role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_venomancer', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_viper', 						role = {0, 100, 100, 0, 0}},
	{name = 'npc_dota_hero_visage', 					role = {0, 50, 100, 0, 0}},
	{name = 'npc_dota_hero_void_spirit', 				role = {0, 100, 0, 0, 0}},
	{name = 'npc_dota_hero_warlock', 					role = {0, 0, 0, 50, 100}},
	{name = 'npc_dota_hero_weaver', 					role = {100, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_windrunner', 				role = {80, 100, 5, 70, 5}},
	{name = 'npc_dota_hero_winter_wyvern', 				role = {0, 5, 25, 100, 100}},
	{name = 'npc_dota_hero_wisp', 						role = {0, 0, 0, 0, 0}},--nil
	{name = 'npc_dota_hero_witch_doctor', 				role = {0, 0, 0, 100, 100}},
	{name = 'npc_dota_hero_zuus', 						role = {0, 100, 0, 50, 25}},
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