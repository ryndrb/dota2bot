local Push = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local pingTimeDelta = 5

function Push.GetPushDesire(bot, lane)
    local nMaxDesire = BOT_MODE_DESIRE_HIGH
    local botActiveMode = bot:GetActiveMode()
    local bMyLane = bot:GetAssignedLane() == lane

	if (not bMyLane and J.IsCore(bot) and J.IsInLaningPhase())
    or ((#J.GetAlliesNearLoc(J.GetTormentorLocation(GetTeam()), 1600) >= 3) or #J.GetAlliesNearLoc(J.GetTormentorWaitingLocation(GetTeam()), 2500) >= 3)
    or (J.IsGoingToRune(bot))
	then
		return BOT_MODE_DESIRE_NONE
	end

    for i = 1, 5 do
		local member = GetTeamMember(i)
        if member ~= nil and member:GetLevel() < 6 then return BOT_MODE_DESIRE_NONE end
    end

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

    local nInRangeAlly_core = {}
    for _, ally in pairs(nInRangeAlly) do
        if J.IsValidHero(ally) and J.IsCore(ally) then
            table.insert(nInRangeAlly_core, ally)
        end
    end

    local nInRangeEnemy_core = {}
    for _, enemy in pairs(nInRangeEnemy) do
        if J.IsValidHero(enemy) and J.IsCore(enemy) then
            table.insert(nInRangeEnemy_core, enemy)
        end
    end

    if (#nInRangeAlly  < #nInRangeEnemy and #nInRangeAlly_core < #nInRangeEnemy_core)
    or (#nInRangeAlly >= #nInRangeEnemy and bot:WasRecentlyDamagedByAnyHero(5.0))
    then
        return BOT_MODE_DESIRE_NONE
    end

    local human, humanPing = J.GetHumanPing()
	if human ~= nil and humanPing ~= nil and not humanPing.normal_ping and DotaTime() > 0 then
		local isPinged, pingedLane = J.IsPingCloseToValidTower(GetOpposingTeam(), humanPing, 700, 5.0)
		if isPinged and lane == pingedLane and GameTime() < humanPing.time + pingTimeDelta then
			return BOT_MODE_DESIRE_VERYHIGH
		end
	end

	-- finish camps
	if J.IsFarming(bot) and (J.IsCore(bot) or bot:GetNetWorth() >= 15500) then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(Min(bot:GetAttackRange() + 200, 1600))
		if #nNeutralCreeps > 0 then
			return BOT_MODE_DESIRE_NONE
		end
	end

    local hEnemyAncient = GetAncient(GetOpposingTeam())
    if hEnemyAncient then
        if J.IsDoingTormentor(bot) and GetUnitToUnitDistance(bot, hEnemyAncient) > 4000 then
            return BOT_MODE_DESIRE_NONE
        end
    end

    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)
    local allyKills = J.GetNumOfTeamTotalKills(false) + 1
    local enemyKills = J.GetNumOfTeamTotalKills(true) + 1
    local aAliveCoreCount = J.GetAliveCoreCount(false)
    local eAliveCoreCount = J.GetAliveCoreCount(true)
    local hAncient = GetAncient(GetTeam())
    local nPushDesire = RemapValClamped(GetPushLaneDesire(lane), 0, 1, 0, nMaxDesire)

    -- -- mulling
    -- local vEnemyLaneFrontLocation = GetLaneFrontLocation(GetOpposingTeam(), lane, 0)
    -- if Push.ShouldWaitForImportantItemsSpells(vEnemyLaneFrontLocation)
    -- and (  eAliveCount >= aAliveCount
    --     or eAliveCount >= aAliveCount and eAliveCoreCount >= aAliveCoreCount
    --     )
    -- then
    --     return BOT_MODE_DESIRE_NONE
    -- end

    local nEnemyTowers = bot:GetNearbyTowers(1600, true)
    if nEnemyTowers == nil then nEnemyTowers = bot:GetNearbyBarracks(1600, true) end

    if J.IsValidBuilding(nEnemyTowers[1])
    and not string.find(nEnemyTowers[1]:GetUnitName(), 'tower1')
    and not string.find(nEnemyTowers[1]:GetUnitName(), 'tower2')
    then
        if nEnemyTowers[1]:HasModifier('modifier_backdoor_protection')
        or nEnemyTowers[1]:HasModifier('modifier_backdoor_protection_in_base')
        or nEnemyTowers[1]:HasModifier('modifier_backdoor_protection_active')
        then
            return BOT_MODE_DESIRE_NONE
        end
    end

    local furthestBuildingEnemy = J.GetFurthestBuildingAlongLane(GetOpposingTeam(), lane)
    local vLaneFrontLocation_Enemy = GetLaneFrontLocation(GetOpposingTeam(), lane, 0)

    -- farm pushed in lanes
    if  J.GetDistance(vLaneFrontLocation_Enemy, J.GetTeamFountain()) < 5500
    and GetUnitToLocationDistance(bot, vLaneFrontLocation_Enemy) < 4200
    and not J.IsEnemyHeroAroundLocation(vLaneFrontLocation_Enemy, 1600, 5.0)
    then
        local nLocationAoE = bot:FindAoELocation(false, false, furthestBuildingEnemy:GetLocation(), 0, 1200, 0, 0)
        if nLocationAoE.count >= 3
        or bot:GetEstimatedDamageToTarget(true, bot, 5.0, DAMAGE_TYPE_PHYSICAL) >= 450.0
        then
            return BOT_MODE_DESIRE_VERYHIGH
        end
    end

    -- if safe, push tierX tower
    if J.IsValidBuilding(furthestBuildingEnemy) then
        if  J.CanBeAttacked(furthestBuildingEnemy)
        and J.IsInRange(bot, furthestBuildingEnemy, 1200)
        and not J.IsRetreating(bot)
        and (J.IsTier1(furthestBuildingEnemy, GetOpposingTeam()) or J.IsTier2(furthestBuildingEnemy, GetOpposingTeam()))
        then
            if not J.IsFarming(bot) or J.GetHP(furthestBuildingEnemy) < 0.2 then
                local nLocationAoE = bot:FindAoELocation(false, false, furthestBuildingEnemy:GetLocation(), 0, 800, 0, 0)
                if nLocationAoE.count >= 3 and not bot:WasRecentlyDamagedByTower(3.0) and not J.IsEnemyHeroAroundLocation(furthestBuildingEnemy:GetLocation(), 1400, 5.0) then
                    return nMaxDesire
                end
            end
        end
    end

    -- General Push
    if Push.WhichLaneToPush(bot, lane) == lane then
        if eAliveCount == 0
        or aAliveCoreCount >= eAliveCoreCount
        or (aAliveCoreCount >= 1 and aAliveCount >= eAliveCount + 2)
        or (GetUnitToUnitDistance(bot, GetAncient(GetOpposingTeam())) < 3500 and #nInRangeAlly >= #nInRangeEnemy)
        then
            if not J.IsEarlyGame() then
                local teamNetworth, enemyNetworth = J.GetInventoryNetworth()
                if J.DoesTeamHaveAegis() and aAliveCount >= 4 then
                    local factor = (J.IsLateGame() or (teamNetworth - enemyNetworth > 11000)) and BOT_MODE_DESIRE_HIGH or BOT_MODE_DESIRE_LOW
                    nPushDesire = nPushDesire + factor
                end

                if aAliveCount >= eAliveCount and J.GetAverageLevel(GetTeam()) >= 12 then
                    nPushDesire = nPushDesire + RemapValClamped(teamNetworth - enemyNetworth, 5000, 10000, 0.0, BOT_MODE_DESIRE_MODERATE)
                end

                local pushingLane = { [LANE_TOP] = BOT_MODE_PUSH_TOWER_TOP, [LANE_MID] = BOT_MODE_PUSH_TOWER_MID, [LANE_BOT] = BOT_MODE_PUSH_TOWER_BOT }
                local countPushingAlliesNearby = #J.GetSpecialModeAllies(bot, 900, pushingLane[lane])
                local factor = J.IsLateGame() and BOT_MODE_DESIRE_MODERATE or BOT_MODE_DESIRE_LOW
                nPushDesire = nPushDesire + countPushingAlliesNearby * (factor / 5)
            end

            return Clamp(nPushDesire, 0, nMaxDesire)
        end
    end

    local _, closestLane = J.GetClosestTeamLane(bot)
	if closestLane == lane then
        local laneDistThres = { [LANE_TOP] = 12000, [LANE_MID] = 8500, [LANE_BOT] = 12000 }
        if J.GetDistance(vLaneFrontLocation_Enemy, J.GetTeamFountain()) < laneDistThres[lane] and not J.IsEnemyHeroAroundLocation(vLaneFrontLocation_Enemy, 1400, 3.0) then
            return BOT_MODE_DESIRE_LOW
        end
	end

    return BOT_MODE_DESIRE_NONE
end

function Push.WhichLaneToPush(bot, lane)
    local topLaneScore = 0
    local midLaneScore = 0
    local botLaneScore = 0

    local vLaneFrontLocationTop = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)
    local vLaneFrontLocationMid = GetLaneFrontLocation(GetTeam(), LANE_MID, 0)
    local vLaneFrontLocationBot = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)
    local topBuilding = J.GetFurthestBuildingAlongLane(GetOpposingTeam(), LANE_TOP)
    local midBuilding = J.GetFurthestBuildingAlongLane(GetOpposingTeam(), LANE_MID)
    local botBuilding = J.GetFurthestBuildingAlongLane(GetOpposingTeam(), LANE_BOT)

    -- distance and enemy scores; should more likely to consider a lane closest to a human/core
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if J.IsValidHero(member) then
            local topDist = GetUnitToLocationDistance(member, vLaneFrontLocationTop) * 0.9 * 0.6
            local midDist = GetUnitToLocationDistance(member, vLaneFrontLocationMid)       * 0.6
            local botDist = GetUnitToLocationDistance(member, vLaneFrontLocationBot) * 0.9 * 0.6
            topDist = topDist + GetUnitToUnitDistance(member, topBuilding) * 0.9 * 0.4
            midDist = midDist + GetUnitToUnitDistance(member, midBuilding)       * 0.4
            botDist = botDist + GetUnitToUnitDistance(member, botBuilding) * 0.9 * 0.4

            if J.IsCore(member) or not member:IsBot() then
                topDist = topDist * 0.5
                midDist = midDist * 0.5
                botDist = botDist * 0.5
            elseif not J.IsCore(member) then
                topDist = topDist * 1.2
                midDist = midDist * 1.2
                botDist = botDist * 1.2
            end

            topLaneScore = topLaneScore + topDist
            midLaneScore = midLaneScore + midDist
            botLaneScore = botLaneScore + botDist
        end
    end

    local count1 = 0
    local count2 = 0
    local count3 = 0
    for _, id in pairs( GetTeamPlayers(GetOpposingTeam())) do
        if IsHeroAlive(id) then
            local info = GetHeroLastSeenInfo(id)
            if info ~= nil then
                local dInfo = info[1]
                if dInfo ~= nil then
                    if     J.GetDistance(vLaneFrontLocationTop, dInfo.location) <= 1600 then
                        count1 = count1 + 1
                    elseif J.GetDistance(vLaneFrontLocationMid, dInfo.location) <= 1600 then
                        count2 = count2 + 1
                    elseif J.GetDistance(vLaneFrontLocationBot, dInfo.location) <= 1600 then
                        count3 = count3 + 1
                    end
                end
            end
        end
    end

    local hTeleports = GetIncomingTeleports()
    for _, tp in pairs(hTeleports) do
        if tp ~= nil and Push.IsEnemyTP(tp.playerid) then
            if     J.GetDistance(vLaneFrontLocationTop, tp.location) <= 1600 then
                count1 = count1 + 1
            elseif J.GetDistance(vLaneFrontLocationMid, tp.location) <= 1600 then
                count2 = count2 + 1
            elseif J.GetDistance(vLaneFrontLocationBot, tp.location) <= 1600 then
                count3 = count3 + 1
            end
        end
    end

    topLaneScore = topLaneScore * (0.05 * count1 + 1)
    midLaneScore = midLaneScore * (0.05 * count2 + 1)
    botLaneScore = botLaneScore * (0.05 * count3 + 1)

    -- tower scores; should more likely consider taking out outer tower first, ^ unless overwhelmingly closer (case above)
    local topLaneTier = Push.GetLaneBuildingTier(LANE_TOP)
    local midLaneTier = Push.GetLaneBuildingTier(LANE_MID)
    local botLaneTier = Push.GetLaneBuildingTier(LANE_BOT)

    topLaneScore = topLaneScore * RemapValClamped(topLaneTier, 1, 3, 0.25, 1)
    midLaneScore = midLaneScore * RemapValClamped(midLaneTier, 1, 3, 0.25, 1)
    botLaneScore = botLaneScore * RemapValClamped(botLaneTier, 1, 3, 0.25, 1)

    topLaneScore = topLaneScore * (Max(0.1, 1 - GetPushLaneDesire(LANE_TOP)))
    midLaneScore = midLaneScore * (Max(0.1, 1 - GetPushLaneDesire(LANE_MID)))
    botLaneScore = botLaneScore * (Max(0.1, 1 - GetPushLaneDesire(LANE_BOT)))

    if  topLaneScore < midLaneScore
    and topLaneScore < botLaneScore
    then
        return LANE_TOP
    end

    if  midLaneScore < topLaneScore
    and midLaneScore < botLaneScore
    then
        return LANE_MID
    end

    if  botLaneScore < topLaneScore
    and botLaneScore < midLaneScore
    then
        return LANE_BOT
    end

    return LANE_MID
end

local fNextMovementTime = 0
function Push.PushThink(bot, lane)
    if J.CanNotUseAction(bot) then return end

    local botAttackRange = bot:GetAttackRange()
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)
    local nAllyCreeps = bot:GetNearbyLaneCreeps(1200, false)
    local hEnemyAncient = GetAncient(GetOpposingTeam())
    local bHasPierceTheVeil = bot:HasModifier('modifier_muerta_pierce_the_veil_buff')

    local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), lane, 0)

    local nAllyHeroes = J.GetAlliesNearLoc(vLaneFrontLocation, 1600)
    local nEnemyHeroes = J.GetEnemiesNearLoc(vLaneFrontLocation, 1600)

    if #nAllyHeroes < #nEnemyHeroes then
        local nFurthestEnemyAttackRange = 0
		local vTargetLocation = vLaneFrontLocation
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero) and not enemyHero:HasModifier('modifier_teleporting') then
                local sEnemyHeroName = enemyHero:GetUnitName()
				local enemyHeroAttackRange = enemyHero:GetAttackRange()
				if J.HasItem(enemyHero, 'item_blink')
				or J.HasItem(enemyHero, 'item_overwhelming_blink')
				or J.HasItem(enemyHero, 'item_swift_blink')
				or J.HasItem(enemyHero, 'item_arcane_blink')
				or J.HasItem(enemyHero, 'item_fallen_sky')
                or sEnemyHeroName == 'npc_dota_hero_antimage'
                or sEnemyHeroName == 'npc_dota_hero_queenofpain'
				then
					enemyHeroAttackRange = Max(enemyHeroAttackRange, 1200)
				end

				if enemyHeroAttackRange > nFurthestEnemyAttackRange then
					nFurthestEnemyAttackRange = enemyHeroAttackRange
				end

				local enemyHeroDistance = GetUnitToLocationDistance(enemyHero, J.GetTeamFountain())
				if enemyHeroDistance < J.GetDistance(vLaneFrontLocation, J.GetTeamFountain()) then
					vTargetLocation = enemyHero:GetLocation()
				end
			end
		end

        if nFurthestEnemyAttackRange > 0 then
			local vLocation = J.VectorAway(vTargetLocation, vLaneFrontLocation, nFurthestEnemyAttackRange + J.GetDistance(vTargetLocation, vLaneFrontLocation))
            local dist = GetUnitToLocationDistance(bot, vLocation)
            if dist < 350 then
                bot:Action_AttackMove(vLocation + RandomVector(100))
                return
            end

			if DotaTime() >= fNextMovementTime then
                bot:Action_MoveToLocation(vLocation + RandomVector(100))
				fNextMovementTime = DotaTime() + RandomFloat(0.3, 0.9)
			end

			return
		end
    end

    local targetLoc = GetLaneFrontLocation(GetTeam(), lane, 0)

    local nUnitList = GetUnitList(UNIT_LIST_ENEMY_BUILDINGS)
    local bBuildingGlyphedBackdoor = Push.IsBuildingGlyphedBackdoor(nUnitList)

    if bBuildingGlyphedBackdoor then
        local building = J.GetFurthestBuildingAlongLane(GetOpposingTeam(), lane)
        if building and building:IsTower() then
            targetLoc = Push.GetAdjustedHoldPosition(bot, building)
        end
    end

    if Push.DropTowerAggro(bot) then return end

    nAllyHeroes = J.GetAlliesNearLoc(hEnemyAncient:GetLocation(), 1600)
    if  GetUnitToUnitDistance(bot, hEnemyAncient) < 1600
    and J.CanBeAttacked(hEnemyAncient)
    and not bHasPierceTheVeil
    and (  #Push.GetAllyHeroesAttackingUnit(hEnemyAncient) >= 3
        or #Push.GetAllyCreepsAttackingUnit(hEnemyAncient) >= 4
        or hEnemyAncient:GetHealthRegen() < 20
        or #nAllyHeroes >= 4)
    then
        bot:Action_AttackUnit(hEnemyAncient, true)
        return
    end

    local nRange = math.min(700 + botAttackRange, 1600)
    if bBuildingGlyphedBackdoor then nRange = Min(botAttackRange, 1600) end

    local nInRangeAlly = J.GetAlliesNearLoc(hEnemyAncient:GetLocation(), 3200)
    local nCreeps = bot:GetNearbyLaneCreeps(nRange, true)
    if ((bot:GetAttackDamage() / bot:GetSecondsPerAttack()) * 5.0 >= 2800)
    then
        nCreeps = bot:GetNearbyCreeps(nRange, true)
    end
    nCreeps = Push.GetSpecialUnitsNearby(bot, nCreeps, nRange)

    local vTeamFountain = J.GetTeamFountain()
    local bTowerNearby = false
    if J.IsValidBuilding(nEnemyTowers[1]) then
        bTowerNearby = true
    end

    for _, creep in pairs(nCreeps) do
        if J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and (not bTowerNearby
            or (bTowerNearby and GetUnitToLocationDistance(creep, vTeamFountain) < GetUnitToLocationDistance(nEnemyTowers[1], vTeamFountain)))
        and not J.IsTormentor(creep)
        and not J.IsRoshan(creep)
        then
            bot:Action_AttackUnit(creep, false)
            return
        end
    end

    if GetUnitToUnitDistance(bot, hEnemyAncient) <= 4000
    and (  not (GetTower(GetOpposingTeam(), TOWER_TOP_2) ~= nil and GetTower(GetOpposingTeam(), TOWER_TOP_2):IsAlive())
        or not (GetTower(GetOpposingTeam(), TOWER_MID_2) ~= nil and GetTower(GetOpposingTeam(), TOWER_MID_2):IsAlive())
        or not (GetTower(GetOpposingTeam(), TOWER_BOT_2) ~= nil and GetTower(GetOpposingTeam(), TOWER_BOT_2):IsAlive())
        )
    and not bHasPierceTheVeil
    then
        local hBuildingTarget = TryClearingOtherLaneHighGround(bot, targetLoc)
        if hBuildingTarget then
            bot:Action_AttackUnit(hBuildingTarget, true)
            return
        end
    end

    local nBarracks = bot:GetNearbyBarracks(nRange, true)
    if J.IsValidBuilding(nBarracks[1]) and J.CanBeAttacked(nBarracks[1]) and not bHasPierceTheVeil then
        for _, barrack in pairs(nBarracks) do
            if J.IsValid(barrack) and string.find(barrack:GetUnitName(), 'range') then
                bot:Action_AttackUnit(barrack, true)
                return
            end
        end
        for _, barrack in pairs(nBarracks) do
            if J.IsValid(barrack) and string.find(barrack:GetUnitName(), 'melee') then
                bot:Action_AttackUnit(barrack, true)
                return
            end
        end
    end

    if J.IsValidBuilding(nEnemyTowers[1]) and J.CanBeAttacked(nEnemyTowers[1]) and not bHasPierceTheVeil then
        local hTowerTarget = nil
        local hTowerTargetDistance = math.huge
        for _, tower in pairs(nEnemyTowers) do
            if J.IsValidBuilding(tower) and J.CanBeAttacked(tower) then
                local towerDistance = GetUnitToLocationDistance(tower, targetLoc)
                if towerDistance < hTowerTargetDistance then
                    hTowerTarget = tower
                    hTowerTargetDistance = towerDistance
                end
            end
        end

        if hTowerTarget then
            bot:Action_AttackUnit(hTowerTarget, true)
            return
        end
    end

    local nEnemyFillers = bot:GetNearbyFillers(nRange, true)
    if J.IsValidBuilding(nEnemyFillers[1]) and J.CanBeAttacked(nEnemyFillers[1]) and not bHasPierceTheVeil then
        local hTowerFillerTarget = nil
        local hTowerFillerTargetDistance = math.huge
        for _, filler in pairs(nEnemyFillers) do
            if J.CanBeAttacked(filler) then
                local fillerTowerDistance = GetUnitToLocationDistance(filler, targetLoc)
                if fillerTowerDistance < hTowerFillerTargetDistance then
                    hTowerFillerTarget = filler
                    hTowerFillerTargetDistance = fillerTowerDistance
                end
            end
        end

        if hTowerFillerTarget then
            bot:Action_AttackUnit(hTowerFillerTarget, true)
            return
        end
    end

    if GetUnitToLocationDistance(bot, targetLoc) > 500 then
        bot:Action_MoveToLocation(targetLoc)
        return
    else
        if DotaTime() >= fNextMovementTime then
            bot:Action_MoveToLocation(J.GetRandomLocationWithinDist(targetLoc, 0, 400))
            fNextMovementTime = DotaTime() + RandomFloat(0.05, 0.3)
            return
        end
    end
end

function Push.DropTowerAggro(hUnit)
	if J.IsValid(hUnit) then
        if J.CanNotUseAction(hUnit) or hUnit:IsDisarmed() then return false end

        local nUnitList = GetUnitList(UNIT_LIST_ENEMY_BUILDINGS)
        for _, buliding in pairs(nUnitList) do
            if  J.IsValidBuilding(buliding)
            and buliding:IsTower()
            and buliding:GetAttackTarget() == hUnit
            and not buliding:HasModifier('modifier_fountain_glyph')
            then
                local nAllyCreeps = hUnit:GetNearbyLaneCreeps(700, false)
                for _, creep in pairs(nAllyCreeps) do
                    if J.IsValid(creep) and GetUnitToUnitDistance(creep, buliding) < 700 then
                        hUnit:Action_AttackUnit(creep, false)
                        return true
                    end
                end

                if (hUnit:GetActualIncomingDamage(buliding:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL) / hUnit:GetHealth()) > 0.3 then
                    hUnit:Action_MoveToLocation(J.GetTeamFountain())
                    return true
                end
            end
        end
	end

    return false
end

local function IsInTowerRange(vLoc)
    for _, b in pairs(GetUnitList(UNIT_LIST_ENEMY_BUILDINGS)) do
        if b and b:IsTower() and GetUnitToLocationDistance(b, vLoc) < 900 then
            return true
        end
    end
    return false
end
function Push.GetAdjustedHoldPosition(bot, building)

    local vBuildingLocation = building:GetLocation()
    local targetLoc = J.VectorTowards(vBuildingLocation, bot:GetLocation(), 1200)

    -- highground relevant
    if IsInTowerRange(targetLoc) then
        local nBaseAngle = math.atan(targetLoc.y - vBuildingLocation.y, targetLoc.x - vBuildingLocation.x)
        local cwResult, ccwResult = nil, nil

        for step = 1, 18 do
            if not cwResult then
                local angle = nBaseAngle + step * (math.pi / 18)
                local candidate = vBuildingLocation + Vector(math.cos(angle) * 1200, math.sin(angle) * 1200, 0)
                if not IsInTowerRange(candidate) then cwResult = candidate end
            end

            if not ccwResult then
                local angle = nBaseAngle - step * (math.pi / 18)
                local candidate = vBuildingLocation + Vector(math.cos(angle) * 1200, math.sin(angle) * 1200, 0)
                if not IsInTowerRange(candidate) then ccwResult = candidate end
            end

            if cwResult and ccwResult then break end
        end

        if cwResult and ccwResult then
            -- pick whichever was found at a smaller angular step (closer to original)
            -- if both were found at the same step, just pick ccw as tiebreak
            targetLoc = GetUnitToLocationDistance(bot, cwResult) < GetUnitToLocationDistance(bot, ccwResult)
                        and cwResult or ccwResult
        elseif cwResult then
            targetLoc = cwResult
        elseif ccwResult then
            targetLoc = ccwResult
        end
    end

    return targetLoc
end

function TryClearingOtherLaneHighGround(bot, vLocation)
    local unitList = GetUnitList(UNIT_LIST_ENEMY_BUILDINGS)
    local function IsValid(building)
        return  J.IsValidBuilding(building)
            and J.CanBeAttacked(building)
            and not building:HasModifier('modifier_backdoor_protection')
            and not building:HasModifier('modifier_backdoor_protection_in_base')
            and not building:HasModifier('modifier_backdoor_protection_active')
    end

    local hBarrackTarget = nil
    local hBarrackTargetDistance = math.huge
    for _, barrack in pairs(unitList) do
        if IsValid(barrack)
        and (  barrack == GetBarracks(GetOpposingTeam(), BARRACKS_TOP_RANGED)
            or barrack == GetBarracks(GetOpposingTeam(), BARRACKS_TOP_MELEE)
            or barrack == GetBarracks(GetOpposingTeam(), BARRACKS_MID_RANGED)
            or barrack == GetBarracks(GetOpposingTeam(), BARRACKS_MID_MELEE)
            or barrack == GetBarracks(GetOpposingTeam(), BARRACKS_BOT_RANGED)
            or barrack == GetBarracks(GetOpposingTeam(), BARRACKS_BOT_MELEE))
        then
            local barrackDistance = GetUnitToLocationDistance(barrack, vLocation)
            if barrackDistance < hBarrackTargetDistance then
                hBarrackTarget = barrack
                hBarrackTargetDistance = barrackDistance
            end
        end
    end
    if hBarrackTarget then
        return hBarrackTarget
    end

    local hTowerTarget = nil
    local hTowerTargetDistance = math.huge
    for _, tower in pairs(unitList) do
        if IsValid(tower) and (tower == GetTower(GetOpposingTeam(), TOWER_TOP_3) or tower == GetTower(GetOpposingTeam(), TOWER_MID_3) or tower == GetTower(GetOpposingTeam(), TOWER_BOT_3)) then
            local towerDistance = GetUnitToLocationDistance(tower, vLocation)
            if towerDistance < hTowerTargetDistance then
                hTowerTarget = tower
                hTowerTargetDistance = towerDistance
            end
        end
    end
    if hTowerTarget then
        return hTowerTarget
    end
end

function Push.CanBeAttacked(building)
    if  building ~= nil
    and building:CanBeSeen()
    and not building:IsInvulnerable()
    then
        return true
    end
end

function Push.IsEnemyTP(nID)
    for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
        if id == nID then
            return true
        end
    end

    return false
end

function Push.IsInDangerWithinTower(hUnit, fThreshold, fDuration)
    local totalDamage = 0
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
        if J.IsValid(enemy)
        and J.IsInRange(hUnit, enemy, 1600)
        and (enemy:GetAttackTarget() == hUnit or J.IsChasingTarget(enemy, hUnit)) then
            totalDamage = totalDamage + hUnit:GetActualIncomingDamage((enemy:GetAttackDamage() / enemy:GetSecondsPerAttack()) * fDuration, DAMAGE_TYPE_PHYSICAL)
        end
    end

    local hUnitHealth = hUnit:GetHealth()
    return (totalDamage / hUnitHealth * 1.2) > fThreshold
end

function Push.GetSpecialUnitsNearby(bot, hUnitList, nRadius)
    local hCreepList = hUnitList
    for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
        if unit ~= nil and unit:CanBeSeen() and J.IsInRange(bot, unit, nRadius) then
            local sUnitName = unit:GetUnitName()
            if string.find(sUnitName, 'invoker_forge_spirit')
            or string.find(sUnitName, 'lycan_wolf')
            or string.find(sUnitName, 'eidolon')
            or string.find(sUnitName, 'beastmaster_boar')
            or string.find(sUnitName, 'beastmaster_greater_boar')
            or string.find(sUnitName, 'furion_treant')
            or string.find(sUnitName, 'broodmother_spiderling')
            or string.find(sUnitName, 'skeleton_warrior')
            or string.find(sUnitName, 'warlock_golem')
            or unit:HasModifier('modifier_dominated')
            or unit:HasModifier('modifier_chen_holy_persuasion')
            then
                table.insert(hCreepList, unit)
            end
        end
    end

    return hCreepList
end

function Push.IsBuildingGlyphedBackdoor(nUnitList)
    for _, building in pairs(nUnitList) do
        if J.IsValidBuilding(building)
        and (building:HasModifier('modifier_fountain_glyph')
            or building:HasModifier('modifier_backdoor_protection')
            or building:HasModifier('modifier_backdoor_protection_in_base')
            or building:HasModifier('modifier_backdoor_protection_active')
        )
        then
            return true
        end
    end

    return false
end

function Push.GetAllyHeroesAttackingUnit(hUnit)
    local hUnitList = {}
    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if J.IsValidHero(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and (allyHero:GetAttackTarget() == hUnit)
        then
            table.insert(hUnitList, allyHero)
        end
    end

    return hUnitList
end

function Push.GetAllyCreepsAttackingUnit(hUnit)
    local hUnitList = {}
    for _, creep in pairs(GetUnitList(UNIT_LIST_ALLIED_CREEPS)) do
        if J.IsValid(creep)
        and (creep:GetAttackTarget() == hUnit)
        then
            table.insert(hUnitList, creep)
        end
    end

    return hUnitList
end

local laneBuildings = {
    [LANE_TOP] = {
        towers      = { TOWER_TOP_1, TOWER_TOP_2, TOWER_TOP_3 },
        barracks    = { BARRACKS_TOP_MELEE, BARRACKS_TOP_RANGED }
    },
    [LANE_MID] = {
        towers      = { TOWER_MID_1, TOWER_MID_2, TOWER_MID_3 },
        barracks    = { BARRACKS_MID_MELEE, BARRACKS_MID_RANGED }
    },
    [LANE_BOT] = {
        towers      = { TOWER_BOT_1, TOWER_BOT_2, TOWER_BOT_3 },
        barracks    = { BARRACKS_BOT_MELEE, BARRACKS_BOT_RANGED }
    }
}
function Push.GetLaneBuildingTier(nLane)
    local buildings = laneBuildings[nLane]
    if buildings == nil then return 4 end

    for i, tower in ipairs(buildings.towers) do
        local t = GetTower(GetOpposingTeam(), tower)
        if t ~= nil and t:IsAlive() then return i end
    end

    for _, barrack in ipairs(buildings.barracks) do
        local b = GetBarracks(GetOpposingTeam(), barrack)
        if b ~= nil and b:IsAlive() then return 3 end
    end

    return 4
end

local function IsValidAbility(hAbility)
    if hAbility == nil
	or hAbility:IsNull()
	or hAbility:GetName() == ''
	or hAbility:IsPassive()
	or hAbility:IsHidden()
	or not hAbility:IsTrained()
	or not hAbility:IsActivated()
	then
		return false
	end

	return true
end

-- try, tentative
local hItemList = {
    'item_black_king_bar',
    'item_refresher'
}
-- do k,v
local hAbilityList = {
    ['ncp_dota_hero_alchemist'] = {'alchemist_chemical_rage'},
    ['ncp_dota_hero_axe'] = {'axe_culling_blade'},
    ['ncp_dota_hero_bristleback'] = {'bristleback_bristleback'},
    ['ncp_dota_hero_centaur'] = {'centaur_stampede'},
    ['ncp_dota_hero_chaos_knight'] = {'chaos_knight_phantasm'},
    ['ncp_dota_hero_dawnbreaker'] = {'dawnbreaker_solar_guardian'},
    ['ncp_dota_hero_doom_bringer'] = {'doom_bringer_doom'},
    ['ncp_dota_hero_dragon_knight'] = {'dragon_knight_elder_dragon_form'},
    ['ncp_dota_hero_earth_spirit'] = {'earth_spirit_magnetize'},
    ['ncp_dota_hero_earthshaker'] = {'earthshaker_echo_slam'},
    ['ncp_dota_hero_elder_titan'] = {'elder_titan_earth_splitter'},
    --huskar
    ['ncp_dota_hero_kunkka'] = {'kunkka_ghostship'},
    ['ncp_dota_hero_legion_commander'] = {'legion_commander_duel'},
    ['ncp_dota_hero_life_stealer'] = {'life_stealer_rage'},
    ['ncp_dota_hero_mars'] = {'mars_arena_of_blood'},
    ['ncp_dota_hero_night_stalker'] = {'night_stalker_darkness'},
    ['ncp_dota_hero_omniknight'] = {'omniknight_guardian_angel'},
    ['ncp_dota_hero_primal_beast'] = {'primal_beast_pulverize'},
    --pudge, slardar, spirit breaker
    ['ncp_dota_hero_sven'] = {'sven_gods_strength'},
    ['ncp_dota_hero_tidehunter'] = {'tidehunter_ravage'},
    --timbersaw, tiny
    ['ncp_dota_hero_treant'] = {'treant_overgrowth'},
    --tusk
    ['ncp_dota_hero_undying'] = {'undying_tombstone', 'undying_flesh_golem'},
    ['ncp_dota_hero_skeleton_king'] = {'skeleton_king_reincarnation'},

    ['npc_dota_hero_antimage'] = {'antimage_mana_void'},
    --arc
    ['npc_dota_hero_bloodseeker'] = {'bloodseeker_rupture'},
    --bounty
    ['npc_dota_hero_clinkz'] = {'clinkz_burning_barrage'},
    --drow ranger, ember
    ['npc_dota_hero_faceless_void'] = {'faceless_void_chronosphere'},
    ['npc_dota_hero_gyrocopter'] = {'gyrocopter_flak_cannon'},
    ['npc_dota_hero_hoodwink'] = {'hoodwink_sharpshooter'},
    ['npc_dota_hero_juggernaut'] = {'juggernaut_omni_slash'},
    --kez
    ['npc_dota_hero_luna'] = {'luna_eclipse'},
    ['npc_dota_hero_medusa'] = {'medusa_stone_gaze'},
    --meepo
    ['npc_dota_hero_monkey_king'] = {'monkey_king_wukongs_command'},
    --morphling
    ['npc_dota_hero_naga_siren'] = {'naga_siren_song_of_the_siren'},
    --phantom ass, phantom lance
    ['npc_dota_hero_razor'] = {'razor_static_link'},
    --riki
    ['npc_dota_hero_nevermore'] = {'nevermore_requiem'},
    ['npc_dota_hero_slark'] = {'slark_shadow_dance'},
    --sniper
    ['npc_dota_hero_spectre'] = {'spectre_shadow_step', 'spectre_haunt'},
    -- ta
    ['npc_dota_hero_terrorblade'] = {'terrorblade_metamorphosis', 'terrorblade_sunder'},
    ['npc_dota_hero_troll_warlord'] = {'troll_warlord_battle_trance'},
    ['npc_dota_hero_ursa'] = {'ursa_enrage'},
    ['npc_dota_hero_viper'] = {'viper_viper_strike'},
    ['npc_dota_hero_weaver'] = {'weaver_time_lapse'},

    ['npc_dota_hero_ancient_apparition'] = {'ancient_apparition_ice_blast'},
    ['npc_dota_hero_crystal_maiden'] = {'crystal_maiden_freezing_field'},
    ['npc_dota_hero_death_prophet'] = {'death_prophet_exorcism'},
    ['npc_dota_hero_disruptor'] = {'disruptor_static_storm'},
    --enchantress
    ['npc_dota_hero_grimstroke'] = {'grimstroke_dark_portrait', 'grimstroke_soul_chain'},
    ['npc_dota_hero_jakiro'] = {'jakiro_macropyre'},
    --kotl, leshrac
    ['npc_dota_hero_lich'] = {'lich_chain_frost'},
    ['npc_dota_hero_lina'] = {'lina_laguna_blade'},
    ['npc_dota_hero_lion'] = {'lion_finger_of_death'},
    ['npc_dota_hero_muerta'] = {'muerta_pierce_the_veil'},
    --np
    ['npc_dota_hero_necrolyte'] = {'necrolyte_ghost_shroud', 'necrolyte_reapers_scythe'},
    ['npc_dota_hero_oracle'] = {'oracle_false_promise'},
    ['npc_dota_hero_obsidian_destroyer'] = {'obsidian_destroyer_sanity_eclipse'},
    ['npc_dota_hero_puck'] = {'puck_dream_coil'},
    ['npc_dota_hero_pugna'] = {'pugna_life_drain'},
    ['npc_dota_hero_queenofpain'] = {'queenofpain_sonic_wave'},
    ['npc_dota_hero_ringmaster'] = {'ringmaster_wheel'},
    --rubick
    ['npc_dota_hero_shadow_demon'] = {'shadow_demon_disruption', 'shadow_demon_demonic_cleanse', 'shadow_demon_demonic_purge'},
    ['npc_dota_hero_shadow_shaman'] = {'shadow_shaman_mass_serpent_ward'},
    ['npc_dota_hero_silencer'] = {'silencer_global_silence'},
    ['npc_dota_hero_skywrath_mage'] = {'skywrath_mage_mystic_flare'},
    --storm, tinker
    ['npc_dota_hero_warlock'] = {'warlock_fatal_bonds', 'warlock_golem'},
    ['npc_dota_hero_witch_doctor'] = {'witch_doctor_voodoo_switcheroo', 'witch_doctor_death_ward'},
    ['npc_dota_hero_zuus'] = {'zuus_thundergods_wrath'},

    ['npc_dota_hero_abaddon'] = {'abaddon_borrowed_time'},
    ['npc_dota_hero_bane'] = {'bane_fiends_grip'},
    ['npc_dota_hero_batrider'] = {'batrider_flaming_lasso'},
    ['npc_dota_hero_beastmaster'] = {'beastmaster_primal_roar'},
    ['npc_dota_hero_brewmaster'] = {'brewmaster_primal_split'},
    ['npc_dota_hero_broodmother'] = {'broodmother_insatiable_hunger'},
    ['npc_dota_hero_chen'] = {'chen_hand_of_god'},
    --clockwerk
    ['npc_dota_hero_dark_seer'] = {'dark_seer_wall_of_replica'},
    ['npc_dota_hero_dark_willow'] = {'dark_willow_terrorize'},
    --dazzle
    ['npc_dota_hero_enigma'] = {'enigma_black_hole'},
    --invoker, io, ld
    ['npc_dota_hero_lycan'] = {'lycan_shapeshift'},
    ['npc_dota_hero_magnataur'] = {'magnataur_reverse_polarity'},
    ['npc_dota_hero_marci'] = {'marci_unleash'},
    --mirana, nyx
    ['npc_dota_hero_pangolier'] = {'pangolier_gyroshell'},
    ['npc_dota_hero_phoenix'] = {'phoenix_supernova'},
    ['npc_dota_hero_sand_king'] = {'sandking_epicenter'},
    ['npc_dota_hero_snapfire'] = {'snapfire_mortimer_kisses'},
    --techies
    ['npc_dota_hero_vengefulspirit'] = {'vengefulspirit_nether_swap'},
    ['npc_dota_hero_venomancer'] = {'venomancer_noxious_plague'},
    --visage, void spirit
    ['npc_dota_hero_windrunner'] = {'windrunner_focusfire'},
    ['npc_dota_hero_winter_wyvern'] = {'winter_wyvern_cold_embrace', 'winter_wyvern_winters_curse'},
}
function Push.ShouldWaitForImportantItemsSpells(vLocation)
    if J.IsMidGame() or J.IsLateGame() then
        for i = 1, 5 do
            local member = GetTeamMember(i)
            if member ~= nil and member:IsAlive() then
                for _, itemName in pairs(hItemList) do
                    local hItem = J.GetItem(itemName)
                    if hItem ~= nil
                    and (hItem:GetCooldownTimeRemaining() >
                        (GetUnitToLocationDistance(member, vLocation) / member:GetCurrentMovementSpeed())
                    )
                    then
                        return true
                    end
                end
            end
        end

        for i = 1, 5 do
            local member = GetTeamMember(i)
            if member ~= nil then
                local sMemberName = member:GetUnitName()
                local bCore = J.IsCore(member)
                if string.find(sMemberName, 'gyrocopter') and not bCore
                or string.find(sMemberName, 'weaver') and not bCore
                then
                    -- none
                else
                    -- do some mana later
                    if hAbilityList[sMemberName] ~= nil then
                        for _, abilityName in pairs(hAbilityList[sMemberName]) do
                            local hAbility = J.GetAbility(member, abilityName)
                            if IsValidAbility(hAbility)
                            and (hAbility:GetCooldownTimeRemaining() >
                                (GetUnitToLocationDistance(member, vLocation) / member:GetCurrentMovementSpeed())
                            )
                            then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

return Push