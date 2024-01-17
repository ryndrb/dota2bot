local Push = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

function Push.GetPushDesire(bot, lane)
    local enemies   = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local allies    = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local creeps    = bot:GetNearbyCreeps(600 + bot:GetAttackRange(), false)

    local IDs = GetTeamPlayers(GetTeam())
    for _, id in pairs(IDs) do
        if GetHeroLevel(id) < 6
        and (J.IsModeTurbo() and DotaTime() < 8 * 60 or DotaTime() < 12 * 60)
        then
            return 0.1
        end
    end

    local aliveHeroesList = {}
    for _, h in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if h:IsAlive()
        then
            table.insert(aliveHeroesList, h)
        end
    end

    if J.IsRoshanAlive()
    and J.HasEnoughDPSForRoshan(aliveHeroesList)
    then
        return BOT_MODE_DESIRE_NONE
    end

    if bot:GetHealth() / bot:GetMaxHealth() < 0.3
    or (enemies ~= nil and allies ~= nil and #enemies > #allies)
    or bot:WasRecentlyDamagedByTower(1)
    or not J.WeAreStronger(bot, 1600)
    or (J.IsLaning(bot) or J.IsFarming(bot))
    then
        return 0.25
    end

    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)
    if Push.WhichLaneToPush(bot) == lane
    and aAliveCount > eAliveCount
    then
        local aFront = RemapValClamped(GetLaneFrontAmount(GetTeam(), lane, true), 0, 1, 0, 0.75)
        local eFront = RemapValClamped(GetLaneFrontAmount(GetOpposingTeam(), lane, true), 0, 1, 0, 0.75)
        -- local amount = aFront * eFront
        local amount = RemapValClamped(GetPushLaneDesire(lane), 0, 1, 0, 0.75)

        if J.DoesTeamHaveAegis(GetUnitList(UNIT_LIST_ALLIED_HEROES))
        then
            local aegis = 1.3
            amount = amount * aegis
        end

        local tot = ((aAliveCount - eAliveCount) / (aAliveCount + eAliveCount)) * 0.15
        amount = amount + tot

        local nHeroesInLane = Push.GetEnemyCountInLane(lane)
        if ((#nHeroesInLane[1] - #nHeroesInLane[2]) / (#nHeroesInLane[1] + #nHeroesInLane[2])) * 0.15 < 0
        then
            amount = amount + ((#nHeroesInLane[1] - #nHeroesInLane[2]) / (#nHeroesInLane[1] + #nHeroesInLane[2])) * 0.15
        end

        return Clamp(amount, 0.1, 0.75 + tot)
    end

    return 0.1
end

-- local TeamLocation = {}
function Push.WhichLaneToPush(bot)

    -- TeamLocation[bot:GetPlayerID()] = bot:GetLocation()
    local TeamLocation = {}
    for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if u:IsAlive()
        and J.IsCore(u)
        then
            TeamLocation[u:GetPlayerID()] = u:GetLocation()
        end
    end

    local distanceToTop = 0
    local distanceToMid = 0
    local distanceToBot = 0

    local IDs = GetTeamPlayers(GetTeam())
    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)

    if aAliveCount > eAliveCount
    or J.DoesTeamHaveAegis(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    then
        for _, id in pairs(IDs) do
            if TeamLocation[id] ~= nil then
                if IsHeroAlive(id) then
                    distanceToTop = distanceToTop + math.max(distanceToTop, #(GetLaneFrontLocation(GetTeam(), LANE_TOP, 0.0) - TeamLocation[id]))
                    distanceToMid = distanceToMid + math.max(distanceToMid, #(GetLaneFrontLocation(GetTeam(), LANE_MID, 0.0) - TeamLocation[id]))
                    distanceToBot = distanceToBot + math.max(distanceToBot, #(GetLaneFrontLocation(GetTeam(), LANE_BOT, 0.0) - TeamLocation[id]))
                end
            end
        end
    else
        distanceToTop = math.max(0, #(GetLaneFrontLocation(GetTeam(), LANE_TOP, 0.0) - bot:GetLocation()))
        distanceToMid = math.max(0, #(GetLaneFrontLocation(GetTeam(), LANE_MID, 0.0) - bot:GetLocation()))
        distanceToBot = math.max(0, #(GetLaneFrontLocation(GetTeam(), LANE_BOT, 0.0) - bot:GetLocation()))
    end

    if distanceToBot < distanceToTop
    and distanceToBot < distanceToMid
    -- and (GetBarracks(GetOpposingTeam(), BARRACKS_BOT_MELEE) ~= nil or GetBarracks(GetOpposingTeam(), BARRACKS_BOT_RANGED) ~= nil) 
    then
        return LANE_BOT
    end

    if distanceToTop < distanceToMid
    and distanceToTop < distanceToBot
    -- and (GetBarracks(GetOpposingTeam(), BARRACKS_TOP_MELEE) ~= nil or GetBarracks(GetOpposingTeam(), BARRACKS_TOP_RANGED) ~= nil) 
    then
        return LANE_TOP
    end

    if distanceToMid < distanceToTop
    and distanceToMid < distanceToBot
    -- and (GetBarracks(GetOpposingTeam(), BARRACKS_MID_MELEE) ~= nil or GetBarracks(GetOpposingTeam(), BARRACKS_MID_RANGED) ~= nil) 
    then
        return LANE_MID
    end

    -- local botLocation = bot:GetLocation()
    -- local distanceToTop = 0
    -- local distanceToMid = 0
    -- local distanceToBot = 0

    -- if bot:IsAlive()
    -- then
    --     distanceToTop = 50000 - math.max(0, #(GetLaneFrontLocation(GetTeam(), LANE_TOP, 0.0) - botLocation))
    --     distanceToMid = 50000 - math.max(0, #(GetLaneFrontLocation(GetTeam(), LANE_MID, 0.0) - botLocation))
    --     distanceToBot = 50000 - math.max(0, #(GetLaneFrontLocation(GetTeam(), LANE_BOT, 0.0) - botLocation))
    -- else
    --     return Push.TeamPushLane()
    -- end

    -- local laneAmountEnemyTop = (GetLaneFrontAmount(GetOpposingTeam(), LANE_TOP, false))
	-- local laneAmountEnemyMid = (GetLaneFrontAmount(GetOpposingTeam(), LANE_MID, false))
	-- local laneAmountEnemyBot = (GetLaneFrontAmount(GetOpposingTeam(), LANE_BOT, false))

	-- local laneAmountTop = GetLaneFrontAmount(GetTeam(), LANE_TOP, false) * laneAmountEnemyTop * distanceToTop
    -- local laneAmountMid = GetLaneFrontAmount(GetTeam(), LANE_MID, false) * laneAmountEnemyMid * distanceToMid
    -- local laneAmountBot = GetLaneFrontAmount(GetTeam(), LANE_BOT, false) * laneAmountEnemyBot * distanceToBot

    -- if laneAmountTop     > laneAmountBot
    -- and laneAmountTop    > laneAmountMid
    -- -- and (GetBarracks(GetOpposingTeam(), BARRACKS_TOP_MELEE) ~= nil or GetBarracks(GetOpposingTeam(), BARRACKS_TOP_RANGED) ~= nil) 
    -- then
    --     return LANE_TOP
    -- end

    -- if laneAmountBot     > laneAmountTop
    -- and laneAmountBot    > laneAmountMid
    -- -- and (GetBarracks(GetOpposingTeam(), BARRACKS_BOT_MELEE) ~= nil or GetBarracks(GetOpposingTeam(), BARRACKS_BOT_RANGED) ~= nil) 
    -- then
    --     return LANE_BOT
    -- end

    -- if laneAmountMid     > laneAmountTop
    -- and laneAmountMid    > laneAmountBot
    -- -- and (GetBarracks(GetOpposingTeam(), BARRACKS_MID_MELEE) ~= nil or GetBarracks(GetOpposingTeam(), BARRACKS_MID_RANGED) ~= nil) 
    -- then
    --     return LANE_MID
    -- end

    return Push.TeamPushLane()
end

function Push.TeamPushLane()

    local team = TEAM_RADIANT

    if GetTeam() == TEAM_RADIANT then
        team = TEAM_DIRE
    end
  
    if GetTower(team, TOWER_MID_1) ~= nil then
        return LANE_MID;
    end
    if GetTower(team, TOWER_BOT_1) ~= nil then
        return LANE_BOT;
    end
    if GetTower(team, TOWER_TOP_1) ~= nil then
        return LANE_TOP;
    end
  
    if GetTower(team, TOWER_MID_2) ~= nil then
        return LANE_MID;
    end
    if GetTower(team, TOWER_BOT_2) ~= nil then
        return LANE_BOT;
    end
    if GetTower(team, TOWER_TOP_2) ~= nil then
        return LANE_TOP;
    end
  
    if GetTower(team, TOWER_MID_3) ~= nil
    or GetBarracks(team, BARRACKS_MID_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_MID_RANGED) ~= nil then
        return LANE_MID;
    end

    if GetTower(team, TOWER_BOT_3) ~= nil 
    or GetBarracks(team, BARRACKS_BOT_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_BOT_RANGED) ~= nil then
        return LANE_BOT;
    end

    if GetTower(team, TOWER_TOP_3) ~= nil
    or GetBarracks(team, BARRACKS_TOP_MELEE) ~= nil
    or GetBarracks(team, BARRACKS_TOP_RANGED) ~= nil then
        return LANE_TOP;
    end
  
    return LANE_MID;
  
end

function Push.ShouldPushWhenLaning(bot, lane)
	local pos = J.GetPosition(bot)

	if (J.IsModeTurbo() and DotaTime() < 8 * 60)
	or DotaTime() < 12 * 60
	then
		if GetTeam() == TEAM_RADIANT then
			if lane == LANE_TOP
			and (pos == 3 or pos == 4) then
				return true
			elseif lane == LANE_MID
			and pos == 2 then
				return true
			elseif lane == LANE_BOT
			and (pos == 1 or pos == 5) then
				return true
			end
		elseif GetTeam() == TEAM_DIRE then
			if lane == LANE_TOP
			and (pos == 1 or pos == 5) then
				return true
			elseif lane == LANE_MID
			and pos == 2 then
				return true
			elseif lane == LANE_BOT
			and (pos == 3 or pos == 4) then
				return true
			end
		end

        return false
	end
end

function Push.GetEnemyCountInLane(lane)
	local nEnemies = {}
    local nAllies = {}
    local nAllyList = GetUnitList(UNIT_LIST_ALLIED_HEROES)
	local nEnemyList = GetUnitList(UNIT_LIST_ENEMY_HEROES)

	for _, enemy in pairs(nEnemyList) do
		local lanefrontloc = GetLaneFrontLocation(GetTeam(), lane, 0)

		if GetUnitToLocationDistance(enemy, lanefrontloc) <= 1600
		then
			table.insert(nEnemies, enemy)
		end
	end

    for _, enemy in pairs(nAllyList) do
		local lanefrontloc = GetLaneFrontLocation(GetTeam(), lane, 0)

		if GetUnitToLocationDistance(enemy, lanefrontloc) <= 1600
		then
			table.insert(nAllies, enemy)
		end
	end

	return {nAllies, nEnemies}
end

function Push.PushThink(bot, lane)

    if bot:IsChanneling() or bot:IsUsingAbility() then
        return
    end
  
    local enemyIds = GetTeamPlayers(GetOpposingTeam())
    local teammateIds = GetTeamPlayers(GetTeam())
  
    local laneFrontLocation = GetLaneFrontLocation(GetTeam(), lane, 0)
    local enemyDistance = 0
    local enemyAlive = 0
    local teammateDistance = 0
    local teammateAlive = 0
    local nRange = bot:GetAttackRange()
  
    for _, id in pairs(enemyIds) do
        if IsHeroAlive(id) then
            local info = GetHeroLastSeenInfo(id)
            -- Take an aggressive guess
            if info.location ~= nil then
                enemyDistance = enemyDistance + math.max(#(info.location - laneFrontLocation) - info.time * 400, 400)
                enemyAlive = enemyAlive + 1
            end
        end
    end
  
    for _,id in pairs(teammateIds) do
        if IsHeroAlive(id) then
            local info = GetHeroLastSeenInfo(id)
            if info.location ~= nil then
                teammateDistance = teammateDistance + #(info.location - laneFrontLocation)
                teammateAlive = teammateAlive + 1
            end
        end
    end

    local offset = -math.max(teammateDistance / teammateAlive - enemyDistance / enemyAlive, 0)

    if J.WeAreStronger(bot, 700 + nRange) and #bot:GetNearbyHeroes(700 + nRange, false, BOT_MODE_NONE) >= enemyAlive then
        offset = 0
    end

    local towers = bot:GetNearbyTowers(700 + nRange, true)

    local attackRange       = bot:GetAttackRange()
    local targetLoc         = GetLaneFrontLocation(GetTeam(), lane, offset) - J.RandomForwardVector(attackRange)
    local distanceToTarget  = 0

    if towers ~= nil and #towers > 0 then
        distanceToTarget = #(targetLoc - towers[1]:GetLocation())
    end

    if towers ~= nil and #towers > 0 and distanceToTarget > attackRange then
        targetLoc = towers[1]:GetLocation() + (targetLoc - towers[1]:GetLocation()):Normalized() * attackRange
    end

    bot:ActionPush_MoveToLocation(targetLoc)

    local ancient = GetAncient(GetOpposingTeam())
    if GetUnitToUnitDistance(bot, ancient) < 1600 then
        if J.CanBeAttacked(ancient) then
            return bot:ActionPush_AttackUnit(ancient, false)
        end
    end

    local enemies = bot:GetNearbyHeroes(700 + nRange, true, BOT_MODE_NONE)
    if enemies ~= nil and #enemies > 0 and J.WeAreStronger(bot, 700)
    then
        return bot:ActionPush_AttackUnit(enemies[1], false)
    end

    local creeps = bot:GetNearbyLaneCreeps(700 + nRange, true)
    if creeps ~= nil and #creeps > 0
    then
        local targetCreep = creeps[1]

        for _, c in pairs(creeps) do
            if targetCreep:GetAttackDamage() < c:GetAttackDamage()
            then
                targetCreep = c
            end
        end

        return bot:ActionPush_AttackUnit(targetCreep, false)
    end

    local barracks = bot:GetNearbyBarracks(700 + nRange, true);
    if barracks ~= nil and #barracks > 0 then
        if J.CanBeAttacked(barracks[1]) then
            return bot:ActionPush_AttackUnit(barracks[1], false)
        end
    end

    if towers ~= nil and #towers > 0 then
        if J.CanBeAttacked(towers[1]) then
            return bot:ActionPush_AttackUnit(towers[1], false)
        end
    end

end

return Push