local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bounty_hunter'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_heavens_halberd"}
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
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_quelling_blade",
				"item_tango",
				"item_faerie_fire",
			
				"item_bottle",
				"item_phase_boots",
				"item_magic_wand",
				"item_phylactery",
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_black_king_bar",--
				"item_angels_demise",--
				"item_assault",--
				"item_travel_boots",
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
				"item_bottle",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_quelling_blade",
				"item_tango",
				"item_faerie_fire",
			
				"item_boots",
				"item_magic_wand",
				"item_phase_boots",
				"item_phylactery",
				"item_pipe",
				"item_black_king_bar",--
				sUtilityItem,--
				"item_angels_demise",--
				"item_assault",--
				"item_travel_boots",
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
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
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_orb_of_venom",
			
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_ancient_janggo",
				"item_solar_crest",--
				"item_boots_of_bearing",--
				"item_force_staff",--
				"item_heavens_halberd",--
				"item_sheepstick",--
				"item_lotus_orb",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_orb_of_venom",
				"item_magic_wand",
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
                [1] = {3,2,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_orb_of_venom",
			
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_ancient_janggo",
				"item_solar_crest",--
				"item_guardian_greaves",--
				"item_force_staff",--
				"item_heavens_halberd",--
				"item_sheepstick",--
				"item_lotus_orb",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_orb_of_venom",
				"item_magic_wand",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() then X['sBuyList'], X['sSellList'] = { 'PvN_BH' }, {"item_power_treads", 'item_quelling_blade'} end

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

local ShurikenToss = bot:GetAbilityByName('bounty_hunter_shuriken_toss')
local Jinada = bot:GetAbilityByName('bounty_hunter_jinada')
local ShadowWalk = bot:GetAbilityByName('bounty_hunter_wind_walk')
local FriendlyShadow = bot:GetAbilityByName('bounty_hunter_wind_walk_ally')
local Track = bot:GetAbilityByName('bounty_hunter_track')

local ShurikenTossDesire, ShurikenTossTarget
local JinadaDesire
local ShadowWalkDesire
local FriendlyShadowDesire, FriendlyShadowTarget
local TrackDesire, TrackTarget

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	ShurikenToss = bot:GetAbilityByName('bounty_hunter_shuriken_toss')
	ShadowWalk = bot:GetAbilityByName('bounty_hunter_wind_walk')
	FriendlyShadow = bot:GetAbilityByName('bounty_hunter_wind_walk_ally')
	Track = bot:GetAbilityByName('bounty_hunter_track')

	ShadowWalkDesire = X.ConsiderShadowWalk()
	if ShadowWalkDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbility( ShadowWalk )
		return
	end

	FriendlyShadowDesire, FriendlyShadowTarget = X.ConsiderFriendlyShadow()
	if FriendlyShadowDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FriendlyShadow, FriendlyShadowTarget)
		return
	end

	TrackDesire, TrackTarget = X.ConsiderTrack()
    if TrackDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Track, TrackTarget)
        return
    end

	ShurikenTossDesire, ShurikenTossTarget = X.ConsdierShurikenToss()
    if ShurikenTossDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ShurikenToss, ShurikenTossTarget)
        return
    end
end

function X.ConsdierShurikenToss()
	if not J.CanCastAbility(ShurikenToss) then return 0 end

	local nSkillLV = ShurikenToss:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, ShurikenToss:GetCastRange())
	local nCastPoint = ShurikenToss:GetCastPoint()
	local nManaCost = ShurikenToss:GetManaCost()
	local nDamage = ShurikenToss:GetSpecialValueInt( 'bonus_damage' )
	local nDamageType = DAMAGE_TYPE_MAGICAL

    local botTarget = J.GetProperTarget(bot)

	local nRadius = ShurikenToss:GetSpecialValueInt( "bounce_aoe" )
	local nEnemyUnitList = J.GetAroundBotUnitList(bot, nCastRange + 150, true)
	local nTrackEnemyList = {}

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true )

    if string.find(bot:GetUnitName(), 'bounty_hunter')
    then
        local Talent7 = bot:GetAbilityByName('special_bonus_unique_bounty_hunter_2')
        if Talent7:IsTrained()
        then
            nDamage = nDamage + Talent7:GetSpecialValueInt('value')
        end
    end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if J.IsValidHero(enemyHero)
		then
			if enemyHero:HasModifier( "modifier_bounty_hunter_track" )
			then
				nTrackEnemyList[#nTrackEnemyList + 1] = enemyHero
			end

			if enemyHero:IsChanneling()
			and not enemyHero:IsMagicImmune()
			then
				if enemyHero:HasModifier("modifier_bounty_hunter_track")
				then
					for _, nUnit in pairs(nEnemyUnitList)
					do
						if J.IsValid( nUnit )
							and J.CanCastOnTargetAdvanced( nUnit )
							and not nUnit:IsMagicImmune()
						then
							return BOT_ACTION_DESIRE_HIGH, nUnit
						end
					end
				end

				if J.IsInRange( bot, enemyHero, nCastRange + 300 )
                and J.CanCastOnTargetAdvanced(enemyHero)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if J.CanCastOnNonMagicImmune( enemyHero )
            and J.WillMagicKillTarget( bot, enemyHero, nDamage, nCastPoint + GetUnitToUnitDistance( bot, enemyHero )/1000 )
			then
				if enemyHero:HasModifier( "modifier_bounty_hunter_track" )
				then
					for _, nUnit in pairs( nEnemyUnitList )
					do
						if J.IsValid( nUnit )
                        and J.CanCastOnTargetAdvanced( nUnit )
                        and not nUnit:IsMagicImmune()
						then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end

				if J.IsInRange( bot, enemyHero, nCastRange + 300 )
                and J.CanCastOnTargetAdvanced( enemyHero )
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if #nTrackEnemyList >= 2
	then
		local nBestUnit = nil
		local nMaxBounceCount = 1.2
		for _, nUnit in pairs( nEnemyUnitList )
		do
			if J.IsValid( nUnit )
				and not nUnit:IsMagicImmune()
				and J.CanCastOnTargetAdvanced( nUnit )
			then
				local nBounceCount = 0

				if not nUnit:HasModifier( "modifier_bounty_hunter_track" )
				then
					if nUnit:IsHero()
					then
						nBounceCount = nBounceCount + 1
					else
						nBounceCount = nBounceCount + 0.1
					end
				end

				for _, npcEnemy in pairs( nTrackEnemyList )
				do
					if J.IsInRange( nUnit, npcEnemy, nRadius - 80 )
					then
						nBounceCount = nBounceCount + 1
					end
				end

				if nBounceCount > nMaxBounceCount
				then
					nBestUnit = nUnit
					nMaxBounceCount = nBounceCount
				end
			end
		end

		if nBestUnit ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nBestUnit
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange + nRadius + 150 )
        and J.CanCastOnNonMagicImmune( botTarget )
		then
			if botTarget:HasModifier( "modifier_bounty_hunter_track" )
			then
				for _, nUnit in pairs( nEnemyUnitList )
				do
					if J.IsInRange( nUnit, botTarget, nRadius - 100 )
                    and not nUnit:IsMagicImmune()
                    and J.CanCastOnTargetAdvanced( nUnit )
                    and not nUnit:HasModifier( "modifier_bounty_hunter_track" )
					then
						nCastTarget = nUnit
						return BOT_ACTION_DESIRE_HIGH, nUnit
					end
				end
			end

			if J.IsInRange( bot, botTarget, nCastRange )
            and J.CanCastOnTargetAdvanced( botTarget )
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if ( J.IsLaning(bot) or ( bot:GetLevel() <= 7 and nAllyHeroes ~= nil and #nAllyHeroes <= 2 ) )
    and bot:GetMana() >= 150
	and J.IsCore(bot)
	then
		local keyWord = "ranged"
		for _, creep in pairs( nEnemyLaneCreeps )
		do
			if J.IsValid( creep )
            and J.IsInRange(bot, creep, nCastRange + 300)
            and J.CanBeAttacked(creep)
            and J.IsKeyWordUnit( keyWord, creep )
            and J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint + GetUnitToUnitDistance( bot, creep )/1100 )
            and GetUnitToUnitDistance( creep, bot ) > 300
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, nManaCost * 0.52 )
    and ( bot:GetAttackDamage() < 300 or J.GetMP(bot) > 0.7 )
    and nSkillLV >= 2 and DotaTime() > 7 * 60
    and nAllyHeroes ~= nil and #nAllyHeroes == 0
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local keyWord = "ranged"
		for _, creep in pairs( nEnemyLaneCreeps )
		do
			if J.IsValid( creep )
            and J.IsInRange(bot, creep, nCastRange + 350)
            and J.IsKeyWordUnit( keyWord, creep )
            and J.CanBeAttacked(creep)
            and J.WillKillTarget( creep, nDamage, nDamageType, nCastPoint + GetUnitToUnitDistance( bot, creep )/1100 )
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.2, DAMAGE_TYPE_PHYSICAL )
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if J.IsFarming( bot )
    and nSkillLV >= 3
    and J.IsAllowedToSpam( bot, nManaCost )
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps( nCastRange + 300 )
		local targetCreep = J.GetMostHpUnit( nNeutralCreeps )

		if J.IsValid( targetCreep )
			and not J.IsRoshan( targetCreep )
			and ( (nNeutralCreeps ~= nil and #nNeutralCreeps >= 2) or GetUnitToUnitDistance( targetCreep, bot ) <= 400 )
			and bot:IsFacingLocation( targetCreep:GetLocation(), 40 )
			and ( targetCreep:GetMagicResist() < 0.3 or J.GetMP(bot) > 0.9 )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.68, DAMAGE_TYPE_PHYSICAL )
			and not J.CanKillTarget( targetCreep, nDamage - 50, nDamageType )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.GetHP( botTarget ) > 0.2
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderJinada()
	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShadowWalk()
	if not J.CanCastAbility(ShadowWalk) or J.IsRealInvisible(bot) then return BOT_ACTION_DESIRE_NONE end


	local nSkillLV = ShadowWalk:GetLevel()

    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if J.IsGoingOnSomeone( bot )
    and ( bot:GetLevel() >= 7 or DotaTime() > 6 * 60 or nSkillLV >= 2 )
	then
		if J.IsValidHero( botTarget )
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( bot, botTarget, 2500 )
        and ( not J.IsInRange( bot, botTarget, 1000 )
                or J.IsChasingTarget( bot, botTarget ) )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating( bot )
    and bot:WasRecentlyDamagedByAnyHero( 3.0 )
    and ( (nEnemyHeroes ~= nil and #nEnemyHeroes >= 1) or J.GetHP(bot) < 0.2 )
    and bot:DistanceFromFountain() > 800
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsInEnemyArea( bot ) and bot:GetLevel() >= 7
	then
		if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and nEnemyTowers ~= nil and #nEnemyTowers == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end


	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFriendlyShadow()
	if not J.CanCastAbility(FriendlyShadow)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, FriendlyShadow:GetCastRange())
	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	for _, allyHero in pairs(nAllyHeroes)
    do
        if J.IsValidHero(allyHero)
        and not J.IsRealInvisible(allyHero)
        then
            if J.IsGoingOnSomeone(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsNotSelf(bot, allyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and allyHero:DistanceFromFountain() > 800
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsNotSelf(bot, allyHero)
            and nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsInEnemyArea(bot)
            then
                if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
                and nEnemyTowers ~= nil and #nEnemyTowers == 0
                and J.IsInRange(bot, allyHero, nCastRange)
                and J.IsNotSelf(bot, allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
	end
end

function X.ConsiderTrack()
	if not J.CanCastAbility(Track) then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, Track:GetCastRange())
	local nCastTarget = nil

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local nMinHealth = 999999
	for _, enemyHero in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( enemyHero )
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastAbilityOnTarget( enemyHero, false )
        and J.CanCastOnTargetAdvanced( enemyHero )
        and not enemyHero:HasModifier( "modifier_bounty_hunter_track" )
        and enemyHero:GetHealth() < nMinHealth
		then
			nCastTarget = enemyHero
			nMinHealth = enemyHero:GetHealth()
		end
	end

	if nCastTarget ~= nil
	then
		return BOT_ACTION_DESIRE_HIGH, nCastTarget
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X