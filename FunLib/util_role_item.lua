local X = {}
local Item = {}

Item['item_crimson_guard'] = {
	['npc_dota_hero_arc_warden'] = true,
	['npc_dota_hero_broodmother'] = true,
	['npc_dota_hero_chaos_knight'] = true,
	['npc_dota_hero_gyrocopter'] = true,
	['npc_dota_hero_juggernaut'] = true,
	['npc_dota_hero_luna'] = true,
	['npc_dota_hero_medusa'] = true,
	['npc_dota_hero_meepo'] = true,
	['npc_dota_hero_naga_siren'] = true,
	['npc_dota_hero_phantom_lancer'] = true,
	['npc_dota_hero_sven'] = true,
	['npc_dota_hero_templar_assassin'] = true,
	['npc_dota_hero_terrorblade'] = true,
	['npc_dota_hero_troll_warlord'] = true,
}

Item['item_pipe'] = {
	['npc_dota_hero_crystal_maiden'] = true,
	['npc_dota_hero_death_prophet'] = true,
	['npc_dota_hero_earth_spirit'] = true,
	['npc_dota_hero_earthshaker'] = true,
	['npc_dota_hero_invoker'] = true,
	['npc_dota_hero_jakiro'] = true,
	['npc_dota_hero_kunkka'] = true,
	['npc_dota_hero_leshrac'] = true,
	['npc_dota_hero_lich'] = true,
	['npc_dota_hero_lina'] = true,
	['npc_dota_hero_puck'] = true,
	['npc_dota_hero_pudge'] = true,
	['npc_dota_hero_queenofpain'] = true,
	['npc_dota_hero_sand_king'] = true,
	['npc_dota_hero_skywrath_mage'] = true,
	['npc_dota_hero_storm_spirit'] = true,
	['npc_dota_hero_techies'] = true,
	['npc_dota_hero_venomancer'] = true,
	['npc_dota_hero_viper'] = true,
	['npc_dota_hero_zuus'] = true,
}

Item['item_halberd'] = {
	['npc_dota_hero_antimage'] = true,
	['npc_dota_hero_arc_warden'] = true,
	['npc_dota_hero_bloodseeker'] = true,
	['npc_dota_hero_broodmother'] = true,
	['npc_dota_hero_chaos_knight'] = true,
	['npc_dota_hero_clinkz'] = true,
	['npc_dota_hero_drow_ranger'] = true,
	['npc_dota_hero_gyrocopter'] = true,
	['npc_dota_hero_huskar'] = true,
	['npc_dota_hero_juggernaut'] = true,
	['npc_dota_hero_lina'] = true,
	['npc_dota_hero_medusa'] = true,
	['npc_dota_hero_monkey_king'] = true,
	['npc_dota_hero_morphling'] = true,
	['npc_dota_hero_muerta'] = true,
	['npc_dota_hero_nevermore'] = true,
	['npc_dota_hero_obsidian_destroyer'] = true,
	['npc_dota_hero_phantom_assassin'] = true,
	['npc_dota_hero_slardar'] = true,
	['npc_dota_hero_slark'] = true,
	['npc_dota_hero_sniper'] = true,
	['npc_dota_hero_sven'] = true,
	['npc_dota_hero_templar_assassin'] = true,
	['npc_dota_hero_terrorblade'] = true,
	['npc_dota_hero_troll_warlord'] = true,
	['npc_dota_hero_ursa'] = true,
}

Item['item_lotus_orb'] = {
	['npc_dota_hero_bane'] = true,
	['npc_dota_hero_batrider'] = true,
	['npc_dota_hero_beastmaster'] = true,
	['npc_dota_hero_bloodseeker'] = true,
	['npc_dota_hero_doom_bringer'] = true,
	['npc_dota_hero_grimstroke'] = true,
	['npc_dota_hero_primal_beast'] = true,
	['npc_dota_hero_pudge'] = true,
	['npc_dota_hero_razor'] = true,
	['npc_dota_hero_winter_wyvern'] = true,
}

Item['item_nullifier'] = {
	['npc_dota_hero_necrolyte'] = true,
	['npc_dota_hero_pugna'] = true,
	['npc_dota_hero_omniknight'] = true,
	['npc_dota_hero_windrunner'] = true,
}

Item['item_radiance'] = {
	['npc_dota_hero_chaos_knight'] = true,
	['npc_dota_hero_meepo'] = true,
	['npc_dota_hero_naga_siren'] = true,
	['npc_dota_hero_phantom_lancer'] = true,
	['npc_dota_hero_terrorblade'] = true,
}

Item['item_assault'] = {
	['npc_dota_hero_chaos_knight'] = true,
	['npc_dota_hero_meepo'] = true,
	['npc_dota_hero_naga_siren'] = true,
	['npc_dota_hero_phantom_lancer'] = true,
	['npc_dota_hero_terrorblade'] = true,
	['npc_dota_hero_phantom_assassin'] = true,
	['npc_dota_hero_templar_assassin'] = true,
}

local bDoneBestItem = false
local hItemName = ''
function X.GetBestUtilityItem(itemTable)
	if bDoneBestItem == true and hItemName ~= '' then
		return hItemName
	end

	local nItemList = {}
	for i = 1, #itemTable
	do
		nItemList[itemTable[i]] = 0
	end

	for i = 1, #itemTable
	do
		for j, id in pairs(GetTeamPlayers(GetOpposingTeam()))
		do
			local hName = GetSelectedHeroName(id)

			if Item['item_crimson_guard'][hName] and nItemList['item_crimson_guard'] and j <= 3
			then
				nItemList['item_crimson_guard'] = nItemList['item_crimson_guard'] + 1
			end

			if Item['item_pipe'][hName] and nItemList['item_pipe']
			then
				nItemList['item_pipe'] = nItemList['item_pipe'] + 1
			end

			if Item['item_halberd'][hName] and nItemList['item_halberd'] and j <= 3
			then
				nItemList['item_halberd'] = nItemList['item_halberd'] + 1
			end

			if Item['item_lotus_orb'][hName] and nItemList['item_lotus_orb']
			then
				nItemList['item_lotus_orb'] = nItemList['item_lotus_orb'] + 1
			end

			if Item['item_nullifier'][hName] and nItemList['item_nullifier']
			then
				nItemList['item_nullifier'] = nItemList['item_nullifier'] + 1
			end

			if Item['item_assault'][hName] and nItemList['item_assault'] and j <= 3
			then
				nItemList['item_assault'] = nItemList['item_assault'] + 1
			end
		end
	end

	local sBestItem = ''
	local c = -1
	for k, v in pairs(nItemList)
	do
		if v > c
		then
			c = v
			sBestItem = k
		end
	end

	bDoneBestItem = true
	if sBestItem == '' then return itemTable[1] end
	return sBestItem
end

function X.GetAltItem(hItemName1, hItemName2)
	local sChosenItem = hItemName1

	for i, id in pairs(GetTeamPlayers(GetOpposingTeam()))
	do
		local hName = GetSelectedHeroName(id)

		if Item[hItemName2][hName]
		and i <= 3
		then
			sChosenItem = hItemName2
			break
		end
	end

	return sChosenItem
end

return X