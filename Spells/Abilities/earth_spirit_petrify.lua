local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local EchantRemnant

function X.Cast()
    bot = GetBot()
    EchantRemnant = bot:GetAbilityByName('earth_spirit_petrify')

    local _, BoulderSmash = J.HasAbility(bot, 'earth_spirit_boulder_smash')

    Desire, Target = X.Consider()
    if Desire > 0
    and BoulderSmash ~= nil and BoulderSmash:IsFullyCastable()
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(EchantRemnant, Target)
		bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, bot:GetLocation() + RandomVector(800))
		return
    end
end

function X.Consider()
    if not EchantRemnant:IsTrained()
	or not EchantRemnant:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X