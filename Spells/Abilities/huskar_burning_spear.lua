local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BurningSpear

function X.Cast()
    bot = GetBot()
    BurningSpear = bot:GetAbilityByName('huskar_burning_spear')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(BurningSpear, Target)
        return
    end
end

local lastAutoTime = 0
function X.Consider()
    if not BurningSpear:IsFullyCastable() or bot:IsDisarmed() then return 0 end

	local nCastRange = bot:GetAttackRange() + 50

	local nAttackDamage = bot:GetAttackDamage()
    local botTarget = J.GetProperTarget(bot)

	local nTowerList = bot:GetNearbyTowers( 800, true )
	local nInAttackRangeWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, nCastRange, true, true )

    local hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if bot:GetLevel() >= 7
	then
		if ( hEnemyList[1] ~= nil
			or ( bot:GetLevel() >= 15 and J.GetHP(bot) > 0.38 ) )
			and not BurningSpear:GetAutoCastState()
		then
			lastAutoTime = DotaTime()
			BurningSpear:ToggleAutoCast()
		elseif hEnemyList[1] == nil
				and lastAutoTime < DotaTime() - 3.0
				and BurningSpear:GetAutoCastState()
			then
				BurningSpear:ToggleAutoCast()
		end
	else
		if BurningSpear:GetAutoCastState()
		then
			BurningSpear:ToggleAutoCast()
		end
	end

	if bot:GetLevel() <= 6 and not BurningSpear:GetAutoCastState()
		and J.IsValidHero( botTarget )
		and J.IsInRange( bot, botTarget, nCastRange + 99 )
		and ( not J.IsRunning( bot ) or J.IsInRange( bot, botTarget, nCastRange + 39 ) )
		and not botTarget:IsMagicImmune()
		and not botTarget:IsAttackImmune()
	then
		return BOT_ACTION_DESIRE_HIGH, botTarget
	end

	if J.IsLaning( bot ) and #nTowerList == 0 and J.GetHP(bot) > 0.5
	then
		if J.IsWithoutTarget( bot )
			and not J.IsAttacking( bot )
		then
			local nLaneCreepList = bot:GetNearbyLaneCreeps( 666, true )
			for _, creep in pairs( nLaneCreepList )
			do
				if J.IsValid( creep )
					and J.CanBeAttacked(creep)
					and creep:GetHealth() < nAttackDamage * 2.8
					and not J.IsAllysTarget( creep )
				then
					local nAttackProDelayTime = J.GetAttackProDelayTime( bot, creep ) * 1.12 + 0.05
					local nAD = nAttackDamage * 1.0
					if J.WillKillTarget( creep, nAD, DAMAGE_TYPE_PHYSICAL, nAttackProDelayTime )
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end

		end

		local nWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, 600, true, true )
		local nAllyCreepList = bot:GetNearbyCreeps( 500, false )
		local nEnemyCreepList = bot:GetNearbyCreeps( 800, true )
		if J.IsValidHero(nWeakestEnemyHero)
			and #nAllyCreepList >= 1
			and #nEnemyCreepList - #nAllyCreepList <= 4
			and not nWeakestEnemyHero:IsMagicImmune()
			and not bot:WasRecentlyDamagedByCreep( 1.5 )
		then
			return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHero
		end
	end

	if J.IsValidHero(botTarget)
		and not J.IsInRange( bot, botTarget, nCastRange + 120 )
		and J.IsValidHero( nInAttackRangeWeakestEnemyHero )
		and not nInAttackRangeWeakestEnemyHero:IsAttackImmune()
		and not nInAttackRangeWeakestEnemyHero:IsMagicImmune()
        and not nInAttackRangeWeakestEnemyHero:HasModifier('modifier_item_blade_mail_reflect')
	then
		bot:SetTarget( nInAttackRangeWeakestEnemyHero )
		return BOT_ACTION_DESIRE_HIGH, nInAttackRangeWeakestEnemyHero
	end

	if J.IsGoingOnSomeone( bot ) and not BurningSpear:GetAutoCastState()
	then
		if J.IsValidHero( botTarget )
			and not botTarget:IsAttackImmune()
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange + 80 )
            and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsFarming( bot ) and bot:GetLevel() >= 7 and not BurningSpear:GetAutoCastState()
	then
		local nCreepList = bot:GetNearbyNeutralCreeps( nCastRange + 80 )
		local hMostHPCreep = J.GetMostHpUnit( nCreepList )
		local hTargetCreep = nil
		local nTargetHealth = 0
		for _, creep in pairs( nCreepList )
		do
			if J.IsValid( creep )
				and not creep:HasModifier( "modifier_huskar_burning_spear_debuff" )
				and creep:GetHealth() > nTargetHealth
			then
				hTargetCreep = creep
				nTargetHealth = creep:GetHealth()
			end
		end

		if J.IsValid(hTargetCreep)
		then
			return BOT_ACTION_DESIRE_HIGH, hTargetCreep
		end

		if J.IsValid(hTargetCreep)
			and not J.CanKillTarget( hMostHPCreep, nAttackDamage * 2.6, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, hMostHPCreep
		end

	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and bot:GetLevel() > 9 and #hEnemyList <= 1 and not BurningSpear:GetAutoCastState()
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps( nCastRange + 80, true )
		local nAllyLaneCreeps = bot:GetNearbyLaneCreeps( 1200, false )
		local nWeakestCreep = J.GetAttackableWeakestUnit( bot, nCastRange + 200, false, true )

		if ( #nAllyLaneCreeps == 0
			or ( J.IsValid(nWeakestCreep) and nWeakestCreep:GetHealth() > bot:GetAttackDamage() + 88 ) )
			and #nEnemyLaneCreeps >= 2
		then
			local hTargetCreep = nil
			local nTargetHealth = 0
			for _, creep in pairs( nEnemyLaneCreeps )
			do
				if J.IsValid( creep )
					and not J.IsKeyWordUnit( 'siege', creep )
					and not creep:HasModifier( "modifier_huskar_burning_spear_debuff" )
					and not J.CanKillTarget( creep, nAttackDamage * 1.68, DAMAGE_TYPE_PHYSICAL )
					and creep:GetHealth() > nTargetHealth
				then
					hTargetCreep = creep
					nTargetHealth = creep:GetHealth()
				end
			end

			if J.IsValid(hTargetCreep)
			then
				return BOT_ACTION_DESIRE_HIGH, hTargetCreep
			end
		end

	end

	if J.IsDoingRoshan( bot ) and not BurningSpear:GetAutoCastState()
	then
		if J.IsRoshan( bot:GetAttackTarget() )
			and J.IsInRange( bot, botTarget, nCastRange -40 )
            and J.IsAttacking(bot)
            and J.GetHP(bot) > 0.3
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor( bot ) and not BurningSpear:GetAutoCastState()
	then
		if J.IsTormentor( bot:GetAttackTarget() )
			and J.IsInRange( bot, botTarget, nCastRange -40 )
            and J.IsAttacking(bot)
            and J.GetHP(bot) > 0.35
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end


	return BOT_ACTION_DESIRE_NONE
end

return X