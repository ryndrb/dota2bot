local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_naga_siren'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,2,1,1,3,1,3,3,6,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_magic_wand",
				"item_wraith_band",
				"item_power_treads",
				"item_diffusal_blade",
				"item_manta",--
				"item_orchid",
				"item_butterfly",--
				"item_heart",--
				"item_bloodthorn",--
				"item_aghanims_shard",
				"item_skadi",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_disperser",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_heart",
				"item_power_treads", "item_skadi",
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
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {3,2,3,1,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_gauntlets",
				"item_circlet",
			
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_diffusal_blade",
				"item_pipe",--
				"item_aghanims_shard",
				"item_assault",--
				"item_bloodthorn",--
				"item_disperser",--
				"item_sheepstick",--
				"item_heart",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_assault",
				"item_bracer", "item_bloodthorn",
				"item_magic_wand", "item_sheepstick",
				"item_power_treads", "item_heart",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'],X['sSellList'] = { 'PvN_PL' }, {"item_manta",'item_quelling_blade'} end

nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList'] = J.SetUserHeroInit(nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList']);

X['sSkillList'] = J.Skill.GetSkillList(sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList)

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)

	if Minion.IsValidUnit(hMinionUnit) 
	then
		Minion.IllusionThink(hMinionUnit)	
	end

end

end

local MirrorImage = bot:GetAbilityByName('naga_siren_mirror_image')
local Ensnare = bot:GetAbilityByName('naga_siren_ensnare')
local Riptide = bot:GetAbilityByName('naga_siren_rip_tide')
local ReelIn = bot:GetAbilityByName('naga_siren_reel_in')
local Deluge = bot:GetAbilityByName('naga_siren_deluge')
local SongOfTheSiren = bot:GetAbilityByName('naga_siren_song_of_the_siren')
local SongOfTheSirenEnd = bot:GetAbilityByName('naga_siren_song_of_the_siren_cancel')

local MirrorImageDesire
local EnsnareDesire, EnsnareTarget
local RiptideDesire
local ReelInDesire
local DelugeDesire
local SongOfTheSirenDesire
local SongOfTheSirenEndDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	MirrorImage = bot:GetAbilityByName('naga_siren_mirror_image')
	Ensnare = bot:GetAbilityByName('naga_siren_ensnare')
	ReelIn = bot:GetAbilityByName('naga_siren_reel_in')
	Deluge = bot:GetAbilityByName('naga_siren_deluge')
	SongOfTheSiren = bot:GetAbilityByName('naga_siren_song_of_the_siren')
	SongOfTheSirenEnd = bot:GetAbilityByName('naga_siren_song_of_the_siren_cancel')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	MirrorImageDesire = X.ConsiderMirrorImage()
	if MirrorImageDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(MirrorImage)
		return
	end

	EnsnareDesire, EnsnareTarget = X.ConsiderEnsnare()
	if EnsnareDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Ensnare, EnsnareTarget)
		return
	end

	ReelInDesire = X.ConsiderReelIn()
	if ReelInDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ReelIn)
		return
	end

	SongOfTheSirenDesire = X.ConsiderSongOfTheSiren()
	if SongOfTheSirenDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(SongOfTheSiren)
		return
	end

	SongOfTheSirenEndDesire = X.ConsiderSongOfTheSirenEnd()
	if SongOfTheSirenEndDesire > 0 then
		bot:Action_UseAbility(SongOfTheSirenEnd)
		return
	end

	DelugeDesire = X.ConsiderDeluge()
	if DelugeDesire > 0 then
		bot:Action_UseAbility(Deluge)
		return
	end
end

function X.ConsiderMirrorImage()
	if not J.CanCastAbility(MirrorImage) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nAbilityLevel = MirrorImage:GetLevel()
	local nManaCost = MirrorImage:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Ensnare, Deluge, SongOfTheSiren})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MirrorImage, Ensnare, Deluge, SongOfTheSiren})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Ensnare, SongOfTheSiren})

	if not bot:IsMagicImmune() and not J.IsRealInvisible(bot) then
		if (J.GetAttackProjectileDamageByRange(bot, 600) > bot:GetHealth())
		or (J.IsStunProjectileIncoming(bot, 600))
		or (J.IsUnitTargetProjectileIncoming(bot, 600))
		or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 600))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		if #nEnemyHeroes >= 2 and fManaAfter > fManaThreshold3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and fManaAfter > fManaThreshold3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes > 0 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			then
				if (J.IsChasingTarget(enemyHero, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.6 and bot:WasRecentlyDamagedByAnyHero(5.0))
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
	local nEnemyTowers = bot:GetNearbyTowers(800, true)
	local nEnemyBarracks = bot:GetNearbyBarracks(800, true)

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and fManaAfter > fManaThreshold1 then
		if (#nEnemyCreeps > 0 or #nEnemyTowers > 0 or #nEnemyBarracks > 0) then
			if J.CanBeAttacked(botTarget) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		then
			if J.CanBeAttacked(botTarget) or bot:WasRecentlyDamagedByAnyHero(3.0) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold3 then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		then
			if J.CanBeAttacked(botTarget) or bot:WasRecentlyDamagedByAnyHero(3.0) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)
		if bot:WasRecentlyDamagedByAnyHero(3.0) and #nEnemyHeroesTargetingMe > 0 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  (#nEnemyCreeps > 0 or #nEnemyTowers > 0 or #nEnemyBarracks > 0 or #nEnemyHeroes > 0)
	and not J.IsDoingRoshan(bot)
	and not J.IsDoingTormentor(bot)
	then
		if nAbilityLevel >= 4 and fManaAfter > fManaThreshold2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(botTarget, botTarget, 800)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEnsnare()
	if not J.CanCastAbility(Ensnare) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Ensnare:GetCastRange())
	local nCastPoint = Ensnare:GetCastPoint()
	local nSpeed = Ensnare:GetSpecialValueInt('net_speed')
	local nManaCost = Ensnare:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {MirrorImage, Deluge, SongOfTheSiren})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MirrorImage, Ensnare, Deluge, SongOfTheSiren})
	local bHasScepter = bot:HasScepter()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and (J.CanCastOnNonMagicImmune(enemyHero) or (J.CanCastOnMagicImmune(enemyHero) and bHasScepter))
		and J.CanCastOnTargetAdvanced(enemyHero)
	   	then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsChasingTarget(bot, botTarget)
		and not J.IsDisabled(botTarget)
		and (bHasScepter or J.CanCastOnNonMagicImmune(botTarget))
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and (bHasScepter or J.CanCastOnNonMagicImmune(enemyHero))
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsRunning(bot) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderReelIn()
	if not bot:HasScepter()
	or not J.CanCastAbility(ReelIn)
	or J.IsInTeamFight(bot, 1200)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = ReelIn:GetSpecialValueInt('radius')

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsInRange(bot, botTarget, nRadius / 2)
		and botTarget:HasModifier('modifier_naga_siren_ensnare')
		and not botTarget:HasModifier('modifier_naga_siren_song_of_the_siren')
		and not bot:WasRecentlyDamagedByAnyHero(3.0)
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			if #nInRangeAlly >= #nInRangeEnemy then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDeluge()
	if not J.CanCastAbility(Deluge) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Deluge:GetSpecialValueInt('radius')

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, nRadius)
			and J.CanCastOnNonMagicImmune(enemy)
			and not J.IsDisabled(enemy)
			and not enemy:IsDisarmed()
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or botHP < 0.5
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSongOfTheSiren()
	if not J.CanCastAbility(SongOfTheSiren) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = SongOfTheSiren:GetSpecialValueInt('radius')

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsInRange(bot, botTarget, 800)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:WasRecentlyDamagedByAnyHero(3.0)
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1000)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1000)
			local nInRangeAlly_Near = J.GetAlliesNearLoc(botTarget:GetLocation(), 700)

			if #nInRangeAlly_Near == 0 and not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if botHP < 0.3 or (#nEnemyHeroes > #nAllyHeroes and botHP > 0.5) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSongOfTheSirenEnd()
	if not J.CanCastAbility(SongOfTheSirenEnd) then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 700)
			if #nInRangeAlly >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X