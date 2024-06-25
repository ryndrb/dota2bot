local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SolarGuardian

local BlackKingBar
local ShouldBKB = false

function X.Cast()
    bot = GetBot()
    SolarGuardian = bot:GetAbilityByName('dawnbreaker_solar_guardian')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        if  X.CanBKB()
        and ShouldBKB
        then
            bot:Action_UseAbility(BlackKingBar)
            ShouldBKB = false
        end

        bot:ActionQueue_UseAbilityOnLocation(SolarGuardian, Location)
        return
    end
end

function X.Consider()
    if not SolarGuardian:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nChannelTime = SolarGuardian:GetChannelTime()
	local nRadius = SolarGuardian:GetSpecialValueInt('radius')
    local nAirTime = SolarGuardian:GetSpecialValueFloat('airtime_duration')
    local nCastPoint = SolarGuardian:GetCastPoint()
    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    local nTotalCastTime = nChannelTime + nAirTime + nCastPoint

    if nTeamFightLocation ~= nil
    then
        local nAllyList = J.GetAlliesNearLoc(nTeamFightLocation, nRadius)

        if nAllyList ~= nil and #nAllyList >= 1
        then
            local allyHero = nAllyList[#nAllyList]
            if J.IsValidHero(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                local nNeabyEnemyNearAllyList = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

                if  not J.IsLocationInChrono(nTeamFightLocation)
                and (nNeabyEnemyNearAllyList ~= nil and #nNeabyEnemyNearAllyList >= 1)
                then
                    local aLocationAoE = bot:FindAoELocation(false, true, nTeamFightLocation, GetUnitToLocationDistance(bot, nTeamFightLocation), nRadius, nTotalCastTime, 0)
                    local eLocationAoE = bot:FindAoELocation(true, true, nTeamFightLocation, GetUnitToLocationDistance(bot, nTeamFightLocation), nRadius, nTotalCastTime, 0)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 700)

                    if aLocationAoE.count >= 1 and eLocationAoE.count >= 1
                    then
                        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                        and not bot:IsMagicImmune()
                        then
                            ShouldBKB = true
                        end

                        return BOT_ACTION_DESIRE_HIGH, aLocationAoE.targetloc
                    end
                end
            end
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    if (J.IsRetreating(bot) and bot:DistanceFromFountain() > 1600 and J.GetHP(bot) < 0.33 and not J.IsRealInvisible(bot))
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
                local nAllyHeroes = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
                local furthestAlly = nil

                for i = 1, 5
                do
                    local ally = GetTeamMember(i)
                    local dist = 0

                    if  ally ~= nil
                    and ally:IsAlive()
                    and GetUnitToUnitDistance(bot, ally) > dist
                    then
                        dist = GetUnitToUnitDistance(bot, ally)
                        furthestAlly = ally
                    end
                end

				if  nAllyHeroes ~= nil
				and (#nAllyHeroes <= 1 and #nEnemyHeroes >= 3)
                and furthestAlly ~= nil and GetUnitToUnitDistance(bot, furthestAlly) > 1600
                and bot:IsMagicImmune()
				then
					return BOT_ACTION_DESIRE_MODERATE, furthestAlly:GetLocation()
				end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanBKB()
    local bkb = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if  item ~= nil
        and item:GetName() == "item_black_king_bar"
        then
			bkb = item
			break
		end
	end

    if  bkb ~= nil
    and bkb:IsFullyCastable()
	then
        BlackKingBar = bkb
        return true
	end

    return false
end

return X