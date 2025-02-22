local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_muerta'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_circlet",

                "item_null_talisman",
                "item_power_treads",
                "item_magic_wand",
                "item_maelstrom",
                "item_dragon_lance",
                "item_mjollnir",--
                "item_hurricane_pike",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_satanic",--
                "item_moon_shard",
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_greater_crit",
                "item_null_talisman", "item_satanic",
            },
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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local Deadshot      = bot:GetAbilityByName('muerta_dead_shot')
local TheCalling    = bot:GetAbilityByName('muerta_the_calling')
local Gunslinger    = bot:GetAbilityByName('muerta_gunslinger')
local PartingShot   = bot:GetAbilityByName('muerta_parting_shot')
local Ofrenda       = bot:GetAbilityByName('muerta_ofrenda')
local OfrendaDestroy = bot:GetAbilityByName('muerta_ofrenda_destroy')
local PierceTheVeil = bot:GetAbilityByName('muerta_pierce_the_veil')

local DeadshotDesire, DeadshotTarget
local TheCallingDesire, TheCallingLocation
local GunslingerDesire
local PartingShotDesire, PartingShotTarget
local OfrendaDesire, OfrendaLocation
local OfrendaDestroyDesire
local PierceTheVeilDesire

local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    Deadshot      = bot:GetAbilityByName('muerta_dead_shot')
    TheCalling    = bot:GetAbilityByName('muerta_the_calling')
    Gunslinger    = bot:GetAbilityByName('muerta_gunslinger')
    PartingShot   = bot:GetAbilityByName('muerta_parting_shot')
    PierceTheVeil = bot:GetAbilityByName('muerta_pierce_the_veil')

    botTarget = J.GetProperTarget(bot)

    PierceTheVeilDesire = X.ConsiderPierceTheVeil()
    if PierceTheVeilDesire > 0
    then
        bot:Action_UseAbility(PierceTheVeil)
        return
    end

    PartingShotDesire, PartingShotTarget = X.ConsiderPartingShot()
    if PartingShotDesire > 0
    then
        bot:Action_UseAbilityOnEntity(PartingShot, PartingShotTarget)
        return
    end

    TheCallingDesire, TheCallingLocation = X.ConsiderTheCalling()
    if TheCallingDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(TheCalling, TheCallingLocation)
        return
    end

    DeadshotDesire, DeadshotTarget = X.ConsiderDeadshot()
    if DeadshotDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Deadshot, DeadshotTarget)
        return
    end

    GunslingerDesire = X.ConsiderGunslinger()
    if GunslingerDesire > 0
    then
        bot:Action_UseAbility(Gunslinger)
        return
    end

    -- OfrendaDesire, OfrendaLocation = X.ConsiderOfrenda()
end

function X.ConsiderDeadshot()
    if not J.CanCastAbility(Deadshot)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Deadshot:GetCastRange())
    local nDamage = Deadshot:GetAbilityDamage()

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
    end

    if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        then
            if (not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe'))
            or J.IsChasingTarget(bot, botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.CanCastOnTargetAdvanced(nEnemyHeroes[1])
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsDisarmed()
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
        end
	end

    if J.IsLaning(bot)
	then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.IsKeyWordUnit('ranged', creep)
            and creep:GetHealth() <= nDamage
            then
                if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

    for _, allyHero in pairs(nAllyHeroes)
    do
        if J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.GetManaAfter(Deadshot:GetManaCost()) > 0.48
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not J.IsRealInvisible(bot)
        and not J.IsRealInvisible(allyHero)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and not botTarget:IsAttackImmune()
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
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

    if bot:GetLevel() >= 10
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    and not J.IsAttacking(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(nCastRange, true)
        for _, creep in pairs(nCreeps)
        do
            if  J.IsValid(creep)
            and botTarget ~= creep
            and J.CanBeAttacked(creep)
            and creep:GetHealth() <= nDamage
            then
                return BOT_ACTION_DESIRE_HIGH, creep
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTheCalling()
    if not J.CanCastAbility(TheCalling)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, TheCalling:GetCastRange())
    local nRadius = TheCalling:GetSpecialValueInt('dead_zone_distance')
    local nCastPoint = TheCalling:GetCastPoint()

    if J.IsInTeamFight(bot, 1200)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + nRadius, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
            else
                if J.IsInRange(bot, botTarget, nCastRange)
                then
                    if J.IsChasingTarget(bot, botTarget)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint)
                    else
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                end
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.5)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if  J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nCastRange)
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and not J.IsDisabled(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.GetManaAfter(TheCalling:GetManaCost()) > 0.48
        and allyHero:WasRecentlyDamagedByAnyHero(3.5)
        and not J.IsRealInvisible(bot)
        and not J.IsRealInvisible(allyHero)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            then
                if J.IsInRange(allyHero, nAllyInRangeEnemy[1], nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
                else
                    return BOT_ACTION_DESIRE_HIGH, (allyHero:GetLocation() + nAllyInRangeEnemy[1]:GetLocation()) / 2
                end
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.3
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderGunslinger()
    if not J.CanCastAbility(Gunslinger)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if Gunslinger:GetToggleState() == false
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPartingShot()
    if not J.CanCastAbility(PartingShot)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, PartingShot:GetCastRange())
    local nDamage = PartingShot:GetAbilityDamage()
    local nDuration = 4

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if J.IsGoingOnSomeone(bot)
    then
        local dmg = 0
        local target = nil

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 150)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_batrider_flaming_lasso')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, nDuration, DAMAGE_TYPE_ALL)
                if currDmg > dmg
                then
                    dmg = currDmg
                    target = enemyHero
                end
            end
        end

        if J.IsValidHero(target)
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3)
	then
        if J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], nCastRange)
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.CanCastOnTargetAdvanced(nInRangeEnemy[1])
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        and not J.IsDisabled(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
        end
	end

    for _, enemyHero in pairs(nInRangeEnemy)
    do
        if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:IsChanneling()
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPierceTheVeil()
    if not J.CanCastAbility(PierceTheVeil)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsInTeamFight(bot, bot:GetAttackRange() + 150)
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), bot:GetAttackRange() + 300)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not bot:IsAttackImmune()
        and not bot:IsInvulnerable()
        and (not bot:IsMagicImmune() or not bot:HasModifier('modifier_black_king_bar_immune'))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and not botTarget:IsAttackImmune()
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.GetHP(bot) <= 0.75
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
            and not (#nAllyHeroes >= #nEnemyHeroes + 2)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(5)
    and bot:GetActiveModeDesire() > 0.7
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and (J.IsChasingTarget(nEnemyHeroes[1], bot) or (J.IsAttacking(nEnemyHeroes[1]) and nEnemyHeroes[1]:GetAttackTarget() == bot))
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and J.GetHP(bot) <= 0.55
        and not bot:IsAttackImmune()
        and not bot:IsInvulnerable()
        and not bot:IsMagicImmune()
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
    then
        if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, 700)
        and J.GetHP(bot) < 0.17
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end


return X