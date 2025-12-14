local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bane'
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
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,2,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_faerie_fire",
			
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_hand_of_midas",
				"item_phylactery",
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_hurricane_pike",--
				"item_black_king_bar",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_dagon_5",--
				"item_sheepstick",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_circlet", "item_phylactery",
				"item_circlet", "item_ultimate_scepter",
				"item_magic_wand", "item_hurricane_pike",
				"item_bottle", "item_black_king_bar",
				"item_hand_of_midas", "item_dagon_5",
				"item_phylactery", "item_sheepstick",
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
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_faerie_fire",

				"item_magic_wand",
				"item_tranquil_boots",
				"item_aether_lens",
				"item_glimmer_cape",--
				"item_blink",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_ethereal_blade",--
				"item_arcane_blink",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_magic_stick",
				"item_faerie_fire",

				"item_magic_wand",
				"item_arcane_boots",
				"item_aether_lens",
				"item_glimmer_cape",--
				"item_blink",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_ethereal_blade",--
				"item_arcane_blink",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list


if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_priest' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local Enfeeble = bot:GetAbilityByName( 'bane_enfeeble' )
local BrainSap = bot:GetAbilityByName( 'bane_brain_sap' )
local Nightmare = bot:GetAbilityByName( 'bane_nightmare' )
local FiendsGrip = bot:GetAbilityByName( 'bane_fiends_grip' )

local EnfeebleDesire, EnfeebleTarget
local BrainSapDesire, BrainSapTarget
local NightmareDesire, NightmareTarget
local FiendsGripDesire, FiendsGripTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Enfeeble = bot:GetAbilityByName( 'bane_enfeeble' )
	BrainSap = bot:GetAbilityByName( 'bane_brain_sap' )
	Nightmare = bot:GetAbilityByName( 'bane_nightmare' )
	FiendsGrip = bot:GetAbilityByName( 'bane_fiends_grip' )

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	EnfeebleDesire, EnfeebleTarget = X.ConsiderEnfeeble()
    if EnfeebleDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Enfeeble, EnfeebleTarget)
        return
    end

	BrainSapDesire, BrainSapTarget = X.ConsiderBrainSap()
    if BrainSapDesire > 0 then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(BrainSap, BrainSapTarget)
        return
    end

	FiendsGripDesire, FiendsGripTarget = X.ConsiderFiendsGrip()
    if FiendsGripDesire > 0 then
        J.SetQueuePtToINT(bot, false)
		J.SetQueueToInvisible(bot)
        bot:ActionQueue_UseAbilityOnEntity(FiendsGrip, FiendsGripTarget)
        return
    end

	NightmareDesire, NightmareTarget = X.ConsiderNightmare()
	if NightmareDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Nightmare, NightmareTarget)
		return
	end
end

function X.ConsiderEnfeeble()
	if not J.CanCastAbility(Enfeeble) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Enfeeble:GetCastRange())
	local nManaCost = Enfeeble:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BrainSap, Nightmare, FiendsGrip})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {FiendsGrip})

    if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0

		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsMeepoClone(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_bane_enfeeble')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_teleporting')
			then
				local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_bane_enfeeble')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_teleporting')
		and fManaAfter > fManaThreshold2
        then
			return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.IsAttacking(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_bane_enfeeble')
			and not enemyHero:HasModifier('modifier_teleporting')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBrainSap()
	if not J.CanCastAbility(BrainSap) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, BrainSap:GetCastRange())
	local nRadius = BrainSap:GetSpecialValueInt('shard_radius')
	local nDamage = BrainSap:GetSpecialValueInt('brain_sap_damage')
	local nMissingHealth = bot:GetMaxHealth() - bot:GetHealth()
	local nManaCost = BrainSap:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Enfeeble, Nightmare, FiendsGrip})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and nMissingHealth > nDamage then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			then
				if bot:WasRecentlyDamagedByHero(enemyHero, 5.0) or (nMissingHealth > nDamage * 2) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end

		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)

		if #nInRangeEnemy == 0 and not J.IsEarlyGame() and (nMissingHealth > nDamage * 1.5) and not bot:WasRecentlyDamagedByAnyHero(3) then
			for _, creep in pairs(nEnemyCreeps) do
				if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.CanCastOnNonMagicImmune(creep)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRoshan(creep)
			and not J.IsTormentor(creep)
			then
				if  J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
				and not J.CanKillTarget(creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
				and nMissingHealth > nDamage
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end

				if nRadius > 0 then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 3) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRoshan(creep)
			and not J.IsTormentor(creep)
			then
				if  J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PURE)
				and not J.CanKillTarget(creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end

				if nRadius > 0 then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 3) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsRoshan(creep)
			and not J.IsTormentor(creep)
			then
				if not J.CanKillTarget(creep, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL) and nMissingHealth > nDamage then
					return BOT_ACTION_DESIRE_HIGH, creep
				end

				if nRadius > 0 then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 3)
					or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
					or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

    if  J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			and not J.IsOtherAllysTarget(creep)
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.38, DAMAGE_TYPE_PHYSICAL)
			then
				local sCreepName = creep:GetUnitName()
				local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

				if string.find(sCreepName, 'ranged') then
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 800) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
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

function X.ConsiderNightmare()
	if not J.CanCastAbility(Nightmare) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = Nightmare:GetCastRange()
	local nManaCost = Nightmare:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Enfeeble, BrainSap, FiendsGrip})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		and fManaAfter > fManaThreshold1
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0
		local nEnemyCount = 0

		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 150)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_ice_blast')
			and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			then
				if enemyHero:HasModifier('modifier_abaddon_borrowed_time') then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end

				nEnemyCount = nEnemyCount + 1
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(true, bot, 5.0, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget and nEnemyCount >= 2 then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
		then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
                and enemyHero ~= botTarget
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
				then
					local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 550)
					if #nInRangeAlly <= 1 then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end

			if  J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
            and J.IsChasingTarget(bot, botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.CanCastOnTargetAdvanced(botTarget)
			and not J.IsDisabled(botTarget)
			then
				local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 550)
				if #nInRangeAlly == 0 then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderFiendsGrip()
	if not J.CanCastAbility(FiendsGrip) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, FiendsGrip:GetCastRange())
	local nCastPoint = FiendsGrip:GetCastPoint()
	local nDamage = FiendsGrip:GetSpecialValueInt('fiend_grip_damage')
	local fTickInterval = FiendsGrip:GetSpecialValueFloat('fiend_grip_tick_interval')
	local fDuration = FiendsGrip:GetSpecialValueFloat('AbilityChannelTime')

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 550) then
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	if J.CanBeAttacked(bot) then
		if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, fDuration) > bot:GetHealth() then
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint + 0.1 then
				if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, fDuration) > enemyHero:GetHealth() then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if  J.IsInRange(bot, enemyHero, nCastRange + 75)
            and J.WillKillTarget(enemyHero, nDamage * (fDuration / fTickInterval), DAMAGE_TYPE_PURE, fDuration)
			and not J.IsHaveAegis(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0

		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 150)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(true, bot, fDuration, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage and #nAllyHeroesTargetingTarget >= 2 then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 75)
        and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, fDuration) > botTarget:GetHealth() then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X