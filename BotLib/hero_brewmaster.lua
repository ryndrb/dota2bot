local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_brewmaster'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_crimson_guard"}
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
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
                "item_faerie_fire",
			
				"item_magic_wand",
				"item_boots",
				"item_double_bracer",
				"item_radiance",--
				sUtilityItem,--
				"item_black_king_bar",--
				"item_shivas_guard",--
                "item_travel_boots",
                "item_assault",--
                "item_aghanims_shard",
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_shivas_guard",
                "item_bracer", "item_assault",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local ThunderClap       = bot:GetAbilityByName('brewmaster_thunder_clap')
local CinderBrew        = bot:GetAbilityByName('brewmaster_cinder_brew')
local DrunkenBrawler    = bot:GetAbilityByName('brewmaster_drunken_brawler')
local LiquidCourage     = bot:GetAbilityByName('brewmaster_liquid_courage')
local PrimalCompanion   = bot:GetAbilityByName('brewmaster_primal_companion')
local PrimalSplit       = bot:GetAbilityByName('brewmaster_primal_split')

local ThunderClapDesire
local CinderBrewDesire, CinderBrewLocation
local DrunkenBrawlerDesire
local LiquidCourageDesire, LiquidCourageTarget
local PrimalCompanionDesire
local PrimalSplitDesire

local drunkenBrawlerState = 1

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    ThunderClap       = bot:GetAbilityByName('brewmaster_thunder_clap')
    CinderBrew        = bot:GetAbilityByName('brewmaster_cinder_brew')
    DrunkenBrawler    = bot:GetAbilityByName('brewmaster_drunken_brawler')
    LiquidCourage     = bot:GetAbilityByName('brewmaster_liquid_courage')
    PrimalCompanion   = bot:GetAbilityByName('brewmaster_primal_companion')
    PrimalSplit       = bot:GetAbilityByName('brewmaster_primal_split')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    DrunkenBrawlerDesire, State = X.ConsiderDrunkenBrawler()
    if DrunkenBrawlerDesire > 0 then
        if drunkenBrawlerState ~= State then
            bot:Action_UseAbility(DrunkenBrawler)
            drunkenBrawlerState = (drunkenBrawlerState % 3) + 1
        end
    end

    LiquidCourageDesire, LiquidCourageTarget = X.ConsiderLiquidCourage()
    if LiquidCourageDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(LiquidCourage, LiquidCourageTarget)
        return
    end

    CinderBrewDesire, CinderBrewLocation = X.ConsiderCinderBrew()
    if CinderBrewDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CinderBrew, CinderBrewLocation)
        return
    end

    ThunderClapDesire = X.ConsiderThunderClap()
    if ThunderClapDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ThunderClap)
        return
    end

    PrimalSplitDesire = X.ConsiderPrimalSplit()
    if PrimalSplitDesire > 0 then
        bot:Action_UseAbility(PrimalSplit)
        return
    end

    PrimalCompanionDesire = X.ConsiderPrimalCompanion()
    if PrimalCompanionDesire > 0 then
        bot:Action_UseAbility(PrimalSplit)
        return
    end
end

function X.ConsiderThunderClap()
    if not J.CanCastAbility(ThunderClap) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = ThunderClap:GetSpecialValueInt('radius')
    local nDamage = ThunderClap:GetSpecialValueInt('damage')
    local nManaCost = ThunderClap:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {CinderBrew, PrimalSplit})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PrimalSplit})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius - 75)
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

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold2
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if  J.IsValidHero(nEnemyHeroes[1])
        and bot:WasRecentlyDamagedByAnyHero(1.5)
        and J.IsInRange(bot, nEnemyHeroes[1], nRadius)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_brewmaster_cinder_brew')
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_brewmaster_cinder_brew')
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.05 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.05 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 500)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
                local sCreepName = creep:GetUnitName()
                local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), nRadius)

                if string.find(sCreepName, 'ranged') then
                    if #nInRangeEnemy > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                if #nInRangeEnemy > 0 and J.CanCastAbility(CinderBrew) then
                    return BOT_ACTION_DESIRE_HIGH
                end

                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnMagicImmune(botTarget)
        and not botTarget:IsDisarmed()
        and not J.IsDisabled(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCinderBrew()
    if not J.CanCastAbility(CinderBrew) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, CinderBrew:GetCastRange())
    local nCastPoint = CinderBrew:GetCastPoint()
    local nRadius = CinderBrew:GetSpecialValueInt('radius')
    local nManaCost = CinderBrew:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ThunderClap, PrimalSplit})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ThunderClap, CinderBrew, PrimalSplit})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {PrimalSplit})

	if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold3 then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_brewmaster_cinder_brew')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_brewmaster_cinder_brew')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_brewmaster_cinder_brew')
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDrunkenBrawler()
    if not J.CanCastAbility(DrunkenBrawler) then
        return BOT_ACTION_DESIRE_NONE, -1
    end

    if J.GetHP(bot) < 0.33 and J.IsValidHero(nEnemyHeroes[1]) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        return BOT_ACTION_DESIRE_HIGH, 1
    end

    if J.IsGoingOnSomeone(bot) then
        return BOT_ACTION_DESIRE_HIGH, 3
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        return BOT_ACTION_DESIRE_HIGH, 2
    end

    if J.IsLaning(bot) or J.IsFarming(bot) then
        return BOT_ACTION_DESIRE_HIGH, 3
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget) and J.CanBeAttacked(botTarget) and J.IsInRange(bot, botTarget, 600) then
            return BOT_ACTION_DESIRE_HIGH, 3
        else
            return BOT_ACTION_DESIRE_HIGH, 2
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget) and J.IsInRange(bot, botTarget, 600) then
            return BOT_ACTION_DESIRE_HIGH, 3
        else
            return BOT_ACTION_DESIRE_HIGH, 2
        end
    end

    return BOT_ACTION_DESIRE_NONE, -1
end

function X.ConsiderLiquidCourage()
    if not J.CanCastAbility(LiquidCourage) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = LiquidCourage:GetCastRange()

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not allyHero:IsIllusion()
        and not allyHero:IsChanneling()
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not J.IsAttacking(allyHero)
        and J.IsRunning(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(2.0)
        then
            if (J.IsGoingOnSomeone(allyHero))
            or (J.IsRetreating(allyHero) and J.GetHP(allyHero) < 0.75)
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPrimalCompanion()
    if not bot:HasScepter()
    or not J.CanCastAbility(PrimalCompanion)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.CanCastAbilitySoon(PrimalSplit, 5.0) then
        return BOT_ACTION_DESIRE_NONE
    end

	if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
        if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 600)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPrimalSplit()
    if not J.CanCastAbility(PrimalSplit) then
        return BOT_ACTION_DESIRE_NONE
    end

    if  J.GetHP(bot) < 0.33
    and nEnemyHeroes ~= nil and #nEnemyHeroes >= 2
    and nAllyHeroes ~= nil and #nAllyHeroes == 0
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeEnemy >= 2 or botHP < 0.25 then
			return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
            if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                if J.IsCore(botTarget) or botHP < 0.3 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if botHP < 0.5 then
            if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.0) > bot:GetHealth() then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X