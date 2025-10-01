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

local sUtility = {"item_pipe", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_desolator",--
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_butterfly",--
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_wraith_band", "item_butterfly",
				"item_magic_wand", "item_greater_crit",
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
				"item_circlet",
				"item_slippers",
			
				"item_bottle",
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_desolator",--
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_butterfly",--
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_wraith_band", "item_ultimate_scepter",
				"item_magic_wand", "item_butterfly",
				"item_bottle", "item_greater_crit",
			},
        },
        [2] = {
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
				"item_circlet",
				"item_slippers",
			
				"item_bottle",
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_phylactery",
				"item_orchid",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_sheepstick",--
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_angels_demise",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_orchid",
				"item_wraith_band", "item_ultimate_scepter",
				"item_magic_wand", "item_black_king_bar",
				"item_bottle", "item_sheepstick",
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
				"item_circlet",
				"item_slippers",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_wraith_band",
				"item_phylactery",
				"item_rod_of_atos",
				sUtilityItem,--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_assault",--
				"item_gungir",--
				"item_angels_demise",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", sUtilityItem,
				"item_wraith_band", "item_black_king_bar",
				"item_magic_wand", "item_assault"
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
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_urn_of_shadows",
				"item_phylactery",
				"item_spirit_vessel",
				"item_ancient_janggo",
				"item_solar_crest",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_cyclone",
				"item_sheepstick",--
				"item_wind_waker",--
				"item_angels_demise",--
				"item_nullifier",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_orb_of_venom", "item_solar_crest",
				"item_magic_wand", "item_sheepstick",
				"item_spirit_vessel", "item_nullifier",
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
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_urn_of_shadows",
				"item_phylactery",
				"item_spirit_vessel",
				"item_mekansm",
				"item_solar_crest",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_cyclone",
				"item_sheepstick",--
				"item_wind_waker",--
				"item_angels_demise",--
				"item_nullifier",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_orb_of_venom", "item_solar_crest",
				"item_magic_wand", "item_sheepstick",
				"item_spirit_vessel", "item_nullifier",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility( bot ) then return end

	ShurikenToss = bot:GetAbilityByName('bounty_hunter_shuriken_toss')
	ShadowWalk = bot:GetAbilityByName('bounty_hunter_wind_walk')
	FriendlyShadow = bot:GetAbilityByName('bounty_hunter_wind_walk_ally')
	Track = bot:GetAbilityByName('bounty_hunter_track')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	ShadowWalkDesire = X.ConsiderShadowWalk()
	if ShadowWalkDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ShadowWalk)
		return
	end

	FriendlyShadowDesire, FriendlyShadowTarget = X.ConsiderFriendlyShadow()
	if FriendlyShadowDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FriendlyShadow, FriendlyShadowTarget)
		return
	end

	TrackDesire, TrackTarget = X.ConsiderTrack()
    if TrackDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Track, TrackTarget)
        return
    end

	ShurikenTossDesire, ShurikenTossTarget = X.ConsdierShurikenToss()
    if ShurikenTossDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ShurikenToss, ShurikenTossTarget)
        return
    end
end

function X.ConsdierShurikenToss()
	if not J.CanCastAbility(ShurikenToss) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, ShurikenToss:GetCastRange())
	local nCastPoint = ShurikenToss:GetCastPoint()
	local nDamage = ShurikenToss:GetSpecialValueInt('bonus_damage')
	local nRadius = ShurikenToss:GetSpecialValueInt('bounce_aoe')
	local nSpeed = ShurikenToss:GetSpecialValueInt('speed')
	local nManaCost = ShurikenToss:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowWalk, Track})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ShurikenToss, ShadowWalk, Track})

	local nTrackEnemyList = {}

	for _, enemyHero in ipairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if enemyHero:HasModifier('modifier_bounty_hunter_track') then
				nTrackEnemyList[#nTrackEnemyList + 1] = enemyHero
			end

			if  J.CanCastOnNonMagicImmune(enemyHero)
            and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + GetUnitToUnitDistance(bot, enemyHero) / nSpeed)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				if J.IsInRange(bot, enemyHero, nCastRange + 300) then
					if J.CanCastOnTargetAdvanced(enemyHero) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				else
					if enemyHero:HasModifier('modifier_bounty_hunter_track') then
						for _, enemyHero_ in pairs(nEnemyHeroes) do
							if J.IsValidHero(enemyHero_)
							and enemyHero ~= enemyHero_
							and J.CanBeAttacked(enemyHero_)
							and J.IsInRange(enemyHero_, enemyHero, nRadius)
							and J.CanCastOnTargetAdvanced(enemyHero_)
							then
								return BOT_ACTION_DESIRE_HIGH, enemyHero_
							end
						end
					end
				end
			end
		end
	end

	if #nTrackEnemyList >= 2 and fManaAfter > fManaThreshold1 then
		local hTarget = nil
		local hTargetBounceCount = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_bounty_hunter_track')
			then
				local enemyHeroBounceCount = 0
				for _, trackEnemyHero in pairs(nTrackEnemyList) do
					if J.IsValidHero(trackEnemyHero)
					and J.IsInRange(enemyHero, trackEnemyHero, nRadius * 0.8)
					then
						enemyHeroBounceCount = enemyHeroBounceCount + 1
					end
				end

				if enemyHeroBounceCount > hTargetBounceCount then
					hTarget = enemyHero
					hTargetBounceCount = enemyHeroBounceCount
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
        and J.IsInRange(bot, botTarget, nCastRange + nRadius * 0.8)
        and J.CanCastOnNonMagicImmune(botTarget)
		and fManaAfter > fManaThreshold1
		then
			if botTarget:HasModifier('modifier_bounty_hunter_track') and not J.IsInRange(bot, botTarget, nCastRange) then
				for _, enemyHero_ in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero_)
					and botTarget ~= enemyHero_
					and J.CanBeAttacked(enemyHero_)
					and J.IsInRange(enemyHero_, botTarget, nRadius)
					and J.CanCastOnTargetAdvanced(enemyHero_)
					and not enemyHero_:HasModifier('modifier_bounty_hunter_track')
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero_
					end
				end
			end

			if J.IsInRange(bot, botTarget, nCastRange + 300)
            and J.CanCastOnTargetAdvanced(botTarget)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) and fManaAfter > fManaThreshold1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
				if (J.IsChasingTarget(enemyHero, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if (J.IsPushing(bot) or J.IsDefending(bot)) and fManaAfter > fManaThreshold2 and #nEnemyHeroes <= 1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local sCreepName = creep:GetUnitName()
				if  string.find(sCreepName, 'ranged')
				and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + (GetUnitToUnitDistance(bot, creep) / nSpeed))
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end

				if (string.find(sCreepName, 'siege') or string.find(sCreepName, 'warlock_golem')) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		local hTargetCreep = J.GetMostHpUnit(nEnemyCreeps)
		if J.IsValid(hTargetCreep)
		and J.CanBeAttacked(hTargetCreep)
		and not J.IsRoshan(hTargetCreep)
		and not J.IsTormentor(hTargetCreep)
		and not J.CanKillTarget(hTargetCreep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget(hTargetCreep, nDamage, DAMAGE_TYPE_MAGICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, hTargetCreep
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local sCreepName = creep:GetUnitName()
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + (GetUnitToUnitDistance(bot, creep) / nSpeed)) then
					if string.find(sCreepName, 'ranged') then
						return BOT_ACTION_DESIRE_HIGH, creep
					end

					local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius * 0.8)
					for _, enemyHero in pairs(nInRangeEnemy) do
						if J.IsValidHero(enemyHero)
						and J.CanBeAttacked(enemyHero)
						and J.CanCastOnNonMagicImmune(enemyHero)
						and enemyHero:HasModifier('modifier_bounty_hunter_track')
						then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end

					if J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled()
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
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
	if not J.CanCastAbility(ShadowWalk)
	or J.IsRealInvisible(bot)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = ShadowWalk:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShurikenToss, ShadowWalk})

	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 600)
		or J.IsUnitTargetProjectileIncoming(bot, 400)
		or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400))
		or bot:IsRooted()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 3200)
		and not J.IsSuspiciousIllusion(botTarget)
		and fManaAfter > fManaThreshold1
		then
			if not J.IsInRange(bot, botTarget, 800) or J.IsChasingTarget(bot, botTarget) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) then
		if not bot:HasModifier('modifier_fountain_aura_buff') and #nEnemyHeroes > 0 and not bAttacking then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInEnemyArea(bot) and not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and not bAttacking then
		if #nEnemyHeroes == 0 and #nEnemyTowers == 0 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if  not J.IsRetreating(bot)
	and not bAttacking
	and J.IsRunning(bot)
	and bot:GetAttackTarget() == nil
	and fManaAfter > fManaThreshold1 + 0.2
	and #nEnemyHeroes == 0
	and #nEnemyTowers == 0
	and #nEnemyCreeps == 0
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFriendlyShadow()
	if not J.CanCastAbility(FriendlyShadow) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, FriendlyShadow:GetCastRange())
	local nManaCost = FriendlyShadow:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShurikenToss, ShadowWalk})

	for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
		and bot ~= allyHero
		and J.IsInRange(bot, allyHero, nCastRange + 300)
        and not J.IsRealInvisible(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			if not allyHero:IsMagicImmune() then
				if J.IsStunProjectileIncoming(allyHero, 600)
				or J.IsUnitTargetProjectileIncoming(allyHero, 400)
				or (not allyHero:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(allyHero, 400))
				or allyHero:IsRooted()
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end

			if J.IsGoingOnSomeone(bot) then
				local allyTarget = allyHero:GetAttackTarget()

				if J.IsValidHero(allyTarget)
				and J.IsInRange(allyHero, allyTarget, 3200)
				and not J.IsSuspiciousIllusion(allyTarget)
				and fManaAfter > fManaThreshold1
				then
					if not J.IsInRange(allyHero, allyTarget, 800) or J.IsChasingTarget(allyHero, allyTarget) then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end
			end

			local nEnemyTowers = allyHero:GetNearbyTowers(1600, true)
			local nInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

			if J.IsRetreating(allyHero) and not J.IsAttacking(allyHero) then
				if J.GetHP(allyHero) < 0.25 or #nInRangeEnemy > 0 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if J.IsInEnemyArea(allyHero) and not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
				if #nEnemyHeroes == 0 and #nEnemyTowers == 0 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			local nEnemyCreeps = allyHero:GetNearbyCreeps(800, true)

			if  not J.IsRetreating(bot)
			and not J.IsRetreating(allyHero)
			and not J.IsAttacking(allyHero)
			and J.IsRunning(allyHero)
			and allyHero:GetAttackTarget() == nil
			and fManaAfter > fManaThreshold1 + 0.2
			and #nInRangeEnemy == 0
			and #nEnemyTowers == 0
			and #nEnemyCreeps == 0
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTrack()
	if not J.CanCastAbility(Track) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Track:GetCastRange())
	local nManaCost = Track:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShurikenToss, ShadowWalk})

	local hTarget = nil
	local hTargetScore = 0
	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_bounty_hunter_track')
		then
			local enemyHeroScore = enemyHero:GetActualIncomingDamage(10000, DAMAGE_TYPE_ALL) / enemyHero:GetHealth()
			if enemyHeroScore > hTargetScore then
				hTarget = enemyHero
				hTargetScore = enemyHeroScore
			end

			if bAttacking and bot:GetAttackTarget() == enemyHero and J.GetHP(enemyHero) < 0.5 and J.CanCastAbility(Jinada) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
			if #nAllyHeroesAttackingTarget >= 3 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if hTarget ~= nil then
		return BOT_ACTION_DESIRE_HIGH, hTarget
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_bounty_hunter_track')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X