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

local UnstableConcoctionThrow   = bot:GetAbilityByName( "alchemist_unstable_concoction_throw" )
local UnstableConcoction        = bot:GetAbilityByName( "alchemist_unstable_concoction" )
local AcidSpray                 = bot:GetAbilityByName( "alchemist_acid_spray" )
local ChemicalRage              = bot:GetAbilityByName( "alchemist_chemical_rage" )
local BerserkPotion             = bot:GetAbilityByName( "alchemist_berserk_potion" )

local UnstableConcoctionThrowDesire
local UnstableConcoctionDesire
local AcidSprayDesire
local ChemicalRageDesire
local BerserkPotionDesire

local defDuration = 2
local offDuration = 4.25
local CCStartTime = 0

function X.SkillsComplement()

    if J.CanNotUseAbility(bot) or bot:IsInvisible() then return end

	ChemicalRageDesire = X.ConsiderChemicalRage()
	if (ChemicalRageDesire > 0)
	then
		bot:Action_UseAbility( ChemicalRage)
		return
	end

	UnstableConcoctionThrowDesire, ThrowLocation = X.ConsiderUnstableConcoctionThrow()
	if (UnstableConcoctionThrowDesire > 0)
	then
		bot:Action_UseAbilityOnEntity(UnstableConcoctionThrow, ThrowLocation)
		return
	end

	AcidSprayDesire, AcidSprayLocation = X.ConsiderAcidSpray()
	if (AcidSprayDesire > 0)
	then
		bot:Action_UseAbilityOnLocation( AcidSpray, AcidSprayLocation )
		return
	end

	UnstableConcoctionDesire = X.ConsiderUnstableConcoction()
	if (UnstableConcoctionDesire > 0)
	then
		bot:Action_UseAbility(UnstableConcoction)
		CCStartTime =  DotaTime()
		return
	end

	BerserkPotionDesire, PotionTarget = X.ConsiderBerserkPotion()
	if (BerserkPotionDesire > 0)
	then
		bot:Action_UseAbilityOnEntity(UnstableConcoctionThrow, PotionTarget)
		return
	end
end

function X.ConsiderUnstableConcoction()
	if not UnstableConcoction:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local npcTarget = bot:GetTarget()

	local nCastRange = UnstableConcoction:GetCastRange()
	local nDamage = UnstableConcoction:GetSpecialValueInt("max_damage")

	if J.IsRetreating(bot)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		for _, npcEnemy in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 1.0)
			and J.CanCastOnNonMagicImmune(npcEnemy)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsValidTarget(npcTarget)
	and J.CanCastOnNonMagicImmune(npcTarget)
	and J.CanKillTarget(npcTarget, nDamage, DAMAGE_TYPE_PHYSICAL)
	and J.IsInRange(npcTarget, bot, nCastRange - 200)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nCastRange - 200)
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
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = UnstableConcoctionThrow:GetCastRange()
	local nDamage = UnstableConcoction:GetSpecialValueInt("max_damage")
	local npcTarget = bot:GetTarget()

	if J.IsValidTarget(npcTarget)
	and J.CanCastOnNonMagicImmune(npcTarget)
	then
		if ((DotaTime() == CCStartTime + offDuration or J.CanKillTarget(npcTarget, nDamage, DAMAGE_TYPE_PHYSICAL))
		and J.IsInRange(npcTarget, bot, nCastRange + 200))
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	if J.IsRetreating(bot)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		for _, npcEnemy in pairs(nEnemyHeroes)
		do
			if J.IsValidTarget(npcEnemy)
			and bot:WasRecentlyDamagedByHero(npcEnemy, 2.0)
			and J.CanCastOnNonMagicImmune(npcEnemy)
			and DotaTime() >= CCStartTime + defDuration
			and J.IsInRange(npcTarget, bot, nCastRange + 200)
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and (DotaTime() >= CCStartTime + offDuration or npcTarget:GetHealth() < nDamage or npcTarget:IsChanneling())
		and J.IsInRange(npcTarget, bot, nCastRange + 200)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	local nEnemyHeroes = bot:GetNearbyHeroes(1300, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs(nEnemyHeroes)
	do
		if (J.CanCastOnNonMagicImmune(npcEnemy)
		and (DotaTime() >= CCStartTime + offDuration or npcEnemy:GetHealth() < nDamage or npcEnemy:IsChanneling())
		and J.IsInRange(npcTarget, bot, nCastRange+200))
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAcidSpray()
	if not AcidSpray:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = AcidSpray:GetSpecialValueInt("radius")
	local nCastRange = AcidSpray:GetCastRange()
	local nCastPoint = AcidSpray:GetCastPoint()

	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		for _, npcEnemy in pairs(tableNearbyEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 2.0)
			then
				return BOT_ACTION_DESIRE_MODERATE, bot:GetLocation()
			end
		end
	end

	if J.IsFarming(bot)
	then
		local locationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if  locationAoE.count >= 4
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end
	end

	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetAttackTarget()

		if J.IsRoshan(npcTarget)
		and J.CanCastOnMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nCastRange)
		then
			return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation()
		end
	end

	if (J.IsLaning(bot) or J.IsDefending(bot) or J.IsPushing(bot))
	and bot:GetMana() / bot:GetMaxMana() > 0.5
	then
		local nLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		local locationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if (locationAoE.count >= 4 and #nLaneCreeps >= 4)
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local locationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if  locationAoE.count >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()

		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nCastRange)
		then
			local nEnemyHeroes = npcTarget:GetNearbyHeroes( nRadius, false, BOT_MODE_NONE)

			if #nEnemyHeroes >= 2
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetExtrapolatedLocation(nCastPoint)
			end
		end
	end

	local skThere, skLoc = J.IsSandKingThere(bot, nCastRange, 2.0)

	if skThere
	then
		return BOT_ACTION_DESIRE_MODERATE, skLoc
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderChemicalRage()
	if not ChemicalRage:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = 1000

	if bot:GetHealth() / bot:GetMaxHealth() < 0.5
	then
		return BOT_ACTION_DESIRE_LOW
	end

	if J.IsRetreating(bot)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
		for _,npcEnemy in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 1.0)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsFarming(bot)
	and bot:GetHealth() / bot:GetMaxHealth() < 0.3
	then
		local npcTarget = bot:GetAttackTarget()

		if npcTarget ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetTarget()

		if J.IsRoshan(npcTarget)
		and J.CanCastOnMagicImmune(npcTarget)
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
		if #tableNearbyEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()

		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nRadius - 400)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBerserkPotion()

	if not BerserkPotion:IsFullyCastable() then return 0, nil end

	local nCastRange = BerserkPotion:GetCastRange()
	local hAllyList = J.GetAlliesNearLoc(bot:GetLocation(), 1600)

	for _, npcAlly in pairs(hAllyList)
	do
		if J.IsValidHero( npcAlly )
		and J.IsInRange( bot, npcAlly, nCastRange )
		and not npcAlly:HasModifier( 'modifier_legion_commander_press_the_attack' )
		and not npcAlly:IsMagicImmune()
		and not npcAlly:IsInvulnerable()
		and npcAlly:CanBeSeen()
		then
			if not npcAlly:IsBot()
			and npcAlly:GetAttackTarget() ~= nil
			and npcAlly:GetMaxHealth() - npcAlly:GetHealth() >= 120
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

			if J.IsDisabled( npcAlly )
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

			if J.IsRetreating(npcAlly)
			and J.IsRunning(npcAlly)
			and npcAlly:GetMaxHealth() - npcAlly:GetHealth() >= 300
			and npcAlly:WasRecentlyDamagedByAnyHero(5.0)
			and npcAlly:IsFacingLocation(GetAncient( GetTeam() ):GetLocation(), 30)
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

			if J.IsGoingOnSomeone(npcAlly)
			then
				local allyTarget = J.GetProperTarget(npcAlly)

				if J.IsValidHero(allyTarget)
				and npcAlly:IsFacingLocation( allyTarget:GetLocation(), 20)
				and J.IsInRange(npcAlly, allyTarget, npcAlly:GetAttackRange() + 100)
				then
					return BOT_ACTION_DESIRE_HIGH, npcAlly, sCastMotive
				end
			end

			if J.GetHP(npcAlly) < 0.3
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly, sCastMotive
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X