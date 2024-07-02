local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Fissure

function X.Cast()
    bot = GetBot()
    Fissure = bot:GetAbilityByName('earthshaker_fissure')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Fissure, Target)
        return
    end
end

function X.Consider()
    if not Fissure:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Fissure:GetCastRange())
	local nCastPoint = Fissure:GetCastPoint()
	local nRadius = Fissure:GetSpecialValueInt('fissure_radius')
    local nDamage = Fissure:GetSpecialValueInt('fissure_damage')
    local nAbilityLevel = Fissure:GetLevel()
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
            end
        end
    end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.5
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nCastPoint + 0.1)
            end
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
        local target = nil
        local dmg = 0

        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local currDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, 5, DAMAGE_TYPE_ALL)
                if currDmg > dmg
                then
                    dmg = currDmg
                    target = enemyHero
                end
            end
        end

        if J.IsValidHero(target)
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(target:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(target, nCastPoint)
            end
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nRadius)
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and bot:WasRecentlyDamagedByAnyHero(4)
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(nEnemyHeroes[1]:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
            end
        end
    end

	if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(Fissure:GetManaCost())  > 0.5
    and nAbilityLevel >= 3
    and nAllyHeroes ~= nil and #nAllyHeroes == 0
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(bot)
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X