local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local EchoSlam

function X.Cast()
    bot = GetBot()
    EchoSlam = bot:GetAbilityByName('earthshaker_echo_slam')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end
end

function X.Consider()
    if not EchoSlam:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')
    local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius / 2)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius / 2)
        and J.IsCore(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
        and not botTarget:IsInvulnerable()
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            then
                if #nInRangeAlly <= 1 and #nInRangeEnemy <= 1
                then
                    if botTarget:IsChanneling()
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end

                    if botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                if #nInRangeEnemy > #nInRangeAlly
                then
                    if botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5, DAMAGE_TYPE_ALL)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                if  #nInRangeAlly >= #nInRangeEnemy
                and not (#nInRangeAlly >= #nInRangeEnemy + 2)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X