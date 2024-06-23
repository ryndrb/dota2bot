local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FiendsGate

function X.Cast()
    bot = GetBot()
    FiendsGate = bot:GetAbilityByName('abyssal_underlord_dark_portal')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(FiendsGate, Location)
        return
    end
end

function X.Consider()
    if not FiendsGate:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)
    local botTarget = J.GetProperTarget(bot)

    if  nTeamFightLocation ~= nil
    and GetUnitToLocationDistance(bot, nTeamFightLocation) > 2500
    and not J.IsGoingOnSomeone(bot)
    and not J.IsRetreating(bot)
    and not J.IsInLaningPhase()
    then
        local nInRangeAlly = J.GetAlliesNearLoc(nTeamFightLocation, 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nTeamFightLocation, 1200)

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and #nInRangeAlly + 1 >= #nInRangeEnemy
        and #nInRangeEnemy >= 1
        then
            local targetLoc = J.GetCenterOfUnits(nInRangeAlly)

            if  IsLocationPassable(targetLoc)
            and not J.IsLocationInChrono(targetLoc)
            and not J.IsLocationInBlackHole(targetLoc)
            and not J.IsLocationInArena(targetLoc, 600)
            then
                bot:SetTarget(nInRangeEnemy[1])
                return BOT_ACTION_DESIRE_HIGH, targetLoc
            end
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsInLaningPhase()
        and GetUnitToUnitDistance(bot, botTarget) > 2500
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
            local nInRangeEnemy = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
            local nEnemyTowers = bot:GetNearbyTowers(700, true)

			if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and nInRangeEnemy ~= nil and nEnemyTowers ~= nil
            and #nInRangeAlly >= #nTargetInRangeAlly
            and #nInRangeEnemy == 0 and #nEnemyTowers == 0
            then
                local targetLoc = J.GetCenterOfUnits(nInRangeAlly)

                if  IsLocationPassable(targetLoc)
                and not J.IsLocationInChrono(targetLoc)
                and not J.IsLocationInBlackHole(targetLoc)
                and not J.IsLocationInArena(targetLoc, 600)
                then
                    bot:SetTarget(botTarget)
                    return BOT_ACTION_DESIRE_HIGH, targetLoc
                end
            end
		end
	end

    local aveDist = {0,0,0}
    local pushCount = {0,0,0}
    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    do
        if  J.IsValidHero(allyHero)
        and J.IsGoingOnSomeone(allyHero)
        and GetUnitToUnitDistance(bot, allyHero) > 2500
        and not allyHero:IsIllusion()
        and not J.IsInLaningPhase()
        then
            local allyTarget = allyHero:GetAttackTarget()
            local nAllyInRangeAlly = allyHero:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  J.IsValidTarget(allyTarget)
            and J.IsInRange(allyHero, allyTarget, 800)
            and J.GetHP(allyHero) > 0.5
            and J.IsCore(allyTarget)
            and not J.IsSuspiciousIllusion(allyTarget)
            then
                local nTargetInRangeAlly = allyTarget:GetNearbyHeroes(800, false, BOT_MODE_NONE)
                local nInRangeEnemy = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
                local nEnemyTowers = bot:GetNearbyTowers(700, true)

                if  nAllyInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nAllyInRangeAlly + 1 >= #nTargetInRangeAlly
                and #nTargetInRangeAlly >= 1
                and nInRangeEnemy ~= nil and nEnemyTowers ~= nil
                and #nInRangeEnemy == 0 and #nEnemyTowers == 0
                then
                    local targetLoc = J.GetCenterOfUnits(nTargetInRangeAlly)

                    if  IsLocationPassable(targetLoc)
                    and not J.IsLocationInChrono(targetLoc)
                    and not J.IsLocationInBlackHole(targetLoc)
                    and not J.IsLocationInArena(targetLoc, 600)
                    then
                        bot:SetTarget(allyTarget)
                        return BOT_ACTION_DESIRE_HIGH, targetLoc
                    end
                end
            end
        end

        if  J.IsValidHero(allyHero)
        and bot ~= allyHero
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        then
            if  allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
            and bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
            then
                pushCount[1] = pushCount[1] + 1
                aveDist[1] = aveDist[1] + GetUnitToLocationDistance(allyHero, GetLaneFrontLocation(GetTeam(), LANE_TOP, 0))
            end

            if  allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
            and bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
            then
                pushCount[2] = pushCount[2] + 1
                aveDist[2] = aveDist[2] + GetUnitToLocationDistance(allyHero, GetLaneFrontLocation(GetTeam(), LANE_MID, 0))
            end

            if  allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
            and bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
            then
                pushCount[3] = pushCount[3] + 1
                aveDist[3] = aveDist[3] + GetUnitToLocationDistance(allyHero, GetLaneFrontLocation(GetTeam(), LANE_BOT, 0))
            end
        end
    end

    if pushCount[1] ~= nil and pushCount[1] >= 3 and (aveDist[1] / pushCount[1]) <= 1200
    then
        if GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH, GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)
        end
    elseif pushCount[2] ~= nil and pushCount[2] >= 3 and (aveDist[2] / pushCount[2]) <= 1200
    then
        if GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), LANE_MID, 0)) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH, GetLaneFrontLocation(GetTeam(), LANE_MID, 0)
        end
    elseif pushCount[3] ~= nil and pushCount[3] >= 3 and (aveDist[3] / pushCount[3]) <= 1200
    then
        if GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)) > 4000
        then
            return BOT_ACTION_DESIRE_HIGH, GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X