local X = {}
local Item = {}

Item['item_crimson_guard'] = {
	['npc_dota_hero_arc_warden'] = true,
	['npc_dota_hero_broodmother'] = true,
	['npc_dota_hero_chaos_knight'] = true,
	['npc_dota_hero_death_prophet'] = true,
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
	['npc_dota_hero_earth_spirit'] = true,
	['npc_dota_hero_earthshaker'] = true,
	['npc_dota_hero_invoker'] = true,
	['npc_dota_hero_jakiro'] = true,
	['npc_dota_hero_leshrac'] = true,
	['npc_dota_hero_lich'] = true,
	['npc_dota_hero_lina'] = true,
	['npc_dota_hero_pudge'] = true,
	['npc_dota_hero_queenofpain'] = true,
	['npc_dota_hero_sand_king'] = true,
	['npc_dota_hero_skywrath_mage'] = true,
	['npc_dota_hero_storm_spirit'] = true,
	['npc_dota_hero_techies'] = true,
	['npc_dota_hero_venomancer'] = true,
	['npc_dota_hero_zuus'] = true,
}

Item['item_halberd'] = {
	['npc_dota_hero_clinkz'] = true,
	['npc_dota_hero_drow_ranger'] = true,
	['npc_dota_hero_furion'] = true,
	['npc_dota_hero_gyrocopter'] = true,
	['npc_dota_hero_juggernaut'] = true,
	['npc_dota_hero_kez'] = true,
	['npc_dota_hero_medusa'] = true,
	['npc_dota_hero_monkey_king'] = true,
	['npc_dota_hero_morphling'] = true,
	['npc_dota_hero_muerta'] = true,
	['npc_dota_hero_nevermore'] = true,
	['npc_dota_hero_obsidian_destroyer'] = true,
	['npc_dota_hero_phantom_assassin'] = true,
	['npc_dota_hero_sniper'] = true,
	['npc_dota_hero_sven'] = true,
	['npc_dota_hero_templar_assassin'] = true,
	['npc_dota_hero_terrorblade'] = true,
	['npc_dota_hero_ursa'] = true,
}

Item['item_lotus_orb'] = {
	['npc_dota_hero_bane'] = true,
	['npc_dota_hero_batrider'] = true,
	['npc_dota_hero_beastmaster'] = true,
	['npc_dota_hero_bloodseeker'] = true,
	['npc_dota_hero_doom_bringer'] = true,
	['npc_dota_hero_grimstroke'] = true,
	['npc_dota_hero_juggernaut'] = true,
	['npc_dota_hero_primal_beast'] = true,
	['npc_dota_hero_pudge'] = true,
	['npc_dota_hero_razor'] = true,
	['npc_dota_hero_shadow_demon'] = true,
	['npc_dota_hero_shadow_shaman'] = true,
	['npc_dota_hero_winter_wyvern'] = true,
}

Item['item_nullifier'] = {
	['npc_dota_hero_necrolyte'] = true,
	['npc_dota_hero_omniknight'] = true,
	['npc_dota_hero_pugna'] = true,
	['npc_dota_hero_windrunner'] = true,
}

Item['item_radiance'] = {
	['npc_dota_hero_broodmother'] = true,
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

local hItemName = nil
function X.GetBestUtilityItem(hItemList)
	if hItemName then return hItemName end

	local nItemList = {}
	for i = 1, #hItemList do
		nItemList[hItemList[i]] = -999
	end

	for i = 1, #hItemList do
		local sItemName = hItemList[i]
		for j, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
			local sHeroName = GetSelectedHeroName(id)
			if Item[sItemName] and Item[sItemName][sHeroName] and nItemList[sItemName] then
				local weight = 0
				if sItemName == 'item_crimson_guard'
				or sItemName == 'item_halberd'
				or sItemName == 'item_assault'
				then
					weight = j <= 3 and 1 or 0.5
				else
					weight = 1
				end
				nItemList[sItemName] = weight
			end
		end
	end

	local bestItem = nil
	local bestItemValue = -1
	for itemName, value in pairs(nItemList) do
		if value >= bestItemValue then
			if value == bestItemValue then
				bestItem = (RandomInt(0,1) == 0 and bestItem) or itemName
			else
				bestItem = itemName
			end
			bestItemValue = value
		end
	end

	hItemName = bestItem or hItemList[1]
	return hItemName
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