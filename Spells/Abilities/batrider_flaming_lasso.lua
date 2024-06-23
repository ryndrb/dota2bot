local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FlamingLasso

function X.Cast()
    bot = GetBot()
    FlamingLasso = bot:GetAbilityByName('batrider_flaming_lasso')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(FlamingLasso, Target)
        return
    end
end

function X.Consider()
    if not FlamingLasso:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, FlamingLasso:GetCastRange()) + 300

    if J.IsGoingOnSomeone(bot)
	then
        local nTarget = nil
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidTarget(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                nTarget = enemyHero
                break
            end
        end

        if nTarget ~= nil
        then
            local nInRangeAlly = nTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and (#nInRangeAlly >= #nTargetInRangeAlly or J.WeAreStronger(bot, 1200))
            then
                return BOT_ACTION_DESIRE_HIGH, nTarget
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X