local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local LifeBreak

function X.Cast()
    bot = GetBot()
    LifeBreak = bot:GetAbilityByName('huskar_life_break')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LifeBreak, Target)
        return
    end
end

function X.Consider()
    if not LifeBreak:IsFullyCastable() then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, LifeBreak:GetCastRange())
    local botTarget = J.GetProperTarget(bot)

    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone( bot )
	then
        if bot:HasScepter()
        then
            for _, enemyHero in pairs(hEnemyList)
            do
                if J.IsValidHero(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange + 88)
                and bot:GetUnitName() == 'npc_dota_hero_bristleback'
                and J.CanCastOnNonMagicImmune( enemyHero )
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    bot:SetTarget(enemyHero)
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end

		if J.IsValidHero( botTarget )
			and J.CanCastOnNonMagicImmune( botTarget )
            and J.CanCastOnTargetAdvanced(botTarget)
			and ( J.IsInRange( bot, botTarget, nCastRange + 88 )
				  or J.IsInRange( bot, botTarget, bot:GetAttackRange() + 99 ) )
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    local hAllyList = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	if bot:GetLevel() >= 12 and hEnemyList ~= nil and #hEnemyList == 0
		and bot:GetLevel() > 0.38 and hAllyList ~= nil and #hAllyList < 3
		and nCastRange > bot:GetAttackRange() + 58
	then
		if J.IsValid( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and not J.IsInRange( bot, botTarget, nCastRange -80 )
			and J.GetHP( botTarget ) > 0.9
			and not botTarget:IsHero()
			and not J.IsRoshan( botTarget )
            and not J.IsTormentor(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X