local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_kunkka'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
			
				"item_magic_wand",
				"item_bracer",
				"item_phase_boots",
				"item_radiance",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_satanic",--
				"item_bloodthorn",--
				"item_greater_crit",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_satanic",
				"item_magic_wand", "item_bloodthorn",
				"item_bracer", "item_greater_crit",
			},
        },
    },
    ['pos_2'] = {
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
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_bottle",
				"item_magic_wand",
				"item_double_bracer",
				"item_phase_boots",
				"item_blade_mail",
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_heart",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blade_mail",
				"item_magic_wand", "item_ultimate_scepter",
				"item_bracer", "item_black_king_bar",
				"item_bracer", "item_shivas_guard",
				"item_bottle", "item_octarine_core",
				"item_blade_mail", "item_heart",
			},
        },
        [2] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
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
				"item_radiance",--
				"item_blade_mail",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_satanic",--
				"item_bloodthorn",--
				"item_greater_crit",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_satanic",
				"item_magic_wand", "item_black_king_bar",
				"item_bottle", "item_satanic",
				"item_bracer", "item_bloodthorn",
				"item_blade_mail", "item_greater_crit",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_magic_wand",
				"item_boots",
				"item_double_bracer",
				"item_phase_boots",
				"item_blade_mail",
				"item_crimson_guard",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				sUtilityItem,--
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_octarine_core",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_ultimate_scepter",
				"item_bracer", sUtilityItem,
				"item_bracer", "item_black_king_bar",
				"item_blade_mail", "item_octarine_core",
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

function X.MinionThink(hMinionUnit)
	Minion.IllusionThink(hMinionUnit)
end

end

local Torrent = bot:GetAbilityByName('kunkka_torrent')
local Tidebringer = bot:GetAbilityByName('kunkka_tidebringer')
local XMarksTheSpot = bot:GetAbilityByName('kunkka_x_marks_the_spot')
local Return = bot:GetAbilityByName('kunkka_return')
local TidalWave = bot:GetAbilityByName('kunkka_tidal_wave')
local Ghostship = bot:GetAbilityByName('kunkka_ghostship')


local TorrentDesire, TorrentLocation
local TidebringerDesire, TidebringerTarget
local XMarksTheSpotDesire, XMarksTheSpotTarget
local ReturnDesire
local TidalWaveDesire, TidalWaveLocation
local GhostshipDesire, GhostshipLocation

local Combo1Desire, Combo1Target, Combo1Location
local Combo2Desire, Combo2Target, Combo2Location
local Combo3Desire, Combo3Target, Combo3Location

local kunkka = { combo1 = false, combo2 = false, combo3 = false }

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Torrent = bot:GetAbilityByName('kunkka_torrent')
	Tidebringer = bot:GetAbilityByName('kunkka_tidebringer')
	XMarksTheSpot = bot:GetAbilityByName('kunkka_x_marks_the_spot')
	Return = bot:GetAbilityByName('kunkka_return')
	TidalWave = bot:GetAbilityByName('kunkka_tidal_wave')
	Ghostship = bot:GetAbilityByName('kunkka_ghostship')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.CanCastAbility(Return) then
		if Torrent and Torrent:IsTrained() and XMarksTheSpot and XMarksTheSpot:IsTrained() then
			local fTorrentDelay = Torrent:GetSpecialValueFloat('delay')
			local fReturnCastPoint = Return:GetCastPoint()

			local fTimeRemaining__X = XMarksTheSpot:GetCooldown() - XMarksTheSpot:GetCooldownTimeRemaining()
			local fTimeRemaining__Torrent = Torrent:GetCooldown() - Torrent:GetCooldownTimeRemaining()

			if kunkka.combo2 then
				if fTorrentDelay - fTimeRemaining__Torrent > 0 and fTorrentDelay - fTimeRemaining__Torrent < fReturnCastPoint + 0.1 then
					bot:Action_UseAbility(Return)
					return
				end
			end

			if Ghostship and Ghostship:IsTrained() then
				local fTimeRemaining__Ghostship = Ghostship:GetCooldown() - Ghostship:GetCooldownTimeRemaining()

				if kunkka.combo1 then
					if fTorrentDelay - fTimeRemaining__Torrent > 0 and fTorrentDelay - fTimeRemaining__Torrent < fReturnCastPoint + 0.1 then
						bot:Action_UseAbility(Return)
						return
					end
				end

				if kunkka.combo3 then
					local nDelay = Ghostship:GetSpecialValueFloat('tooltip_delay')
					if nDelay - fTimeRemaining__X > 0 and nDelay - fTimeRemaining__X < fReturnCastPoint + 0.1 then
						bot:Action_UseAbility(Return)
						return
					end
				end
			end
		end

		return
	else
		kunkka = { combo1 = false, combo2 = false, combo3 = false }
	end

	-- X -> Ghostship -> Torrent
	Combo1Desire, Combo1Target, Combo1Location = X.ConsiderCombo1()
	if Combo1Desire > 0 then
		kunkka.combo1 = true
		bot:Action_ClearActions(true)
		bot:ActionQueue_UseAbilityOnEntity(XMarksTheSpot, Combo1Target)
		bot:ActionQueue_UseAbilityOnLocation(Ghostship, Combo1Location)
		bot:ActionQueue_UseAbilityOnLocation(Torrent, Combo1Location)
		return
	end

	-- X -> Torrent
	Combo2Desire, Combo2Target, Combo2Location = X.ConsiderCombo2()
	if Combo2Desire > 0 then
		kunkka.combo2 = true
		bot:Action_ClearActions(true)
		bot:ActionQueue_UseAbilityOnEntity(XMarksTheSpot, Combo2Target)
		bot:ActionQueue_UseAbilityOnLocation(Torrent, Combo2Location)
		return
	end

	-- X -> Ghostship
	Combo3Desire, Combo3Target, Combo3Location = X.ConsiderCombo3()
	if Combo3Desire > 0 then
		kunkka.combo3 = true
		bot:Action_ClearActions(true)
		bot:ActionQueue_UseAbilityOnEntity(XMarksTheSpot, Combo3Target)
		bot:ActionQueue_UseAbilityOnLocation(Ghostship, Combo3Location)
		return
	end

	TorrentDesire, TorrentLocation = X.ConsiderTorrent()
	if TorrentDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Torrent, TorrentLocation)
		return
	end

	XMarksTheSpotDesire, XMarksTheSpotTarget = X.ConsiderXMarksTheSpot()
	if XMarksTheSpotDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(XMarksTheSpot, XMarksTheSpotTarget)
		return
	end

	GhostshipDesire, GhostshipLocation = X.ConsiderGhostship()
	if GhostshipDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Ghostship, GhostshipLocation)
		return
	end

	TidalWaveDesire, TidalWaveLocation = X.ConsiderTidalWave()
	if TidalWaveDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(TidalWave, TidalWaveLocation)
		return
	end

	TidebringerDesire, TidebringerTarget = X.ConsiderTidebringer()
	if TidebringerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(Tidebringer, TidebringerTarget)
		return
	end

	X.ConsiderReturn()
end

function X.ConsiderTorrent()
	if not J.CanCastAbility(Torrent) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Torrent:GetCastRange())
	local fCastPoint = Torrent:GetCastPoint()
	local nRadius = Torrent:GetSpecialValueInt('radius')
	local nDamage = Torrent:GetSpecialValueInt('torrent_damage')
	local fDelay = Torrent:GetSpecialValueFloat('delay')
	local nManaCost = Torrent:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Torrent, XMarksTheSpot, TidalWave, Ghostship})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {XMarksTheSpot, TidalWave, Ghostship})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(bot, 'modifier_teleporting') > fCastPoint + fDelay then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			elseif enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			local vLocation = J.GetCorrectLoc(enemyHero, fCastPoint + fDelay)
			if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint + fDelay)
				and J.CanBeAttacked(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_oracle_false_promise')
				and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
				then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsMoving(botTarget)
		then
			if not J.CanCastAbility(XMarksTheSpot) then
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fCastPoint + fDelay)
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1000)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if J.IsChasingTarget(enemyHero, bot)
				or ((#nEnemyHeroes > #nAllyHeroes or botHP < 0.5) and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, fDelay)
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if not J.CanCastAbility(Tidebringer) then
		if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and bAttacking then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 4) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end

		if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and bAttacking then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 4) then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end

		if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 and bAttacking then
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
					if (nLocationAoE.count >= 3)
					or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
					then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end
	end

	if fManaAfter > 0.5 and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
				local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
				if (nLocationAoE.count >= 4) then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		and bAttacking
		and fManaAfter > 0.5
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		and bAttacking
		and fManaAfter > 0.5
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTidebringer()
	if not J.CanCastAbility(Tidebringer) then
		return BOT_ACTION_DESIRE_NONE
	end

	local bIsAutoCasted = Tidebringer:GetAutoCastState()

	if not bIsAutoCasted then
		Tidebringer:ToggleAutoCast()
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderXMarksTheSpot()
	if not J.CanCastAbility(XMarksTheSpot)
	or J.CanCastAbility(Torrent)
	or J.CanCastAbility(Ghostship)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, XMarksTheSpot:GetCastRange())
	local fCastPoint = XMarksTheSpot:GetCastPoint()
	local nDuration_Ally = XMarksTheSpot:GetSpecialValueInt('allied_duration')
	local nDuration_Enemy = XMarksTheSpot:GetSpecialValueInt('duration')

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local fModifierTime = J.GetModifierTime(enemyHero, 'modifier_teleporting')
			if enemyHero:HasModifier('modifier_teleporting') then
				if  fModifierTime < nDuration_Enemy
				and fModifierTime > fCastPoint
				and not J.CanCastAbilitySoon(Torrent, fModifierTime + 0.5)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, nCastRange / 2)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 500)
			if #nInRangeAlly == 0 and #J.GetHeroesTargetingUnit(nAllyHeroes, botTarget) >= 2 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot) then
					if bot:GetHealth() > J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, nDuration_Enemy) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderReturn()
	if not J.CanCastAbility(Return) then
		return BOT_ACTION_DESIRE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTidalWave()
	if not J.CanCastAbility(TidalWave) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, TidalWave:GetCastRange())
	local nRadius = TidalWave:GetSpecialValueInt('radius')
	local nManaCost = TidalWave:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Torrent, XMarksTheSpot, Ghostship})

	if Torrent and Torrent:IsTrained() and Torrent:GetCooldown() - Torrent:GetCooldownTimeRemaining() < 3.1 then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		local count = 0
		for _, enemy in pairs(nInRangeEnemy) do
			if J.IsValidHero(enemy)
			and J.CanBeAttacked(enemy)
			and not J.IsSuspiciousIllusion(enemy)
			and not enemy:IsMagicImmune()
			and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemy:HasModifier('modifier_enigma_black_hole_pull')
			and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				count = count + 1
			end
		end

		if count >= 2 and fManaAfter > fManaThreshold1 then
			return BOT_ACTION_DESIRE_HIGH, J.VectorAway(bot:GetLocation(), nLocationAoE.targetloc, nRadius)
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 200)
		and J.CanBeAttacked(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:IsMagicImmune()
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			if fManaAfter > fManaThreshold1 or J.IsChasingTarget(bot, botTarget) then
				return BOT_ACTION_DESIRE_HIGH, J.VectorAway(bot:GetLocation(), botTarget:GetLocation(), nRadius)
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:IsMagicImmune()
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or ((#nEnemyHeroes > #nAllyHeroes or botHP < 0.5) and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderGhostship()
	if not J.CanCastAbility(Ghostship)
	or J.CanCastAbility(XMarksTheSpot)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Ghostship:GetCastRange())
	local nRadius = Ghostship:GetSpecialValueInt('ghostship_width')

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not enemyHero:IsMagicImmune()
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderCombo1()
	if J.CanCastAbility(Torrent) and J.CanCastAbility(XMarksTheSpot) and J.CanCastAbility(Ghostship) then
		local nComboMana = Torrent:GetManaCost() + XMarksTheSpot:GetManaCost() + Ghostship:GetManaCost() + 75
		if nComboMana > bot:GetMana() then
			return BOT_ACTION_DESIRE_NONE, nil, 0
		end

		local nCastRange_X = J.GetProperCastRange(false, bot, XMarksTheSpot:GetCastRange())

		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and (GetUnitToUnitDistance(bot, botTarget) <= nCastRange_X + 300)
			and (GetUnitToLocationDistance( botTarget, J.GetEnemyFountain()) > 600)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
			and J.GetHP(botTarget) > 0.4
			then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
				if not (#nInRangeAlly >= #nInRangeEnemy + 2) or J.IsInTeamFight(bot, 1200) then
					return BOT_ACTION_DESIRE_HIGH, botTarget, J.GetCorrectLoc(botTarget, XMarksTheSpot:GetCastPoint())
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil, 0
end

function X.ConsiderCombo2()
	if J.CanCastAbility(Torrent) and J.CanCastAbility(XMarksTheSpot) then
		if J.CanCastAbilitySoon(Ghostship, 10) then
			return BOT_ACTION_DESIRE_NONE, nil, 0
		end

		local nComboMana = Torrent:GetManaCost() + XMarksTheSpot:GetManaCost() + 75
		if nComboMana > bot:GetMana() then
			return BOT_ACTION_DESIRE_NONE, nil, 0
		end

		local nCastRange_X = J.GetProperCastRange(false, bot, XMarksTheSpot:GetCastRange())

		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and (GetUnitToUnitDistance(bot, botTarget) <= nCastRange_X + 300)
			and (GetUnitToLocationDistance( botTarget, J.GetEnemyFountain()) > 600)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
			then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
				if not (#nInRangeAlly >= #nInRangeEnemy + 3)
				or (J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, nCastRange_X / 2))
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget, J.GetCorrectLoc(botTarget, XMarksTheSpot:GetCastPoint())
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil, 0
end

function X.ConsiderCombo3()
	if J.CanCastAbility(XMarksTheSpot) and J.CanCastAbility(Ghostship) then
		local nComboMana = XMarksTheSpot:GetManaCost() + Ghostship:GetManaCost() + 75
		if nComboMana > bot:GetMana() then
			return BOT_ACTION_DESIRE_NONE, nil, 0
		end

		local nCastRange_X = J.GetProperCastRange(false, bot, XMarksTheSpot:GetCastRange())

		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and (GetUnitToUnitDistance(bot, botTarget) <= nCastRange_X + 300)
			and (GetUnitToLocationDistance( botTarget, J.GetEnemyFountain()) > 600)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
			then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

				if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
					if J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, 5.0) > botTarget:GetHealth() or J.IsInTeamFight(bot, 1200) then
						return BOT_ACTION_DESIRE_HIGH, botTarget, J.GetCorrectLoc(botTarget, XMarksTheSpot:GetCastPoint())
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil, 0
end

return X
