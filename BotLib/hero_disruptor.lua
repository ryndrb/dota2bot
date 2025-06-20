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

local botTarget

if bot.KineticFieldTimeLast == nil then bot.KineticFieldTimeLast = -1 end
if bot.KineticFieldLocation == nil then bot.KineticFieldLocation = bot:GetLocation() end

local KineticFenceTimeLast = 0

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    ThunderStrike = bot:GetAbilityByName('disruptor_thunder_strike')
    Glimpse       = bot:GetAbilityByName('disruptor_glimpse')
    KineticField  = bot:GetAbilityByName('disruptor_kinetic_field')
    KineticFence  = bot:GetAbilityByName('disruptor_kinetic_fence')
    StaticStorm   = bot:GetAbilityByName('disruptor_static_storm')

    botTarget = J.GetProperTarget(bot)

    KineticStormDesire, KineticStormLocation = X.ConsiderKineticStorm()
    if KineticStormDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(StaticStorm, KineticStormLocation)
        bot:ActionQueue_Delay(0.05)
        bot:ActionQueue_UseAbilityOnLocation(KineticField, KineticStormLocation)
        bot:ActionQueue_Delay(0.05)
        return
    end

    StaticStormDesire, StaticStormLocation = X.ConsiderStaticStorm()
    if StaticStormDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StaticStorm, StaticStormLocation)
        return
    end

    KineticFieldDesire, KineticFieldLocation = X.ConsiderKineticField()
    if KineticFieldDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(KineticField, KineticFieldLocation)
        bot.KineticFieldLocation = KineticFieldLocation
        bot.KineticFieldTimeLast = DotaTime()
        return
    end

    KineticFenceDesire, KineticFenceLocation = X.ConsiderKineticFence()
    if KineticFenceDesire > 0 then
        bot:Action_UseAbilityOnLocation(KineticFence, KineticFenceLocation)
        KineticFenceTimeLast = DotaTime()
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
    if not J.CanCastAbility(ThunderStrike)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, ThunderStrike:GetCastRange())
    local nRadius = ThunderStrike:GetSpecialValueInt('radius')
	local nDamage = ThunderStrike:GetSpecialValueInt('strike_damage')
    local nStikesCount = ThunderStrike:GetSpecialValueInt('strikes')

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidTarget(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage * nStikesCount, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.IsRetreating(allyHero)
        and J.IsCore(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(5.0)
        and not allyHero:IsIllusion()
        and not J.CanCastAbility(Glimpse)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (J.IsChasingTarget(enemyHero, bot) or bot:WasRecentlyDamagedByHero(enemyHero, 4))
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)
	then
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        then
            for _, creep in pairs(nEnemyLaneCreeps)
            do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and not J.IsRunning(creep)
                then
                    local nCreepCountAround = J.GetNearbyAroundLocationUnitCount(true, false, nRadius, creep:GetLocation())
                    if nCreepCountAround >= 2
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
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

    for _, creep in pairs(nNeutralCreeps)
    do
        if  J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and creep:GetHealth() > nDamage * nStikesCount / 2
        and creep:GetHealth() <= nDamage * nStikesCount
        then
            return BOT_ACTION_DESIRE_HIGH, creep
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGlimpse()
    if not J.CanCastAbility(Glimpse)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local _, KineticField_ = J.HasAbility(bot, 'disruptor_kinetic_field')
    local nCastRange = J.GetProperCastRange(false, bot, Glimpse:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local nDuration = 0
    if KineticField_ ~= nil then nDuration = KineticField_:GetSpecialValueFloat('duration') end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and (enemyHero:IsChanneling()
		or (J.IsGoingOnSomeone(bot)
            and (nAllyHeroes ~= nil and #nAllyHeroes <= 3 and #nEnemyHeroes <= 2)
            and bot:IsFacingLocation(enemyHero:GetLocation(), 30)
            and enemyHero:IsFacingLocation(J.GetEnemyFountain(), 30)))
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
		then
            if enemyHero:HasModifier('modifier_teleporting')
            or enemyHero:HasModifier('modifier_fountain_aura_buff')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.IsGoingOnSomeone(bot)
            then
                if J.IsChasingTarget(bot, enemyHero)
                and enemyHero:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
                and not enemyHero:HasModifier('modifier_disruptor_static_storm')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not J.IsLocationInArena(enemyHero:GetLocation(), 600)
                then
                    if KineticField ~= nil
                    then
                        if DotaTime() > bot.KineticFieldTimeLast + nDuration
                        and GetUnitToLocationDistance(enemyHero, bot.KineticFieldLocation) > 350
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

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.75
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (J.IsChasingTarget(enemyHero, bot) or bot:WasRecentlyDamagedByHero(enemyHero, 3))
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_disruptor_static_storm')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not J.IsLocationInArena(enemyHero:GetLocation(), 600)
            then
                if KineticField ~= nil
                then
                    if DotaTime() > bot.KineticFieldTimeLast + nDuration
                    and GetUnitToLocationDistance(enemyHero, bot.KineticFieldLocation) > 350
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.IsCore(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.75
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_disruptor_static_storm')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and not J.IsLocationInArena(nAllyInRangeEnemy[1]:GetLocation(), 600)
            then
                if KineticField ~= nil
                then
                    if DotaTime() > bot.KineticFieldTimeLast + nDuration
                    and GetUnitToLocationDistance(nAllyInRangeEnemy[1], bot.KineticFieldLocation) > 350
                    then
                        return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
                end
            end
        end
    end

    local realHeroCount = 0
    local illuHeroCount = 0
    local illuTarget = nil

    for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and Glimpse:GetLevel() >= 3
		then
            if J.IsSuspiciousIllusion(enemyHero)
            then
                illuHeroCount = illuHeroCount + 1
                illuTarget = enemyHero
            else
                realHeroCount = realHeroCount + 1
            end
        end
    end

    if realHeroCount == 0 and illuHeroCount >= 1
    then
        return BOT_ACTION_DESIRE_HIGH, illuTarget
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderKineticField()
    if not J.CanCastAbility(KineticField)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
	local nCastPoint = KineticField:GetCastPoint()
	local nRadius = KineticField:GetSpecialValueInt('radius')

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:IsMagicImmune()
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		then
            if nEnemyHeroes ~= nil and #nEnemyHeroes <= 1
            then
                if J.IsChasingTarget(bot, botTarget)
                then
                    if not J.IsInRange(bot, botTarget, nCastRange)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 0.2)
                    end
                end
            else
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius - 75)

                if not J.IsInRange(bot, botTarget, nCastRange)
                then
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                    end
                else
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 0.2)
                    end
                end
            end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.7
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsMagicImmune()
        and not nEnemyHeroes[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if GetUnitToLocationDistance(bot, J.GetCorrectLoc(nEnemyHeroes[1], nCastPoint)) > nRadius
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            else
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + nEnemyHeroes[1]:GetLocation()) / 2
            end
        end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.IsCore(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.75
        and allyHero:WasRecentlyDamagedByAnyHero(4.0)
        and not allyHero:IsIllusion()
        and not J.IsGoingOnSomeone(bot)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:IsMagicImmune()
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and GetUnitToUnitDistance(allyHero, nAllyInRangeEnemy[1]) < GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]:GetLocation()
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

local nDuration = 5
function X.ConsiderKineticFence()
    if not J.CanCastAbility(KineticFence) or DotaTime() < KineticFenceTimeLast + nDuration then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, KineticFence:GetCastRange())
	local nCastPoint = KineticFence:GetCastPoint()
	local nRadius = KineticFence:GetSpecialValueInt('radius')
    local nDelay = KineticFence:GetSpecialValueInt('formation_time')
    nDuration = KineticFence:GetSpecialValueInt('duration')

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

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
            local vAoELocation = nLocationAoE.targetloc
            local botTargetLocation = J.GetCorrectLoc(botTarget, nDelay)

            if #nEnemyHeroes <= 1 then
                if J.IsChasingTarget(bot, botTarget) then
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, vAoELocation
                    else
                        return BOT_ACTION_DESIRE_HIGH, botTargetLocation
                    end
                end
            else
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, vAoELocation
                else
                    return BOT_ACTION_DESIRE_HIGH, botTargetLocation
                end
            end
		end
	end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.9
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + J.GetCorrectLoc(enemyHero, nDelay)) / 2
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderStaticStorm()
    if not J.CanCastAbility(StaticStorm)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = StaticStorm:GetSpecialValueInt('radius')
	local nCastRange = J.GetProperCastRange(false, bot, StaticStorm:GetCastRange())

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)

		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderKineticStorm()
    if X.CanCastKineticStorm()
    then
	    local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
        local nRadius = KineticField:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)

            if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanCastKineticStorm()
    if J.CanCastAbility(KineticField)
    and J.CanCastAbility(StaticStorm)
    then
        local nManaCost = KineticField:GetManaCost() + StaticStorm:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

return X