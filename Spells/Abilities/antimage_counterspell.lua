local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CounterSpell

function X.Cast()
	bot = GetBot()
	CounterSpell = bot:GetAbilityByName('antimage_counterspell')

	Desire = X.Consider()
	if Desire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(CounterSpell)
		return
	end
end

function X.Consider()
    if not CounterSpell:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsUnitTargetProjectileIncoming(bot, 400)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 1400)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X