local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BoulderSmash

local nStone

function X.Cast()
    bot = GetBot()
    BoulderSmash = bot:GetAbilityByName('earth_spirit_boulder_smash')

    local _, StoneRemnant = J.HasAbility(bot, 'earth_spirit_stone_caller')

    if StoneRemnant ~= nil and StoneRemnant:IsFullyCastable()
    then
        nStone = 1
    else
        nStone = 0
    end

    Desire, Target, CanRemnantSmashCombo, CanKickNearby = X.Consider()
    if Desire > 0
    then
        if CanRemnantSmashCombo
		then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbilityOnLocation(StoneRemnant, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, Target)
			return
		else
			if CanKickNearby
			then
				J.SetQueuePtToINT(bot, false)
				bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, Target)
				return
			end
		end
    end
end

function X.Consider()
    if not BoulderSmash:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0, false, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, BoulderSmash:GetCastRange())
	local nSpeed = BoulderSmash:GetSpecialValueInt('speed')
	local nDamage = BoulderSmash:GetSpecialValueInt('rock_damage')
    local nRockKickDist = BoulderSmash:GetSpecialValueInt('rock_distance')
    local nUnitKickDist = BoulderSmash:GetSpecialValueInt('unit_distance')
	local stoneNearby = X.IsStoneNearby(bot:GetLocation(), nCastRange)
    local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRockKickDist)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local loc = J.GetCorrectLoc(enemyHero, GetUnitToUnitDistance(bot, enemyHero) / nSpeed)

			if stoneNearby
			then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true
			elseif nStone >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, loc, true, false
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				if nAllyHeroes ~= nil and #nAllyHeroes >= 2
				and J.IsValidHero(nAllyHeroes[#nAllyHeroes])
				and J.IsInRange(bot, nAllyHeroes[#nAllyHeroes], nUnitKickDist)
				and not J.IsInRange(bot, nAllyHeroes[#nAllyHeroes], nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, nAllyHeroes[#nAllyHeroes]:GetLocation(), false, true
				else
					return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nUnitKickDist), false, true
				end
			end
		end

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRockKickDist)
		then
			local loc = J.GetCorrectLoc(botTarget, GetUnitToUnitDistance(bot, botTarget) / nSpeed)

            if not J.IsLocationInChrono(loc) and IsLocationPassable(loc)
			and ((J.IsInLaningPhase() and botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL) and nAllyHeroes ~= nil and #nAllyHeroes <= 1)
				or (not J.IsInLaningPhase() or nAllyHeroes ~= nil and #nAllyHeroes >= 2))
            then
                if stoneNearby
                and not J.IsInRange(bot, botTarget, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, false, true
                elseif nStone >= 1
                then
                    return BOT_ACTION_DESIRE_HIGH, loc, true, false
                elseif nStone == 0
                then
                    for _, allyHero in pairs(nAllyHeroes)
                    do
                        if J.IsValidHero(allyHero)
                        and bot ~= allyHero
                        and not J.IsInRange(bot, botTarget, 600)
                        and GetUnitToLocationDistance(allyHero, loc) <= 800
                        and J.IsInRange(bot, allyHero, nCastRange)
                        and J.IsChasingTarget(allyHero, botTarget)
                        and botTarget:GetHealth() <= (allyHero:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                                                    + bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL))
                        then
                            return BOT_ACTION_DESIRE_HIGH, loc, false, true
                        end
                    end
                end
            end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 880)
        and bot:WasRecentlyDamagedByAnyHero(4)
        then
            if J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetEnemyFountain(), nUnitKickDist), false, true
            else
                if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
                and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
                then
                    if stoneNearby
                    then
                        return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation(), false, true
                    elseif nStone >= 1
                    then
                        if bot:IsFacingLocation(J.GetTeamFountain(), 30)
                        then
                            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation(), true, false
                        end
                    end
                end
            end
        end
	end

	if  J.IsLaning(bot)
	and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1600)))
	then
		if  nStone >= 1
		and J.GetMP(bot) > 0.35
		then
			local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

			for _, creep in pairs(nEnemyLaneCreeps)
			do
				if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
				and J.IsKeyWordUnit('ranged', creep)
				and creep:GetHealth() <= nDamage
                and not J.IsRunning(creep)
				then
					if J.IsValidHero(nEnemyHeroes[1])
					and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
					then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation(), true, false
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false, false
end

function X.IsStoneNearby(vLoc, nRadius)
	for _, u in pairs(GetUnitList(UNIT_LIST_ALLIED_OTHER))
	do
		if  u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone"
		and GetUnitToLocationDistance(u, vLoc) < nRadius
		then
			return true
		end
	end

	return false
end

return X