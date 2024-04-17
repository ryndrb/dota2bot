local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local R             = dofile( GetScriptDirectory()..'/FunLib/rubick_utility' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sRole   = J.Item.GetRoleItemsBuyList( bot )

local tTalentTreeList = {--pos4,5
                        ['t25'] = {10, 0},
                        ['t20'] = {0, 10},
                        ['t15'] = {0, 10},
                        ['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{2,1,2,3,2,6,2,3,3,3,1,6,1,1,6},--pos4,5
}

local nAbilityBuildList = J.Skill.GetRandomBuild(tAllAbilityBuildList)

local nTalentBuildList = J.Skill.GetTalentBuild(tTalentTreeList)

local sRoleItemsBuyList = {}

sRoleItemsBuyList['pos_1'] = sRoleItemsBuyList['pos_1']

sRoleItemsBuyList['pos_2'] = sRoleItemsBuyList['pos_2']

sRoleItemsBuyList['pos_3'] = sRoleItemsBuyList['pos_3']

sRoleItemsBuyList['pos_4'] = {
    "item_double_tango",
    "item_double_branches",
    "item_blood_grenade",
    "item_magic_stick",

    "item_boots",
    "item_magic_wand",
    "item_tranquil_boots",
    "item_aether_lens",
    "item_blink",
    "item_ancient_janggo",
    "item_aghanims_shard",
    "item_force_staff",--
    "item_boots_of_bearing",--
    "item_ultimate_scepter",
    "item_octarine_core",--
    "item_cyclone",
    "item_ethereal_blade",--
    "item_wind_waker",--
    "item_arcane_blink",--
    "item_ultimate_scepter_2",
    "item_moon_shard",
}

sRoleItemsBuyList['pos_5'] = {
    "item_double_tango",
    "item_double_branches",
    "item_blood_grenade",
    "item_magic_stick",

    "item_boots",
    "item_magic_wand",
    "item_arcane_boots",
    "item_aether_lens",
    "item_blink",
    "item_mekansm",
    "item_aghanims_shard",
    "item_force_staff",--
    "item_guardian_greaves",--
    "item_ultimate_scepter",
    "item_octarine_core",--
    "item_cyclone",
    "item_ethereal_blade",--
    "item_wind_waker",--
    "item_arcane_blink",--
    "item_ultimate_scepter_2",
    "item_moon_shard",
}

X['sBuyList'] = sRoleItemsBuyList[sRole]

Pos4SellList = {
    "item_magic_wand",
}

Pos5SellList = {
    "item_magic_wand",
}

X['sSellList'] = {}

if sRole == "pos_4"
then
    X['sSellList'] = Pos4SellList
elseif sRole == "pos_5"
then
    X['sSellList'] = Pos5SellList
end

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

local Telekinesis       = bot:GetAbilityByName('rubick_telekinesis')
local TelekinesisLand   = bot:GetAbilityByName('rubick_telekinesis_land')
local FadeBolt          = bot:GetAbilityByName('rubick_fade_bolt')
-- local ArcaneSupremacy   = bot:GetAbilityByName('rubick_null_field')
local StolenSpell1      = bot:GetAbilityByName('rubick_empty1')
local StolenSpell2      = bot:GetAbilityByName('rubick_empty2')
local SpellSteal        = bot:GetAbilityByName('rubick_spell_steal')

local TelekinesisDesire, TelekinesisTarget
local TelekinesisLandDesire, TelekinesisLandLocation
local FadeBoltDesire, FadeBoltTarget
local SpellStealDesire, SpellStealTarget

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    StolenSpell1 = bot:GetAbilityInSlot(3)
    StolenSpell2 = bot:GetAbilityInSlot(4)

    SpellStealDesire, SpellStealTarget = X.ConsiderSpellSteal()
    if SpellStealDesire > 0
    then
        bot:Action_UseAbilityOnEntity(SpellSteal, SpellStealTarget)
        return
    end

    X.ConsiderStolenSpell1()
    X.ConsiderStolenSpell2()

    TelekinesisDesire, TelekinesisTarget = X.ConsiderTelekinesis()
    if TelekinesisDesire > 0
    then
        bot.teleTarget = TelekinesisTarget
        bot:Action_UseAbilityOnEntity(Telekinesis, TelekinesisTarget)
        return
    end

    TelekinesisLandDesire, TelekinesisLandLocation = X.ConsiderTelekinesisLand()
    if TelekinesisLandDesire > 0
    then
        bot:Action_UseAbilityOnLocation(TelekinesisLand, TelekinesisLandLocation)
        bot.isChannelLand = false
        bot.isSaveUltLand= false
        bot.isEngagingLand = false
        bot.isRetreatLand = false
        bot.isSaveAllyLand = false
        return
    end

    FadeBoltDesire, FadeBoltTarget = X.ConsiderFadeBolt()
    if FadeBoltDesire > 0
    then
        bot:Action_UseAbilityOnEntity(FadeBolt, FadeBoltTarget)
        return
    end
end

function X.ConsiderTelekinesis()
    if Telekinesis:IsHidden()
    or not Telekinesis:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Telekinesis:GetCastRange())

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange + 300, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
		then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                bot.isChannelLand = true
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        for _, allyHero in pairs(nInRangeAlly)
        do
            if  J.IsValidHero(allyHero)
            and J.IsCore(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:IsInvulnerable()
            and not allyHero:IsAttackImmune()
            and not allyHero:HasModifier('modifier_furion_sprout_damage')
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if allyHero:HasModifier('modifier_enigma_black_hole_pull')
                or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                then
                    bot.isSaveUltLand = true
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_furion_sprout_damage')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            nInRangeAlly =  J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            and not (#nInRangeEnemy == 0 and #nInRangeAlly >= #nInRangeEnemy + 2)
            then
                bot.isEngagingLand = true
                return BOT_ACTION_DESIRE_HIGH, botTarget
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
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_furion_sprout_damage')
			then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and (#nTargetInRangeAlly > #nInRangeAlly
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    bot.isRetreatLand = true
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
			end
		end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(2)
        and not allyHero:IsIllusion()
        then
            if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
            and J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and nAllyInRangeEnemy[1]:IsFacingLocation(allyHero:GetLocation(), 30)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsTaunted(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_furion_sprout_damage')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                bot.isSaveAllyLand = true
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

	if J.IsDoingRoshan(bot)
	then
        -- Remove Spell Block
		if  J.IsRoshan(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and botTarget:HasModifier('modifier_roshan_spell_block')
		then
			return BOT_ACTION_DESIRE_LOW, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTelekinesisLand()
    if TelekinesisLand:IsHidden()
    or not TelekinesisLand:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nDistance = TelekinesisLand:GetSpecialValueInt('radius')
    local nTalent8 = bot:GetAbilityByName('special_bonus_unique_rubick_8')
    if nTalent8:IsTrained()
    then
        nDistance = nDistance + nTalent8:GetSpecialValueInt('value')
    end

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

    if  J.IsValidHero(botTarget)
    and not J.IsSuspiciousIllusion(botTarget)
    then
        nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
        nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
    end

    if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
    and bot.teleTarget ~= nil
    then
        if  bot.isChannelLand ~= nil
        and bot.isChannelLand == true
        then
            if #nInRangeAlly >= #nInRangeEnemy
            then
                if J.IsInRange(bot, bot.teleTarget, nDistance)
                then
                    return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                end

                if not J.IsInRange(bot, bot.teleTarget, nDistance)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, bot:GetLocation(), nDistance)
                end
            end

            if #nInRangeEnemy > #nInRangeAlly
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetEnemyFountain(), nDistance)
            end
        end

        if  bot.isSaveUltLand ~= nil
        and bot.isSaveUltLand == true
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nDistance)
        end

        if  bot.isEngagingLand ~= nil
        and bot.isEngagingLand == true
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end

        if  bot.isRetreatLand ~= nil
        and bot.isRetreatLand == true
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetEnemyFountain(), nDistance)
        end

        if  bot.isSaveAllyLand ~= nil
        and bot.isSaveAllyLand == true
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nDistance)
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFadeBolt()
    if not FadeBolt:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, FadeBolt:GetCastRange())
    local nDamage = FadeBolt:GetSpecialValueInt('damage')
    local nRadius = FadeBolt:GetSpecialValueInt('radius')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_rubick_telekinesis')
        then
            if J.IsInEtherealForm(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(1.5)
        and not allyHero:IsIllusion()
        then
            if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
            and J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and J.IsAttacking(nAllyInRangeEnemy[1])
            and nAllyInRangeEnemy[1]:IsFacingLocation(allyHero:GetLocation(), 30)
            and not J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsTaunted(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_rubick_telekinesis')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsInTeamFight(bot, 1200)
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)
        local target = nil
        local hp = 100000

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_rubick_telekinesis')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                local nTargetInRangeAlly = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                local currHP = enemyHero:GetHealth()

                if  nTargetInRangeAlly ~= nil and #nTargetInRangeAlly >= 1
                and currHP < hp
                then
                    hp = currHP
                    target = enemyHero
                end
            end
        end

        if target ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_rubick_telekinesis')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
            local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
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
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and J.IsAttacking(enemyHero)
            and not J.IsInRange(bot, enemyHero, 300)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]
        end
    end

    if  J.IsLaning(bot)
    and not J.IsThereCoreNearby(800)
	then
        local creepList = {}
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
            and J.GetMP(bot) > 0.3
			then
				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
				and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) < 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                table.insert(creepList, creep)
            end
		end

        if  J.GetMP(bot) > 0.3
        and nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and #creepList >= 2
        and J.CanBeAttacked(creepList[1])
        then
            return BOT_ACTION_DESIRE_HIGH, creepList[1]
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderStolenSpell1()
    if StolenSpell1:GetName() == 'rubick_empty1'
    or not StolenSpell1:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_HIGH, 0, ''
    end

    R.ConsiderStolenSpell(StolenSpell1)

    return BOT_ACTION_DESIRE_HIGH, 0, ''
end

function X.ConsiderStolenSpell2()
    if StolenSpell2:GetName() == 'rubick_empty2'
    or not StolenSpell2:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_HIGH, 0, ''
    end

    R.ConsiderStolenSpell(StolenSpell2)

    return BOT_ACTION_DESIRE_HIGH, 0, ''
end

function X.ConsiderSpellSteal()
    if not SpellSteal:IsFullyCastable()
    or HaveGoodSpells(StolenSpell1, StolenSpell2)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SpellSteal:GetCastRange())

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange + 300)
    for _, enemyHero in pairs(nInRangeEnemy)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and X.ShouldStealSpellFrom(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not J.IsMeepoClone(enemyHero)
        then
            if enemyHero:IsUsingAbility()
            or enemyHero:IsCastingAbility()
            or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

-- Direct Stun Spells
-- Huge Ults
-- etc
function HaveGoodSpells(ability1, ability2)
    if ability1:GetName() == 'bane_nightmare'
    or ability2:GetName() == 'bane_nightmare'
    then
        return true
    end

    if ability1:GetName() == 'bane_fiends_grip'
    or ability2:GetName() == 'bane_fiends_grip'
    then
        return true
    end

    if ability1:GetName() == 'batrider_flaming_lasso'
    or ability2:GetName() == 'batrider_flaming_lasso'
    then
        return true
    end

    if ability1:GetName() == 'beastmaster_primal_roar'
    or ability2:GetName() == 'beastmaster_primal_roar'
    then
        return true
    end

    if ability1:GetName() == 'centaur_hoof_stomp'
    or ability2:GetName() == 'centaur_hoof_stomp'
    then
        return true
    end

    -- if ability1:GetName() == 'chaos_knight_chaos_bolt'
    -- or ability2:GetName() == 'chaos_knight_chaos_bolt'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'rattletrap_hookshot'
    -- or ability2:GetName() == 'rattletrap_hookshot'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'crystal_maiden_frostbite'
    -- or ability2:GetName() == 'crystal_maiden_frostbite'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'dragon_knight_dragon_tail'
    -- or ability2:GetName() == 'dragon_knight_dragon_tail'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'earthshaker_fissure'
    -- or ability2:GetName() == 'earthshaker_fissure'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'earthshaker_echo_slam'
    -- or ability2:GetName() == 'earthshaker_echo_slam'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'enigma_black_hole'
    -- or ability2:GetName() == 'enigma_black_hole'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'faceless_void_chronosphere'
    -- or ability2:GetName() == 'faceless_void_chronosphere'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'jakiro_ice_path'
    -- or ability2:GetName() == 'jakiro_ice_path'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'legion_commander_duel'
    -- or ability2:GetName() == 'legion_commander_duel'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'lion_impale'
    -- or ability2:GetName() == 'lion_impale'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'magnataur_reverse_polarity'
    -- or ability2:GetName() == 'magnataur_reverse_polarity'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'mars_arena_of_blood'
    -- or ability2:GetName() == 'mars_arena_of_blood'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'monkey_king_wukongs_command'
    -- or ability2:GetName() == 'monkey_king_wukongs_command'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'naga_siren_song_of_the_siren'
    -- or ability2:GetName() == 'naga_siren_song_of_the_siren'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'nyx_assassin_impale'
    -- or ability2:GetName() == 'nyx_assassin_impale'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'ogre_magi_fireblast'
    -- or ability2:GetName() == 'ogre_magi_fireblast'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'oracle_false_promise'
    -- or ability2:GetName() == 'oracle_false_promise'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'obsidian_destroyer_astral_imprisonment'
    -- or ability2:GetName() == 'obsidian_destroyer_astral_imprisonment'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'pangolier_gyroshell'
    -- or ability2:GetName() == 'pangolier_gyroshell'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'phoenix_supernova'
    -- or ability2:GetName() == 'phoenix_supernova'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'puck_dream_coil'
    -- or ability2:GetName() == 'puck_dream_coil'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'pudge_meat_hook'
    -- or ability2:GetName() == 'pudge_meat_hook'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'shadow_demon_disruption'
    -- or ability2:GetName() == 'shadow_demon_disruption'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'shadow_shaman_voodoo'
    -- or ability2:GetName() == 'shadow_shaman_voodoo'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'shadow_shaman_shackles'
    -- or ability2:GetName() == 'shadow_shaman_shackles'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'silencer_global_silence'
    -- or ability2:GetName() == 'silencer_global_silence'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'sven_storm_bolt'
    -- or ability2:GetName() == 'sven_storm_bolt'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'tidehunter_ravage'
    -- or ability2:GetName() == 'tidehunter_ravage'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'treant_overgrowth'
    -- or ability2:GetName() == 'treant_overgrowth'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'vengefulspirit_magic_missile'
    -- or ability2:GetName() == 'vengefulspirit_magic_missile'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'warlock_rain_of_chaos'
    -- or ability2:GetName() == 'warlock_rain_of_chaos'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'winter_wyvern_winters_curse'
    -- or ability2:GetName() == 'winter_wyvern_winters_curse'
    -- then
    --     return true
    -- end

    -- if ability1:GetName() == 'winter_wyvern_winters_curse'
    -- or ability2:GetName() == 'winter_wyvern_winters_curse'
    -- then
    --     return true
    -- end

    return false
end

function X.ShouldStealSpellFrom(hero)
    local HeroNames = {
        ['npc_dota_hero_abaddon'] = false,
        ['npc_dota_hero_abyssal_underlord'] = false,
        ['npc_dota_hero_alchemist'] = false,
        ['npc_dota_hero_ancient_apparition'] = false,
        ['npc_dota_hero_antimage'] = false,
        ['npc_dota_hero_arc_warden'] = false,
        ['npc_dota_hero_axe'] = false,
        ['npc_dota_hero_bane'] = true,
        ['npc_dota_hero_batrider'] = true,
        ['npc_dota_hero_beastmaster'] = true,
        ['npc_dota_hero_bloodseeker'] = false,
        ['npc_dota_hero_bounty_hunter'] = false,
        ['npc_dota_hero_brewmaster'] = false,
        ['npc_dota_hero_bristleback'] = false,
        ['npc_dota_hero_broodmother'] = false,
        ['npc_dota_hero_centaur'] = true,
        -- ['npc_dota_hero_chaos_knight'] = ,
        -- ['npc_dota_hero_chen'] = ,
        -- ['npc_dota_hero_clinkz'] = ,
        -- ['npc_dota_hero_crystal_maiden'] = ,
        -- ['npc_dota_hero_dark_seer'] = ,
        -- ['npc_dota_hero_dark_willow'] = ,
        -- ['npc_dota_hero_dawnbreaker'] = ,
        -- ['npc_dota_hero_dazzle'] = ,
        -- ['npc_dota_hero_disruptor'] = ,
        -- ['npc_dota_hero_death_prophet'] = ,
        -- ['npc_dota_hero_doom_bringer'] = ,
        -- ['npc_dota_hero_dragon_knight'] = ,
        -- ['npc_dota_hero_drow_ranger'] = ,
        -- ['npc_dota_hero_earth_spirit'] = ,
        -- ['npc_dota_hero_earthshaker'] = ,
        -- ['npc_dota_hero_elder_titan'] = ,
        -- ['npc_dota_hero_ember_spirit'] = ,
        -- ['npc_dota_hero_enchantress'] = ,
        -- ['npc_dota_hero_enigma'] = ,
        -- ['npc_dota_hero_faceless_void'] = ,
        -- ['npc_dota_hero_furion'] = ,
        -- ['npc_dota_hero_grimstroke'] = ,
        -- ['npc_dota_hero_gyrocopter'] = ,
        -- ['npc_dota_hero_hoodwink'] = ,
        -- ['npc_dota_hero_huskar'] = ,
        -- ['npc_dota_hero_invoker'] = ,
        -- ['npc_dota_hero_jakiro'] = ,
        -- ['npc_dota_hero_juggernaut'] = ,
        -- ['npc_dota_hero_keeper_of_the_light'] = ,
        -- ['npc_dota_hero_kunkka'] = ,
        -- ['npc_dota_hero_legion_commander'] = ,
        -- ['npc_dota_hero_leshrac'] = ,
        -- ['npc_dota_hero_lich'] = ,
        -- ['npc_dota_hero_life_stealer'] = ,
        -- ['npc_dota_hero_lina'] = ,
        -- ['npc_dota_hero_lion'] = ,
        -- ['npc_dota_hero_lone_druid'] = ,
        -- ['npc_dota_hero_luna'] = ,
        -- ['npc_dota_hero_lycan'] = ,
        -- ['npc_dota_hero_magnataur'] = ,
        -- ['npc_dota_hero_marci'] = ,
        -- ['npc_dota_hero_mars'] = ,
        -- ['npc_dota_hero_medusa'] = ,
        -- ['npc_dota_hero_meepo'] = ,
        -- ['npc_dota_hero_mirana'] = ,
        -- ['npc_dota_hero_morphling'] = ,
        -- ['npc_dota_hero_monkey_king'] = ,
        -- ['npc_dota_hero_naga_siren'] = ,
        -- ['npc_dota_hero_necrolyte'] = ,
        -- ['npc_dota_hero_nevermore'] = ,
        -- ['npc_dota_hero_night_stalker'] = ,
        -- ['npc_dota_hero_nyx_assassin'] = ,
        -- ['npc_dota_hero_obsidian_destroyer'] = ,
        -- ['npc_dota_hero_ogre_magi'] = ,
        -- ['npc_dota_hero_omniknight'] = ,
        -- ['npc_dota_hero_oracle'] = ,
        -- ['npc_dota_hero_pangolier'] = ,
        -- ['npc_dota_hero_phantom_lancer'] = ,
        -- ['npc_dota_hero_phantom_assassin'] = ,
        -- ['npc_dota_hero_phoenix'] = ,
        -- ['npc_dota_hero_primal_beast'] = ,
        -- ['npc_dota_hero_puck'] = ,
        -- ['npc_dota_hero_pudge'] = ,
        -- ['npc_dota_hero_pugna'] = ,
        -- ['npc_dota_hero_queenofpain'] = ,
        -- ['npc_dota_hero_rattletrap'] = ,
        -- ['npc_dota_hero_razor'] = ,
        -- ['npc_dota_hero_riki'] = ,
        -- ['npc_dota_hero_rubick'] = ,
        -- ['npc_dota_hero_sand_king'] = ,
        -- ['npc_dota_hero_shadow_demon'] = ,
        -- ['npc_dota_hero_shadow_shaman'] = ,
        -- ['npc_dota_hero_shredder'] = ,
        -- ['npc_dota_hero_silencer'] = ,
        -- ['npc_dota_hero_skeleton_king'] = ,
        -- ['npc_dota_hero_skywrath_mage'] = ,
        -- ['npc_dota_hero_slardar'] = ,
        -- ['npc_dota_hero_slark'] = ,
        -- ["npc_dota_hero_snapfire"] = ,
        -- ['npc_dota_hero_sniper'] = ,
        -- ['npc_dota_hero_spectre'] = ,
        -- ['npc_dota_hero_spirit_breaker'] = ,
        -- ['npc_dota_hero_storm_spirit'] = ,
        -- ['npc_dota_hero_sven'] = ,
        -- ['npc_dota_hero_techies'] = ,
        -- ['npc_dota_hero_terrorblade'] = ,
        -- ['npc_dota_hero_templar_assassin'] = ,
        -- ['npc_dota_hero_tidehunter'] = ,
        -- ['npc_dota_hero_tinker'] = ,
        -- ['npc_dota_hero_tiny'] = ,
        -- ['npc_dota_hero_treant'] = ,
        -- ['npc_dota_hero_troll_warlord'] = ,
        -- ['npc_dota_hero_tusk'] = ,
        -- ['npc_dota_hero_undying'] = ,
        -- ['npc_dota_hero_ursa'] = ,
        -- ['npc_dota_hero_vengefulspirit'] = ,
        -- ['npc_dota_hero_venomancer'] = ,
        -- ['npc_dota_hero_viper'] = ,
        -- ['npc_dota_hero_visage'] = ,
        -- ['npc_dota_hero_void_spirit'] = ,
        -- ['npc_dota_hero_warlock'] = ,
        -- ['npc_dota_hero_weaver'] = ,
        -- ['npc_dota_hero_windrunner'] = ,
        -- ['npc_dota_hero_winter_wyvern'] = ,
        -- ['npc_dota_hero_wisp'] = ,
        -- ['npc_dota_hero_witch_doctor'] = ,
        -- ['npc_dota_hero_zuus'] = ,
    }

    return HeroNames[hero:GetUnitName()]
end

return X