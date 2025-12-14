local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_snapfire'
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
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,3,6,3,3,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_branches",
                "item_tango",
                "item_circlet",
                "item_gauntlets",
                "item_faerie_fire",
            
                "item_bottle",
                "item_magic_wand",
                "item_bracer",
                "item_power_treads",
                "item_maelstrom",
                "item_dragon_lance",
                "item_mjollnir",--
                "item_manta",--
                "item_hurricane_pike",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_manta",
                "item_bracer", "item_black_king_bar",
                "item_bottle", "item_greater_crit",
            },
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
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_rod_of_atos",
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_gungir",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_rod_of_atos",
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_gungir",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
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

local ScatterBlast      = bot:GetAbilityByName('snapfire_scatterblast')
local FiresnapCookie    = bot:GetAbilityByName('snapfire_firesnap_cookie')
local LilShredder       = bot:GetAbilityByName('snapfire_lil_shredder')
local GobbleUp          = bot:GetAbilityByName('snapfire_gobble_up')
local SpitOut           = bot:GetAbilityByName('snapfire_spit_creep')
local MortimerKisses    = bot:GetAbilityByName('snapfire_mortimer_kisses')

local ScatterBlastDesire, ScatterBlastLocation
local FiresnapCookieDesire, FiresnapCookieTarget
local LilShredderDesire
local GobbleUpDesire, GobbleUpTarget
local SpitOutDesire, SpitOutLocation
local MortimerKissesDesire, MortimerKissesLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local gobbled = { target = nil, type = '' }

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot)
    or bot:HasModifier('modifier_snapfire_mortimer_kisses')
    then
        return
    end

    ScatterBlast      = bot:GetAbilityByName('snapfire_scatterblast')
    FiresnapCookie    = bot:GetAbilityByName('snapfire_firesnap_cookie')
    LilShredder       = bot:GetAbilityByName('snapfire_lil_shredder')
    GobbleUp          = bot:GetAbilityByName('snapfire_gobble_up')
    SpitOut           = bot:GetAbilityByName('snapfire_spit_creep')
    MortimerKisses    = bot:GetAbilityByName('snapfire_mortimer_kisses')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    MortimerKissesDesire, MortimerKissesLocation = X.ConsiderMortimerKisses()
    if MortimerKissesDesire > 0 then
        bot:Action_UseAbilityOnLocation(MortimerKisses, MortimerKissesLocation)
        return
    end

    LilShredderDesire = X.ConsiderLilShredder()
    if LilShredderDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(LilShredder)
        return
    end

    ScatterBlastDesire, ScatterBlastLocation = X.ConsiderScatterBlast()
    if ScatterBlastDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(ScatterBlast, ScatterBlastLocation)
        return
    end

    FiresnapCookieDesire, FiresnapCookieTarget = X.ConsiderFiresnapCookie()
    if FiresnapCookieDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(FiresnapCookie, FiresnapCookieTarget)
        return
    end

    SpitOutDesire, SpitOutLocation = X.ConsiderSpitOut()
    if SpitOutDesire > 0
    then
        bot:Action_UseAbilityOnLocation(SpitOut, SpitOutLocation)
        return
    end

    GobbleUpDesire, GobbleUpTarget = X.ConsiderGobbleUp()
    if GobbleUpDesire > 0
    then
        bot:Action_UseAbilityOnEntity(GobbleUp, GobbleUpTarget)
        return
    end
end

function X.ConsiderScatterBlast()
    if not J.CanCastAbility(ScatterBlast) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, ScatterBlast:GetCastRange())
	local nCastPoint = ScatterBlast:GetCastPoint()
	local nRadius = ScatterBlast:GetSpecialValueInt('blast_width_initial')
	local nDamage = ScatterBlast:GetSpecialValueInt('damage')
    local nPointBlankRange = ScatterBlast:GetSpecialValueInt('point_blank_range')
    local nPointBlankBonusPct = ScatterBlast:GetSpecialValueInt('point_blank_dmg_bonus_pct') / 100
    local nManaCost = ScatterBlast:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FiresnapCookie, LilShredder, GobbleUp, MortimerKisses})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local damage = nDamage
            if J.IsInRange(bot, enemyHero, nPointBlankRange) then
                damage = nDamage * (1 + nPointBlankBonusPct)
            end

            if J.CanKillTarget(enemyHero, damage ,DAMAGE_TYPE_MAGICAL) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 4.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)
    local bIsLilShredding = bot:HasModifier('modifier_snapfire_lil_shredder_buff')

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 and not bIsLilShredding then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and not bIsLilShredding then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and not bIsLilShredding then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
			and not J.IsOtherAllysTarget(creep)
			then
                local damage = nDamage
                if J.IsInRange(bot, creep, nPointBlankRange) then
                    damage = nDamage * (1 + nPointBlankBonusPct)
                end

                if J.CanKillTarget(creep, damage ,DAMAGE_TYPE_MAGICAL) then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'ranged') then
                        if J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
                            return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                        end
                    end

                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 1000)
                    if nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end


                    local nLocationAoE2 = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, damage)
                    if nLocationAoE2.count >= 2 and (J.IsUnitTargetedByTower(creep, false) or nLocationAoE.count > 0) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE2.targetloc
                    end
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFiresnapCookie()
    if not J.CanCastAbility(FiresnapCookie) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, FiresnapCookie:GetCastRange())
	local nCastPoint = FiresnapCookie:GetCastPoint()
	local nRadius = FiresnapCookie:GetSpecialValueInt('impact_radius')
	local nJumpDistance = FiresnapCookie:GetSpecialValueInt('jump_horizontal_distance')
    local nJumpDuration = FiresnapCookie:GetSpecialValueFloat('jump_duration')
    local nLevel = FiresnapCookie:GetLevel()
    local nManaCost = FiresnapCookie:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ScatterBlast, LilShredder, GobbleUp, MortimerKisses})

    for i = 1, 5 do
        local allyHero = GetTeamMember(i)

        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not allyHero:IsChanneling()
        and not allyHero:IsCastingAbility()
        and not allyHero:HasModifier('modifier_teleporting')
        then
            local vJumpLocation = J.GetFaceTowardDistanceLocation(allyHero, nJumpDistance)
            local nInRangeEnemy = J.GetEnemiesNearLoc(vJumpLocation, nJumpDistance)

            if J.IsStuck(allyHero) then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and enemyHero:IsChanneling()
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if J.IsGoingOnSomeone(allyHero) then
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                local allyTarget = J.GetProperTarget(allyHero)

                if  J.IsValidHero(allyTarget)
                and J.CanBeAttacked(allyTarget)
                and GetUnitToLocationDistance(allyTarget, vJumpLocation) <= nRadius
                and J.CanCastOnNonMagicImmune(allyTarget)
                and not J.IsDisabled(allyTarget)
                and not allyTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                and not allyTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
                and fManaAfter > fManaThreshold1
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            nInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) and not J.IsRealInvisible(bot) and allyHero:IsFacingLocation(J.GetTeamFountain(), 30) then
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if J.IsValidHero(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    then
                        if (allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0))
                        or (allyHero:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nInRangeEnemy > #nAllyHeroes)
                        then
                            return BOT_ACTION_DESIRE_HIGH, allyHero
                        end
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nJumpDistance, true)
    local vJumpLocation = J.GetFaceTowardDistanceLocation(bot, nJumpDistance)
    local bIsLilShredding = bot:HasModifier('modifier_snapfire_lil_shredder_buff')

    if not bIsLilShredding and not J.CanCastAbilitySoon(ScatterBlast, 4.0) and not J.CanCastAbility(LilShredder, 4.0) and nLevel >= 3 then
        if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if J.GetDistance(vJumpLocation, nLocationAoE.targetloc) <= nRadius then
                        if (nLocationAoE.count >= 3) then
                            return BOT_ACTION_DESIRE_HIGH, bot
                        end
                    end
                end
            end
        end

        if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if J.GetDistance(vJumpLocation, nLocationAoE.targetloc) <= nRadius then
                        if (nLocationAoE.count >= 3) then
                            return BOT_ACTION_DESIRE_HIGH, bot
                        end
                    end
                end
            end
        end

        if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if J.GetDistance(vJumpLocation, nLocationAoE.targetloc) <= nRadius then
                        if (nLocationAoE.count >= 3)
                        or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                        or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                        then
                            return BOT_ACTION_DESIRE_HIGH, bot
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderLilShredder()
    if not J.CanCastAbility(LilShredder)
    or not bAttacking
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botAttackRange = bot:GetAttackRange() + LilShredder:GetSpecialValueInt('attack_range_bonus')
    local nManaCost = LilShredder:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ScatterBlast, FiresnapCookie, GobbleUp, MortimerKisses})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange - 100)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(botAttackRange, 1600), true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 550)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGobbleUp()
    if not bot:HasScepter()
    or not J.CanCastAbility(GobbleUp)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, GobbleUp:GetCastRange())

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 3000)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 200)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange + 300, true)
            if J.IsValid(nEnemyCreeps[1]) and J.CanCastOnTargetAdvanced(nEnemyCreeps[1]) then
                gobbled.target = nEnemyCreeps[1]
                gobbled.type = 'creep'
                return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
            end
		end
	end

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and bot ~= allyHero
        and J.CanBeAttacked(allyHero)
        and J.IsRetreating(allyHero)
        and not allyHero:IsIllusion()
        and not allyHero:IsChanneling()
        and not allyHero:HasModifier('modifier_teleporting')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.IsInRange(allyHero, enemyHero, 800)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsDisabled(enemyHero)
                and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                then
                    gobbled.target = allyHero
                    gobbled.type = 'hero'
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSpitOut()
    if not J.CanCastAbility(SpitOut)
    or not bot:HasModifier('modifier_snapfire_gobble_up_belly_has_unit')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = SpitOut:GetCastRange()
    local nCastPoint = SpitOut:GetCastPoint()
    local nSpeed = SpitOut:GetSpecialValueInt('projectile_speed')

	if gobbled.type == 'creep' then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)
        for _, enemyHero in pairs(nInRangeEnemy) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
            then
                local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                if enemyHero:IsChanneling() then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
                end
            end
        end

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and J.CanCastOnNonMagicImmune(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
            end
        end
    end

	if gobbled.type == 'hero' then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain()))
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMortimerKisses()
    if not J.CanCastAbility(MortimerKisses) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = MortimerKisses:GetCastRange()
    local nMinDistance = MortimerKisses:GetSpecialValueInt('min_range')

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 1200) then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nMinDistance)

	if (J.GetAttackProjectileDamageByRange(bot, 900) > bot:GetHealth())
    or (#nInRangeEnemy > 0)
    then
		return BOT_ACTION_DESIRE_NONE
	end

    for i = 1, 5 do
        local allyHero = GetTeamMember(i)

        if  J.IsValidHero(allyHero)
        and J.IsInTeamFight(allyHero, 1200)
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1600)
            if #nInRangeEnemy >= 2 then
                local hTarget = nil
                local hTargetHealth = math.huge
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and not J.IsInRange(bot, enemyHero, nMinDistance)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                    and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                    and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                    and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
                    then
                        if enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                        or enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        or enemyHero:HasModifier('modifier_legion_commander_duel')
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                        end

                        local enemyHeroHealth = enemyHero:GetHealth()
                        if enemyHeroHealth < hTargetHealth then
                            hTarget = enemyHero
                            hTargetHealth = enemyHeroHealth
                        end
                    end
                end

                if hTarget then
                    return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, nMinDistance)
        and J.CanCastOnMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and botTarget:GetHealth() > 500
        then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
            if not (#nInRangeAlly >= #nInRangeEnemy + 3) and J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 5.0) > botTarget:GetHealth() then
                if J.IsDisabled(botTarget)
                or botTarget:GetCurrentMovementSpeed() <= 280
                or botTarget:HasModifier('modifier_legion_commander_duel')
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X