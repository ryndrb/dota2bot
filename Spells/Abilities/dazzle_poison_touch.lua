local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local PoisonTouch

function X.Cast()
    bot = GetBot()
    PoisonTouch = bot:GetAbilityByName('dazzle_poison_touch')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(PoisonTouch, Target)
        return
    end
end

function X.Consider()
    if not PoisonTouch:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nSkillLV = PoisonTouch:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, PoisonTouch:GetCastRange())
	local nManaCost = PoisonTouch:GetManaCost()
	local nPerDamage = PoisonTouch:GetSpecialValueInt( "damage" )

    if string.find(bot:GetUnitName(), 'dazzle')
    then
        local talent20left = bot:GetAbilityByName('special_bonus_unique_dazzle_3')
        if talent20left:IsTrained() then nPerDamage = nPerDamage + talent20left:GetSpecialValueInt( "value" ) end
    end

	local nDuration = PoisonTouch:GetSpecialValueInt( "duration" )

	local nDamage = nPerDamage * nDuration

	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.IsInRange(bot, npcEnemy, nCastRange + 200)
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
			and J.CanKillTarget( npcEnemy, nDamage, nDamageType )
            and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
            and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyHealth = 10000

		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
                and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyHealth = npcEnemy:GetHealth()
				if ( npcEnemyHealth < npcWeakestEnemyHealth )
				then
					npcWeakestEnemyHealth = npcEnemyHealth
					npcWeakestEnemy = npcEnemy
				end
			end
		end

		if npcWeakestEnemy ~= nil
			and J.IsInRange( bot, npcWeakestEnemy, nCastRange + 100 )
		then
			return BOT_ACTION_DESIRE_HIGH, npcWeakestEnemy
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange + 50 )
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.CanCastOnTargetAdvanced( botTarget )
		then
			if nSkillLV >= 2 or J.GetMP(bot) > 0.68 or J.GetHP( botTarget ) < 0.43 or J.GetHP(bot) <= 0.4
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsFarming( bot )
		and nSkillLV >= 3
		and nAllyHeroes ~= nil and #nAllyHeroes <= 1
		and J.IsAllowedToSpam( bot, nManaCost * 0.25 )
	then
		local nCreeps = bot:GetNearbyNeutralCreeps( nCastRange + 200 )

		local targetCreep = J.GetMostHpUnit( nCreeps )

		if J.IsValid( targetCreep )
			and not J.IsRoshan( targetCreep )
			and #nCreeps >= 3
			and bot:IsFacingLocation( targetCreep:GetLocation(), 40 )
			and ( targetCreep:GetMagicResist() < 0.3 or J.GetMP(bot) > 0.9 )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.88, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost )
		and nSkillLV >= 3 and DotaTime() > 6 * 60
        and nAllyHeroes ~= nil and #nAllyHeroes <= 2
        and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nLaneCreeps = bot:GetNearbyLaneCreeps( nCastRange + 300, true )
		local targetCreep = nLaneCreeps[3]

		if #nLaneCreeps >= 4
			and J.IsValid( targetCreep )
			and J.CanBeAttacked(targetCreep)
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.88, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.CanBeAttacked(botTarget)
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if ( nEnemyHeroes ~= nil and #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero( 3.0 ) )
		and ( not J.IsRetreating(bot) or nAllyHeroes ~= nil and #nAllyHeroes >= 2 )
		and J.IsValidHero(nEnemyHeroes[1])
		and nSkillLV >= 4
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X