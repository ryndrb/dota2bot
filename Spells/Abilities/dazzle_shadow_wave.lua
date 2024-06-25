local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ShadowWave

function X.Cast()
    bot = GetBot()
    ShadowWave = bot:GetAbilityByName('dazzle_shadow_wave')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ShadowWave, Target)
        return
    end
end

function X.Consider()
    if not ShadowWave:IsFullyCastable() then return 0 end

	local nSkillLV = ShadowWave:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, ShadowWave:GetCastRange())
	local nRadius = ShadowWave:GetSpecialValueInt( 'damage_radius' )
	local nDamage = ShadowWave:GetSpecialValueInt( 'damage' )
	local nMaxHealCount = ShadowWave:GetSpecialValueInt( 'tooltip_max_targets_inc_dazzle' )
	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local nInRangeAllyList = J.GetAlliesNearLoc( bot:GetLocation(), nCastRange + 300 )
    local botTarget = J.GetProperTarget(bot)

	local nWeakestAlly = J.GetLeastHpUnit( nInRangeAllyList )

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if string.find(bot:GetUnitName(), 'dazzle')
    then
        local talent15right = bot:GetAbilityByName('special_bonus_unique_dazzle_2')
        if talent15right:IsTrained() then nDamage = nDamage + talent15right:GetSpecialValueInt( "value" ) end
    end

	local nNeedHealHeroCount = 0
	for _, npcAlly in pairs( nAllyHeroes )
	do
		if J.IsValidHero(npcAlly)
        then
            if npcAlly:GetMaxHealth() - npcAlly:GetHealth() > nDamage
            then
                nNeedHealHeroCount = nNeedHealHeroCount + 1
            end
        end
	end

	if J.IsValid(nWeakestAlly)
	then
		if J.GetHP( nWeakestAlly ) < 0.8
        and ( nNeedHealHeroCount >= nMaxHealCount - 2 or nNeedHealHeroCount >= 4 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

		if J.GetHP( nWeakestAlly ) < 0.6
        and ( J.GetMP(bot) > 0.9
            or nNeedHealHeroCount >= nMaxHealCount - 3
            or nNeedHealHeroCount >= 3 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

		if J.GetHP( nWeakestAlly ) < 0.35
        or ( J.GetHP( nWeakestAlly ) < 0.5 and nNeedHealHeroCount >= 2 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end
	end

	if nAllyHeroes ~= nil and #nAllyHeroes <= 2
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    and nSkillLV >= 3
    and J.IsAllowedToSpam( bot, 90 )
	then
		local allyCreepList = bot:GetNearbyLaneCreeps( 1400, false )
		local needHealCreepCount = 0
		for _, creep in pairs( allyCreepList )
		do
            if J.IsValid(creep)
            then
                if creep:GetMaxHealth() - creep:GetHealth() > nDamage
                then
                    needHealCreepCount = needHealCreepCount + 1
                elseif creep:GetMaxHealth() - creep:GetHealth() > nDamage * 0.6
                then
                    needHealCreepCount = needHealCreepCount + 0.6
                end
            end
		end

		if needHealCreepCount >= nMaxHealCount - 1
		then
			local nWeakestCreep = J.GetLeastHpUnit( allyCreepList )
			if J.IsValid(nWeakestCreep)
			then
				return 	BOT_ACTION_DESIRE_HIGH, nWeakestCreep
			end
		end
	end

	local ShadowWaveTotalDamage = 0
	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.IsInRange( bot, npcEnemy, nCastRange + 300 )
        and J.CanCastOnMagicImmune( npcEnemy )
		then
			local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( npcEnemy, nRadius )
			if J.CanKillTarget( npcEnemy, allyUnitCount * nDamage, nDamageType )
			then
				local target = X.GetBestHealTarget( npcEnemy, nRadius )
				if J.IsValid(target)
				then
					return BOT_ACTION_DESIRE_HIGH, target
				end
			end

			if allyUnitCount >= 1 and nSkillLV >= 3
			then
				ShadowWaveTotalDamage = ShadowWaveTotalDamage + allyUnitCount * nDamage
			end
			if ShadowWaveTotalDamage >= 800
            and nWeakestAlly ~= nil
            and J.IsInRange( bot, nWeakestAlly, nCastRange + 50 )
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestAlly
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange + 200 )
        and J.CanCastOnMagicImmune( botTarget )
		then
			local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( botTarget, nRadius )
			if allyUnitCount >= nMaxHealCount - 2 or allyUnitCount >= 4
			then
				local target = X.GetBestHealTarget( botTarget, nRadius )
				if target ~= nil
				then
					return 	BOT_ACTION_DESIRE_HIGH, target
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetBestHealTarget( npcEnemy, nRadius )

	local bestTarget = nil
	local maxLostHealth = -1

	local allyCreepList = bot:GetNearbyCreeps( 1600, false )
	local allyHeroList = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE )
	local allyUnit = J.CombineTwoTable( allyCreepList, allyHeroList )

	for _, unit in pairs( allyUnit )
	do
		if J.IsValid(unit)
        and J.IsInRange( npcEnemy, unit, nRadius + 9 )
			and unit:GetMaxHealth() - unit:GetHealth() > maxLostHealth
		then
			maxLostHealth = unit:GetMaxHealth() - unit:GetHealth()
			bestTarget = unit
		end
	end

	return bestTarget
end

return X