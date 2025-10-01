local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_pudge'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb"}
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
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,3,2,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_gauntlets",
            
                "item_bottle",
                "item_magic_wand",
                "item_bracer",
                "item_phase_boots",
                "item_blade_mail",
                "item_ultimate_scepter",
                "item_bloodstone",--
                "item_aghanims_shard",
                "item_kaya_and_sange",--
                "item_shivas_guard",--
                "item_overwhelming_blink",--
                "item_ultimate_scepter_2",
                "item_heart",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_bloodstone",
                "item_bracer", "item_kaya_and_sange",
                "item_bottle", "item_shivas_guard",
                "item_blade_mail", "item_heart",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_ring_of_protection",
            
                "item_boots",
                "item_magic_wand",
                "item_double_bracer",
                "item_phase_boots",
                "item_blade_mail",
                "item_crimson_guard",--
                "item_ultimate_scepter",
                "item_blink",
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_heart",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_sphere",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_ring_of_protection", "item_crimson_guard",
                "item_magic_wand", "item_ultimate_scepter",
                "item_bracer", "item_blink",
                "item_bracer", "item_shivas_guard",
                "item_blade_mail", "item_sphere",
            },
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
                [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_enchanted_mango",
                "item_wind_lace",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_rod_of_atos",
                "item_ancient_janggo",
                "item_blink",
                "item_boots_of_bearing",--
                "item_shivas_guard",--
                "item_lotus_orb",--
                "item_ultimate_scepter",
                "item_overwhelming_blink",--
                "item_aghanims_shard",
                "item_gungir",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_wind_waker",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_lotus_orb",
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
                [1] = {1,2,2,3,1,6,1,1,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_enchanted_mango",
                "item_wind_lace",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_rod_of_atos",
                "item_mekansm",
                "item_blink",
                "item_guardian_greaves",--
                "item_shivas_guard",--
                "item_lotus_orb",--
                "item_ultimate_scepter",
                "item_overwhelming_blink",--
                "item_aghanims_shard",
                "item_gungir",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_wind_waker",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_lotus_orb",
            },
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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local MeatHook   = bot:GetAbilityByName('pudge_meat_hook')
local Rot        = bot:GetAbilityByName('pudge_rot')
local MeatShield = bot:GetAbilityByName('pudge_flesh_heap')
-- local Eject     = bot:GetAbilityByName('pudge_eject')
local Dismember  = bot:GetAbilityByName('pudge_dismember')

local MeatHookDesire, MeatHookLocation
local RotDesire
local MeatShieldDesire
-- local EjectDesire
local DismemberDesire, DismemberTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    MeatHook   = bot:GetAbilityByName('pudge_meat_hook')
    Rot        = bot:GetAbilityByName('pudge_rot')
    MeatShield = bot:GetAbilityByName('pudge_flesh_heap')
    Dismember  = bot:GetAbilityByName('pudge_dismember')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    MeatHookDesire, MeatHookLocation = X.ConsiderMeatHook()
    if MeatHookDesire > 0
    then
        bot:Action_UseAbilityOnLocation(MeatHook, MeatHookLocation)
        return
    end

    RotDesire = X.ConsiderRot()
    if RotDesire > 0
    then
        bot:Action_UseAbility(Rot)
        return
    end

    MeatShieldDesire = X.ConsiderMeatShield()
    if MeatShieldDesire > 0
    then
        bot:Action_UseAbility(MeatShield)
        return
    end

    DismemberDesire, DismemberTarget = X.ConsiderDismember()
    if DismemberDesire > 0
    then
        if J.CanCastAbility(Rot) and Rot:GetToggleState() == false
        and J.CanCastAbility(MeatShield)
        and (MeatShield:GetManaCost() + Dismember:GetManaCost()) < bot:GetMana()
        then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbility(Rot)
            bot:ActionQueue_UseAbility(MeatShield)
            bot:ActionQueue_UseAbilityOnEntity(Dismember, DismemberTarget)
            return
        end

        if botHP > 0.3 and J.CanCastAbility(Rot) and Rot:GetToggleState() == false then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbility(Rot)
            bot:ActionQueue_UseAbilityOnEntity(Dismember, DismemberTarget)
            return
        end

        bot:Action_UseAbilityOnEntity(Dismember, DismemberTarget)
        return
    end

    -- EjectDesire = X.ConsiderEject()
    -- if EjectDesire > 0
    -- then
    --     bot:Action_UseAbility(Eject)
    --     return
    -- end
end

function X.ConsiderMeatHook()
    if not J.CanCastAbility(MeatHook) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, MeatHook:GetCastRange())
    local nCastPoint = MeatHook:GetCastPoint()
	local nRadius = MeatHook:GetSpecialValueInt('hook_width')
	local nSpeed = MeatHook:GetSpecialValueInt('hook_speed')
	local nDamage = MeatHook:GetSpecialValueInt('damage')
    local nManaCost = MeatHook:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {MeatShield, Dismember})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MeatHook, MeatShield, Dismember})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {MeatHook})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if  J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsUnitBetweenMeAndLocation(bot, enemyHero, enemyHero:GetLocation(), nRadius)
            and fManaAfter > fManaThreshold1
            then
                if enemyHero:HasModifier('modifier_teleporting') then
                    if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
                end
            end

            local vLocation = J.GetCorrectLoc(enemyHero, eta)

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, eta)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if  GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                and not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end

            if J.IsLaning(bot) and fManaAfter > fManaThreshold1 then
                local nInRangeTower = bot:GetNearbyTowers(400, false)
                if J.IsValidBuilding(nInRangeTower[1]) then
                    local towerTarget = nInRangeTower[1]:GetAttackTarget()
                    if towerTarget == nil then
                        if  GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                        and not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius)
                        then
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end
            end

            if bot:HasModifier('modifier_fountain_aura_buff') and bot:DistanceFromFountain() < 500 then
                if  GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                and not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                if #nAllyHeroes >= #nEnemyHeroes then
                    local sEnemyHeroName = enemyHero:GetUnitName()
                    if string.find(sEnemyHeroName, 'sniper')
                    or string.find(sEnemyHeroName, 'drow_ranger')
                    or string.find(sEnemyHeroName, 'templar_assassin')
                    or string.find(sEnemyHeroName, 'nevermore')
                    or string.find(sEnemyHeroName, 'viper')
                    or string.find(sEnemyHeroName, 'muerta')
                    or string.find(sEnemyHeroName, 'obsidian_destroyer')
                    or string.find(sEnemyHeroName, 'zuus')
                    or string.find(sEnemyHeroName, 'lina')
                    or string.find(sEnemyHeroName, 'silencer')
                    or string.find(sEnemyHeroName, 'arc_warden')
                    then
                        local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                        local vLocation = J.GetCorrectLoc(enemyHero, eta)
                        if  GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                        and not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius)
                        then
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end
            end
        end

		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if #nAllyHeroes >= #nEnemyHeroes then
                local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                local vLocation = J.GetCorrectLoc(botTarget, eta)
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                and not J.IsUnitBetweenMeAndLocation(bot, botTarget, vLocation, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and (J.IsCore(bot) or not J.IsThereCoreNearby(1200)) and fManaAfter > fManaThreshold3 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and not J.IsRunning(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('range', creep)
            and not J.IsUnitBetweenMeAndLocation(bot, creep, creep:GetLocation(), nRadius)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PURE, eta)
                and J.IsValid(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 600
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
			end
		end
	end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and bot ~= allyHero
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsInRange(bot, allyHero, nCastRange * 0.5)
        and not allyHero:IsIllusion()
        and allyHero:HasModifier('modifier_enigma_black_hole_pull')
        and allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not J.IsUnitBetweenMeAndLocation(bot, allyHero, allyHero:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
        end

        if  J.IsValidHero(allyHero)
        and bot ~= allyHero
        and not allyHero:IsIllusion()
        and (not J.IsRunning(allyHero) or allyHero:GetMovementDirectionStability() > 0.85)
        and J.CanBeAttacked(allyHero)
        and not J.IsInRange(bot, allyHero, nCastRange * 0.5)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and fManaAfter > 0.25
        then
            local vFountain = J.GetTeamFountain()
            local nAllyInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 800)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and GetUnitToLocationDistance(bot, vFountain) < GetUnitToLocationDistance(allyHero, vFountain)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and not J.IsUnitBetweenMeAndLocation(bot, allyHero, allyHero:GetLocation(), nRadius)
            then
                local eta = (GetUnitToUnitDistance(bot, allyHero) / nSpeed) + nCastPoint
                local vLocation = J.GetCorrectLoc(allyHero, eta)
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange
                and not J.IsUnitBetweenMeAndLocation(bot, allyHero, vLocation, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > 0.75
        and fManaAfter > fManaThreshold2
        and not J.IsUnitBetweenMeAndLocation(bot, botTarget, botTarget:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > 0.75
        and fManaAfter > fManaThreshold2
        and not J.IsUnitBetweenMeAndLocation(bot, botTarget, botTarget:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if (fManaAfter > 0.7 or J.IsFarming(bot) and fManaAfter > 0.4) and fManaAfter > fManaThreshold2 then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
        for _, creep in pairs(nNeutralCreeps) do
            if  J.IsValid(creep)
            and not J.IsRunning(creep)
            and J.CanBeAttacked(creep)
            and not J.IsUnitBetweenMeAndLocation(bot, creep, creep:GetLocation(), nRadius)
            and not creep:IsAncientCreep()
            then
                local sCreepName = creep:GetUnitName()
                if sCreepName == 'npc_dota_neutral_satyr_hellcaller'
                or sCreepName == 'npc_dota_neutral_polar_furbolg_ursa_warrior'
                or sCreepName == 'npc_dota_neutral_dark_troll_warlord'
                or sCreepName == 'npc_dota_neutral_centaur_khan'
                or sCreepName == 'npc_dota_neutral_enraged_wildkin'
                or sCreepName == 'npc_dota_neutral_warpine_raider'
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderRot()
    if not J.CanCastAbility(Rot) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = Rot:GetSpecialValueInt('rot_radius')
    local bToggled = Rot:GetToggleState()
    local bFleshHeaped = bot:HasModifier('modifier_pudge_flesh_heap_block')
    local bHeart = J.HasItem(bot, 'item_heart')

    if bFleshHeaped and bToggled then
        local nLocationAoE1 = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
        local nLocationAoE2 = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
        if nLocationAoE1.count > 0 or nLocationAoE2.count > 0 then
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if J.IsGoingOnSomeone(bot) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if #nInRangeEnemy >= 2 then
            if not bToggled and botHP > 0.1 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and botHP < 0.1 then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end

        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        then
            if not bToggled and botHP > 0.15 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled
                and botHP < 0.15
                and J.CanBeAttacked(bot)
                and not bFleshHeaped
                and not bHeart
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            then
                if (#nAllyHeroes < #nEnemyHeroes and enemyHero:GetAttackTarget() == bot) or J.IsChasingTarget(enemyHero, bot) then
                    if not bToggled and botHP > 0.2 then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        if bToggled and botHP < 0.15 and not (bFleshHeaped or bHeart) then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius * 2, true)

    if J.IsPushing(bot) or (J.IsDefending(bot) and #nEnemyHeroes == 0) then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and J.IsInRange(bot, nEnemyCreeps[1], nRadius)
        then
            if not bToggled and botHP > 0.2 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and ((botHP < 0.15 and not (bFleshHeaped or bHeart)) or #nEnemyCreeps == 0) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsFarming(bot) then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and J.IsInRange(bot, nEnemyCreeps[1], nRadius)
        then
            if not bToggled and botHP > 0.2 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and ((botHP < 0.15 and not (bFleshHeaped or bHeart)) or #nEnemyCreeps == 0) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsLaning(bot)
    and (J.IsCore(bot) or not J.IsThereCoreNearby(1200))
    and #nEnemyHeroes == 0
    then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, bot:GetAttackDamage() + 1)
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and J.IsInRange(bot, nEnemyCreeps[1], nRadius)
        and nLocationAoE.count >= 3
        then
            if not bToggled and botHP > 0.5 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and ((botHP < 0.3 and not (bFleshHeaped or bHeart)) or #nEnemyCreeps == 0) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        then
            if not bToggled and botHP > 0.4 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and (botHP < 0.4 and not (bFleshHeaped or bHeart)) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        then
            if not bToggled and botHP > 0.6 then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and (botHP < 0.4 and not (bFleshHeaped or bHeart)) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if bToggled then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMeatShield()
    if not J.CanCastAbility(MeatShield) then
        return BOT_ACTION_DESIRE_NONE
    end

    if botHP < 0.6 and bot:HasModifier('modifier_pudge_rot') then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(2.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 600)
            then
                if (#nAllyHeroes < #nEnemyHeroes and enemyHero:GetAttackTarget() == bot)
                or (botHP < 0.5 and J.IsChasingTarget(enemyHero, bot))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDismember()
    if not J.CanCastAbility(Dismember) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Dismember:GetCastRange())
    local nAttributeStrength = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
    local nSTRMul = Dismember:GetSpecialValueFloat('strength_damage')
    local nDuration = Dismember:GetSpecialValueFloat('AbilityChannelTime')
    local nDamage = Dismember:GetSpecialValueInt('dismember_damage') + (nAttributeStrength * nSTRMul)
    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    local nEnemyTowers = bot:GetNearbyTowers(900, true)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDuration)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if #nAllyHeroes >= #nEnemyHeroes or #nEnemyHeroesTargetingMe <= 2 then
                if not J.CanCastAbility(MeatHook) and enemyHero:HasModifier('modifier_teleporting') and #nAllyHeroes >= 2 then
                    local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed())
                    if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end

                if J.IsInLaningPhase() or #nAllyHeroes <= 1 then
                    if #nEnemyTowers == 0 or not bot:WasRecentlyDamagedByTower(nDuration) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and J.CanCastOnMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_eul_cyclone')
        and not botTarget:HasModifier('modifier_brewmaster_storm_cyclone')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            if #nAllyHeroesTargetingTarget <= 1 then
                if J.GetHP(botTarget) < 0.5 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        local hTarget = J.GetAttackableWeakestUnit(bot, nCastRange + 300, true, true)
		if  J.IsValidTarget(hTarget)
        and J.CanBeAttacked(hTarget)
        and J.CanCastOnMagicImmune(hTarget)
        and J.CanCastOnTargetAdvanced(hTarget)
        and not hTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not hTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not hTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not hTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not hTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and botHP < 0.2
		then
            if (#nEnemyHeroes > #nAllyHeroes and hTarget:GetAttackTarget() == bot) or J.IsChasingTarget(hTarget, bot) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
		end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X