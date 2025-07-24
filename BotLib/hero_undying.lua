local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_undying'
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
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_branches",
                "item_magic_stick",
                "item_double_gauntlets",
            
                "item_magic_wand",
                "item_phase_boots",
                "item_soul_ring",
                "item_blade_mail",
                "item_crimson_guard",--
                "item_echo_sabre",
                "item_ultimate_scepter",
                "item_sange_and_yasha",--
                "item_harpoon",--
                "item_heart",--
                "item_ultimate_scepter_2",
                "item_sheepstick",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
                "item_soul_ring", "item_sange_and_yasha",
                "item_blade_mail", "item_sheepstick",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_ancient_janggo",
                "item_force_staff",--
                "item_boots_of_bearing",--
                "item_blink",
                "item_lotus_orb",--
                "item_heart",--
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_aghanims_shard",
                "item_overwhelming_blink",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
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
                    ['t10'] = {0, 10},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_mekansm",
                "item_force_staff",--
                "item_guardian_greaves",--
                "item_blink",
                "item_lotus_orb",--
                "item_heart",--
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_aghanims_shard",
                "item_overwhelming_blink",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
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

local Decay         = bot:GetAbilityByName('undying_decay')
local SoulRip       = bot:GetAbilityByName('undying_soul_rip')
local Tombstone     = bot:GetAbilityByName('undying_tombstone')
local FleshGolem    = bot:GetAbilityByName('undying_flesh_golem')

local DecayDesire, DecayLocation
local SoulRipDesire, SoulRipTarget
local TombstoneDesire, TombstoneLocation
local FleshGolemDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    Decay         = bot:GetAbilityByName('undying_decay')
    SoulRip       = bot:GetAbilityByName('undying_soul_rip')
    Tombstone     = bot:GetAbilityByName('undying_tombstone')
    FleshGolem    = bot:GetAbilityByName('undying_flesh_golem')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    FleshGolemDesire = X.ConsiderFleshGolem()
    if FleshGolemDesire > 0 then
        bot:Action_UseAbility(FleshGolem)
        return
    end

    TombstoneDesire, TombstoneLocation = X.ConsiderTombstone()
    if TombstoneDesire > 0 then
        bot:Action_UseAbilityOnLocation(Tombstone, TombstoneLocation)
        return
    end

    DecayDesire, DecayLocation = X.ConsiderDecay()
    if DecayDesire > 0 then
        bot:Action_UseAbilityOnLocation(Decay, DecayLocation)
        return
    end

    SoulRipDesire, SoulRipTarget = X.ConsiderSoulRip()
    if SoulRipDesire > 0 then
        bot:Action_UseAbilityOnEntity(SoulRip, SoulRipTarget)
        return
    end
end

function X.ConsiderDecay()
    if not J.CanCastAbility(Decay) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, Decay:GetCastRange())
    local nRadius = Decay:GetSpecialValueInt('radius')
	local nDamage = Decay:GetSpecialValueInt('decay_damage')
    local nAbilityLevel = Decay:GetLevel()
    local nManaCost = Decay:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Decay, SoulRip, Tombstone, FleshGolem})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SoulRip, Tombstone, FleshGolem})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Tombstone, FleshGolem})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, 1.0)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            if J.IsInRange(bot, enemyHero, nCastRange) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            else
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange)
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
        then
            local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and #nEnemyHeroes <= 1 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold3 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage * 2)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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
        and fManaAfter > fManaThreshold1
        and nAbilityLevel >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and nAbilityLevel >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if fManaAfter > fManaThreshold3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage * 2)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSoulRip()
    if not J.CanCastAbility(SoulRip) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SoulRip:GetCastRange())
	local nRadius = SoulRip:GetSpecialValueInt('radius')
    local nDamage = SoulRip:GetSpecialValueInt('damage_per_unit')
    local nManaCost = SoulRip:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Decay, SoulRip, Tombstone, FleshGolem})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Decay, Tombstone, FleshGolem})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Tombstone, FleshGolem})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            local damage = nDamage * (Min(10, 1 + X.GetAllHeroCreepNearbyCount(enemyHero:GetLocation(), nRadius)))

            local bAllyHeroCanDie = false
            local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), nRadius)
            for _, allyHero in pairs(nInRangeAlly) do
                if J.IsValidHero(allyHero) and allyHero:GetHealth() <= damage*2 then
                    bAllyHeroCanDie = true
                    break
                end
            end

            if not bAllyHeroCanDie and J.CanKillTarget(enemyHero, damage, DAMAGE_TYPE_MAGICAL) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		local targetAlly = nil
		local targetAllyHealth = 0
		for _, allyHero in pairs(nAllyHeroes) do
			if  J.IsValidHero(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not allyHero:HasModifier('modifier_ice_blast')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not string.find(allyHero:GetUnitName(), 'medusa')
            and J.GetHP(allyHero) < 0.6
			then
                local allyHeroHealth = allyHero:GetHealth()
                if targetAllyHealth < allyHeroHealth then
                    targetAlly = allyHero
                    targetAllyHealth = allyHeroHealth
                end
			end
		end

		if targetAlly ~= nil then
            local unitCount = X.GetAllHeroCreepNearbyCount(targetAlly:GetLocation(), nRadius)
            local totalHeal = nDamage * (Min(10, 1 + unitCount))

            local bAllyHeroCanDie = false
            local nInRangeAlly = J.GetAlliesNearLoc(targetAlly:GetLocation(), nRadius)
            for _, allyHero in pairs(nInRangeAlly) do
                if targetAlly ~= allyHero and J.IsValidHero(allyHero) and allyHero:GetHealth() <= totalHeal*2 then
                    bAllyHeroCanDie = true
                    break
                end
            end

            if not bAllyHeroCanDie and ((totalHeal / targetAlly:GetMaxHealth()) >= 0.10) or (J.IsInTeamFight(bot, 1200) and unitCount >= 4) then
                return BOT_ACTION_DESIRE_HIGH, targetAlly
            end
		end

        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and fManaAfter > fManaThreshold3
        then
            local unitCount = X.GetAllHeroCreepNearbyCount(botTarget:GetLocation(), nRadius)
            if unitCount >= 5 then
                local damage = nDamage * (Min(10, 1 + unitCount))

                local bAllyHeroCanDie = false
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), nRadius)
                for _, allyHero in pairs(nInRangeAlly) do
                    if J.IsValidHero(allyHero) and allyHero:GetHealth() <= damage*2 then
                        bAllyHeroCanDie = true
                        break
                    end
                end

                if not bAllyHeroCanDie and J.GetHP(botTarget) < 0.5 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            and botHP < 0.8
            then
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
                if J.IsChasingTarget(enemyHero, bot) or (#nInRangeEnemy > #nInRangeAlly and botHP < 0.6) then
                    local unitCount = X.GetAllHeroCreepNearbyCount(bot:GetLocation(), nRadius)
                    local totalHeal = nDamage * (Min(10, 1 + unitCount))

                    local bAllyHeroCanDie = false
                    for _, allyHero in pairs(nInRangeAlly) do
                        if bot ~= allyHero and J.IsValidHero(allyHero) and allyHero:GetHealth() <= totalHeal*2 then
                            bAllyHeroCanDie = true
                            break
                        end
                    end

                    if not bAllyHeroCanDie then
                        return BOT_ACTION_DESIRE_HIGH, bot
                    end
                end
            end
        end
	end

    if botHP < 0.5 and bot:DistanceFromFountain() > 1200 and fManaAfter > fManaThreshold2 then
        local unitCount = X.GetAllHeroCreepNearbyCount(bot:GetLocation(), nRadius)
        local totalHeal = nDamage * (Min(10, 1 + unitCount))
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)
        local bAllyHeroCanDie = false
        for _, allyHero in pairs(nInRangeAlly) do
            if bot ~= allyHero and J.IsValidHero(allyHero) and allyHero:GetHealth() <= totalHeal*2 then
                bAllyHeroCanDie = true
                break
            end
        end

        if not bAllyHeroCanDie and ((totalHeal / bot:GetMaxHealth()) >= 0.12) then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if (J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)) then
        if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold3
        then
            local targetAlly = nil
            local targetAllyHealth = 0
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and not J.IsSuspiciousIllusion(allyHero)
                and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                and not allyHero:HasModifier('modifier_ice_blast')
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not string.find(allyHero:GetUnitName(), 'medusa')
                and J.GetHP(allyHero) < 0.5
                then
                    local allyHeroHealth = allyHero:GetHealth()
                    if targetAllyHealth < allyHeroHealth then
                        targetAlly = allyHero
                        targetAllyHealth = allyHeroHealth
                    end
                end
            end

            if targetAlly ~= nil then
                local unitCount = X.GetAllHeroCreepNearbyCount(targetAlly:GetLocation(), nRadius)
                local totalHeal = nDamage * (Min(10, 1 + unitCount))

                local bAllyHeroCanDie = false
                local nInRangeAlly = J.GetAlliesNearLoc(targetAlly:GetLocation(), nRadius)
                for _, allyHero in pairs(nInRangeAlly) do
                    if targetAlly ~= allyHero and J.IsValidHero(allyHero) and allyHero:GetHealth() <= totalHeal then
                        bAllyHeroCanDie = true
                        break
                    end
                end

                if not bAllyHeroCanDie and ((totalHeal / targetAlly:GetMaxHealth()) >= 0.10) then
                    return BOT_ACTION_DESIRE_HIGH, targetAlly
                end
            end
        end
	end

    -- if J.IsGoingOnSomeone(bot) and fManaAfter > 0.3 then
    --     local unitList = GetUnitList(UNIT_LIST_ALLIES)
    --     for _, unit in ipairs(unitList) do
    --         if J.IsValid(unit) and string.find(unit:GetUnitName(), 'tombstone') then
    --             local unitCount = X.GetAllHeroCreepNearbyCount(unit:GetLocation(), nRadius)
    --             local totalHeal = nDamage * (Min(10, 1 + unitCount))

    --             local bAllyHeroCanDie = false
    --             local nInRangeAlly = J.GetAlliesNearLoc(unit:GetLocation(), nRadius)
    --             for _, allyHero in pairs(nInRangeAlly) do
    --                 if J.IsValidHero(allyHero) and allyHero:GetHealth() <= totalHeal then
    --                     bAllyHeroCanDie = true
    --                     break
    --                 end
    --             end

    --             if not bAllyHeroCanDie then
    --                 return BOT_ACTION_DESIRE_HIGH, unit
    --             end
    --         end
    --     end
    -- end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTombstone()
    if not J.CanCastAbility(Tombstone) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Tombstone:GetCastRange())
    local nRadius = Tombstone:GetSpecialValueInt('radius')

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFleshGolem()
    if not J.CanCastAbility(FleshGolem) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.GetAllHeroCreepNearbyCount(vLocation, nRadius)
    local nLocationAoE_allyHeroes = bot:FindAoELocation(false, true, vLocation, 0, nRadius, 0, 0)
    local nLocationAoE_allyCreeps = bot:FindAoELocation(false, false, vLocation, 0, nRadius, 0, 0)
    local nLocationAoE_enemyHeroes = bot:FindAoELocation(true, true, vLocation, 0, nRadius, 0, 0)
    local nLocationAoE_enemyCreeps = bot:FindAoELocation(true, false, vLocation, 0, nRadius, 0, 0)
    return nLocationAoE_allyHeroes.count + nLocationAoE_allyCreeps.count + nLocationAoE_enemyHeroes.count + nLocationAoE_enemyCreeps.count
end

return X