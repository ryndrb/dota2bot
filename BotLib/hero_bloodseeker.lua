local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bloodseeker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {3,2,3,1,3,6,1,1,1,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_magic_wand",
				"item_wraith_band",
				"item_phase_boots",
				"item_maelstrom",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_basher",
				"item_aghanims_shard",
				"item_butterfly",--
				"item_abyssal_blade",--
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_monkey_king_bar",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_basher",
				"item_wraith_band", "item_butterfly",
				"item_magic_wand", "item_satanic",
				"item_phase_boots", "item_monkey_king_bar",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,2,3,1,3,6,1,1,1,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_magic_wand",
				"item_wraith_band",
				"item_phase_boots",
				"item_maelstrom",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_basher",
				"item_aghanims_shard",
				"item_butterfly",--
				"item_abyssal_blade",--
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_monkey_king_bar",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_basher",
				"item_wraith_band", "item_butterfly",
				"item_magic_wand", "item_satanic",
				"item_phase_boots", "item_monkey_king_bar",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_wraith_band",
				"item_phase_boots",
				"item_maelstrom",
				"item_rod_of_atos",
				sUtilityItem,--
				"item_mjollnir",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_sheepstick",--
			},
            ['sell_list'] = {
				"item_quelling_blade", sUtilityItem,
				"item_wraith_band", "item_black_king_bar",
				"item_magic_wand", "item_assault",
				"item_rod_of_atos", "item_abyssal_blade",
				"item_phase_boots", "item_sheepstick",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_melee_carry' }, {"item_power_treads", 'item_quelling_blade'} end

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

local Bloodrage = bot:GetAbilityByName('bloodseeker_bloodrage')
local Bloodrite = bot:GetAbilityByName('bloodseeker_blood_bath')
local BloodMist = bot:GetAbilityByName('bloodseeker_blood_mist')
local Thirst = bot:GetAbilityByName('bloodseeker_thirst')
local Rupture = bot:GetAbilityByName('bloodseeker_rupture')

local BloodrageDesire, BloodrageTarget
local BloodriteDesire, BloodriteLocation
local BloodMistDesire
local ThirstDesire
local RuptureDesire, RuptureTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Bloodrage = bot:GetAbilityByName('bloodseeker_bloodrage')
	Bloodrite = bot:GetAbilityByName('bloodseeker_blood_bath')
	BloodMist = bot:GetAbilityByName('bloodseeker_blood_mist')
	Thirst = bot:GetAbilityByName('bloodseeker_thirst')
	Rupture = bot:GetAbilityByName('bloodseeker_rupture')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	BloodMistDesire = X.ConsiderBloodMist()
	if BloodMistDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(BloodMist)
		return
	end

	RuptureDesire, RuptureTarget = X.ConsiderRupture()
	if RuptureDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Rupture, RuptureTarget)
		return
	end

	BloodrageDesire, BloodrageTarget = X.ConsiderBloodrage()
	if BloodrageDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Bloodrage, BloodrageTarget)
		return
	end

	ThirstDesire = X.ConsiderThirst()
	if ThirstDesire > 0 then
		bot:Action_UseAbility(Thirst)
		return
	end

	BloodriteDesire, BloodriteLocation = X.ConsiderBloodrite()
	if BloodriteDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Bloodrite, BloodriteLocation)
		return
	end
end

function X.ConsiderBloodrage()
	if not J.CanCastAbility(Bloodrage) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Bloodrage:GetCastRange())
	local nDuration = Bloodrage:GetSpecialValueInt('duration')
	local fMaxHealthDPS = Bloodrage:GetSpecialValueFloat('damage_pct')
	local fHealthAfter = J.GetHealthAfter(((fMaxHealthDPS / 100) * bot:GetHealth() * nDuration))

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetScore = 0

		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange + 300)
			and allyHero:GetAttackTarget() ~= nil
			and not J.IsSuspiciousIllusion(allyHero)
			and not J.IsRetreating(allyHero)
			and not allyHero:HasModifier('modifier_bloodseeker_bloodrage')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:IsDisarmed()
			then
				local fAllyHeroHealthAfter = J.GetHealthAfter(((fMaxHealthDPS / 100) * allyHero:GetHealth() * nDuration))
				local allyHeroScore = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
				if allyHeroScore > hTargetScore and fAllyHeroHealthAfter > 0.25 then
					hTarget = allyHero
					hTargetScore = allyHeroScore
				end
			end
		end

		if hTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not bot:HasModifier('modifier_bloodseeker_bloodrage')
		and not bot:IsDisarmed()
		and fHealthAfter > 0.2
		then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	if J.IsPushing(bot) and #nEnemyHeroes <= 1 and not bot:WasRecentlyDamagedByTower(4.0) and fHealthAfter > 0.25 and bAttacking then
		if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and not bot:HasModifier('modifier_bloodseeker_bloodrage')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
	if  J.IsValid(botTarget)
	and J.CanBeAttacked(botTarget)
	and botTarget:IsCreep()
	and fHealthAfter > 0.2 and bAttacking
	and #nEnemyHeroes <= 1
	and not bot:HasModifier('modifier_bloodseeker_bloodrage')
	then
		if #nEnemyCreeps >= 3
		or not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
		if ((J.IsRoshan(botTarget) and J.CanBeAttacked(botTarget)) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
		and #nAllyHeroes >= 3
		then
			local hTarget = nil
			local hTargetScore = 0

			for _, allyHero in pairs(nAllyHeroes) do
				if J.IsValidHero(allyHero)
				and J.IsInRange(bot, allyHero, nCastRange)
				and J.IsAttacking(allyHero)
				and not J.IsSuspiciousIllusion(allyHero)
				and not J.IsRetreating(allyHero)
				and not allyHero:HasModifier('modifier_bloodseeker_bloodrage')
				and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not allyHero:IsDisarmed()
				then
					local fAllyHeroHealthAfter = J.GetHealthAfter(((fMaxHealthDPS / 100) * allyHero:GetHealth() * nDuration))
					local allyHeroScore = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
					if allyHeroScore > hTargetScore and fAllyHeroHealthAfter > 0.25 then
						hTarget = allyHero
						hTargetScore = allyHeroScore
					end
				end
			end

			if hTarget ~= nil then
				return BOT_ACTION_DESIRE_HIGH, hTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBloodrite()
	if not J.CanCastAbility(Bloodrite) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Bloodrite:GetCastRange())
	local nCastPoint = Bloodrite:GetCastPoint()
	local nRadius = Bloodrite:GetSpecialValueInt('radius')
	local nDamage = Bloodrite:GetSpecialValueInt('damage')
	local nDelay = Bloodrite:GetSpecialValueFloat('delay')
	local nManaCost = Bloodrite:GetManaCost()
	local bHasBloodrage = bot:HasModifier('modifier_bloodseeker_bloodrage')
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Bloodrite, Rupture})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Rupture})

	local hTalent = bot:GetAbilityByName('special_bonus_unique_bloodseeker_rupture_charges')
	if hTalent and hTalent:IsTrained() then
		fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Bloodrite, Rupture, Rupture})
		fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Rupture, Rupture})
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and fManaAfter > fManaThreshold2
		then
			local eta = nDelay + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE, eta)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
			then
				if J.IsInRange(bot, enemyHero, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				else
					if not J.IsChasingTarget(bot, enemyHero) then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange)
					end
				end
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange - 200, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)
		if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not J.IsChasingTarget(bot, enemyHero)
				and not J.IsDisabled(enemyHero)
				and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not J.IsSuspiciousIllusion(enemyHero)
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
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and fManaAfter > fManaThreshold2
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
			if #nInRangeEnemy <= 1
			or (not botTarget:HasModifier('modifier_abaddon_borrowed_time')
				and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
				and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
				and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
				and not botTarget:HasModifier('modifier_item_aeon_disk_buff'))
			then
				local bChasingTarget = J.IsChasingTarget(bot, botTarget)
				if J.IsInRange(bot, botTarget, nCastRange) then
					if not bChasingTarget then
						return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
					else
						if J.IsInRange(bot, botTarget, nCastRange / 2) then
							return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay + nCastPoint)
						end
					end
				else
					if not bChasingTarget then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange)
					end
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:IsDisarmed()
			and not enemyHero:IsSilenced()
            then
                if (J.IsChasingTarget(enemyHero, bot) and botHP < 0.65)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    local vHalfLocation = (bot:GetLocation() + enemyHero:GetLocation()) / 2
                    local vLocation = (not J.IsInRange(bot, enemyHero, nCastRange / 2) and vHalfLocation) or bot:GetLocation()
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes <= 1 and not bHasBloodrage then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not bHasBloodrage then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange * 0.8, nRadius, 0, 0)
		if (nLocationAoE.count >= 3) then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold2 and not bHasBloodrage then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 1000 and fManaAfter > 0.65)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if  J.IsLaning(bot) and J.IsInLaningPhase()
    and fManaAfter > fManaThreshold1
    and bAttacking
    and #nAllyHeroes <= 2
    and #nEnemyHeroes == 0
	then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBloodMist()
	if not bot:HasScepter()
	or not J.CanCastAbility(BloodMist)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = BloodMist:GetSpecialValueInt('radius')

	if BloodMist:GetToggleState() == true
	then
		if J.GetHP(bot) < 0.2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not BloodMist:GetToggleState() == false
	and J.GetHP(bot) > 0.5
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderThirst()
	if not J.CanCastAbility(Thirst) then
		return BOT_ACTION_DESIRE_NONE
	end

	local bSomeoneUnhealthy = false
	for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
		if J.IsValidHero(enemy)
		and not J.IsSuspiciousIllusion(enemy)
		and J.GetHP(enemy) < 0.9
		then
			bSomeoneUnhealthy = true
			break
		end
	end

	if bSomeoneUnhealthy then
		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, 900)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
			and not botTarget:HasModifier('modifier_ursa_enrage')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsRetreating(bot) and J.CanBeAttacked(bot) and not J.IsRealInvisible(bot) then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero) and J.IsInRange(bot, enemyHero, 750) and J.IsChasingTarget(enemyHero, bot) then
					if (botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(3.0))
					or (#nEnemyHeroes > #nAllyHeroes)
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end

		if (J.IsFarming(bot) and #nEnemyHeroes == 0) or (J.IsLaning(bot) and not bot:WasRecentlyDamagedByAnyHero(2.0)) then
			local attackTarget = bot:GetAttackTarget()
			if J.IsValid(attackTarget)
			and attackTarget:IsCreep()
			and J.CanBeAttacked(attackTarget)
			and J.IsAttacking(bot)
			and botHP < 0.3
			and attackTarget:GetHealth() < bot:GetAttackDamage() * 1.5
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRupture()
	if not J.CanCastAbility(Rupture) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Rupture:GetCastRange())

	if J.IsInTeamFight(bot, 1200) then
        -- mobile heroes
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and X.IsMobileHero(enemyHero:GetUnitName())
            and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end

		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
			then
				local enemyHeroScore = (enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)) * 0.65
									 + (enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed() * 5.0) * 0.35
				if enemyHeroScore > hTargetScore then
					hTarget = enemyHero
					hTargetScore = enemyHeroScore
				end
			end
		end

		if hTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_bloodseeker_rupture')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
			and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsMobileHero(hName)
    local hMobileHeroList = {
		['npc_dota_hero_antimage'] = true,
        ['npc_dota_hero_earth_spirit'] = true,
        ['npc_dota_hero_night_stalker'] = true,
        ['npc_dota_hero_slardar'] = true,
        ['npc_dota_hero_spirit_breaker'] = true,
        ['npc_dota_hero_shredder'] = true,
        ['npc_dota_hero_ember_spirit'] = true,
        ['npc_dota_hero_morphling'] = true,
        ['npc_dota_hero_razor'] = true,
        ['npc_dota_hero_slark'] = true,
        ['npc_dota_hero_weaver'] = true,
        ['npc_dota_hero_storm_spirit'] = true,
        ['npc_dota_hero_batrider'] = true,
        ['npc_dota_hero_magnataur'] = true,
        ['npc_dota_hero_mirana'] = true,
        ['npc_dota_hero_pangolier'] = true,
        ['npc_dota_hero_windrunner'] = true,
    }

    if hMobileHeroList[hName] == nil then return false end

    return hMobileHeroList[hName]
end

return X