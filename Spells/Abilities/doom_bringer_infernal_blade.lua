local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local InfernalBlade

function X.Cast()
    bot = GetBot()
    InfernalBlade = bot:GetAbilityByName('doom_bringer_infernal_blade')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(InfernalBlade, Target)
        return
    end
end

function X.Consider()
    if not InfernalBlade:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, InfernalBlade:GetCastRange())
    local nBurnDamage = InfernalBlade:GetSpecialValueInt('burn_damage')
    local nDamagePct = InfernalBlade:GetSpecialValueInt('burn_damage_pct') / 100
    local nDuration = InfernalBlade:GetSpecialValueInt('burn_duration')
    local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, 700)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling()
            then
                if J.IsInLaningPhase()
                then
                    if nEnemyTowers ~= nil
                    and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(enemyHero, nEnemyTowers[1], 700))
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end

            if  J.WillKillTarget(enemyHero, nBurnDamage + enemyHero:GetMaxHealth() * nDamagePct, DAMAGE_TYPE_MAGICAL, nDuration)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if J.IsInLaningPhase()
                then
                    if nEnemyTowers ~= nil
                    and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(enemyHero, nEnemyTowers[1], 700))
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (J.IsChasingTarget(enemyHero, bot) or bot:WasRecentlyDamagedByHero(enemyHero, 4))
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	if J.IsFarming(bot)
	then
		local nCreeps = bot:GetNearbyCreeps(nCastRange + 150)
        local targetCreep = J.GetMostHpUnit(nCreeps)

        if  J.IsValid(targetCreep)
        and J.GetManaAfter(InfernalBlade:GetManaCost()) > 0.35
        and not J.IsOtherAllysTarget(targetCreep)
        then
            return BOT_ACTION_DESIRE_HIGH, targetCreep
        end
	end

    if J.IsLaning(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 75, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nBurnDamage
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X