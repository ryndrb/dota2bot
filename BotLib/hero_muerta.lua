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
                "item_magic_wand",
                "item_faerie_fire",

                "item_power_treads",
                "item_null_talisman",
                "item_falcon_blade",
                "item_maelstrom",
                "item_dragon_lance",
                "item_mjollnir",--
                "item_hurricane_pike",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_satanic",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_greater_crit",
                "item_falcon_blade", "item_satanic",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Deadshot      = bot:GetAbilityByName('muerta_dead_shot')
    TheCalling    = bot:GetAbilityByName('muerta_the_calling')
    Gunslinger    = bot:GetAbilityByName('muerta_gunslinger')
    PartingShot   = bot:GetAbilityByName('muerta_parting_shot')
    PierceTheVeil = bot:GetAbilityByName('muerta_pierce_the_veil')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

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
    if not J.CanCastAbility(Deadshot) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Deadshot:GetCastRange())
    local nCastPoint = Deadshot:GetCastPoint()
    local nRadius = Deadshot:GetSpecialValueInt('radius')
    local nDamage = Deadshot:GetSpecialValueInt('damage')
    local nSpeed = Deadshot:GetSpecialValueInt('speed')
    local nManaCost = Deadshot:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TheCalling, PierceTheVeil})

    for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
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
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
					and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end

		if not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(600)) and #nEnemyHeroes == 0 then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if (nLocationAoE.count >= 3) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end

                    local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                    if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) and #nAllyHeroes <= 1 and fManaAfter > fManaThreshold1 + 0.2 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
				end
			end
		end
	end

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
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
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500 and fManaAfter > fManaThreshold1 + 0.1)
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
            and (J.IsCore(bot) or not J.IsThereCoreInLocation(creep:GetLocation(), 550))
            then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 650, 0, 0)

                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTheCalling()
    if not J.CanCastAbility(TheCalling) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, TheCalling:GetCastRange())
    local nCastPoint = TheCalling:GetCastPoint()
    local nRadius = TheCalling:GetSpecialValueInt('hit_radius')
    local nManaCost = TheCalling:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Deadshot, PierceTheVeil})

    for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange * 2)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        and not enemyHero:HasModifier('modifier_teleporting')
		then
            local dist = GetUnitToUnitDistance(bot, enemyHero)
            if J.IsInRange(bot, enemyHero, nCastRange) then
                return BOT_ACTION_DESIRE_HIGH, J.VectorAway(bot:GetLocation(), enemyHero:GetLocation(), Min(nCastRange, nCastRange - dist + nRadius))
            else
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), Min(nCastRange, dist - nCastRange + nRadius))
            end
		end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange * 2, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsDisabled(enemyHero)
                and not enemyHero:IsSilenced()
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 2)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsSilenced()
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and fManaAfter > fManaThreshold1
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange - 75)
			and J.CanCastOnNonMagicImmune(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
            and not enemyHero:IsSilenced()
			then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderGunslinger()
    if not J.CanCastAbility(Gunslinger) then
        return BOT_ACTION_DESIRE_NONE
    end

    if Gunslinger:GetToggleState() == false then
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
    if not J.CanCastAbility(PierceTheVeil) then
        return BOT_ACTION_DESIRE_NONE
    end

    local botAttackRange = bot:GetAttackRange()

    if J.IsInTeamFight(bot, 1200) then
        if bot:WasRecentlyDamagedByAnyHero(1.0) and bAttacking and #nEnemyHeroes >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and botHP < 0.75
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if not (#nAllyHeroes >= #nEnemyHeroes + 2)
            or (botHP < 0.15 and bot:WasRecentlyDamagedByAnyHero(1.0))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(2.0) and J.CanBeAttacked(bot) then
        if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.5) > bot:GetHealth() then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and botTarget:GetAttackTarget() == bot
        and botHP < 0.2
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and botHP < 0.2
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X