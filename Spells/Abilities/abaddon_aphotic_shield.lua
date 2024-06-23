local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local AphoticShield

function X.Cast()
    bot = GetBot()
    AphoticShield = bot:GetAbilityByName('abaddon_aphotic_shield')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(AphoticShield, Target)
        return
    end
end

function X.Consider()
    if not AphoticShield:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange  = J.GetProperCastRange(false, bot, AphoticShield:GetCastRange())
    local botTarget = J.GetProperTarget(bot)

    local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
	do
        if  J.IsValidHero(allyHero)
        and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull')
            or allyHero:HasModifier('modifier_legion_commander_duel'))
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

        if  J.IsValidHero(allyHero)
        and J.IsDisabled(allyHero)
        and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

		if  J.IsValidHero(allyHero)
        and not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
        and not allyHero:HasModifier('modifier_item_solar_crest_armor_addition')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and J.IsNotSelf(bot, allyHero)
		then
            if  J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(1.6)
            and not allyHero:IsIllusion()
            then
                local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(800, true, BOT_MODE_NONE)

                if  J.IsValidHero(nAllyInRangeEnemy[1])
                and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 400)
                and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
                and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
                and not J.IsDisabled(nAllyInRangeEnemy[1])
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidHero(allyTarget)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange())
                and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyTarget:HasModifier('modifier_enigma_black_hole_pull')
                and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
    then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        then
            if  J.IsValidHero(nInRangeAlly[1])
            and J.IsInRange(bot, nInRangeAlly[1], nCastRange)
            and J.IsCore(nInRangeAlly[1])
            and not nInRangeAlly[1]:HasModifier('modifier_abaddon_aphotic_shield')
            and not nInRangeAlly[1]:IsMagicImmune()
            and not nInRangeAlly[1]:IsInvulnerable()
            and not nInRangeAlly[1]:IsIllusion()
            then
                return BOT_ACTION_DESIRE_HIGH, nInRangeAlly[1]
            end

            if  not bot:HasModifier('modifier_abaddon_aphotic_shield')
            and not bot:HasModifier("modifier_abaddon_borrowed_time")
            then
                return BOT_ACTION_DESIRE_MODERATE, bot
            end
	    end

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and #nInRangeAlly == 0 and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 500)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier("modifier_abaddon_borrowed_time")
        then
            return BOT_ACTION_DESIRE_MODERATE, bot
        end
    end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.65 or bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
            and J.IsInRange(bot, enemyHero, 600)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(1600, true)
        if  J.IsValid(nCreeps[1])
        and J.CanBeAttacked(nCreeps[1])
        and J.GetHP(bot) < 0.5
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier('modifier_abaddon_borrowed_time')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            local weakestAlly = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if  weakestAlly ~= nil
            and not weakestAlly:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, weakestAlly
            end
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            local weakestAlly = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if  weakestAlly ~= nil
            and not weakestAlly:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, weakestAlly
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X