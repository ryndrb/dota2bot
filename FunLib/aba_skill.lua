----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
--- Refactor: 决明子 Email: dota2jmz@163.com 微博@Dota2_决明子
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1573671599
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1627071163
----------------------------------------------------------------------------------------------------


local X = {}


X['sAllyUnitAbilityIndex'] = {

		["bloodseeker_bloodrage"] = true,
		["omniknight_purification"] = true,
		["omniknight_repel"] = true,
		["medusa_mana_shield"] = true,
		["grimstroke_spirit_walk"] = true,
		["dazzle_shallow_grave"] = true,
		["dazzle_shadow_wave"] = true,
		["ogre_magi_bloodlust"] = true,
		["lich_frost_shield"] = true,

}


X['sProjectileAbilityIndex'] = {

		["chaos_knight_chaos_bolt"] = true,
		["grimstroke_ink_creature"] = true,
		["lich_chain_frost"] = true,
		["medusa_mystic_snake"] = true,
		["phantom_assassin_stifling_dagger"] = true,
		["phantom_lancer_spirit_lance"] = true,
		["skeleton_king_hellfire_blast"] = true,
		["skywrath_mage_arcane_bolt"] = true,
		["sven_storm_bolt"] = true,
		["vengefulspirit_magic_missile"] = true,
		["viper_viper_strike"] = true,
		["witch_doctor_paralyzing_cask"] = true,

}


X['sOnlyProjectileAbilityIndex'] = {

		["necrolyte_death_pulse"] = true,
		["arc_warden_spark_wraith"] = true,
		["tinker_heat_seeking_missile"] = true,
		["skywrath_mage_concussive_shot"] = true,
		["rattletrap_battery_assault"] = true,
		["queenofpain_scream_of_pain"] = true,

}


X['sStunProjectileAbilityIndex'] = {

		["chaos_knight_chaos_bolt"] = true,
		["skeleton_king_hellfire_blast"] = true,
		["sven_storm_bolt"] = true,
		["vengefulspirit_magic_missile"] = true,
		["witch_doctor_paralyzing_cask"] = true,
		["dragon_knight_dragon_tail"] = true,

}



function X.GetTalentList( bot )

	local sTalentList = {}
	for i = 0, 23
	do
		local hAbility = bot:GetAbilityInSlot( i )
		if hAbility ~= nil and hAbility:IsTalent()
		then
			table.insert( sTalentList, hAbility:GetName() )
		end
	end

	return sTalentList

end


function X.GetAbilityList( bot )

	local sAbilityList = {}
	for slot = 0, 6
	do
		local hAbility = bot:GetAbilityInSlot( slot )
		if hAbility ~= nil then
			table.insert( sAbilityList, bot:GetAbilityInSlot( slot ):GetName() )
		end
	end

	return sAbilityList

end


function X.GetRandomBuild( tBuildList )

	return tBuildList[RandomInt( 1, #tBuildList )]

end


function X.GetTalentBuild( tTalentTreeList )

	local nTalentBuildList = {
							[1] = ( tTalentTreeList['t10'][1] == 0 and 1 or 2 ),
							[2] = ( tTalentTreeList['t15'][1] == 0 and 3 or 4 ),
							[3] = ( tTalentTreeList['t20'][1] == 0 and 5 or 6 ),
							[4] = ( tTalentTreeList['t25'][1] == 0 and 7 or 8 ),
							[5] = ( tTalentTreeList['t10'][1] == 0 and 2 or 1 ),
							[6] = ( tTalentTreeList['t15'][1] == 0 and 4 or 3 ),
							[7] = ( tTalentTreeList['t20'][1] == 0 and 6 or 5 ),
							[8] = ( tTalentTreeList['t25'][1] == 0 and 8 or 7 ),
						  }

	return nTalentBuildList

end

function X.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )
	local sSkillList = {}
	local botName = GetBot():GetUnitName()
	local bMoreMeepoFacet = botName == 'npc_dota_hero_meepo' and true

	--[[
	7.40+ broke "ActionImmediate_LevelAbility"
	ability points are different server side; the distribution is also "wrong", except invoker
	~for most heroes:             (now)					 (before?)
					level  1-17 : 14 points (other 15)   16 points
					level 18-22 :  1 points				 2 points
					level 23-30 :  8 points      		 5 points
	
	will level talents last
	]]

	sSkillList = {
		[ 1] = {done = false, name = sAbilityList[nAbilityBuildList[1]]},
		[ 2] = {done = false, name = sAbilityList[nAbilityBuildList[2]]},
		[ 3] = {done = false, name = sAbilityList[nAbilityBuildList[3]]},
		[ 4] = {done = false, name = sAbilityList[nAbilityBuildList[4]]},
		[ 5] = {done = false, name = sAbilityList[nAbilityBuildList[5]]},
		[ 6] = {done = false, name = sAbilityList[nAbilityBuildList[6]]},
		[ 7] = {done = false, name = sAbilityList[nAbilityBuildList[7]]},
		[ 8] = {done = false, name = sAbilityList[nAbilityBuildList[8]]},
		[ 9] = {done = false, name = sAbilityList[nAbilityBuildList[9]]},
		[10] = {done = false, name = sAbilityList[nAbilityBuildList[10]]},
		[11] = {done = false, name = sAbilityList[nAbilityBuildList[12]]},
		[12] = {done = false, name = sAbilityList[nAbilityBuildList[11]]},
		[13] = {done = false, name = sAbilityList[nAbilityBuildList[13]]},
		[14] = {done = false, name = sAbilityList[nAbilityBuildList[14]]},
		[15] = {done = false, name = nil},
		[16] = {done = false, name = nil},
		[17] = {done = false, name = nil},
		[18] = {done = false, name = sAbilityList[nAbilityBuildList[15]]},
		[19] = {done = false, name = nil},
		[20] = {done = false, name = nil},
		[21] = {done = false, name = nil},
		[22] = {done = false, name = nil},
		[23] = {done = false, name = sTalentList[nTalentBuildList[1]]},
		[24] = {done = false, name = sTalentList[nTalentBuildList[2]]},
		[25] = {done = false, name = sTalentList[nTalentBuildList[3]]},
		[26] = {done = false, name = sTalentList[nTalentBuildList[4]]},
		[27] = {done = false, name = sTalentList[nTalentBuildList[5]]},
		[28] = {done = false, name = sTalentList[nTalentBuildList[6]]},
		[29] = {done = false, name = sTalentList[nTalentBuildList[7]]},
		[30] = {done = false, name = sTalentList[nTalentBuildList[8]]},
	}

	if botName == 'npc_dota_hero_lone_druid_bear' then
		sSkillList = {
			[10] = {done = false, name = sTalentList[nTalentBuildList[1]]},
			[15] = {done = false, name = sTalentList[nTalentBuildList[2]]},
			[20] = {done = false, name = sTalentList[nTalentBuildList[3]]},
			[25] = {done = false, name = sTalentList[nTalentBuildList[4]]},
			[27] = {done = false, name = sTalentList[nTalentBuildList[5]]},
			[28] = {done = false, name = sTalentList[nTalentBuildList[6]]},
			[29] = {done = false, name = sTalentList[nTalentBuildList[7]]},
			[30] = {done = false, name = sTalentList[nTalentBuildList[8]]},
		}
	end

	if botName == 'npc_dota_hero_invoker' then
		sSkillList = {
			[ 1] = {done = false, name = sAbilityList[nAbilityBuildList[1]]},
			[ 2] = {done = false, name = sAbilityList[nAbilityBuildList[2]]},
			[ 3] = {done = false, name = sAbilityList[nAbilityBuildList[3]]},
			[ 4] = {done = false, name = sAbilityList[nAbilityBuildList[4]]},
			[ 5] = {done = false, name = sAbilityList[nAbilityBuildList[5]]},
			[ 6] = {done = false, name = sAbilityList[nAbilityBuildList[6]]},
			[ 7] = {done = false, name = sAbilityList[nAbilityBuildList[7]]},
			[ 8] = {done = false, name = sAbilityList[nAbilityBuildList[8]]},
			[ 9] = {done = false, name = sAbilityList[nAbilityBuildList[9]]},
			[10] = {done = false, name = sAbilityList[nAbilityBuildList[10]]},
			[11] = {done = false, name = sAbilityList[nAbilityBuildList[11]]},
			[12] = {done = false, name = sAbilityList[nAbilityBuildList[12]]},
			[13] = {done = false, name = sAbilityList[nAbilityBuildList[13]]},
			[14] = {done = false, name = sAbilityList[nAbilityBuildList[14]]},
			[15] = {done = false, name = sAbilityList[nAbilityBuildList[15]]},
			[16] = {done = false, name = sAbilityList[nAbilityBuildList[16]]},
			[17] = {done = false, name = sAbilityList[nAbilityBuildList[17]]},
			[18] = {done = false, name = sAbilityList[nAbilityBuildList[18]]},
			[19] = {done = false, name = sAbilityList[nAbilityBuildList[19]]},
			[20] = {done = false, name = sAbilityList[nAbilityBuildList[20]]},
			[21] = {done = false, name = sAbilityList[nAbilityBuildList[21]]},
			[22] = {done = false, name = sTalentList[nTalentBuildList[1]]},
			[23] = {done = false, name = sTalentList[nTalentBuildList[2]]},
			[24] = {done = false, name = sTalentList[nTalentBuildList[3]]},
			[25] = {done = false, name = sTalentList[nTalentBuildList[4]]},
			[26] = {done = false, name = nil},
			[27] = {done = false, name = sTalentList[nTalentBuildList[5]]},
			[28] = {done = false, name = sTalentList[nTalentBuildList[6]]},
			[29] = {done = false, name = sTalentList[nTalentBuildList[7]]},
			[30] = {done = false, name = sTalentList[nTalentBuildList[8]]},
		}
	end

	if bMoreMeepoFacet then
		sSkillList = {
			[ 1] = {done = false, name = sAbilityList[nAbilityBuildList[1]]},
			[ 2] = {done = false, name = sAbilityList[nAbilityBuildList[2]]},
			[ 3] = {done = false, name = sAbilityList[nAbilityBuildList[3]]},
			[ 4] = {done = false, name = sAbilityList[nAbilityBuildList[4]]},
			[ 5] = {done = false, name = sAbilityList[nAbilityBuildList[5]]},
			[ 6] = {done = false, name = sAbilityList[nAbilityBuildList[6]]},
			[ 7] = {done = false, name = sAbilityList[nAbilityBuildList[7]]},
			[ 8] = {done = false, name = sAbilityList[nAbilityBuildList[8]]},
			[ 9] = {done = false, name = sAbilityList[nAbilityBuildList[9]]},
			[10] = {done = false, name = sAbilityList[nAbilityBuildList[10]]},
			[11] = {done = false, name = sAbilityList[nAbilityBuildList[11]]},
			[12] = {done = false, name = sAbilityList[nAbilityBuildList[12]]},
			[13] = {done = false, name = sAbilityList[nAbilityBuildList[13]]},
			[14] = {done = false, name = sAbilityList[nAbilityBuildList[14]]},
			[15] = {done = false, name = nil},
			[16] = {done = false, name = nil},
			[17] = {done = false, name = nil},
			[18] = {done = false, name = sAbilityList[nAbilityBuildList[15]]},
			[19] = {done = false, name = nil},
			[20] = {done = false, name = nil},
			[21] = {done = false, name = nil},
			[22] = {done = false, name = sTalentList[nTalentBuildList[1]]},
			[23] = {done = false, name = sTalentList[nTalentBuildList[2]]},
			[24] = {done = false, name = sAbilityList[nAbilityBuildList[16]]},
			[25] = {done = false, name = sTalentList[nTalentBuildList[3]]},
			[26] = {done = false, name = sTalentList[nTalentBuildList[4]]},
			[27] = {done = false, name = sTalentList[nTalentBuildList[5]]},
			[28] = {done = false, name = sTalentList[nTalentBuildList[6]]},
			[29] = {done = false, name = sTalentList[nTalentBuildList[7]]},
			[30] = {done = false, name = sTalentList[nTalentBuildList[8]]},
		}
	end

	if not bMoreMeepoFacet and #nAbilityBuildList == 16 then
		sSkillList = {
			[ 1] = {done = false, name = sAbilityList[nAbilityBuildList[1]]},
			[ 2] = {done = false, name = sAbilityList[nAbilityBuildList[2]]},
			[ 3] = {done = false, name = sAbilityList[nAbilityBuildList[3]]},
			[ 4] = {done = false, name = sAbilityList[nAbilityBuildList[4]]},
			[ 5] = {done = false, name = sAbilityList[nAbilityBuildList[5]]},
			[ 6] = {done = false, name = sAbilityList[nAbilityBuildList[6]]},
			[ 7] = {done = false, name = sAbilityList[nAbilityBuildList[7]]},
			[ 8] = {done = false, name = sAbilityList[nAbilityBuildList[8]]},
			[ 9] = {done = false, name = sAbilityList[nAbilityBuildList[9]]},
			[10] = {done = false, name = sAbilityList[nAbilityBuildList[10]]},
			[11] = {done = false, name = sAbilityList[nAbilityBuildList[12]]},
			[12] = {done = false, name = sAbilityList[nAbilityBuildList[11]]},
			[13] = {done = false, name = sAbilityList[nAbilityBuildList[13]]},
			[14] = {done = false, name = sAbilityList[nAbilityBuildList[14]]},
			[15] = {done = false, name = nil},
			[16] = {done = false, name = nil},
			[17] = {done = false, name = sAbilityList[nAbilityBuildList[15]]},
			[18] = {done = false, name = sAbilityList[nAbilityBuildList[16]]},
			[19] = {done = false, name = nil},
			[20] = {done = false, name = nil},
			[21] = {done = false, name = nil},
			[22] = {done = false, name = nil},
			[23] = {done = false, name = sTalentList[nTalentBuildList[1]]},
			[24] = {done = false, name = sTalentList[nTalentBuildList[2]]},
			[25] = {done = false, name = sTalentList[nTalentBuildList[3]]},
			[26] = {done = false, name = sTalentList[nTalentBuildList[4]]},
			[27] = {done = false, name = sTalentList[nTalentBuildList[5]]},
			[28] = {done = false, name = sTalentList[nTalentBuildList[6]]},
			[29] = {done = false, name = sTalentList[nTalentBuildList[7]]},
			[30] = {done = false, name = sTalentList[nTalentBuildList[8]]},
		}
	end

	return sSkillList
end


function X.IsHeroInEnemyTeam( sHero )

	for _, id in pairs( GetTeamPlayers( GetOpposingTeam() ) )
	do
		if GetSelectedHeroName( id ) == sHero
		then
			return true
		end
	end

	return false

end


function X.GetOutfitName( bot )

	return 'item_'..string.gsub( bot:GetUnitName(), 'npc_dota_hero_', '' )..'_outfit'

end


return X
-- dota2jmz@163.com QQ:2462331592..
