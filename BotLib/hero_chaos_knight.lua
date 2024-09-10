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
	
				"item_bracer",
				"item_power_treads",
				"item_magic_wand",
				"item_armlet",
				"item_orchid",
				"item_manta",--
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_heart",--
				"item_aghanims_shard",
				"item_blink",
				"item_travel_boots",
				"item_swift_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_armlet",
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
	
				"item_bracer",
				"item_power_treads",
				"item_magic_wand",
				"item_armlet",
				"item_orchid",
				"item_manta",--
				"item_black_king_bar",--
				"item_bloodthorn",--
				"item_heart",--
				"item_aghanims_shard",
				"item_blink",
				"item_travel_boots",
				"item_swift_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_armlet",
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
	
				"item_bracer",
				"item_power_treads",
				"item_magic_wand",
				"item_armlet",
				"item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_blink",
				"item_heart",--
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_armlet",
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

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	ChaosBolt = bot:GetAbilityByName('chaos_knight_chaos_bolt')
	RealityRift = bot:GetAbilityByName('chaos_knight_reality_rift')
	Phantasm = bot:GetAbilityByName('chaos_knight_phantasm')

	PhantasmDesire = X.ConsiderPhantasm()
    if PhantasmDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

		local Armlet = J.IsItemAvailable( "item_armlet" )
        if Armlet ~= nil and Armlet:IsFullyCastable() and Armlet:GetToggleState() == false
        then
            bot:ActionQueue_UseAbility(Armlet)
        end

        bot:ActionQueue_UseAbility(Phantasm)
        return
    end

	RealityRiftDesire, RealityRiftTarget = X.ConsiderRealityRift()
	if RealityRiftDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnEntity(RealityRift, RealityRiftTarget)
		return
	end

	ChaosBoltDesire, ChaosBoltTarget = X.ConsiderChaosBolt()
	if ChaosBoltDesire > 0
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity(ChaosBolt, ChaosBoltTarget)
		return
	end
end

function X.ConsiderChaosBolt()
	if not J.CanCastAbility(ChaosBolt) then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, ChaosBolt:GetCastRange())
	local nSkillLV = ChaosBolt:GetLevel()
	local nDamage = 30 + nSkillLV * 30 + 120 * 0.38

	local nEnemysHeroesInCastRange = bot:GetNearbyHeroes( nCastRange + 99, true, BOT_MODE_NONE )
	local nEnemysHeroesInView = bot:GetNearbyHeroes( 880, true, BOT_MODE_NONE )

    local botTarget = J.GetProperTarget( bot )

	if nEnemysHeroesInCastRange ~= nil and #nEnemysHeroesInCastRange > 0 then
		for i=1, #nEnemysHeroesInCastRange do
			if J.IsValidHero( nEnemysHeroesInCastRange[i] )
            and J.CanCastOnNonMagicImmune( nEnemysHeroesInCastRange[i] )
            and J.CanCastOnTargetAdvanced( nEnemysHeroesInCastRange[i] )
            and nEnemysHeroesInCastRange[i]:GetHealth() < nEnemysHeroesInCastRange[i]:GetActualIncomingDamage( nDamage, DAMAGE_TYPE_MAGICAL )
            and not ( GetUnitToUnitDistance( nEnemysHeroesInCastRange[i], bot ) <= bot:GetAttackRange() + 60 )
            and not J.IsDisabled( nEnemysHeroesInCastRange[i] )
            and not nEnemysHeroesInCastRange[i]:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInCastRange[i]
			end
		end
	end

	if nEnemysHeroesInView ~= nil and #nEnemysHeroesInView > 0 then
		for i=1, #nEnemysHeroesInView do
			if J.IsValidHero( nEnemysHeroesInView[i] )
            and J.CanCastOnNonMagicImmune( nEnemysHeroesInView[i] )
            and J.CanCastOnTargetAdvanced( nEnemysHeroesInView[i] )
            and nEnemysHeroesInView[i]:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInView[i]
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
		and DotaTime() > 4 * 60
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemysHeroesInCastRange )
		do
			if J.IsValidHero( npcEnemy )
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not J.IsDisabled( npcEnemy )
            and not npcEnemy:IsDisarmed()
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
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

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and not J.IsDisabled( botTarget )
        and not botTarget:IsDisarmed()
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero( nEnemysHeroesInCastRange[1] )
        and GetUnitToUnitDistance( bot, nEnemysHeroesInCastRange[1] ) <= nCastRange - 60
        and J.CanCastOnNonMagicImmune( nEnemysHeroesInCastRange[1] )
        and J.CanCastOnTargetAdvanced( nEnemysHeroesInCastRange[1] )
        and not J.IsDisabled( nEnemysHeroesInCastRange[1] )
        and not nEnemysHeroesInCastRange[1]:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInCastRange[1]
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and not J.IsDisabled( botTarget )
        and J.GetHP( botTarget ) > 0.2
        and not botTarget:IsDisarmed()
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderRealityRift()
	if not J.CanCastAbility(RealityRift) or bot:IsRooted() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, RealityRift:GetCastRange())
	local bIgnoreMagicImmune = false

    local botTarget = J.GetProperTarget( bot )

    if bot:GetUnitName() == 'npc_dota_hero_chaos_knight'
    then
        local PierceSpellImmunityTalent = bot:GetAbilityByName('special_bonus_unique_chaos_knight')
        if PierceSpellImmunityTalent ~= nil and PierceSpellImmunityTalent:IsTrained()
        then
            bIgnoreMagicImmune = true
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE )

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange + 50 )
        and ( not J.IsInRange( bot, botTarget, 200 ) or not botTarget:HasModifier( 'modifier_chaos_knight_reality_rift' ) )
        and ((bIgnoreMagicImmune and J.CanCastOnMagicImmune(botTarget)) or J.CanCastOnNonMagicImmune(botTarget))
        and J.CanCastOnTargetAdvanced( botTarget )
        and not J.IsDisabled( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		local creeps = bot:GetNearbyCreeps( nCastRange, true )

		if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 800)
		then
			for _, creep in pairs( creeps )
			do
				if J.IsValid(creep)
                and nEnemyHeroes[1]:IsFacingLocation( bot:GetLocation(), 30 )
					and bot:IsFacingLocation( creep:GetLocation(), 30 )
					and GetUnitToUnitDistance( bot, creep ) >= 650
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end


	if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		and bot:GetAttackDamage() >= 150
	then
		local nCreeps = bot:GetNearbyLaneCreeps( 1000, true )
		for i=1, #nCreeps
		do
			local creep = nCreeps[#nCreeps -i + 1]
			if J.IsValid( creep )
            and J.CanBeAttacked(creep)
            and J.IsKeyWordUnit( "ranged", creep )
            and GetUnitToUnitDistance( bot, creep ) >= 350
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and not J.IsDisabled( botTarget )
        and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPhantasm()
	if not J.CanCastAbility(Phantasm) or bot:DistanceFromFountain() < 500 then return BOT_ACTION_DESIRE_NONE end

	local nNearbyEnemyHeroes = J.GetEnemyList( bot, 1600 )
	local nNearbyEnemyTowers = bot:GetNearbyTowers( 700, true )
	local nNearbyEnemyBarracks = bot:GetNearbyBarracks( 400, true )
	local nNearbyAlliedCreeps = bot:GetNearbyLaneCreeps( 1000, false )
	local nCastRange = 900

    local hasAbility = J.HasAbility(bot, 'chaos_knight_reality_rift')
    if hasAbility
    then
        nCastRange = 1200
    end

    local botTarget = J.GetProperTarget( bot )

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and not botTarget:IsAttackImmune()
        and J.IsInRange( bot, botTarget, nCastRange )
        and J.CanCastOnMagicImmune( botTarget )
        and ( J.GetHP( botTarget ) > 0.5
            or J.GetHP(bot) < 0.7
            or nNearbyEnemyHeroes ~= nil and #nNearbyEnemyHeroes >= 2 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		if nNearbyEnemyHeroes ~= nil and #nNearbyEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsPushing( bot )
	and DotaTime() > 8 * 30
	then
		if ( (nNearbyEnemyTowers ~= nil and #nNearbyEnemyTowers >= 1) or (nNearbyEnemyBarracks ~= nil and #nNearbyEnemyBarracks >= 1 ))
			and (nNearbyAlliedCreeps ~= nil and #nNearbyAlliedCreeps >= 2)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and J.GetHP(bot) >= 0.5
    and J.IsValidHero( nNearbyEnemyHeroes[1] )
    and GetUnitToUnitDistance( bot, nNearbyEnemyHeroes[1] ) <= 700
    and J.IsChasingTarget(nNearbyEnemyHeroes[1], bot)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

return X