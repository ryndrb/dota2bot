local X = {}

local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/lua_util')

local nVisionRadius = 1600

-- Radiant Warding Spots
-- Game Start
local RADIANT_GAME_START_MID_1 = Vector(-250, -1089, 128)
local RADIANT_GAME_START_MID_2 = Vector(-1936.532593, 219.070312, 128.000000)
local RADIANT_GAME_START_MID_3 = Vector(192.359741, -1245.259888, 128.000000)
local RADIANT_GAME_START_2 = Vector(1573.506714, -4622.163574, 256)

-- Laning Phase
local RADIANT_LANE_PHASE_1 = Vector(-3975.636719, 1596.444824, 256.000000)
local RADIANT_LANE_PHASE_2 = Vector(-7801.413574, 3812.353760, 128.000000)
local RADIANT_LANE_PHASE_3 = Vector(-1936.532593, 219.070312, 128.000000)
local RADIANT_LANE_PHASE_4 = Vector(-138.504257, 1377.454346, 128.000000)
local RADIANT_LANE_PHASE_5 = Vector(3107.636475, -4059.501465, 256.000000)
local RADIANT_LANE_PHASE_6 = Vector(7938.873047, -5564.231934, 128.000000)

-- Dire Warding Spots
-- Game Start
local DIRE_GAME_START_MID_1 = Vector(-491, 303, 128)
local DIRE_GAME_START_MID_2 = Vector(1388.739624, -501.590698, 128.000000)
local DIRE_GAME_START_MID_3 = Vector(-1123.828003, 1443.285522, 128.000000)
local DIRE_GAME_START_2 = Vector(-1751.722900, 3574.795898, 256)

-- Laning Phase
local DIRE_LANE_PHASE_1 = Vector(-4278.674805, 3518.397217, 128.000000)
local DIRE_LANE_PHASE_2 = Vector(-7044.607422, 5093.973633, 128.000000)
local DIRE_LANE_PHASE_3 = Vector(-1546.854858, 2030.528931, 256.000000)
local DIRE_LANE_PHASE_4 = Vector(1388.739624, -501.590698, 128.000000)
local DIRE_LANE_PHASE_5 = Vector(4193.616699, -4767.900391, 128.000000)
local DIRE_LANE_PHASE_6 = Vector(8394.113281, -4270.384766, 128.000000)

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

-- #############################################################
-- RADIANT
-- #############################################################
local WardSpotAliveTeamTowerRadiant = {
	[TOWER_TOP_1] = {
						Vector(-5925.026855, 5931.392578, 128.000000),
						Vector(-6833.243652, 3245.077637, 128.000000),
						Vector(-3659.489014, 3796.637207, 128.000000),
					},
	[TOWER_MID_1] = {
						Vector(2453.528564, -2577.262695, 0.000000),
						Vector(-112.282990, -7.913391, 128.000000),
						Vector(-2402.732666, 2227.818359, 0.000000),
					},
	[TOWER_BOT_1] = {
						Vector(5465.406738, -4899.457031, 128.000000),
						Vector(5879.298340, -7194.353516, 256.003510),
						Vector(3107.636475, -4059.501465, 256.000000),
					},

	[TOWER_TOP_2] = {
						Vector(-7926.328613, 1815.046875, 535.996094),
						Vector(-3975.636719, 1596.444824, 256.000000),
						Vector(-4342.049316, -1026.770630, 535.996094),
					},
	[TOWER_MID_2] = {
						Vector(-1288.826660, -4335.034668, 403.246094),
						Vector(-4342.049316, -1026.770630, 535.996094),
						Vector(-865.099976, -2101.762451, 128.000000),
					},
	[TOWER_BOT_2] = {
						Vector(2553.738281, -7069.553711, 128.000000),
						Vector(1573.506714, -4622.163574, 256),
						Vector(-205.959290, -8172.805664, 134.000000),
					},

	[TOWER_TOP_3] = {
						Vector(-6558, -3055, 256),
						Vector(-7507.452148, -961.982544, 256.000000),
						Vector(-4838.390625, -2104.272705, 256.000000),
					},
	[TOWER_MID_3] = {
						Vector(-4346, -3911, 256),
						Vector(-1288.826660, -4335.034668, 403.246094),
						Vector(-4342.049316, -1026.770630, 535.996094),
					},
	[TOWER_BOT_3] = {
						Vector(-1795.113770, -5899.868164, 128.000000),
						Vector(-3623, -6089, 256),
						Vector(-1691.701416, -7688.642090, 134.000000),
					},
}

local InvadeWardSpotDeadEnemyTowerDire = {
	[TOWER_TOP_1] = {
						Vector(-5866.308105, 8028.103027, 256.000000),
						Vector(-1616.051270, 7650.706055, 124.342430),
						Vector(-2238.374023, 4268.447266, 256.000000),
						Vector(1028.810791, 3569.791016, 399.996094),
					},
	[TOWER_MID_1] = {
						Vector(1028.810791, 3569.791016, 399.996094),
						Vector(834.130371, 1580.029785, 128.000000),
						Vector(4609.375977, 765.528931, 527.996094),
						Vector(3440, -704, 256),
					},
	[TOWER_BOT_1] = {
						Vector(4646, -1805, 128),
						Vector(7678.188477, -2579.864746, 256.000000),
						Vector(7700.361328, -1578.569580, 527.996094),
						Vector(5093,  -238, 256),
					},

	[TOWER_TOP_2] = {
						Vector(1028.810791, 3569.791016, 399.996094),
						Vector(-1616.051270, 7650.706055, 124.342430),
						Vector(3171.022217, 6606.255371, 256.000000),
						Vector(2334, 4270, 128),
					},
	[TOWER_MID_2] = {
						Vector(4609.375977, 765.528931, 527.996094),
						Vector(3400,  986, 256),
						Vector(1028.810791, 3569.791016, 399.996094),
						Vector(4548.328613, 2876.464355, 256.000000),
						Vector(3386.056885, 4060.462891, 256.000000),
					},
	[TOWER_BOT_2] = {
						Vector(8130,  700, 256),
						Vector(4609.375977, 765.528931, 527.996094),
						Vector(5496.652344, 2656.241699, 256.000000),
					},

	[TOWER_TOP_3] = {
						Vector(2334, 4270, 128),
						Vector(4441, 5559, 256),
					},
	[TOWER_MID_3] = {
						Vector(4474, 3877, 256),
						Vector(5747, 5298, 256),
					},
	[TOWER_BOT_3] = {
						Vector(6003, 3884, 256),
						Vector(5124, 2755, 256),
					},
}

-- #############################################################
-- DIRE
-- #############################################################
local WardSpotAliveTeamTowerDire = {
	[TOWER_TOP_1] = {
						Vector(-8035.601074, 6464.156250, 256.000000),
						Vector(-3871.359131, 5240.929688, 128.000000),
						Vector(-4531.346680, 2140.848389, 128.000000),
					},
	[TOWER_MID_1] = {
						Vector(-1123.828003, 1443.285522, 128.000000),
						Vector(2817.993408, -1454.977173, 256.000000),
						Vector(-1636.748413, 3503.218018, 256.000000),
					},
	[TOWER_BOT_1] = {
						Vector(4332.247070, -3319.497803, 128.002655),
						Vector(4881.448242, -1862.006348, 128.000000),
						Vector(7700.361328, -1578.569580, 527.996094),
					},

	[TOWER_TOP_2] = {
						Vector(-1636.748413, 3503.218018, 256.000000),
						Vector(-1616.051270, 7650.706055, 124.342430),
						Vector(-4166.691895, 6420.217285, 128.000000),
					},
	[TOWER_MID_2] = {
						Vector(3116, -274, 256),
						Vector(1028.810791, 3569.791016, 399.996094),
						Vector(-1636.748413, 3503.218018, 256.000000),
					},
	[TOWER_BOT_2] = {
						Vector(7700.361328, -1578.569580, 527.996094),
						Vector(4609.375977, 765.528931, 527.996094),
						Vector(2817.993408, -1454.977173, 256.000000),
					},

	[TOWER_TOP_3] = {
						Vector(3122, 5724, 256),
						Vector(1028.810791, 3569.791016, 399.996094),
						Vector(938.908936, 5137.645996, 128.000000),
						Vector(1273.940918, 7240.232910, 134.000000),
					},
	[TOWER_MID_3] = {
						Vector(4007, 3492, 256),
						Vector(4609.375977, 765.528931, 527.996094),
						Vector(1727.438599, 2453.378662, 128.000000),
					},
	[TOWER_BOT_3] = {
						Vector(6350, 2653, 256),
						Vector(4609.375977, 765.528931, 527.996094),
						Vector(8038.527832, 757.996704, 256.000000),
					},
}

local InvadeWardSpotDeadEnemyTowerRadiant = {
	[TOWER_TOP_1] = {
						Vector(-3859.457764, 498.036194, 256.000000),
						Vector(-7900, 1786, 535),
						Vector(-7561,  372, 256),
					},
	[TOWER_MID_1] = {
						Vector(-4342.049316, -1026.770630, 535.996094),
						Vector(-3408,  -339, 256),
						Vector(-808.006470, -2437.411377, 128.000000),
						Vector(-1290.444702, -4357.909668, 403.246094),
					},
	[TOWER_BOT_1] = {
						Vector(3808.769287, -4587.837891, 128.000000),
						Vector(3935.465332, -7214.897461, 128.008591),
						Vector(2562.140137, -7083.191406, 128.000000),
						Vector(1737.805664, -5081.153320, 256.000000),
						Vector(2035.314575, -8358.462891, 250.179520),
					},

	[TOWER_TOP_2] = {
						Vector(-5285, -1585, 256),
						Vector(-7485.068848, -1111.628174, 256.000000),
						Vector(-5685, -3139, 256),
					},
	[TOWER_MID_2] = {
						Vector(-1288.826660, -4335.034668, 403.246094),
						Vector(-4342.049316, -1026.770630, 535.996094),
						Vector(-3269, -1425, 256),
						Vector(-3791, -4518, 256),
						Vector(-5167, -3419, 256),
						Vector(-4907, -2860, 128),
						Vector(-3088, -4273, 128),
					},
	[TOWER_BOT_2] = {
						Vector(-1288.826660, -4335.034668, 403.246094),
						Vector(-1886.194214, -7875.292480, 134.000000),
						Vector(-3529.098389, -6957.137695, 256.000000),
						Vector(-3609, -5320, 256),
						Vector(-2755, -5275, 128),
					},

	[TOWER_TOP_3] = {
						Vector(-6401, -4286, 256),
					},
	[TOWER_MID_3] = {
						Vector(-4912, -4403, 256),
						Vector(-4912, -4403, 256),
						Vector(-6170,  5643, 256),
					},
	[TOWER_BOT_3] = {
						Vector(-4853, -5937, 256),
					},
}

function X.GetLaningPhaseWardSpots()
	local WardSpotRadiant = {
		RADIANT_LANE_PHASE_1,
		RADIANT_LANE_PHASE_2,
		RADIANT_LANE_PHASE_3,
		RADIANT_LANE_PHASE_4,
		RADIANT_LANE_PHASE_5,
		RADIANT_LANE_PHASE_6,
	}

	local WardSpotDire = {
		DIRE_LANE_PHASE_1,
		DIRE_LANE_PHASE_2,
		DIRE_LANE_PHASE_3,
		DIRE_LANE_PHASE_4,
		DIRE_LANE_PHASE_5,
		DIRE_LANE_PHASE_6,
	}

	if GetTeam() == TEAM_RADIANT
    then
		return WardSpotRadiant
	else
		return WardSpotDire
	end
end

function X.GetGameStartWardSpots()
	local hMidWardSpots = {
		RADIANT_GAME_START_MID_1,
		RADIANT_GAME_START_MID_2,
		RADIANT_GAME_START_MID_3,
	}

	local vWardMidSpot = hMidWardSpots[RandomInt(1, #hMidWardSpots)]

	local WardSpotRadiant = {
		vWardMidSpot,
		RADIANT_GAME_START_2,
	}

	hMidWardSpots = {
		DIRE_GAME_START_MID_1,
		DIRE_GAME_START_MID_2,
		DIRE_GAME_START_MID_3,
	}
	vWardMidSpot = hMidWardSpots[RandomInt(1, #hMidWardSpots)]

	local WardSpotDire = {
		vWardMidSpot,
		DIRE_GAME_START_2,
	}

	if GetTeam() == TEAM_RADIANT
    then
		return WardSpotRadiant
	else
		return WardSpotDire
	end
end

function X.GetWardSpotBeforeTowerFall()
	local wardSpot = {}

	for i = 1, #nTowerList
	do
		local t = GetTower(GetTeam(),  nTowerList[i])

		if t ~= nil
		or (t == GetTower(GetTeam(), TOWER_TOP_3) == nil
			or t == GetTower(GetTeam(), TOWER_MID_3) == nil
			or t == GetTower(GetTeam(), TOWER_BOT_3) == nil)
        then
			if (t == GetTower(GetTeam(), TOWER_TOP_2)
				and GetTower(GetTeam(), TOWER_TOP_1) ~= nil)
			or (t == GetTower(GetTeam(), TOWER_TOP_3)
				and GetTower(GetTeam(), TOWER_TOP_2) ~= nil)
			or (t == GetTower(GetTeam(), TOWER_MID_2)
				and GetTower(GetTeam(), TOWER_MID_1) ~= nil)
			or (t == GetTower(GetTeam(), TOWER_MID_3)
				and GetTower(GetTeam(), TOWER_MID_2) ~= nil)
			or (t == GetTower(GetTeam(), TOWER_BOT_2)
				and GetTower(GetTeam(), TOWER_BOT_1) ~= nil)
			or (t == GetTower(GetTeam(), TOWER_BOT_3)
				and GetTower(GetTeam(), TOWER_BOT_2) ~= nil)
			then
				break
			end

			if GetTeam() == TEAM_RADIANT
            then
				for j = 1, #WardSpotAliveTeamTowerRadiant[nTowerList[i]]
				do
					table.insert(wardSpot, WardSpotAliveTeamTowerRadiant[nTowerList[i]][j])
				end
			else
				for j = 1, #WardSpotAliveTeamTowerDire[nTowerList[i]]
				do
					table.insert(wardSpot, WardSpotAliveTeamTowerDire[nTowerList[i]][j])
				end
			end
		end
	end

	return wardSpot
end

function X.GetWardSpotDeadEnemyTowerDire()
	local wardSpot = {}

	for i = 1, #nTowerList
	do
		local t = GetTower(GetOpposingTeam(),  nTowerList[i])

		if t == nil
        then
			if (t == GetTower(GetOpposingTeam(), TOWER_TOP_2)
				and GetTower(GetOpposingTeam(), TOWER_TOP_1) ~= nil)
			or (t == GetTower(GetOpposingTeam(), TOWER_TOP_3)
				and GetTower(GetOpposingTeam(), TOWER_TOP_2) ~= nil)
			or (t == GetTower(GetOpposingTeam(), TOWER_MID_2)
				and GetTower(GetOpposingTeam(), TOWER_MID_1) ~= nil)
			or (t == GetTower(GetOpposingTeam(), TOWER_MID_3)
				and GetTower(GetOpposingTeam(), TOWER_MID_2) ~= nil)
			or (t == GetTower(GetOpposingTeam(), TOWER_BOT_2)
				and GetTower(GetOpposingTeam(), TOWER_BOT_1) ~= nil)
			or (t == GetTower(GetOpposingTeam(), TOWER_BOT_3)
				and GetTower(GetOpposingTeam(), TOWER_BOT_2) ~= nil)
			then
				break
			end

			if GetTeam() == TEAM_RADIANT
            then
				for j = 1, #InvadeWardSpotDeadEnemyTowerDire[nTowerList[i]]
				do
					table.insert(wardSpot, InvadeWardSpotDeadEnemyTowerDire[nTowerList[i]][j])
				end
			else
				for j = 1, #InvadeWardSpotDeadEnemyTowerRadiant[nTowerList[i]]
				do
					table.insert(wardSpot, InvadeWardSpotDeadEnemyTowerRadiant[nTowerList[i]][j])
				end
			end
		end
	end

	return wardSpot
end

local IsPinged = false
function X.GetItemWard(bot)
	for i = 0, 8
    do
		local item = bot:GetItemInSlot(i)

		if  item ~= nil
		and (item:GetName() == 'item_ward_observer'
			or (item:GetName() == 'item_ward_sentry' and IsPinged))
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
				local wardType = "item_ward_observer"

				if J.HasItem(bot, "item_ward_sentry")
				then
					wardType = "item_ward_sentry"
				end

				local wardSlot = member:FindItemSlot(wardType)

				if  GetUnitToLocationDistance(bot, ping.location) <= 700
                and DotaTime() - ping.time < 5
                and wardSlot == -1
				and not ping.normal_ping
				then
					IsPinged = true
					return true, ping.location
				end

				IsPinged = false
			end
		end
	end

	return false, 0
end

function X.GetAvailableSpot(bot)
	local availableSpot = {}

	if DotaTime() < 0
	then
		for _, spot in pairs(X.GetGameStartWardSpots())
		do
			if not X.IsOtherWardClose(spot)
			then
				table.insert(availableSpot, spot)
			end
		end

		return availableSpot
	end

	if J.IsInLaningPhase()
	then
		local nSpots = X.CheckSpots(X.GetLaningPhaseWardSpots())
		for _, spot in pairs(nSpots)
		do
			if not X.IsOtherWardClose(spot)
			then
				table.insert(availableSpot, spot)
			end
		end
	end

	local nSpots = X.CheckSpots(X.GetWardSpotBeforeTowerFall())
	for _, spot in pairs(nSpots)
    do
		if not X.IsOtherWardClose(spot)
        then
			table.insert(availableSpot, spot)
		end
	end

	nSpots = X.CheckSpots(X.GetWardSpotDeadEnemyTowerDire())
	for _, spot in pairs(nSpots)
    do
		if not X.IsOtherWardClose(spot)
        then
			table.insert(availableSpot, spot)
		end
	end

	return availableSpot
end

function X.IsOtherWardClose(wardLoc)
	local nWardList = GetUnitList(UNIT_LIST_ALLIED_WARDS)

	for _, ward in pairs(nWardList)
    do
		if  X.IsWard(ward)
        and GetUnitToLocationDistance(ward, wardLoc) <= nVisionRadius * 1.5
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

    if J.HasItem(bot, "item_ward_sentry")
    then
        return ward:GetUnitName() == "npc_dota_sentry_wards"
    elseif J.HasItem(bot, "item_ward_observer")
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

function X.IsThereSentry(loc)
	local nWardList = GetUnitList(UNIT_LIST_ALLIED_WARDS)

	for _, ward in pairs(nWardList)
    do
		if ward ~= nil
		and ward:GetUnitName() == "npc_dota_sentry_wards"
        and GetUnitToLocationDistance(ward, loc) <= 600
        then
			return true
		end
	end

	return false
end

function X.GetWardType()
	if J.HasItem(GetBot(), 'item_ward_sentry') then return 'sentry' end
	return 'observer'
end

-- Can't refer to the actual (invalid) objects (wards) once garbage collected.
-- So affected spot will just be on cooldown according to the duration of the wards.
function X.CheckSpots(bSpots)
	local bot = GetBot()
	local sSpots = U.deepCopy(bSpots)

	for i = 1, #bot.WardTable
	do
		if bot.WardTable[i] ~= nil
		and X.GetWardType() == bot.WardTable[i].type
		and DotaTime() < bot.WardTable[i].timePlanted + bot.WardTable[i].duration
		then
			for j = #sSpots, 1, -1
			do
				if J.GetDistance(sSpots[j], bot.WardTable[i].loc) < 50
				and not X.IsThereSentry(sSpots[j])
				then
					-- print('Ward Spot: '..tostring(sSpots[j])..' on cooldown!')
					table.remove(sSpots, j)
				end
			end
		end
	end

	return sSpots
end

return X