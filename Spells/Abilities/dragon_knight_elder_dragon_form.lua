local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ElderDragonForm

function X.Cast()
    bot = GetBot()
    ElderDragonForm = bot:GetAbilityByName('dragon_knight_elder_dragon_form')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ElderDragonForm)
        return
    end
end

function X.Consider()
    if ( not ElderDragonForm:IsFullyCastable() or J.GetHP( bot ) < 0.25 ) then
		return BOT_ACTION_DESIRE_NONE
	end

	if ( J.IsPushing( bot ) or J.IsFarming( bot ) or J.IsDefending( bot ) )
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyCreeps( 800, true )
		local tableNearbyTowers = bot:GetNearbyTowers( 800, true )
		if #tableNearbyEnemyCreeps >= 2 or #tableNearbyTowers >= 1
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and J.IsInRange( npcTarget, bot, 800 )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X