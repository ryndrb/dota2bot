local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_venomancer'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_lotus_orb", "item_heavens_halberd"}
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
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,3,6,3,3,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_gauntlets",
                "item_faerie_fire",
            
                "item_bottle",
                "item_magic_wand",
                "item_bracer",
                "item_power_treads",
                "item_dragon_lance",
                "item_witch_blade",
                "item_manta",--
                "item_hurricane_pike",--
                "item_ultimate_scepter",
                "item_devastator",--
                "item_black_king_bar",--
                "item_skadi",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_manta",
                "item_bracer", "item_ultimate_scepter",
                "item_bottle", "item_black_king_bar",
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
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_force_staff",
                "item_solar_crest",--
                "item_ancient_janggo",
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_boots_of_bearing",--
                "item_lotus_orb",--
                "item_sheepstick",--
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_hurricane_pike",--
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
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_force_staff",
                "item_solar_crest",--
                "item_mekansm",
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_guardian_greaves",--
                "item_lotus_orb",--
                "item_sheepstick",--
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_hurricane_pike",--
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

local VenomousGale      = bot:GetAbilityByName('venomancer_venomous_gale')
-- local PoisonSting       = bot:GetAbilityByName('venomancer_poison_sting')
local PlagueWard        = bot:GetAbilityByName('venomancer_plague_ward')
-- local LatentToxicity    = bot:GetAbilityByName('venomancer_latent_poison')
-- local PoisonNova        = bot:GetAbilityByName('venomancer_poison_nova')
local NoxiousPlague     = bot:GetAbilityByName('venomancer_noxious_plague')

local VenomousGaleDesire, VenomousGaleLocation
local PlagueWardDesire, PlagueWardLocation, bTargetAlly
-- local LatentToxicityDesire, LatentToxicityTarget
local NoxiousPlagueDesire, NoxiousPlagueTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    VenomousGale      = bot:GetAbilityByName('venomancer_venomous_gale')
    PlagueWard        = bot:GetAbilityByName('venomancer_plague_ward')
    NoxiousPlague     = bot:GetAbilityByName('venomancer_noxious_plague')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    NoxiousPlagueDesire, NoxiousPlagueTarget = X.ConsiderNoxiousPlague()
    if NoxiousPlagueDesire > 0 then
        bot:Action_UseAbilityOnEntity(NoxiousPlague, NoxiousPlagueTarget)
        return
    end

    -- LatentToxicityDesire, LatentToxicityTarget = X.ConsiderLatentToxicity()
    -- if LatentToxicityDesire > 0
    -- then
    --     bot:Action_UseAbilityOnEntity(LatentToxicity, LatentToxicityTarget)
    --     return
    -- end

    VenomousGaleDesire, VenomousGaleLocation = X.ConsiderVenomousGale()
    if VenomousGaleDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(VenomousGale, VenomousGaleLocation)
        return
    end

    PlagueWardDesire, PlagueWardLocation, bTargetAlly = X.ConsiderPlagueWard()
    if PlagueWardDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if bTargetAlly then
            bot:ActionQueue_UseAbilityOnEntity(PlagueWard, PlagueWardLocation)
        else
            bot:ActionQueue_UseAbilityOnLocation(PlagueWard, PlagueWardLocation)
        end
        return
    end
end

function X.ConsiderVenomousGale()
    if not J.CanCastAbility(VenomousGale) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, VenomousGale:GetCastRange())
	local nRadius = VenomousGale:GetSpecialValueInt('radius')
    local nManaCost = VenomousGale:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PlagueWard, NoxiousPlague})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
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

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPlagueWard()
    if not J.CanCastAbility(PlagueWard) then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

    local nCastRange = J.GetProperCastRange(false, bot, PlagueWard:GetCastRange())
    local nManaCost = PlagueWard:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {VenomousGale, NoxiousPlague})

    if fManaAfter < fManaThreshold1 then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

    local bCanTargetAlly = J.CheckBitfieldFlag(PlagueWard:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                return BOT_ACTION_DESIRE_HIGH, bot, true
            else
                local nEnemyTower = botTarget:GetNearbyTowers(700, false)
                if nEnemyTower ~= nil and #nEnemyTower == 0 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), false
                end
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange - 100)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if (bot:WasRecentlyDamagedByHero(enemyHero, 3.0))
                or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
                then
                    if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                        return BOT_ACTION_DESIRE_HIGH, bot, true
                    else
                        return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2, false
                    end
                end
            end
        end
	end

    if bCanTargetAlly and fManaAfter > fManaThreshold1 + 0.15 then
        for _, allyHero in pairs(nAllyHeroes) do
            if J.IsValidHero(allyHero)
            and allyHero ~= bot
            and J.IsInRange(bot, allyHero, nCastRange)
            and not allyHero:HasModifier('modifier_venomancer_ward_counter')
            and not allyHero:IsIllusion()
            then
                local allyHeroTarget = J.GetProperTarget(allyHero)

                if J.IsGoingOnSomeone(allyHero) then
                    if  J.IsValidHero(allyHeroTarget)
                    and J.CanBeAttacked(allyHeroTarget)
                    and J.IsInRange(allyHero, allyHeroTarget, 800)
                    and not J.IsSuspiciousIllusion(allyHeroTarget)
                    and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero, true
                    end
                end

                if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                    for _, enemyHero in pairs(nEnemyHeroes) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and J.IsInRange(allyHero, enemyHero, 600)
                        and not J.IsSuspiciousIllusion(enemyHero)
                        then
                            if (allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0))
                            or (allyHero:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
                            then
                                return BOT_ACTION_DESIRE_HIGH, allyHero, true
                            end
                        end
                    end
                end

                if J.IsPushing(allyHero)
                or J.IsDefending(allyHero)
                or J.IsFarming(allyHero)
                or (J.IsDoingRoshan(allyHero) and bAttacking)
                or (J.IsDoingTormentor(allyHero) and bAttacking)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero, true
                end
            end
        end
    end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

    if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 1 then
        for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, 500, 0, 0)
                if (nLocationAoE.count >= 4) then
                    if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                        return BOT_ACTION_DESIRE_HIGH, bot, true
                    else
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    end
                end
            end
        end

        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_backdoor_protection')
        and not botTarget:HasModifier('modifier_backdoor_protection_active')
        and not botTarget:HasModifier('modifier_backdoor_protection_in_base')
        then
            if bCanTargetAlly then
                return BOT_ACTION_DESIRE_HIGH, bot, true
            else
                local nLocationAoE = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, 500, 0, 0)
                if nLocationAoE.count <= 1 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation() + RandomVector(150), false
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, 500, 0, 0)
                if (nLocationAoE.count >= 4) then
                    if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                        return BOT_ACTION_DESIRE_HIGH, bot, true
                    else
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
                    end
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking then
        for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, 500, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 700)
                then
                    if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                        return BOT_ACTION_DESIRE_HIGH, bot, true
                    else
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, false
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
        then
            if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                return BOT_ACTION_DESIRE_HIGH, bot, true
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()+ RandomVector(150), false
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        then
            if bCanTargetAlly and not bot:HasModifier('modifier_venomancer_ward_counter') then
                return BOT_ACTION_DESIRE_HIGH, bot, true
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation() + RandomVector(150), false
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderNoxiousPlague()
    if not J.CanCastAbility(NoxiousPlague) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, NoxiousPlague:GetCastRange())

    if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_venomancer_latent_poison')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 800)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 800)
                if not (#nInRangeAlly >= #nInRangeEnemy + 1) then
                    local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                    if enemyHeroDamage > hTargetScore then
                        hTarget = enemyHero
                        hTargetScore = enemyHeroDamage
                    end
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

-- function X.ConsiderLatentToxicity()
--     if not LatentToxicity:IsTrained()
--     or not LatentToxicity:IsFullyCastable()
--     then
--         return BOT_ACTION_DESIRE_NONE, nil
--     end

--     local nCastRange = J.GetProperCastRange(false, bot, LatentToxicity:GetCastRange())
--     local nDamagePer = LatentToxicity:GetSpecialValueInt('duration_damage')
--     local nDuration = LatentToxicity:GetSpecialValueInt('duration')

--     local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--     for _, enemyHero in pairs(nEnemyHeroes)
--     do
--         if  J.IsValidHero(enemyHero)
--         and J.CanCastOnNonMagicImmune(enemyHero)
--         and J.CanCastOnTargetAdvanced(enemyHero)
--         and (J.CanKillTarget(enemyHero, nDamagePer * nDuration, DAMAGE_TYPE_MAGICAL))
--         and not J.IsSuspiciousIllusion(enemyHero)
--         and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
--         and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
--         and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--         and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
--         and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
--         then
--             return BOT_ACTION_DESIRE_HIGH
--         end
--     end

--     if J.IsGoingOnSomeone(bot)
-- 	then
--         local target = nil
--         local dmg = 0
--         local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

--         for _, enemyHero in pairs(nInRangeEnemy)
--         do
--             if  J.IsValidHero(enemyHero)
--             and J.CanCastOnNonMagicImmune(enemyHero)
--             and J.CanCastOnTargetAdvanced(enemyHero)
--             and not J.IsSuspiciousIllusion(enemyHero)
--             and not J.IsDisabled(enemyHero)
--             and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
--             and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
--             and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not enemyHero:HasModifier('modifier_venomancer_noxious_plague_primary')
--             then
--                 local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                 local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, 5, DAMAGE_TYPE_ALL)

--                 if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                 and #nInRangeAlly >= #nTargetInRangeAlly
--                 and dmg < currDmg
--                 then
--                     dmg = currDmg
--                     target = enemyHero
--                 end
--             end
--         end

--         if target ~= nil
--         then
--             return BOT_ACTION_DESIRE_HIGH, target
--         end
-- 	end

--     if J.IsDoingRoshan(bot)
--     then
--         if  J.IsRoshan(botTarget)
--         and J.CanCastOnNonMagicImmune(botTarget)
--         and J.CanCastOnTargetAdvanced(botTarget)
--         and J.IsInRange(bot, botTarget, 500)
--         and J.IsAttacking(bot)
--         then
--             return BOT_ACTION_DESIRE_HIGH, botTarget
--         end
--     end

--     return BOT_ACTION_DESIRE_NONE, nil
-- end

return X