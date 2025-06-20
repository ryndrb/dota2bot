local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_death_prophet'
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
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_spirit_vessel",--
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_aghanims_shard",
				"item_wind_waker",--
				"item_kaya_and_sange",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_shivas_guard",
				"item_bottle", "item_wind_waker",
				"item_spirit_vessel", "item_sheepstick",
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
                [1] = {1,3,3,1,3,6,3,2,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_magic_stick",
			
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_spirit_vessel",
				"item_pipe",--
				"item_shivas_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				sUtilityItem,--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", sUtilityItem,
				"item_spirit_vessel", "item_travel_boots_2",
			},
        },
    },
    ['pos_4'] = {
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
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_ring_of_protection",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_urn_of_shadows",
				"item_glimmer_cape",--
				"item_ancient_janggo",
				"item_spirit_vessel",
				"item_ultimate_scepter",
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_kaya_and_sange",--
				"item_ultimate_scepter_2",
				"item_octarine_core",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
				"item_spirit_vessel", "item_octarine_core",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_ring_of_protection",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_urn_of_shadows",
				"item_glimmer_cape",--
				"item_mekansm",
				"item_spirit_vessel",
				"item_ultimate_scepter",
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_kaya_and_sange",--
				"item_ultimate_scepter_2",
				"item_octarine_core",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
				"item_spirit_vessel", "item_octarine_core",
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

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		local sUnitName = hMinionUnit:GetUnitName()
		if sUnitName ~= "npc_dota_death_prophet_torment"
			and sUnitName ~= "dota_death_prophet_exorcism_spirit"
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

local abilityQ = bot:GetAbilityByName('death_prophet_carrion_swarm')
local abilityW = bot:GetAbilityByName('death_prophet_silence')
local abilityE = bot:GetAbilityByName('death_prophet_spirit_siphon')
local abilityR = bot:GetAbilityByName('death_prophet_exorcism')

local castQDesire, castQLocation
local castWDesire, castWLocation
local castEDesire, castETarget
local castRDesire

function X.SkillsComplement()
	if J.CanNotUseAbility( bot )then return end

	abilityQ = bot:GetAbilityByName('death_prophet_carrion_swarm')
	abilityW = bot:GetAbilityByName('death_prophet_silence')
	abilityE = bot:GetAbilityByName('death_prophet_spirit_siphon')
	abilityR = bot:GetAbilityByName('death_prophet_exorcism')

	castWDesire, castWLocation = X.ConsiderW()
	if ( castWDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnLocation( abilityW, castWLocation )
		return
	end

	castRDesire = X.ConsiderR()
	if ( castRDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbility( abilityR )
		return

	end

	castEDesire, castETarget = X.ConsiderE()
	if ( castEDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity( abilityE, castETarget )
		return
	end

	castQDesire, castQLocation = X.ConsiderQ()
	if ( castQDesire > 0 )
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnLocation( abilityQ, castQLocation )
		return
	end
end

function X.ConsiderQ()
	if not J.CanCastAbility(abilityQ) then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, abilityQ:GetCastRange())
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = abilityQ:GetAbilityDamage()
	local nRadius = abilityQ:GetSpecialValueInt( "end_radius" )
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.CanCastOnNonMagicImmune( npcEnemy )
        and J.CanBeAttacked(npcEnemy)
        and J.IsInRange(bot, npcEnemy, nCastRange - 50)
        and J.WillMagicKillTarget( bot, npcEnemy, nDamage, nCastPoint )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	local nCanHurtEnemyAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0 )
	if nCanHurtEnemyAoE.count >= 3 and bot:GetActiveMode() ~= BOT_MODE_RETREAT
	then
		return BOT_ACTION_DESIRE_HIGH, nCanHurtEnemyAoE.targetloc
	end

	if J.IsLaning( bot )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange - 80, nRadius, 2 )
		if nAoeLoc ~= nil and J.GetMP(bot) > 0.58
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end

		if nAllyHeroes ~= nil and #nAllyHeroes == 1 and J.GetMP(bot) > 0.38
		then
			local locationAoEKill = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius + 50, 0, nDamage )
			if locationAoEKill.count >= 3
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoEKill.targetloc
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange -80 )
		then
			if nSkillLV >= 2 or J.GetMP(bot) > 0.68 or J.GetHP( botTarget ) < 0.38
			then
				local nTargetLocation = J.GetCorrectLoc(botTarget, nCastPoint)
				if J.IsInLocRange( bot, nTargetLocation, nCastRange )
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and bot:IsFacingLocation( npcEnemy:GetLocation(), 30 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
			end
		end
	end

	if J.IsFarming( bot )
    and nSkillLV >= 3
    and J.IsAllowedToSpam( bot, nManaCost * 0.25 )
	then
		if J.IsValid( botTarget )
        and botTarget:GetTeam() == TEAM_NEUTRAL
        and J.IsInRange( bot, botTarget, 1000 )
        and bot:IsFacingLocation( botTarget:GetLocation(), 45 )
        and ( botTarget:GetMagicResist() < 0.4 or J.GetMP(bot) > 0.9 )
		then
			local nShouldHurtCount = J.GetMP(bot) > 0.6 and 2 or 3
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
			if ( locationAoE.count >= nShouldHurtCount )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
    and nSkillLV >= 2 and DotaTime() > 8 * 60
    and (J.IsCore(bot) or not J.IsCore(bot) and nAllyHeroes ~= nil and #nAllyHeroes <= 3 and nEnemyHeroes ~= nil and #nEnemyHeroes == 0)
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 400, true )
		if #laneCreepList >= 3
        and J.CanBeAttacked( laneCreepList[1] )
		then
			local locationAoEKill = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if locationAoEKill.count >= 2
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoEKill.targetloc
			end

			local locationAoEHurt = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0 )
			if ( locationAoEHurt.count >= 3 and #laneCreepList >= 4 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoEHurt.targetloc
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.GetHP( botTarget ) > 0.15
		and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
		and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if ( nEnemyHeroes ~= nil and #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero( 3.0 ) )
    and ( not J.IsRetreating(bot) or nAllyHeroes ~= nil and #nAllyHeroes >= 2)
    and J.IsValidHero(nEnemyHeroes[1])
    and bot:GetLevel() > 15
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and J.CanCastOnNonMagicImmune( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(npcEnemy, nCastPoint)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderW()
	if not J.CanCastAbility(abilityW) then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, abilityW:GetCastRange())
	local nRadius	 = abilityW:GetSpecialValueInt( 'radius' )
	local nTargetLocation = nil
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero(npcEnemy)
        and npcEnemy:IsChanneling()
        and not npcEnemy:HasModifier( 'modifier_teleporting' )
        and J.IsInRange( bot, npcEnemy, nCastRange + nRadius )
        and J.CanCastOnNonMagicImmune( npcEnemy )
		then
			nTargetLocation = J.GetCastLocation( bot, npcEnemy, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			nTargetLocation = nAoeLoc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange + nRadius - 200 )
        and J.CanCastOnNonMagicImmune( botTarget )
        and ( J.IsInRange( bot, botTarget, 700 ) or botTarget:IsFacingLocation( bot:GetLocation(), 40 ) )
        and not J.IsDisabled( botTarget )
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderE()
	if not J.CanCastAbility(abilityE) then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, abilityE:GetCastRange())
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and not botTarget:HasModifier( "modifier_abaddon_borrowed_time" )
        and not botTarget:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
        and not botTarget:HasModifier( "modifier_necrolyte_reapers_scythe" )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end


	if J.IsInTeamFight( bot, 1200 )
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not npcEnemy:HasModifier( "modifier_abaddon_borrowed_time" )
            and not npcEnemy:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
            and not npcEnemy:HasModifier( "modifier_necrolyte_reapers_scythe" )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not npcEnemy:HasModifier( "modifier_abaddon_borrowed_time" )
            and not npcEnemy:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
            and not npcEnemy:HasModifier( "modifier_necrolyte_reapers_scythe" )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderR()
	if not J.CanCastAbility(abilityR) or bot:HasModifier( 'modifier_death_prophet_exorcism' )
    then return 0 end

    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if J.IsGoingOnSomeone( bot )
    then
        if J.IsValidHero( botTarget )
        and ( J.IsInRange( bot, botTarget, 700 )
            or ( #nEnemyHeroes >= 3 and J.IsInRange( bot, botTarget, 1200 ) ) )
        and J.CanCastOnMagicImmune( botTarget )
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local nAllyCreepList = bot:GetNearbyLaneCreeps( 1000, false )
    if J.IsPushing( bot ) and nAllyCreepList ~= nil and #nAllyCreepList >= 1
    then
        if J.IsValidBuilding( botTarget )
        and J.IsInRange( bot, botTarget, 800 )
        and not botTarget:HasModifier( 'modifier_fountain_glyph' )
        and not botTarget:HasModifier( 'modifier_backdoor_protection' )
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X