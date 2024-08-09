local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_dragon_knight'
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
				[2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
				[3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_quelling_blade",
				"item_double_branches",
				"item_tango",
			
				"item_bracer",
				"item_power_treads",
				"item_magic_wand",
				"item_mage_slayer",--
				"item_manta",--
				"item_ultimate_scepter",
				"item_orchid",
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_greater_crit",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
				[2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
				[3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_bottle",
				"item_double_bracer",
				"item_boots",
				"item_magic_wand",
				"item_power_treads",
				"item_hand_of_midas",
				"item_blink",
				"item_manta",--
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_octarine_core",--
				"item_assault",--
				"item_travel_boots",
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bottle",
				"item_bracer",
				"item_magic_wand",
				"item_hand_of_midas",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,1,1,1,2,6,2,2,3,6},
				[2] = {2,3,3,1,1,6,1,1,2,2,2,6,3,3,6},
				[3] = {1,3,3,2,1,6,1,1,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_gauntlets",
				"item_circlet",
			
				"item_bracer",
				"item_boots",
				"item_magic_wand",
				"item_power_treads",
				"item_hand_of_midas",
				"item_blink",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_assault",--
				"item_octarine_core",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_travel_boots",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
			
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_hand_of_midas",
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


X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local abilityQ 	= bot:GetAbilityByName('dragon_knight_breathe_fire')
local abilityW 	= bot:GetAbilityByName('dragon_knight_dragon_tail')
local abilityAS = bot:GetAbilityByName('dragon_knight_fireball')
local abilityR 	= bot:GetAbilityByName('dragon_knight_elder_dragon_form')

local castQDesire, castQLocation
local castWDesire, castWTarget
local castRDesire
local castASDesire, castASTarget

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	abilityQ 	= bot:GetAbilityByName('dragon_knight_breathe_fire')
	abilityW 	= bot:GetAbilityByName('dragon_knight_dragon_tail')
	abilityAS 	= bot:GetAbilityByName('dragon_knight_fireball')
	abilityR 	= bot:GetAbilityByName('dragon_knight_elder_dragon_form')

	castRDesire = X.ConsiderR()
	if ( castRDesire > 0 )
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbility( abilityR )
		return
	end

	castQDesire, castQLocation = X.ConsiderQ()
	if ( castQDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnLocation( abilityQ, castQLocation )
		return
	end

	castWDesire, castWTarget = X.ConsiderW()
	if ( castWDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget )
		return
	end

	castASDesire, castASTarget = X.ConsiderAS()
	if ( castASDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnLocation( abilityAS, castASTarget )
		return
	end
end

function X.ConsiderQ()
	if ( not J.CanCastAbility(abilityQ) ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = abilityQ:GetSpecialValueInt( 'end_radius' )
	local nCastRange = abilityQ:GetSpecialValueInt( 'range' )
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = abilityQ:GetAbilityDamage()

    local nAllyHeroes = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE )
	local nEnemyHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
    local nCreeps = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE)
    local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 200, true )

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero(npcEnemy)
        and J.IsInRange(bot, npcEnemy, nCastRange + 150)
        and J.CanCastOnNonMagicImmune( npcEnemy )
        and J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL )
        and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
        and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
        and not npcEnemy:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	if J.IsFarming( bot ) and J.GetManaAfter(abilityQ:GetManaCost()) > 0.25
	then
        if nCreeps ~= nil and #nCreeps >= 2
        and J.IsValid(nCreeps[1])
        and nCreeps[1]:GetMagicResist() < 0.4
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nCreeps)
        end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 100, nRadius, 0, 0 )
		if ( locationAoE.count >= 2 )
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end

		if J.IsValidHero( nEnemyHeroes[1] )
        and J.IsInRange( bot, nEnemyHeroes[1], nCastRange - 100 )
        and J.CanCastOnNonMagicImmune( nEnemyHeroes[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
		end
	end

	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget ) and J.IsInRange( npcTarget, bot, nCastRange ) )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsTormentor( npcTarget ) and J.IsInRange( npcTarget, bot, nCastRange ) )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation()
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, nManaCost * 0.3 )
    and bot:GetLevel() >= 6
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		if laneCreepList ~= nil and #laneCreepList >= 2
        and nAllyHeroes ~= nil and #nAllyHeroes <= 2
        and J.CanBeAttacked( laneCreepList[1] )
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if ( locationAoE.count >= 2 and #laneCreepList >= 2  and bot:GetLevel() < 25 and #nAllyHeroes == 1 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end

			locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
			if ( locationAoE.count >= 4 and #laneCreepList >= 4 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius - 30, 0, 0 )
		if ( locationAoE.count >= 2 )
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end

		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange( npcEnemy, bot, nCastRange )
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
            and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not npcEnemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_PHYSICAL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetExtrapolatedLocation( nCastPoint )
		end
	end


	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and J.CanCastOnNonMagicImmune( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange - 100 )
        and not npcTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not npcTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not npcTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation( nCastPoint )
		end
	end

	if bot:GetLevel() < 18
	then
		if laneCreepList ~= nil and #laneCreepList >= 3
        and nAllyHeroes ~= nil and #nAllyHeroes < 3
        and J.CanBeAttacked(laneCreepList[1])
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if ( locationAoE.count >= 3 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderW()
	if ( not J.CanCastAbility(abilityW) ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = abilityW:GetCastRange()
	local nDamage = abilityW:GetAbilityDamage()

	if bot:GetAttackRange() > 300
	then
		nCastRange = 400
	end

    local npcTarget = J.GetProperTarget( bot )

	local nEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 240, true, BOT_MODE_NONE )

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero(npcEnemy)
        and J.IsInRange(bot, npcEnemy, nCastRange + 300)
        and J.CanCastOnNonMagicImmune( npcEnemy )
        and J.CanCastOnTargetAdvanced( npcEnemy )
        and ( J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL ) or npcEnemy:IsChanneling() )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsValidHero(nEnemyHeroes[1])
    then
		for i = 1, #nEnemyHeroes
        do
			if J.IsValidHero( nEnemyHeroes[i] )
            and J.IsInRange(bot, nEnemyHeroes[i], 800)
            and J.CanCastOnNonMagicImmune( nEnemyHeroes[i] )
            and J.CanCastOnTargetAdvanced( nEnemyHeroes[i] )
            and nEnemyHeroes[i]:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[i]
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and not J.IsDisabled( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange + 300)
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not npcEnemy:IsDisarmed()
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_ALL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end


	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero(nEnemyHeroes[1])
        and not J.IsDisabled( nEnemyHeroes[1] )
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange + 240)
        and J.CanCastOnNonMagicImmune( nEnemyHeroes[1] )
        and J.CanCastOnTargetAdvanced( nEnemyHeroes[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if ( J.IsRoshan( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange )
			and not J.IsDisabled( npcTarget ) )
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_LOW, npcTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_LOW, npcTarget
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( npcTarget )
        and not J.IsDisabled( npcTarget )
        and J.CanCastOnNonMagicImmune( npcTarget )
        and J.CanCastOnTargetAdvanced( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange + 240 )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderR()
	if ( not J.CanCastAbility(abilityR) or J.GetHP( bot ) < 0.25 ) then
		return BOT_ACTION_DESIRE_NONE
	end

	if ( J.IsPushing( bot ) or J.IsFarming( bot ) or J.IsDefending( bot ) )
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyCreeps( 800, true )
		local tableNearbyTowers = bot:GetNearbyTowers( 800, true )
		if #tableNearbyEnemyCreeps >= 2 or #tableNearbyTowers >= 1
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and J.IsInRange( npcTarget, bot, 800 )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderAS()
	if not J.CanCastAbility(abilityAS)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = abilityAS:GetSpecialValueInt('radius')
    local nCastRange = J.GetProperCastRange(false, bot, abilityAS:GetCastRange())

    local enemyHeroList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )

    if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
    then
        local targetHero = enemyHeroList[1]
        if J.IsValidHero( targetHero )
        and J.IsInRange(bot, targetHero, nRadius)
        and J.CanCastOnNonMagicImmune( targetHero )
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if J.IsInTeamFight( bot, 1400 )
    then
        local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
        if nAoeLoc ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, nAoeLoc
        end
    end

    if J.IsGoingOnSomeone( bot )
    then
        local targetHero = J.GetProperTarget( bot )
        if J.IsValidHero( targetHero )
        and J.IsInRange( bot, targetHero, nCastRange )
        and J.CanCastOnNonMagicImmune( targetHero )
        then
            return BOT_ACTION_DESIRE_HIGH, targetHero:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X