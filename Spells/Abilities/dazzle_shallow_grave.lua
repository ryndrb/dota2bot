local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ShallowGrave

function X.Cast()
    bot = GetBot()
    ShallowGrave = bot:GetAbilityByName('dazzle_shallow_grave')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ShallowGrave, Target)
        return
    end
end

function X.Consider()
    if not ShallowGrave:IsFullyCastable() then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, ShallowGrave:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

	for _, npcAlly in pairs( nAllyHeroes )
	do
		if J.IsValidHero( npcAlly )
        and not npcAlly:IsIllusion()
        and J.IsInRange( bot, npcAlly, nCastRange + 600 )
        and not npcAlly:HasModifier( 'modifier_dazzle_shallow_grave' )
        and J.GetHP( npcAlly ) < 0.4
		then
			local nCastDelay = X.GetCastShallowGraveDelay( npcAlly, nCastRange ) * 1.1
			if X.GetEnemyFacingAllyDamage( npcAlly, 1100, nCastDelay ) > npcAlly:GetHealth()
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

			if npcAlly:GetHealth() < 200
			then

				if npcAlly:HasModifier( 'modifier_sniper_assassinate' )
				then
					return BOT_ACTION_DESIRE_HIGH, npcAlly
				end

				if npcAlly:HasModifier( 'modifier_huskar_burning_spear_counter' )
                or npcAlly:HasModifier( 'modifier_jakiro_macropyre_burn' )
                or npcAlly:HasModifier( 'modifier_necrolyte_reapers_scythe' )
                or npcAlly:HasModifier( 'modifier_viper_viper_strike_slow' )
                or npcAlly:HasModifier( 'modifier_viper_nethertoxin' )
                or npcAlly:HasModifier( 'modifier_viper_poison_attack_slow' )
                or npcAlly:HasModifier( 'modifier_maledict' )
				then
					return BOT_ACTION_DESIRE_HIGH, npcAlly
				end
			end

			if J.GetHP( npcAlly ) < 0.13
            and J.IsInRange( bot, npcAlly, nCastRange + 200 )
            and J.GetEnemyCount( npcAlly, 600 ) >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetCastShallowGraveDelay( npcAlly, nCastRange )
	if not J.IsInRange( bot, npcAlly, nCastRange )
	then
		local nDistance = GetUnitToUnitDistance( bot, npcAlly ) - nCastRange
		local moveDelay = nDistance/bot:GetCurrentMovementSpeed()

		return 0.4 + moveDelay + 1.3
	end

	return 0.4 + 1.1
end

function X.GetEnemyFacingAllyDamage( npcAlly, nRadius, nDelay )
	local enemyList = J.GetEnemyList( npcAlly, nRadius )
	local totalDamage = 0

	for _, npcEnemy in pairs( enemyList )
	do
		if J.IsValidHero(npcEnemy)
        and (npcEnemy:IsFacingLocation( npcAlly:GetLocation(), 15 )
			or npcEnemy:GetAttackTarget() == npcAlly)
		then
			local enemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, npcAlly, nDelay, DAMAGE_TYPE_ALL )
			totalDamage = totalDamage + enemyDamage
		end
	end

	return totalDamage
end

return X