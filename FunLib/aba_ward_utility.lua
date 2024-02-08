local X = {}

local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local nVisionRadius = 1600

-- Radiant Warding Spots
local RADIANT_T3TOPFALL = Vector(-6590, -3126, 256)
local RADIANT_T3MIDFALL = Vector(-4346, -3929, 256)
local RADIANT_T3BOTFALL = Vector(-3650, -6116, 256)

local RADIANT_T2TOPFALL = Vector(-7529, -516, 256)
local RADIANT_T2MIDFALL = Vector(-4333, -1031, 535)
local RADIANT_T2BOTFALL = Vector(760, -4600, 535)

local RADIANT_T1TOPFALL = Vector(-4110, 1510, 535)
local RADIANT_T1MIDFALL = Vector(-1082, -2208, 256)
local RADIANT_T1BOTFALL = Vector(3859, -4611, 535)

local RADIANT_MANDATE1 = Vector(-250, -1089, 128)
local RADIANT_MANDATE2 = Vector(-1932, 202, 128)

-- Dire Warding Spots
local DIRE_T3TOPFALL = Vector(3149, 5704, 256)
local DIRE_T3MIDFALL = Vector(4071, 3459, 256)
local DIRE_T3BOTFALL = Vector(6321, 2674, 256)

local DIRE_T2TOPFALL = Vector(-772, 3608, 527)
local DIRE_T2MIDFALL = Vector(1044, 3323, 399)
local DIRE_T2BOTFALL = Vector(4610, 767, 527)

local DIRE_T1TOPFALL = Vector(-2409, 5274, 256)
local DIRE_T1MIDFALL = Vector(2055, -771, 527)
local DIRE_T1BOTFALL = Vector(4476, -1703, 128)

local DIRE_MANDATE1 = Vector(-491, 303, 128)
local DIRE_MANDATE2 = Vector(1160, -483, 128)

-- Aggresive Warding
local RADIANT_AGGRESSIVETOP = DIRE_T2TOPFALL
local RADIANT_AGGRESSIVEMID1 = DIRE_T1MIDFALL
local RADIANT_AGGRESSIVEMID2 = DIRE_T2MIDFALL
local RADIANT_AGGRESSIVEBOT = DIRE_T2BOTFALL

local DIRE_AGGRESSIVETOP = RADIANT_T1TOPFALL
local DIRE_AGGRESSIVEMID1 = RADIANT_T2TOPFALL
local DIRE_AGGRESSIVEMID2 = RADIANT_T2MIDFALL
local DIRE_AGGRESSIVEBOT = RADIANT_T2BOTFALL

local nTowerList = {
	TOWER_TOP_1,
	TOWER_MID_1,
	TOWER_BOT_1,
	TOWER_TOP_2,
	TOWER_MID_2,
	TOWER_BOT_2,
	TOWER_TOP_3,
	TOWER_MID_3,
	TOWER_BOT_3,
}

local WardSpotTowerFallRadiant = {
	RADIANT_T1TOPFALL,
	RADIANT_T1MIDFALL,
	RADIANT_T1BOTFALL,
	RADIANT_T2TOPFALL,
	RADIANT_T2MIDFALL,
	RADIANT_T2BOTFALL,
	RADIANT_T3TOPFALL,
	RADIANT_T3MIDFALL,
	RADIANT_T3BOTFALL,
}

local WardSpotTowerFallDire = {
	DIRE_T1TOPFALL,
	DIRE_T1MIDFALL,
	DIRE_T1BOTFALL,
	DIRE_T2TOPFALL,
	DIRE_T2MIDFALL,
	DIRE_T2BOTFALL,
	DIRE_T3TOPFALL,
	DIRE_T3MIDFALL,
	DIRE_T3BOTFALL,
}

function X.GetMandatorySpot()
	local MandatorySpotRadiant = {
		RADIANT_MANDATE1,
		RADIANT_MANDATE2
	}

	local MandatorySpotDire = {
		DIRE_MANDATE1,
		DIRE_MANDATE2
	}

	if GetTeam() == TEAM_RADIANT
    then
		return MandatorySpotRadiant
	else
		return MandatorySpotDire
	end
end

function X.GetWardSpotWhenTowerFall()
	local wardSpot = {}

	for i = 1, #nTowerList
	do
		local t = GetTower(GetTeam(),  nTowerList[i])

		if t == nil
        then
			if GetTeam() == TEAM_RADIANT
            then
				table.insert(wardSpot, WardSpotTowerFallRadiant[i])
			else
				table.insert(wardSpot, WardSpotTowerFallDire[i])
			end
		end
	end

	return wardSpot
end

function X.GetAggressiveSpot()
	local AggressiveDire = {
		DIRE_AGGRESSIVETOP,
		DIRE_AGGRESSIVEMID1,
		DIRE_AGGRESSIVEMID2,
		DIRE_AGGRESSIVEBOT
	}

	local AggressiveRadiant = {
		RADIANT_AGGRESSIVETOP,
		RADIANT_AGGRESSIVEMID1,
		RADIANT_AGGRESSIVEMID2,
		RADIANT_AGGRESSIVEBOT
	}

	if GetTeam() == TEAM_RADIANT
    then
		return AggressiveRadiant
	else
		return AggressiveDire
	end
end

function X.GetItemWard(bot)
	for i = 0, 8
    do
		local item = bot:GetItemInSlot(i)

		if  item ~= nil
        and (item:GetName() == 'item_ward_observer'
            or item:GetName() == 'item_ward_sentry')
        then
			return item
		end
	end

	return nil
end

function X.IsPingedByHumanPlayer(bot)
	local nTeamPlayers = GetTeamPlayers(GetTeam())

	for i, id in pairs(nTeamPlayers)
	do
		if not IsPlayerBot(id)
        then
			local member = GetTeamMember(i)

			if  member ~= nil
            and member:IsAlive()
            and GetUnitToUnitDistance(bot, member) < 1200
            then
				local ping = member:GetMostRecentPing()
				local wardSlot = member:FindItemSlot("item_ward_observer")

				if  GetUnitToLocationDistance(bot, ping.location) <= 600
                and GameTime() - ping.time < 5
                and wardSlot == -1
				then
					return true, member
				end
			end
		end
	end

	return false, nil
end

function X.GetAvailableSpot(bot)
	local availableSpot = {}

	for _, spot in pairs(X.GetMandatorySpot())
    do
		if not X.IsOtherWardClose(spot)
        then
			table.insert(availableSpot, spot)
		end
	end

	for _, spot in pairs(X.GetWardSpotWhenTowerFall())
    do
		if not X.IsOtherWardClose(spot)
        then
			table.insert(availableSpot, spot)
		end
	end

    if DotaTime() > 5 * 60
    then
		for _, spot in pairs(X.GetAggressiveSpot())
        do
			if  GetUnitToLocationDistance(bot, spot) <= 1200
            and not X.IsOtherWardClose(spot)
            then
				table.insert(availableSpot, spot)
			end
		end
	end

	return availableSpot
end

function X.IsOtherWardClose(wardLoc)
	local nWardList = GetUnitList(UNIT_LIST_ALLIED_WARDS)

	for _, ward in pairs(nWardList)
    do
		if  X.IsWard(ward)
        and GetUnitToLocationDistance(ward, wardLoc) <= nVisionRadius
        then
			return true
		end
	end

	return false
end

function X.GetClosestSpot(bot, spots)
	local cDist = 100000
	local cTarget = nil

	for _, spot in pairs(spots)
    do
		local dist = GetUnitToLocationDistance(bot, spot)

		if dist < cDist
        then
			cDist = dist
			cTarget = spot
		end
	end

	return cTarget, cDist
end

function X.IsWard(ward)
    local bot = GetBot()
    local pos = J.GetPosition(bot)

    if pos == 4
    then
        return ward:GetUnitName() == "npc_dota_sentry_wards"
    elseif pos == 5
    then
        return ward:GetUnitName() == "npc_dota_observer_wards"
    end
end

function X.GetHumanPing()
	local nTeamPlayers = GetTeamPlayers(GetTeam())

	for _, id in pairs(nTeamPlayers)
	do
		local member = GetTeamMember(id)

		if  member ~= nil
        and not member:IsBot()
        then
			return member:GetMostRecentPing()
		end
	end

	return nil
end

return X