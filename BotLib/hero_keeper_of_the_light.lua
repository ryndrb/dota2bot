local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_keeper_of_the_light'
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
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_faerie_fire",
                "item_double_branches",
                "item_tango",
                "item_circlet",
                "item_mantle",
            
                "item_magic_wand",
                "item_boots",
                "item_null_talisman",
                "item_spirit_vessel",
                "item_dagon_2",
                "item_travel_boots",
                "item_octarine_core",--
                "item_black_king_bar",--
                "item_sheepstick",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_dagon_5",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_sheepstick",
                "item_spirit_vessel", "item_ultimate_scepter",
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
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_glimmer_cape",--
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_ultimate_scepter",
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_octarine_core",--
                "item_sheepstick",--
                "item_cyclone",
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick"
            },
        },
    },
    ['pos_5'] = {
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
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_glimmer_cape",--
                "item_mekansm",
                "item_solar_crest",--
                "item_ultimate_scepter",
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_octarine_core",--
                "item_sheepstick",--
                "item_cyclone",
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick"
            },
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

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end
end

end

local Illuminate    = bot:GetAbilityByName('keeper_of_the_light_illuminate')
local IlluminateEnd = bot:GetAbilityByName('keeper_of_the_light_illuminate_end')
local BlindingLight = bot:GetAbilityByName('keeper_of_the_light_blinding_light')
local ChakraMagic   = bot:GetAbilityByName('keeper_of_the_light_chakra_magic')
local SolarBind     = bot:GetAbilityByName('keeper_of_the_light_radiant_bind')
local Recall        = bot:GetAbilityByName('keeper_of_the_light_recall')
local WillOWisp     = bot:GetAbilityByName('keeper_of_the_light_will_o_wisp')
local SpiritForm    = bot:GetAbilityByName('keeper_of_the_light_spirit_form')

local IlluminateDesire, IlluminateLocation
local IlluminateEndDesire
local BlindingLightDesire, BlindingLightLocation
local ChakraMagicDesire, ChakraMagicTarget
local SolarBindDesire, SolarBindTarget
local RecallDesire, RecallTarget
local WillOWispDesire, WillOWispLocation
local SpiritFormDesire

local illuminate = { target = nil }

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Illuminate          = bot:GetAbilityByName('keeper_of_the_light_illuminate')
    IlluminateEnd       = bot:GetAbilityByName('keeper_of_the_light_illuminate_end')
    BlindingLight       = bot:GetAbilityByName('keeper_of_the_light_blinding_light')
    ChakraMagic         = bot:GetAbilityByName('keeper_of_the_light_chakra_magic')
    SolarBind           = bot:GetAbilityByName('keeper_of_the_light_radiant_bind')
    Recall              = bot:GetAbilityByName('keeper_of_the_light_recall')
    WillOWisp           = bot:GetAbilityByName('keeper_of_the_light_will_o_wisp')
    SpiritForm          = bot:GetAbilityByName('keeper_of_the_light_spirit_form')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    SpiritFormDesire = X.ConsiderSpiritForm()
    if SpiritFormDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SpiritForm)
        return
    end

    SolarBindDesire, SolarBindTarget = X.ConsiderSolarBind()
    if SolarBindDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SolarBind, SolarBindTarget)
        return
    end

    WillOWispDesire, WillOWispLocation = X.ConsiderWillOWisp()
    if WillOWispDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WillOWisp, WillOWispLocation)
        return
    end

    BlindingLightDesire, BlindingLightLocation = X.ConsiderBlindingLight()
    if BlindingLightDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BlindingLight, BlindingLightLocation)
        return
    end

    IlluminateEndDesire = X.ConsiderIlluminateEnd()
    if IlluminateEndDesire > 0
    then
        bot:Action_UseAbility(IlluminateEnd)
        return
    end

    IlluminateDesire, IlluminateLocation = X.ConsiderIlluminate()
    if IlluminateDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Illuminate, IlluminateLocation)
        return
    end

    ChakraMagicDesire, ChakraMagicTarget = X.ConsiderChakraMagic()
    if ChakraMagicDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ChakraMagic, ChakraMagicTarget)
        return
    end

    RecallDesire, RecallTarget = X.ConsiderRecall()
    if RecallDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Recall, RecallTarget)
        return
    end
end

function X.ConsiderIlluminate()
    if not J.CanCastAbility(Illuminate) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Illuminate:GetCastRange())
    local nTravelDist = Illuminate:GetSpecialValueInt('range')
    local nRadius = Illuminate:GetSpecialValueInt('radius')
    local nMaxDamage = Illuminate:GetSpecialValueInt('total_damage')
    local nSpeed = Illuminate:GetSpecialValueInt('speed')
    local nManaCost = Illuminate:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BlindingLight, SolarBind, Recall, WillOWisp, SpiritForm})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Illuminate, BlindingLight, SolarBind, Recall, WillOWisp, SpiritForm})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nTravelDist)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local eta = GetUnitToUnitDistance(bot, enemyHero) / nSpeed
            if J.WillKillTarget(enemyHero, nMaxDamage, DAMAGE_TYPE_MAGICAL, eta)
            and not J.IsChasingTarget(bot, enemyHero)
            and not J.IsRunning(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            then
                illuminate.target = enemyHero
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if J.IsInEtherealForm(enemyHero)
            or enemyHero:HasModifier('modifier_keeper_of_the_light_radiant_bind')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nTravelDist)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 500)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 1000)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if  J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
			and J.CanKillTarget(creep, nMaxDamage, DAMAGE_TYPE_MAGICAL)
			then
                if J.IsKeyWordUnit('ranged', creep) then
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 650, 0, 0)
                    if nLocationAoE.count > 0 then
                        illuminate.target = creep
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end

                if #nEnemyHeroes == 0 then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nMaxDamage)
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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
        and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIlluminateEnd()
    if not J.CanCastAbility(IlluminateEnd)
    or Illuminate == nil
    then
        illuminate.target = nil
        return BOT_ACTION_DESIRE_NONE
    end

    local nChannelTime = Illuminate:GetSpecialValueInt('max_channel_time')
    local nMaxDamage = Illuminate:GetSpecialValueInt('total_damage')
    local nDamage = RemapValClamped(Illuminate:GetCooldown() - Illuminate:GetCooldownTimeRemaining(), 0, nChannelTime, 0, nMaxDamage)

    if illuminate.target then
        if J.IsValid(illuminate.target) then
            if J.CanKillTarget(illuminate.target, nDamage, DAMAGE_TYPE_MAGICAL) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlindingLight()
    if not J.CanCastAbility(BlindingLight) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BlindingLight:GetCastRange())
	local nCastPoint = BlindingLight:GetCastPoint()
    local nDamage = BlindingLight:GetSpecialValueInt('damage')
    local nRadius = BlindingLight:GetSpecialValueInt('radius')
    local nAbilityLevel = BlindingLight:GetLevel()
    local nManaCost = BlindingLight:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Illuminate, SolarBind, Recall, WillOWisp, SpiritForm})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            local sEnemyHeroName = enemyHero:GetUnitName()

            if (enemyHero:HasModifier('modifier_troll_warlord_battle_trance') and J.IsAttacking(enemyHero))
            or (enemyHero:HasModifier('modifier_legion_commander_duel') and J.GetHP(enemyHero) > 0.25 and string.find(sEnemyHeroName, 'legion_commander'))
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsChasingTarget(bot, botTarget) then
                local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), nRadius / 2)
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.CanCastAbility(SolarBind)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nRadius)
            and J.IsChasingTarget(enemy, bot)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsDisabled(enemy)
            then
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemy:GetLocation()) / 2
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not allyHero:IsIllusion()
            then
                for _, enemy in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemy)
                    and J.IsInRange(allyHero, enemy, nRadius)
                    and J.IsChasingTarget(enemy, allyHero)
                    and J.CanCastOnNonMagicImmune(enemy)
                    and not J.IsDisabled(enemy)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
                    end
                end
            end
        end

        if not J.IsInLaningPhase() and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if (nLocationAoE.count >= 5) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and bAttacking and fManaAfter > fManaThreshold1 and nAbilityLevel >= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and nAbilityLevel >= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and nAbilityLevel >= 3 then
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

    if  J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 650, 0, 0)
                if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderChakraMagic()
    if not J.CanCastAbility(ChakraMagic) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, ChakraMagic:GetCastRange())
    local nManaRestore = ChakraMagic:GetSpecialValueInt('mana_restore')

	if (bot:GetMaxMana() - bot:GetMana()) > nManaRestore * 1.2 then
		return BOT_ACTION_DESIRE_HIGH, bot
	else
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsInRange(bot, allyHero, nCastRange)
            and not allyHero:IsIllusion()
            and ((allyHero:GetMaxMana() - allyHero:GetMana()) > nManaRestore * 1.3)
            then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSolarBind()
    if not J.CanCastAbility(SolarBind) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SolarBind:GetCastRange())
    local nManaCost = SolarBind:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Illuminate, BlindingLight, Recall, WillOWisp, SpiritForm})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and not J.CanCastAbility(BlindingLight)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 400)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.CanCastOnTargetAdvanced(enemy)
            and J.IsChasingTarget(enemy, bot)
            and not J.IsDisabled(enemy)
            then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end
        end
	end

    if not J.CanCastAbility(BlindingLight) then
        if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and bot ~= allyHero
                and J.IsInRange(bot, allyHero, nCastRange)
                and J.IsRetreating(allyHero)
                and not allyHero:IsIllusion()
                then
                    for _, enemy in pairs(nEnemyHeroes) do
                        if J.IsValidHero(enemy)
                        and J.IsInRange(bot, enemy, nCastRange)
                        and J.IsChasingTarget(enemy, allyHero)
                        and J.CanCastOnNonMagicImmune(enemy)
                        and J.CanCastOnTargetAdvanced(enemy)
                        and not J.IsDisabled(enemy)
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemy
                        end
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnTargetAdvanced(botTarget)
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

function X.ConsiderWillOWisp()
    if not J.CanCastAbility(WillOWisp) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, WillOWisp:GetCastRange())
    local nRadius = WillOWisp:GetSpecialValueInt('radius')

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 and (J.IsCore(nInRangeEnemy[1]) or J.IsCore(nInRangeEnemy[2])) then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSpiritForm()
    if not J.CanCastAbility(SpiritForm) then
        return BOT_ACTION_DESIRE_NONE
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and J.WeAreStronger(bot, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
        and not botTarget:HasModifier('modifier_ursa_enrage')
		then
            if J.IsInTeamFight(bot, 1200) or bot:GetEstimatedDamageToTarget(true, botTarget, 10.0, DAMAGE_TYPE_ALL) then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRecall()
    if not J.CanCastAbility(Recall) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nDelay = Recall:GetSpecialValueInt('teleport_delay')

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if J.IsValidHero(allyHero) and not allyHero:IsIllusion() and not J.IsMeepoClone(allyHero) then
            if not allyHero:WasRecentlyDamagedByAnyHero(nDelay + 1.0) then
                if  J.IsRetreating(allyHero)
                and J.GetHP(allyHero) < 0.25
                and allyHero:DistanceFromFountain() > 4500
                and bot:DistanceFromFountain() < 1600
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end

                if J.IsPushing(bot)
                and GetUnitToUnitDistance(bot, allyHero) > 4000
                and not J.IsFarming(allyHero)
                and not J.IsLaning(allyHero)
                and not J.IsDoingRoshan(allyHero)
                and not J.IsDoingTormentor(allyHero)
                and not J.IsDefending(allyHero)
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
                    if #nInRangeAlly >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X