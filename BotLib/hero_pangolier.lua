local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_pangolier'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_lotus_orb", "item_crimson_guard", "item_pipe", "item_heavens_halberd"}
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
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_arcane_boots",
                "item_diffusal_blade",
                "item_blink",
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_basher",
                "item_octarine_core",--
                "item_disperser",--
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_abyssal_blade",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_diffusal_blade",
                "item_circlet", "item_blink",
                "item_circlet", "item_ultimate_scepter",
                "item_magic_wand", "item_basher",
                "item_magic_wand", "item_abyssal_blade",
                "item_bottle", "item_octarine_core",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_soul_ring",
                "item_diffusal_blade",
                "item_blink",
                "item_assault",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_disperser",--
                "item_shivas_guard",--
                "item_abyssal_blade",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_diffusal_blade",
                "item_circlet", "item_blink",
                "item_circlet", "item_assault",
                "item_magic_wand", "item_ultimate_scepter",
                "item_soul_ring", "item_shivas_guard",
            },
        },
    },
    ['pos_4'] = {
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
    ['pos_5'] = {
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
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end
end

end

local Swashbuckle       = bot:GetAbilityByName('pangolier_swashbuckle')
local ShieldCrash       = bot:GetAbilityByName('pangolier_shield_crash')
-- local LuckyShot         = bot:GetAbilityByName('pangolier_luckyshot')
local RollUp            = bot:GetAbilityByName('pangolier_rollup')
local EndRollUp         = bot:GetAbilityByName('pangolier_rollup_stop')
local RollingThunder    = bot:GetAbilityByName('pangolier_gyroshell')
local EndRollingThunder    = bot:GetAbilityByName('pangolier_gyroshell_stop')

local SwashbuckleDesire, SwashbuckleLocation
local ShieldCrashDesire
local RollUpDesire
local EndRollUpDesire
local RollingThunderDesire
local EndRollingThunderDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Swashbuckle       = bot:GetAbilityByName('pangolier_swashbuckle')
    ShieldCrash       = bot:GetAbilityByName('pangolier_shield_crash')
    RollUp            = bot:GetAbilityByName('pangolier_rollup')
    EndRollUp         = bot:GetAbilityByName('pangolier_rollup_stop')
    RollingThunder    = bot:GetAbilityByName('pangolier_gyroshell')
    EndRollingThunder = bot:GetAbilityByName('pangolier_gyroshell_stop')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    EndRollUpDesire = X.ConsiderEndRollUp()
    if EndRollUpDesire > 0 then
        bot:Action_UseAbility(EndRollUp)
        return
    end

    RollUpDesire = X.ConsiderRollUp()
    if RollUpDesire > 0 then
        bot:Action_UseAbility(RollUp)
        return
    end

    EndRollingThunderDesire = X.ConsiderEndRollingThunder()
    if EndRollingThunderDesire > 0 then
        bot:Action_UseAbility(EndRollingThunder)
        return
    end

    RollingThunderDesire = X.ConsiderRollingThunder()
    if RollingThunderDesire > 0 then
        bot:Action_UseAbility(RollingThunder)
        return
    end

    ShieldCrashDesire = X.ConsiderShieldCrash()
    if ShieldCrashDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ShieldCrash)
        return
    end

    SwashbuckleDesire, SwashbuckleLocation = X.ConsiderSwashbuckle()
    if SwashbuckleDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Swashbuckle, SwashbuckleLocation)
        return
    end
end

function X.ConsiderSwashbuckle()
    if not J.CanCastAbility(Swashbuckle)
    or bot:HasModifier('modifier_pangolier_gyroshell')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = Swashbuckle:GetCastRange()
    local nRadius = Swashbuckle:GetSpecialValueInt('end_radius')
    local nDamage = Swashbuckle:GetSpecialValueInt('damage')
    local nStrikeCount = Swashbuckle:GetSpecialValueInt('strikes')
    local nManaCost = Swashbuckle:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShieldCrash, RollUp, RollingThunder})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanKillTarget(enemyHero, nDamage * nStrikeCount, DAMAGE_TYPE_PHYSICAL)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
            if #nInRangeAlly >= #nInRangeEnemy and not J.IsRetreating(bot) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain()))
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
                if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
                or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nCastRange, bot:DistanceFromFountain()))
                end
			end
		end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
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

    local nEnemyTowers = bot:GetNearbyTowers(1200, true)

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and #nEnemyTowers == 0 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not J.IsOtherAllysTarget(creep)
			then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 500, 0, 0)

                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end

                local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
                if #nInRangeEnemy > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 and not J.IsRunning(creep) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.05
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.05
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShieldCrash()
    if not J.CanCastAbility(ShieldCrash) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ShieldCrash:GetSpecialValueInt('radius')
    local nDamage = ShieldCrash:GetSpecialValueInt('damage')
    local nJumpDistance = ShieldCrash:GetSpecialValueInt('jump_horizontal_distance')
    local nManaCost = Swashbuckle:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Swashbuckle, RollUp, RollingThunder})

    local vJumpLocation = J.GetFaceTowardDistanceLocation(bot, nJumpDistance)

    if  bot:HasModifier('modifier_pangolier_gyroshell')
    and not bot:HasModifier('modifier_pangolier_gyroshell_ricochet')
    then
        if (GetHeightLevel(vJumpLocation) > GetHeightLevel(bot:GetLocation()))
        or not IsLocationVisible(vJumpLocation)
        or not IsLocationPassable(vJumpLocation)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bot:HasModifier('modifier_pangolier_rollup') and not J.IsRealInvisible(bot) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if #nInRangeEnemy > 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH
	end

    if J.IsInTeamFight(bot, 1200) then
        local count = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and GetUnitToLocationDistance(enemyHero, vJumpLocation) <= nRadius
            and not J.IsDisabled(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                count = count + 1
            end
        end

        if count >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and GetUnitToLocationDistance(botTarget, vJumpLocation) <= nRadius
        and not J.IsDisabled(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nJumpDistance, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.05 and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if J.GetDistance(vJumpLocation, nLocationAoE.targetloc) <= nRadius then
                    if (nLocationAoE.count >= 3) then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.05 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if J.GetDistance(vJumpLocation, nLocationAoE.targetloc) <= nRadius then
                    if (nLocationAoE.count >= 3) then
                        return BOT_ACTION_DESIRE_HIGH
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
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
            and GetUnitToLocationDistance(creep, vJumpLocation) <= nRadius
			and not J.IsOtherAllysTarget(creep)
			then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 500, 0, 0)

                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius * 0.8, 0, 0)
                if nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and GetUnitToLocationDistance(botTarget, vJumpLocation) <= nRadius
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and GetUnitToLocationDistance(botTarget, vJumpLocation) <= nRadius
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRollUp()
    if not J.CanCastAbility(RollUp) then
        return BOT_ACTION_DESIRE_NONE
    end

    if not bot:IsMagicImmune() then
        if J.IsStunProjectileIncoming(bot, 400)
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 600))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not bot:IsFacingLocation(botTarget:GetLocation(), 90)
        and bot:HasModifier('modifier_pangolier_gyroshell')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEndRollUp()
    if not J.CanCastAbility(EndRollUp)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot, 1200) then
        if  J.IsValidHero(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and bot:HasModifier('modifier_pangolier_gyroshell')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRollingThunder()
    if not J.CanCastAbility(RollingThunder)
    or bot:IsRooted()
    or bot:HasModifier('modifier_bloodseeker_rupture')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			then
                if #nEnemyHeroes > #nAllyHeroes or J.IsChasingTarget(enemyHero, bot) then
                    return BOT_ACTION_DESIRE_HIGH
                end
			end
		end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEndRollingThunder()
    if not J.CanCastAbility(EndRollingThunder) then
        return BOT_ACTION_DESIRE_NONE
    end

    if #nEnemyHeroes == 0 and not bot:WasRecentlyDamagedByAnyHero(6.0) then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

return X