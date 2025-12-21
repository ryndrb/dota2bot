local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_phantom_lancer'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
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
                [1] = {1,3,2,3,3,6,3,1,1,1,6,2,2,2,6},
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
				"item_orchid",
				"item_manta",--
				"item_ultimate_scepter",
				"item_heart",--
				"item_aghanims_shard",
				"item_skadi",--
				"item_bloodthorn",--
				"item_butterfly",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_greater_crit",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_magic_wand", "item_heart",
				"item_wraith_band", "item_orchid",
				"item_power_treads", "item_greater_crit",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_PL' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:HasModifier( 'modifier_phantom_lancer_phantom_edge_boost' ) then return end

		Minion.IllusionThink( hMinionUnit )
	end

end

end

local SpiritLance = bot:GetAbilityByName('phantom_lancer_spirit_lance')
local Doppelganger = bot:GetAbilityByName('phantom_lancer_doppelwalk')
local PhantomRush = bot:GetAbilityByName('phantom_lancer_phantom_edge')
local Juxtapose = bot:GetAbilityByName('phantom_lancer_juxtapose')

local SpiritLanceDesire, SpiritLanceTarget
local DoppelgangerDesire, DoppelgangerLocation
local JuxtaposeDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	SpiritLance = bot:GetAbilityByName('phantom_lancer_spirit_lance')
	Doppelganger = bot:GetAbilityByName('phantom_lancer_doppelwalk')
	PhantomRush = bot:GetAbilityByName('phantom_lancer_phantom_edge')
	Juxtapose = bot:GetAbilityByName('phantom_lancer_juxtapose')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	SpiritLanceDesire, SpiritLanceTarget = X.ConsiderSpiritLance()
	if SpiritLanceDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(SpiritLance, SpiritLanceTarget)
		return
	end

	DoppelgangerDesire, DoppelgangerLocation = X.ConsiderDoppelganger()
	if DoppelgangerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Doppelganger, DoppelgangerLocation)
		return
	end

	JuxtaposeDesire = X.ConsiderJuxtapose()
	if JuxtaposeDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Juxtapose)
		return
	end

end

function X.ConsiderSpiritLance()
	if not J.CanCastAbility(SpiritLance) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, SpiritLance:GetCastRange())
	local nCastPoint = SpiritLance:GetCastPoint()
	local nDamage = SpiritLance:GetSpecialValueInt('lance_damage')
	local nSpeed = SpiritLance:GetSpecialValueInt('lance_speed')
	local nManaCost = SpiritLance:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Doppelganger})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SpiritLance, Doppelganger})

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
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
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				local enemyHeroScore = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL) / enemyHero:GetHealth()
				if enemyHeroScore > hTargetScore then
					hTarget = enemyHero
					hTargetScore = enemyHeroScore
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or botHP < 0.55
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if (J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2)
	or (J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0)
	or (J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0)
	then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnTargetAdvanced(creep)
			and not J.IsOtherAllysTarget(creep)
			and not J.CanKillTarget(creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
			then
				local sCreepName = creep:GetUnitName()
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					if (string.find(sCreepName, 'ranged'))
					or (#nEnemyHeroes == 0)
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and botTarget:IsCreep()
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.CanKillTarget( botTarget, bot:GetAttackDamage() * 1.1, DAMAGE_TYPE_PHYSICAL)
		and not J.CanKillTarget( botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnTargetAdvanced(creep)
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, eta) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, 600, 0, 0)
					if (string.find(sCreepName, 'ranged') or #nEnemyCreeps >= 4) and (nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false))
					then
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
		and J.GetHP(botTarget) > 0.2
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

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDoppelganger()
	if not J.CanCastAbility(Doppelganger) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, Doppelganger:GetCastRange())
	local nAbilityLevel = Doppelganger:GetLevel()
	local nManaCost = Doppelganger:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SpiritLance})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SpiritLance, Doppelganger})
	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	local vTeamFountain = J.GetTeamFountain()
	local botLocation = bot:GetLocation()

	if (J.IsNotAttackProjectileIncoming(bot, 500))
	or (J.GetAttackProjectileDamageByRange(bot, 1600) >= bot:GetHealth())
	then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vTeamFountain, nCastRange)
	end

	if J.IsGoingOnSomeone(bot) and not bot:HasModifier('modifier_phantom_lancer_phantom_edge_agility') then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		then
			if nAbilityLevel >= 3 or fManaAfter > fManaThreshold2 or botHP < 0.4 or J.GetHP(botTarget) < 0.4 or not J.IsEarlyGame() then
				if J.IsInRange(bot, botTarget, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				else
					if J.IsInRange(bot, botTarget, nCastRange, 500) and J.IsChasingTarget(bot, botTarget) then
						return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, botTarget:GetLocation(), nCastRange)
					end
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(2.0) then
		if #nEnemyHeroesTargetingMe > 0 or (#nEnemyHeroes > #nAllyHeroes) then
			return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, vTeamFountain, nCastRange)
		end
	end

	if not bot:HasModifier('modifier_phantom_lancer_phantom_edge_agility') then
		if J.IsPushing(bot) and bAttacking and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
			if  J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and botTarget:IsCreep()
			then
				local nLocationAoE = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, 550, 0, 0)
				if (nLocationAoE.count >= 4) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end

		if J.IsDefending(bot) and bAttacking and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold1 then
			if  J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and botTarget:IsCreep()
			then
				local nLocationAoE = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, 550, 0, 0)
				if (nLocationAoE.count >= 4) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end

		if J.IsFarming(bot) and bAttacking and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
			if  J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and botTarget:IsCreep()
			then
				local nLocationAoE = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, 550, 0, 0)
				if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and botTarget:IsAncientCreep())
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderJuxtapose()
	if not J.CanCastAbility(Juxtapose)
	or J.IsRealInvisible(bot)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and not J.IsInRange(bot, botTarget, 650)
		and not J.IsSuspiciousIllusion(botTarget)
		and not bot:WasRecentlyDamagedByAnyHero(2.0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		if botHP < 0.5 or (#nEnemyHeroes > #nAllyHeroes) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
