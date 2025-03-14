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

local sUtility = {"item_crimson_guard", "item_lotus_orb"}
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                },
                [2] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
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
            
                "item_bracer",
                "item_bottle",
                "item_magic_wand",
                "item_phase_boots",
                "item_blade_mail",
                "item_ultimate_scepter",
                "item_bloodstone",--
                "item_black_king_bar",--
                "item_shivas_guard",--
                "item_heart",--
                "item_heavens_halberd",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_bloodstone",
                "item_bottle", "item_black_king_bar",
                "item_bracer", "item_shivas_guard",
                "item_blade_mail", "item_heavens_halberd",
            },
        },
    },
    ['pos_3'] = {
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
                [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_ring_of_protection",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_boots",
                "item_phase_boots",
                "item_ultimate_scepter",
                "item_pipe",--
                "item_black_king_bar",--
                sUtilityItem,--
                "item_blink",
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_ring_of_protection", "item_pipe",
                "item_magic_wand", "item_black_king_bar",
                "item_bracer", sUtilityItem,
                "item_bracer", "item_blink",
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
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_force_staff",--
                "item_blink",
                "item_ancient_janggo",
                "item_veil_of_discord",
                "item_boots_of_bearing",--
                "item_heart",--
                "item_shivas_guard",--
                "item_cyclone",
                "item_overwhelming_blink",--
                "item_wind_waker",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ancient_janggo",
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
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_force_staff",--
                "item_blink",
                "item_mekansm",
                "item_veil_of_discord",
                "item_guardian_greaves",--
                "item_heart",--
                "item_shivas_guard",--
                "item_cyclone",
                "item_overwhelming_blink",--
                "item_wind_waker",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_mekansm",
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

local nAllyHeroes, nEnemyHeroes
local botTarget, botHP

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    if bot:GetUnitName() == 'npc_dota_hero_rubick' then
        MeatHook   = bot:GetAbilityByName('pudge_meat_hook')
        Rot        = bot:GetAbilityByName('pudge_rot')
        MeatShield = bot:GetAbilityByName('pudge_flesh_heap')
        Dismember  = bot:GetAbilityByName('pudge_dismember')
    end

    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    botTarget = J.GetProperTarget(bot)
    botHP = J.GetHP(bot)

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
    local nManaAfter = J.GetManaAfter(MeatHook:GetManaCost())

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if enemyHero:IsChanneling() then

                if not J.IsUnitBetweenMeAndLocation(bot, enemyHero, enemyHero:GetLocation(), nRadius) then
                    if enemyHero:HasModifier('modifier_teleporting') then
                        if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                        end
                    else
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                    end
                end
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                local vLocation = J.GetCorrectLoc(enemyHero, eta)
                if not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end

            if J.IsLaning(bot) and nManaAfter> 0.35 then
                local nInRangeTower = bot:GetNearbyTowers(700, false)
                if J.IsValidBuilding(nInRangeTower[1]) then
                    local towerTarget = nInRangeTower[1]:GetAttackTarget()
                    if towerTarget == nil then
                        local vLocation = J.GetCorrectLoc(enemyHero, eta)
                        if not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius) then
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end
            end

            if bot:HasModifier('modifier_fountain_aura_buff') and bot:DistanceFromFountain() < 500 then
                local vLocation = J.GetCorrectLoc(enemyHero, eta)
                if not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
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
                        if not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius) then
                            bot:SetTarget(enemyHero)
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end
            end
        end

		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if #nAllyHeroes >= #nEnemyHeroes then
                local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                local vLocation = J.GetCorrectLoc(botTarget, eta)
                if not J.IsUnitBetweenMeAndLocation(bot, botTarget, vLocation, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
		end
	end

    if J.IsLaning(bot) and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200)) then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and not J.IsRunning(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('range', creep))
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
            and not J.IsUnitBetweenMeAndLocation(bot, creep, creep:GetLocation(), nRadius)
			then
				if J.IsValid(nEnemyHeroes[1])
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
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsInRange(bot, allyHero, 500)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and nManaAfter > 0.25
        then
            local vFountain = J.GetTeamFountain()
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and GetUnitToLocationDistance(bot, vFountain) < GetUnitToLocationDistance(allyHero, vFountain)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and not J.IsUnitBetweenMeAndLocation(bot, allyHero, allyHero:GetLocation(), nRadius)
            then
                local eta = (GetUnitToUnitDistance(bot, allyHero) / nSpeed) + nCastPoint
                local vLocation = J.GetCorrectLoc(allyHero, eta)
                if not J.IsUnitBetweenMeAndLocation(bot, allyHero, vLocation, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and nManaAfter > 0.75
        and not J.IsUnitBetweenMeAndLocation(bot, botTarget, botTarget:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and nManaAfter > 0.75
        and not J.IsUnitBetweenMeAndLocation(bot, botTarget, botTarget:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if (nManaAfter > 0.7 or J.IsFarming(bot) and nManaAfter > 0.4) then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
        for _, creep in pairs(nNeutralCreeps) do
            if  J.IsValid(creep)
            and not J.IsRunning(creep)
            and J.CanBeAttacked(creep)
            and not J.IsUnitBetweenMeAndLocation(bot, creep, creep:GetLocation(), nRadius)
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
    local bAttacking = J.IsAttacking(bot)

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
                and bot:WasRecentlyDamagedByAnyHero(2.0)
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

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            then
                if #nAllyHeroes < #nEnemyHeroes or J.IsChasingTarget(enemyHero, bot) then
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

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius + 150, true)
    if J.IsPushing(bot) or (J.IsDefending(bot) and #nEnemyHeroes == 0) then
        if #nEnemyCreeps >= 1
        and J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        then
            if not bToggled and botHP > 0.2 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and botHP < 0.16 and not (bFleshHeaped or bHeart) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsFarming(bot) then
        if #nEnemyCreeps >= 1
        and J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        then
            if not bToggled and botHP > 0.2 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and ((botHP < 0.2 and not (bFleshHeaped or bHeart)) or #nEnemyCreeps == 0) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsLaning(bot)
    and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
    and #nEnemyHeroes == 0
    then
        if #nEnemyCreeps >= 3
        and J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        then
            if not bToggled and botHP > 0.5 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and ((botHP < 0.35 and not (bFleshHeaped or bHeart)) or #nEnemyCreeps == 0) then
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
            if not bToggled and botHP > 0.4 and bAttacking then
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
            if not bToggled and botHP > 0.6 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH
            else
                if bToggled and (botHP < 0.6 and not (bFleshHeaped or bHeart)) then
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
            and J.IsChasingTarget(enemyHero, bot)
            then
                if #nAllyHeroes < #nEnemyHeroes or botHP < 0.5 then
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

    local nEnemyTowers = bot:GetNearbyTowers(900, true)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDuration)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if J.IsInLaningPhase() then
                if #nEnemyTowers == 0 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            else
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
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
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 900)
            if #nInRangeAlly <= 1 then
                if J.GetHP(botTarget) < 0.6 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        local hTarget = J.GetAttackableWeakestUnit(bot, nCastRange, true, true)
		if  J.IsValidTarget(hTarget)
        and J.CanCastOnMagicImmune(hTarget)
        and J.CanCastOnTargetAdvanced(hTarget)
        and not hTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not hTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not hTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not hTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not hTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if #nEnemyHeroes > #nAllyHeroes and botHP < 0.2 and J.IsChasingTarget(hTarget, bot) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
		end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X