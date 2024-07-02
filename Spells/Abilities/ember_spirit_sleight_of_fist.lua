local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SleightOfFist

function X.Cast()
    bot = GetBot()
    SleightOfFist = bot:GetAbilityByName('ember_spirit_sleight_of_fist')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SleightOfFist, Target)
        return
    end
end

function X.Consider()
    if not SleightOfFist:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = SleightOfFist:GetSpecialValueInt('radius')
	local nCastRange = J.GetProperCastRange(false, bot, SleightOfFist:GetCastRange())
	local nCastPoint = SleightOfFist:GetCastPoint()
	local nDamage = bot:GetAttackDamage() + SleightOfFist:GetSpecialValueInt('bonus_hero_damage')
	local nAbilityLevel = SleightOfFist:GetLevel()
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsStunProjectileIncoming(bot, 300)
	then
		local nCreeps = bot:GetNearbyCreeps(nCastRange, true)

		if J.IsValid(nCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH, nCreeps[1]:GetLocation()
		elseif J.IsValidHero(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

		if nLocationAoE.count >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
        and not botTarget:IsAttackImmune()
		and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.7
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnMagicImmune(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsDisarmed()
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

    if  J.IsFarming(bot)
	and nAbilityLevel >= 3
    and J.GetManaAfter(SleightOfFist:GetManaCost()) > 0.35
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
		if nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        and J.IsAttacking(bot)
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
		end

        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end
	end

	if J.IsLaning(bot) and J.GetManaAfter(SleightOfFist:GetManaCost()) > 0.35
	then
        local kCreepList = {}

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= bot:GetAttackDamage()
			then
				if J.IsValidHero(nEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end

            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetHealth() <= bot:GetAttackDamage()
            then
                table.insert(kCreepList, creep)
            end
		end

        if #kCreepList >= 2
        and J.CanBeAttacked(kCreepList[1])
        and J.IsValidHero(nEnemyHeroes[1]) and GetUnitToUnitDistance(kCreepList[1], nEnemyHeroes[1]) <= 500
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(kCreepList)
        end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot))
	and nAbilityLevel >= 3
    and J.GetManaAfter(SleightOfFist:GetManaCost()) > 0.5
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not botTarget:IsAttackImmune()
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(bot) > 0.2
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X