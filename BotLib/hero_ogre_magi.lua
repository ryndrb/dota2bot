local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_ogre_magi'
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
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,2,2,1,2,7,2,1,1,1,7,3,3,3,7},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",

				"item_bottle",
				"item_magic_wand",
				"item_bracer",
				"item_phase_boots",
				"item_soul_ring",
				"item_hand_of_midas",
				"item_blade_mail",
				"item_black_king_bar",--
				"item_heart",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter",
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_hand_of_midas",
				"item_magic_wand", "item_blade_mail",
				"item_soul_ring", "item_black_king_bar",
				"item_bracer", "item_heart",
				"item_bottle", "item_shivas_guard",
				"item_hand_of_midas", "item_octarine_core",
				"item_blade_mail", "item_sheepstick",
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
                [1] = {2,1,2,3,2,7,3,1,1,1,7,3,3,2,7},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_magic_wand",
				"item_boots",
				"item_soul_ring",
				"item_hand_of_midas",
				"item_crimson_guard",--
				"item_heart",--
				sUtilityItem,--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", sUtilityItem,
				"item_soul_ring", "item_shivas_guard",
				"item_hand_of_midas", "item_sheepstick",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,7,2,1,1,1,7,3,3,3,7},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_enchanted_mango",
				"item_faerie_fire",
				"item_double_branches",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_aether_lens",
				"item_hand_of_midas",
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_assault",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_heart",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_ethereal_blade",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
				"item_hand_of_midas", "item_heart",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,7,2,1,1,1,7,3,3,3,7},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_enchanted_mango",
				"item_faerie_fire",
				"item_double_branches",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_aether_lens",
				"item_hand_of_midas",
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_assault",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_heart",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_ethereal_blade",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
				"item_hand_of_midas", "item_heart",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_OM' }, {"item_power_treads", 'item_quelling_blade'} end

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

local Fireblast = bot:GetAbilityByName('ogre_magi_fireblast')
local Ignite = bot:GetAbilityByName('ogre_magi_ignite')
local Bloodlust = bot:GetAbilityByName('ogre_magi_bloodlust')
local UnrefinedFireblast = bot:GetAbilityByName('ogre_magi_unrefined_fireblast')
local FireShield = bot:GetAbilityByName('ogre_magi_smash')
local Multicast = bot:GetAbilityByName('ogre_magi_multicast')

local FireblastDesire, FireblastTarget
local IgniteDesire, IgniteTarget
local BloodlustDesire, BloodlustTarget
local UnrefinedFireblastDesire, UnrefinedFireblastTarget
local FireShieldDesire, FireShieldTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Fireblast = bot:GetAbilityByName('ogre_magi_fireblast')
	Ignite = bot:GetAbilityByName('ogre_magi_ignite')
	Bloodlust = bot:GetAbilityByName('ogre_magi_bloodlust')
	UnrefinedFireblast = bot:GetAbilityByName('ogre_magi_unrefined_fireblast')
	FireShield = bot:GetAbilityByName('ogre_magi_smash')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	FireblastDesire, FireblastTarget = X.ConsiderFireblast()
	if FireblastDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Fireblast, FireblastTarget)
		return
	end

	IgniteDesire, IgniteTarget = X.ConsiderIgnite()
	if IgniteDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Ignite, IgniteTarget)
		return
	end

	BloodlustDesire, BloodlustTarget = X.ConsiderBloodlust()
	if BloodlustDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Bloodlust, BloodlustTarget)
		return
	end

	UnrefinedFireblastDesire, UnrefinedFireblastTarget = X.ConsiderUnrefinedFireblast()
	if UnrefinedFireblastDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(UnrefinedFireblast, UnrefinedFireblastTarget)
		return
	end

	FireShieldDesire, FireShieldTarget = X.ConsiderFireShield()
	if FireShieldDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FireShield, FireShieldTarget)
		return
	end
end

function X.ConsiderFireblast()
	if not J.CanCastAbility(Fireblast) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Fireblast:GetCastRange())
	local nCastPoint = Fireblast:GetCastPoint()
	local nDamage = Fireblast:GetSpecialValueInt('fireblast_damage')
	local nManaCost = Fireblast:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Fireblast, Ignite, Bloodlust})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Ignite, Bloodlust})

	local nAverageDamage = nDamage
	if Multicast and Multicast:IsTrained() then
		local p2x = Multicast:GetSpecialValueInt('multicast_2_times') / 100
		local p3x = Multicast:GetSpecialValueInt('multicast_3_times') / 100
		local p4x = Multicast:GetSpecialValueInt('multicast_4_times') / 100
		local p0x = 1 - p2x
		nAverageDamage = nDamage * ((1 * (p0x)) + (2 * (p2x - p3x)) + (3 * (p3x - p4x)) + (4 * (p4x)))
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.WillKillTarget(enemyHero, nAverageDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetPower = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local enemyHeroPower = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
				if enemyHeroPower > hTargetPower then
					hTarget = enemyHero
					hTargetPower = enemyHeroPower
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
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end

		if fManaAfter > fManaThreshold2 and not J.IsInTeamFight(bot, 1200) then
			for _, allyHero in pairs(nAllyHeroes) do
				if  J.IsValidHero(allyHero)
				and J.IsRetreating(allyHero)
				and bot ~= allyHero
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				and botHP > 0.5
				then
					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and J.CanCastOnTargetAdvanced(enemyHero)
						and J.IsChasingTarget(enemyHero, allyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and not J.IsDisabled(enemyHero)
						and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						then
							if #J.GetHeroesTargetingUnit(nEnemyHeroes, bot) <= 1 then
								return BOT_ACTION_DESIRE_HIGH, enemyHero
							end
						end
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot)
	and #nAllyHeroes <= 2
	and #nEnemyHeroes == 0
	and bAttacking
	and fManaAfter > fManaThreshold1
	and fManaAfter > 0.5
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not J.CanKillTarget(creep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged')
				or string.find(sCreepName, 'siege')
				or string.find(sCreepName, 'flagbearer')
				or fManaAfter > 0.75
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDefending(bot)
	and #nAllyHeroes <= 2
	and #nEnemyHeroes == 0
	and fManaAfter > fManaThreshold1
	and fManaAfter > 0.5
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not J.CanKillTarget(creep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged')
				or string.find(sCreepName, 'siege')
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 then
		local hTargetCreep = J.GetMostHpUnit(nEnemyCreeps)
		if J.IsValid(hTargetCreep)
		and J.CanBeAttacked(hTargetCreep)
		and not J.IsRoshan(hTargetCreep)
		and not J.IsTormentor(hTargetCreep)
		and bot:IsFacingLocation(hTargetCreep:GetLocation(), 60 )
		and not J.CanKillTarget(hTargetCreep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget(hTargetCreep, nDamage - 10, DAMAGE_TYPE_MAGICAL)
		then
			local sTargetCreepName = hTargetCreep:GetUnitName()
			if #nEnemyCreeps >= 2
			or hTargetCreep:IsAncientCreep()
			or string.find(sTargetCreepName, 'golem')
			then
				return BOT_ACTION_DESIRE_HIGH, hTargetCreep
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase()
	and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	and fManaAfter > fManaThreshold1
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not J.IsOtherAllysTarget(creep)
			then
				local sCreepName = creep:GetUnitName()
				if (string.find(sCreepName, 'ranged')) or fManaAfter > 0.75 then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderIgnite()
	if not J.CanCastAbility(Ignite) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Ignite:GetCastRange())
	local nCastPoint = Ignite:GetCastPoint()
	local nSearchRadius = 900 + (Ignite:GetLevel() - 1) * 100
	local nSpeed = Ignite:GetSpecialValueInt('projectile_speed')
	local nDuration = Ignite:GetSpecialValueInt('duration')
	local nDamage = Ignite:GetSpecialValueInt('burn_damage') * nDuration
	local nManaCost = Ignite:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Fireblast, Bloodlust})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Fireblast, Ignite, Bloodlust})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, nSearchRadius) then
		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			then
				local enemyHeroScore = enemyHero:GetActualIncomingDamage(nDamage * nDuration, DAMAGE_TYPE_MAGICAL) / enemyHero:GetHealth()
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
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nSearchRadius - 100)
			if fManaAfter > fManaThreshold1
			or #nInRangeEnemy >= 2 and J.IsChasingTarget(bot, botTarget)
			or J.GetHP(botTarget) < 0.6 and not J.IsChasingTarget(bot, botTarget)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nSearchRadius)
				if J.IsChasingTarget(enemyHero, bot)
				or (#nInRangeEnemy > #nAllyHeroes and #nInRangeEnemy >= 2 and botHP < 0.6 and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end

		if fManaAfter > fManaThreshold1 then
			for _, allyHero in pairs(nAllyHeroes) do
				if  J.IsValidHero(allyHero)
				and bot ~= allyHero
				and J.IsRetreating(allyHero)
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				and botHP > 0.5
				then
					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and J.CanCastOnTargetAdvanced(enemyHero)
						and J.IsChasingTarget(enemyHero, allyHero)
						and not J.IsDisabled(enemyHero)
						and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						and #J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
						then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and fManaAfter > 0.5 and fManaAfter > fManaThreshold2 and bAttacking and #nEnemyHeroes <= 1 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and #nEnemyCreeps >= 3
		then
			local nLocationAoE1 = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nSearchRadius, 0, nDamage * nDuration)
			local nLocationAoE2 = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nSearchRadius, 0, bot:GetAttackDamage() * 3)
			if  (nLocationAoE1.count <= 1 or (Multicast and Multicast:IsTrained() and nLocationAoE1.count >= 3))
			and (nLocationAoE2.count == 0)
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
			end
		end
	end

	if J.IsDefending(bot) and #nAllyHeroes <= 2 and fManaAfter > 0.5 and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and #nEnemyCreeps >= 4
		and bAttacking
		then
			local nLocationAoE1 = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nSearchRadius, 0, nDamage * nDuration)
			local nLocationAoE2 = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nSearchRadius, 0, bot:GetAttackDamage() * 3)
			if nLocationAoE1.count >= 2 and nLocationAoE2.count == 0 then
				return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
			end
		end

		if #nEnemyHeroes >= 2 then
			if J.IsValidHero(nEnemyHeroes[1]) and J.IsSuspiciousIllusion(nEnemyHeroes[1]) then
				return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
			end
		end
	end

	if J.IsFarming(bot) and #nAllyHeroes <= 2 and fManaAfter > 0.3 and fManaAfter > fManaThreshold2 and bAttacking then
		if  J.IsValid(nEnemyCreeps[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
		then
			local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nSearchRadius, 0, bot:GetAttackDamage() * 2.5)
			if nLocationAoE.count == 0 then
				return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold2
		and fManaAfter > 0.4
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold2
		and fManaAfter > 0.4
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBloodlust()
	if not J.CanCastAbility(Bloodlust) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Bloodlust:GetCastRange())
	local nManaCost = Bloodlust:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Fireblast, Ignite})

	local hAllyTarget = nil
	local hAllyTargetDamage = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and not J.IsSuspiciousIllusion(allyHero)
		and not J.IsDisabled(allyHero)
		and not allyHero:IsDisarmed()
		and not allyHero:HasModifier('modifier_ogre_magi_bloodlust')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_fountain_aura_buff')
		and allyHero:GetAttackDamage() > 0
		then
			local allyHeroDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
			if allyHeroDamage > hAllyTargetDamage then
				hAllyTarget = allyHero
				hAllyTargetDamage = allyHeroDamage
			end
		end
	end

	if J.IsGoingOnSomeone(bot) and hAllyTarget ~= nil then
		if hAllyTarget == bot then
			if J.IsValidHero(botTarget)
			and J.IsInRange(bot, botTarget, 900)
			then
				if J.CanBeAttacked(botTarget) or #nEnemyHeroes >= 2 then
					return BOT_ACTION_DESIRE_HIGH, hAllyTarget
				end
			end
		end

		if hAllyTarget ~= bot then
			local hAllyTarget_Target = hAllyTarget:GetAttackTarget()
			if J.IsValidHero(hAllyTarget_Target)
			and J.CanBeAttacked(hAllyTarget_Target)
			and J.IsInRange(hAllyTarget, hAllyTarget_Target, 900)
			then
				return BOT_ACTION_DESIRE_HIGH, hAllyTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:IsDisarmed()
			and not bot:HasModifier('modifier_ogre_magi_bloodlust')
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and botHP < 0.6 and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, bot
				end
			end
		end

		if fManaAfter > 0.3 and not J.IsInTeamFight(bot, 1200) then
			for _, allyHero in pairs(nAllyHeroes) do
				if  J.IsValidHero(allyHero)
				and J.IsRetreating(allyHero)
				and bot ~= allyHero
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				and not allyHero:HasModifier('modifier_ogre_magi_bloodlust')
				then
					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.IsChasingTarget(enemyHero, allyHero)
						and J.IsInRange(allyHero, enemyHero, 800)
						and not J.IsSuspiciousIllusion(enemyHero)
						and not J.IsDisabled(enemyHero)
						and not enemyHero:IsDisarmed()
						and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						then
							if #J.GetHeroesTargetingUnit(nEnemyHeroes, bot) <= 1 then
								return BOT_ACTION_DESIRE_HIGH, allyHero
							end
						end
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) and hAllyTarget ~= nil then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1000)
		and bAttacking
		and fManaAfter > 0.3
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, hAllyTarget
		end
	end

	if J.IsDoingTormentor(bot) and hAllyTarget ~= nil then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 1000)
        and bAttacking
		and fManaAfter > 0.3
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, hAllyTarget
		end
	end

	if not J.IsInLaningPhase() then
		hAllyTarget = nil
		hAllyTargetDamage = 0
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and not J.IsSuspiciousIllusion(allyHero)
			and not allyHero:IsDisarmed()
			and not allyHero:HasModifier('modifier_ogre_magi_bloodlust')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			and allyHero:GetAttackDamage() > 0
			then
				if J.IsPushing(allyHero) or J.IsDefending(allyHero) or J.IsFarming(allyHero) then
					local allyDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
					if allyDamage > hAllyTargetDamage then
						hAllyTarget = allyHero
						hAllyTargetDamage = allyDamage
					end
				end
			end
		end

		if hAllyTarget ~= nil then
			if hAllyTarget == bot then
				if fManaAfter > 0.4 and bAttacking then
					return BOT_ACTION_DESIRE_HIGH, hAllyTarget
				end
			end

			if hAllyTarget ~= bot and #nEnemyHeroes == 0 then
				if fManaAfter > 0.4 and fManaAfter > fManaThreshold1 then
					return BOT_ACTION_DESIRE_HIGH, hAllyTarget
				end
			end
		end

		local nAllyTowers = bot:GetNearbyTowers(Min(1600, nCastRange + 300), false)
		if J.IsValidBuilding(nAllyTowers[1])
		and not nAllyTowers[1]:HasModifier('modifier_ogre_magi_bloodlust')
		and not J.IsWithoutTarget(nAllyTowers[1])
		and #nEnemyHeroes >= 1
		then
			if J.IsDefending(bot) or fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, nAllyTowers[1]
			end
		end

		if fManaAfter > fManaThreshold1 then
			local nAllyCreeps = bot:GetNearbyCreeps(Min(1600, nCastRange + 300), false)
			for _, creep in pairs(nAllyCreeps) do
				if J.IsValid(creep)
				and not creep:HasModifier('modifier_ogre_magi_bloodlust')
				then
					local sCreepName = creep:GetUnitName()
					local hCreepTarget = creep:GetAttackTarget()
					local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 1200)

					if string.find(sCreepName, 'warlock_golem') and #nInRangeEnemy > 0 then
						return BOT_ACTION_DESIRE_HIGH, creep
					end

					if string.find(sCreepName, 'siege') and J.IsValidBuilding(hCreepTarget) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderUnrefinedFireblast()
	if J.CanCastAbility(Fireblast)
	or not J.CanCastAbility(UnrefinedFireblast) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, UnrefinedFireblast:GetCastRange())
	local nCastPoint = UnrefinedFireblast:GetCastPoint()
	local nDamage = UnrefinedFireblast:GetSpecialValueInt('base_damage') * UnrefinedFireblast:GetSpecialValueInt('str_multiplier')
	local nManaCost = (UnrefinedFireblast:GetSpecialValueInt('scepter_mana') / 100) * bot:GetMana()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Fireblast, Ignite, Bloodlust, FireShield})

	local nAverageDamage = nDamage
	if Multicast and Multicast:IsTrained() then
		local p2x = Multicast:GetSpecialValueInt('multicast_2_times') / 100
		local p3x = Multicast:GetSpecialValueInt('multicast_3_times') / 100
		local p4x = Multicast:GetSpecialValueInt('multicast_4_times') / 100
		local p0x = 1 - p2x
		nAverageDamage = nDamage * ((1 * (p0x)) + (2 * (p2x - p3x)) + (3 * (p3x - p4x)) + (4 * (p4x)))
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.WillKillTarget(enemyHero, nAverageDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetPower = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local enemyHeroPower = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
				if enemyHeroPower > hTargetPower then
					hTarget = enemyHero
					hTargetPower = enemyHeroPower
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
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if J.IsChasingTarget(enemyHero, bot) or #nEnemyHeroes > #nAllyHeroes and botHP < 0.6 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end

		if fManaAfter > fManaThreshold1 and not J.IsInTeamFight(bot, 1200) then
			for _, allyHero in pairs(nAllyHeroes) do
				if  J.IsValidHero(allyHero)
				and J.IsRetreating(allyHero)
				and bot ~= allyHero
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				and botHP > 0.5
				then
					for _, enemyHero in pairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and J.CanCastOnTargetAdvanced(enemyHero)
						and J.IsChasingTarget(enemyHero, allyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and not J.IsDisabled(enemyHero)
						and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
						then
							if #J.GetHeroesTargetingUnit(nEnemyHeroes, bot) <= 1 then
								return BOT_ACTION_DESIRE_HIGH, enemyHero
							end
						end
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsDefending(bot)
	and #nAllyHeroes <= 2
	and #nEnemyHeroes == 0
	and fManaAfter > 0.5
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not J.CanKillTarget(creep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged')
				or string.find(sCreepName, 'siege')
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFireShield()
	if not J.CanCastAbility(FireShield) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, FireShield:GetCastRange())

    for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not J.IsSuspiciousIllusion(allyHero)
		and not X.IsHaveShield(allyHero)
		then
			local nEnemyHeroes_Attacking = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)

			if  bot ~= allyHero
			and J.IsInRange(bot, allyHero, nCastRange + 400)
			and not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
			and allyHero:WasRecentlyDamagedByAnyHero(2.0)
			then
				if allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				or allyHero:HasModifier('modifier_enigma_black_hole_pull')
				or allyHero:HasModifier('modifier_legion_commander_duel')
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if J.IsDisabled(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and allyHero:WasRecentlyDamagedByAnyHero(2.0)
			and #nEnemyHeroes_Attacking >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if  J.IsRetreating(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and not J.IsRealInvisible(allyHero)
			and allyHero:WasRecentlyDamagedByAnyHero(1.0)
			and #nEnemyHeroes_Attacking >= 1
			then
				if #nEnemyHeroes > 0 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if  J.IsGoingOnSomeone(bot)
			and J.IsInRange(bot, allyHero, nCastRange + 300)
			and (J.IsCore(allyHero) or #nAllyHeroes > 1)
			then
				if #nEnemyHeroes_Attacking >= 1 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if not J.IsRealInvisible(bot) and #nEnemyHeroes_Attacking >= 3 then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.GetHP(allyHero) < 0.15 and J.IsInRange(bot, allyHero, nCastRange + 300) then
				if allyHero:WasRecentlyDamagedByAnyHero(2.0)
				or allyHero:WasRecentlyDamagedByCreep(1.0)
				or allyHero:WasRecentlyDamagedByTower(2.0)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	if J.IsDefending(bot) and #nAllyHeroes <= 2 then
		local nAllyTowers = bot:GetNearbyTowers(nCastRange + 300, false)
		if J.IsValidBuilding(nAllyTowers[1]) then
			local unitList = GetUnitList(UNIT_LIST_ENEMIES)
			local heroCount = 0
			local creepCount = 0
			for _, enemy in pairs(unitList) do
				if J.IsValid(enemy) and enemy:GetAttackTarget() == nAllyTowers[1] then
					local sEnemyName = enemy:GetUnitName()

					if enemy:IsHero() then
						if not J.IsSuspiciousIllusion(enemy)
						or (J.IsSuspiciousIllusion(enemy) and J.IsLateGame() and string.find(sEnemyName, 'naga_siren') or string.find(sEnemyName, 'terrorblade'))
						then
							heroCount = heroCount + 1
						elseif J.IsSuspiciousIllusion(enemy) then
							heroCount = heroCount + 0.5
						end
					end

					if enemy:IsCreep() then
						if string.find(sEnemyName, 'upgraded_mega') then
							creepCount = creepCount + 0.6
						elseif string.find(sEnemyName, 'upgraded') then
							creepCount = creepCount + 0.4
						else
							creepCount = creepCount + 0.2
						end
					end
				end
			end

			if heroCount >= 2 or creepCount >= 1.2 then
				return BOT_ACTION_DESIRE_HIGH, nAllyTowers[1]
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsHaveShield(hUnit)
	if J.IsValid(hUnit) then
		return hUnit:HasModifier('modifier_rune_shield')
			or hUnit:HasModifier('modifier_abaddon_aphotic_shield')
			or hUnit:HasModifier('modifier_item_solar_crest_armor_addition')
			or hUnit:HasModifier('modifier_ogre_magi_smash_buff')
			or hUnit:HasModifier('modifier_templar_assassin_refraction_absorb')
			or hUnit:HasModifier('modifier_ursa_enrage')
	end

	return false
end

return X