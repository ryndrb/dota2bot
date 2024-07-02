local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local WrathOfNature

function X.Cast()
    bot = GetBot()
    WrathOfNature = bot:GetAbilityByName('furion_wrath_of_nature')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(WrathOfNature, Target)
        return
    end
end

function X.Consider()
    if not WrathOfNature:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nDamage = WrathOfNature:GetSpecialValueInt('damage')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
        local hTarget = nil
        local hp = 99999

        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if J.IsValidTarget(enemyHero)
            and J.GetHP(enemyHero) < 0.5
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local currHP = enemyHero:GetHealth()
                if currHP < hp
                then
                    hTarget = enemyHero
                    hp = currHP
                end
            end
        end

        if hTarget ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X