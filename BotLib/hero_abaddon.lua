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

local MistCoil          = bot:GetAbilityByName( 'abaddon_death_coil' )
local AphoticShield     = bot:GetAbilityByName( 'abaddon_aphotic_shield' )
-- local CurseOfAvernus    = bot:GetAbilityByName( 'abaddon_frostmourne' )
-- local BorrowedTimelocal = bot:GetAbilityByName( 'abaddon_borrowed_time' )

local MistCoilDesire, MistCoilTarget
local AphoticShieldDesire, AphoticShieldTarget

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)

    AphoticShieldDesire, AphoticShieldTarget = X.ConsiderAphoticShield()
    if AphoticShieldDesire > 0
    then
        bot:Action_UseAbilityOnEntity(AphoticShield, AphoticShieldTarget)
        return
    end

    MistCoilDesire, MistCoilTarget = X.ConsiderMistCoil()
    if MistCoilDesire > 0
    then
        bot:Action_UseAbilityOnEntity(MistCoil, MistCoilTarget)
        return
    end
end

function X.ConsiderMistCoil()
    if not MistCoil:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, MistCoil:GetCastRange())
	local nDamage = MistCoil:GetSpecialValueInt('target_damage')
    local nDamageType = DAMAGE_TYPE_MAGICAL

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange + 300, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, nDamageType)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange + 300, false, BOT_MODE_NONE)
	for _, allyHero in pairs(nAllyHeroes)
	do
        if  J.IsValidHero(allyHero)
        and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull'))
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
		and allyHero:CanBeSeen()
		then
			if  J.IsRetreating(allyHero)
            and J.GetHP(allyHero) < 0.6
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero)
			then
                local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidHero(allyTarget)
				and allyHero:IsFacingLocation(allyTarget:GetLocation(), 30)
				and J.IsInRange(allyHero, allyTarget, 300)
                and J.GetHP(allyHero) < 0.8
                and J.GetHP(bot) > 0.2
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 600)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        then
            local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and #nTargetInRangeAlly ~= nil
            and ((#nInRangeAlly == 0 and #nTargetInRangeAlly >= 1)
                or (#nInRangeAlly >= 1
                    and J.GetHP(bot) < 0.3
                    and bot:WasRecentlyDamagedByAnyHero(1)
                    and not bot:HasModifier('modifier_abaddon_borrowed_time')))
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if  J.IsLaning(bot)
    and J.IsCore(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 300, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                and J.IsValidHero(nInRangeEnemy[1])
                and GetUnitToUnitDistance(creep, nInRangeEnemy[1])
                and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
                and botTarget ~= creep
                and J.GetHP(bot) >= 0.5
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderAphoticShield()
    if not AphoticShield:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange  = J.GetProperCastRange(false, bot, AphoticShield:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
	do
        if  J.IsValidHero(allyHero)
        and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull')
            or allyHero:HasModifier('modifier_legion_commander_duel'))
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

        if  J.IsValidHero(allyHero)
        and J.IsDisabled(allyHero)
        and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end

		if  J.IsValidHero(allyHero)
        and not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
        and not allyHero:HasModifier('modifier_item_solar_crest_armor_addition')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
        and not allyHero:IsIllusion()
        and J.IsNotSelf(bot, allyHero)
		then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(800, true, BOT_MODE_NONE)

            if  J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(1.6)
            and not allyHero:IsIllusion()
            then
                if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
                and J.IsValidHero(nAllyInRangeEnemy[1])
                and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 400)
                and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
                and J.IsRunning(allyHero)
                and nAllyInRangeEnemy[1]:IsFacingLocation(allyHero:GetLocation(), 30)
                and not J.IsDisabled(nAllyInRangeEnemy[1])
                and not J.IsTaunted(nAllyInRangeEnemy[1])
                and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidHero(allyTarget)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange())
                and not J.IsSuspiciousIllusion(allyTarget)
                and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyTarget:HasModifier('modifier_enigma_black_hole_pull')
                and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				then
                    local nAllInRangeAlly = allyHero:GetNearbyHeroes(800, false, BOT_MODE_NONE)
                    local nTargetInRangeAlly = allyTarget:GetNearbyHeroes(800, false, BOT_MODE_NONE)

                    if  nAllInRangeAlly ~= nil and  nTargetInRangeAlly ~= nil
                    and #nAllInRangeAlly >= #nTargetInRangeAlly
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
    then
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        then
            local nTargetInRangeAlly = botTarget:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and #nInRangeAlly >= #nTargetInRangeAlly
            then
                if  J.IsValidHero(nInRangeAlly[1])
                and J.IsInRange(bot, nInRangeAlly[1], nCastRange)
                and J.IsCore(nInRangeAlly[1])
                and not nInRangeAlly[1]:HasModifier('modifier_abaddon_aphotic_shield')
                and not nInRangeAlly[1]:IsMagicImmune()
                and not nInRangeAlly[1]:IsInvulnerable()
                and not nInRangeAlly[1]:IsIllusion()
                then
                    return BOT_ACTION_DESIRE_HIGH, nInRangeAlly[1]
                end

                if  not bot:HasModifier('modifier_abaddon_aphotic_shield')
                and not bot:HasModifier("modifier_abaddon_borrowed_time")
                then
                    return BOT_ACTION_DESIRE_MODERATE, bot
                end
            end
	    end

        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and #nInRangeAlly == 0 and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 500)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier("modifier_abaddon_borrowed_time")
        then
            return BOT_ACTION_DESIRE_MODERATE, bot
        end
    end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  nInRangeEnemy ~= nil
        and J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nCastRange)
        and J.IsRunning(nInRangeEnemy[1])
        and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
        and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or bot:WasRecentlyDamagedByAnyHero(2))
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(1200, true)
        if  nCreeps ~= nil and #nCreeps >= 1
        and J.GetHP(bot) < 0.5
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_abaddon_aphotic_shield')
        and not bot:HasModifier('modifier_abaddon_borrowed_time')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            local weakestAlly = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if  weakestAlly ~= nil
            and not weakestAlly:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, weakestAlly
            end
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            local weakestAlly = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if  weakestAlly ~= nil
            and not weakestAlly:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, weakestAlly
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X