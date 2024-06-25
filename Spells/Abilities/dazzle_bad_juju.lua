local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BadJuJu

function X.Cast()
    bot = GetBot()
    BadJuJu = bot:GetAbilityByName('dazzle_bad_juju')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(BadJuJu)
        return
    end
end

function X.Consider()
    if not BadJuJu:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE end

    local nBaseHealth = 75
    local nCDR = BadJuJu:GetSpecialValueInt('cooldown_reduction')
    local nJuJuStacks = bot:GetModifierStackCount(bot:GetModifierByName('modifier_dazzle_bad_juju_manacost'))

    local _, PoisonTouch = J.HasAbility(bot, 'dazzle_poison_touch')
    local _, ShallowGrave = J.HasAbility(bot, 'dazzle_shallow_grave')
    local _, ShadowWave = J.HasAbility(bot, 'dazzle_shadow_wave')

    if J.IsRetreating(bot) and J.IsRealInvisible(bot) and ShallowGrave ~= nil and not ShallowGrave:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if PoisonTouch ~= nil and not PoisonTouch:IsFullyCastable()
    and ShallowGrave ~= nil and not ShallowGrave:IsFullyCastable()
    and ShadowWave ~= nil and not ShadowWave:IsFullyCastable()
    and (bot:HasModifier('modifier_dazzle_shallow_grave') or J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.25)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if ShallowGrave ~= nil and ShallowGrave:GetCooldownTimeRemaining() > nCDR
    and J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.15
	then
		return BOT_ACTION_DESIRE_HIGH
	end

    if not string.find(bot:GetUnitName(), 'dazzle')
    and J.IsGoingOnSomeone(bot)
    then
        local sAbilityList = J.Skill.GetAbilityList(bot)
        local ability1 = bot:GetAbilityByName(sAbilityList[1])
        local ability2 = bot:GetAbilityByName(sAbilityList[2])
        local ability3 = bot:GetAbilityByName(sAbilityList[3])

        if J.IsGoingOnSomeone(bot)
        and J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.25
        then
            if (ability1 ~= nil and not ability1:IsPassive() and ability1:GetCooldownTimeRemaining() > nCDR)
            or (ability2 ~= nil and not ability2:IsPassive() and ability2:GetCooldownTimeRemaining() > nCDR)
            or (ability3 ~= nil and not ability3:IsPassive() and ability3:GetCooldownTimeRemaining() > nCDR)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X