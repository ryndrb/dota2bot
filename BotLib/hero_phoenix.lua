local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_phoenix'
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_faerie_fire",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_cyclone",
                "item_spirit_vessel",--
                "item_glimmer_cape",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_refresher",--
                "item_sheepstick",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_refresher",
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
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_faerie_fire",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_cyclone",
                "item_spirit_vessel",--
                "item_glimmer_cape",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_refresher",--
                "item_sheepstick",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_refresher",
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

local IcarusDive        = bot:GetAbilityByName('phoenix_icarus_dive')
local IcarusDiveStop    = bot:GetAbilityByName('phoenix_icarus_dive_stop')
local FireSpirits       = bot:GetAbilityByName('phoenix_fire_spirits')
local FireSpiritsLaunch = bot:GetAbilityByName('phoenix_launch_fire_spirit')
local SunRay            = bot:GetAbilityByName('phoenix_sun_ray')
local SunRayStop        = bot:GetAbilityByName('phoenix_sun_ray_stop')
local ToggleMovement    = bot:GetAbilityByName('phoenix_sun_ray_toggle_move')
local Supernova         = bot:GetAbilityByName('phoenix_supernova')

local IcarusDiveDesire, IcarusDiveLocation
local IcarusDiveStopDesire
local FireSpiritsDesire
local FireSpiritsLaunchDesire, FireSpiritsLaunchLocation
local SunRayDesire, SunRayLocation
local SunRayStopDesire
local ToggleMovementDesire, bToggle
local SupernovaDesire, SupernovaTarget

local IcarusDiveTime = -1
local IcarusDiveDuration = 2

local FireSpiritsLaunchTime = 0

local bHasShardSupernova = false
local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()
    bHasShardSupernova = bot:HasModifier('modifier_phoenix_supernova_hiding') and J.CanCastAbility(SunRay)

	if J.CanNotUseAbility(bot) and not bHasShardSupernova then
        return
    end

    IcarusDive        = bot:GetAbilityByName('phoenix_icarus_dive')
    IcarusDiveStop    = bot:GetAbilityByName('phoenix_icarus_dive_stop')
    FireSpirits       = bot:GetAbilityByName('phoenix_fire_spirits')
    FireSpiritsLaunch = bot:GetAbilityByName('phoenix_launch_fire_spirit')
    SunRay            = bot:GetAbilityByName('phoenix_sun_ray')
    SunRayStop        = bot:GetAbilityByName('phoenix_sun_ray_stop')
    ToggleMovement    = bot:GetAbilityByName('phoenix_sun_ray_toggle_move')
    Supernova         = bot:GetAbilityByName('phoenix_supernova')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    FireSpiritsDesire = X.ConsiderFireSpirits()
    if FireSpiritsDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FireSpirits)
        return
    end

    FireSpiritsLaunchDesire, FireSpiritsLaunchLocation = X.ConsiderFireSpiritsLaunch()
    if FireSpiritsLaunchDesire > 0 then
        FireSpiritsLaunchTime = DotaTime()
        bot:Action_UseAbilityOnLocation(FireSpiritsLaunch, FireSpiritsLaunchLocation)
        return
    end

    SupernovaDesire, SupernovaTarget, bCastToAlly = X.ConsiderSupernova()
    if SupernovaDesire > 0 then
        if string.find(GetBot():GetUnitName(), 'phoenix')
        and bot:HasScepter()
        and bCastToAlly
        then
            bot:Action_UseAbilityOnEntity(Supernova, SupernovaTarget)
            return
        else
            -- use Fire Spirits before exploding
            if J.CanCastAbility(FireSpirits) and bot:GetMana() > (FireSpirits:GetManaCost() + Supernova:GetManaCost() + 100) then
                bot:Action_ClearActions(false)
                bot:ActionQueue_UseAbility(FireSpirits)

                for _, enemy in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemy)
                    and J.IsInRange(bot, enemy, FireSpirits:GetCastRange())
                    and J.CanCastOnNonMagicImmune(enemy)
                    and not J.IsEnemyChronosphereInLocation(enemy:GetLocation())
                    and not J.IsEnemyBlackHoleInLocation(enemy:GetLocation())
                    and not enemy:IsDisarmed()
                    and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not enemy:HasModifier('modifier_phoenix_fire_spirit_burn') then
                        bot:ActionQueue_UseAbilityOnLocation(FireSpiritsLaunch, enemy:GetLocation())
                    end
                end

                bot:ActionQueue_UseAbility(Supernova)
                return
            else
                bot:Action_UseAbility(Supernova)
                return
            end
        end
    end

    IcarusDiveDesire, IcarusDiveLocation = X.ConsiderIcarusDive()
    if IcarusDiveDesire > 0 then
        IcarusDiveTime = DotaTime()
        bot:Action_UseAbilityOnLocation(IcarusDive, IcarusDiveLocation)
        return
    end

    IcarusDiveStopDesire = X.ConsiderIcarusDiveStop()
    if IcarusDiveStopDesire > 0 then
        bot.icarus_dive_stuck = false
        bot:Action_UseAbility(IcarusDiveStop)
        return
    end

    SunRayDesire, SunRayLocation = X.ConsiderSunRay()
    if SunRayDesire > 0 then
        bot:Action_UseAbilityOnLocation(SunRay, SunRayLocation)
        return
    end

    SunRayStopDesire = X.ConsiderSunRayStop()
    if SunRayStopDesire > 0 then
        bot.sun_ray_engage = false
        bot.sun_ray_heal_ally = false
        bot:Action_UseAbility(SunRayStop)
        return
    end

    ToggleMovementDesire, bToggle = X.ConsiderToggleMovement()
    if ToggleMovementDesire > 0 then
		if bToggle == true then
			if not ToggleMovement:GetToggleState() then
				bot:Action_UseAbility(ToggleMovement)
			end
		else
			if ToggleMovement:GetToggleState() then
				bot:Action_UseAbility(ToggleMovement)
			end
		end

        return
    end
end

function X.ConsiderIcarusDive()
    if not J.CanCastAbility(IcarusDive)
    or bot:IsRooted()
    or bot:HasModifier('modifier_phoenix_icarus_dive')
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    or bot:HasModifier('modifier_bloodseeker_rupture')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nDiveLength = IcarusDive:GetSpecialValueInt('dash_length')
	local nDiveWidth = IcarusDive:GetSpecialValueInt('dash_width')
    local nHealthCost = (IcarusDive:GetSpecialValueInt('hp_cost_perc') / 100) * bot:GetHealth()
	local nDamage = IcarusDive:GetSpecialValueInt('damage_per_second') * IcarusDive:GetSpecialValueFloat('burn_duration')
    local fHealthAfter = J.GetHealthAfter(nHealthCost)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nDiveLength)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, 1.0)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not J.IsLocationInChrono(enemyHero:GetLocation())
        and not J.IsEnemyBlackHoleInLocation(enemyHero:GetLocation())
        and fHealthAfter > 0.4
        then
            bot.icarus_dive_kill = true
            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
        end
    end

	if J.IsStuck(bot) then
        bot.icarus_dive_stuck = true
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nDiveLength)
        and not J.IsLocationInChrono(botTarget:GetLocation())
        and not J.IsEnemyBlackHoleInLocation(botTarget:GetLocation())
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fHealthAfter > 0.3
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 800)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 800)
            if #nInRangeAlly >= #nInRangeEnemy then
                bot.icarus_dive_engage = true
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and not J.IsSuspiciousIllusion(enemy)
            and bot:WasRecentlyDamagedByAnyHero(3.0)
            and fHealthAfter > 0.15
            then
                if J.IsChasingTarget(enemy, bot) or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot) then
                    bot.icarus_dive_retreat = true
                    return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
                end
            end
        end

        if botHP < 0.5 and bot:WasRecentlyDamagedByTower(2.5)
        and not J.IsLateGame()
        and fHealthAfter > 0.2
        then
            bot.icarus_dive_retreat = true
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderIcarusDiveStop()
    if not J.CanCastAbility(IcarusDiveStop)
    or bot:HasModifier('modifier_phoenix_icarus_dive')
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if bot.icarus_dive_kill
    or bot.icarus_dive_engage then
        if DotaTime() > (IcarusDiveTime + IcarusDiveDuration) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bot.icarus_dive_stuck
    or bot.icarus_dive_retreat then
        if DotaTime() > (IcarusDiveTime + (IcarusDiveDuration / 2))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFireSpirits()
    if not J.CanCastAbility(FireSpirits)
    or bot:HasModifier('modifier_phoenix_icarus_dive')
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    or bot:HasModifier('modifier_phoenix_fire_spirit_count')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, FireSpirits:GetCastRange())
    local nCastPoint = FireSpirits:GetCastPoint()
	local nRadius = FireSpirits:GetSpecialValueInt('radius')
    local nHealthCost = (FireSpirits:GetSpecialValueInt('hp_cost_perc') / 100) * bot:GetHealth()
    local nDuration = FireSpirits:GetSpecialValueFloat('duration')
	local nDPS = FireSpirits:GetSpecialValueInt('damage_per_second')
    local nSpeed = FireSpirits:GetSpecialValueInt('spirit_speed')
    local nManaCost = FireSpirits:GetManaCost()
    local fHealthAfter = J.GetHealthAfter(nHealthCost)
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SunRay, Supernova})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {FireSpirits, SunRay, Supernova})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_phoenix_fire_spirit_burn')
        and fHealthAfter > 0.25
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, (nDuration / 0.2 - 1) * (nDPS * 0.2), DAMAGE_TYPE_MAGICAL, nDuration + eta) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        local target = nil
        local targetAttackDamage = 0
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsLocationInChrono(enemy:GetLocation())
            and not J.IsLocationInBlackHole(enemy:GetLocation())
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_phoenix_fire_spirit_burn') then
                local enemyAttackDamage = enemy:GetAttackDamage() * enemy:GetAttackSpeed()
                if enemyAttackDamage > targetAttackDamage then
                    target = enemy
                    targetAttackDamage = enemyAttackDamage
                end
            end
        end

        if target ~= nil and fManaAfter > fManaThreshold1 then
            if J.IsInLaningPhase() then
                for _, ally in pairs(nAllyHeroes) do
                    if J.IsValidHero(ally)
                    and not ally:IsIllusion()
                    and (J.IsAttacking(target) == ally or (J.IsChasingTarget(target, ally)) or target:GetAttackTarget() == ally)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            else
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and #nEnemyCreeps >= 4
        and #nEnemyHeroes == 0
        and fManaAfter > fManaThreshold2
        and fHealthAfter > 0.4
        and bAttacking
        and not J.DoesSomeoneHaveModifier(nEnemyCreeps, 'modifier_phoenix_fire_spirit_burn')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 3 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and #nEnemyCreeps >= 4
        and #nEnemyHeroes == 0
        and fManaAfter > fManaThreshold2
        and fHealthAfter > 0.4
        and bAttacking
        and not J.DoesSomeoneHaveModifier(nEnemyCreeps, 'modifier_phoenix_fire_spirit_burn')
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nCastPoint, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
        if #nInRangeEnemy == 0 and nLocationAoE.count >= 3 and #nAllyHeroes <= 2
        and not J.DoesSomeoneHaveModifier(nEnemyHeroes, 'modifier_phoenix_fire_spirit_burn')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and fHealthAfter > 0.4 and fManaAfter > fManaThreshold1 and bAttacking then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and not J.DoesSomeoneHaveModifier(nEnemyCreeps, 'modifier_phoenix_fire_spirit_burn')
        then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 2 and fManaAfter > fManaThreshold2)
                    or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                    or (nLocationAoE.count >= 3)
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.GetHP(botTarget) > 0.25
        and bAttacking
        and fHealthAfter > 0.6
        and fManaAfter > fManaThreshold1
        and not botTarget:HasModifier('modifier_phoenix_fire_spirit_burn')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fHealthAfter > 0.6
        and fManaAfter > fManaThreshold1
        and not botTarget:HasModifier('modifier_phoenix_fire_spirit_burn')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFireSpiritsLaunch()
    if not J.CanCastAbility(FireSpiritsLaunch)
    or bot:HasModifier('modifier_phoenix_icarus_dive')
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, FireSpirits:GetCastRange())
    local nCastPoint = FireSpirits:GetCastPoint()
	local nRadius = FireSpirits:GetSpecialValueInt('radius')
    local nSpeed = FireSpirits:GetSpecialValueInt('spirit_speed')
    local nDuration = FireSpirits:GetSpecialValueFloat('burn_duration')
	local nDPS = FireSpirits:GetSpecialValueInt('damage_per_second')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not enemyHero:HasModifier('modifier_phoenix_fire_spirit_burn')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, (nDuration / 0.2 - 1) * (nDPS * 0.2), DAMAGE_TYPE_MAGICAL, nDuration + eta)
            and eta > X.GetModifierTime(enemyHero, 'modifier_phoenix_fire_spirit_burn')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        local target = nil
        local targetAttackDamage = 0
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.CanBeAttacked(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsLocationInChrono(enemy:GetLocation())
            and not J.IsLocationInBlackHole(enemy:GetLocation())
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemy:HasModifier('modifier_phoenix_fire_spirit_burn') then
                local enemyAttackDamage = enemy:GetAttackDamage() * enemy:GetAttackSpeed()
                if enemyAttackDamage > targetAttackDamage then
                    target = enemy
                    targetAttackDamage = enemyAttackDamage
                end
            end
        end

        if target ~= nil then
            local eta = GetUnitToUnitDistance(bot, target) / nSpeed
            local vLocation = J.GetCorrectLoc(target, eta)
            local nLocationAoE = bot:FindAoELocation(true, true, vLocation, 0, nRadius, 0, 0)

            if DotaTime() > FireSpiritsLaunchTime + eta + 0.25
            and eta > X.GetModifierTime(target, 'modifier_phoenix_fire_spirit_burn')
            then
                if J.IsInLaningPhase() then
                    for _, ally in pairs(nAllyHeroes) do
                        if J.IsValidHero(ally)
                        and not ally:IsIllusion()
                        and (J.IsAttacking(target) == ally or (J.IsChasingTarget(target, ally)) or target:GetAttackTarget() == ally)
                        then
                            if nLocationAoE.count >= 2 then
                                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                            else
                                return BOT_ACTION_DESIRE_HIGH, vLocation
                            end
                        end
                    end
                else
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    else
                        return BOT_ACTION_DESIRE_HIGH, vLocation
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and bAttacking
        then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    if  nLocationAoE.count >= 4
                    and DotaTime() > FireSpiritsLaunchTime + eta + 0.25
                    and eta > X.GetModifierTime(creep, 'modifier_phoenix_fire_spirit_burn')
                    then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 2 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and bAttacking
        then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    if  nLocationAoE.count >= 4
                    and DotaTime() > FireSpiritsLaunchTime + eta + 0.25
                    and eta > X.GetModifierTime(creep, 'modifier_phoenix_fire_spirit_burn')
                    then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nCastPoint, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
        local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
        if #nInRangeEnemy == 0 and nLocationAoE.count >= 3 and #nAllyHeroes <= 2
        and J.IsValidHero(nEnemyHeroes[1])
        and DotaTime() > FireSpiritsLaunchTime + eta + 0.25
        and eta > X.GetModifierTime(nEnemyHeroes[1], 'modifier_phoenix_fire_spirit_burn')
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and bAttacking then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                    if (nLocationAoE.count >= 2)
                    or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                    then
                        if DotaTime() > FireSpiritsLaunchTime + eta + 0.25
                        and eta > X.GetModifierTime(creep, 'modifier_phoenix_fire_spirit_burn') then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                        end
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and bAttacking
        and not botTarget:HasModifier('modifier_phoenix_fire_spirit_burn')
        then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            if DotaTime() > FireSpiritsLaunchTime + eta + 0.25
            and eta > X.GetModifierTime(botTarget, 'modifier_phoenix_fire_spirit_burn') then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and not botTarget:HasModifier('modifier_phoenix_fire_spirit_burn')
        then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            if DotaTime() > FireSpiritsLaunchTime + eta + 0.25
            and eta > X.GetModifierTime(botTarget, 'modifier_phoenix_fire_spirit_burn') then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    if J.IsValid(nEnemyCreeps[1])
    and J.CanBeAttacked(nEnemyCreeps[1])
    and not J.IsRoshan(nEnemyCreeps[1])
    and not J.IsTormentor(nEnemyCreeps[1])
    and not J.IsRunning(nEnemyCreeps[1]) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                local eta = (GetUnitToLocationDistance(bot, nLocationAoE.targetloc) / nSpeed) + nCastPoint
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 1 and #nEnemyHeroes == 0)
                then
                    if DotaTime() > FireSpiritsLaunchTime + eta + 0.25
                    and eta > X.GetModifierTime(creep, 'modifier_phoenix_fire_spirit_burn') then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_phoenix_fire_spirit_burn')
        then
            local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSunRay()
    if not J.CanCastAbility(SunRay)
    or bot:HasModifier('modifier_phoenix_icarus_dive')
    or bot:HasModifier('modifier_phoenix_sun_ray')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, SunRay:GetCastRange())

    if bHasShardSupernova then
        local hTarget = nil
        local hTargetTargetCount = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange - 200)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_phoenix_fire_spirit_burn')
            then
                local nAllyHeroesTargetingEnemy = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
                if #nAllyHeroesTargetingEnemy > hTargetTargetCount then
                    hTarget = enemyHero
                    hTargetTargetCount = #nAllyHeroesTargetingEnemy
                end
            end
        end

        if hTarget ~= nil then
            local nInRangeAlly = J.GetAlliesNearLoc(hTarget:GetLocation(), 500)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 500)
            if #nInRangeEnemy <= 1 then
                for _, allyHero in pairs(nInRangeAlly) do
                    if J.IsValidHero(allyHero)
                    and bot ~= allyHero
                    and J.IsInRange(bot, allyHero, nCastRange - 200)
                    and not J.IsInRange(bot, allyHero, 400)
                    and J.IsCore(allyHero)
                    and J.GetHP(allyHero) < 0.5
                    and allyHero:WasRecentlyDamagedByAnyHero(4.0)
                    and not J.IsSuspiciousIllusion(allyHero)
                    and botHP > 0.4
                    and not J.IsRunning(allyHero)
                    and allyHero:GetUnitName() ~= 'npc_dota_hero_medusa'
                    then
                        if allyHero:IsStunned()
                        or allyHero:IsRooted()
                        or allyHero:IsHexed()
                        or allyHero:HasModifier('modifier_bane_fiends_grip')
                        or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        or allyHero:HasModifier('modifier_enigma_black_hole_pull') then
                            bot.sun_ray_heal_ally = true
                            bot.sun_ray_target = allyHero
                            return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
                        end
                    end
                end
            end

            bot.sun_ray_engage = true
            bot.sun_ray_target = hTarget
            return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
        end

        if J.IsValidHero(nEnemyHeroes[1]) then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), nEnemyHeroes[1]:GetLocation(), nCastRange)
        end

        return BOT_ACTION_DESIRE_NONE, nil
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 0.8)
        and J.CanCastOnNonMagicImmune(botTarget)
        and (not J.IsChasingTarget(bot, botTarget) or J.GetHP(botTarget) < 0.15)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
        and botHP > 0.4
        then
            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            if #nAllyHeroesTargetingTarget >= 2 then
                bot.sun_ray_engage = true
                bot.sun_ray_target = botTarget
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 500)
    if #nInRangeEnemy == 0 then
        for _, allyHero in pairs(nAllyHeroes) do
            if J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsInRange(bot, allyHero, nCastRange - 200)
            and not J.IsInRange(bot, allyHero, 400)
            and J.IsCore(allyHero)
            and J.GetHP(allyHero) < 0.5
            and allyHero:WasRecentlyDamagedByAnyHero(4.0)
            and not J.IsSuspiciousIllusion(allyHero)
            and botHP > 0.4
            and not (J.IsRetreating(bot) and J.IsRealInvisible(bot))
            and not J.IsRunning(allyHero)
            and allyHero:GetUnitName() ~= 'npc_dota_hero_medusa'
            then
                if allyHero:IsStunned()
                or allyHero:IsRooted()
                or allyHero:IsHexed()
                or allyHero:HasModifier('modifier_bane_fiends_grip')
                or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or allyHero:HasModifier('modifier_enigma_black_hole_pull') then
                    bot.sun_ray_heal_ally = true
                    bot.sun_ray_target = allyHero
                    return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSunRayStop()
    if not J.CanCastAbility(SunRayStop)
    or bot:HasModifier('modifier_phoenix_icarus_dive')
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
    local bIsTargeted = X.IsBeingAttackedByRealHero(nInRangeEnemy, bot)

    if bot.sun_ray_engage then
        if (bIsTargeted and botHP < 0.25 and bot:WasRecentlyDamagedByAnyHero(2.0))
        or (#nInRangeAlly + 1 < #nInRangeEnemy and bIsTargeted)
        or (#nInRangeAlly <= 1 and #nInRangeEnemy == 0)
        or (#nInRangeEnemy == 0 and not bot:WasRecentlyDamagedByAnyHero(3.0))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bot.sun_ray_heal_ally then
        if (bIsTargeted and botHP < 0.25 and bot:WasRecentlyDamagedByAnyHero(2.0))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if botHP < 0.15 then
        return BOT_ACTION_DESIRE_HIGH
    end

    if math.floor(DotaTime()) % 2 == 0 then
        if J.IsValidHero(bot.sun_ray_target)
        and not bot:IsFacingLocation(bot.sun_ray_target:GetLocation(), 45)
        and #nInRangeEnemy > 0
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderToggleMovement()
    if not J.CanCastAbility(ToggleMovement)
    or not bot:HasModifier('modifier_phoenix_sun_ray')
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE, false
    end

    local nBeamDistance = 1150
    local bIsToggled = ToggleMovement:GetToggleState()

    if J.IsValidHero(bot.sun_ray_target) then
        if not J.IsInRange(bot, bot.sun_ray_target, nBeamDistance) then
            if bIsToggled == false then
                return BOT_ACTION_DESIRE_HIGH, true
            end

            return BOT_ACTION_DESIRE_NONE, false
        end
    end

    if bIsToggled == true then
        return BOT_ACTION_DESIRE_HIGH, false
    end

    return BOT_ACTION_DESIRE_NONE, false
end

function X.ConsiderSupernova()
    if not J.CanCastAbility(Supernova)
    or bot:HasModifier('modifier_phoenix_supernova_hiding')
    then
        return BOT_ACTION_DESIRE_NONE, nil, false
    end

	local nCastRange = J.GetProperCastRange(false, bot, Supernova:GetCastRange())
	local nRadius = Supernova:GetSpecialValueInt('aura_radius')

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), (nRadius / 2) + 250)

        if #nInRangeEnemy >= 2 then
            if string.find(GetBot():GetUnitName(), 'phoenix') and bot:HasScepter() then
                for _, allyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(allyHero)
                    and bot ~= allyHero
                    and J.CanBeAttacked(allyHero)
                    and J.IsInRange(bot, allyHero, nCastRange)
                    and J.IsRetreating(allyHero)
                    and J.GetHP(allyHero) < 0.3
                    and allyHero:WasRecentlyDamagedByAnyHero(3.0)
                    and not J.IsSuspiciousIllusion(allyHero)
                    and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
                    and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
                    and not allyHero:HasModifier('modifier_item_aeon_disk_buff')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero, true
                    end
                end
            end

            if not (#nInRangeAlly >= #nInRangeEnemy + 2)
            and ((not J.CanCastAbility(FireSpirits) and not bot:HasModifier('modifier_phoenix_fire_spirit_count')) or botHP < 0.3 or #nInRangeEnemy >= 3)
            then
                if botHP < 0.15 and bot:WasRecentlyDamagedByAnyHero(1.0) and X.IsBeingAttackedByRealHero(nInRangeAlly, bot) then
                    return BOT_ACTION_DESIRE_HIGH, nil, false
                end

                local bIsThereEnemyCore = false
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if J.IsValidHero(enemyHero) and J.IsCore(enemyHero) then
                        bIsThereEnemyCore = true
                        break
                    end
                end

                if bIsThereEnemyCore then
                    return BOT_ACTION_DESIRE_HIGH, nil, false
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.IsBeingAttackedByRealHero(hUnitList, hUnit)
    for _, enemy in pairs(hUnitList)
    do
        if J.IsValidHero(enemy)
        and not J.IsSuspiciousIllusion(enemy)
        and (enemy:GetAttackTarget() == hUnit or J.IsChasingTarget(enemy, hUnit))
        then
            return true
        end
    end

    return false
end

function X.GetModifierTime(unit, sModifierName)
    if unit:HasModifier(sModifierName) then
        return unit:GetModifierRemainingDuration(unit:GetModifierByName(sModifierName))
    else
        return 0
    end
end

return X