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
                "item_double_tango",
                "item_double_branches",
                "item_circlet",
                "item_blood_grenade",
            
                "item_null_talisman",
                "item_wind_lace",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_cyclone",
                "item_glimmer_cape",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_aether_lens",
                "item_octarine_core",--
                "item_wind_waker",--
                "item_sheepstick",--
                "item_ethereal_blade",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_null_talisman",
                "item_magic_wand",
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
                "item_double_tango",
                "item_double_branches",
                "item_circlet",
                "item_blood_grenade",
            
                "item_null_talisman",
                "item_wind_lace",
                "item_magic_wand",
                "item_arcane_boots",
                "item_cyclone",
                "item_glimmer_cape",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_aether_lens",
                "item_octarine_core",--
                "item_wind_waker",--
                "item_sheepstick",--
                "item_ethereal_blade",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_null_talisman",
                "item_magic_wand",
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
local CurseCrown    = bot:GetAbilityByName('dark_willow_cursed_crown')
local Bedlam        = bot:GetAbilityByName('dark_willow_bedlam')
local Terrorize     = bot:GetAbilityByName('dark_willow_terrorize')

local BrambleMazeDesire, BrambleMazeLocation
local ShadowRealmDesire
local CurseCrownDesire, CurseCrownTarget
local BedlamDesire
local TerrorizeDesire, TerrorizeLocation

local BedlamTime    = 0
local TerrorizeTime = 0

local botTarget

function X.SkillsComplement()
    BrambleMaze   = bot:GetAbilityByName('dark_willow_bramble_maze')
    ShadowRealm   = bot:GetAbilityByName('dark_willow_shadow_realm')
    CurseCrown    = bot:GetAbilityByName('dark_willow_cursed_crown')
    Bedlam        = bot:GetAbilityByName('dark_willow_bedlam')
    Terrorize     = bot:GetAbilityByName('dark_willow_terrorize')

	if J.CanNotUseAbility(bot)
    then
        return
    end

    botTarget = J.GetProperTarget(bot)

    TerrorizeDesire, TerrorizeLocation = X.ConsiderTerrorize()
    if TerrorizeDesire > 0
    then
        bot:Action_UseAbilityOnLocation(Terrorize, TerrorizeLocation)
        TerrorizeTime = DotaTime()
        return
    end

    BrambleMazeDesire, BrambleMazeLocation = X.ConsiderBrambleMaze()
    if BrambleMazeDesire > 0
    then
        bot:Action_UseAbilityOnLocation(BrambleMaze, BrambleMazeLocation)
        return
    end

    BedlamDesire = X.ConsiderBedlam()
    if BedlamDesire > 0
    then
        bot:Action_UseAbility(Bedlam)
        BedlamTime = DotaTime()
        return
    end

    ShadowRealmDesire = X.ConsiderShadowRealm()
    if ShadowRealmDesire > 0
    then
        bot:Action_UseAbility(ShadowRealm)
        return
    end

    CurseCrownDesire, CurseCrownTarget = X.ConsiderCurseCrown()
    if CurseCrownDesire > 0
    then
        bot:Action_UseAbilityOnEntity(CurseCrown, CurseCrownTarget)
        return
    end
end

function X.ConsiderBrambleMaze()
    if not J.CanCastAbility(BrambleMaze)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BrambleMaze:GetCastRange())
    local nRadius = BrambleMaze:GetSpecialValueInt('placement_range')

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
		and enemyHero:HasModifier('modifier_teleporting')
        and J.CanCastOnNonMagicImmune(enemyHero)
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
            if J.IsInTeamFight(bot, 1200) then
                if nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end

            if J.IsChasingTarget(bot, botTarget)
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if J.IsInRange(bot, botTarget, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
                if J.IsInRange(bot, botTarget, nCastRange + nRadius)
                and not J.IsInRange(bot, botTarget, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsDisabled(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 3.0)
            and J.IsChasingTarget(enemy, bot)
            then
                if J.IsInRange(bot, enemy, nCastRange) then
                    local nLocationAoE = bot:FindAoELocation(true, true, enemy:GetLocation(), 0, nRadius, 0, 0)
                    if nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                    end
                end
                if J.IsInRange(bot, enemy, nCastRange + nRadius)
                and not J.IsInRange(bot, enemy, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, enemy:GetLocation(), nCastRange)
                end
            end
        end
    end

    if J.IsDefending(bot) and (J.IsMidGame() or J.IsLateGame()) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end

        nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 4 and not J.IsThereCoreNearby(800) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and (J.IsRetreating(allyHero) and J.GetHP(allyHero) < 0.75 and allyHero:WasRecentlyDamagedByAnyHero(3.0))
        and not allyHero:IsIllusion()
        and not J.IsRealInvisible(bot)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            for _, enemy in pairs(nAllyInRangeEnemy) do
                if J.IsValidHero(enemy)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.IsInRange(bot, enemy, nCastRange)
                and J.IsChasingTarget(enemy, allyHero)
                and not J.IsDisabled(enemy)
                then
                    local nLocationAoE = bot:FindAoELocation(true, true, enemy:GetLocation(), 0, nRadius, 0, 0)
                    if nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
                    end
                end
            end
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

    if J.IsStunProjectileIncoming(bot, 350)
    or J.IsUnitTargetProjectileIncoming(bot, 350)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if not bot:HasModifier('modifier_sniper_assassinate') and not bot:IsMagicImmune() then
		if J.IsWillBeCastUnitTargetSpell(bot, 400) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsGoingOnSomeone(bot) and J.GetHP(bot) < 0.5 then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and X.IsBeingAttackedByHero(bot, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsRetreating(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 1200)
            and J.IsChasingTarget(enemy, bot)
            and X.IsBeingAttackedByHero(bot, 1000)
            and not J.IsSuspiciousIllusion(enemy)
            and bot:WasRecentlyDamagedByAnyHero(3.0)
            and J.GetHP(bot) < 0.6
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if (J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)) then
        if (J.IsRoshan(bot) or J.IsTormentor(bot))
        and J.IsInRange(bot, botTarget, 800)
        and J.GetHP(bot) < 0.25
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.GetHP(bot) < 0.25 and #nEnemyHeroes > 0 then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCurseCrown()
	if not J.CanCastAbility(CurseCrown)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, CurseCrown:GetCastRange())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
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
            and not enemy:HasModifier('modifier_enigma_black_hole_pull')
            and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemy:HasModifier('modifier_legion_commander_duel')
            then
                local enemyDamage = enemy:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                if hTargetDamage < enemyDamage then
                    hTarget = enemy
                    hTargetDamage = enemyDamage
                end
            end
        end

        if hTarget ~= nil then
            bot:SetTarget(hTarget)
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not J.IsRealInvisible(bot)
        and not allyHero:IsIllusion()
        and not J.IsInTeamFight(bot, 1200)
        then
            local tAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            for _, enemyHero in pairs(tAllyInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.IsChasingTarget(enemyHero, allyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBedlam()
    if not J.CanCastAbility(Bedlam)
    or DotaTime() < TerrorizeTime + 3.5
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = Bedlam:GetSpecialValueInt('attack_radius')
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

    if #nEnemyHeroes > 0 then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTerrorize()
    if not J.CanCastAbility(Terrorize)
    or DotaTime() < BedlamTime + 5.5
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, Terrorize:GetCastRange())
    local nCastPoint = Terrorize:GetCastPoint()
	local nRadius   = Terrorize:GetSpecialValueInt('destination_radius')

    -- just in teamfights; don't gimp her power; this is specially strong since bots mostly clump together in fights
    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsBeingAttackedByHero(hUnit, nRadius)
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, nRadius)
        and (enemy:GetAttackTarget() == hUnit or J.IsChasingTarget(enemy, hUnit))
        then
            return true
        end
    end

    return false
end

return X