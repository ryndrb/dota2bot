local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sRole   = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_dark_willow'
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
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_urn_of_shadows",
                "item_cyclone",
                "item_spirit_vessel",--
                "item_glimmer_cape",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_octarine_core",--
                "item_sheepstick",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
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
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_urn_of_shadows",
                "item_cyclone",
                "item_spirit_vessel",--
                "item_glimmer_cape",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_octarine_core",--
                "item_sheepstick",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
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

local BrambleMaze   = bot:GetAbilityByName('dark_willow_bramble_maze')
local ShadowRealm   = bot:GetAbilityByName('dark_willow_shadow_realm')
local CursedCrown    = bot:GetAbilityByName('dark_willow_cursed_crown')
local Bedlam        = bot:GetAbilityByName('dark_willow_bedlam')
local Terrorize     = bot:GetAbilityByName('dark_willow_terrorize')

local BrambleMazeDesire, BrambleMazeLocation
local ShadowRealmDesire
local CurseCrownDesire, CurseCrownTarget
local BedlamDesire
local TerrorizeDesire, TerrorizeLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if Terrorize and Terrorize:IsInAbilityPhase() and TerrorizeLocation then
        local nRadius = Terrorize:GetSpecialValueInt('destination_radius')
        local nInRangeEnemy = J.GetEnemiesNearLoc(TerrorizeLocation, nRadius)
        if #nInRangeEnemy == 0 then
            bot:Action_ClearActions(true)
            return
        end
    end

	if J.CanNotUseAbility(bot) then return end

    BrambleMaze   = bot:GetAbilityByName('dark_willow_bramble_maze')
    ShadowRealm   = bot:GetAbilityByName('dark_willow_shadow_realm')
    CursedCrown    = bot:GetAbilityByName('dark_willow_cursed_crown')
    Bedlam        = bot:GetAbilityByName('dark_willow_bedlam')
    Terrorize     = bot:GetAbilityByName('dark_willow_terrorize')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    TerrorizeDesire, TerrorizeLocation = X.ConsiderTerrorize()
    if TerrorizeDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Terrorize, TerrorizeLocation)
        return
    end

    CurseCrownDesire, CurseCrownTarget = X.ConsiderCursedCrown()
    if CurseCrownDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(CursedCrown, CurseCrownTarget)
        return
    end

    BrambleMazeDesire, BrambleMazeLocation = X.ConsiderBrambleMaze()
    if BrambleMazeDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BrambleMaze, BrambleMazeLocation)
        return
    end

    BedlamDesire = X.ConsiderBedlam()
    if BedlamDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Bedlam)
        return
    end

    ShadowRealmDesire = X.ConsiderShadowRealm()
    if ShadowRealmDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ShadowRealm)
        return
    end
end

function X.ConsiderBrambleMaze()
    if not J.CanCastAbility(BrambleMaze) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BrambleMaze:GetCastRange())
    local nRadius = BrambleMaze:GetSpecialValueInt('placement_range')
    local nManaCost = BrambleMaze:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowRealm, CursedCrown, Bedlam, Terrorize})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
            if J.IsInTeamFight(bot, 1200) then
                if nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end

            if J.IsChasingTarget(bot, botTarget) then
                if J.IsInRange(bot, botTarget, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsDisabled(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 3.0)
            and J.IsChasingTarget(enemy, bot)
            then
                return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not J.IsRealInvisible(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                for _, enemy in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemy)
                    and J.IsInRange(bot, enemy, nCastRange)
                    and J.IsInRange(allyHero, enemy, nRadius)
                    and J.CanCastOnNonMagicImmune(enemy)
                    and not J.IsDisabled(enemy)
                    and J.IsChasingTarget(enemy, bot)
                    then
                        return BOT_ACTION_DESIRE_HIGH, (allyHero:GetLocation() + enemy:GetLocation()) / 2
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShadowRealm()
    if not J.CanCastAbility(ShadowRealm)
    or J.IsRealInvisible(bot)
    or bot:HasModifier('modifier_dark_willow_shadow_realm_buff')
    or not J.CanBeAttacked(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nManaCost = BrambleMaze:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowRealm, CursedCrown, Bedlam, Terrorize})

    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    if bot:HasModifier('modifier_fountain_aura_buff') and botHP < 0.75 and #nEnemyHeroes == 0 then
        return BOT_ACTION_DESIRE_HIGH
    end

	if not bot:IsMagicImmune() and fManaAfter > fManaThreshold1 then
		if (J.IsStunProjectileIncoming(bot, 350))
		or (J.IsUnitTargetProjectileIncoming(bot, 350))
		or (J.IsWillBeCastUnitTargetSpell(bot, 400) and not bot:HasModifier('modifier_sniper_assassinate'))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsGoingOnSomeone(bot) then
        if bot:WasRecentlyDamagedByAnyHero(1.0) and botHP < 0.5 and (#nEnemyHeroesTargetingMe > 0 or botHP < 0.2) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 1200)
            and not J.IsSuspiciousIllusion(enemy)
            then
                if (J.IsChasingTarget(enemy, bot) and botHP < 0.6)
                or (bot:IsRooted() and bot:WasRecentlyDamagedByAnyHero(1.0) and #nEnemyHeroesTargetingMe > 0)
                or (#nEnemyHeroes > #nAllyHeroes and bot:IsFacingLocation(J.GetTeamFountain(), 20) and J.IsRunning(bot))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and botHP < 0.25
        then
            if botTarget:GetAttackTarget() == bot or botHP < 0.15 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and botHP < 0.25
        then
            if botTarget:GetAttackTarget() == bot or botHP < 0.15 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if botHP < 0.2 and not J.IsInTeamFight(bot, 800) then
        if bot:WasRecentlyDamagedByAnyHero(1.0)
        or bot:WasRecentlyDamagedByCreep(1.0)
        or bot:WasRecentlyDamagedByTower(1.0)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCursedCrown()
	if not J.CanCastAbility(CursedCrown) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, CursedCrown:GetCastRange())
    local nCastPoint = CursedCrown:GetCastPoint()
    local nDelay = CursedCrown:GetSpecialValueInt('delay')
    local nManaCost = CursedCrown:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BrambleMaze, ShadowRealm, Bedlam, Terrorize})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nDelay + nCastPoint then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
                local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
                if #nAllyHeroesAttackingTarget >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.CanCastOnTargetAdvanced(enemy)
            and J.CanBeAttacked(enemy)
            and not J.IsDisabled(enemy)
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_legion_commander_duel')
            then
                local enemyDamage = enemy:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                if hTargetDamage < enemyDamage then
                    hTarget = enemy
                    hTargetDamage = enemyDamage
                end
            end
        end

        if hTarget then
            bot:SetTarget(hTarget)
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsSuspiciousIllusion(allyHero)
            and not J.IsInTeamFight(bot, 1200)
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBedlam()
    if not J.CanCastAbility(Bedlam) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = Bedlam:GetSpecialValueInt('attack_radius')
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), bot:GetAttackRange() + nRadius)

    if J.IsValidHero(nInRangeEnemy[1]) then
        if J.IsInTeamFight(bot, 1200) then
            return BOT_ACTION_DESIRE_HIGH
        end

        if #nAllyHeroes >= #nEnemyHeroes or bot:HasModifier('modifier_dark_willow_shadow_realm_buff') then
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
                then
                    if J.GetHP(enemyHero) < 0.5
                    or J.IsDisabled(enemyHero)
                    or enemyHero:HasModifier('modifier_legion_commander_duel')
                   then
                       return BOT_ACTION_DESIRE_HIGH
                   end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTerrorize()
    if not J.CanCastAbility(Terrorize) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, Terrorize:GetCastRange())
    local nCastPoint = Terrorize:GetCastPoint()
	local nRadius   = Terrorize:GetSpecialValueInt('destination_radius')

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidTarget(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not J.IsDisabled(enemyHero)
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X