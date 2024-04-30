local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local tTalentTreeList = {
					{--pos1
                        ['t25'] = {10, 0},
						['t20'] = {0, 10},
						['t15'] = {0, 10},
						['t10'] = {10, 0},
                    },
                    {--pos2,3
                        ['t25'] = {10, 0},
                        ['t20'] = {0, 10},
                        ['t15'] = {10, 0},
                        ['t10'] = {10, 0},
                    },
}

local tAllAbilityBuildList = {
						{3,1,3,2,3,6,3,1,1,1,6,2,2,2,6},--pos1
                        {3,1,1,2,1,6,1,2,2,2,6,3,3,3,6},--pos2,3
}

local nAbilityBuildList
local nTalentBuildList

if sRole == "pos_1"
then
    nAbilityBuildList   = tAllAbilityBuildList[1]
    nTalentBuildList    = J.Skill.GetTalentBuild(tTalentTreeList[1])
elseif sRole == "pos_2" or sRole == "pos_3"
then
    nAbilityBuildList   = tAllAbilityBuildList[2]
    nTalentBuildList    = J.Skill.GetTalentBuild(tTalentTreeList[2])
end

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe", "item_nullifier"}
local nUtility = sUtility[RandomInt(1, #sUtility)]

local sBlinkUpgrade = RandomInt(1, 2) == 1 and "item_swift_blink" or "item_overwhelming_blink"

local sRoleItemsBuyList = {}

sRoleItemsBuyList['pos_1'] = {
    "item_tango",
    "item_quelling_blade",
    "item_slippers",
    "item_circlet",
    "item_double_branches",

    "item_wraith_band",
    "item_magic_wand",
    "item_power_treads",
    "item_echo_sabre",
    "item_blink",
    "item_black_king_bar",--
    "item_aghanims_shard",
    "item_greater_crit",--
    "item_satanic",--
    "item_moon_shard",
    "item_monkey_king_bar",--
    "item_swift_blink",--
    "item_travel_boots_2",--
    "item_ultimate_scepter_2",
}

sRoleItemsBuyList['pos_2'] = {
    "item_tango",
    "item_double_branches",
    "item_faerie_fire",
    "item_quelling_blade",

    "item_bottle",
    "item_power_treads",
    "item_magic_wand",
    "item_blink",
    "item_echo_sabre",
	"item_phylactery",
    "item_black_king_bar",--
	"item_angels_demise",--
    "item_aghanims_shard",
    "item_assault",--
	"item_travel_boots",
    "item_moon_shard",
    "item_monkey_king_bar",--
    sBlinkUpgrade,--
    "item_travel_boots_2",--
    "item_ultimate_scepter_2",
}

sRoleItemsBuyList['pos_3'] = {
	"item_tango",
    "item_double_branches",
    "item_slippers",
	"item_circlet",
    "item_quelling_blade",

	"item_wraith_band",
	"item_boots",
    "item_magic_wand",
	"item_power_treads",
    "item_echo_sabre",
    "item_blink",
	"item_phylactery",
	nUtility,--
    "item_black_king_bar",--
	"item_angels_demise",--
    "item_aghanims_shard",
    "item_assault",--
	"item_travel_boots",
    sBlinkUpgrade,--
    "item_moon_shard",
    "item_travel_boots_2",--
    "item_ultimate_scepter_2",
}

sRoleItemsBuyList['pos_4'] = sRoleItemsBuyList['pos_4']

sRoleItemsBuyList['pos_5'] = sRoleItemsBuyList['pos_5']

X['sBuyList'] = sRoleItemsBuyList[sRole]

Pos1SellList = {
	"item_quelling_blade",
    "item_wraith_band",
    "item_magic_wand",
	"item_echo_sabre",
}

Pos2SellList = {
    "item_quelling_blade",
    "item_bottle",
    "item_magic_wand",
	"item_echo_sabre",
}

Pos3SellList = {
    "item_quelling_blade",
	"item_wraith_band",
    "item_magic_wand",
	"item_echo_sabre",
}

X['sSellList'] = {}

if sRole == "pos_1"
then
    X['sSellList'] = Pos1SellList
elseif sRole == "pos_2"
then
    X['sSellList'] = Pos2SellList
elseif sRole == "pos_3"
then
    X['sSellList'] = Pos3SellList
end

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

local Avalanche     = bot:GetAbilityByName("tiny_avalanche")
local Toss          = bot:GetAbilityByName("tiny_toss")
local TreeGrab      = bot:GetAbilityByName("tiny_tree_grab")
local TreeThrow     = bot:GetAbilityByName("tiny_toss_tree")
local TreeVolley    = bot:GetAbilityByName("tiny_tree_channel")

local AvalancheDesire, AvalancheTarget
local TossDesire, TossTarget
local TreeGrabDesire, TreeGrabTarget
local TreeThrowDesire, TreeThrowTarget
local TreeVolleyDesire, TreeVolleyTarget

local BlinkTossDesire, BlinkTossTarget

local Blink
local BlinkLocation

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	botTarget = J.GetProperTarget(bot)

	BlinkTossDesire, BlinkTossTarget = X.ConsiderBlinkToss()
	if BlinkTossDesire > 0
	then
		bot:Action_ClearActions(false)
		bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkLocation)
		bot:ActionQueue_Delay(0.1)
		bot:ActionQueue_UseAbilityOnEntity(Toss, BlinkTossTarget)
		return
	end

	TossDesire, TossTarget = X.ConsiderToss()
	if TossDesire > 0
	then
		bot:Action_UseAbilityOnEntity(Toss, TossTarget)
		return
	end

	AvalancheDesire, AvalancheTarget = X.ConsiderAvalanche()
	if AvalancheDesire > 0
	then
		bot:Action_UseAbilityOnLocation(Avalanche, AvalancheTarget)
		return
	end

	TreeGrabDesire, TreeGrabTarget = X.ConsiderTreeGrab()
	if TreeGrabDesire > 0
	then
		bot:Action_UseAbilityOnTree(TreeGrab, TreeGrabTarget)
		return
	end

	TreeThrowDesire, TreeThrowTarget = X.ConsiderTreeThrow()
	if TreeThrowDesire > 0
	then
		bot:Action_UseAbilityOnEntity(TreeThrow, TreeThrowTarget)
		return
	end

	TreeVolleyDesire, TreeVolleyTarget = X.ConsiderTreeVolley()
	if TreeVolleyDesire > 0
	then
		bot:Action_UseAbilityOnLocation(TreeVolley, TreeVolleyTarget)
		return
	end
end

function X.ConsiderAvalanche()
    if not Avalanche:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Avalanche:GetCastRange())
	local nRadius = Avalanche:GetSpecialValueInt('radius')
	local nDamage = Avalanche:GetSpecialValueInt('value') * (1 + bot:GetSpellAmp())
	local nManaCost = Avalanche:GetManaCost()

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange + 300, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange + nRadius)
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
				if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
				then
					return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
				else
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end
	end

	if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or bot:WasRecentlyDamagedByAnyHero(2))
            then
                return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]:GetLocation()
            end
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
		and J.IsValid(nEnemyLaneCreeps[1])
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and J.GetManaAfter(Avalanche:GetManaCost()) * bot:GetMana() > Avalanche:GetManaCost() + Toss:GetManaCost()
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(J.GetCenterOfUnits(nEnemyLaneCreeps), 1600)
			if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

	if  J.IsFarming(bot)
	and J.GetManaAfter(Avalanche:GetManaCost()) * bot:GetMana() > Avalanche:GetManaCost() + Toss:GetManaCost()
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
		if  nNeutralCreeps ~= nil
		and (#nNeutralCreeps >= 3 or (#nNeutralCreeps >= 1 and nNeutralCreeps[1]:IsAncientCreep()))
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
		end

		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
		and J.IsValid(nEnemyLaneCreeps[1])
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(J.GetCenterOfUnits(nEnemyLaneCreeps), 1600)
			if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

	if J.IsLaning(bot)
	then
		local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 300, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			and botTarget ~= creep
			then
				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
				and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) <= 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end

			if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                table.insert(creepList, creep)
            end
		end

		if  #creepList >= 3
        and J.GetMP(bot) > 0.4
        and nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(creepList)
        end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderToss()
    if not Toss:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Toss:GetCastRange())
	local nDamage = Toss:GetSpecialValueInt('toss_damage') * (1 + bot:GetSpellAmp())
	local nRadius = Toss:GetSpecialValueInt('grab_radius')

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if  (enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero))
			and Avalanche:IsTrained() and not Avalanche:IsCooldownReady()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				if J.IsInRange(bot, enemyHero, nRadius)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end

				local nCreeps = bot:GetNearbyCreeps(nRadius, true)
				if nCreeps ~= nil and #nCreeps >= 1
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local bigUltedTarget = nil
		local nInRangeEnemy2 = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)
		for _, enemyHero in pairs(nInRangeEnemy2)
		do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsSuspiciousIllusion(enemyHero)
			and (enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				or enemyHero:HasModifier('modifier_enigma_black_hole_pull'))
			then
				bigUltedTarget = enemyHero
				break
			end
		end

		if bigUltedTarget ~= nil
		then
			for _, enemyHero in pairs(nInRangeEnemy2)
			do
				if  J.IsValidHero(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.IsInRange(bot, enemyHero, nRadius)
				and bigUltedTarget ~= enemyHero
				and not J.IsSuspiciousIllusion(enemyHero)
				then
					return BOT_ACTION_DESIRE_HIGH, bigUltedTarget
				end
			end
		end

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_legion_commander_duel')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:IsAttackImmune()
		and not botTarget:IsInvulnerable()
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				if J.IsInRange(bot, botTarget, nRadius)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end

				local nTargetInRangeAlly = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
				if  nTargetInRangeAlly ~= nil
				and #nInRangeAlly >= #nTargetInRangeAlly
				then
					nInRangeAlly = bot:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
					if  nInRangeAlly ~= nil and #nInRangeAlly >= 1
					and GetUnitToUnitDistance(bot, botTarget) > nRadius + 150
					then
						return BOT_ACTION_DESIRE_HIGH, botTarget
					end
				end

				local nCreeps = bot:GetNearbyCreeps(nRadius, true)
				if  nCreeps ~= nil and #nCreeps >= 1
				and J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
				and not J.IsInRange(bot, botTarget, nRadius)
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  nInRangeEnemy ~= nil
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
		and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		and not J.IsDisabled(nInRangeEnemy[1])
		then
			local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or bot:WasRecentlyDamagedByAnyHero(2))
            then
				local loc = J.GetEscapeLoc()
				local furthestTarget = J.GetFurthestUnitToLocationFrommAll(bot, nCastRange, loc)

				if  furthestTarget ~= nil
				and GetUnitToUnitDistance(bot, furthestTarget) > nRadius
				then
					local tTarget = J.GetClosestUnitToLocationFrommAll2(bot, nRadius, bot:GetLocation())

					if  J.IsValidTarget(tTarget)
					and tTarget:GetTeam() ~= bot:GetTeam()
					then
						return BOT_ACTION_DESIRE_MODERATE, furthestTarget
					end
				elseif furthestTarget ~= nil and GetUnitToUnitDistance(furthestTarget, bot) <= nRadius
				then
					local tTarget = J.GetClosestUnitToLocationFrommAll2(bot, nRadius, bot:GetLocation())

					if  J.IsValidTarget(tTarget)
					and tTarget:GetTeam() ~= bot:GetTeam()
					then
						return BOT_ACTION_DESIRE_MODERATE, tTarget
					end
				end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTreeGrab()
	if not TreeGrab:IsFullyCastable()
	or bot:HasModifier('modifier_tiny_tree_grab')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nEnemyHeroes = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)

	if  not J.IsRetreating(bot)
	and bot:GetHealth() > 0.15
	and bot:DistanceFromFountain() > 800
	and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nTrees = bot:GetNearbyTrees(1200)

		if  nTrees ~= nil and #nTrees > 0
		and (IsLocationVisible(GetTreeLocation(nTrees[1]))
			or IsLocationPassable(GetTreeLocation(nTrees[1])))
		then
			return BOT_ACTION_DESIRE_HIGH, nTrees[1]
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTreeThrow()
	if not TreeThrow:IsFullyCastable()
	or not bot:HasModifier('modifier_tiny_tree_grab')
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, TreeThrow:GetCastRange())
	local nDamage = bot:GetAttackDamage()
	local nAttackCount = bot:GetModifierStackCount(bot:GetModifierByName('modifier_tiny_tree_grab'))

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and nAttackCount <= 2
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end

		end
	end

	if  J.IsRetreating(bot)
	and bot:GetActiveModeDesire() > 0.65
	then
		local weakestTarget = J.GetVulnerableWeakestUnit(bot, true, true, nCastRange)

        if  J.IsValidHero(weakestTarget)
        and J.IsChasingTarget(weakestTarget, bot)
        and not J.IsSuspiciousIllusion(weakestTarget)
        and not J.IsDisabled(weakestTarget)
        and not weakestTarget:IsAttackImmune()
		and not weakestTarget:IsInvulnerable()
        then
			local nInRangeAlly = weakestTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = weakestTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and ((#nInRangeEnemy > #nInRangeAlly)
                or bot:WasRecentlyDamagedByAnyHero(1))
            then
                return BOT_ACTION_DESIRE_HIGH, weakestTarget
            end
        end
	end

	if J.IsLaning(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
				and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) <= 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTreeVolley()
	if not bot:HasScepter()
	or not TreeVolley:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, TreeVolley:GetCastRange())
	local nCastPoint = TreeVolley:GetCastPoint()
	local nRadius = TreeVolley:GetSpecialValueInt('tree_grab_radius')
	local nSplashRadius = TreeVolley:GetSpecialValueInt('splash_radius')

	if J.IsInTeamFight(bot, 1200)
	then
		local nTrees = bot:GetNearbyTrees(nRadius)

		if #nTrees >= 3
		then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nSplashRadius, nCastPoint, 0)
			local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

			if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and not J.IsInRange(bot, botTarget, 500)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1400, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1400, false, BOT_MODE_NONE)
			local nTrees = bot:GetNearbyTrees(nRadius)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				if #nTrees >= 3
				then
					nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nSplashRadius)
					if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
					then
						return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
					else
						if J.IsRunning(botTarget)
						then
							return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(1)
						else
							return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBlinkToss()
    if X.CanDoBlinkToss()
    then
		local nCastRange = 1199

		if J.IsGoingOnSomeone(bot)
		then
			if  J.IsValidTarget(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and not J.IsInRange(bot, botTarget, 500)
			and not J.IsSuspiciousIllusion(botTarget)
			and not J.IsDisabled(botTarget)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_legion_commander_duel')
			and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			and not botTarget:IsAttackImmune()
			and not botTarget:IsInvulnerable()
			then
				local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
				local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

				if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
				and #nInRangeAlly >= #nInRangeEnemy
				then
					BlinkLocation = botTarget:GetLocation()

					local allyTarget = nil
					for _, allyHero in pairs(nInRangeAlly)
					do
						if  J.IsValidHero(allyHero)
						and J.IsInRange(allyHero, botTarget, nCastRange)
						and not J.IsInRange(bot, allyHero, 700)
						and not J.IsRetreating(allyHero)
						and not J.IsSuspiciousIllusion(allyHero)
						then
							allyTarget = allyHero
							break
						end
					end

					if allyTarget ~= nil
					then
						bot.shouldBlink = true
						return BOT_ACTION_DESIRE_HIGH, allyTarget
					else
						return BOT_ACTION_DESIRE_HIGH, botTarget
					end
				end
			end
		end
    end

	bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

function X.CanDoBlinkToss()
    if  Toss:IsFullyCastable()
    and X.HasBlink()
    then
        local manaCost = Toss:GetManaCost()

        if  bot:GetMana() >= manaCost
        then
            return true
        end
    end

    return false
end

function X.HasBlink()
    local blink = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if item ~= nil
        and (item:GetName() == "item_blink" or item:GetName() == "item_overwhelming_blink" or item:GetName() == "item_arcane_blink" or item:GetName() == "item_swift_blink")
        then
			blink = item
			break
		end
	end

    if  blink ~= nil
    and blink:IsFullyCastable()
	then
        Blink = blink
        return true
	end

    return false
end

return X