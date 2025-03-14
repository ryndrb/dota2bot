local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_ursa'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                [1] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
				"item_circlet",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_bfury",--
				"item_blink",
				"item_basher",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_ultimate_scepter",
				"item_satanic",--
				"item_swift_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_circlet", "item_black_king_bar",
				"item_magic_wand", "item_satanic",
			},
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
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_quelling_blade",
				"item_circlet",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_bfury",--
				"item_crimson_guard",--
				"item_blink",
				"item_black_king_bar",--
				"item_basher",
				"item_aghanims_shard",
				"item_abyssal_blade",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_circlet", "item_black_king_bar",
				"item_magic_wand", "item_basher",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

local Earthshock    = bot:GetAbilityByName( "ursa_earthshock" )
local Overpower     = bot:GetAbilityByName( "ursa_overpower" )
local FurySwipes    = bot:GetAbilityByName( "ursa_fury_swipes" )
local Enrage        = bot:GetAbilityByName( "ursa_enrage" )

local EarthshockDesire
local OverpowerDesire
local EnrageDesire

local nAllyHeroes, nEnemyHeroes
local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

	if bot:GetUnitName() == 'npc_dota_hero_rubick' then
		Earthshock    = bot:GetAbilityByName( "ursa_earthshock" )
		Overpower     = bot:GetAbilityByName( "ursa_overpower" )
		Enrage        = bot:GetAbilityByName( "ursa_enrage" )
    end

	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	botTarget = J.GetProperTarget(bot)

	EnrageDesire = X.ConsiderEnrage()
    if EnrageDesire > 0
	then
		bot:Action_UseAbility(Enrage)
		return
	end

	OverpowerDesire = X.ConsiderOverpower()
	if OverpowerDesire > 0
	then
		bot:Action_UseAbility(Overpower)
		return
	end

	EarthshockDesire = X.ConsiderEarthshock()
	if EarthshockDesire > 0
	then
		bot:Action_UseAbility(Earthshock)
		return
	end
end

function X.ConsiderEarthshock()
	if not J.CanCastAbility(Earthshock)
	or bot:HasModifier('modifier_ursa_earthshock_move')
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Earthshock:GetSpecialValueInt('shock_radius')
	local nLeapDuration = Earthshock:GetSpecialValueInt('hop_duration')
	local nDamage = Earthshock:GetAbilityDamage()
	local nManaAfter = J.GetManaAfter(Earthshock:GetManaCost())

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and bot:IsFacingLocation(enemyHero:GetLocation(), 15)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			if #nAllyHeroes >= #nEnemyHeroes and not J.IsRealInvisible(bot) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and bot:IsFacingLocation(botTarget:GetLocation(), 15)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			if (J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, nRadius) and J.IsInRange(bot, botTarget, nRadius * 2.5))
			or (J.IsInRange(bot, botTarget, nRadius) and J.CanCastOnNonMagicImmune(botTarget))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) and bot:IsFacingLocation(J.GetTeamFountain(), 30) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 700)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
				if J.GetHP(bot) < 0.7 or #nEnemyHeroes > #nAllyHeroes then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsLaning(bot) and not bot:WasRecentlyDamagedByAnyHero(4.0) then
		local nEnemyTowers = bot:GetNearbyTowers(1000, true)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
		if #nEnemyHeroes <= 1 and #nEnemyTowers == 0 and nManaAfter > 0.3 then
			for _, creep in pairs(nEnemyLaneCreeps) do
				if  J.IsValid(creep)
				and J.CanBeAttacked(creep)
				and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
				and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
				and bot:IsFacingLocation(creep:GetLocation(), 15)
				then
					bot:SetTarget(creep)
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if nManaAfter > 0.85
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)
			if nDistFromLane > 1600 then
				local vLocation = J.Site.GetXUnitsTowardsLocation(bot, nLaneFrontLocation, nRadius)
				if  IsLocationPassable(vLocation)
				and bot:IsFacingLocation(vLocation, 30)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
	local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
	if nLocationAoE.count >= 3
	and bot:IsFacingLocation(nLocationAoE.targetloc, 15)
	and J.IsValid(nEnemyCreeps[1])
	and J.CanBeAttacked(nEnemyCreeps[1])
	and not J.IsRunning(nEnemyCreeps[1])
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderOverpower()
	if not J.CanCastAbility(Overpower) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaAfter = J.GetManaAfter(Overpower:GetManaCost())
	local bAttacking = J.IsAttacking(bot)

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(500, true)
	if J.IsPushing(bot) and nManaAfter > 0.3 then
		if bAttacking then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
				if #nEnemyCreeps >= 3 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
			if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and nManaAfter > 0.25 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 2 or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep()) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange( botTarget, bot, 600)
		and J.CanBeAttacked(botTarget)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(botTarget, bot, 600)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEnrage()
	if not J.CanCastAbility(Enrage)
	or not J.CanBeAttacked(bot)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botHP = J.GetHP(bot)

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 700)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and (not bot:IsMagicImmune() or botHP < 0.7)
		and bot:WasRecentlyDamagedByAnyHero(2.0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		for _, enemyHero in pairs(nInRangeEnemy) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 800)
			and not J.IsSuspiciousIllusion(enemyHero)
			and (J.IsChasingTarget(enemyHero, bot) or enemyHero:GetAttackTarget() == bot)
			then
				if #nInRangeEnemy > #nInRangeAlly or botHP < 0.6 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsFarming(bot) and botHP < 0.25 then
		if  J.IsValid(botTarget)
		and botTarget:IsCreep()
		and J.IsInRange(bot, botTarget, 500)
		and bot:WasRecentlyDamagedByCreep(2.0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and botHP < 0.25
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and botHP < 0.3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X