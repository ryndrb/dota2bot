local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DoubleEdge

function X.Cast()
    bot = GetBot()
    DoubleEdge = bot:GetAbilityByName('centaur_double_edge')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DoubleEdge, Target)
        return
    end
end

function X.Consider()
    if not DoubleEdge:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local nStrength = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
	local nCastRange = J.GetProperCastRange(false, bot, DoubleEdge:GetCastRange())
    local nAttackRange = bot:GetAttackRange()
    local nStrengthDamageMul = DoubleEdge:GetSpecialValueInt("strength_damage") / 100
	local nDamage = DoubleEdge:GetSpecialValueInt("edge_damage") + (nStrength * nStrengthDamageMul)
	local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange * 2, true)
    local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange * 2)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nAttackRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and bot:GetHealth() > nDamage * 1.2
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and bot:GetHealth() > nDamage * 1.5
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if (J.IsPushing(bot) or J.IsDefending(bot))
    then
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and J.IsAttacking(bot)
        and bot:GetHealth() > nDamage * 1.5
        and (bot:GetHealth() - nDamage) / bot:GetMaxHealth() > 0.5
        and J.GetHP(nEnemyLaneCreeps[1]) > 0.33
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]
        end
    end

    if J.IsFarming(bot)
    then
        if  J.IsAttacking(bot)
        and J.GetHP(bot) > 0.3
        and bot:GetHealth() > nDamage * 1.5
        and (bot:GetHealth() - nDamage) / bot:GetMaxHealth() > 0.3
        then
            if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
            and J.GetHP(nNeutralCreeps[1]) > 0.33
            then
                return BOT_ACTION_DESIRE_HIGH, nNeutralCreeps[1]
            end

            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and J.GetHP(nEnemyLaneCreeps[1]) > 0.33
            then
                return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]
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
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 500
                and J.CanBeAttacked(creep)
                and J.GetHP(bot) > 0.3
                and bot:GetHealth() > nDamage * 1.5
                and (bot:GetHealth() - nDamage) / bot:GetMaxHealth() > 0.3
				then
					return BOT_ACTION_DESIRE_HIGH, creep
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
        and J.CanBeAttacked(creepList[1])
        and J.GetHP(bot) > 0.3
        and bot:GetHealth() > nDamage * 1.5
        and (bot:GetHealth() - nDamage) / bot:GetMaxHealth() > 0.3
        then
            return BOT_ACTION_DESIRE_HIGH, creepList[1]
        end

        if J.IsValidTarget(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.CanBeAttacked(nEnemyHeroes[1])
        and (bot:GetHealth() - nDamage) / bot:GetMaxHealth() > 0.65
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and not botTarget:IsInvulnerable()
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and J.IsAttacking(bot)
        and bot:GetHealth() > nDamage * 1.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and J.IsAttacking(bot)
        and bot:GetHealth() > nDamage * 1.5
        and (bot:GetHealth() - nDamage) / bot:GetMaxHealth() > 0.45
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X