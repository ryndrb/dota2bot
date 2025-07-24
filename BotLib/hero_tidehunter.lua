local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_tidehunter'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_lotus_orb", "item_heavens_halberd"}
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
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,2,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
		
				"item_magic_wand",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_vladmir",
				"item_pipe",--
				"item_blink",
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blink",
				"item_magic_wand", "item_shivas_guard",
				"item_soul_ring", "item_octarine_core",
				"item_vladmir", "item_overwhelming_blink",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_heavens_halberd", 'item_quelling_blade'} end

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

local Gush = bot:GetAbilityByName('tidehunter_gush')
local KrakenShell = bot:GetAbilityByName('tidehunter_kraken_shell')
local AnchorSmash = bot:GetAbilityByName('tidehunter_anchor_smash')
local DeadInTheWater = bot:GetAbilityByName('tidehunter_dead_in_the_water')
local Ravage = bot:GetAbilityByName('tidehunter_ravage')

local GushDesire, GushTarget
local KrakenShellDesire
local AnchorSmashDesire
local DeadInTheWaterDesire, DeadInTheWaterTarget
local RavageDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Gush = bot:GetAbilityByName('tidehunter_gush')
	KrakenShell = bot:GetAbilityByName('tidehunter_kraken_shell')
	AnchorSmash = bot:GetAbilityByName('tidehunter_anchor_smash')
	DeadInTheWater = bot:GetAbilityByName('tidehunter_dead_in_the_water')
	Ravage = bot:GetAbilityByName('tidehunter_ravage')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	RavageDesire = X.ConsiderRavage()
	if RavageDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Ravage)
		return
	end

	GushDesire, GushTarget, bTargetGround = X.ConsiderGush()
	if GushDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		if bot:HasScepter() and bTargetGround then
			bot:ActionQueue_UseAbilityOnLocation(Gush, GushTarget)
		else
			bot:ActionQueue_UseAbilityOnEntity(Gush, GushTarget)
		end
		return
	end

	AnchorSmashDesire = X.ConsiderAnchorSmash()
	if AnchorSmashDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:Action_UseAbility(AnchorSmash)
		return
	end

	DeadInTheWaterDesire, DeadInTheWaterTarget = X.ConsiderDeadInTheWater()
	if DeadInTheWaterDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(DeadInTheWater, DeadInTheWaterTarget)
		return
	end

	KrakenShellDesire = X.ConsiderKrakenShell()
	if KrakenShellDesire > 0 then
		bot:Action_UseAbility(KrakenShell)
		return
	end
end

function X.ConsiderGush()
	if not J.CanCastAbility(Gush) then
		return BOT_ACTION_DESIRE_NONE, nil, false
	end

	local nCastRange = J.GetProperCastRange(false, bot, Gush:GetCastRange())
	local nCastPoint = Gush:GetCastPoint()
	local nRadius = 260
	local nDamage = Gush:GetSpecialValueInt('gush_damage')
	local nSpeed = Gush:GetSpecialValueInt('projectile_speed')
	local nManaCost = Gush:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {KrakenShell, AnchorSmash, DeadInTheWater, Ravage})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {AnchorSmash, DeadInTheWater, Ravage})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Ravage})
	local fManaThreshold4 = J.GetManaThreshold(bot, nManaCost, {AnchorSmash, Ravage})
	local bHasScepter = bot:HasScepter()

	if bHasScepter then
		nSpeed = 1500
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and (bHasScepter or J.CanCastOnTargetAdvanced(enemyHero))
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) and fManaAfter > fManaThreshold3 then
				return BOT_ACTION_DESIRE_HIGH, (bHasScepter and J.GetCorrectLoc(enemyHero, eta) or enemyHero), bHasScepter
            end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and fManaAfter > fManaThreshold3
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			return BOT_ACTION_DESIRE_HIGH, (bHasScepter and J.GetCorrectLoc(botTarget, eta) or botTarget), bHasScepter
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, (bHasScepter and enemyHero:GetLocation() or enemyHero), bHasScepter
				end
			end
		end

		if fManaAfter > fManaThreshold2 and not J.IsInTeamFight(bot, 1200) then
			for _, allyHero in pairs(nAllyHeroes) do
				if  bot ~= allyHero
				and J.IsValidHero(allyHero)
				and J.IsRetreating(allyHero)
				and allyHero:WasRecentlyDamagedByAnyHero(3.0)
				and not J.IsSuspiciousIllusion(allyHero)
				then
					for _, enemyHero in ipairs(nEnemyHeroes) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and J.CanCastOnTargetAdvanced(enemyHero)
						and J.IsInRange(bot, enemyHero, nCastRange)
						and J.IsChasingTarget(enemyHero, allyHero)
						and not J.IsDisabled(enemyHero)
						and not enemyHero:IsDisarmed()
						then
							return BOT_ACTION_DESIRE_HIGH, (bHasScepter and enemyHero:GetLocation() or enemyHero), bHasScepter
						end
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and bAttacking and fManaAfter > fManaThreshold1 + (nManaCost / bot:GetMaxMana()) then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
				local sCreepName = creep:GetUnitName()

				if bHasScepter then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 4) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
					end
				else
					local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
					if  J.IsInRange(bot, creep, nCastRange)
					and string.find(sCreepName, 'ranged')
					and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta)
					and not J.CanKillTarget(creep, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
					and J.CanCastOnNonMagicImmune(creep)
					and J.CanCastOnTargetAdvanced(creep)
					then
						return BOT_ACTION_DESIRE_HIGH, creep, false
					end
				end
			end
		end
	end

	if J.IsDefending(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and #nEnemyHeroes == 0 then
				local sCreepName = creep:GetUnitName()

				if bHasScepter then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 4) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
					end
				else
					if  J.IsInRange(bot, creep, nCastRange)
					and (string.find(sCreepName, 'ranged') or string.find(sCreepName, 'siege'))
					and not J.CanKillTarget(creep, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
					and J.CanCastOnNonMagicImmune(creep)
					and J.CanCastOnTargetAdvanced(creep)
					then
						return BOT_ACTION_DESIRE_HIGH, creep, false
					end
				end
			end
		end

		if bHasScepter then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold4 then
		if bHasScepter then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 4)
					or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
					then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
					end
				end
			end
		else
			if  J.IsValid(botTarget)
			and botTarget:IsCreep()
			and J.IsInRange(bot, botTarget, nCastRange)
			and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 2.5, DAMAGE_TYPE_PHYSICAL)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget, false
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase()
	and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	and fManaAfter > fManaThreshold4
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep)
			and J.IsInRange(bot, creep, nCastRange)
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged') then
					local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
					if  J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta)
					and J.CanCastOnNonMagicImmune(creep)
					and J.CanCastOnTargetAdvanced(creep)
					then
						local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 600)
						if #nInRangeEnemy > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH, (bHasScepter and creep:GetLocation() or creep), bHasScepter
						end
					end
				end

				if bHasScepter then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 3 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, (bHasScepter and botTarget:GetLocation() or botTarget), bHasScepter
		end
	end

	if J.IsDoingTormentor( bot ) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, (bHasScepter and botTarget:GetLocation() or botTarget), bHasScepter
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil, false
end

function X.ConsiderKrakenShell()
	if not J.CanCastAbility(KrakenShell) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and botHP < 0.6
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if botHP < 0.8 and bot:WasRecentlyDamagedByAnyHero(2.0) and #nEnemyHeroesTargetingMe >= 3 then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and botTarget:GetAttackTarget() == bot
		and bAttacking
		and botHP < 0.3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
		and botHP < 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderAnchorSmash()
	if not J.CanCastAbility(AnchorSmash) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = AnchorSmash:GetCastPoint()
	local nRadius = AnchorSmash:GetSpecialValueInt('radius')
	local nDamage = AnchorSmash:GetSpecialValueInt( 'attack_damage' ) + bot:GetAttackDamage()
	local nManaCost = AnchorSmash:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Gush, DeadInTheWater, Ravage})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Gush, AnchorSmash, DeadInTheWater, Ravage})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Ravage})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 50)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold3
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius - 50)
			if not botTarget:IsDisarmed() or #nInRangeEnemy > 1 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating( bot ) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValid(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius - 50)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius - 50, 0, 0)
		if nLocationAoE.count >= 4 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 3 and fManaAfter > fManaThreshold2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and fManaAfter > 0.65) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and fManaAfter > 0.65) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold3 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 or nEnemyCreeps[1]:IsAncientCreep() then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase()
	and fManaAfter > fManaThreshold3
	then
		local nCanKillMeleeCount = 0
		local nCanKillRangeCount = 0
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

		for _, creep in pairs(nEnemyLaneCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
				local sCreepName = creep:GetUnitName()
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint) then
					if string.find(sCreepName, 'range') then
						nCanKillRangeCount = nCanKillRangeCount + 1
					end

					if string.find(sCreepName, 'melee') or string.find(sCreepName, 'siege') then
						nCanKillMeleeCount = nCanKillMeleeCount + 1
					end
				end
			end
		end

		if (nCanKillMeleeCount + nCanKillRangeCount >= 3)
		or (nCanKillMeleeCount >= 1 and nCanKillRangeCount >= 1 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if #nEnemyLaneCreeps <= 1
		and J.IsValidHero(nEnemyHeroes[1])
		and J.CanBeAttacked(nEnemyCreeps[1])
		and J.IsInRange(bot, nEnemyHeroes[1], nRadius - 50)
		and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		and not nEnemyHeroes[1]:IsDisarmed()
		and fManaAfter > 0.65
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:IsDisarmed()
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
	if nLocationAoE.count >= 5 and fManaAfter > fManaThreshold3 then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDeadInTheWater()
	if not J.CanCastAbility(DeadInTheWater) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, DeadInTheWater:GetCastRange())
	local nManaCost = DeadInTheWater:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Ravage})

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange * 2)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and fManaAfter > fManaThreshold1 + 0.1
		then
			if J.IsChasingTarget(bot, botTarget) or #nEnemyHeroes > #nAllyHeroes then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		if not J.CanCastAbility(Gush) and not J.CanCastAbility(AnchorSmash) and fManaAfter > fManaThreshold1 then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValid(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.CanCastOnTargetAdvanced(enemyHero)
				and not J.IsDisabled(enemyHero)
				and not enemyHero:IsDisarmed()
				then
					if J.IsChasingTarget(enemyHero, bot)
					or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderRavage()
	if not J.CanCastAbility(Ravage) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Ravage:GetSpecialValueInt('radius')
	local nCastPoint = Ravage:GetCastPoint()
	local nDamage = Ravage:GetSpecialValueInt('#AbilityDamage')
	local nSpeed = Ravage:GetSpecialValueInt('speed')
	local nDuration = Ravage:GetSpecialValueFloat('duration')

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius * 0.8)
		and J.IsCore(enemyHero)
		and not enemyHero:IsMagicImmune()
		and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if  enemyHero:HasModifier('modifier_teleporting')
			and J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta
			and #nAllyHeroesAttackingTarget >= 3
			and not J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local count = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius * 0.8)
			and not enemyHero:IsMagicImmune()
			and not enemyHero:IsStunned()
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
		and not botTarget:IsMagicImmune()
		and not botTarget:IsStunned()
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

return X