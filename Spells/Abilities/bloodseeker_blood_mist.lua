local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BloodMist

function X.Cast()
    bot = GetBot()
    BloodMist = bot:GetAbilityByName('bloodseeker_blood_mist')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(BloodMist)
        return
    end
end

function X.Consider()
    if not bot:HasScepter()
	or not BloodMist:IsFullyCastable()
	then
		return BOT_MODE_NONE
	end

	local nRadius = BloodMist:GetSpecialValueInt('radius')
	local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	local botTarget = J.GetProperTarget(bot)

	if BloodMist:GetToggleState() == true
	then
		if J.GetHP(bot) < 0.2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not BloodMist:GetToggleState() == false
	and J.GetHP(bot) > 0.5
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_MODE_NONE
end

return X