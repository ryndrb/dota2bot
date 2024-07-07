local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local InnerFire

function X.Cast()
    bot = GetBot()
    InnerFire = bot:GetAbilityByName('huskar_inner_fire')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(InnerFire)
        return
    end
end

function X.Consider()
    if not InnerFire:IsFullyCastable() then return 0 end

	local nSkillLV = InnerFire:GetLevel()
	local nCastPoint = InnerFire:GetCastPoint()
	local nDamage = InnerFire:GetSpecialValueInt( 'damage' )
	local nRadius = InnerFire:GetSpecialValueInt( 'radius' )
	local nDamageType = DAMAGE_TYPE_MAGICAL
    local botTarget = J.GetProperTarget(bot)
	local nInRangeEnemyList = bot:GetNearbyHeroes( nRadius -32, true, BOT_MODE_NONE )

	local nCanHurtCount = 0
	for _, npcEnemy in pairs( nInRangeEnemyList )
	do
		if J.IsValidHero( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
		then

			nCanHurtCount = nCanHurtCount + 1
			if nCanHurtCount >= 2
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.WillMagicKillTarget( bot, npcEnemy, nDamage, nCastPoint )
            and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
            and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.IsRetreating( bot )
            and not J.IsRealInvisible(bot)
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH
			end

		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nRadius -32 )
			and ( not J.IsInRange( bot, botTarget, 200 )
				or J.IsAttacking( botTarget )
				or botTarget:GetAttackTarget() ~= nil )
			and J.CanCastOnNonMagicImmune( botTarget )
			and not J.IsDisabled( botTarget )
			and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    local nLaneCreepList = bot:GetNearbyLaneCreeps( nRadius, true )

	if J.IsLaning( bot )
	then
		local nCanKillCount = 0
		for _, creep in pairs( nLaneCreepList )
		do
			if J.IsValid( creep )
				and J.CanBeAttacked(creep)
				and J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint )
			then
				nCanKillCount = nCanKillCount + 1
			end
		end
		if nCanKillCount >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming( bot ) and bot:GetLevel() >= 8
        and J.GetHP(bot) > 0.45
	then
		local nCreepList = bot:GetNearbyNeutralCreeps( nRadius )
		local targetCreep = nCreepList[1]
		if nCreepList ~= nil and #nCreepList >= 2
			and J.IsValid( targetCreep )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 2.2, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    local hAllyList = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if hEnemyList ~= nil and #hEnemyList == 0 and hAllyList ~= nil and #hAllyList <= 2 and nSkillLV >= 3 and bot:GetLevel() >= 8
		and J.GetHP(bot) > 0.4
		and ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
	then
		local nCanKillCount = 0
		nCanHurtCount = 0
		for _, creep in pairs( nLaneCreepList )
		do
			if J.IsValid( creep )
				and J.CanBeAttacked(creep)
			then
				nCanHurtCount = nCanHurtCount + 1

				if J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint )
				then
					nCanKillCount = nCanKillCount + 1
				end
			end
		end

		if nCanKillCount >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
		if nCanHurtCount >= 4
		then
			return BOT_ACTION_DESIRE_HIGH
		end

	end

	if J.IsDoingRoshan( bot )
	then
		if J.IsRoshan( botTarget )
			and J.IsInRange( bot, botTarget, nRadius)
			and J.GetHP( botTarget ) > 0.3
            and J.GetHP(bot) > 0.45
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor( bot )
	then
		if J.IsTormentor( botTarget )
			and J.IsInRange( bot, botTarget, nRadius)
            and J.GetHP(bot) > 0.45
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X