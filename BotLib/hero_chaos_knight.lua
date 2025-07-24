local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_chaos_knight'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd", "item_nullifier"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
	
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_armlet",
				"item_orchid",
				"item_manta",--
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_heart",--
				"item_aghanims_shard",
				"item_assault",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_manta",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_heart",
				"item_armlet", "item_travel_boots_2",
			},
        },
    },
    ['pos_2'] = {
		[1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
	
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_armlet",
				"item_orchid",
				"item_manta",--
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_heart",--
				"item_aghanims_shard",
				"item_assault",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_manta",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_heart",
				"item_armlet", "item_travel_boots_2",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
	
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_armlet",
				"item_crimson_guard",--
				"item_black_king_bar",--
				"item_assault",--
				"item_aghanims_shard",
				"item_heart",--
				"item_nullifier",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_assault",
				"item_bracer", "item_heart",
				"item_armlet", "item_travel_boots_2",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )


X['bDeafaultAbility'] = true
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local ChaosBolt = bot:GetAbilityByName('chaos_knight_chaos_bolt')
local RealityRift = bot:GetAbilityByName('chaos_knight_reality_rift')
local Phantasm = bot:GetAbilityByName('chaos_knight_phantasm')

local ChaosBoltDesire, ChaosBoltTarget
local RealityRiftDesire, RealityRiftTarget
local PhantasmDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility( bot ) then return end

	ChaosBolt = bot:GetAbilityByName('chaos_knight_chaos_bolt')
	RealityRift = bot:GetAbilityByName('chaos_knight_reality_rift')
	Phantasm = bot:GetAbilityByName('chaos_knight_phantasm')

	bAttacking = J.IsAttacking(bot)
	botHP = J.GetHP(bot)
	botTarget = J.GetProperTarget(bot)
	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	PhantasmDesire = X.ConsiderPhantasm()
    if PhantasmDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		local Armlet = J.IsItemAvailable('item_armlet')
        if J.CanCastAbility(Armlet) and Armlet:GetToggleState() == false then
            bot:ActionQueue_UseAbility(Armlet)
			bot:ActionQueue_UseAbility(Phantasm)
			return
		else
			bot:ActionQueue_UseAbility(Phantasm)
			return
        end
    end

	RealityRiftDesire, RealityRiftTarget = X.ConsiderRealityRift()
	if RealityRiftDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(RealityRift, RealityRiftTarget)
		return
	end

	ChaosBoltDesire, ChaosBoltTarget = X.ConsiderChaosBolt()
	if ChaosBoltDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ChaosBolt, ChaosBoltTarget)
		return
	end
end

function X.ConsiderChaosBolt()
	if not J.CanCastAbility(ChaosBolt) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, ChaosBolt:GetCastRange())
	local nCastPoint = ChaosBolt:GetCastPoint()
	local nProjectileSpeed = ChaosBolt:GetSpecialValueInt('chaos_bolt_speed')
	local nMinDamage = ChaosBolt:GetSpecialValueInt('damage_min')
	local nMaxDamage = ChaosBolt:GetSpecialValueInt('damage_max')
	local nManaCost = ChaosBolt:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ChaosBolt, RealityRift, Phantasm})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {RealityRift, Phantasm})

	for _, enemyHero in ipairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nProjectileSpeed) + nCastPoint
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.WillKillTarget(enemyHero, (nMinDamage + nMaxDamage) / 2, DAMAGE_TYPE_MAGICAL, eta)
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
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 3.0, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget ~= nil then
			if fManaAfter > fManaThreshold2 then
				return BOT_ACTION_DESIRE_HIGH, hTarget
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if not J.IsChasingTarget(bot, botTarget) then
				if fManaAfter > fManaThreshold2 then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			else
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
            then
				if J.IsChasingTarget(enemyHero, bot) or botHP < 0.5 or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold2 then
		local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.IsInRange(bot, creep, nCastRange)
			and J.CanBeAttacked(creep)
			and string.find(creep:GetUnitName(), 'ranged')
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nProjectileSpeed) + nCastPoint
				if J.WillKillTarget(creep, (nMinDamage + nMaxDamage) / 2, DAMAGE_TYPE_MAGICAL, eta) then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 500, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, true) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and J.GetHP(botTarget) > 0.2
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderRealityRift()
	if not J.CanCastAbility(RealityRift) or bot:IsRooted() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, RealityRift:GetCastRange())
	local botAttackRange = bot:GetAttackRange() + bot:GetBoundingRadius()
	local fManaAfter = J.GetManaAfter(RealityRift:GetManaCost())
	local bIgnoreMagicImmune = false

    if bot:GetUnitName() == 'npc_dota_hero_chaos_knight' then
        local hTalent = bot:GetAbilityByName('special_bonus_unique_chaos_knight')
        if hTalent ~= nil and hTalent:IsTrained() then
            bIgnoreMagicImmune = true
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not J.IsInRange(bot, botTarget, botAttackRange)
        and (bIgnoreMagicImmune or J.CanCastOnNonMagicImmune(botTarget))
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
			and not enemyHero:IsDisarmed()
            then
				if (J.IsChasingTarget(enemyHero, bot) and botHP < 0.75) or #nEnemyHeroes > #nAllyHeroes then
					for _, creep in ipairs(nEnemyCreeps) do
						if J.IsValid(creep)
						and not J.IsInRange(bot, creep, nCastRange * 0.6)
						and bot:IsFacingLocation(creep:GetLocation(), 30)
						and bot:IsFacingLocation(J.VectorAway(bot:GetLocation(), enemyHero:GetLocation(), 800), 45)
						then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end
				end
            end
        end
	end

	if J.IsFarming(bot)
	or ((J.IsPushing(bot) or J.IsDefending(bot) or (J.IsLaning(bot) and J.IsInLaningPhase())) and #nEnemyHeroes == 0)
	then
		if J.IsAttacking(bot) and fManaAfter > 0.5 then
			if J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and botTarget:IsCreep()
			and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
		and fManaAfter > 0.5
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPhantasm()
	if not J.CanCastAbility(Phantasm)
	or bot:DistanceFromFountain() < 500
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = 900
	local fManaAfter = J.GetManaAfter(Phantasm:GetManaCost())

    if RealityRift ~= nil and RealityRift:IsTrained() and RealityRift:GetCooldownTimeRemaining() < 3 and bot:GetMana() > (Phantasm:GetManaCost() + RealityRift:GetManaCost() + 75) then
        nRadius = 1200
    end

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 800)
			if botHP < 0.75 or J.GetHP(botTarget) > 0.5 or #nInRangeEnemy >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	local nEnemyTowers = bot:GetNearbyTowers(800, true)
	local nEnemyBarracks = bot:GetNearbyBarracks(400, true)
	local nAllyCreeps = bot:GetNearbyLaneCreeps(1200, false)

	if J.IsPushing(bot) and not J.IsEarlyGame() then
		if J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and (J.GetNumOfAliveHeroes(false) > J.GetNumOfAliveHeroes(true))
		then
			if (#nEnemyTowers >= 1 or #nEnemyBarracks >= 1 or botTarget == GetAncient(GetOpposingTeam())) and #nAllyCreeps >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and botHP > 0.5 then
		if J.IsValidHero(nEnemyHeroes[1])
		and J.IsInRange(bot, nEnemyHeroes[1], 800)
		and not nEnemyHeroes[1]:IsDisarmed()
		and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		and not J.IsInTeamFight(bot, 1200)
		and not (#nEnemyHeroes >= #nAllyHeroes + 3)
		then
			if J.IsChasingTarget(nEnemyHeroes[1], bot)
			or (#nEnemyHeroes > #nAllyHeroes and #J.GetHeroesTargetingUnit(nEnemyHeroes, bot) >= 2)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and J.CanBeAttacked(botTarget)
		and J.GetHP(botTarget) > 0.5
		and bot:GetNetWorth() < 20000
		and bAttacking
		and fManaAfter > 0.35
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and J.CanBeAttacked(botTarget)
		and bot:GetNetWorth() < 20000
		and bAttacking
		and fManaAfter > 0.35
		and not bot:HasModifier('modifier_item_crimson_guard_extra')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X