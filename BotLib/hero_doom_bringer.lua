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

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
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
                "item_magic_stick",
            
                "item_bottle",
                "item_helm_of_iron_will",
                "item_boots",
                "item_magic_wand",
                "item_phase_boots",
                "item_shivas_guard",--
                "item_blink",
                "item_black_king_bar",--
                "item_octarine_core",--
                "item_travel_boots",
                "item_aghanims_shard",
                "item_overwhelming_blink",--
                "item_refresher",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_bottle",
                "item_magic_wand",
            },
        },
    },
    ['pos_3'] = {
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
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_magic_stick",
                "item_enchanted_mango",
            
                "item_helm_of_iron_will",
                "item_boots",
                "item_magic_wand",
                "item_phase_boots",
                "item_shivas_guard",--
                "item_blink",
                "item_black_king_bar",--
                "item_octarine_core",--
                sUtilityItem,--
                "item_aghanims_shard",
                "item_overwhelming_blink",--
                "item_refresher",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_magic_wand",
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

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    Devour        = bot:GetAbilityByName('doom_bringer_devour')
    ScorchedEarth = bot:GetAbilityByName('doom_bringer_scorched_earth')
    InfernalBlade = bot:GetAbilityByName('doom_bringer_infernal_blade')
    Doom          = bot:GetAbilityByName('doom_bringer_doom')

    botTarget = J.GetProperTarget(bot)

    DoomDesire, DoomTarget = X.ConsiderDoom()
    if DoomDesire > 0
    then
        bot:Action_UseAbilityOnEntity(Doom, DoomTarget)
        return
    end

    InfernalBladeDesire, InfernalBladeTarget = X.ConsiderInfernalBlade()
    if InfernalBladeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(InfernalBlade, InfernalBladeTarget)
        return
    end

    ScorchedEarthDesire = X.ConsiderScorchedEarth()
    if ScorchedEarthDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ScorchedEarth)
        return
    end

    DevourDesire, DevourTarget = X.ConsiderDevour()
    if DevourDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Devour, DevourTarget)
        return
    end
end

function X.ConsiderDevour()
    if not J.CanCastAbility(Devour)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nMaxLevel = Devour:GetSpecialValueInt('creep_level')
    local nCreeps = bot:GetNearbyCreeps(1200, true)

    local talent15left = bot:GetAbilityByName('special_bonus_unique_doom_2')

    if not J.IsRetreating(bot)
    then
        local nEnemyTowers = bot:GetNearbyTowers(1600, true)
        local nCreepTarget = X.GetRangedOrSiegeCreep(nCreeps, nMaxLevel)

        if J.IsValid(nCreepTarget)
        then
            if  J.IsLaning(bot)
            and nEnemyTowers ~= nil
            and (#nEnemyTowers == 0
                or #nEnemyTowers >= 1 and J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToUnitDistance(nCreepTarget, nEnemyTowers[1]) > 700)
            then
                return BOT_ACTION_DESIRE_HIGH, nCreepTarget
            end
        end

        for _, creep in pairs(nCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetLevel() <= nMaxLevel
            and not J.IsRoshan(creep)
            and not J.IsTormentor(creep)
            then
                if  J.IsInLaningPhase()
                and creep:GetTeam() ~= bot:GetTeam()
                and creep:GetTeam() ~= TEAM_NEUTRAL
                and nEnemyTowers ~= nil
                and (#nEnemyTowers == 0
                    or #nEnemyTowers >= 1
                        and J.IsValidBuilding(nEnemyTowers[1])
                        and GetUnitToUnitDistance(creep, nEnemyTowers[1]) > 700)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nCreepTarget = nil
                if creep:GetTeam() == TEAM_NEUTRAL
                then
                    nCreepTarget = J.GetMostHpUnit(nCreeps)
                end

                if nCreepTarget ~= nil and nCreepTarget:CanBeSeen()
                then
                    if string.find(bot:GetUnitName(), 'doom_bringer')
                    and nCreepTarget:IsAncientCreep()
                    and talent15left:IsTrained()
                    then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end

                    if not nCreepTarget:IsAncientCreep()
                    then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end
                end

                if not creep:IsAncientCreep()
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderScorchedEarth()
    if not J.CanCastAbility(ScorchedEarth)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ScorchedEarth:GetSpecialValueInt('radius')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.75
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nRadius + 150)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsFarming(bot)
	then
        if  nCreeps ~= nil
        and J.CanBeAttacked(nCreeps[1])
        and (#nCreeps >= 3 or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
        and J.IsAttacking(bot)
        and J.GetManaAfter(ScorchedEarth:GetManaCost()) > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(bot) > 0.2
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderInfernalBlade()
    if not J.CanCastAbility(InfernalBlade)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, InfernalBlade:GetCastRange())
    local nBurnDamage = InfernalBlade:GetSpecialValueInt('burn_damage')
    local nDamagePct = InfernalBlade:GetSpecialValueInt('burn_damage_pct') / 100
    local nDuration = InfernalBlade:GetSpecialValueInt('burn_duration')

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, 700)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling()
            then
                if J.IsInLaningPhase()
                then
                    if nEnemyTowers ~= nil
                    and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(enemyHero, nEnemyTowers[1], 700))
                    then
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
            and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if J.IsInLaningPhase()
                then
                    if nEnemyTowers ~= nil
                    and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(enemyHero, nEnemyTowers[1], 700))
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot)
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

	if J.IsFarming(bot)
	then
		local nCreeps = bot:GetNearbyCreeps(nCastRange + 150, true)
        local targetCreep = J.GetMostHpUnit(nCreeps)

        if  J.IsValid(targetCreep)
        and J.GetManaAfter(InfernalBlade:GetManaCost()) > 0.35
        and not J.IsOtherAllysTarget(targetCreep)
        then
            return BOT_ACTION_DESIRE_HIGH, targetCreep
        end
	end

    if J.IsLaning(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 75, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nBurnDamage
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep
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

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDoom()
	if not J.CanCastAbility(Doom)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nDuration = Doom:GetSpecialValueInt('duration')

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local dmg = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_doom_bringer_doom')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
                local estDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
                if dmg < estDmg
                then
                    dmg = estDmg
                    target = enemyHero
                end
			end
		end

		if target ~= nil
		then
            if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
            then
                if J.IsInLaningPhase()
                then
                    if  not (#nAllyHeroes >= #nEnemyHeroes + 2)
                    and J.IsAttacking(target)
                    then
                        if target:GetHealth() <= bot:GetEstimatedDamageToTarget(true, target, nDuration, DAMAGE_TYPE_ALL)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    end
                else
                    if #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
                    then
                        if target:GetHealth() <= bot:GetEstimatedDamageToTarget(true, target, nDuration, DAMAGE_TYPE_ALL)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    else
                        if not (#nAllyHeroes >= #nEnemyHeroes + 2)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    end
                end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

-- function X.ConsiderDevourAbility(DevouredAbility)
--     if DevouredAbility:IsPassive()
--     or not DevouredAbility:IsFullyCastable()
--     then
--         return BOT_ACTION_DESIRE_NONE, nil, ''
--     end

--     local nCastRange = 0
--     local nRadius = 0
--     local nDamage = 0

--     -- -- Tornado
--     -- if DevouredAbility:GetName() == 'enraged_wildkin_tornado'
--     -- -- Hurricane
--     -- if DevouredAbility:GetName() == 'enraged_wildkin_hurricane'

--     -- -- Thunder Clap
--     -- if DevouredAbility:GetName() == 'polar_furbolg_ursa_warrior_thunder_clap'

--     -- -- Ogre Smash!
--     -- if DevouredAbility:GetName() == 'ogre_bruiser_ogre_smash'
--     -- -- Ice Armor
--     -- if DevouredAbility:GetName() == 'ogre_magi_frost_armor'

--     -- -- Ensnare
--     -- if DevouredAbility:GetName() == 'dark_troll_warlord_ensnare'
--     -- -- Raise Dead
--     -- if DevouredAbility:GetName() == 'dark_troll_warlord_raise_dead'

--     -- -- Hurl Boulder
--     -- if DevouredAbility:GetName() == 'mud_golem_hurl_boulder'

--     -- -- Slam
--     -- if DevouredAbility:GetName() == 'big_thunder_lizard_slam'
--     -- -- Frenzy
--     -- if DevouredAbility:GetName() == 'big_thunder_lizard_frenzy'

--     -- -- Ice Fire Bomb
--     -- if DevouredAbility:GetName() == 'ice_shaman_incendiary_bomb'

--     -- -- Fireball
--     -- if DevouredAbility:GetName() == 'black_dragon_fireball'

--     -- -- Seed Shot
--     -- if DevouredAbility:GetName() == 'warpine_raider_seed_shot'

--     -- Vex
--     if DevouredAbility:GetName() == 'fel_beast_haunt'
--     then
--         nCastRange = 600

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.CanCastOnTargetAdvanced(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--             then
--                 local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                 local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--                 end
--             end
--         end

--         if  J.IsRetreating(bot)
--         and bot:GetActiveModeDesire() > 0.5
--         then
--             local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--             for _, enemyHero in pairs(nInRangeEnemy)
--             do
--                 if  J.IsValidHero(enemyHero)
--                 and J.CanCastOnNonMagicImmune(enemyHero)
--                 and J.CanCastOnTargetAdvanced(enemyHero)
--                 and J.IsChasingTarget(enemyHero, bot)
--                 and not J.IsSuspiciousIllusion(enemyHero)
--                 and not J.IsDisabled(enemyHero)
--                 and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--                 and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--                 then
--                     local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                     local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                     if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                     and ((#nTargetInRangeAlly > #nInRangeAlly)
--                         or bot:WasRecentlyDamagedByAnyHero(2))
--                     then
--                         return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                     end
--                 end
--             end
--         end
--     end

--     -- Take Off
--     if DevouredAbility:GetName() == 'harpy_scout_take_off'
--     then
--         if J.IsStuck(bot)
--         then
--             if DevouredAbility:GetToggleState() == false
--             then
--                 return BOT_ACTION_DESIRE_HIGH
--             else
--                 return BOT_ACTION_DESIRE_NONE
--             end
--         end

--         if DevouredAbility:GetToggleState() == true
--         then
--             return BOT_ACTION_DESIRE_HIGH
--         end
--     end

--     -- Chain Lightning
--     if DevouredAbility:GetName() == 'harpy_storm_chain_lightning'
--     then
--         nCastRange = J.GetProperCastRange(false, bot, DevouredAbility:GetCastRange())
--         nDamage = DevouredAbility:GetSpecialValueInt('initial_damage')
--         local nJumpDist = DevouredAbility:GetSpecialValueInt('jump_range')

--         local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nEnemyHeroes)
--         do
--             if  J.IsValidHero(enemyHero)
--             and J.CanCastOnNonMagicImmune(enemyHero)
--             and J.CanCastOnTargetAdvanced(enemyHero)
--             and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
--             and not J.IsSuspiciousIllusion(enemyHero)
--             and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
--             and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
--             and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
--             and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
--             then
--                 return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--             end
--         end

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.CanCastOnTargetAdvanced(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
--             and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
--             then
--                 local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--             for _, enemyHero in pairs(nInRangeEnemy)
--             do
--                 if  J.IsValidHero(enemyHero)
--                 and J.CanCastOnNonMagicImmune(enemyHero)
--                 and J.IsChasingTarget(enemyHero, bot)
--                 and not J.IsSuspiciousIllusion(enemyHero)
--                 and not J.IsDisabled(enemyHero)
--                 then
--                     local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                     local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                     if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                     and ((#nTargetInRangeAlly > #nInRangeAlly)
--                         or bot:WasRecentlyDamagedByAnyHero(2))
--                     then
--                         return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                     end
--                 end
--             end
--         end

--         if  J.IsFarming(bot)
--         and J.GetManaAfter(DevouredAbility:GetManaCost()) * bot:GetMana() > Doom:GetManaCost() * 2
--         then
--             local nCreeps = bot:GetNearbyCreeps(1600, true)
--             if  nCreeps ~= nil
--             and ((#nCreeps >= 3)
--                 or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
--             and J.IsAttacking(bot)
--             then
--                 for _, creep in pairs(nCreeps)
--                 do
--                     if  J.IsValid(creep)
--                     and J.CanBeAttacked(creep)
--                     then
--                         local nCreepCountAround = J.GetNearbyAroundLocationUnitCount(true, false, nJumpDist, creep:GetLocation())
--                         if nCreepCountAround >= 2
--                         then
--                             return BOT_ACTION_DESIRE_HIGH, creep, 'unit'
--                         end
--                     end
--                 end
--             end
--         end

--         if J.IsDoingRoshan(bot)
--         then
--             -- Remove Spell Block
--             if  J.IsRoshan(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--             end
--         end

--         if J.IsDoingTormentor(bot)
--         then
--             if  J.IsTormentor(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--             end
--         end
--     end

--     -- War Stomp
--     if DevouredAbility:GetName() == 'centaur_khan_war_stomp'
--     then
--         nDamage = DevouredAbility:GetAbilityDamage()
--         nRadius = DevouredAbility:GetSpecialValueInt('radius')

--         local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nEnemyHeroes)
--         do
--             if  J.IsValidHero(enemyHero)
--             and J.CanCastOnNonMagicImmune(enemyHero)
--             and not J.IsSuspiciousIllusion(enemyHero)
--             then
--                 if enemyHero:IsChanneling()
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end

--                 if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
--                 and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
--                 and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
--                 and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--                 and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
--                 and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--                 and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
--             and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--             then
--                 local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                 local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--             local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--             if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--             and J.IsValidHero(nInRangeEnemy[1])
--             and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
--             and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
--             and J.IsChasingTarget(nInRangeEnemy[1], bot)
--             and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
--             and not J.IsDisabled(nInRangeEnemy[1])
--             and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nTargetInRangeAlly ~= nil
--                 and ((#nTargetInRangeAlly > #nInRangeAlly)
--                     or (bot:WasRecentlyDamagedByAnyHero(2)))
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsDoingRoshan(bot)
--         then
--             if  J.IsRoshan(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             and not J.IsDisabled(botTarget)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end

--         if J.IsDoingTormentor(bot)
--         then
--             if  J.IsTormentor(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end
--     end

--     -- Intimidate
--     if DevouredAbility:GetName() == 'giant_wolf_intimidate'
--     then
--         nRadius = DevouredAbility:GetSpecialValueInt('radius')

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--             local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--             if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--             and J.IsValidHero(nInRangeEnemy[1])
--             and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
--             and J.IsChasingTarget(nInRangeEnemy[1], bot)
--             and J.IsAttacking(nInRangeEnemy[1])
--             and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
--             and not J.IsDisabled(nInRangeEnemy[1])
--             and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nTargetInRangeAlly ~= nil
--                 and ((#nTargetInRangeAlly > #nInRangeAlly)
--                     or (bot:WasRecentlyDamagedByAnyHero(1.5)))
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsDoingRoshan(bot)
--         then
--             if  J.IsRoshan(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             and not J.IsDisabled(botTarget)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end

--         if J.IsDoingTormentor(bot)
--         then
--             if  J.IsTormentor(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end
--     end

--     -- Purge
--     if DevouredAbility:GetName() == 'satyr_trickster_purge'
--     then
--         nCastRange = J.GetProperCastRange(false, bot, DevouredAbility:GetCastRange())

--         if  not bot:IsMagicImmune()
-- 		and not bot:IsInvulnerable()
--         then
--             if J.IsDisabled(bot)
--             or bot:HasModifier('modifier_bounty_hunter_track')
--             -- more here...
--             then
--                 return BOT_ACTION_DESIRE_HIGH, bot, 'unit'
--             end
--         end

--         local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
--         for _, allyHero in pairs(nAllyHeroes)
--         do
--             if  J.IsValidHero(allyHero)
--             and not allyHero:IsMagicImmune()
--             and not allyHero:IsInvulnerable()
--             and not J.IsSuspiciousIllusion(allyHero)
--             then
--                 if J.IsDisabled(allyHero)
--                 or allyHero:HasModifier('modifier_bounty_hunter_track')
--                 -- more here...
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, bot, 'unit'
--                 end
--                 return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit'
--             end
--         end

--         local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nEnemyHeroes)
--         do
--             if  J.IsValidHero(enemyHero)
--             and not J.IsDisabled(enemyHero)
--             and not enemyHero:IsMagicImmune()
--             and not enemyHero:IsInvulnerable()
--             and not J.IsSuspiciousIllusion(enemyHero)
--             then
--                 if enemyHero:HasModifier('modifier_item_satanic_unholy')
--                 or enemyHero:HasModifier('modifier_rune_doubledamage')
--                 -- more here...
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                 end
--             end
--         end

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.CanCastOnTargetAdvanced(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and J.IsChasingTarget(bot, botTarget)
--             and botTarget:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--             for _, enemyHero in pairs(nInRangeEnemy)
--             do
--                 if  J.IsValidHero(enemyHero)
--                 and J.CanCastOnNonMagicImmune(enemyHero)
--                 and J.CanCastOnTargetAdvanced(enemyHero)
--                 and J.IsChasingTarget(enemyHero, bot)
--                 and not J.IsSuspiciousIllusion(enemyHero)
--                 and not J.IsDisabled(enemyHero)
--                 then
--                     local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                     local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                     if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                     and ((#nTargetInRangeAlly > #nInRangeAlly)
--                         or bot:WasRecentlyDamagedByAnyHero(2))
--                     and enemyHero:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
--                     then
--                         return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                     end
--                 end
--             end
--         end
--     end

--     -- -- Mana Burn
--     -- if DevouredAbility:GetName() == 'satyr_soulstealer_mana_burn'
--     -- -- Shock Wave
--     -- if DevouredAbility:GetName() == 'satyr_hellcaller_shockwave'

--     return BOT_ACTION_DESIRE_HIGH, nil, ''
-- end

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