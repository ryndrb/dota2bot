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

local ShackleShot   = bot:GetAbilityByName('windrunner_shackleshot')
local Powershot     = bot:GetAbilityByName('windrunner_powershot')
local Windrun       = bot:GetAbilityByName('windrunner_windrun')
local GaleForce     = bot:GetAbilityByName('windrunner_gale_force')
local FocusFire     = bot:GetAbilityByName('windrunner_focusfire')

local ShackleShotDesire, ShackleShotTarget
local PowershotDesire, PowershotLocation
local WindrunDesire
local GaleForceDesire, GaleForceLocation
local FocusFireDesire, FocusFireTarget

local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)

    ShackleShotDesire, ShackleShotTarget = X.ConsiderShackleShot()
    if ShackleShotDesire > 0
    then
        bot:Action_UseAbilityOnEntity(ShackleShot, ShackleShotTarget)
        return
    end

    FocusFireDesire, FocusFireTarget = X.ConsiderFocusFire()
    if FocusFireDesire > 0
    then
        bot:Action_UseAbilityOnEntity(FocusFire, FocusFireTarget)
        return
    end

    PowershotDesire, PowershotLocation = X.ConsiderPowershot()
    if PowershotDesire > 0
    then
        bot:Action_UseAbilityOnLocation(Powershot, PowershotLocation)
        return
    end

    WindrunDesire = X.ConsiderWindrun()
    if WindrunDesire > 0
    then
        bot:Action_UseAbility(Windrun)
        return
    end

    GaleForceDesire, GaleForceLocation = X.ConsiderGaleForce()
    if GaleForceDesire > 0
    then
        bot:Action_UseAbilityOnLocation(GaleForce, GaleForceLocation)
        return
    end
end

function X.ConsiderShackleShot()
    if not ShackleShot:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, ShackleShot:GetCastRange())
    local nRadius = ShackleShot:GetSpecialValueInt('shackle_distance')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
    do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        and not J.IsSuspiciousIllusion(enemyHero)
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy
            and #nInRangeAlly >= #nInRangeEnemy
            then
                local target = GetShackleTarget(bot, botTarget, nRadius, GetUnitToUnitDistance(bot, botTarget))
                if target ~= nil
                then
                    return BOT_ACTION_DESIRE_HIGH, target
                end
            end
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(1.5))
                then
                    local target = GetShackleTarget(bot, enemyHero, nRadius, GetUnitToUnitDistance(enemyHero, bot))
                    if target ~= nil
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        for _, enemyHero in pairs(nAllyInRangeEnemy)
        do
            if  J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and J.GetMP(bot) > 0.45
            and allyHero:WasRecentlyDamagedByAnyHero(1.5)
            and not allyHero:IsIllusion()
            then
                if  J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.IsChasingTarget(enemyHero, allyHero)
                and not J.IsDisabled(enemyHero)
                and not J.IsTaunted(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local target = GetShackleTarget(bot, enemyHero, nRadius, GetUnitToUnitDistance(enemyHero, bot))
                    if target ~= nil
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPowershot()
    if not Powershot:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, Powershot:GetCastRange())
	local nCastRange2 = 2600
    local nCastPoint = Powershot:GetCastPoint()
	local nRadius = Powershot:GetSpecialValueInt('arrow_width')
	local nSpeed = Powershot:GetSpecialValueInt('arrow_speed')
    local nDamage = Powershot:GetSpecialValueInt('powershot_damage')
	local nAttackRange = bot:GetAttackRange()

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsInRange(bot, enemyHero, nAttackRange)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetExtrapolatedLocation(eta)
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        local target = nil
        local hp = 0
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange2)
            and not J.IsInRange(bot, enemyHero, nAttackRange)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                local currHP = enemyHero:GetHealth()

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nInRangeAlly >= #nTargetInRangeAlly
                and hp < currHP
                then
                    hp = currHP
                    target = enemyHero
                end

            end
        end

        if target ~= nil
        then
            local eta = (GetUnitToUnitDistance(bot, target) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, target:GetExtrapolatedLocation(eta)
        end
	end

	if J.IsPushing(bot)
	then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 1000, nRadius, 0, 0)
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and nLocationAoE.count >= 4
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end

        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1600, nRadius, 0, 0)
        if nLocationAoE.count >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsFarming(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 1000, nRadius, 0, 0)

        if J.IsAttacking(bot)
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
            if nNeutralCreeps ~= nil
            and ((#nNeutralCreeps >= 3 and nLocationAoE.count >= 3)
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep() and nLocationAoE.count >= 2))
            and J.GetMP(bot) > 0.3
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
            end

            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and nLocationAoE.count >= 3
            and J.GetMP(bot) > 0.3
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
            end
        end
    end

    if  J.IsLaning(bot)
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
	then
        local canKill = 0
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then

				if  (bot:GetTarget() ~= creep or bot:GetAttackTarget() ~= creep)
                and J.GetMP(bot) > 0.3
                and J.CanBeAttacked(creep)
				then
                    if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    and J.IsValidHero(nInRangeEnemy[1])
                    and nInRangeEnemy[1]:GetAttackTarget() ~= bot
                    and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
                    and not J.IsDisabled(nInRangeEnemy[1])
                    and not bot:WasRecentlyDamagedByTower(1)
                    and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) < nInRangeEnemy[1]:GetAttackRange()
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                canKill = canKill + 1
                table.insert(creepList, creep)
            end
		end

        if  canKill >= 2
        and J.GetMP(bot) > 0.25
        and nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.CanBeAttacked(creepList[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(creepList)
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWindrun()
    if not Windrun:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nDuration = Windrun:GetSpecialValueInt('duration')
    local nSpeed = (1 + Windrun:GetSpecialValueInt('movespeed_bonus_pct') / 100) * bot:GetCurrentMovementSpeed()
    local roshanLoc = J.GetCurrentRoshanLocation()
    local tormentorLoc = J.GetTormentorLocation(GetTeam())

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsChasingTarget(bot, botTarget)
        and botTarget:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(1.3))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    if J.IsPushing(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
        local eta = (GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0)) / nSpeed)

        if  J.GetMP(bot) > 0.5
        and nInRangeAlly ~= nil and #nInRangeAlly == 0
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and eta > nDuration
        then
            return  BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
        local eta = (GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0)) / nSpeed)

        if  J.GetMP(bot) > 0.5
        and nInRangeAlly ~= nil and #nInRangeAlly == 0
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and eta > nDuration
        then
            return  BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsLaning(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		if  ((bot:GetMana() - Windrun:GetManaCost()) / bot:GetMaxMana()) > 0.8
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > 800
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            if J.GetHP(bot) < 0.5
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        local eta = (GetUnitToLocationDistance(bot, roshanLoc) / nSpeed)
        if  eta > nDuration
        and J.GetMP(bot) > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            if J.GetHP(bot) < 0.5
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        local eta = (GetUnitToLocationDistance(bot, tormentorLoc) / nSpeed)
        if  eta > nDuration
        and J.GetMP(bot) > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFocusFire()
    if not FocusFire:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, FocusFire:GetCastRange())
	local nDamageReduction = FocusFire:GetSpecialValueInt('focusfire_damage_reduction')
    local nDuration = FocusFire:GetDuration()
	local nDamage = bot:GetAttackDamage()

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanKillTarget(enemyHero, (nDamage * nDuration) * nDamageReduction, DAMAGE_TYPE_PHYSICAL)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_item_sphere_target')
        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
        and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
        then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end

            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidTarget(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.GetHP(enemyHero) > 0.33
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_item_sphere_target')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
            and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and #nInRangeAlly >= #nTargetInRangeAlly
                then
                    if not J.IsCore(enemyHero)
                    then
                        if J.GetHP(enemyHero) > 0.49
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero
                        end
                    else
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGaleForce()
    if not GaleForce:IsTrained()
    or not GaleForce:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, GaleForce:GetCastRange())
    local nRadius = GaleForce:GetSpecialValueInt('radius')
    local nCastPoint = GaleForce:GetCastPoint()

    if J.IsGoingOnSomeone(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + nRadius, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            local targetLoc = (bot:GetLocation() + J.GetCenterOfUnits(nInRangeEnemy)) / 2
            nInRangeEnemy = J.GetEnemiesNearLoc(targetLoc, nRadius)

            if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(targetLoc)
            and not J.IsLocationInBlackHole(targetLoc)
            then
                return BOT_ACTION_DESIRE_HIGH, targetLoc
            end
        end
    end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    local nInRangeEnemy2 = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

                    if nInRangeEnemy2 ~= nil and #nInRangeEnemy2 >= 2
                    then
                        local targetLoc = (bot:GetLocation() + J.GetCenterOfUnits(nInRangeEnemy2)) / 2
                        nInRangeEnemy2 = J.GetEnemiesNearLoc(targetLoc, nRadius)

                        if  nInRangeEnemy2 ~= nil and #nInRangeEnemy2 >= 2
                        and not J.IsLocationInChrono(targetLoc)
                        and not J.IsLocationInBlackHole(targetLoc)
                        then
                            return BOT_ACTION_DESIRE_HIGH, targetLoc
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

-- Helper Funcs
function GetShackleCreepTarget(hSource, hTarget, nRadius)
	local vStart = hSource:GetLocation()
	local vEnd = hTarget:GetLocation()
	local nCreeps = hTarget:GetNearbyCreeps(nRadius, false)

	for _, creep in pairs(nCreeps)
    do
        if J.IsValid(creep)
        then
            local dist1 = GetUnitToUnitDistance(creep, hSource)
            local dist2 = GetUnitToUnitDistance(hTarget, hSource)

            if dist1 < dist2
            then
                local tResult = PointToLineDistance(vStart, vEnd, creep:GetLocation())

                if  tResult ~= nil
                and tResult.within
                and tResult.distance < 75
                then
                    return creep
                end
            end
        end
	end

	return nil
end

function GetShackleHeroTarget(hSource, hTarget, nRadius)
	local vStart = hSource:GetLocation()
	local vEnd = hTarget:GetLocation()
	local nEnemyHeroes = hTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero ~= hTarget
        then
            local dist1 = GetUnitToUnitDistance(enemyHero, hSource)
            local dist2 = GetUnitToUnitDistance(hTarget, hSource)

            if  dist1 < dist2
            then
                local tResult = PointToLineDistance(vStart, vEnd, enemyHero:GetLocation())

                if  tResult ~= nil
                and tResult.within
                and tResult.distance < 75
                then
                    return enemyHero
                end
            end
        end
	end

	return nil
end

function CanShackleToCreep(hSource, hTarget, nRadius)
	local vStart = hSource:GetLocation()
	local nCreeps = hTarget:GetNearbyCreeps(nRadius, false)

	for _, creep in pairs(nCreeps)
    do
        if J.IsValid(creep)
        then
            local vEnd = creep:GetLocation()
            local tResult = PointToLineDistance(vStart, vEnd, hTarget:GetLocation())

            if  tResult ~= nil
            and tResult.within
            and tResult.distance < 75
            then
                return true
            end
        end
	end

	return false
end

function CanShackleToHero(hSource, hTarget, nRadius)
	local vStart = hSource:GetLocation()
	local nEnemyHeroes = hTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
    do
        if J.IsValidHero(enemyHero)
        then
            local vEnd = enemyHero:GetLocation()
            local tResult = PointToLineDistance(vStart, vEnd, hTarget:GetLocation())

            if  enemyHero ~= hTarget
            and tResult ~= nil
            and tResult.within
            and tResult.distance < 75
            then
                return true
            end
        end
	end

	return false
end

function CanShackleToTree(hSource, hTarget, nRadius)
	local vStart = hSource:GetLocation()
	local nTrees = hTarget:GetNearbyTrees(nRadius)

	for _, tree in pairs(nTrees)
    do
        if tree ~= nil
        then
            local vEnd = GetTreeLocation(tree)
            local tResult = PointToLineDistance(vStart, vEnd, hTarget:GetLocation())

            if  tResult ~= nil
            and tResult.within
            and tResult.distance < 75
            then
                return true
            end
        end
	end

	return false
end

function GetShackleTarget(hSource, hTarget, nRadius, nRange)
	local sTarget = nil
	local dist = GetUnitToUnitDistance(hSource, hTarget)

	if (dist < nRange
        and CanShackleToCreep(hSource, hTarget, nRadius))
    or CanShackleToHero(hSource, hTarget, nRadius)
    or CanShackleToTree(hSource, hTarget, nRadius)
	then
		sTarget = hTarget
	elseif dist < nRange or dist < nRange+nRadius
    then
		sTarget = GetShackleCreepTarget(hSource, hTarget, nRadius)

		if sTarget == nil
        then
			sTarget = GetShackleHeroTarget(hSource, hTarget, nRadius)
		end
	end

	return sTarget
end

return X