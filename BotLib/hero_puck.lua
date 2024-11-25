local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_puck'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)
local nBkBSphere = RandomInt(1, 2) == 1 and "item_black_king_bar" or "item_sphere"

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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
            
                "item_null_talisman",
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_witch_blade",
                "item_blink",
                "item_cyclone",
                "item_black_king_bar",--
                "item_devastator",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_mjollnir",--
                "item_ultimate_scepter_2",
                "item_overwhelming_blink",--
                "item_wind_waker",--
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_cyclone",
                "item_bottle", "item_black_king_bar",
                "item_null_talisman", "item_ultimate_scepter",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local IllusoryOrb   = bot:GetAbilityByName('puck_illusory_orb')
local WaningRift    = bot:GetAbilityByName('puck_waning_rift')
local PhaseShift    = bot:GetAbilityByName('puck_phase_shift')
local EtherealJaunt = bot:GetAbilityByName('puck_ethereal_jaunt')
local DreamCoil     = bot:GetAbilityByName('puck_dream_coil')

local IllusoryOrbDesire, IllusoryOrbLocation
local WaningRiftDesire, WaningRiftLocation
local PhaseShiftDesire
local EtherealJauntDesire
local DreamCoilDesire, DreamCoilLocation

local PhaseOrbDesire, PhaseOrbLocation

local IsRetreatOrb = false

local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    IllusoryOrb   = bot:GetAbilityByName('puck_illusory_orb')
    WaningRift    = bot:GetAbilityByName('puck_waning_rift')
    PhaseShift    = bot:GetAbilityByName('puck_phase_shift')
    EtherealJaunt = bot:GetAbilityByName('puck_ethereal_jaunt')
    DreamCoil     = bot:GetAbilityByName('puck_dream_coil')

    botTarget = J.GetProperTarget(bot)

    PhaseOrbDesire, PhaseOrbLocation, PhaseDuration = X.ConsiderPhaseOrb()
    if PhaseOrbDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(IllusoryOrb, PhaseOrbLocation)
        bot:ActionQueue_Delay(0.1 + 0.27)
        bot:ActionQueue_UseAbility(PhaseShift)
        bot:ActionQueue_Delay(PhaseDuration - 0.3)
        bot:ActionQueue_UseAbility(EtherealJaunt)
        return
    end

    EtherealJauntDesire = X.ConsiderEtherealJaunt()
    if EtherealJauntDesire > 0
    then
        if IsRetreatOrb then IsRetreatOrb = false end

        bot:Action_UseAbility(EtherealJaunt)
        return
    end

    PhaseShiftDesire = X.ConsiderPhaseShift()
    if PhaseShiftDesire > 0
    then
        bot:Action_UseAbility(PhaseShift)
        return
    end

    IllusoryOrbDesire, IllusoryOrbLocation = X.ConsiderIllusoryOrb()
    if IllusoryOrbDesire > 0
    then
        bot:Action_UseAbilityOnLocation(IllusoryOrb, IllusoryOrbLocation)
        return
    end

    DreamCoilDesire, DreamCoilLocation = X.ConsiderDreamCoil()
    if DreamCoilDesire > 0
    then
        bot:Action_UseAbilityOnLocation(DreamCoil, DreamCoilLocation)
        return
    end

    WaningRiftDesire, WaningRiftLocation = X.ConsiderWaningRift()
    if WaningRiftDesire > 0
    then
        bot:Action_UseAbilityOnLocation(WaningRift, WaningRiftLocation)
        return
    end
end

function X.ConsiderIllusoryOrb()
    if not J.CanCastAbility(IllusoryOrb)
    or bot:HasModifier('modifier_puck_phase_shift')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, IllusoryOrb:GetCastRange())
    local nCastPoint = IllusoryOrb:GetCastPoint()
	local nRadius = IllusoryOrb:GetSpecialValueInt('radius')
    local nDamage = IllusoryOrb:GetSpecialValueInt('damage')
    local nSpeed = IllusoryOrb:GetSpecialValueInt('orb_speed')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if  J.IsRunning(enemyHero)
            and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            then
                local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint + 0.27
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetExtrapolatedLocation(nDelay)
            else
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, bot:GetXUnitsTowardsLocation(bot, loc, nCastRange)
	end

    if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
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
                if  J.IsRunning(botTarget)
                and not J.IsInRange(bot, botTarget, nCastRange / 2)
                then
                    local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint + 0.27
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(nDelay)
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
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and (#nTargetInRangeAlly > #nInRangeAlly
                or bot:WasRecentlyDamagedByAnyHero(2))
            then
                IsRetreatOrb = true
                local loc = J.GetEscapeLoc()
		        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
            end
        end
    end

    if (J.IsPushing(bot) or J.IsDefending(bot))
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.GetManaAfter(IllusoryOrb:GetManaCost()) > 0.45
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint + 0.27, 0)
        if nLocationAoE.count >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot)
    then
        if  J.IsAttacking(bot)
        and J.GetManaAfter(IllusoryOrb:GetManaCost()) > 0.45
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
            if nNeutralCreeps ~= nil
            and ((#nNeutralCreeps >= 2)
                or (#nNeutralCreeps >= 1 and nNeutralCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
            end

            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
            end
        end
    end

    if J.IsLaning(bot)
	then
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
			then
				if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                and J.GetMP(bot) > 0.35
                and J.IsValidHero(nInRangeEnemy[1])
                and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
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

        if  #creepList >= 2
        and J.GetMP(bot) > 0.25
        and nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(creepList)
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWaningRift()
    if not J.CanCastAbility(WaningRift)
    or bot:HasModifier('modifier_puck_phase_shift')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastPoint = WaningRift:GetCastPoint() + 0.27
	local nRadius = WaningRift:GetSpecialValueInt('radius')
    local nDamage = WaningRift:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(nRadius + 300, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
        end
    end

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, bot:GetXUnitsTowardsLocation(bot, loc, nRadius)
	end

    if J.IsInTeamFight(bot, 1200)
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius + 300)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not J.IsLocationInBlackHole(J.GetCenterOfUnits(nInRangeEnemy))
        and not J.IsLocationInChrono(J.GetCenterOfUnits(nInRangeEnemy))
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(nCastPoint)
            end
        end
	end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], bot:GetAttackRange())
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        then
            local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and (#nTargetInRangeAlly > #nInRangeAlly
                or bot:WasRecentlyDamagedByAnyHero(2))
            then
		        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nRadius)
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(J.GetCenterOfUnits(nEnemyLaneCreeps), 1600)
            if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
            end
        end
    end

    if J.IsFarming(bot)
    then
        if J.IsAttacking(bot)
        then
            local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1200)
            if nNeutralCreeps ~= nil
            and (#nNeutralCreeps >= 3
                or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
            end

            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and not J.IsRunning(nEnemyLaneCreeps[1])
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(J.GetCenterOfUnits(nEnemyLaneCreeps), 1600)
                if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
                end
            end
        end
    end

    if  J.IsLaning(bot)
    and (not IllusoryOrb:IsTrained() or IllusoryOrb:GetCooldownTimeRemaining() >= 3)
	then
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and creep:GetHealth() <= nDamage
			then
                if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                and J.GetMP(bot) > 0.35
                and J.IsValidHero(nInRangeEnemy[1])
                and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) <= 500
                and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
				then
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                table.insert(creepList, creep)
            end
		end

        if  #creepList >= 2
        and J.GetMP(bot) > 0.25
        and nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPhaseShift()
    if not J.CanCastAbility(PhaseShift)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nDuration = PhaseShift:GetSpecialValueInt('duration')

    if J.IsStunProjectileIncoming(bot, 600)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsUnitTargetProjectileIncoming(bot, 400)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 400)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if IsRetreatOrb
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsGoingOnSomeone(bot)
    then
        if bot:WasRecentlyDamagedByAnyHero(1)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsRetreating(bot)
	then
		local blink = bot:GetItemInSlot(bot:FindItemSlot('item_blink'))
		if  blink ~= nil
        and blink:GetCooldownTimeRemaining() < nDuration
        then
			return BOT_ACTION_DESIRE_HIGH
		end

		local nProjectiles = GetLinearProjectiles()
		for _, p in pairs(nProjectiles)
		do
			if  p ~= nil
            and p.ability:GetName() == 'puck_illusory_orb'
            then
				if GetUnitToLocationDistance(bot, J.GetTeamFountain()) > J.GetDistance(p.location, J.GetTeamFountain())
                then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and (#nTargetInRangeAlly > #nInRangeAlly
                or bot:WasRecentlyDamagedByAnyHero(1))
            then
		        return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEtherealJaunt()
    if not J.CanCastAbility(EtherealJaunt)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nAttackRange = bot:GetAttackRange()
    local nDuration = 1

    if string.find(GetBot():GetUnitName(), 'puck')
    then
        nDuration = PhaseShift:GetSpecialValueInt('duration')
    end

    if IsRetreatOrb
	then
		local nProjectiles = GetLinearProjectiles()

		for _, p in pairs(nProjectiles)
        do
            if  p.ability:GetName() == 'puck_illusory_orb'
            and not J.IsLocationInChrono(p.location)
            then
                local blink = bot:GetItemInSlot(bot:FindItemSlot('item_blink'))

                if GetUnitToLocationDistance(bot, p.location) > 600
                or (blink ~= nil
                    and blink:GetCooldownTimeRemaining() < nDuration)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    else
        if J.IsGoingOnSomeone(bot)
        then
            if  J.IsValidTarget(botTarget)
            and not J.IsSuspiciousIllusion(botTarget)
            then
                local nProjectiles = GetLinearProjectiles()

                local nTargetInRangeAlly = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                local nTargetInRangeEnemy = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

                if  nTargetInRangeEnemy ~= nil and nTargetInRangeAlly ~= nil
                and #nTargetInRangeEnemy >= #nTargetInRangeAlly
                then
                    local nTargetInRangeTower = botTarget:GetNearbyTowers(800, false)

                    for _, p in pairs(nProjectiles)
                    do
                        if  p ~= nil
                        and p.ability:GetName() == 'puck_illusory_orb'
                        and not J.IsLocationInChrono(p.location)
                        then
                            if J.IsInLaningPhase()
                            then
                                if  nTargetInRangeTower ~= nil
                                and (#nTargetInRangeTower == 0
                                    or (#nTargetInRangeTower >= 1 and J.GetTotalEstimatedDamageToTarget(nTargetInRangeEnemy, botTarget)))
                                then
                                    if J.IsChasingTarget(bot, botTarget)
                                    then
                                        if botTarget:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
                                        then
                                            if GetUnitToLocationDistance(botTarget, p.location) <= nAttackRange + 150
                                            then
                                                return BOT_ACTION_DESIRE_HIGH
                                            end
                                        end
                                    else
                                        if GetUnitToUnitDistance(bot, botTarget) < GetUnitToLocationDistance(bot, p.location)
                                        then
                                            return BOT_ACTION_DESIRE_HIGH
                                        end
                                    end
                                end
                            else
                                local nInRangeAlly = J.GetAlliesNearLoc(p.location, 1000)
                                local nInRangeEnemy = J.GetEnemiesNearLoc(p.location, 1000)

                                if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
                                and #nInRangeAlly >= #nInRangeEnemy
                                then
                                    if  nTargetInRangeTower ~= nil
                                    and (#nTargetInRangeTower == 0
                                        or (#nTargetInRangeTower >= 1 and J.GetTotalEstimatedDamageToTarget(nTargetInRangeEnemy, botTarget)))
                                    then
                                        if J.IsChasingTarget(bot, botTarget)
                                        then
                                            if GetUnitToLocationDistance(botTarget, p.location) <= nAttackRange + 150
                                            then
                                                return BOT_ACTION_DESIRE_HIGH
                                            end
                                        else
                                            if GetUnitToUnitDistance(bot, botTarget) < GetUnitToLocationDistance(bot, p.location)
                                            then
                                                return BOT_ACTION_DESIRE_HIGH
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderDreamCoil()
    if not J.CanCastAbility(DreamCoil)
    or bot:HasModifier('modifier_puck_phase_shift')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, DreamCoil:GetCastRange())
	local nRadius = DreamCoil:GetSpecialValueInt('coil_radius')
    local nDuration = DreamCoil:GetSpecialValueInt('coil_duration')

    if J.IsInTeamFight(bot, 1200)
    then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
        local target = nil
        local dmg = 0
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.GetHP(enemyHero) > 0.25
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsLocationInChrono(enemyHero:GetLocation())
            and not J.IsLocationInBlackHole(enemyHero:GetLocation())
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local currDmg = enemyHero:GetEstimatedDamageToTarget(false, enemyHero, nDuration, DAMAGE_TYPE_ALL)
                if currDmg > dmg
                then
                    target = enemyHero
                    dmg = currDmg
                end
            end
        end

        if target ~= nil
        then
            local nInRangeAlly = target:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            nInRangeEnemy = target:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            and not (#nInRangeAlly >= #nInRangeEnemy + 2)
            then
                if #nInRangeAlly <= 1 and #nInRangeEnemy <= 1
                then
                    if bot:GetEstimatedDamageToTarget(true, target, nDuration, DAMAGE_TYPE_ALL) >= target:GetHealth()
                    then
                        return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_NONE, 0
                    end
                end

                nInRangeEnemy = J.GetEnemiesNearLoc(target:GetLocation(), nRadius)
                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                else
                    return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
                end
            end
        end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.75
	then
        local nInRangeTower = bot:GetNearbyTowers(700, false)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and GetUnitToLocationDistance(bot, GetAncient(GetTeam()):GetLocation()) > 3200
            and nInRangeTower ~= nil and #nInRangeTower == 0
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly and #nInRangeAlly == 0)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoPhaseOrb()
    if  J.CanCastAbility(PhaseShift)
    and J.CanCastAbility(IllusoryOrb)
    then
        local nManaCost = PhaseShift:GetManaCost() + IllusoryOrb:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

function X.ConsiderPhaseOrb()
    if X.CanDoPhaseOrb()
    then
        local nCastRange = J.GetProperCastRange(false, bot, IllusoryOrb:GetCastRange())
        local nDuration = PhaseShift:GetSpecialValueInt('duration')

        if J.IsRetreating(bot)
        then
            local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            and J.IsValidHero(nInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
            then
                local nInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and (#nTargetInRangeAlly > #nInRangeAlly
                    or bot:WasRecentlyDamagedByAnyHero(1))
                then
                    local loc = J.GetEscapeLoc()
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange), nDuration
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, 0
end

return X