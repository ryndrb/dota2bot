local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_ancient_apparition'
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
                [2] = {3,2,3,1,3,6,3,2,1,2,6,1,2,1,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_tango",
				"item_double_circlet",
                "item_faerie_fire",
	
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_double_null_talisman",
				"item_witch_blade",
                "item_force_staff",
				"item_ultimate_scepter",
				"item_devastator",--
				"item_black_king_bar",--
                "item_aghanims_shard",
				"item_hurricane_pike",--
				"item_bloodthorn",--
                "item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_force_staff",
				"item_null_talisman", "item_ultimate_scepter",
                "item_null_talisman", "item_black_king_bar",
				"item_bottle", "item_bloodthorn",
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
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {3,1,2,2,2,6,2,1,1,1,6,3,3,3,6},
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
                "item_rod_of_atos",
                "item_ancient_janggo",
                "item_force_staff",
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_sheepstick",--
				"item_wind_waker",--
				"item_gungir",--
                "item_hurricane_pike",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_wind_waker",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,1,2,2,2,6,2,1,1,1,6,3,3,3,6},
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
                "item_rod_of_atos",
                "item_mekansm",
                "item_force_staff",
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_sheepstick",--
				"item_wind_waker",--
				"item_gungir",--
                "item_hurricane_pike",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_wind_waker",
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

function X.MinionThink( hMinionUnit )
	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end
end

end

local ColdFeet          = bot:GetAbilityByName('ancient_apparition_cold_feet')
local IceVortex         = bot:GetAbilityByName('ancient_apparition_ice_vortex')
local ChillingTouch     = bot:GetAbilityByName('ancient_apparition_chilling_touch')
local IceBlast          = bot:GetAbilityByName('ancient_apparition_ice_blast')
local IceBlastRelease   = bot:GetAbilityByName('ancient_apparition_ice_blast_release')

local ColdFeetDesire, ColdFeetTarget
local IceVortexDesire, IceVortextLocation
local ChillingTouchDesire, ChillingTouchTarget
local IceBlastDesire, IceBlastLocation
local IceBlastReleaseDesire

local iceblast = { sourceLoc = nil, targetLoc = nil }

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    ColdFeet          = bot:GetAbilityByName('ancient_apparition_cold_feet')
    IceVortex         = bot:GetAbilityByName('ancient_apparition_ice_vortex')
    ChillingTouch     = bot:GetAbilityByName('ancient_apparition_chilling_touch')
    IceBlast          = bot:GetAbilityByName('ancient_apparition_ice_blast')
    IceBlastRelease   = bot:GetAbilityByName('ancient_apparition_ice_blast_release')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    IceBlastReleaseDesire = X.ConsiderIceBlastRelease()
    if IceBlastReleaseDesire > 0 then
        bot:Action_UseAbility(IceBlastRelease)
        return
    end

    IceBlastDesire, IceBlastLocation = X.ConsiderIceBlast()
    if IceBlastDesire > 0 then
        iceblast.sourceLoc = bot:GetLocation()
        iceblast.targetLoc = IceBlastLocation
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(IceBlast, IceBlastLocation)
        return
    end

    IceVortexDesire, IceVortextLocation = X.ConsiderIceVortex()
    if IceVortexDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(IceVortex, IceVortextLocation)
        return
    end

    ColdFeetDesire, ColdFeetTarget = X.ConsiderColdFeet()
    if ColdFeetDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        if J.CheckBitfieldFlag(ColdFeet:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) then
            bot:ActionQueue_UseAbilityOnEntity(ColdFeet, ColdFeetTarget)
            return
        else
            if ColdFeetTarget then
                if (IceBlast ~= nil and IceBlast:IsTrained())
                or (IceBlastRelease ~= nil and IceBlastRelease:IsTrained())
                then
                    local nRadius = 200 + (IceBlast:GetLevel() - 1) * 150
                    local nLocationAoE = bot:FindAoELocation(true, true, ColdFeetTarget:GetLocation(), 0, nRadius, 0, 0)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
                    if #nInRangeEnemy >= 2 then
                        bot:ActionQueue_UseAbilityOnLocation(ColdFeet, nLocationAoE.targetloc)
                        return
                    end
                end

                bot:ActionQueue_UseAbilityOnLocation(ColdFeet, ColdFeetTarget:GetLocation())
                return
            end
        end
    end

    ChillingTouchDesire, ChillingTouchTarget = X.ConsiderChillingTouch()
    if ChillingTouchDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ChillingTouch, ChillingTouchTarget)
        return
    end
end

function X.ConsiderColdFeet()
	if not J.CanCastAbility(ColdFeet) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, ColdFeet:GetCastRange())
    local nManaCost = ColdFeet:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IceVortex, IceBlast})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ColdFeet, IceVortex, IceBlast})

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_cold_feet')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_cold_feet')
            and not enemyHero:HasModifier('modifier_chilling_touch_slow')
            and not enemyHero:HasModifier('modifier_ice_vortex')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            and bot ~= allyHero
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_legion_commander_duel')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not enemyHero:HasModifier('modifier_cold_feet')
                    and not enemyHero:HasModifier('modifier_chilling_touch_slow')
                    and not enemyHero:HasModifier('modifier_ice_vortex')
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsDisabled(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        and not botTarget:HasModifier('modifier_cold_feet')
        and not botTarget:HasModifier('modifier_ice_vortex')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        and not botTarget:HasModifier('modifier_cold_feet')
        and not botTarget:HasModifier('modifier_ice_vortex')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderIceVortex()
	if not J.CanCastAbility(IceVortex) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, IceVortex:GetCastRange())
    local nCastPoint = IceVortex:GetCastPoint()
    local nRadius = IceVortex:GetSpecialValueInt('radius')
    local nManaCost = IceVortex:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ColdFeet, IceBlast})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ColdFeet, IceVortex, IceBlast})

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_ice_vortex')
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
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

function X.ConsiderChillingTouch()
	if not J.CanCastAbility(ChillingTouch) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = ChillingTouch:GetCastRange() + ChillingTouch:GetSpecialValueInt('attack_range_bonus')
    local nCastPoint = ChillingTouch:GetCastPoint()
    local nDamage = ChillingTouch:GetSpecialValueInt('damage')
    local nManaCost = ChillingTouch:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ColdFeet, IceVortex, IceBlast})

    local nEnemyCreeps = bot:GetNearbyLaneCreeps(Min(nCastPoint, 1600), true)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, 1 + nCastPoint)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
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
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, 350)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_cold_feet')
            and not enemyHero:HasModifier('modifier_chilling_touch_slow')
            and not enemyHero:HasModifier('modifier_ice_vortex')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            and bot ~= allyHero
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_legion_commander_duel')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not enemyHero:HasModifier('modifier_cold_feet')
                    and not enemyHero:HasModifier('modifier_chilling_touch_slow')
                    and not enemyHero:HasModifier('modifier_ice_vortex')
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end

        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeEnemy == 0 and fManaAfter > fManaThreshold1 then
            for _, creep in pairs(nEnemyCreeps) do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
                and not J.IsOtherAllysTarget(creep)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                    if J.IsCore(bot)
                    or not J.IsThereCoreInLocation(creep:GetLocation(), 800)
                    or not J.IsOtherAllysTarget(creep)
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
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

local nRadius = 0
function X.ConsiderIceBlast()
	if not J.CanCastAbility(IceBlast) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nMinRadius = IceBlast:GetSpecialValueInt('radius_min')
    local nGrowSpeed = IceBlast:GetSpecialValueInt('radius_grow')
    local nMaxRadius = IceBlast:GetSpecialValueInt('radius_max')
    local nSpeed = IceBlast:GetSpecialValueInt('speed')
    local nShatterThreshold = IceBlast:GetSpecialValueInt('kill_pct')

    local vTeamFightLocation = J.GetTeamFightLocation(bot)

    if J.IsInTeamFight(bot, 1600) then
        if vTeamFightLocation ~= nil then
            local dist = GetUnitToLocationDistance(bot, vTeamFightLocation)
            nRadius = math.min(nMinRadius + ((dist / nSpeed) * nGrowSpeed), nMaxRadius)
            local nLocationAoE = bot:FindAoELocation(true, true, vTeamFightLocation, 0, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if #nInRangeEnemy >= 2 then
                local count = 0
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
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

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
        then
            if not J.IsChasingTarget(bot, botTarget)
            or J.IsDisabled(botTarget)
            or botTarget:IsRooted()
            or botTarget:GetCurrentMovementSpeed() < 200
            then
                local dist = GetUnitToUnitDistance(bot, botTarget)
                nRadius = math.min(nMinRadius + ((dist / nSpeed) * nGrowSpeed), nMaxRadius)
                local sBotTargetName = botTarget:GetUnitName()
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 800)

                if sBotTargetName == 'npc_dota_hero_alchemist'
                or sBotTargetName == 'npc_dota_hero_bristleback'
                or sBotTargetName == 'npc_dota_hero_dragon_knight'
                or sBotTargetName == 'npc_dota_hero_huskar'
                or sBotTargetName == 'npc_dota_hero_life_stealer'
                or sBotTargetName == 'npc_dota_hero_shredder'
                or sBotTargetName == 'npc_dota_hero_morphling'
                or sBotTargetName == 'npc_dota_hero_leshrac'
                or sBotTargetName == 'npc_dota_hero_necrolyte'
                or sBotTargetName == 'npc_dota_hero_pugna'
                or sBotTargetName == 'npc_dota_hero_abaddon'
                or sBotTargetName == 'npc_dota_hero_death_prophet'
                or (sBotTargetName == 'npc_dota_hero_wisp' and not botTarget:IsBot())
                or botTarget:HasModifier('modifier_item_satanic_unholy')
                or botTarget:HasModifier('modifier_item_bloodstone_active')
                then
                    if (#nInRangeAlly >= 2 and J.IsThereCoreNearby(800))
                    or (J.GetHP(botTarget) < (nShatterThreshold / 100) + 0.15)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                end

                nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
                if  not (#nInRangeAlly >= #nInRangeEnemy + 2)
                and ((#nInRangeAlly >= 2 and J.IsThereCoreNearby(1000)) or (J.GetHP(botTarget) < (nShatterThreshold / 100) + 0.15))
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
        end
    end

    if vTeamFightLocation ~= nil and GetUnitToLocationDistance(bot, vTeamFightLocation) > 1600 then
        local dist = GetUnitToLocationDistance(bot, vTeamFightLocation)
        nRadius = math.min(nMinRadius + ((dist / nSpeed) * nGrowSpeed), nMaxRadius)
        local nInRangeEnemy = J.GetEnemiesNearLoc(vTeamFightLocation, nRadius)

        for _, enemyHero in pairs(nInRangeEnemy) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
            and not enemyHero:HasModifier('modifier_eul_cyclone')
            and not enemyHero:HasModifier('modifier_brewmaster_storm_cyclone')
            then
                if J.IsDisabled(enemyHero)
                or enemyHero:IsRooted()
                or enemyHero:GetCurrentMovementSpeed() < 200
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    local vTormentorLocation = J.GetTormentorLocation(GetTeam())
    if not J.IsDoingTormentor(bot) and IsLocationVisible(vTormentorLocation) and GetUnitToLocationDistance(bot, vTormentorLocation) > 1600 then
        local dist = GetUnitToLocationDistance(bot, vTormentorLocation)
        nRadius = math.min(nMinRadius + ((dist / nSpeed) * nGrowSpeed), nMaxRadius)
        local nInRangeEnemy = J.GetEnemiesNearLoc(vTormentorLocation, nRadius)

        if #nInRangeEnemy > 0 then
            if J.IsValidHero(nInRangeEnemy[1]) and J.IsTormentor(nInRangeEnemy[1]:GetAttackTarget()) then
                return BOT_ACTION_DESIRE_HIGH, vTormentorLocation
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIceBlastRelease()
	if not J.CanCastAbility(IceBlastRelease) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nProjectiles = GetLinearProjectiles()

    for _, p in pairs(nProjectiles) do
		if p ~= nil and p.ability:GetName() == 'ancient_apparition_ice_blast' then
			if J.GetDistance(iceblast.targetLoc, p.location) < nRadius then
				return BOT_ACTION_DESIRE_HIGH
			end

            local dist1 = J.GetDistance(iceblast.sourceLoc, p.location)
            local dist2 = J.GetDistance(iceblast.sourceLoc, iceblast.targetLoc)

            if dist1 > dist2 + 200 then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and GetUnitToLocationDistance(enemyHero, iceblast.targetLoc) <= nRadius
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not enemyHero:HasModifier('modifier_eul_cyclone')
                    and not enemyHero:HasModifier('modifier_brewmaster_storm_cyclone')
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X