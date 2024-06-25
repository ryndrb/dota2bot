local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local HandOfGod

function X.Cast()
    bot = GetBot()
    HandOfGod = bot:GetAbilityByName('chen_hand_of_god')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(HandOfGod)
        return
    end
end

function X.Consider()
    if not HandOfGod:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    if nTeamFightLocation ~= nil
    then
        local nAllyList = J.GetAlliesNearLoc(nTeamFightLocation, 1600)

        for _, allyHero in pairs(nAllyList)
        do
            if  J.IsValidHero(allyHero)
            and J.IsCore(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:IsAttackImmune()
			and not allyHero:IsInvulnerable()
            and J.GetHP(allyHero) < 0.63
            and allyHero:WasRecentlyDamagedByAnyHero(3)
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero) and allyHero:GetActiveModeDesire() >= 0.65
        and allyHero:DistanceFromFountain() > 1000
        and J.IsCore(allyHero)
        and not allyHero:IsAttackImmune()
		and not allyHero:IsInvulnerable()
        and J.GetHP(allyHero) < 0.5
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not J.IsSuspiciousIllusion(allyHero)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
            and J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X