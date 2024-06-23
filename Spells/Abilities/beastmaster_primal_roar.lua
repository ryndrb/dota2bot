local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local PrimalRoar

function X.Cast()
    bot = GetBot()
    PrimalRoar = bot:GetAbilityByName('beastmaster_primal_roar')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(PrimalRoar, Target)
        return
    end
end

function X.Consider()
    if not PrimalRoar:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, PrimalRoar:GetCastRange())
    local nDuration = PrimalRoar:GetSpecialValueInt('duration')
    local nDamage = PrimalRoar:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and J.IsChasingTarget(bot, enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
        local strongestTarget = J.GetStrongestUnit(nCastRange, bot, true, false, nDuration)

        if strongestTarget == nil
        then
            strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
        end

        if  J.IsValidTarget(strongestTarget)
        and J.CanCastOnMagicImmune(strongestTarget)
        and J.CanCastOnTargetAdvanced(strongestTarget)
        and J.GetHP(strongestTarget) > 0.5
        and not J.IsDisabled(strongestTarget)
        and not J.IsHaveAegis(strongestTarget)
        and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not strongestTarget:HasModifier('modifier_legion_commander_duel')
        and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			return BOT_ACTION_DESIRE_HIGH, strongestTarget
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidTarget(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.GetHP(enemyHero) > 0.5
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and enemyHero:GetHealth() <= bot:GetEstimatedDamageToTarget(true, enemyHero, nDuration, DAMAGE_TYPE_ALL)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X