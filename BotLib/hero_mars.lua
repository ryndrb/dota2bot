local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_mars'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_lotus_orb", "item_nullifier", "item_pipe",}
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
				[1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
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
				"item_desolator",--
				"item_blink",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_satanic",--
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
			['sell_list'] = {
				"item_quelling_blade", "item_blink",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_assault",
				"item_bottle", "item_satanic",
			},
		}
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_soul_ring",
				"item_blink",
				sUtilityItem,--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_wind_waker",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_assault",
				"item_soul_ring", "item_wind_waker",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local SpearOfMars 	= bot:GetAbilityByName('mars_spear')
local GodsRebuke 	= bot:GetAbilityByName('mars_gods_rebuke')
local Bulwark 		= bot:GetAbilityByName('mars_bulwark')
local ArenaOfBlood 	= bot:GetAbilityByName('mars_arena_of_blood')

local SpearOfMarsDesire, SpearOfMarsLocation
local GodsRebukeDesire, GodsRebukeLocation
local BulwarkDesire, BulwarkLocation
local ArenaOfBloodDesire, ArenaOfBloodLocation

local SpearToAllyDesire, SpearToAllyLocation

local fArenaOfBloodCastTime = 0

local bAttacking = false
local botTarget, botHP, botMaxMana
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	SpearOfMars = bot:GetAbilityByName('mars_spear')
	GodsRebuke = bot:GetAbilityByName('mars_gods_rebuke')
	Bulwark = bot:GetAbilityByName('mars_bulwark')
	ArenaOfBlood = bot:GetAbilityByName('mars_arena_of_blood')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
	botMaxMana = bot:GetMaxMana()
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SpearToAllyDesire, SpearToAllyLocation, BlinkLocation = X.ConsiderSpearToAlly()
	if SpearToAllyDesire > 0 then
		bot:Action_ClearActions(true)

		local vTeamFightLocation = J.GetTeamFightLocation(bot)
		if vTeamFightLocation and J.GetDistance(vTeamFightLocation, BlinkLocation) <= 1200 then
			local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
			if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (SpearOfMars:GetManaCost() + BlackKingBar:GetManaCost() + 100)) then
				bot:ActionQueue_UseAbility(BlackKingBar)
				bot:ActionQueue_Delay(0.1)
			end
		end

		bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkLocation)
		bot:ActionQueue_Delay(0.1)
		bot:ActionQueue_UseAbilityOnLocation(SpearOfMars, SpearToAllyLocation)
		return
	end

	ArenaOfBloodDesire, ArenaOfBloodLocation = X.ConsiderArenaOfBlood()
	if ArenaOfBloodDesire > 0 then
		fArenaOfBloodCastTime = DotaTime()
		bot:Action_UseAbilityOnLocation(ArenaOfBlood, ArenaOfBloodLocation)
		return
	end

	GodsRebukeDesire, GodsRebukeLocation = X.ConsiderGodsRebuke()
	if GodsRebukeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:Action_UseAbilityOnLocation(GodsRebuke, GodsRebukeLocation)
		return
	end

	SpearOfMarsDesire, SpearOfMarsLocation = X.ConsiderSpearOfMars()
	if SpearOfMarsDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SpearOfMars, SpearOfMarsLocation)
		return
	end

	BulwarkDesire, BulwarkLocation, bToggle = X.ConsiderBulwark()
	if BulwarkDesire > 0 then
		if not bToggle then
			bot:Action_UseAbilityOnLocation(Bulwark, BulwarkLocation)
		else
			bot:Action_UseAbility(Bulwark)
		end
		return
	end
end

function X.ConsiderSpearOfMars()
	if not J.CanCastAbility(SpearOfMars) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = SpearOfMars:GetSpecialValueInt('spear_range')
	local nCastPoint = SpearOfMars:GetCastPoint()
	local nRadius = SpearOfMars:GetSpecialValueInt('spear_width')
	local nSpeed = SpearOfMars:GetSpecialValueInt('spear_speed')
	local nDamage = SpearOfMars:GetSpecialValueInt('damage')
	local nAbilityLevel = SpearOfMars:GetLevel()
	local nManaCost = SpearOfMars:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {GodsRebuke, ArenaOfBlood})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and (not J.IsChasingTarget(bot, botTarget) or J.IsInRange(bot, botTarget, nCastRange * 0.75))
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not J.CanCastAbilitySoon(bot.Blink, 2.0)
		then
			local vLocation = X.GetSpearToLocation(nCastRange, nRadius, nCastPoint, nSpeed, botTarget)
			if J.IsInLaningPhase() then
				if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, 5.0) > botTarget:GetHealth() then
					if vLocation then
						return BOT_ACTION_DESIRE_HIGH, vLocation
					end
				end
			else
				if vLocation and fManaAfter > fManaThreshold1 then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange * 0.6)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange, 1600), true)

	if J.IsPushing(bot)
	and not J.IsLateGame()
	and #nAllyHeroes <= 2
	and #nEnemyHeroes == 0
	and nAbilityLevel >= 3
	and fManaAfter > fManaThreshold1
	and fManaAfter > 0.5
	and bAttacking
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

	if J.IsDefending(bot)
	and #nAllyHeroes <= 3
	and #nEnemyHeroes == 0
	and nAbilityLevel >= 3
	and fManaAfter > fManaThreshold1
	and fManaAfter > 0.5
	and bAttacking
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

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and not J.IsLateGame() and bAttacking and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.IsInRange(bot, creep, nCastRange - 150)
			and not J.IsRunning(creep)
			and not J.IsOtherAllysTarget(creep)
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)

					if string.find(sCreepName, 'ranged') then
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
						end
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 2 and (#nEnemyHeroes > 0 or nLocationAoE.count >= 3) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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
        and bAttacking
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGodsRebuke()
    if not J.CanCastAbility(GodsRebuke) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local fCastPoint = GodsRebuke:GetCastPoint()
	local nRadius = GodsRebuke:GetSpecialValueInt('radius')
	local nBonusDamage = GodsRebuke:GetSpecialValueInt('bonus_damage_vs_heroes')
	local nCritMul = GodsRebuke:GetSpecialValueInt('crit_mult')
	local nDamage_G = bot:GetAttackDamage() * nCritMul / 100
	local nDamage_H = (bot:GetAttackDamage() + nBonusDamage) * nCritMul / 100
	local nAbilityLevel = GodsRebuke:GetLevel()
	local nManaCost = GodsRebuke:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SpearOfMars, ArenaOfBlood})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius - 75)
		and J.WillKillTarget(enemyHero, nDamage_H, DAMAGE_TYPE_PHYSICAL, fCastPoint)
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.CanCastAbility(SpearOfMars)
			and not J.IsDisabled(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius + 150, true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and fManaAfter > 0.5 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 4) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 4) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsFarming(bot)
	and nAbilityLevel >= 2
	and fManaAfter > fManaThreshold1
	and fManaAfter > 0.4
	and bAttacking
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
				if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 1 and creep:GetHealth() >= 800)
				then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if  J.IsValid(botTarget)
	and J.CanBeAttacked(botTarget)
	and J.IsInRange(bot, botTarget, nRadius * 2)
	and botTarget:IsCreep()
	and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
	and fManaAfter > fManaThreshold1 + 0.15
	and bAttacking
	and #nEnemyHeroes <= 1
	and not J.IsInLaningPhase()
	then
		return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
	end

	if J.IsLaning(bot)
	and J.IsInLaningPhase()
	and fManaAfter > fManaThreshold1 + 0.15
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.CanKillTarget(creep, nDamage_G, DAMAGE_TYPE_PHYSICAL)
			and not J.IsOtherAllysTarget(creep)
			then
				local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)
				if #nInRangeEnemy > 0 then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end

				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, 600, 0, nDamage_G)
				if nLocationAoE.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
		and fManaAfter > fManaThreshold1
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and fManaAfter > fManaThreshold1
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBulwark()
    if not J.CanCastAbility(Bulwark) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRange = Bulwark:GetSpecialValueInt('soldier_offset')
	local bToggleState = Bulwark:GetToggleState()

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if #nInRangeAlly >= 1 then
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanCastOnMagicImmune(enemyHero)
				and bot:IsFacingLocation(enemyHero:GetLocation(), 30)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not J.IsDisabled(enemyHero)
				and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
				then
					if #nInRangeEnemy > #nInRangeAlly then
						if bToggleState == false then
							return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), bToggleState
						end

						return BOT_ACTION_DESIRE_NONE
					end
				end
			end
		end
	end

	-- if J.IsGoingOnSomeone(bot) then
	-- 	if J.IsValidHero(botTarget)
	-- 	and J.CanBeAttacked(botTarget)
	-- 	and J.IsInRange(bot, botTarget, nRange)
	-- 	and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
	-- 	then
	-- 		if bot:HasScepter() then
	-- 			if bToggleState == false then
	-- 				if #nInRangeAlly >= #nInRangeEnemy + 1 then
	-- 					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
	-- 				end
	-- 			end

	-- 			return BOT_ACTION_DESIRE_NONE
	-- 		end
	-- 	end
	-- end

	if bToggleState == true then
		return BOT_ACTION_DESIRE_HIGH, 0, bToggleState
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderArenaOfBlood()
    if not J.CanCastAbility(ArenaOfBlood) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, ArenaOfBlood:GetCastRange())
	local nCastPoint = ArenaOfBlood:GetCastPoint()
	local nRadius = ArenaOfBlood:GetSpecialValueInt('radius')
	local nDuration = ArenaOfBlood:GetSpecialValueInt('duration')

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not enemyHero:IsMagicImmune()
				and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
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

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and not botTarget:IsMagicImmune()
		and J.IsInRange(bot, botTarget, nCastRange - 75)
		and J.IsCore(botTarget)
		and (J.IsAttacking(bot) or J.IsChasingTarget(bot, botTarget))
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsLocationInChrono(botTarget:GetLocation())
		and not J.IsLocationInBlackHole(botTarget:GetLocation())
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

			if #nInRangeAlly >= #nInRangeEnemy and not (#nInRangeAlly >= #nInRangeEnemy + 2)
			and J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, nDuration) > botTarget:GetHealth()
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsLateGame() then
        for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and not enemyHero:IsMagicImmune()
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.IsChasingTarget(enemyHero, bot)
			and bot:IsFacingLocation(J.GetTeamFountain(), 30)
			and botHP > 0.3
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_legion_commander_duel')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				local vEnemyLocation = enemyHero:GetLocation()
				local nInRangeAlly = J.GetAlliesNearLoc(vEnemyLocation, 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(vEnemyLocation, 1200)

				if #nInRangeEnemy >= #nInRangeAlly + 2 and #nInRangeAlly <= 1 then
					if not J.IsLocationInChrono(vEnemyLocation)
					and not J.IsLocationInBlackHole(vEnemyLocation)
					then
						return BOT_ACTION_DESIRE_HIGH, vEnemyLocation
					end
				end
			end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSpearToAlly()
    if J.CanBlinkDagger(bot) and J.CanCastAbility(SpearOfMars) and (bot:GetMana() > SpearOfMars:GetManaCost() + 100) then
		local nCastRange = J.GetProperCastRange(false, bot, SpearOfMars:GetCastRange())
		local fCastPoint = SpearOfMars:GetCastPoint()

		if J.IsGoingOnSomeone(bot) then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidTarget(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.IsInRange(bot, enemyHero, bot.Blink:GetCastRange() - 175)
				and not J.IsInRange(bot, enemyHero, 600)
				and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1200
				and not J.IsDisabled(enemyHero)
				and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemyHero:HasModifier('modifier_legion_commander_duel')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					local vEnemyHeroLocation = enemyHero:GetLocation()
					local nInRangeAlly = J.GetAlliesNearLoc(vEnemyHeroLocation, nCastRange)
					local nInRangeEnemy = J.GetEnemiesNearLoc(vEnemyHeroLocation, nCastRange)
					local hAllyTarget = X.GetBestAllyToReceiveSpeared(nInRangeAlly)

					if hAllyTarget and #nInRangeAlly >= #nInRangeEnemy then
						local vLocation = J.VectorAway(vEnemyHeroLocation, hAllyTarget:GetLocation(), 250)
						if GetUnitToLocationDistance(bot, vLocation) <= bot.Blink:GetCastRange() then
							return BOT_ACTION_DESIRE_HIGH, hAllyTarget:GetLocation(), vLocation
						end
					end
				end
			end
		end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.GetBestAllyToReceiveSpeared(hAllyList, hUnitTo)
	local target = nil
	local targetDist = 0
	for _, ally in pairs(hAllyList) do
		if J.IsValidHero(ally) and bot ~= ally and J.IsGoingOnSomeone(ally) then
			local nInRangeAlly = J.GetAlliesNearLoc(ally:GetLocation(), 800)
			local nInRangeEnemy = J.GetEnemiesNearLoc(ally:GetLocation(), 800)
			local allyDist = GetUnitToUnitDistance(ally, hUnitTo)
			if allyDist > targetDist and #nInRangeAlly >= #nInRangeEnemy then
				target = ally
				targetDist = allyDist
			end
		end
	end

	return target
end

function X.GetSpearToLocation(nCastRange, nRadius, nCastPoint, nSpeed, hTarget)
	local botLocation = bot:GetLocation()
	local hTargetLocation = J.GetCorrectLoc(hTarget, (GetUnitToUnitDistance(bot, hTarget) / nSpeed) + nCastPoint)
	-- local hTargetLocation = hTarget:GetLocation()
	local hTrees = bot:GetNearbyTrees(nCastRange * 0.6)

	if ArenaOfBlood and ArenaOfBlood:IsTrained() then
		local fElapsedTime = ArenaOfBlood:GetCooldown() - ArenaOfBlood:GetCooldownTimeRemaining()
		local radius = ArenaOfBlood:GetSpecialValueInt('radius') * 0.9
		if ArenaOfBloodLocation and type(ArenaOfBloodLocation) == 'userdata' and GetUnitToLocationDistance(bot, ArenaOfBloodLocation) <= radius then
			if fElapsedTime <= 7 then
				return hTargetLocation
			end
		end
	end

	-- impale to tree
	for _, tree in pairs(hTrees) do
		if tree then
			local vTreeLocation = GetTreeLocation(tree)
			local tResult = PointToLineDistance(botLocation, vTreeLocation, hTargetLocation)
			if tResult ~= nil and tResult.within and tResult.distance <= nRadius
			and (J.GetDistance(hTargetLocation, vTreeLocation) < GetUnitToLocationDistance(bot, vTreeLocation))
			then
				return vTreeLocation
			end
		end
	end

	-- impale to building
	for _, building in pairs(GetUnitList(UNIT_LIST_ALL)) do
		if J.IsValidBuilding(building)
		and J.IsInRange(bot, building, nCastRange * 0.6)
		then
			local vBuildingLocation = building:GetLocation()
			local tResult = PointToLineDistance(botLocation, vBuildingLocation, hTargetLocation)
			if tResult ~= nil and tResult.within and tResult.distance <= nRadius
			and (J.GetDistance(hTargetLocation, vBuildingLocation) < GetUnitToLocationDistance(bot, vBuildingLocation))
			then
				return vBuildingLocation
			end
		end
	end

	-- spear to ally
	return X.GetAllySpearLocation(nCastRange, nRadius, nCastPoint, nSpeed, hTarget)
end

function X.GetAllySpearLocation(nCastRange, nRadius, nCastPoint, nSpeed, hTarget)
	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
	local hTargetLocation = J.GetCorrectLoc(hTarget, (GetUnitToUnitDistance(bot, hTarget) / nSpeed) + nCastPoint)

	for _, ally in pairs(nInRangeAlly) do
		if J.IsValidHero(ally)
		and bot ~= ally
		and not J.IsRetreating(ally)
		and bot:DistanceFromFountain() > ally:DistanceFromFountain()
		then
			local nAllyInRangeAlly = ally:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
			local nAllyInRangeEnemy = ally:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local tResult = PointToLineDistance(bot:GetLocation(), ally:GetLocation(), hTargetLocation)

			if #nAllyInRangeAlly >= #nAllyInRangeEnemy
			and (tResult ~= nil and tResult.within and tResult.distance <= nRadius)
			and (GetUnitToUnitDistance(hTarget, ally) < GetUnitToUnitDistance(bot, ally))
			then
				return ally:GetLocation()
			end
		end
	end

	return nil
end

return X