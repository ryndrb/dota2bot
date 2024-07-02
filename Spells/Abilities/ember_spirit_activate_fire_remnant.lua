local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ActivateFireRemnant

function X.Cast()
    bot = GetBot()
    ActivateFireRemnant = bot:GetAbilityByName('ember_spirit_activate_fire_remnant')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(ActivateFireRemnant, Target)
        return
    end
end

function X.Consider()
    if not ActivateFireRemnant:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local botTarget = J.GetProperTarget(bot)

    local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
        if J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            local closestRemnantToTarget = nil
            local targetDist = 100000

            for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
            do
                if  u ~= nil and u:GetUnitName() == 'npc_dota_ember_spirit_remnant'
                then
                    local dist = GetUnitToUnitDistance(u, botTarget)
                    if dist < targetDist
                    then
                        targetDist = dist
                        closestRemnantToTarget = u
                    end
                end
            end

            if closestRemnantToTarget ~= nil
            then
                if J.IsInLaningPhase()
                then
                    if botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH, closestRemnantToTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, closestRemnantToTarget:GetLocation()
                end
            end
        end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		local closestRemnantToAncient = nil
		local targetDist = 100000

		for _, u in pairs(GetUnitList(UNIT_LIST_ALLIES))
		do
			if  u ~= nil and u:GetUnitName() == 'npc_dota_ember_spirit_remnant'
			then
				local dist = GetUnitToLocationDistance(u, J.GetTeamFountain())
				if dist < targetDist
				then
					targetDist = dist
					closestRemnantToAncient = u
				end
			end
		end

		if closestRemnantToAncient ~= nil
        and bot:GetActiveModeDesire() > 0.7
        and bot:WasRecentlyDamagedByAnyHero(4)
		then
			return BOT_ACTION_DESIRE_HIGH, closestRemnantToAncient:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X