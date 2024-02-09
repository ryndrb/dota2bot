local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sOutfitType = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
						['t25'] = {0, 10},
						['t20'] = {0, 10},
						['t15'] = {10, 0},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},--pos1
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = {
	"item_tango",
    "item_double_branches",
	"item_quelling_blade",
	"item_gauntlets",
	"item_gauntlets",

    "item_magic_wand",
	"item_power_treads",
	"item_soul_ring",
    "item_radiance",--
    "item_blink",
    "item_black_king_bar",--
    "item_assault",--
	"item_basher",
    "item_swift_blink",--
    "item_aghanims_shard",
    "item_abyssal_blade",--
    "item_travel_boots",
    "item_moon_shard",
    "item_travel_boots_2",--
    "item_ultimate_scepter_2",
}

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
	"item_quelling_blade",
    "item_magic_wand",
	"item_power_treads",
	"item_soul_ring",
}

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

local AcidSpray                 = bot:GetAbilityByName( "alchemist_acid_spray" )
local UnstableConcoction        = bot:GetAbilityByName( "alchemist_unstable_concoction" )
local UnstableConcoctionThrow   = bot:GetAbilityByName( "alchemist_unstable_concoction_throw" )
local ChemicalRage              = bot:GetAbilityByName( "alchemist_chemical_rage" )
local BerserkPotion             = bot:GetAbilityByName( "alchemist_berserk_potion" )

local AcidSprayDesire, AcidSprayLocation
local UnstableConcoctionDesire
local UnstableConcoctionThrowDesire, UnstableConcoctionThrowLocation
local BerserkPotionDesire, BerserkPotionTarget
local ChemicalRageDesire

local defDuration = 2
local offDuration = 4.25
local ConcoctionThrowTime = 0

function X.SkillsComplement()

    if J.CanNotUseAbility(bot) or bot:IsInvisible() then return end

	ChemicalRageDesire = X.ConsiderChemicalRage()
	if (ChemicalRageDesire > 0)
	then
		bot:Action_UseAbility( ChemicalRage)
		return
	end

	UnstableConcoctionThrowDesire, UnstableConcoctionThrowLocation = X.ConsiderUnstableConcoctionThrow()
	if (UnstableConcoctionThrowDesire > 0)
	then
		bot:Action_UseAbilityOnEntity(UnstableConcoctionThrow, UnstableConcoctionThrowLocation)
		return
	end

	UnstableConcoctionDesire = X.ConsiderUnstableConcoction()
	if (UnstableConcoctionDesire > 0)
	then
		bot:Action_UseAbility(UnstableConcoction)
		ConcoctionThrowTime =  DotaTime()
		return
	end

	AcidSprayDesire, AcidSprayLocation = X.ConsiderAcidSpray()
	if (AcidSprayDesire > 0)
	then
		bot:Action_UseAbilityOnLocation( AcidSpray, AcidSprayLocation )
		return
	end

	BerserkPotionDesire, BerserkPotionTarget = X.ConsiderBerserkPotion()
	if (BerserkPotionDesire > 0)
	then
		bot:Action_UseAbilityOnEntity(UnstableConcoctionThrow, BerserkPotionTarget)
		return
	end
end

function X.ConsiderAcidSpray()
	if not AcidSpray:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = AcidSpray:GetSpecialValueInt('radius')
	local nCastRange = AcidSpray:GetCastRange()
	local nCastPoint = AcidSpray:GetCastPoint()
	local nMana = bot:GetMana() / bot:GetMaxMana()
	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

		if nLocationAoE.count >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and botTarget:IsFacingLocation(bot:GetLocation(), 45)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_MODERATE, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 175, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and ((#nInRangeEnemy > #nInRangeAlly)
			or (J.GetHP(bot) < 0.45 and bot:WasRecentlyDamagedByAnyHero(2.5)))
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
		and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
		and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		then
			return BOT_ACTION_DESIRE_MODERATE, bot:GetLocation()
		end
	end

	if  J.IsFarming(bot)
	and nMana > 0.45
	then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if  nLocationAoE.count >= 4
		then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetAttackTarget()

		if  J.IsRoshan(npcTarget)
		and J.CanCastOnMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nCastRange)
		then
			return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation()
		end
	end

	if J.IsLaning(bot)
	and nMana > 0.55
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nTeamLaneFrontLoc = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		local nEnemyLaneFrontLoc = GetLaneFrontLocation(GetOpposingTeam(), bot:GetAssignedLane(), 0)

		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
		and nLocationAoE.count >= 4
		and J.GetLocationToLocationDistance(nTeamLaneFrontLoc, nEnemyLaneFrontLoc) < 150
		then
			return BOT_ACTION_DESIRE_LOW, nLocationAoE.targetloc
		end
	end

	if (J.IsDefending(bot) or J.IsPushing(bot))
	and nMana > 0.5
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nTeamLaneFrontLoc = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		local nEnemyLaneFrontLoc = GetLaneFrontLocation(GetOpposingTeam(), bot:GetAssignedLane(), 0)

		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 5
		and nLocationAoE.count >= 5
		and J.GetLocationToLocationDistance(nTeamLaneFrontLoc, nEnemyLaneFrontLoc) < 150
		then
			return BOT_ACTION_DESIRE_MODERATE, nLocationAoE.targetloc
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderUnstableConcoction()
	if not UnstableConcoction:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = UnstableConcoction:GetCastRange()
	local nDamage = UnstableConcoction:GetSpecialValueInt('max_damage')
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange - 200)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and not botTarget:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange - 175)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and #nInRangeAlly >= #nInRangeEnemy
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 175, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and ((#nInRangeEnemy > #nInRangeAlly)
			or J.GetHP(bot) < 0.6 and bot:WasRecentlyDamagedByAnyHero(2))
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
		and J.IsInRange(bot, nInRangeEnemy[1], nCastRange - 175)
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
		and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderUnstableConcoctionThrow()
	if not UnstableConcoctionThrow:IsFullyCastable()
	or UnstableConcoctionThrow:IsHidden()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = UnstableConcoctionThrow:GetCastRange()
	local nDamage = UnstableConcoction:GetSpecialValueInt("max_damage")
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange - 200)
		and not J.IsSuspiciousIllusion(enemyHero)
		and DotaTime() >= ConcoctionThrowTime + offDuration
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and not botTarget:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange - 175)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and #nInRangeAlly >= #nInRangeEnemy
		and DotaTime() >= ConcoctionThrowTime + offDuration
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 175, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and ((#nInRangeEnemy > #nInRangeAlly)
			or J.GetHP(bot) < 0.6 and bot:WasRecentlyDamagedByAnyHero(2))
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
		and J.IsInRange(bot, nInRangeEnemy[1], nCastRange - 175)
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
		and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and DotaTime() >= ConcoctionThrowTime + defDuration
		then
			return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderChemicalRage()
	if not ChemicalRage:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(600, true, BOT_MODE_NONE)
		local nInRangeRealEnemy = J.GetEnemyList(bot, 600)

		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 200)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and nInRangeAlly ~= nil and nInRangeEnemy and nInRangeRealEnemy ~= nil
		and #nInRangeAlly >= #nInRangeEnemy
		and #nInRangeRealEnemy >= 1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(600, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and #nInRangeEnemy > #nInRangeAlly
		and J.IsValidHero(nInRangeEnemy[1])
		and J.IsInRange(bot, nInRangeEnemy[1], 500)
		and (bot:WasRecentlyDamagedByHero(nInRangeEnemy[1], 2)
			and J.GetHP(bot) < 0.33)
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if  J.IsFarming(bot)
	and J.GetHP(bot) < 0.3
	then
		if  J.IsValid(botTarget)
		and botTarget:IsCreep()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 500)
		and DotaTime() < 25 * 60
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBerserkPotion()
	if not BerserkPotion:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = BerserkPotion:GetCastRange()

	local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:HasModifier('modifier_item_satanic_unholy')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
		and not allyHero:IsIllusion()
		and allyHero:CanBeSeen()
		then
			if J.IsDisabled(allyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if  J.IsRetreating(allyHero)
			and J.IsRunning(allyHero)
			and J.GetHP(allyHero) < 0.6
			and allyHero:WasRecentlyDamagedByAnyHero(2.5)
			and allyHero:IsFacingLocation(GetAncient(GetTeam()):GetLocation(), 45)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = J.GetProperTarget(allyHero)

				if  J.IsValidHero(allyTarget)
				and allyHero:IsFacingLocation( allyTarget:GetLocation(), 20)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange() + 100)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end

				if J.GetHP(allyHero) < 0.33
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X