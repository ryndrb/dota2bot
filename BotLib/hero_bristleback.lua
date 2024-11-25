local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bristleback'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
				[2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bracer",
				"item_arcane_boots",
				"item_magic_wand",
				"item_ultimate_scepter",
				"item_bloodstone",--
				"item_black_king_bar",--
				"item_sange_and_yasha",--
				"item_assault",--
				"item_aghanims_shard",
				"item_basher",
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_sange_and_yasha",
				"item_bracer", "item_assault",
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
					['t10'] = {10, 0},
				},
				[2] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},
				[2] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bottle",
				"item_bracer",
				"item_magic_wand",
				"item_arcane_boots",
				"item_ultimate_scepter",
				"item_bloodstone",--
				"item_black_king_bar",--
				"item_sange_and_yasha",--
				"item_assault",--
				"item_aghanims_shard",
				"item_basher",
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_bloodstone",
				"item_magic_wand", "item_black_king_bar",
				"item_bottle", "item_sange_and_yasha",
				"item_bracer", "item_assault",
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
				[1] = {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bracer",
				"item_magic_wand",
				"item_arcane_boots",
				"item_pipe",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_bloodstone",--
				sUtilityItem,--
				"item_sange_and_yasha",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_bloodstone",
				"item_magic_wand", sUtilityItem,
				"item_bracer", "item_sange_and_yasha",
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

local ViscousNasalGoo = bot:GetAbilityByName('bristleback_viscous_nasal_goo')
local QuillSpray = bot:GetAbilityByName('bristleback_quill_spray')
local Bristleback = bot:GetAbilityByName('bristleback_bristleback')
local Hairball = bot:GetAbilityByName('bristleback_hairball')

local ViscousNasalGooDesire, ViscousNasalGooTarget
local QuillSprayDesire
local HairballDesire, HairballTarget
local BristlebackDesire, BristlebackLocation

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	ViscousNasalGoo = bot:GetAbilityByName('bristleback_viscous_nasal_goo')
	QuillSpray = bot:GetAbilityByName('bristleback_quill_spray')
	Bristleback = bot:GetAbilityByName('bristleback_bristleback')
	Hairball = bot:GetAbilityByName('bristleback_hairball')

	HairballDesire, HairballTarget = X.ConsiderHairball()
	if HairballDesire > 0
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnLocation(Hairball, HairballTarget)
		return
	end

	BristlebackDesire, BristlebackLocation = X.ConsiderBristleback()
	if BristlebackDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Bristleback, BristlebackLocation)
		return
	end

	ViscousNasalGooDesire, ViscousNasalGooTarget = X.ConsiderViscousNasalGoo()
    if ViscousNasalGooDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ViscousNasalGoo, ViscousNasalGooTarget)
        return
    end

	QuillSprayDesire = X.ConsiderQuillSpray()
	if QuillSprayDesire > 0
	then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbility(QuillSpray)
		return
	end
end

function X.ConsiderViscousNasalGoo()
	if not J.CanCastAbility(ViscousNasalGoo)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, ViscousNasalGoo:GetCastRange())
	local nManaCost = ViscousNasalGoo:GetManaCost()

    local botTarget = J.GetProperTarget(bot)

	local nInRangeEnemy = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
    local nEnemyHeroes = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero( nInRangeEnemy[1] )
		then
            local enemyHero = nInRangeEnemy[1]
			if bot:HasScepter()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.CanCastOnNonMagicImmune( enemyHero )
            and J.CanCastOnTargetAdvanced( enemyHero )
            and ( bot:IsFacingLocation( enemyHero:GetLocation(), 15 ) or #nEnemyHeroes <= 1 )
            and ( bot:WasRecentlyDamagedByHero( enemyHero, 2.0 ) or bot:GetLevel() >= 10 )
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight( bot, 1400 ) and bot:HasScepter()
	then
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero( nInRangeEnemy[1] )
        and J.CanCastOnNonMagicImmune( nInRangeEnemy[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end

		if J.IsValid( botTarget )
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAllowedToSpam( bot, nManaCost )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and not J.CanKillTarget( botTarget, bot:GetAttackDamage() * 1.68, DAMAGE_TYPE_PHYSICAL )
		then
			local nCreeps = bot:GetNearbyCreeps( 800, true )
			if #nCreeps >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and not J.IsDisabled(botTarget)
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderQuillSpray()
	if not J.CanCastAbility(QuillSpray)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = QuillSpray:GetSpecialValueInt( "radius" )
	local nManaCost = QuillSpray:GetManaCost()

    local botTarget = J.GetProperTarget(bot)

	local nInRangeEnemy = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE )
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps( nRadius, true )

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs( nEnemyHeroes )
		do
			if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and (bot:WasRecentlyDamagedByHero( enemyHero, 4.0 )
				or enemyHero:HasModifier( "modifier_bristleback_quill_spray" ))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsPushing( bot )
    or J.IsDefending( bot )
    or J.IsGoingOnSomeone( bot )
    or J.IsFarming(bot)
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 1 and J.IsAllowedToSpam( bot, nManaCost )
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming( bot )
    and J.IsAllowedToSpam( bot, nManaCost )
	then
		if J.IsValid( botTarget )
		and botTarget:GetTeam() == TEAM_NEUTRAL
		then
			if botTarget:GetHealth() > bot:GetAttackDamage() * 2.28
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			local nCreeps = bot:GetNearbyCreeps( nRadius, true )
			if ( #nCreeps >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nRadius-100 )
        and J.CanCastOnMagicImmune( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nRadius )
        and J.IsAllowedToSpam( bot, nManaCost )
        and J.CanCastOnNonMagicImmune( botTarget )
		then
			local nCreeps = bot:GetNearbyCreeps( 800, true )
			if nCreeps ~= nil and #nCreeps >= 1
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( bot, botTarget, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( bot, botTarget, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.GetMP(bot) > 0.95
		and bot:GetLevel() >= 6
		and bot:DistanceFromFountain() > 2400
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBristleback()
	if not J.CanCastAbility(Bristleback)
	or not bot:HasScepter()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local botTarget = J.GetProperTarget( bot )
	local nRadius = 350

    local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.CanBeAttacked(botTarget)
		and J.IsInRange( bot, botTarget, nRadius )
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByAnyHero(2))
        and J.CanBeAttacked(nEnemyHeroes[1])
		and J.IsInRange( bot, nEnemyHeroes[1], nRadius )
        and not nEnemyHeroes[1]:HasModifier('modifier_abaddon_borrowed_time')
        and not nEnemyHeroes[1]:HasModifier('modifier_dazzle_shallow_grave')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end
	end

	if J.IsFarming(bot)
	then
		local nCreeps = bot:GetNearbyCreeps(nRadius, true)

		if #nCreeps >= 2
		and J.CanBeAttacked(nCreeps[1])
		and J.GetHP(nCreeps[1]) > 0.5
		and nCreeps[1]:IsAncientCreep()
		then
			return BOT_ACTION_DESIRE_HIGH, nCreeps[1]:GetLocation()
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and not botTarget:IsInvulnerable()
        and J.IsInRange( bot, botTarget, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( bot, botTarget, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderHairball()
	if not J.CanCastAbility(Hairball)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = Hairball:GetSpecialValueInt('radius')
    local nCastRange = J.GetProperCastRange(false, bot, Hairball:GetCastRange())

    local botTarget = J.GetProperTarget( bot )

    if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
        if J.IsValidHero( nInRangeEnemy[1] )
        and J.CanCastOnNonMagicImmune( nInRangeEnemy[1] )
        then
            return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + nInRangeEnemy[1]:GetLocation()) / 2
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
        if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange )
        and J.CanCastOnNonMagicImmune( botTarget )
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X