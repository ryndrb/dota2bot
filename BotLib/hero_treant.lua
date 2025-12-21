local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_treant'
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
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_gauntlets",
            
                "item_magic_wand",
                "item_boots",
                "item_bracer",
                "item_phase_boots",
                "item_echo_sabre",
                "item_crimson_guard",--
                "item_black_king_bar",--
                "item_harpoon",--
                "item_blink",
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_overwhelming_blink",--
                "item_heart",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_blink",
                "item_magic_wand", "item_blink",
                "item_bracer", "item_ultimate_scepter",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_enchanted_mango",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_boots",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_solar_crest",--
                "item_blink",
                "item_aghanims_shard",
                "item_boots_of_bearing",--
                "item_orchid",--
                "item_lotus_orb",--
                "item_sheepstick",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_enchanted_mango",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_solar_crest",--
                "item_blink",
                "item_aghanims_shard",
                "item_guardian_greaves",--
                "item_orchid",--
                "item_lotus_orb",--
                "item_sheepstick",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
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

local NaturesGrasp      = bot:GetAbilityByName('treant_natures_grasp')
local LeechSeed         = bot:GetAbilityByName('treant_leech_seed')
local LivingArmor       = bot:GetAbilityByName('treant_living_armor')
-- local NaturesGuise      = bot:GetAbilityByName('treant_natures_guise')
local EyesInTheForest   = bot:GetAbilityByName('treant_eyes_in_the_forest')
local Overgrowth        = bot:GetAbilityByName('treant_overgrowth')

local NaturesGraspDesire, NaturesGraspLocation
local LeechSeedDesire, LeechSeedTarget
local LivingArmorDesire, LivingArmorTarget
local EyesInTheForestDesire, EyesInTheForestTarget
local OvergrowthDesire

local BlinkOvergrowthDesire, BlinkLocation

local EyesInTheForestCast = { time = 0, location = nil }

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    NaturesGrasp      = bot:GetAbilityByName('treant_natures_grasp')
    LeechSeed         = bot:GetAbilityByName('treant_leech_seed')
    LivingArmor       = bot:GetAbilityByName('treant_living_armor')
    EyesInTheForest   = bot:GetAbilityByName('treant_eyes_in_the_forest')
    Overgrowth        = bot:GetAbilityByName('treant_overgrowth')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    BlinkOvergrowthDesire, BlinkLocation = X.ConsiderBlinkOvergrowth()
    if BlinkOvergrowthDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkLocation)
        bot:ActionQueue_UseAbility(Overgrowth)
        return
    end

    OvergrowthDesire = X.ConsiderOvergrowth()
    if OvergrowthDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Overgrowth)
        return
    end

    NaturesGraspDesire, NaturesGraspLocation = X.ConsiderNaturesGrasp()
    if NaturesGraspDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(NaturesGrasp, NaturesGraspLocation)
        return
    end

    LeechSeedDesire, LeechSeedTarget = X.ConsiderLeechSeed()
    if LeechSeedDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LeechSeed, LeechSeedTarget)
        return
    end

    EyesInTheForestDesire, EyesInTheForestTarget = X.ConsiderEyesInTheForest()
    if EyesInTheForestDesire > 0
    then
        EyesInTheForestCast.time = DotaTime()
        EyesInTheForestCast.location = GetTreeLocation(EyesInTheForestTarget)
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnTree(EyesInTheForest, EyesInTheForestTarget)
        return
    end

    LivingArmorDesire, LivingArmorTarget = X.ConsiderLivingArmor()
    if LivingArmorDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LivingArmor, LivingArmorTarget)
        return
    end
end

function X.ConsiderNaturesGrasp()
    if not J.CanCastAbility(NaturesGrasp) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, NaturesGrasp:GetCastRange())
    local nRadius = NaturesGrasp:GetSpecialValueInt('latch_range')
    local nManaCost = NaturesGrasp:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {LeechSeed, LivingArmor, EyesInTheForest, Overgrowth})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {LeechSeed, Overgrowth})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Overgrowth})

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange * 0.8, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in ipairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
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
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
            and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, 1000)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if (J.IsChasingTarget(enemyHero, bot) and botHP < 0.75)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 + 0.1 and bAttacking and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(bot) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(bot) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange * 0.8, nRadius, 0, 0)
        if nLocationAoE.count >= 4 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsFarming(bot) and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) and fManaAfter > fManaThreshold2 + 0.15 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(bot) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
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
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderLeechSeed()
    if not J.CanCastAbility(LeechSeed)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, LeechSeed:GetCastRange())
    local nHealFlat = LeechSeed:GetSpecialValueInt('flat_heal')
    local nHealDamagePct = LeechSeed:GetSpecialValueInt('leech_heal') / 100
    local nHeal = nHealFlat + (bot:GetAttackDamage() * nHealDamagePct)

    local bIsAutoCasted = LeechSeed:GetAutoCastState()

    if bot:GetMaxHealth() - bot:GetHealth() > nHeal then
        if not bIsAutoCasted then
            LeechSeed:ToggleAutoCast()
        end
    else
        if bIsAutoCasted then
            LeechSeed:ToggleAutoCast()
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderLivingArmor()
    if not J.CanCastAbility(LivingArmor) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nHPS = LivingArmor:GetSpecialValueInt('heal_per_second')
    local nDuration = LivingArmor:GetSpecialValueInt('duration')
    local nManaCost = LivingArmor:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {LeechSeed, LivingArmor, Overgrowth})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Overgrowth})

    if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetScore = 0
        for _, allyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not J.IsMeepoClone(allyHero)
            and not allyHero:HasModifier('modifier_treant_living_armor')
            and not allyHero:HasModifier('modifier_fountain_aura')
            and J.GetHP(allyHero) < 0.8
            then
                local allyHeroScore = (allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()) * (1 / Min(1, allyHero:GetArmor()))
                if allyHeroScore > hTargetScore then
                    hTarget = allyHero
                    hTargetScore = allyHeroScore
                end
            end
        end

        if hTarget and fManaAfter > fManaThreshold2 then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

    if fManaAfter > fManaThreshold1 then
        for i = 1, 5 do
            local allyHero = GetTeamMember(i)
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not J.IsMeepoClone(allyHero)
            and not allyHero:HasModifier('modifier_treant_living_armor')
            and not allyHero:HasModifier('modifier_fountain_aura')
            then
                if allyHero:GetMaxHealth() - allyHero:GetHealth() > nHPS * nDuration then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end

        for _, building in pairs(GetUnitList(UNIT_LIST_ALLIED_BUILDINGS)) do
            if  J.IsValidBuilding(building)
            and J.CanBeAttacked(building)
            and not string.find(building:GetUnitName(), 'filler')
            and not building:HasModifier('modifier_treant_living_armor')
            then
                if building:GetMaxHealth() - building:GetHealth() > nHPS * nDuration then
                    return BOT_ACTION_DESIRE_HIGH, building
                end
            end
        end
    end

    if  botHP < 0.75
    and not bot:HasModifier('modifier_treant_living_armor')
    and not bot:HasModifier('modifier_fountain_aura')
    and fManaAfter > fManaThreshold2 + 0.2
    then
        return BOT_ACTION_DESIRE_HIGH, bot
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderEyesInTheForest()
    if not J.CanCastAbility(EyesInTheForest) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, EyesInTheForest:GetCastRange())
    local nRadius = EyesInTheForest:GetSpecialValueInt('vision_aoe')
    local nDuration = EyesInTheForest:GetSpecialValueInt('AbilityChargeRestoreTime')

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_treant_eyes_in_the_forest')
        then
            local nTrees = bot:GetNearbyTrees(nCastRange + 300)
            if nTrees then
                local vTreeLocation = GetTreeLocation(nTrees[1])
                if EyesInTheForestCast and EyesInTheForestCast.location ~= nil then
                    if ((J.GetDistance(vTreeLocation, EyesInTheForestCast.location) > (nRadius + nRadius / 2)) and (DotaTime() > EyesInTheForestCast.time + nDuration / 2)) then
                        return BOT_ACTION_DESIRE_HIGH, nTrees[1]
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, nTrees[1]
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderOvergrowth()
    if not J.CanCastAbility(Overgrowth) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = Overgrowth:GetSpecialValueInt('radius')
    local nDuration = Overgrowth:GetSpecialValueFloat('duration')

	if J.IsInTeamFight(bot, 1200) then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius * 0.95)
			and not enemyHero:IsStunned()
            and not enemyHero:IsRooted()
            and not enemyHero:IsHexed()
            and not enemyHero:IsNightmared()
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not J.IsSuspiciousIllusion(enemyHero)
			then
				if J.IsCore(enemyHero) then
					count = count + 1
				else
					count = count + 0.5
				end
			end
		end

		if count >= 1.5 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.5)
		and J.IsCore(botTarget)
		and not botTarget:IsStunned()
        and not botTarget:IsRooted()
        and not botTarget:IsHexed()
        and not botTarget:IsNightmared()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsLateGame()
        and bAttacking
		and botTarget:GetAttackTarget() == bot
		and J.GetHP(botTarget) < 0.4
		then
			if #nAllyHeroes <= 1 and #nEnemyHeroes <= 1 then
				if bot:GetEstimatedDamageToTarget(true, botTarget, nDuration * 1.5, DAMAGE_TYPE_ALL) > (botTarget:GetHealth() + botTarget:GetHealthRegen() * nDuration * 2) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlinkOvergrowth()
    if  J.CanCastAbility(Overgrowth) and J.CanBlinkDagger(GetBot())
    and bot:GetMana() > (Overgrowth:GetManaCost() + 150)
    then
        bot.shouldBlink = true
        local nRadius = Overgrowth:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200) and bot.Blink then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), bot.Blink:GetCastRange(), nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if  #nInRangeEnemy >= 2
            and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) > 600
            and GetUnitToLocationDistance(bot, J.GetEnemyFountain()) > 800
            then
                local count = 0
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and not enemyHero:IsStunned()
                    and not enemyHero:IsRooted()
                    and not enemyHero:IsHexed()
                    and not enemyHero:IsNightmared()
                    and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                    and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not J.IsSuspiciousIllusion(enemyHero)
                    then
                        if J.IsCore(enemyHero) then
                            count = count + 1
                        else
                            count = count + 0.5
                        end
                    end
                end

                if count >= 1.5 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

return X