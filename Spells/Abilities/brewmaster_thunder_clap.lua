local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ThunderClap

function X.Cast()
    bot = GetBot()
    ThunderClap = bot:GetAbilityByName('brewmaster_thunder_clap')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ThunderClap)
        return
    end
end

function X.Consider()
    if not ThunderClap:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = ThunderClap:GetSpecialValueInt('radius')
    local nDamage = ThunderClap:GetSpecialValueInt('damage')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius - 75)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and bot:WasRecentlyDamagedByAnyHero(1.5)
        and J.IsInRange(bot, nEnemyHeroes[1], nRadius)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_brewmaster_cinder_brew')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if (J.IsPushing(bot) or J.IsDefending(bot))
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot)
    then
        if  J.IsAttacking(bot)
        and J.GetMP(bot) > 0.4
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
            if  nNeutralCreeps ~= nil
            and J.IsValid(nNeutralCreeps[1])
            and ((#nNeutralCreeps >= 3)
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsLaning(bot)
	then
        local canKill = 0
        local creepList = {}

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 500
                and J.GetMP(bot) > 0.35
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                canKill = canKill + 1
                table.insert(creepList, creep)
            end
		end

        if  canKill >= 2
        and J.GetMP(bot) > 0.33
        and nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.IsInLaningPhase()
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
            if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            and J.GetManaAfter(ThunderClap:GetManaCost()) > 0.5
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and not botTarget:IsDisarmed()
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X