local Push = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local ShouldNotPushLane = false
local LanePushCooldown = 0
local LanePush = LANE_MID

local GlyphDuration = 7
local ShoulNotPushTower = false
local TowerPushCooldown = 0

local IsPushingInLaningPhase = false

function Push.GetPushDesire(bot, lane)
    if bot.laneToPush == nil then bot.laneToPush = lane end

    local maxDesire = 0.9
    local nMode = bot:GetActiveMode()
    local nModeDesire = bot:GetActiveModeDesire()

	if  (nMode == BOT_MODE_DEFEND_TOWER_TOP or nMode == BOT_MODE_DEFEND_TOWER_MID or nMode == BOT_MODE_DEFEND_TOWER_BOT)
    and nModeDesire > 0.75
    then
        maxDesire = 0.75
    end

    if  J.IsInLaningPhase()
    and bot:GetLevel() < 8
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
                IsPushingInLaningPhase = true
                return bot:GetActiveModeDesire() + 0.1
            end
        end

        IsPushingInLaningPhase = false

        if J.IsCore(bot) then return 0 end
        if bot:GetLevel() < 6 then return 0.1 end
    end

    IsPushingInLaningPhase = false

    if ShoulNotPushTower
    then
        if DotaTime() < TowerPushCooldown + GlyphDuration
        then
            return BOT_ACTION_DESIRE_NONE
        else
            ShoulNotPushTower = false
            TowerPushCooldown = 0
        end
    end

    if ShouldNotPushLane
    then
        if  DotaTime() < LanePushCooldown + 10
        and LanePush == lane
        then
            return BOT_MODE_DESIRE_NONE
        else
            ShouldNotPushLane = false
            LanePushCooldown = 0
        end
    end

    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)
    local allyKills = J.GetNumOfTeamTotalKills(false) + 1
    local enemyKills = J.GetNumOfTeamTotalKills(true) + 1
    local aAliveCoreCount = J.GetAliveCoreCount(false)
    local eAliveCoreCount = J.GetAliveCoreCount(true)
    local nPushDesire = RemapValClamped(GetPushLaneDesire(lane), 0, 1, 0, maxDesire)

    local botTarget = bot:GetAttackTarget()
    if J.IsValidBuilding(botTarget)
    then
        if  botTarget:HasModifier('modifier_fountain_glyph')
        and not (aAliveCount >= eAliveCount + 2)
        then
            ShoulNotPushTower = true
            TowerPushCooldown = DotaTime()
            return BOT_ACTION_DESIRE_NONE
        end

        if botTarget:HasModifier('modifier_backdoor_protection')
        or botTarget:HasModifier('modifier_backdoor_protection_in_base')
        or botTarget:HasModifier('modifier_backdoor_protection_active')
        then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if bot:WasRecentlyDamagedByTower(1.5)
    or J.GetHP(bot) < 0.45
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local enemyInLane = J.GetEnemyCountInLane(lane)
    if enemyInLane > 0
    then
        local nInRangeAlly = J.GetAlliesNearLoc(GetLaneFrontLocation(GetTeam(), lane, 0), 700)

        if  nInRangeAlly ~= nil
        and enemyInLane > (GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), lane, 0)) < 700 and #nInRangeAlly + 1 or #nInRangeAlly)
        then
            ShouldNotPushLane = true
            LanePushCooldown = DotaTime()
            LanePush = lane
            return BOT_MODE_DESIRE_NONE
        end
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

            if  J.IsCore(allyHero)
            and bot ~= allyHero
            and not J.IsPushing(allyHero)
            and not J.IsCore(bot)
            then
                return BOT_MODE_DESIRE_VERYLOW
            end
        end
    end

    -- General Push
    if eAliveCount == 0
    or aAliveCoreCount >= eAliveCoreCount
    or (aAliveCoreCount >= 1 and aAliveCount >= eAliveCount + 2)
    then
        if J.DoesTeamHaveAegis(GetUnitList(UNIT_LIST_ALLIED_HEROES))
        then
            local aegis = 1.3
            nPushDesire = nPushDesire * aegis
        end

        if aAliveCount >= eAliveCount
        then
            nPushDesire = nPushDesire * RemapValClamped(allyKills / enemyKills, 1, 2, 1, 2)
        end

        bot.laneToPush = lane
        return Clamp(nPushDesire, 0, maxDesire)
    end

    return BOT_MODE_DESIRE_NONE
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

    return LANE_MID
end

function Push.PushThink(bot, lane)
    if J.CanNotUseAction(bot) then return end

    local laneFrontLocation = GetLaneFrontLocation(GetTeam(), lane, 0)
    local enemyDistance = 0
    local enemyAlive = 0
    local teammateDistance = 0
    local teammateAlive = 0
    local nRange = bot:GetAttackRange()

    for _, id in pairs(GetTeamPlayers(GetOpposingTeam()))
    do
        if IsHeroAlive(id)
        then
            local info = GetHeroLastSeenInfo(id)

            if info.location ~= nil
            then
                enemyDistance = enemyDistance + math.max(#(info.location - laneFrontLocation), bot:GetCurrentVisionRange())
                enemyAlive = enemyAlive + 1
            end
        end
    end

    for _,id in pairs(GetTeamPlayers(GetTeam()))
    do
        if IsHeroAlive(id)
        then
            local info = GetHeroLastSeenInfo(id)

            if info.location ~= nil
            then
                teammateDistance = teammateDistance + #(info.location - laneFrontLocation)
                teammateAlive = teammateAlive + 1
            end
        end
    end

    local offset = -math.max(teammateDistance / teammateAlive - enemyDistance / enemyAlive, 0)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

    local targetLoc = GetLaneFrontLocation(GetTeam(), lane, offset)

    local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
    and #nInRangeEnemy > #nInRangeAlly
    then
        local enemyRange = 0
        local longestRangeHero = nil
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and enemyHero:GetAttackRange() > enemyRange
            then
                enemyRange = enemyHero:GetAttackRange()
                longestRangeHero = enemyHero
            end
		end

        if longestRangeHero ~= nil
        then
            if GetUnitToUnitDistance(bot, longestRangeHero) < enemyRange
            then
                bot:Action_MoveToLocation(J.GetEscapeLoc())
                return
            end
        end
    end

    local nEnemyAncient = GetAncient(GetOpposingTeam())
    if  GetUnitToUnitDistance(bot, nEnemyAncient) < 1600
    and J.CanBeAttacked(nEnemyAncient)
    then
        bot:Action_AttackUnit(nEnemyAncient, false)
        return
    end

    local nCreeps = bot:GetNearbyLaneCreeps(700 + nRange, true)
    if J.IsCore(bot)
    or (not J.IsCore(bot) and not J.IsThereCoreNearby(800) and J.GetDistance(bot:GetLocation(), targetLoc) < 1600)
    then
        nCreeps = bot:GetNearbyCreeps(700 + nRange, true)
    end

    if  nCreeps ~= nil and #nCreeps > 0
    and J.CanBeAttacked(nCreeps[1])
    and not IsPushingInLaningPhase
    then
        bot:Action_AttackUnit(nCreeps[1], false)
        return
    end

    local nBarracks = bot:GetNearbyBarracks(700 + nRange, true)
    if  nBarracks ~= nil and #nBarracks > 0
    and Push.CanBeAttacked(nBarracks[1])
    then
        bot:Action_AttackUnit(nBarracks[1], false)
        return
    end

    if  nEnemyTowers ~= nil and #nEnemyTowers > 0
    and Push.CanBeAttacked(nEnemyTowers[1])
    then
        bot:Action_AttackUnit(nEnemyTowers[1], false)
        return
    end

    local sEnemyTowers = bot:GetNearbyFillers(700 + nRange, true)
    if  sEnemyTowers ~= nil and #sEnemyTowers > 0
    and Push.CanBeAttacked(sEnemyTowers[1])
    then
        bot:Action_AttackUnit(sEnemyTowers[1], false)
        return
    end

    bot:Action_MoveToLocation(targetLoc)
end

function Push.CanBeAttacked(building)
    if  building ~= nil
    and building:CanBeSeen()
    and not building:IsInvulnerable()
    then
        return true
    end

    return false
end

return Push