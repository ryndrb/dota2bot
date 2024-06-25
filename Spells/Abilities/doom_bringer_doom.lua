local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Doom

function X.Cast()
    bot = GetBot()
    Doom = bot:GetAbilityByName('doom_bringer_doom')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Doom, Target)
        return
    end
end

function X.Consider()
    if not Doom:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nDuration = Doom:GetSpecialValueInt('duration')

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local dmg = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_doom_bringer_doom')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
                local estDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
                if dmg < estDmg
                then
                    dmg = estDmg
                    target = enemyHero
                end
			end
		end

		if target ~= nil
		then
            if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
            then
                if J.IsInLaningPhase()
                then
                    if  not (#nAllyHeroes >= #nEnemyHeroes + 2)
                    and J.IsAttacking(target)
                    then
                        if target:GetHealth() <= bot:GetEstimatedDamageToTarget(true, target, nDuration, DAMAGE_TYPE_ALL)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    end
                else
                    if #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
                    then
                        if target:GetHealth() <= bot:GetEstimatedDamageToTarget(true, target, nDuration, DAMAGE_TYPE_ALL)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    else
                        if not (#nAllyHeroes >= #nEnemyHeroes + 2)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    end
                end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X