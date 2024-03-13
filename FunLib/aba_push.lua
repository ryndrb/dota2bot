local Push = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

function Push.GetPushDesire(bot, lane)
    if J.IsInLaningPhase()
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(1200, false)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and nAllyLaneCreeps ~= nil and #nAllyLaneCreeps >= 2
        and bot:GetAssignedLane() == lane
        and not (bot:WasRecentlyDamagedByTower(1) or bot:WasRecentlyDamagedByAnyHero(1))
        and not J.IsRetreating(bot)
        then
            local nEnemyTowers = bot:GetNearbyTowers(1200, true)

            if nEnemyTowers ~= nil and #nEnemyTowers >= 1
            then
                return bot:GetActiveModeDesire() + 0.1
            end
        end

        if J.IsCore(bot) then return 0 end
        if bot:GetLevel() < 6 then return 0.1 end
    end

    local maxDesire = 0.75
    local nMode = bot:GetActiveMode()
    local nModeDesire = bot:GetActiveModeDesire()

	if  (nMode == BOT_MODE_DEFEND_TOWER_TOP or nMode == BOT_MODE_DEFEND_TOWER_MID or nMode == BOT_MODE_DEFEND_TOWER_BOT)
    and nModeDesire > 0.75
    then
        maxDesire = 0.5
    end

    local botTarget = bot:GetAttackTarget()
    if  J.IsValidBuilding(botTarget)
    and (botTarget:HasModifier('modifier_backdoor_protection')
        or botTarget:HasModifier('modifier_backdoor_protection_in_base')
        or botTarget:HasModifier('modifier_backdoor_protection_active'))
    then
        return 0.1
    end

    local aliveHeroesList = {}
    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    do
        if  J.IsValidHero(allyHero)
        and not allyHero:IsIllusion()
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
        then
            table.insert(aliveHeroesList, allyHero)

            if J.GetPosition(bot) == 4
            or J.GetPosition(bot) == 5
            then
                if J.GetPosition(allyHero) == 1
                or J.GetPosition(allyHero) == 2
                or J.GetPosition(allyHero) == 3
                then
                    if  J.IsNotSelf(bot, allyHero)
                    and not J.IsPushing(allyHero)
                    then
                        return 0.1
                    end
                end
            end
        end
    end

    local nNearByAlliesLanePush = {
        [LANE_TOP] = BOT_MODE_PUSH_TOWER_TOP,
        [LANE_MID] = BOT_MODE_PUSH_TOWER_MID,
        [LANE_BOT] = BOT_MODE_PUSH_TOWER_BOT,
    }

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    -- local nAllyHeroes = bot:GetNearbyHeroes(1600, false, nNearByAlliesLanePush[lane])
    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

    if (nEnemyHeroes ~= nil and nAllyHeroes ~= nil
        and #nEnemyHeroes > #nAllyHeroes)
    or bot:WasRecentlyDamagedByTower(1.5)
    or J.GetHP(bot) < 0.45
    then
        return 0.1
    end

    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)

    local laneFrontAmount = GetLaneFrontAmount(GetTeam(), lane, true)
    local laneFrontAmountEnemy = 1 - GetLaneFrontAmount(GetOpposingTeam(), lane, true)
    if not J.IsInLaningPhase()
    then
        if  laneFrontAmount < 0.5
        and laneFrontAmountEnemy > 0.5
        then
            local dist = GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), lane, 0))
            local isCorePushing = false

            for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
            do
                if  J.IsValidHero(allyHero)
                and not J.IsSuspiciousIllusion(allyHero)
                and not J.IsMeepoClone(allyHero)
                and J.IsCore(allyHero)
                and J.IsNotSelf(bot, allyHero)
                then
                    if allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP and lane == LANE_TOP
                    or allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID and lane == LANE_MID
                    or allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and lane == LANE_BOT
                    then
                        isCorePushing = true
                        break
                    end
                end
            end

            if not isCorePushing
            then
                return RemapValClamped(dist, 4000, 1000, 0, 0.75)
            end
        end
    end

    if Push.WhichLaneToPush(bot) == lane
    then
        local nPushDesire = RemapValClamped(GetPushLaneDesire(lane), 0, 1, 0, maxDesire)

        if J.DoesTeamHaveAegis(GetUnitList(UNIT_LIST_ALLIED_HEROES))
        then
            local aegis = 1.3
            nPushDesire = nPushDesire * aegis
        end

        local tot = ((aAliveCount - eAliveCount) / (aAliveCount + eAliveCount)) * 0.15

        return Clamp(nPushDesire, 0, maxDesire + tot)
    end

    return 0.1
end

local TeamLocation = {}
function Push.WhichLaneToPush(bot)

    TeamLocation[bot:GetPlayerID()] = bot:GetLocation()

    local distanceToTop = 0
    local distanceToMid = 0
    local distanceToBot = 0

    for _, id in pairs(GetTeamPlayers(GetTeam()))
    do
        if TeamLocation[id] ~= nil
        then
            if IsHeroAlive(id)
            then
                distanceToTop = distanceToTop + math.max(distanceToTop, #(GetLaneFrontLocation(GetTeam(), LANE_TOP, 0.0) - TeamLocation[id]))
                distanceToMid = distanceToMid + math.max(distanceToMid, #(GetLaneFrontLocation(GetTeam(), LANE_MID, 0.0) - TeamLocation[id]))
                distanceToBot = distanceToBot + math.max(distanceToBot, #(GetLaneFrontLocation(GetTeam(), LANE_BOT, 0.0) - TeamLocation[id]))
            end
        end
    end

    if  distanceToTop < distanceToMid
    and distanceToTop < distanceToBot
    then
        return LANE_TOP
    end

    if  distanceToMid < distanceToTop
    and distanceToMid < distanceToBot
    then
        return LANE_MID
    end

    if  distanceToBot < distanceToTop
    and distanceToBot < distanceToMid
    then
        return LANE_BOT
    end

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

    bot:Action_MoveToLocation(targetLoc)

    local ancient = GetAncient(GetOpposingTeam())
    if GetUnitToUnitDistance(bot, ancient) < 1600 then
        if J.CanBeAttacked(ancient) then
            return bot:Action_AttackUnit(ancient, false)
        end
    end

    local enemies = bot:GetNearbyHeroes(700 + nRange, true, BOT_MODE_NONE)
    if enemies ~= nil and #enemies > 0 and J.WeAreStronger(bot, 700)
    then
        return bot:Action_AttackUnit(enemies[1], false)
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

        return bot:Action_AttackUnit(targetCreep, false)
    end

    local barracks = bot:GetNearbyBarracks(700 + nRange, true);
    if barracks ~= nil and #barracks > 0 then
        if J.CanBeAttacked(barracks[1]) then
            return bot:Action_AttackUnit(barracks[1], false)
        end
    end

    if towers ~= nil and #towers > 0 then
        if J.CanBeAttacked(towers[1]) then
            return bot:Action_AttackUnit(towers[1], false)
        end
    end

end

return Push