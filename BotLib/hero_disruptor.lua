local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_disruptor'
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_force_staff",
                "item_boots_of_bearing",--
                "item_ultimate_scepter",
                "item_octarine_core",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_moon_shard",
                "item_hurricane_pike",--
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_force_staff",
                "item_guardian_greaves",--
                "item_ultimate_scepter",
                "item_octarine_core",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_moon_shard",
                "item_hurricane_pike",--
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

local ThunderStrike = bot:GetAbilityByName('disruptor_thunder_strike')
local Glimpse       = bot:GetAbilityByName('disruptor_glimpse')
local KineticField  = bot:GetAbilityByName('disruptor_kinetic_field')
local KineticFence  = bot:GetAbilityByName('disruptor_kinetic_fence')
local StaticStorm   = bot:GetAbilityByName('disruptor_static_storm')

local ThunderStrikeDesire, ThunderStrikeTarget
local GlimpseDesire, GlimpseTarget
local KineticFieldDesire, KineticFieldLocation
local KineticFenceDesire, KineticFenceLocation
local StaticStormDesire, StaticStormLocation

local KineticStormDesire, KineticStormLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local kinetic = {
    field_cast_time = 0, field_cast_location = nil,
    fence_cast_time = 0, fence_cast_location = nil,
}

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    ThunderStrike = bot:GetAbilityByName('disruptor_thunder_strike')
    Glimpse       = bot:GetAbilityByName('disruptor_glimpse')
    KineticField  = bot:GetAbilityByName('disruptor_kinetic_field')
    KineticFence  = bot:GetAbilityByName('disruptor_kinetic_fence')
    StaticStorm   = bot:GetAbilityByName('disruptor_static_storm')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    KineticStormDesire, KineticStormLocation = X.ConsiderKineticStorm()
    if KineticStormDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(KineticField, KineticStormLocation)
        bot:ActionQueue_UseAbilityOnLocation(StaticStorm, KineticStormLocation)
        return
    end

    StaticStormDesire, StaticStormLocation = X.ConsiderStaticStorm()
    if StaticStormDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if J.CanCastAbility(KineticField) then
            if bot:GetMana() > KineticField:GetManaCost() + StaticStorm:GetManaCost() + 75 then
                bot:ActionQueue_UseAbilityOnLocation(KineticField, StaticStormLocation)
                bot:ActionQueue_UseAbilityOnLocation(StaticStorm, StaticStormLocation)
                return
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(StaticStorm, StaticStormLocation)
        return
    end

    KineticFieldDesire, KineticFieldLocation = X.ConsiderKineticField()
    if KineticFieldDesire > 0
    then
        kinetic.field_cast_time = DotaTime()
        kinetic.field_cast_location = KineticFieldLocation
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(KineticField, KineticFieldLocation)
        return
    end

    KineticFenceDesire, KineticFenceLocation = X.ConsiderKineticFence()
    if KineticFenceDesire > 0 then
        kinetic.fence_cast_time = DotaTime()
        kinetic.fence_cast_location = KineticFenceLocation
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(KineticFence, KineticFenceLocation)
        return
    end

    ThunderStrikeDesire, ThunderStrikeTarget = X.ConsiderThunderStrike()
    if ThunderStrikeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ThunderStrike, ThunderStrikeTarget)
        return
    end

    GlimpseDesire, GlimpseTarget = X.ConsiderGlimpse()
    if GlimpseDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Glimpse, GlimpseTarget)
        return
    end
end

function X.ConsiderThunderStrike()
    if not J.CanCastAbility(ThunderStrike) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, ThunderStrike:GetCastRange())
    local nCastPoint = ThunderStrike:GetCastPoint()
    local nRadius = ThunderStrike:GetSpecialValueInt('radius')
	local nDamage = ThunderStrike:GetSpecialValueInt('strike_damage')
    local nStrikesCount = ThunderStrike:GetSpecialValueInt('strikes')
    local nStrikesInterval = ThunderStrike:GetSpecialValueInt('strike_interval')
    local nManaCost = ThunderStrike:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Glimpse, KineticField, KineticFence, StaticStorm})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ThunderStrike, Glimpse, KineticField, KineticFence, StaticStorm})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {KineticField, KineticFence, StaticStorm})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidTarget(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + nStrikesCount * nStrikesInterval)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and fManaAfter > fManaThreshold3
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold3 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(5.0)
            and not allyHero:IsIllusion()
            and not J.CanCastAbility(Glimpse)
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and J.CanCastOnTargetAdvanced(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and J.CanCastOnTargetAdvanced(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and J.CanCastOnTargetAdvanced(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and fManaAfter > fManaThreshold2)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
        for _, creep in pairs(nNeutralCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnTargetAdvanced(creep)
            and (J.IsCore(bot) or not J.IsThereCoreInLocation(creep:GetLocation(), 800))
            then
                if  J.CanKillTarget(creep, nDamage * nStrikesCount, DAMAGE_TYPE_MAGICAL)
                and not J.CanKillTarget(creep, nDamage * nStrikesCount / 2, DAMAGE_TYPE_MAGICAL)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end

        if botHP < 0.5 and J.IsRunning(bot) then
            for _, creep in pairs(nEnemyCreeps) do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.CanCastOnTargetAdvanced(creep)
                and creep:GetAttackTarget() == bot
                then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'warlock_golem')
                    or string.find(sCreepName, 'lycan_wolf')
                    or string.find(sCreepName, 'boar')
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGlimpse()
    if not J.CanCastAbility(Glimpse) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = Glimpse:GetCastRange()
    local nCastPoint = Glimpse:GetCastPoint()
    local nLapseTime = Glimpse:GetSpecialValueInt('backtrack_time')
    local fMaxTeleportTime = 1.8
    local nManaCost = Glimpse:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {KineticField, KineticFence, StaticStorm})

    local nRadius, nDuration = 0, 0
    if KineticField and KineticField:IsTrained() then
        nRadius = KineticField:GetSpecialValueFloat('radius')
        nDuration = KineticField:GetSpecialValueFloat('duration')
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidTarget(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            local fModifierTime = J.GetModifierTime(enemyHero, 'modifier_teleporting')
            if (fModifierTime > nCastPoint and fModifierTime < fMaxTeleportTime)
            or (enemyHero:HasModifier('modifier_fountain_aura_buff'))
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_disruptor_static_storm')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and J.IsChasingTarget(bot, botTarget)
        and J.IsRunning(bot)
        and J.IsRunning(botTarget)
        and fManaAfter > fManaThreshold1
		then
            if DotaTime() > kinetic.field_cast_time + nDuration then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end

            if kinetic.field_cast_location then
                if GetUnitToLocationDistance(botTarget, kinetic.field_cast_location) > nRadius + botTarget:GetBoundingRadius() then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            end
		end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_disruptor_static_storm')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if DotaTime() > kinetic.field_cast_time + nDuration then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end

                if kinetic.field_cast_location then
                    if GetUnitToLocationDistance(enemyHero, kinetic.field_cast_location) > nRadius + enemyHero:GetBoundingRadius() then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 and not J.IsInTeamFight(bot, 800) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_disruptor_static_storm')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        if DotaTime() > kinetic.field_cast_time + nDuration then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero
                        end

                        if kinetic.field_cast_location then
                            if GetUnitToLocationDistance(enemyHero, kinetic.field_cast_location) > nRadius + enemyHero:GetBoundingRadius() then
                                return BOT_ACTION_DESIRE_HIGH, enemyHero
                            end
                        end
                    end
                end
            end
        end

        local hTarget = nil
        local nHeroCountReal = 0
        local nHeroCountIllu = 0

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and Glimpse:GetLevel() >= 3
            then
                local sEnemyHeroName = enemyHero:GetUnitName()
                if sEnemyHeroName == 'npc_dota_hero_terrorblade'
                or sEnemyHeroName == 'npc_dota_hero_naga_siren'
                or sEnemyHeroName == 'npc_dota_hero_chaos_knight'
                then
                    if J.IsSuspiciousIllusion(enemyHero) then
                        hTarget = enemyHero
                        nHeroCountIllu = nHeroCountIllu + 1
                    else
                        nHeroCountReal = nHeroCountReal + 1
                    end
                end
            end
        end

        if hTarget and nHeroCountReal == 0 and nHeroCountIllu > 0 then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderKineticField()
    if not J.CanCastAbility(KineticField) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
	local nCastPoint = KineticField:GetCastPoint()
	local nRadius = KineticField:GetSpecialValueInt('radius')
    local nDelay = KineticField:GetSpecialValueInt('formation_time')
    local nManaCost = KineticField:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ThunderStrike, Glimpse, KineticFence, StaticStorm})

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint + nDelay, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)

		if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
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
        and J.IsInRange(bot, botTarget, nCastRange * 0.8)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:IsMagicImmune()
        and J.IsRunning(botTarget)
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), nRadius)
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 and not J.IsInTeamFight(bot, 800) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), allyHero:GetLocation(), nRadius)
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

local nDuration = 5
function X.ConsiderKineticFence()
    if not J.CanCastAbility(KineticFence)
    or DotaTime() < kinetic.fence_cast_time + nDuration
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, KineticFence:GetCastRange())
	local nCastPoint = KineticFence:GetCastPoint()
	local nRadius = KineticFence:GetSpecialValueInt('radius')
    local nDelay = KineticFence:GetSpecialValueInt('formation_time')
    nDuration = KineticFence:GetSpecialValueInt('duration') + nCastPoint * 2

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint + nDelay, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, nCastPoint, 0)
            local botTargetLocation = J.GetCorrectLoc(botTarget, nDelay)

            if #nEnemyHeroes <= 1 then
                if J.IsChasingTarget(bot, botTarget) then
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    else
                        return BOT_ACTION_DESIRE_HIGH, botTargetLocation
                    end
                end
            else
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                else
                    return BOT_ACTION_DESIRE_HIGH, botTargetLocation
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + J.GetCorrectLoc(enemyHero, nDelay)) / 2
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderStaticStorm()
    if not J.CanCastAbility(StaticStorm) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, StaticStorm:GetCastRange())
	local nRadius = StaticStorm:GetSpecialValueInt('radius')

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderKineticStorm()
    if J.CanCastAbility(KineticField) and J.CanCastAbility(StaticStorm) then
	    local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
        local nRadius = KineticField:GetSpecialValueInt('radius')

        local nManaCost = KineticField:GetManaCost() + StaticStorm:GetManaCost() + 75
        if bot:GetMana() < nManaCost then
            return BOT_ACTION_DESIRE_NONE
        end

        if J.IsInTeamFight(bot, 1200) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)
            if #nInRangeEnemy >= 2 then
                local count = 0
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                    and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        count = count + 1
                    end
                end

                if count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X