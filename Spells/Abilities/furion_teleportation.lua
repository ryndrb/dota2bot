local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Teleportation

function X.Cast()
    bot = GetBot()
    Teleportation = bot:GetAbilityByName('furion_teleportation')

    if  bot.useProphetTP
    and bot.ProphetTPLocation ~= nil
    then
        bot:Action_UseAbilityOnLocation(Teleportation, bot.ProphetTPLocation)
        bot.useProphetTP = false
        return
    end

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Teleportation, Target)
        return
    end
end

function X.Consider()
    if not Teleportation:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nChannelTime = Teleportation:GetCastPoint()

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)
    if nTeamFightLocation ~= nil
    and (not J.IsCore(bot) or (J.IsCore(bot) and (not J.IsInLaningPhase() or bot:GetNetWorth() > 3500)))
    then
        if GetUnitToLocationDistance(bot, nTeamFightLocation) > 1600
        then
            local nAllyHeroes = J.GetAlliesNearLoc(nTeamFightLocation, 1200)

            if nAllyHeroes ~= nil and #nAllyHeroes >= 1
            and J.IsValidHero(nAllyHeroes[#nAllyHeroes])
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyHeroes[#nAllyHeroes], nChannelTime)
            end
        end
    end

    for i = 1, 5
    do
        local allyHero = GetTeamMember(i)

        if  J.IsValidHero(allyHero)
        and J.IsGoingOnSomeone(allyHero)
        and GetUnitToUnitDistance(bot, allyHero) > 2000
        and (not J.IsCore(bot) or (J.IsCore(bot) and (not J.IsInLaningPhase() or bot:GetNetWorth() > 3500)))
        and not allyHero:IsIllusion()
        then
            local allyTarget = allyHero:GetAttackTarget()
            local nAllyInRangeAlly = allyHero:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  J.IsValidTarget(allyTarget)
            and not allyTarget:IsAttackImmune()
            and J.IsInRange(allyHero, allyTarget, 800)
            and J.GetHP(allyHero) > 0.25
            and not J.IsSuspiciousIllusion(allyTarget)
            and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nTargetInRangeAlly = allyTarget:GetNearbyHeroes(800, false, BOT_MODE_NONE)

                if  nAllyInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nAllyInRangeAlly + 1 >= #nTargetInRangeAlly
                and #nTargetInRangeAlly >= 2
                and not J.IsLocationInChrono(J.GetCorrectLoc(allyHero, nChannelTime))
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(allyHero, nChannelTime)
                end
            end
        end
    end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
    and bot:GetActiveModeDesire() > 0.75
    and bot:GetLevel() >= 6
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if J.IsValidHero(nInRangeEnemy[1])
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and (not J.IsInRange(bot, nInRangeEnemy[1], 600) or bot:IsMagicImmune() or not J.CanBeAttacked(bot))
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
	end

    if J.IsDoingRoshan(bot)
    then
        local roshan_loc = J.GetCurrentRoshanLocation()
        local nAllyHeroes = J.GetAlliesNearLoc(roshan_loc, 700)

        if nAllyHeroes ~= nil and #nAllyHeroes >= 2
        and GetUnitToLocationDistance(bot, roshan_loc) > 1600
        then
            return BOT_ACTION_DESIRE_HIGH, roshan_loc
        end
    end

    if J.IsDoingTormentor(bot)
    then
        local tormentor_loc = J.GetTormentorLocation(GetTeam())
        local nAllyHeroes = J.GetAlliesNearLoc(tormentor_loc, 700)

        if nAllyHeroes ~= nil and #nAllyHeroes >= 2
        and GetUnitToLocationDistance(bot, tormentor_loc) > 1600
        then
            return BOT_ACTION_DESIRE_HIGH, tormentor_loc
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X