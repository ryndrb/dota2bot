local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DragonTail

function X.Cast()
    bot = GetBot()
    DragonTail = bot:GetAbilityByName('dragon_knight_dragon_tail')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DragonTail, Target)
        return
    end
end

function X.Consider()
    if ( not DragonTail:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = DragonTail:GetCastRange()
	local nDamage = DragonTail:GetAbilityDamage()

	if bot:GetAttackRange() > 300
	then
		nCastRange = 400
	end

    local npcTarget = J.GetProperTarget( bot )

	local nEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 240, true, BOT_MODE_NONE )

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero(npcEnemy)
        and J.IsInRange(bot, npcEnemy, nCastRange + 300)
        and J.CanCastOnNonMagicImmune( npcEnemy )
        and J.CanCastOnTargetAdvanced( npcEnemy )
        and ( J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL ) or npcEnemy:IsChanneling() )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsValidHero(nEnemyHeroes[1])
    then
		for i = 1, #nEnemyHeroes
        do
			if J.IsValidHero( nEnemyHeroes[i] )
            and J.IsInRange(bot, nEnemyHeroes[i], 800)
            and J.CanCastOnNonMagicImmune( nEnemyHeroes[i] )
            and J.CanCastOnTargetAdvanced( nEnemyHeroes[i] )
            and nEnemyHeroes[i]:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[i]
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and not J.IsDisabled( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange + 300)
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not npcEnemy:IsDisarmed()
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_ALL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end


	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero(nEnemyHeroes[1])
        and not J.IsDisabled( nEnemyHeroes[1] )
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange + 240)
        and J.CanCastOnNonMagicImmune( nEnemyHeroes[1] )
        and J.CanCastOnTargetAdvanced( nEnemyHeroes[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if ( J.IsRoshan( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange )
			and not J.IsDisabled( npcTarget ) )
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_LOW, npcTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_LOW, npcTarget
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( npcTarget )
        and not J.IsDisabled( npcTarget )
        and J.CanCastOnNonMagicImmune( npcTarget )
        and J.CanCastOnTargetAdvanced( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange + 240 )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X