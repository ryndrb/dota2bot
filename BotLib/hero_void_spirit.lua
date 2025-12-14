local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_void_spirit'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
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
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {3,1,3,2,2,6,2,2,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_quelling_blade",
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_power_treads",
				"item_orchid",
				"item_kaya",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_kaya_and_sange",--
				"item_aghanims_shard",
				"item_devastator",--
				"item_bloodthorn",--
				"item_skadi",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_kaya",
				"item_magic_wand", "item_ultimate_scepter",
				"item_null_talisman", "item_black_king_bar",
				"item_bottle", "item_devastator",
			},
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

end

local AetherRemnant = bot:GetAbilityByName( "void_spirit_aether_remnant" )
local Dissimilate   = bot:GetAbilityByName( "void_spirit_dissimilate" )
local ResonantPulse = bot:GetAbilityByName( "void_spirit_resonant_pulse" )
local AstralStep    = bot:GetAbilityByName( "void_spirit_astral_step" )

local AetherRemnantDesire, AetherRemnantLocation
local DissimilateDesire
local ResonantPulseDesire
local AstralStepDesire, AstralStepLocation

local AstralStepCastTime = -100

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if  bot.dissimilate == nil then
		bot.dissimilate = {
			status = '',
			location = J.GetTeamFountain(),
		}
	end

    if J.CanNotUseAbility(bot) then return end

	AetherRemnant = bot:GetAbilityByName( "void_spirit_aether_remnant" )
	Dissimilate   = bot:GetAbilityByName( "void_spirit_dissimilate" )
	ResonantPulse = bot:GetAbilityByName( "void_spirit_resonant_pulse" )
	AstralStep    = bot:GetAbilityByName( "void_spirit_astral_step" )

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	AstralStepDesire, AstralStepLocation = X.ConsiderAstralStep()
    if AstralStepDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(AstralStep, AstralStepLocation)
        AstralStepCastTime = DotaTime()
		return
    end

	AetherRemnantDesire, AetherRemnantLocation = X.ConsiderAetherRemnant()
    if AetherRemnantDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(AetherRemnant, AetherRemnantLocation)
		return
    end

	DissimilateDesire = X.ConsiderDissimilate()
    if DissimilateDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Dissimilate)
		return
    end

	ResonantPulseDesire = X.ConsiderResonantPulse()
    if ResonantPulseDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ResonantPulse)
		ResonantPulseCastTime = DotaTime()
		return
    end
end

function X.ConsiderAetherRemnant()
    if not J.CanCastAbility(AetherRemnant) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, AetherRemnant:GetCastRange())
	local nRadius = AetherRemnant:GetSpecialValueInt('radius')
	local nActivationDelay = AetherRemnant:GetSpecialValueFloat('activation_delay')
	local nDamage = AetherRemnant:GetSpecialValueInt('impact_damage')
	local nSpeed = AetherRemnant:GetSpecialValueInt('projectile_speed')
	local nManaCost = AetherRemnant:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Dissimilate, ResonantPulse, AstralStep})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	if  J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nActivationDelay
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDissimilate()
    if not J.CanCastAbility(Dissimilate)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Dissimilate:GetSpecialValueInt('first_ring_distance_offset')
	local nRadiusPortal = Dissimilate:GetSpecialValueInt('damage_radius')
	local nManaCost = Dissimilate:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AetherRemnant, ResonantPulse, AstralStep})

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 350)
		or J.IsUnitTargetProjectileIncoming(bot, 400)
		or J.IsWillBeCastUnitTargetSpell(bot, 450)
		then
			bot.dissimilate.status = 'retreat'
			bot.dissimilate.location = J.GetTeamFountain()
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			if J.IsDisabled(botTarget)
			or botTarget:GetCurrentMovementSpeed() <= 250
			then
				bot.dissimilate.status = 'engage'
				bot.dissimilate.location = botTarget:GetLocation()
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
			and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
				if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
				or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes)
				then
					bot.dissimilate.status = 'retreat'
					bot.dissimilate.location = J.GetTeamFountain()
					return BOT_ACTION_DESIRE_HIGH
				end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nRadius, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusPortal, 0, 0)
                if (nLocationAoE.count >= 4) then
					bot.dissimilate.status = 'farm'
					bot.dissimilate.location = nLocationAoE.targetloc
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusPortal, 0, 0)
                if (nLocationAoE.count >= 4) then
					bot.dissimilate.status = 'farm'
					bot.dissimilate.location = nLocationAoE.targetloc
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadiusPortal, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 700)
                then
					bot.dissimilate.status = 'farm'
					bot.dissimilate.location = nLocationAoE.targetloc
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			bot.dissimilate.status = 'miniboss'
			bot.dissimilate.location = botTarget:GetLocation()
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			bot.dissimilate.status = 'miniboss'
			bot.dissimilate.location = botTarget:GetLocation()
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderResonantPulse()
    if not J.CanCastAbility(ResonantPulse) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = ResonantPulse:GetSpecialValueInt('radius')
	local nDamage = ResonantPulse:GetSpecialValueInt('damage')
	local nManaCost = ResonantPulse:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AetherRemnant, Dissimilate, AstralStep})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidTarget(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if bot:HasModifier('modifier_void_spirit_resonant_pulse_physical_buff')
	or bot:HasModifier('modifier_void_spirit_resonant_pulse_ring')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_aphotic_shield')
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and bot:WasRecentlyDamagedByAnyHero(3.0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.CanCastAbility(Dissimilate) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
				return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

	local nEnemCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 then
		if J.IsValid(nEnemCreeps[1]) and J.CanBeAttacked(nEnemCreeps[1]) then
			if (#nEnemCreeps >= 4) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemCreeps[1]) and J.CanBeAttacked(nEnemCreeps[1]) then
			if (#nEnemCreeps >= 4) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemCreeps[1]) and J.CanBeAttacked(nEnemCreeps[1]) then
			if (#nEnemCreeps >= 3)
			or (#nEnemCreeps >= 2 and nEnemCreeps[1]:IsAncientCreep())
			or (#nEnemCreeps >= 1 and nEnemCreeps[1]:GetHealth() >= 700)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemCreeps) do
			if  J.IsValid(creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			and not J.IsOtherAllysTarget(creep)
			then
				local sCreepName = creep:GetUnitName()
				if string.find(sCreepName, 'ranged') then
					if J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
						return BOT_ACTION_DESIRE_HIGH
					end
				end

				local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius * 0.9, 0, 800)
				if nLocationAoE.count > 0 then
					return BOT_ACTION_DESIRE_HIGH
				end

				nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
				if nLocationAoE.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local nAstralInterval = 0
function X.ConsiderAstralStep()
	if not J.CanCastAbility(AstralStep)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nMaxTravelDist = AstralStep:GetSpecialValueInt('max_travel_distance')
	local nMinTravelDist = AstralStep:GetSpecialValueInt('min_travel_distance')
	local nCastPoint = AstralStep:GetCastPoint()
	local nDelay = AstralStep:GetSpecialValueFloat('pop_damage_delay')
	local nDamage = AstralStep:GetSpecialValueInt('pop_damage')

	if  (DotaTime() > 0)
	and (DotaTime() < AstralStepCastTime + nAstralInterval)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if J.IsStuck(bot) then
		nAstralInterval = 5
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nMaxTravelDist, bot:DistanceFromFountain()))
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1200
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and J.WeAreStronger(bot, 1600)
		then
			local eta = nCastPoint + nDelay
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
				nAstralInterval = 1.5
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nMaxTravelDist)
		and not J.IsInRange(bot, botTarget, nMinTravelDist)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if #nInRangeAlly >= #nInRangeEnemy then
				local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), bot:GetAttackRange())
				if GetUnitToLocationDistance(bot, vLocation) <= nMaxTravelDist then
					nAstralInterval = 1.5
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
				if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
				or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and #nEnemyHeroes > #nAllyHeroes and J.IsRunning(bot))
				then
					nAstralInterval = 2.5
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), Min(nMaxTravelDist, bot:DistanceFromFountain()))
				end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X