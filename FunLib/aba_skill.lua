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
	local talent_idx = 1
	local ability_idx = 1
	local bMoreMeepoFacet = GetBot():GetUnitName() == 'npc_dota_hero_meepo' and true
	local buildListLen = bMoreMeepoFacet and 30 or (#nAbilityBuildList + #nTalentBuildList)

	if GetBot():GetUnitName() == 'npc_dota_hero_lone_druid_bear' then
		for i = 1, #nTalentBuildList do
			sSkillList[i] = sTalentList[nTalentBuildList[i]]
		end

		return sSkillList
	end

	for i = 1, buildListLen do
		if sSkillList[i] == nil then
			if (not bMoreMeepoFacet and (i >= 10 and (i % 5 == 0 or ability_idx > #nAbilityBuildList)))
			or (bMoreMeepoFacet and ((i == 11) or (i == 15) or (i >= 18 and i <= 23) or (i >= 25 and i <= 30)))
			then
				sSkillList[i] = sTalentList[nTalentBuildList[talent_idx]]
				talent_idx = talent_idx + 1
				if bMoreMeepoFacet then
					if talent_idx == 9 then talent_idx = 3 end
				end
			else
				if (bMoreMeepoFacet)
				or (not bMoreMeepoFacet and (ability_idx <= #nAbilityBuildList))
				then
					sSkillList[i] = sAbilityList[nAbilityBuildList[ability_idx]]
					ability_idx = ability_idx + 1
				end
			end
		end
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
