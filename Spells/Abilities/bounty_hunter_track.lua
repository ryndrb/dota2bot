local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Track

function X.Cast()
    bot = GetBot()
    Track = bot:GetAbilityByName('bounty_hunter_track')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Track, Target)
        return
    end
end

function X.Consider()
    if not Track:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, Track:GetCastRange())
	local nCastTarget = nil

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local nMinHealth = 999999
	for _, enemyHero in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( enemyHero )
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastAbilityOnTarget( enemyHero, false )
        and J.CanCastOnTargetAdvanced( enemyHero )
        and not enemyHero:HasModifier( "modifier_bounty_hunter_track" )
        and enemyHero:GetHealth() < nMinHealth
		then
			nCastTarget = enemyHero
			nMinHealth = enemyHero:GetHealth()
		end
	end

	if nCastTarget ~= nil
	then
		return BOT_ACTION_DESIRE_HIGH, nCastTarget
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X