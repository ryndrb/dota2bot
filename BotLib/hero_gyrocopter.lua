local X = {}
local bot = GetBot()

local Hero = require(GetScriptDirectory()..'/FunLib/bot_builds/'..string.gsub(bot:GetUnitName(), 'npc_dota_hero_', ''))
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local nTalentBuildList = J.Skill.GetTalentBuild(Hero.TalentBuild[sRole][RandomInt(1, #Hero.TalentBuild[sRole])])
local nAbilityBuildList = Hero.AbilityBuild[sRole][RandomInt(1, #Hero.AbilityBuild[sRole])]

local sRand = RandomInt(1, #Hero.BuyList[sRole])
X['sBuyList'] = Hero.BuyList[sRole][sRand]
X['sSellList'] = Hero.SellList[sRole][sRand]

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

local RocketBarrage = bot:GetAbilityByName('gyrocopter_rocket_barrage')
local HomingMissile = bot:GetAbilityByName('gyrocopter_homing_missile')
local FlakCannon    = bot:GetAbilityByName('gyrocopter_flak_cannon')
local CallDown      = bot:GetAbilityByName('gyrocopter_call_down')

local RocketBarrageDesire
local HomingMissileDesire, HomingMissileTarget
local FlakCannonDesire
local CallDownDesire, CallDownLocation

local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility( bot ) then return end

    botTarget = J.GetProperTarget(bot)

    HomingMissileDesire, HomingMissileTarget = X.ConsiderHomingMissile()
    if HomingMissileDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HomingMissile, HomingMissileTarget)
        return
    end

    FlakCannonDesire = X.ConsiderFlakCannon()
    if FlakCannonDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FlakCannon)
        return
    end

    CallDownDesire, CallDownLocation = X.ConsiderCallDown()
    if CallDownDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CallDown, CallDownLocation)
        return
    end

    RocketBarrageDesire = X.ConsiderRocketBarrage()
    if RocketBarrageDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(RocketBarrage)
        return
    end
end

function X.ConsiderRocketBarrage()
    if not RocketBarrage:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = RocketBarrage:GetSpecialValueInt('radius')
    local nDamage = RocketBarrage:GetSpecialValueInt('value')
    local nRocketsPerSecond = RocketBarrage:GetSpecialValueInt('rockets_per_second')
    local nDuration = 3
    local nAbilityLevel = RocketBarrage:GetLevel()

    local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        local nCreeps = bot:GetNearbyCreeps(nRadius, true)

        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage * nRocketsPerSecond * nDuration, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and nCreeps ~= nil and #nCreeps <= 1
        then
            bot:SetTarget(enemyHero)
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        local nCreeps = bot:GetNearbyCreeps(nRadius, true)

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and nCreeps ~= nil and #nCreeps <= 1
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            then
                bot:SetTarget(botTarget)
                return BOT_ACTION_DESIRE_HIGH
            end

		end
	end

	if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if  J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
        and (bot:WasRecentlyDamagedByAnyHero(2) or bot:GetActiveModeDesire() > 0.7)
        and not J.WeAreStronger(bot, 1600)
        and not J.IsRealInvisible(bot)
        and not nInRangeEnemy[1]:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  (J.IsFarming(bot) or J.IsPushing(bot))
    and J.GetMP(bot) > 0.5
    and nAbilityLevel >= 2
    and not bot:HasModifier('modifier_gyrocopter_flak_cannon')
    then
        local nCreeps = bot:GetNearbyCreeps(bot:GetAttackRange(), true)
        if  nCreeps ~= nil and #nCreeps >= 2
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nCreeps)) <= nRadius
        and J.CanBeAttacked(nCreeps[1])
        and not J.IsRunning(nCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHomingMissile()
    if not HomingMissile:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, HomingMissile:GetCastRange())
    local nLaunchDelay = HomingMissile:GetSpecialValueFloat('pre_flight_time')
	local nDamage = HomingMissile:GetAbilityDamage()

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nLaunchDelay)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
        local strongestEnemy = J.GetStrongestUnit(nCastRange, bot, true, false, 5)

        if  J.IsValidHero(strongestEnemy)
        and J.CanCastOnNonMagicImmune(strongestEnemy)
        and J.CanCastOnTargetAdvanced(strongestEnemy)
        and not J.IsDisabled(strongestEnemy)
        then
            return BOT_ACTION_DESIRE_HIGH, strongestEnemy
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

	if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if  J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.CanCastOnTargetAdvanced(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nCastRange)
        and not J.IsDisabled(nInRangeEnemy[1])
        and (bot:WasRecentlyDamagedByAnyHero(2) or bot:GetActiveModeDesire() > 0.7)
        and not J.WeAreStronger(bot, 1600)
        and not J.IsRealInvisible(bot)
        and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
		end
	end

    if  J.IsLaning(bot)
    and J.IsInLaningPhase()
    and J.IsCore(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
            and J.CanBeAttacked(creep)
            and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nLaunchDelay)
            and bot:GetAttackTarget() ~= creep
			then
				local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
				and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) <= 600
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    local nAllyHeroes  = bot:GetNearbyHeroes(888, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if  J.IsValidHero(allyHero)
        and (J.IsRetreating(allyHero) and allyHero:GetActiveModeDesire() > 0.7)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            if  J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and not J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFlakCannon()
    if not FlakCannon:IsFullyCastable()
    or bot:IsDisarmed()
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = FlakCannon:GetSpecialValueInt('radius')
    local nAbilityLevel = FlakCannon:GetLevel()
    local nInRangeIllusion = J.GetIllusionsNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and (not J.IsSuspiciousIllusion(botTarget)
            or J.IsSuspiciousIllusion(botTarget) and #nInRangeIllusion >= 2)
        and not botTarget:IsAttackImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if  ((J.IsPushing(bot) and nEnemyHeroes ~= nil and #nEnemyHeroes == 0) or J.IsDefending(bot))
    and nAbilityLevel >= 2
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) <= nRadius
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if  J.IsFarming(bot)
    and nAbilityLevel >= 2
    and J.GetMP(bot) > 0.33
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    and not bot:HasModifier('modifier_gyrocopter_rocket_barrage')
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(bot:GetAttackRange() + 150)

        if  nNeutralCreeps ~= nil
        and (#nNeutralCreeps >= 3
            or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) <= nRadius
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCallDown()
    if not CallDown:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, CallDown:GetCastRange())
	local nCastPoint = CallDown:GetCastPoint()
	local nRadius = CallDown:GetSpecialValueInt('radius')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
        if J.IsInTeamFight(bot, 1600)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint + 0.2, 0)
            nEnemyHeroes = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if #nEnemyHeroes >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint + 0.2)
            end
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X