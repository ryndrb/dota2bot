local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SpinWeb

function X.Cast()
    bot = GetBot()
    SpinWeb = bot:GetAbilityByName('broodmother_spin_web')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SpinWeb, Location)
        return
    end
end

function X.Consider()
    if not SpinWeb:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, SpinWeb:GetCastRange())
    local nRadius = SpinWeb:GetSpecialValueInt('radius')
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
    local nEnemyHeroes = bot:GetNearbyTowers(1600, true)
    local nEnemyTowers = bot:GetNearbyTowers(700, true)
    local botTarget = J.GetProperTarget(bot)

    if  J.IsStuck(bot)
    and not X.DoesLocationHaveWeb(bot:GetLocation(), nRadius)
	then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
	end

    if J.IsInTeamFight(bot, 1200)
	then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 1.7)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not X.DoesLocationHaveWeb(nLocationAoE.targetloc, nRadius)
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius)
        and not J.IsLocationInChrono(botTarget:GetLocation())
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 600)
        and bot:WasRecentlyDamagedByAnyHero(3)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not X.DoesLocationHaveWeb(bot:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if J.IsPushing(bot)
	then
		if  nEnemyTowers ~= nil and #nEnemyTowers >= 1
        and J.CanBeAttacked(nEnemyTowers[1])
        and not X.DoesLocationHaveWeb(nEnemyTowers[1]:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyTowers[1]:GetLocation()
		end
	end

    if J.IsLaning(bot)
    and J.IsPushing(bot)
    then
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and not X.DoesLocationHaveWeb(J.GetCenterOfUnits(nEnemyLaneCreeps), nRadius)
        then
			return BOT_MODE_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.DoesLocationHaveWeb(loc, nRadius)
	for _, u in pairs (GetUnitList(UNIT_LIST_ALLIES))
	do
		if  J.IsValid(u)
        and u:GetUnitName() == 'npc_dota_broodmother_web'
        and GetUnitToLocationDistance(u, loc) < nRadius
		then
			return true
		end
	end

	return false
end

return X