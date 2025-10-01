local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_phantom_assassin'
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
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,1,5,1,6,2,2,2,1,6,5,5,5,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_magic_stick",
				"item_faerie_fire",
			
				"item_power_treads",
				"item_magic_wand",
				"item_bfury",--
				"item_desolator",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_basher",
				"item_satanic",--
				"item_abyssal_blade",--
				"item_monkey_king_bar",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				'item_magic_wand', "item_satanic",
				"item_power_treads", "item_monkey_king_bar",
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
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_PA' }, {"item_power_treads", 'item_quelling_blade'} end

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

local StiflingDagger = bot:GetAbilityByName('phantom_assassin_stifling_dagger')
local PhantomStrike = bot:GetAbilityByName('phantom_assassin_phantom_strike')
local Blur = bot:GetAbilityByName('phantom_assassin_blur')
local Immaterial = bot:GetAbilityByName('phantom_assassin_immaterial')
local FanOfKnives = bot:GetAbilityByName('phantom_assassin_fan_of_knives')
local CoupDeGrace = bot:GetAbilityByName('phantom_assassin_coup_de_grace')

local StiflingDaggerDesire, StiflingDaggerTarget
local PhantomStrikeDesire, PhantomStrikeTarget
local BlurDesire
local FanOfKnivesDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	StiflingDagger = bot:GetAbilityByName('phantom_assassin_stifling_dagger')
	PhantomStrike = bot:GetAbilityByName('phantom_assassin_phantom_strike')
	Blur = bot:GetAbilityByName('phantom_assassin_blur')
	FanOfKnives = bot:GetAbilityByName('phantom_assassin_fan_of_knives')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	BlurDesire = X.ConsiderBlur()
	if BlurDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Blur)
		return
	end

	FanOfKnivesDesire = X.ConsiderFanOfKnives()
	if FanOfKnivesDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(FanOfKnives)
		return
	end

	StiflingDaggerDesire, StiflingDaggerTarget = X.ConsiderStiflingDagger()
	if StiflingDaggerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(StiflingDagger, StiflingDaggerTarget)
		return
	end

	PhantomStrikeDesire, PhantomStrikeTarget = X.ConsiderPhantomStrike()
	if PhantomStrikeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(PhantomStrike, PhantomStrikeTarget)
		return
	end
end

function X.ConsiderStiflingDagger()
	if not J.CanCastAbility(StiflingDagger) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, StiflingDagger:GetCastRange())
	local nCastPoint = StiflingDagger:GetCastPoint()
	local nAbilityLevel = StiflingDagger:GetLevel()
	local fAttackDamageFactor = StiflingDagger:GetSpecialValueInt('attack_factor_tooltip') / 100
	local nBonusDamage = StiflingDagger:GetSpecialValueInt('base_damage')
	local nDamage = nBonusDamage + (bot:GetAttackDamage() * fAttackDamageFactor)
	local nSpeed = StiflingDagger:GetSpecialValueInt('dagger_speed')
	local nManaCost = StiflingDagger:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PhantomStrike, Blur, FanOfKnives})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {StiflingDagger, PhantomStrike, Blur, FanOfKnives})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL, eta)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
				if enemyHero:HasModifier('modifier_flask_healing')
				or enemyHero:HasModifier('modifier_clarity_potion')
				or enemyHero:HasModifier('modifier_bottle_regeneration')
				or enemyHero:HasModifier('modifier_rune_regen')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end

				if  #nAllyHeroes >= 2
				and #nAllyHeroes >= #nEnemyHeroes
				and not J.IsEarlyGame()
				and not J.IsDisabled(enemyHero)
				and not bot:WasRecentlyDamagedByAnyHero(3.0)
				then
					if not J.IsDisabled(enemyHero) and not bot:WasRecentlyDamagedByAnyHero(3.0) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetScore = -math.huge
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				local enemyHeroScore = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_PHYSICAL) / enemyHero:GetHealth()
				if enemyHeroScore > hTargetScore then
					hTarget = enemyHero
					hTargetScore = enemyHeroScore
				end

				if hTarget then
					return BOT_ACTION_DESIRE_HIGH, hTarget
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			if (nAbilityLevel >= 3)
			or (fManaAfter > 0.5 and botHP < 0.5)
			or (J.GetHP(botTarget) < 0.4)
			or (not J.IsEarlyGame())
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			and not J.IsDisabled(enemyHero)
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (J.IsRunning(bot) and enemyHero:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if (J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2)
	or (J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1)
	or (J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1)
	or (not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2)
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnTargetAdvanced(creep)
			then
				local sCreepName = creep:GetUnitName()
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, eta) then
					if string.find(sCreepName, 'ranged') then
						return BOT_ACTION_DESIRE_HIGH, creep
					end

					if not J.IsInRange(bot, creep, 350) and not bot:IsFacingLocation(creep:GetLocation(), 45) then
						if string.find(sCreepName, 'melee') and #nEnemyHeroes > 0 then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end

					if (not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		local botTarget_Creep = J.GetMostHpUnit(nEnemyCreeps)

		if J.IsValid(botTarget_Creep)
		and J.CanBeAttacked(botTarget_Creep)
		and not J.IsInRange(bot, botTarget_Creep, bot:GetAttackRange() + 150)
		and not J.IsRoshan(botTarget_Creep)
		and not J.IsTormentor(botTarget_Creep)
		then
			if (not J.CanKillTarget(botTarget_Creep, nDamage, DAMAGE_TYPE_PHYSICAL) or (#nEnemyCreeps == 1)) then
				return BOT_ACTION_DESIRE_HIGH, botTarget_Creep
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local sCreepName = creep:GetUnitName()
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, eta) then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						if (string.find(sCreepName, 'ranged'))
						or (string.find(sCreepName, 'melee') and bot:WasRecentlyDamagedByAnyHero(3.0))
						then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPhantomStrike()
	if not J.CanCastAbility(PhantomStrike) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = PhantomStrike:GetCastRange()
	local nAttackDamage = bot:GetAttackDamage()
	local nCastPoint = PhantomStrike:GetCastPoint()
	local nManaCost = PhantomStrike:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StiflingDagger, Blur, FanOfKnives})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {StiflingDagger, PhantomStrike, Blur, FanOfKnives})

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if J.IsValid(botTarget) and (botTarget:IsHero() or fManaAfter > fManaThreshold1) then
			if J.CanBeAttacked(botTarget)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange + 300)
			then
				if (J.CanKillTarget(botTarget, nAttackDamage * 1.25, DAMAGE_TYPE_PHYSICAL))
				or (J.CanKillTarget(botTarget, nAttackDamage * 2.25, DAMAGE_TYPE_PHYSICAL) and botTarget:IsChanneling())
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 800)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 800)
			local nInRangeAlly_ = J.GetAlliesNearLoc(bot:GetLocation(), 1600)

			if (J.WillKillTarget(botTarget, nAttackDamage * 3, DAMAGE_TYPE_PHYSICAL, nCastPoint * 3.0))
			or (J.IsInRange(bot, botTarget, 500))
			or (#nInRangeAlly >= #nInRangeEnemy)
			or (#nInRangeAlly_ <= 1)
			or (botHP > 0.4 and J.GetHP(botTarget) < 0.15)
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 1200)
            and not J.IsDisabled(enemy)
            and not enemy:IsDisarmed()
            then
                if (J.IsChasingTarget(enemy, bot))
                or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or (botHP < 0.55)
                then
					local bestAlly = X.GetBestUnitTowardsLocation(nCastRange, J.GetTeamFountain(), nCastRange / 2, 45)
					if bestAlly then
						return BOT_ACTION_DESIRE_HIGH, bestAlly
					end
                end
            end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if (J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes <= 1)
	or (J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0)
	or (J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0)
	then
		if  J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and not J.IsEnemyHeroAroundLocation(botTarget:GetLocation(), 550)
		then
			if (#nEnemyCreeps >= 3)
			or (not J.IsInRange(bot, botTarget, nCastRange / 2))
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes <= 1 then
		if J.IsValid(botTarget) and J.CanBeAttacked(botTarget) and botTarget:IsCreep() then
			local nLocationAoE = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, 600, 0, 0)
			if (nLocationAoE.count >= 3 and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) <= 500)
			or (nLocationAoE.count >= 2 and not J.CanKillTarget(botTarget, nAttackDamage * 3, DAMAGE_TYPE_PHYSICAL))
			or (nLocationAoE.count >= 1 and not J.CanKillTarget(botTarget, nAttackDamage * 5, DAMAGE_TYPE_PHYSICAL))
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		local nEnemyTowers = bot:GetNearbyTowers(1600, true)
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsInRange(bot, creep, nCastRange / 2)
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged') then
					if J.WillKillTarget(creep, nAttackDamage * 3, DAMAGE_TYPE_PHYSICAL, nCastPoint * 3.0) then
						if (#nEnemyTowers == 0)
						or (J.IsValidBuilding(nEnemyTowers[1]) and not J.IsInRange(creep, nEnemyTowers[1], 800))
						then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.GetHP(botTarget) > 0.15
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return 0
end

function X.ConsiderBlur()
	if not J.CanCastAbility(Blur)
	or J.IsRealInvisible(bot)
	or bot:HasModifier('modifier_fountain_aura_buff')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = Blur:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StiflingDagger, PhantomStrike, FanOfKnives})

	if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
		local nInRangeAlly = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)
		if #nInRangeAlly == 0 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInEnemyArea(bot) and not J.IsEarlyGame() and fManaAfter > fManaThreshold1 then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
		local nEnemyTowers = bot:GetNearbyTowers(1600, true)
		if #nInRangeAlly <= 2 and #nInRangeEnemy == 0 and #nEnemyTowers == 0 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) then
		if J.IsValid(botTarget) and botHP < 0.4 then
			if (botTarget:IsAncientCreep() or botHP < 0.25 ) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFanOfKnives()
	if not J.CanCastAbility(FanOfKnives) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = FanOfKnives:GetCastPoint()
	local nRadius = FanOfKnives:GetSpecialValueInt('radius')
	local nManaCost = FanOfKnives:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StiflingDagger, PhantomStrike, Blur})
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

	if #nInRangeEnemy == 0 then return BOT_ACTION_DESIRE_NONE end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			and not enemyHero:HasModifier('modifier_ice_blast')
			then
				local sEnemyHeroName = enemyHero:GetUnitName()
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius + 300)
				local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nInRangeAlly, enemyHero)
				if #nAllyHeroesTargetingTarget >= 3 then
					if sEnemyHeroName == 'npc_dota_hero_bristleback'
					or sEnemyHeroName == 'npc_dota_hero_dragon_knight'
					or sEnemyHeroName == 'npc_dota_hero_huskar'
					or sEnemyHeroName == 'npc_dota_hero_sven'
					or sEnemyHeroName == 'npc_dota_hero_tidehunter'
					or sEnemyHeroName == 'npc_dota_hero_shredder'
					or sEnemyHeroName == 'npc_dota_hero_luna'
					or sEnemyHeroName == 'npc_dota_hero_monkey_king'
					or sEnemyHeroName == 'npc_dota_hero_ursa'
					or sEnemyHeroName == 'npc_dota_hero_spectre'
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

    if not bot:IsMagicImmune() then
        if (J.IsStunProjectileIncoming(bot, nCastPoint * 1000))
        or (J.IsUnitTargetProjectileIncoming(bot, nCastPoint * 1000))
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, nCastPoint * 1000))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and J.CanCastOnMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if (J.IsRetreating(bot) and not J.IsRealInvisible(bot))
	or (J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1)
	then
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end

		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or botHP < 0.55
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetBestUnitTowardsLocation(nCastRange, vLocation, nMBotDistanceFromTree, nConeAngle)
	local bestAlly = nil
	local bestAllyDistance = 0

	local botLocation = bot:GetLocation()
	local targetDir = (vLocation - botLocation):Normalized()

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValid(unit)
		and J.IsInRange(bot, unit, nCastRange)
		and bot ~= unit
		and (unit:IsHero() or unit:IsCreep())
		then
			local vUnitLocation = unit:GetLocation()
			local unitDir = (vUnitLocation - botLocation):Normalized()
			local dot = J.DotProduct(targetDir, unitDir)
			local nAngle = J.GetAngleFromDotProduct(dot)
			local nBotUnitDistance = GetUnitToLocationDistance(bot, vUnitLocation)

			if nAngle <= nConeAngle and nBotUnitDistance > nMBotDistanceFromTree then
				local nBotTargetDistance = GetUnitToLocationDistance(bot, vUnitLocation)
				local nUnitTargetDistance = GetUnitToLocationDistance(unit, vUnitLocation)
				if nUnitTargetDistance < nBotTargetDistance and nBotUnitDistance > bestAllyDistance then
					bestAlly = unit
					bestAllyDistance = nBotUnitDistance
				end
			end
		end
	end

	return bestAlly
end

return X
