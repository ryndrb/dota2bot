local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local IceBlastRelease

function X.Cast()
    bot = GetBot()
    IceBlastRelease = bot:GetAbilityByName('ancient_apparition_ice_blast_release')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(IceBlastRelease)
        return
    end
end

function X.Consider()
    if IceBlastRelease:IsHidden()
    or not IceBlastRelease:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nProjectiles = GetLinearProjectiles()

    for _, p in pairs(nProjectiles)
	do
		if p ~= nil and p.ability:GetName() == "ancient_apparition_ice_blast"
        then
			if  bot.IceBlastReleaseLocation ~= nil
            and J.GetLocationToLocationDistance(bot.IceBlastReleaseLocation, p.location) < 100
            then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X