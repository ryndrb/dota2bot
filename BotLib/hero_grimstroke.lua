local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_grimstroke'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_enchanted_mango",
                "item_double_branches",
                "item_blood_grenade",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_aether_lens",
                "item_aghanims_shard",
                "item_glimmer_cape",--
                "item_ultimate_scepter",
                "item_boots_of_bearing",--
                "item_sheepstick",--
                "item_solar_crest",--
                "item_ultimate_scepter_2",
                "item_aeon_disk",--
                "item_ethereal_blade",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_enchanted_mango",
                "item_double_branches",
                "item_blood_grenade",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_aether_lens",
                "item_aghanims_shard",
                "item_glimmer_cape",--
                "item_ultimate_scepter",
                "item_guardian_greaves",--
                "item_sheepstick",--
                "item_solar_crest",--
                "item_ultimate_scepter_2",
                "item_aeon_disk",--
                "item_ethereal_blade",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
            },
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local StrokeOfFate      = bot:GetAbilityByName('grimstroke_dark_artistry')
local PhantomsEmbrace   = bot:GetAbilityByName('grimstroke_ink_creature')
local InkSwell          = bot:GetAbilityByName('grimstroke_spirit_walk')
local InkExplosion      = bot:GetAbilityByName('grimstroke_return')
local DarkPortrait      = bot:GetAbilityByName('grimstroke_dark_portrait')
local SoulBind          = bot:GetAbilityByName('grimstroke_soul_chain')

local StrokeOfFateDesire, StrokeOfFateLocation
local PhantomsEmbraceDesire, PhantomsEmbraceTarget
local InkSwellDesire, InkSwellTarget
local InkExplosionDesire
local DarkPortraitDesire, DarkPortraitTarget
local SoulBindDesire, SoulBindTarget

local InkSwellCastTime = -1

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    StrokeOfFate      = bot:GetAbilityByName('grimstroke_dark_artistry')
    PhantomsEmbrace   = bot:GetAbilityByName('grimstroke_ink_creature')
    InkSwell          = bot:GetAbilityByName('grimstroke_spirit_walk')
    InkExplosion      = bot:GetAbilityByName('grimstroke_return')
    DarkPortrait      = bot:GetAbilityByName('grimstroke_dark_portrait')
    SoulBind          = bot:GetAbilityByName('grimstroke_soul_chain')

    botTarget = J.GetProperTarget(bot)

    InkSwellDesire, InkSwellTarget = X.ConsiderInkSwell()
    if InkSwellDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(InkSwell, InkSwellTarget)
        InkSwellCastTime = DotaTime()
        return
    end

    InkExplosionDesire = X.ConsiderInkExplosion()
    if InkExplosionDesire > 0
    then
        bot:Action_UseAbility(InkExplosion)
        return
    end

    SoulBindDesire, SoulBindTarget = X.ConsiderSoulBind()
    if SoulBindDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SoulBind, SoulBindTarget)
        return
    end

    PhantomsEmbraceDesire, PhantomsEmbraceTarget = X.ConsiderPhantomsEmbrace()
    if PhantomsEmbraceDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(PhantomsEmbrace, PhantomsEmbraceTarget)
        return
    end

    StrokeOfFateDesire, StrokeOfFateLocation = X.ConsiderStrokeOfFate()
    if StrokeOfFateDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StrokeOfFate, StrokeOfFateLocation)
        return
    end

    DarkPortraitDesire, DarkPortraitTarget = X.ConsiderDarkPortrait()
    if DarkPortraitDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DarkPortrait, DarkPortraitTarget)
        return
    end
end

function X.ConsiderStrokeOfFate()
    if not J.CanCastAbility(StrokeOfFate)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, StrokeOfFate:GetCastRange())
	local nCastPoint = StrokeOfFate:GetCastPoint()
	local nRadius = StrokeOfFate:GetSpecialValueInt('end_radius')
	local nSpeed = StrokeOfFate:GetSpecialValueInt('projectile_speed')
    local nDamage = StrokeOfFate:GetSpecialValueInt('damage')
    local nAbilityLevel = StrokeOfFate:GetLevel()

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
		end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)

            if #nInRangeEnemy >= 2 and not J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.5)
    then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsInRange(bot, nEnemyHeroes[1], 300)
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end
    end

	if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(StrokeOfFate:GetManaCost()) > 0.4
    and nAbilityLevel >= 3
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
		if nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end

        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and not J.IsThereCoreNearby(1200)
        and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if  J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nDelay = (GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1]) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nDelay)
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and not botTarget:IsAttackImmune()
        and J.GetHP(botTarget) > 0.2
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
        and J.GetHP(botTarget) < 0.5
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPhantomsEmbrace()
    if not J.CanCastAbility(PhantomsEmbrace)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, PhantomsEmbrace:GetCastRange())
    local nDuration = PhantomsEmbrace:GetSpecialValueInt('latch_duration')
    local nDamagePerSec = PhantomsEmbrace:GetSpecialValueInt('damage_per_second')
    local nRendDamage = PhantomsEmbrace:GetSpecialValueInt('pop_damage')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamagePerSec * nDuration + nRendDamage, DAMAGE_TYPE_PHYSICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsSilenced()
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByAnyHero(4)
            then
                if enemyHero:IsUsingAbility() or enemyHero:IsCastingAbility()
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.5)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderInkSwell()
    if not J.CanCastAbility(InkSwell)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, InkSwell:GetCastRange())
	local nRadius = InkSwell:GetSpecialValueInt('radius')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        and not J.IsDisabled(enemyHero)
		then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            local nInRangeAllyEnemy = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

            for _, allyEnemyHero in pairs(nInRangeAllyEnemy)
            do
                if  J.IsValidHero(allyEnemyHero)
                and J.CanCastOnNonMagicImmune(allyEnemyHero)
                and allyEnemyHero:IsChanneling()
                and not J.IsDisabled(allyEnemyHero)
                and not allyEnemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not allyEnemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyEnemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    local dist = 1600
    local targetAlly = nil

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(allyHero)
        and GetUnitToUnitDistance(allyHero, botTarget) < dist
        then
            targetAlly = allyHero
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and targetAlly ~= nil
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(targetAlly:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, targetAlly
            end
        end
    end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.75
    and bot:WasRecentlyDamagedByAnyHero(3.5) and J.GetHP(bot) < 0.75
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderInkExplosion()
    if not J.CanCastAbility(InkExplosion)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = InkSwell:GetSpecialValueInt('radius')
    local nDuration = InkSwell:GetSpecialValueInt('buff_duration')

    if DotaTime() < InkSwellCastTime + nDuration
    then
        local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and enemyHero:IsChanneling()
            and not J.IsDisabled(enemyHero)
            and bot:HasModifier('modifier_grimstroke_spirit_walk_buff')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        for i = 1, 5
        do
            local allyHero = GetTeamMember(i)

            if J.IsValidHero(allyHero)
            then
                local nInRangeAllyEnemy = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

                for _, allyEnemyHero in pairs(nInRangeAllyEnemy)
                do
                    if  J.IsValidHero(allyEnemyHero)
                    and J.CanCastOnNonMagicImmune(allyEnemyHero)
                    and allyEnemyHero:IsChanneling()
                    and not J.IsDisabled(allyEnemyHero)
                    and allyHero:HasModifier('modifier_grimstroke_spirit_walk_buff')
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSoulBind()
    if not J.CanCastAbility(SoulBind)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nRadius = SoulBind:GetSpecialValueInt('chain_latch_radius')
    local nDuration = SoulBind:GetSpecialValueInt('chain_duration')

    if J.IsGoingOnSomeone(bot)
    then
        local strongestTarget = J.GetStrongestUnit(1200, bot, true, true, nDuration)
        if strongestTarget == nil
        then
            strongestTarget = J.GetStrongestUnit(1200, bot, true, false, nDuration)
        end

        if  J.IsValidHero(strongestTarget)
        and not J.IsSuspiciousIllusion(strongestTarget)
        and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = strongestTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = strongestTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
            local nTargetInRangeAlly = J.GetEnemiesNearLoc(strongestTarget:GetLocation(), nRadius)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and (#nInRangeAlly >= #nInRangeEnemy or J.WeAreStronger(bot, 1600))
            and nTargetInRangeAlly ~= nil and #nTargetInRangeAlly >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, strongestTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDarkPortrait()
    if not J.CanCastAbility(DarkPortrait)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

    if J.IsGoingOnSomeone(bot)
    then
        local target = nil
        local atkDMG = 0

        for _, enemy in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemy)
            and J.CanCastOnTargetAdvanced(enemy)
            and J.GetHP(enemy) > 0.35
            and not J.IsSuspiciousIllusion(enemy)
            and not J.IsDisabled(enemy)
            and not enemy:HasModifier('modifier_enigma_black_hole_pull')
            and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local currAtkDMG = enemy:GetAttackDamage()

                if currAtkDMG > atkDMG
                then
                    atkDMG = currAtkDMG
                    target = enemy
                end
            end
        end

        if target ~= nil
        then
            local nInRangeAlly = target:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = target:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if #nInRangeAlly >= #nInRangeEnemy
            or J.WeAreStronger(bot, 1600)
            then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X