local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_centaur'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_heavens_halberd"}
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
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {2,1,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_gauntlets",
			
                "item_bottle",
				"item_magic_wand",
                "item_double_bracer",
				"item_phase_boots",
                "item_blade_mail",
                "item_blink",
                "item_kaya",
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_kaya_and_sange",--
                "item_heart",--
                "item_overwhelming_blink",--
                "item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_blink",
                "item_bracer", "item_kaya",
                "item_bracer", "item_shivas_guard",
                "item_bottle", "item_heart",
                "item_blade_mail", "item_wind_waker",
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
				},
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_ring_of_protection",
			
				"item_magic_wand",
                "item_double_bracer",
                "item_boots",
                "item_blade_mail",
				"item_phase_boots",
                "item_blink",
                "item_crimson_guard",--
                sUtilityItem,--
				"item_aghanims_shard",
                "item_shivas_guard",--
                "item_overwhelming_blink",--
                "item_heart",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_ring_of_protection", "item_blink",
				"item_magic_wand", "item_crimson_guard",
                "item_bracer", sUtilityItem,
                "item_bracer", "item_shivas_guard",
                "item_blade_mail", "item_heart",
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

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

end

local HoofStomp     = bot:GetAbilityByName('centaur_hoof_stomp')
local DoubleEdge    = bot:GetAbilityByName('centaur_double_edge')
-- local Retaliate     = bot:GetAbilityByName('centaur_return')
local WorkHorse     = bot:GetAbilityByName('centaur_work_horse')
local HitchARide    = bot:GetAbilityByName('centaur_mount')
local Stampede      = bot:GetAbilityByName('centaur_stampede')

local HoofStompDesire
local DoubleEdgeDesire, DoubleEdgeTarget
local WorkHorseDesire
local HitchARideDesire, HitchARideTarget
local StampedeDesire

local bAttacking = false
local botTarget, botHealth, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    HoofStomp     = bot:GetAbilityByName('centaur_hoof_stomp')
    DoubleEdge    = bot:GetAbilityByName('centaur_double_edge')
    WorkHorse     = bot:GetAbilityByName('centaur_work_horse')
    HitchARide    = bot:GetAbilityByName('centaur_mount')
    Stampede      = bot:GetAbilityByName('centaur_stampede')

    bAttacking = J.IsAttacking(bot)
    botHealth = bot:GetHealth()
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    HitchARideDesire, HitchARideTarget = X.ConsiderHitchARide()
    if HitchARideDesire > 0 then
        bot:Action_UseAbilityOnEntity(HitchARide, HitchARideTarget)
        return
    end

    WorkHorseDesire, HitchARideTarget = X.ConsiderWorkHorse()
    if WorkHorseDesire > 0 then
        bot:Action_UseAbility(WorkHorse)
        return
    end

    StampedeDesire = X.ConsiderStampede()
    if StampedeDesire > 0 then
        bot:Action_UseAbility(Stampede)
        return
    end

    HoofStompDesire = X.ConsiderHoofStomp()
    if HoofStompDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(HoofStomp)
        return
    end

    DoubleEdgeDesire, DoubleEdgeTarget = X.ConsiderDoubleEdge()
    if DoubleEdgeDesire > 0 then
        bot:Action_UseAbilityOnEntity(DoubleEdge, DoubleEdgeTarget)
        return
    end
end

function X.ConsiderHoofStomp()
    if not J.CanCastAbility(HoofStomp) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = HoofStomp:GetSpecialValueInt('radius')
	local nDamage = HoofStomp:GetSpecialValueInt('stomp_damage')
    local fWindUpTime = HoofStomp:GetSpecialValueInt('windup_time')
    local nManaCost = HoofStomp:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WorkHorse, HitchARide, Stampede})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
            if enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fWindUpTime)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if fManaThreshold1 > 0 then
                if fManaAfter > fManaThreshold1 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            else
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and J.IsInRange(bot, enemy, nRadius - 75)
			and not J.IsDisabled(enemy)
			and not enemy:IsDisarmed()
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsDisabled(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and fManaAfter > 0.5
        and fManaAfter > fManaThreshold1
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and fManaAfter > 0.5
        and fManaAfter > fManaThreshold1
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDoubleEdge()
    if not J.CanCastAbility(DoubleEdge) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, DoubleEdge:GetCastRange())
    local nRadius = DoubleEdge:GetSpecialValueInt('radius')
    local nStrength = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
    local nAttackRange = bot:GetAttackRange()
    local nStrengthDamageMul = DoubleEdge:GetSpecialValueInt('strength_damage') / 100
	local nDamage = DoubleEdge:GetSpecialValueInt('edge_damage') + (nStrength * nStrengthDamageMul)
    local fHealthAfter = J.GetHealthAfter(nDamage)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nAttackRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if botHealth > nDamage * 1.2 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if botHealth > nDamage * 1.5 then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange * 2, true)

    if J.IsPushing(bot) and bAttacking and fHealthAfter > 0.4 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fHealthAfter > 0.4 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end

        if J.IsValidHero(nEnemyHeroes[1]) and fHealthAfter > 0.3 then
            local nLocationAoE = bot:FindAoELocation(true, true, nEnemyHeroes[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fHealthAfter > 0.3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 1) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() then
        if fHealthAfter > 0.3 then
            for _, creep in pairs(nEnemyCreeps) do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
                and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 1 then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end

        if fHealthAfter > 0.5 and #nAllyHeroes >= #nEnemyHeroes then
            if  J.IsValidTarget(nEnemyHeroes[1])
            and J.CanBeAttacked(nEnemyHeroes[1])
            and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
            and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
            and J.CanCastOnTargetAdvanced(nEnemyHeroes[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
            end
        end
	end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and bAttacking
        and fHealthAfter > 0.4
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and bAttacking
        and fHealthAfter > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWorkHorse()
    if not J.CanCastAbility(WorkHorse)
    or bot:HasModifier('modifier_centaur_stampede')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    if J.IsInTeamFight(bot, 1200) then
        local vTeamFightLocation = J.GetTeamFightLocation(bot)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

        if #nInRangeEnemy >= 2 and vTeamFightLocation ~= nil then
            if GetUnitToLocationDistance(bot, vTeamFightLocation) < 800 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 600)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if (J.IsChasingTarget(enemyHero, bot) and botHP < 0.55)
                or (#nInRangeEnemy > #nInRangeAlly and bot:IsFacingLocation(J.GetTeamFountain(), 30) and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderHitchARide()
    if not J.CanCastAbility(HitchARide) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, HitchARide:GetCastRange())

    if J.IsGoingOnSomeone(bot)
    or J.IsInTeamFight(bot, 1200)
    then
        for _, allyHero in pairs(nAllyHeroes) do
            if bot ~= allyHero
            and J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.CanBeAttacked(allyHero)
            and J.IsCore(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(4)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
            then
                local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)
                if J.GetHP(allyHero) < 0.5 and #nEnemyHeroesTargetingAlly >= 1 then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if bot ~= allyHero
            and J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsRetreating(allyHero)
            and J.CanBeAttacked(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(4)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderStampede()
    if not J.CanCastAbility(Stampede)
    or bot:HasModifier('modifier_centaur_cart')
    or bot:HasModifier('modifier_centaur_stampede')
    then
		return BOT_ACTION_DESIRE_NONE
	end

    if J.IsInTeamFight(bot, 1200) then
        local vTeamFightLocation = J.GetTeamFightLocation(bot)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

        if #nInRangeEnemy >= 2 and vTeamFightLocation ~= nil then
            if GetUnitToLocationDistance(bot, vTeamFightLocation) < 800 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 600)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if (J.IsChasingTarget(enemyHero, bot) and botHP < 0.65 and #nInRangeEnemy > #nInRangeAlly)
                or (#nInRangeEnemy > #nInRangeAlly + 1 and bot:IsFacingLocation(J.GetTeamFountain(), 30))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X