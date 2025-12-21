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
                "item_double_branches",
                "item_blood_grenade",
                "item_faerie_fire",
                "item_magic_stick",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_aether_lens",
                "item_aghanims_shard",
                "item_glimmer_cape",--
                "item_ultimate_scepter",
                "item_boots_of_bearing",--
                "item_sheepstick",--
                "item_aeon_disk",--
                "item_ultimate_scepter_2",
                "item_octarine_core",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_aeon_disk",
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
                "item_double_branches",
                "item_blood_grenade",
                "item_faerie_fire",
                "item_magic_stick",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_aether_lens",
                "item_aghanims_shard",
                "item_glimmer_cape",--
                "item_ultimate_scepter",
                "item_guardian_greaves",--
                "item_sheepstick",--
                "item_aeon_disk",--
                "item_ultimate_scepter_2",
                "item_octarine_core",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_aeon_disk",
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

local inkswell = { cast_time = -1, wearer = nil, detonate = false }

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    StrokeOfFate      = bot:GetAbilityByName('grimstroke_dark_artistry')
    PhantomsEmbrace   = bot:GetAbilityByName('grimstroke_ink_creature')
    InkSwell          = bot:GetAbilityByName('grimstroke_spirit_walk')
    InkExplosion      = bot:GetAbilityByName('grimstroke_return')
    DarkPortrait      = bot:GetAbilityByName('grimstroke_dark_portrait')
    SoulBind          = bot:GetAbilityByName('grimstroke_soul_chain')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    InkExplosionDesire = X.ConsiderInkExplosion()
    if InkExplosionDesire > 0 then
        bot:Action_UseAbility(InkExplosion)
        return
    end

    InkSwellDesire, InkSwellTarget = X.ConsiderInkSwell()
    if InkSwellDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(InkSwell, InkSwellTarget)
        inkswell.cast_time = DotaTime()
        inkswell.wearer = InkSwellTarget
        return
    end

    SoulBindDesire, SoulBindTarget = X.ConsiderSoulBind()
    if SoulBindDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SoulBind, SoulBindTarget)
        return
    end

    PhantomsEmbraceDesire, PhantomsEmbraceTarget = X.ConsiderPhantomsEmbrace()
    if PhantomsEmbraceDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(PhantomsEmbrace, PhantomsEmbraceTarget)
        return
    end

    StrokeOfFateDesire, StrokeOfFateLocation = X.ConsiderStrokeOfFate()
    if StrokeOfFateDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StrokeOfFate, StrokeOfFateLocation)
        return
    end

    DarkPortraitDesire, DarkPortraitTarget = X.ConsiderDarkPortrait()
    if DarkPortraitDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DarkPortrait, DarkPortraitTarget)
        return
    end
end

function X.ConsiderStrokeOfFate()
    if not J.CanCastAbility(StrokeOfFate) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = StrokeOfFate:GetCastRange()
	local nCastPoint = StrokeOfFate:GetCastPoint()
	local nRadius = StrokeOfFate:GetSpecialValueInt('end_radius')
	local nSpeed = StrokeOfFate:GetSpecialValueInt('projectile_speed')
    local nDamage = StrokeOfFate:GetSpecialValueInt('damage')
    local nManaCost = StrokeOfFate:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PhantomsEmbrace, InkSwell, DarkPortrait, SoulBind})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {StrokeOfFate, PhantomsEmbrace, InkSwell, DarkPortrait, SoulBind})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL , nDelay) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
            end
		end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsInRange(bot, enemyHero, 300)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        local vLocation = J.VectorTowards(enemyHero:GetLocation(), allyHero:GetLocation(), 300)
                        if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end
            end
        end

        if not J.IsInLaningPhase() then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and not J.IsRunning(creep)
                and not J.IsUnitTargetedByTower(creep, false)
                and (J.IsCore(bot) or not J.IsThereCoreInLocation(creep:GetLocation(), 800))
                then
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep() and creep:GetHealth() > nDamage)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and creep:GetHealth() > nDamage and fManaAfter > fManaThreshold2)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase(bot) and fManaAfter > fManaThreshold1
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            then
                if string.find(creep:GetUnitName(), 'range') then
                    local nDelay = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                    if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nDelay) then
                        local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                            return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                        end
                    end
                end

                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.GetHP(botTarget) > 0.2
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPhantomsEmbrace()
    if not J.CanCastAbility(PhantomsEmbrace) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = PhantomsEmbrace:GetCastRange()
    local nCastPoint = PhantomsEmbrace:GetCastPoint()
    local nDuration = PhantomsEmbrace:GetSpecialValueInt('latch_duration')
    local nDamagePerSec = PhantomsEmbrace:GetSpecialValueInt('damage_per_second')
    local nRendDamage = PhantomsEmbrace:GetSpecialValueInt('pop_damage')
    local nSpeed = PhantomsEmbrace:GetSpecialValueInt('speed')
    local nManaCost = PhantomsEmbrace:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StrokeOfFate, InkSwell, DarkPortrait, SoulBind})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {StrokeOfFate, PhantomsEmbrace, InkSwell, DarkPortrait, SoulBind})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if  enemyHero:IsChanneling()
            and fManaAfter > fManaThreshold2
            and not enemyHero:HasModifier('modifier_teleporting')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
            if  not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                if J.IsInTeamFight(bot, 1200) then
                    if J.CanKillTarget(enemyHero, nDamagePerSec * nDuration + nRendDamage, DAMAGE_TYPE_MAGICAL) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    if J.WillKillTarget(enemyHero, nDamagePerSec, DAMAGE_TYPE_MAGICAL, eta + nDuration) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
		end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsSilenced()
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsSilenced()
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and enemyHero:GetMana() > 150
            then
                if enemyHero:IsUsingAbility()
                or enemyHero:IsCastingAbility()
                or (enemyHero:IsChanneling() and not enemyHero:HasModifier('modifier_teleporting'))
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsSilenced()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        if enemyHero:IsUsingAbility()
                        or enemyHero:IsCastingAbility()
                        or (enemyHero:IsChanneling() and not enemyHero:HasModifier('modifier_teleporting'))
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderInkSwell()
    if not J.CanCastAbility(InkSwell) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = InkSwell:GetCastRange()
	local nRadius = InkSwell:GetSpecialValueInt('radius')
    local nManaCost = InkSwell:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StrokeOfFate, PhantomsEmbrace, DarkPortrait, SoulBind})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {StrokeOfFate, PhantomsEmbrace, InkSwell, DarkPortrait, SoulBind})

    for _, allyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.IsInRange(allyHero, enemyHero, nRadius)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsDisabled(enemyHero)
                then
                    if enemyHero:IsChanneling() then
                        inkswell.detonate = true
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            for _, allyHero in pairs(nAllyHeroes) do
                if J.IsValidHero(allyHero)
                and J.IsGoingOnSomeone(allyHero)
                and J.IsInRange(allyHero, botTarget, 1200)
                and not J.IsSuspiciousIllusion(allyHero)
                and not J.IsMeepoClone(allyHero)
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), nRadius + 75)
                    if #nInRangeEnemy > 0 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not J.IsRealInvisible(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            if J.IsRetreating(allyHero) then
                if bot == allyHero then
                    for _, enemyHero in pairs(nEnemyHeroes) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and J.IsInRange(bot, enemyHero, nRadius * 1.5)
                        and J.CanCastOnNonMagicImmune(enemyHero)
                        and not J.IsDisabled(enemyHero)
                        and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
                        then
                            return BOT_ACTION_DESIRE_HIGH, bot
                        end
                    end
                else
                    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
                        if allyHero:WasRecentlyDamagedByAnyHero(2.0) then
                            for _, enemyHero in pairs(nEnemyHeroes) do
                                if  J.IsValidHero(enemyHero)
                                and J.CanBeAttacked(enemyHero)
                                and J.IsInRange(allyHero, enemyHero, nRadius)
                                and J.CanCastOnNonMagicImmune(enemyHero)
                                and J.IsChasingTarget(enemyHero, allyHero)
                                and not J.IsDisabled(enemyHero)
                                and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                                then
                                    return BOT_ACTION_DESIRE_HIGH, allyHero
                                end
                            end
                        end
                    end
                end
            end

            if J.IsDoingRoshan(bot) then
                if  J.IsRoshan(botTarget)
                and J.CanBeAttacked(botTarget)
                and J.CanCastOnNonMagicImmune(botTarget)
                and J.IsInRange(allyHero, botTarget, nRadius)
                and J.IsAttacking(allyHero)
                and fManaAfter > fManaThreshold2
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if J.IsDoingTormentor(bot) then
                if  J.IsTormentor(botTarget)
                and J.IsInRange(allyHero, botTarget, nRadius)
                and J.IsAttacking(allyHero)
                and fManaAfter > fManaThreshold2
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end


    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderInkExplosion()
    if not J.CanCastAbility(InkExplosion) then
        inkswell.detonate = false
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = InkSwell:GetSpecialValueInt('radius')
    local nDuration = InkSwell:GetSpecialValueInt('buff_duration')
    local nMaxDamage = InkSwell:GetSpecialValueInt('max_damage')

    if inkswell.detonate then
        return BOT_ACTION_DESIRE_HIGH
    end

    if inkswell.wearer and inkswell.wearer:HasModifier('modifier_grimstroke_spirit_walk_buff') then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local fModifierTime = J.GetModifierTime(inkswell.wearer, 'modifier_grimstroke_spirit_walk_buff')
                local nDamage = RemapValClamped(fModifierTime, 0, nDuration, nMaxDamage, 0)

                if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDarkPortrait()
    if not J.CanCastAbility(DarkPortrait) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = DarkPortrait:GetCastRange()

    if J.IsGoingOnSomeone(bot) and bAttacking then
        local hTarget = nil
        local hTargetAttackDamge = 0

        for _, enemy in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnTargetAdvanced(enemy)
            and J.GetHP(enemy) > 0.35
            and not J.IsDisabled(enemy)
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyAttackDamage = enemy:GetAttackDamage() * enemy:GetAttackSpeed()
                if hTargetAttackDamge < enemyAttackDamage then
                    hTarget = enemy
                    hTargetAttackDamge = enemyAttackDamage
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSoulBind()
    if not J.CanCastAbility(SoulBind) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = SoulBind:GetCastRange()
	local nRadius = SoulBind:GetSpecialValueInt('chain_latch_radius')
    local nDuration = SoulBind:GetSpecialValueInt('chain_duration')

    if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetScore = 0

        for _, enemy in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnTargetAdvanced(enemy)
            and not J.IsDisabled(enemy)
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyScore = enemy:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemy:GetLocation(), nRadius)
                if enemyScore > hTargetScore and #nInRangeEnemy >= 2 then
                    hTarget = enemy
                    hTargetScore = enemyScore
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X