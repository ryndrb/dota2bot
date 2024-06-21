local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CounterSpellAlly

function X.Cast()
	bot = GetBot()
	CounterSpellAlly = bot:GetAbilityByName('antimage_counterspell_ally')

	Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(CounterSpellAlly, Target)
		return
    end
end

function X.Consider()
	if not CounterSpellAlly:IsTrained()
	or not CounterSpellAlly:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = CounterSpellAlly:GetCastRange()
	local nInRangeAlly = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)

	for _, allyHero in pairs(nInRangeAlly)
	do
		if  J.IsValidHero(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if  J.IsUnitTargetProjectileIncoming(allyHero, 400)
			and not allyHero:IsMagicImmune()
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if  not allyHero:HasModifier('modifier_sniper_assassinate')
			and not allyHero:IsMagicImmune()
			then
				if J.IsWillBeCastUnitTargetSpell(allyHero, nCastRange)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X