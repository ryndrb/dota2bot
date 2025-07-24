local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_doom_bringer'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_nullifier"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,2,2,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_gauntlets",
            
                "item_magic_wand",
                "item_bracer",
                "item_power_treads",
                "item_radiance",
                "item_black_king_bar",--
                "item_harpoon",--
                "item_assault",--
                "item_aghanims_shard",
                "item_overwhelming_blink",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_harpoon",
                "item_magic_wand", "item_assault",
                "item_bracer", "item_overwhelming_blink",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,2,2,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_gauntlets",
            
                "item_bottle",
                "item_magic_wand",
                "item_bracer",
                "item_phase_boots",
                "item_hand_of_midas",
                "item_blink",
                "item_shivas_guard",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_octarine_core",--
                "item_refresher",--
                "item_arcane_blink",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_blink",
                "item_magic_wand", "item_shivas_guard",
                "item_bracer", "item_black_king_bar",
                "item_bottle", "item_octarine_core",
                "item_hand_of_midas", "item_refresher",
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
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
            
                "item_double_bracer",
                "item_phase_boots",
                "item_magic_wand",
                "item_hand_of_midas",
                "item_shivas_guard",--
                "item_blink",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_aghanims_shard",
                "item_overwhelming_blink",--
                "item_refresher",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_blink",
                "item_bracer", "item_black_king_bar",
                "item_bracer", "item_octarine_core",
                "item_hand_of_midas", "item_refresher",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
            
                "item_double_bracer",
                "item_phase_boots",
                "item_magic_wand",
                "item_hand_of_midas",
                "item_crimson_guard",--
                "item_black_king_bar",--
                "item_blink",
                sUtilityItem,--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_overwhelming_blink",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_bracer", "item_blink",
                "item_bracer", sUtilityItem,
                "item_hand_of_midas", "item_shivas_guard",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local Devour        = bot:GetAbilityByName('doom_bringer_devour')
local ScorchedEarth = bot:GetAbilityByName('doom_bringer_scorched_earth')
local InfernalBlade = bot:GetAbilityByName('doom_bringer_infernal_blade')
local Doom          = bot:GetAbilityByName('doom_bringer_doom')

local DevourAbility1 = bot:GetAbilityByName('doom_bringer_empty1')
local DevourAbility2 = bot:GetAbilityByName('doom_bringer_empty2')

local DevourDesire, DevourTarget
local ScorchedEarthDesire
local InfernalBladeDesire, InfernalBladeTarget
local DoomDesire, DoomTarget

local DevourAbility1Desire, DevourAbility1TargetLocation
local DevourAbility2Desire, DevourAbility2TargetLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Devour        = bot:GetAbilityByName('doom_bringer_devour')
    ScorchedEarth = bot:GetAbilityByName('doom_bringer_scorched_earth')
    InfernalBlade = bot:GetAbilityByName('doom_bringer_infernal_blade')
    Doom          = bot:GetAbilityByName('doom_bringer_doom')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    DoomDesire, DoomTarget = X.ConsiderDoom()
    if DoomDesire > 0 then
        bot:Action_UseAbilityOnEntity(Doom, DoomTarget)
        return
    end

    InfernalBladeDesire, InfernalBladeTarget = X.ConsiderInfernalBlade()
    if InfernalBladeDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(InfernalBlade, InfernalBladeTarget)
        return
    end

    ScorchedEarthDesire = X.ConsiderScorchedEarth()
    if ScorchedEarthDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ScorchedEarth)
        return
    end

    DevourDesire, DevourTarget = X.ConsiderDevour()
    if DevourDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Devour, DevourTarget)
        return
    end
end

function X.ConsiderDevour()
    if not J.CanCastAbility(Devour) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nMaxLevel = Devour:GetSpecialValueInt('creep_level')
    local nManaCost = Devour:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ScorchedEarth, Doom})

    if fManaAfter < fManaThreshold1 then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local hTalent = bot:GetAbilityByName('special_bonus_unique_doom_2')

    local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)
    if not J.IsRetreating(bot) then
        local nEnemyTowers = bot:GetNearbyTowers(1600, true)
        local nCreepTarget = X.GetRangedOrSiegeCreep(nEnemyCreeps, nMaxLevel)

        if J.IsValid(nCreepTarget)
        and not nCreepTarget:IsDominated()
        and not nCreepTarget:HasModifier('modifier_chen_holy_persuasion')
        and not nCreepTarget:HasModifier('modifier_dominated')
        then
            if J.IsLaning(bot)
            and J.IsInLaningPhase()
            and (#nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToUnitDistance(nCreepTarget, nEnemyTowers[1]) > 800))
            then
                return BOT_ACTION_DESIRE_HIGH, nCreepTarget
            end
        end

        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetLevel() <= nMaxLevel
            and not J.IsRoshan(creep)
            and not J.IsTormentor(creep)
            and not creep:IsDominated()
            and not creep:HasModifier('modifier_chen_holy_persuasion')
            and not creep:HasModifier('modifier_dominated')
            then
                local nCreepTeam = creep:GetTeam()

                if  J.IsInLaningPhase()
                and nCreepTeam ~= bot:GetTeam()
                and nCreepTeam ~= TEAM_NEUTRAL
                and (#nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToUnitDistance(creep, nEnemyTowers[1]) > 800))
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nCreepTarget = nil
                if nCreepTeam == TEAM_NEUTRAL then
                    nCreepTarget = J.GetMostHpUnit(nEnemyCreeps)
                end

                if J.IsValid(nCreepTarget) then
                    if string.find(bot:GetUnitName(), 'doom_bringer') and nCreepTarget:IsAncientCreep() and hTalent and hTalent:IsTrained() then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end

                    if not nCreepTarget:IsAncientCreep() then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end
                end

                if not creep:IsAncientCreep() then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderScorchedEarth()
    if not J.CanCastAbility(ScorchedEarth) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ScorchedEarth:GetSpecialValueInt('radius')
    local nManaCost = ScorchedEarth:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {InfernalBlade, Doom})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {InfernalBlade, ScorchedEarth, Doom})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 300)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius + 300)
            and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:IsDisarmed()
            then
				if J.IsChasingTarget(enemyHero, bot) or botHP < 0.5 or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 1 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and fManaAfter > fManaThreshold2
        and bAttacking
        then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and fManaAfter > fManaThreshold1
        and bAttacking
        then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
        if #nInRangeEnemy == 0 and nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and fManaAfter > fManaThreshold1
        and bAttacking
        then
            if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(botTarget) > 0.4
        and fManaAfter > fManaThreshold2
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and fManaAfter > fManaThreshold2
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderInfernalBlade()
    if not J.CanCastAbility(InfernalBlade) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, InfernalBlade:GetCastRange())
    local nBurnDamage = InfernalBlade:GetSpecialValueInt('burn_damage')
    local nDamagePct = InfernalBlade:GetSpecialValueInt('burn_damage_pct') / 100
    local nDuration = InfernalBlade:GetSpecialValueInt('burn_duration')
    local fManaAfter = J.GetManaAfter(InfernalBlade:GetManaCost())

    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, 700)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling() then
                if J.IsInLaningPhase() then
                    if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(enemyHero, nEnemyTowers[1], 700)) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end

            if  J.WillKillTarget(enemyHero, nBurnDamage + enemyHero:GetMaxHealth() * nDamagePct, DAMAGE_TYPE_MAGICAL, nDuration)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if J.IsInLaningPhase() then
                    if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(enemyHero, nEnemyTowers[1], 700)) then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot) or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange + 300, true)

    local hTargetCreep = J.GetMostHpUnit(nEnemyCreeps)
    if  J.IsValid(hTargetCreep)
    and J.CanBeAttacked(hTargetCreep)
    and hTargetCreep:IsCreep()
    and not J.IsOtherAllysTarget(hTargetCreep)
    and not J.CanKillTarget(hTargetCreep, nBurnDamage + hTargetCreep:GetMaxHealth() * nDamagePct * nDuration, DAMAGE_TYPE_MAGICAL)
    and fManaAfter > 0.4
    then
        return BOT_ACTION_DESIRE_HIGH, hTargetCreep
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > 0.3 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
            and J.WillKillTarget(creep, nBurnDamage + creep:GetMaxHealth() * nDamagePct, DAMAGE_TYPE_MAGICAL, nDuration / 2)
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 700
                then
                    if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(creep, nEnemyTowers[1], 700)) then
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
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and fManaAfter > 0.3
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and fManaAfter > 0.3
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDoom()
	if not J.CanCastAbility(Doom) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nDamageDPS = Doom:GetSpecialValueInt('damage')
    local nDuration = Doom:GetSpecialValueInt('duration')

    if J.IsGoingOnSomeone(bot) then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

		local hTarget = nil
		local hTargetDamage = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValid(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
                if hTargetDamage < enemyHeroDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
			end
		end

		if hTarget ~= nil then
            if J.IsEarlyGame() and not J.IsInTeamFight(bot, 1200) then
                if not (#nInRangeAlly >= #nInRangeEnemy + 2) and J.IsAttacking(hTarget) then
                    local nDamage = hTarget:GetActualIncomingDamage(nDamageDPS * nDuration, DAMAGE_TYPE_MAGICAL)
                                  + hTarget:GetActualIncomingDamage(bot:GetAttackDamage() * bot:GetAttackSpeed() * (nDuration / 2), DAMAGE_TYPE_PHYSICAL)
                    if nDamage > (hTarget:GetHealth() + hTarget:GetHealthRegen() * nDuration) then
                        return BOT_ACTION_DESIRE_HIGH, hTarget
                    end
                end
            else
                if J.IsInTeamFight(bot, 1200) then
                    if #nInRangeEnemy >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, hTarget
                    end
                else
                    if not (#nInRangeAlly >= #nInRangeEnemy + 2) and botTarget == hTarget then
                        return BOT_ACTION_DESIRE_HIGH, hTarget
                    end
                end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.GetRangedOrSiegeCreep(nCreeps, lvl)
	for _, creep in pairs(nCreeps)
	do
		if  J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and creep:GetLevel() <= lvl
        and (J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('ranged', creep))
        and not J.IsRoshan(creep)
        and not J.IsTormentor(creep)
		then
			return creep
		end
	end

	return nil
end

return X