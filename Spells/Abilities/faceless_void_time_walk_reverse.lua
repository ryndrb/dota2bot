local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local TimeWalkReverse

function X.Cast()
    bot = GetBot()
    TimeWalkReverse = bot:GetAbilityByName('faceless_void_time_walk_reverse')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(TimeWalkReverse)
        return
    end
end

function X.Consider()
    if not TimeWalkReverse:IsTrained()
	or not TimeWalkReverse:IsFullyCastable()
	or not TimeWalkReverse:IsActivated()
	then
		return BOT_ACTION_DESIRE_NONE
	end

    local botTarget = J.GetProperTarget(bot)

	if J.IsStunProjectileIncoming(bot, 350)
	or J.IsUnitTargetProjectileIncoming(bot, 350)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 350)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  not bot:HasModifier('modifier_faceless_void_chronosphere_speed')
	and J.IsValidTarget(botTarget)
	and J.IsInRange(bot, botTarget, 1600)
	and not J.IsSuspiciousIllusion(botTarget)
	then
		local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

		local isPrevLocDist1 = GetUnitToLocationDistance(bot, bot.TimeWalkPrevLocation) > GetUnitToLocationDistance(botTarget, bot.TimeWalkPrevLocation)
		local isPrevLocDist2 = GetUnitToLocationDistance(bot, bot.TimeWalkPrevLocation) > GetUnitToUnitDistance(bot, botTarget)

		if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		then
			if  #nInRangeEnemy > #nInRangeAlly
			and isPrevLocDist1
			and isPrevLocDist2
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if bot.InfoBuffer ~= nil
		then
			-- try to backtrack ~^40% of damage
			for i = 1, 3
			do
				local prevHealth = bot.InfoBuffer[i].health
				if prevHealth and (prevHealth / bot:GetMaxHealth()) - J.GetHP(bot) >= 0.4
				and isPrevLocDist1 and isPrevLocDist2
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X