local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ShurikenToss

function X.Cast()
    bot = GetBot()
    ShurikenToss = bot:GetAbilityByName('bounty_hunter_shuriken_toss')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ShurikenToss, Target)
        return
    end
end

function X.Consider()
    if not ShurikenToss:IsFullyCastable() then return 0 end

	local nSkillLV = ShurikenToss:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, ShurikenToss:GetCastRange())
	local nCastPoint = ShurikenToss:GetCastPoint()
	local nManaCost = ShurikenToss:GetManaCost()
	local nDamage = ShurikenToss:GetSpecialValueInt( 'bonus_damage' )
	local nDamageType = DAMAGE_TYPE_MAGICAL

    local botTarget = J.GetProperTarget(bot)

	local nRadius = ShurikenToss:GetSpecialValueInt( "bounce_aoe" )
	local nEnemyUnitList = J.GetAroundBotUnitList(bot, nCastRange + 150, true)
	local nTrackEnemyList = {}

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true )

    if string.find(bot:GetUnitName(), 'bounty_hunter')
    then
        local Talent7 = bot:GetAbilityByName('special_bonus_unique_bounty_hunter_2')
        if Talent7:IsTrained()
        then
            nDamage = nDamage + Talent7:GetSpecialValueInt('value')
        end
    end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if J.IsValidHero(enemyHero)
		then
			if enemyHero:HasModifier( "modifier_bounty_hunter_track" )
			then
				nTrackEnemyList[#nTrackEnemyList + 1] = enemyHero
			end

			if enemyHero:IsChanneling()
			and not enemyHero:IsMagicImmune()
			then
				if enemyHero:HasModifier("modifier_bounty_hunter_track")
				then
					for _, nUnit in pairs(nEnemyUnitList)
					do
						if J.IsValid( nUnit )
							and J.CanCastOnTargetAdvanced( nUnit )
							and not nUnit:IsMagicImmune()
						then
							return BOT_ACTION_DESIRE_HIGH, nUnit
						end
					end
				end

				if J.IsInRange( bot, enemyHero, nCastRange + 300 )
                and J.CanCastOnTargetAdvanced(enemyHero)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if J.CanCastOnNonMagicImmune( enemyHero )
            and J.WillMagicKillTarget( bot, enemyHero, nDamage, nCastPoint + GetUnitToUnitDistance( bot, enemyHero )/1000 )
			then
				if enemyHero:HasModifier( "modifier_bounty_hunter_track" )
				then
					for _, nUnit in pairs( nEnemyUnitList )
					do
						if J.IsValid( nUnit )
                        and J.CanCastOnTargetAdvanced( nUnit )
                        and not nUnit:IsMagicImmune()
						then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end

				if J.IsInRange( bot, enemyHero, nCastRange + 300 )
                and J.CanCastOnTargetAdvanced( enemyHero )
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if #nTrackEnemyList >= 2
	then
		local nBestUnit = nil
		local nMaxBounceCount = 1.2
		for _, nUnit in pairs( nEnemyUnitList )
		do
			if J.IsValid( nUnit )
				and not nUnit:IsMagicImmune()
				and J.CanCastOnTargetAdvanced( nUnit )
			then
				local nBounceCount = 0

				if not nUnit:HasModifier( "modifier_bounty_hunter_track" )
				then
					if nUnit:IsHero()
					then
						nBounceCount = nBounceCount + 1
					else
						nBounceCount = nBounceCount + 0.1
					end
				end

				for _, npcEnemy in pairs( nTrackEnemyList )
				do
					if J.IsInRange( nUnit, npcEnemy, nRadius - 80 )
					then
						nBounceCount = nBounceCount + 1
					end
				end

				if nBounceCount > nMaxBounceCount
				then
					nBestUnit = nUnit
					nMaxBounceCount = nBounceCount
				end
			end
		end

		if nBestUnit ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nBestUnit
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange + nRadius + 150 )
        and J.CanCastOnNonMagicImmune( botTarget )
		then
			if botTarget:HasModifier( "modifier_bounty_hunter_track" )
			then
				for _, nUnit in pairs( nEnemyUnitList )
				do
					if J.IsInRange( nUnit, botTarget, nRadius - 100 )
                    and not nUnit:IsMagicImmune()
                    and J.CanCastOnTargetAdvanced( nUnit )
                    and not nUnit:HasModifier( "modifier_bounty_hunter_track" )
					then
						nCastTarget = nUnit
						return BOT_ACTION_DESIRE_HIGH, nUnit
					end
				end
			end

			if J.IsInRange( bot, botTarget, nCastRange )
            and J.CanCastOnTargetAdvanced( botTarget )
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if ( J.IsLaning(bot) or ( bot:GetLevel() <= 7 and nAllyHeroes ~= nil and #nAllyHeroes <= 2 ) )
    and bot:GetMana() >= 150
	and J.IsCore(bot)
	then
		local keyWord = "ranged"
		for _, creep in pairs( nEnemyLaneCreeps )
		do
			if J.IsValid( creep )
            and J.IsInRange(bot, creep, nCastRange + 300)
            and J.CanBeAttacked(creep)
            and J.IsKeyWordUnit( keyWord, creep )
            and J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint + GetUnitToUnitDistance( bot, creep )/1100 )
            and GetUnitToUnitDistance( creep, bot ) > 300
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, nManaCost * 0.52 )
    and ( bot:GetAttackDamage() < 300 or J.GetMP(bot) > 0.7 )
    and nSkillLV >= 2 and DotaTime() > 7 * 60
    and nAllyHeroes ~= nil and #nAllyHeroes == 0
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local keyWord = "ranged"
		for _, creep in pairs( nEnemyLaneCreeps )
		do
			if J.IsValid( creep )
            and J.IsInRange(bot, creep, nCastRange + 350)
            and J.IsKeyWordUnit( keyWord, creep )
            and J.CanBeAttacked(creep)
            and J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint + GetUnitToUnitDistance( bot, creep )/1100 )
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.2, DAMAGE_TYPE_PHYSICAL )
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if J.IsFarming( bot )
    and nSkillLV >= 3
    and J.IsAllowedToSpam( bot, nManaCost )
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps( nCastRange + 300 )
		local targetCreep = J.GetMostHpUnit( nNeutralCreeps )

		if J.IsValid( targetCreep )
			and not J.IsRoshan( targetCreep )
			and ( (nNeutralCreeps ~= nil and #nNeutralCreeps >= 2) or GetUnitToUnitDistance( targetCreep, bot ) <= 400 )
			and bot:IsFacingLocation( targetCreep:GetLocation(), 40 )
			and ( targetCreep:GetMagicResist() < 0.3 or J.GetMP(bot) > 0.9 )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.68, DAMAGE_TYPE_PHYSICAL )
			and not J.CanKillTarget( targetCreep, nDamage - 50, nDamageType )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.GetHP( botTarget ) > 0.2
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

	return BOT_ACTION_DESIRE_NONE
end

return X