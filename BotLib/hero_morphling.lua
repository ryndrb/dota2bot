local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local SPL = require( GetScriptDirectory()..'/FunLib/spell_list' )
local M = require( GetScriptDirectory()..'/FunLib/morphling_utility' )

if GetBot():GetUnitName() == 'npc_dota_hero_morphling'
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
            
                "item_wraith_band",
                "item_magic_wand",
                "item_power_treads",
                "item_vladmir",
                "item_manta",--
                "item_black_king_bar",--
                "item_angels_demise",--
                "item_butterfly",--
                "item_aghanims_shard",
                "item_satanic",--
                "item_skadi",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_angels_demise",
                "item_wraith_band", "item_butterfly",
                "item_vladmir", "item_satanic",
                "item_power_treads", "item_skadi",
            },
        },
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_power_treads",
                "item_vladmir",
                "item_manta",--
                "item_black_king_bar",--
                "item_greater_crit",--
                "item_butterfly",--
                "item_aghanims_shard",
                "item_satanic",--
                "item_skadi",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_circlet", "item_black_king_bar",
                "item_circlet", "item_greater_crit",
                "item_magic_wand", "item_butterfly",
                "item_vladmir", "item_satanic",
                "item_power_treads", "item_skadi",
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
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
            
                "item_bottle",
                "item_magic_wand",
                "item_wraith_band",
                "item_power_treads",
                "item_vladmir",
                "item_manta",--
                "item_black_king_bar",--
                "item_angels_demise",--
                "item_butterfly",--
                "item_aghanims_shard",
                "item_satanic",--
                "item_disperser",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_angels_demise",
                "item_wraith_band", "item_butterfly",
                "item_vladmir", "item_satanic",
                "item_power_treads", "item_disperser",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_double_wraith_band",
                "item_vladmir",
                "item_manta",--
                "item_black_king_bar",--
                "item_greater_crit",--
                "item_butterfly",--
                "item_aghanims_shard",
                "item_satanic",--
                "item_disperser",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_manta",
                "item_bottle", "item_black_king_bar",
                "item_wraith_band", "item_greater_crit",
                "item_wraith_band", "item_butterfly",
                "item_vladmir", "item_satanic",
                "item_power_treads", "item_disperser",
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

local Waveform              = bot:GetAbilityByName('morphling_waveform')
local AdaptiveStrikeAGI     = bot:GetAbilityByName('morphling_adaptive_strike_agi')
local AdaptiveStrikeSTR     = bot:GetAbilityByName('morphling_adaptive_strike_str')
local AttributeShiftAGI     = bot:GetAbilityByName('morphling_morph_agi')
local AttributeShiftSTR     = bot:GetAbilityByName('morphling_morph_str')
local Morph                 = bot:GetAbilityByName('morphling_replicate')
local MorphReplicate        = bot:GetAbilityByName('morphling_morph_replicate')

local WaveformDesire, WaveformLocation
local AdaptiveStrikeAGIDesire, AdaptiveStrikeAGITarget
local AdaptiveStrikeSTRDesire, AdaptiveStrikeSTRTarget
local AtttributeShiftDesire
local MorphDesire, MorphTarget

local MorphedHeroName = ''

local botTarget

if bot.IsMorphling == nil then bot.IsMorphling = true end

local nAGIRatio = 1
local nSTRRatio = 1

local AGI_BASE = 24
local STR_BASE = 23
local AGI_GROWTH_RATE = 3.9
local STR_GROWTH_RATE = 3.2

-- do similar thing as Rubick's
-- TODO: Update some bot fields from select heroes to not give errors
local heroAbilityUsage = {}
local function HandleSpell(spell)
    if spell == nil then return end

    local heroName = SPL.GetSpellHeroName(spell:GetName())

    if heroName == nil then return end

    if not heroAbilityUsage[heroName]
    then
        heroAbilityUsage[heroName] = dofile(GetScriptDirectory()..'/BotLib/'..string.gsub(heroName, 'npc_dota_', ''))
    end

    local heroSpells = heroAbilityUsage[heroName]
    if heroSpells and heroSpells.SkillsComplement
    then
        heroSpells.SkillsComplement()
    end
end

local nMorphTime = {0, math.huge}

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    Waveform              = bot:GetAbilityByName('morphling_waveform')
    AdaptiveStrikeAGI     = bot:GetAbilityByName('morphling_adaptive_strike_agi')
    AdaptiveStrikeSTR     = bot:GetAbilityByName('morphling_adaptive_strike_str')
    AttributeShiftAGI     = bot:GetAbilityByName('morphling_morph_agi')
    AttributeShiftSTR     = bot:GetAbilityByName('morphling_morph_str')

    botTarget = J.GetProperTarget(bot)

    if bot:GetAbilityInSlot(0) == Waveform then bot.IsMorphling = true else bot.IsMorphling = false end

    if bot:HasModifier('modifier_morphling_replicate_manager') then
        -- Replicate back if it's a good hero
        local nCooldownTime = M.GetMorphLength(bot, MorphedHeroName)
        if DotaTime() > nMorphTime[2] + nCooldownTime + (0.25 + 0.1) then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
            if bot.IsMorphling == true then
                if J.IsGoingOnSomeone(bot)
                and J.IsValidHero(botTarget)
                and J.IsInRange(bot, botTarget, 900)
                then
                    bot:Action_UseAbility(MorphReplicate)
                    nMorphTime[1] = DotaTime()
                    return
                end

                if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and M.IsGoodToMorphBack(MorphedHeroName)
                and Waveform:GetCooldownTimeRemaining() > 3
                then
                    if J.IsValidHero(nInRangeEnemy[1])
                    and J.IsChasingTarget(nInRangeEnemy[1], bot)
                    then
                        bot:Action_UseAbility(MorphReplicate)
                        nMorphTime[1] = DotaTime()
                        return
                    end
                end
            end
        end

        -- give 3 seconds to cast any spells
        if DotaTime() < nMorphTime[1] + 3 + (0.25 + 0.1) then
            if bot.IsMorphling == false and not MorphReplicate:IsHidden() and J.CanCastAbility(MorphReplicate) and MorphedHeroName ~= '' then
                for i = 0, 6 do
                    local hAbility = bot:GetAbilityInSlot(i)
                    if hAbility ~= nil and not hAbility ~= MorphReplicate then
                        HandleSpell(hAbility)
                    end
                end
            end
        else
            if bot.IsMorphling == false and not MorphReplicate:IsHidden() and J.CanCastAbility(MorphReplicate) then
                bot:Action_UseAbility(MorphReplicate)
                nMorphTime[2] = DotaTime()
                return
            end
        end
    else
        nMorphTime = {0, math.huge}
        MorphedHeroName = ''
    end

    if bot.IsMorphling then
        X.SetRatios()

        AtttributeShiftDesire, Type = X.ConsiderAtttributeShift()
        if AtttributeShiftDesire > 0
        then
            if Type == 'agi'
            then
                bot:Action_UseAbility(AttributeShiftAGI)
            else
                bot:Action_UseAbility(AttributeShiftSTR)
            end
            return
        end

        WaveformDesire, WaveformLocation = X.ConsiderWaveform()
        if WaveformDesire > 0
        then
            J.SetQueuePtToINT(bot, false)
            bot:ActionQueue_UseAbilityOnLocation(Waveform, WaveformLocation)
            return
        end

        AdaptiveStrikeSTRDesire, AdaptiveStrikeSTRTarget = X.ConsiderAdaptiveStrikeSTR()
        if AdaptiveStrikeSTRDesire > 0
        then
            bot:Action_UseAbilityOnEntity(AdaptiveStrikeSTR, AdaptiveStrikeSTRTarget)
            return
        end

        AdaptiveStrikeAGIDesire, AdaptiveStrikeAGITarget = X.ConsiderAdaptiveStrikeAGI()
        if AdaptiveStrikeAGIDesire > 0
        then
            J.SetQueuePtToINT(bot, false)
            bot:ActionQueue_UseAbilityOnEntity(AdaptiveStrikeAGI, AdaptiveStrikeAGITarget)
            return
        end

        MorphDesire, MorphTarget = X.ConsiderMorph()
        if MorphDesire > 0
        then
            bot:Action_UseAbilityOnEntity(Morph, MorphTarget)
            nMorphTime[1] = DotaTime()
            MorphedHeroName = MorphTarget:GetUnitName()
            return
        end
    end
end

function X.ConsiderWaveform()
    if not J.CanCastAbility(Waveform)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Waveform:GetCastRange())
	local nCastPoint = Waveform:GetCastPoint()
	local nSpeed = Waveform:GetSpecialValueInt('speed')
    local nDamage = Waveform:GetSpecialValueInt('#AbilityDamage')
    local nRadius = Waveform:GetSpecialValueInt('width')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            local targetLoc = J.GetCorrectLoc(botTarget, (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint)
            if not J.IsInRange(bot, enemyHero, nCastRange) then
                targetLoc = J.Site.GetXUnitsTowardsLocation(bot, targetLoc, nCastRange)
            end

            if J.IsInLaningPhase()
            then
                if not bot:HasModifier('modifier_tower_aura')
                and not bot:HasModifier('modifier_tower_aura_bonus')
                then
                    return BOT_ACTION_DESIRE_HIGH, targetLoc
                end
            else
                return BOT_ACTION_DESIRE_HIGH, targetLoc
            end
        end
	end

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
	end

	if J.IsStunProjectileIncoming(bot, 600)
	or J.IsUnitTargetProjectileIncoming(bot, 400)
    then
        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
    end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 400)
		then
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() - 200)
		and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local targetLoc = J.GetCorrectLoc(botTarget, (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint)
            if not J.IsInRange(bot, botTarget, nCastRange) then
                targetLoc = J.Site.GetXUnitsTowardsLocation(bot, targetLoc, nCastRange)
            end

            if IsLocationPassable(targetLoc) then
                if J.IsInLaningPhase()
                then
                    if not bot:HasModifier('modifier_tower_aura')
                    and not bot:HasModifier('modifier_tower_aura_bonus')
                    then
                        return BOT_ACTION_DESIRE_HIGH, targetLoc
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, targetLoc
                end
            end
		end
	end

	if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
    and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_MODERATE
	then
		for _, enemyHero in pairs(nEnemyHeroes)
        do
			if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
			end
        end
	end

	if J.IsPushing(bot) and J.IsAttacking(bot) and not J.IsThereCoreNearby(1000)
	then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
        if J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4
            and not J.IsInRange(bot, nEnemyLaneCreeps[1], 350)
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

	if J.IsFarming(bot)
    and J.IsAttacking(bot)
    and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH
    and J.GetManaAfter(Waveform:GetManaCost()) > 0.4
	then
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
        if J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if (nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
            and not J.IsInRange(bot, nEnemyCreeps[1], 350)
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

	if J.IsDoingRoshan(bot) and J.GetManaAfter(Waveform:GetManaCost()) > 0.75
    then
		local roshLoc = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, roshLoc) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, roshLoc, nCastRange)

			if #nEnemyHeroes == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end
        end
    end

    if J.IsDoingTormentor(bot) and J.GetManaAfter(Waveform:GetManaCost()) > 0.75
    then
		local tormentorLoc = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, tormentorLoc) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, tormentorLoc, nCastRange)

			if #nEnemyHeroes == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAdaptiveStrikeAGI()
    if not J.CanCastAbility(AdaptiveStrikeAGI)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, AdaptiveStrikeAGI:GetCastRange())
	local nMinAGI = AdaptiveStrikeAGI:GetSpecialValueFloat('damage_min')
	local nMaxAGI = AdaptiveStrikeAGI:GetSpecialValueFloat('damage_max')
	local nCurrAGI = bot:GetAttributeValue(ATTRIBUTE_AGILITY)
	local nCurrSTR = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
	local nDamage = AdaptiveStrikeAGI:GetSpecialValueInt('damage_base')

	if nCurrAGI > nCurrSTR * 1.5
    then
		nDamage = nDamage + nMaxAGI * nCurrAGI
	else
		nDamage = nDamage + nMinAGI * nCurrAGI
	end

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
                if J.HasItem(bot, 'item_phylactery') or J.HasItem(bot, 'item_angels_demise')
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                else
                    if J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget
                    end
                end
			end
		end
	end

    if  J.IsLaning(bot)
    and J.IsInLaningPhase()
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then

				if  (bot:GetTarget() ~= creep or bot:GetAttackTarget() ~= creep)
                and J.GetManaAfter(AdaptiveStrikeAGI:GetManaCost()) > 0.2
                and J.CanBeAttacked(creep)
				then
                    if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    and J.IsValidHero(nInRangeEnemy[1])
                    and nInRangeEnemy[1]:GetAttackTarget() ~= bot
                    and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
                    and not J.IsDisabled(nInRangeEnemy[1])
                    and not bot:WasRecentlyDamagedByTower(1)
                    and GetUnitToUnitDistance(creep, nInRangeEnemy[1]) < nInRangeEnemy[1]:GetAttackRange()
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
				end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderAdaptiveStrikeSTR()
    if not J.CanCastAbility(AdaptiveStrikeSTR)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, AdaptiveStrikeSTR:GetCastRange())

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
	end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_MODERATE
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
		for _, enemyHero in pairs(nInRangeEnemy)
        do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			then
				local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
				local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

				if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
				and ((#nTargetInRangeAlly > #nInRangeAlly)
					or bot:WasRecentlyDamagedByAnyHero(1.5))
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderAtttributeShift()
    if not J.CanCastAbility(AttributeShiftAGI)
    or not J.CanCastAbility(AttributeShiftSTR)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botHP = J.GetHP(bot)
    local botNetworth = bot:GetNetWorth()
    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if (J.IsRetreating(bot) and not J.IsRealInvisible(bot)
        and bot:GetActiveModeDesire() > 0.75
        and bot:WasRecentlyDamagedByAnyHero(1.5))
    or (bot:GetActiveMode() == BOT_MODE_ASSEMBLE_WITH_HUMANS and bot:GetActiveModeDesire() > 0.65)
    then
        if AttributeShiftSTR:GetToggleState() == false then
            return BOT_ACTION_DESIRE_HIGH, 'str'
        end

        return BOT_ACTION_DESIRE_NONE, ''
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and (J.CanBeAttacked(botTarget) or #nEnemyHeroes > 1)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 400)
        then
            local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.5, 0.9)
            if #nEnemyHeroes > #nAllyHeroes then
                ratio = ratio * 0.75
            end

            if nAGIRatio < ratio and botHP > 0.3 then
                if AttributeShiftAGI:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nAGIRatio > ratio + 0.1 then
                    if AttributeShiftSTR:GetToggleState() == true then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end

                    return BOT_ACTION_DESIRE_NONE, ''
                end

                if AttributeShiftAGI:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end

                if AttributeShiftSTR:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end
        end

        if AttributeShiftAGI:GetToggleState() == true then
            return BOT_ACTION_DESIRE_HIGH, 'agi'
        end
    end

    if J.IsPushing(bot)
    then
        local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.55, 0.85)
        if #nEnemyHeroes > #nAllyHeroes then
            ratio = ratio * 0.75
        end

        if nAGIRatio < ratio and botHP > 0.3 then
            if AttributeShiftAGI:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        else
            if nAGIRatio > ratio + 0.1 then
                if AttributeShiftSTR:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if AttributeShiftAGI:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            if AttributeShiftSTR:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'str'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end
    end

    if  J.IsLaning(bot)
    and J.IsInLaningPhase()
    then
        local nRatio = RemapValClamped(bot:GetHealth(), bot:GetMaxHealth() * 0.5, bot:GetMaxHealth(), 0.5, 0.77)
        if nAGIRatio < nRatio then
            if AttributeShiftAGI:GetToggleState() == false
            then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        else
            if nAGIRatio > nRatio + 0.1 then
                if AttributeShiftSTR:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if AttributeShiftAGI:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            if AttributeShiftSTR:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'str'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end
    end

    if J.IsFarming(bot) and botHP > 0.3
    then
        local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.55, 0.85)
        if #nEnemyHeroes > #nAllyHeroes then
            ratio = ratio * 0.75
        end

        if nAGIRatio < ratio then
            if AttributeShiftAGI:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        else
            if nAGIRatio > ratio + 0.1 then
                if AttributeShiftSTR:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if AttributeShiftAGI:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            if AttributeShiftSTR:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'str'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
    then
        if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1000)
        then
            local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.55, 0.85)
            if #nEnemyHeroes > #nAllyHeroes then
                ratio = ratio * 0.75
            end

            if nAGIRatio < ratio and botHP > 0.35 then
                if AttributeShiftAGI:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nAGIRatio > ratio + 0.1 then
                    if AttributeShiftSTR:GetToggleState() == true then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end

                    return BOT_ACTION_DESIRE_NONE, ''
                end

                if AttributeShiftAGI:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end

                if AttributeShiftSTR:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end
        end
    end

    if  bot:DistanceFromFountain() < 1200
    and bot:HasModifier('modifier_fountain_aura_buff')
    and J.GetHP(bot) > 0.2
    and DotaTime() > 0
    and not bot:WasRecentlyDamagedByAnyHero(1)
    then

        if nAGIRatio < 0.5
        then
            if AttributeShiftAGI:GetToggleState() == false
            then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end
        else
            if nAGIRatio > 0.5 + 0.1 then
                if AttributeShiftSTR:GetToggleState() == true then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if AttributeShiftAGI:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'agi'
            end

            if AttributeShiftSTR:GetToggleState() == true then
                return BOT_ACTION_DESIRE_HIGH, 'str'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end

        return BOT_ACTION_DESIRE_NONE, ''
    end

    if AttributeShiftSTR:GetToggleState() == true
    then
        return BOT_ACTION_DESIRE_HIGH, 'str'
    end

    if AttributeShiftAGI:GetToggleState() == true
    then
        return BOT_ACTION_DESIRE_HIGH, 'agi'
    end

    return BOT_ACTION_DESIRE_NONE, ''
end

function X.ConsiderMorph()
    if not J.CanCastAbility(Morph)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Morph:GetCastRange())
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)

	if J.IsGoingOnSomeone(bot)
	then
        local target = nil
        local targetScore = 0

        if (J.IsEarlyGame() and #nInRangeEnemy > 0)
        or #nInRangeEnemy > 1
        then
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                then
                    local score = M.GetMorphEngageScore(enemyHero:GetUnitName())
                    if score > targetScore then
                        target = enemyHero
                        targetScore = score
                    end
                end
            end
        end

        if target ~= nil then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH
    and bot:WasRecentlyDamagedByAnyHero(3.0)
    and Waveform:GetCooldownTimeRemaining() > 3
	then
        local target = nil
        local targetScore = 0

        for _, enemyHero in pairs(nInRangeEnemy) do
            if J.IsValidHero(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            then
                local score = M.GetMorphRetreatScore(enemyHero:GetUnitName())
                if score > targetScore then
                    target = enemyHero
                    targetScore = score
                end
            end
        end

        if target ~= nil then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.SetRatios()
    local count = 0
    local nAddedAGI = 0
    local nAddedSTR = 0

    -- Iron Branches
    if J.HasItem(bot, 'item_branches')
    then
        count = X.CountItemsInInventory('item_branches')
        nAddedAGI = nAddedAGI + 1 * count
        nAddedSTR = nAddedSTR + 1 * count
    end

    -- Circlet
    if J.HasItem(bot, 'item_circlet')
    then
        count = X.CountItemsInInventory('item_circlet')
        nAddedAGI = nAddedAGI + 2 * count
        nAddedSTR = nAddedSTR + 2 * count
    end

    -- Slippers of Agility
    if J.HasItem(bot, 'item_slippers')
    then
        count = X.CountItemsInInventory('item_slippers')
        nAddedAGI = nAddedAGI + 3 * count
    end

    -- Wraith Band
    if J.HasItem(bot, 'item_wraith_band')
    then
        count = X.CountItemsInInventory('item_wraith_band')
        nAddedAGI = nAddedAGI + count * 5
        nAddedSTR = nAddedSTR + count * 2
    end

    -- Boots of Elves
    if J.HasItem(bot, 'item_boots_of_elves')
    then
        count = X.CountItemsInInventory('item_boots_of_elves')
        nAddedAGI = nAddedAGI + 6 * count
    end

    -- Magic Wand
    if J.HasItem(bot, 'item_magic_wand')
    then
        nAddedAGI = nAddedAGI + 3
        nAddedSTR = nAddedSTR + 3
    end

    -- Power Treads
    if J.HasItem(bot, 'item_power_treads')
    then
        local hItem = J.GetItem('item_power_treads')
        if hItem ~= nil
        then
            local nState = hItem:GetPowerTreadsStat()

            if nState == ATTRIBUTE_AGILITY
            then
                nAddedAGI = nAddedAGI + 10
            elseif nState == ATTRIBUTE_STRENGTH
            then
                nAddedSTR = nAddedSTR + 10
            end
        end
    end

    -- Blades of Alacrity
    if J.HasItem(bot, 'item_blade_of_alacrity')
    then
        count = X.CountItemsInInventory('item_boots_of_elves')
        nAddedAGI = nAddedAGI + 10 * count
    end

    -- Yasha
    if J.HasItem(bot, 'item_yasha')
    then
        nAddedAGI = nAddedAGI + 16
    end

    -- Manta
    if J.HasItem(bot, 'item_manta')
    then
        nAddedAGI = nAddedAGI + 26
        nAddedSTR = nAddedSTR + 10
    end

    -- Diadem
    if J.HasItem(bot, 'item_diadem')
    then
        count = X.CountItemsInInventory('item_diadem')
        nAddedAGI = nAddedAGI + 6 * count
        nAddedSTR = nAddedSTR + 6 * count
    end

    -- Phylactery
    if J.HasItem(bot, 'item_phylactery')
    then
        nAddedAGI = nAddedAGI + 7
        nAddedSTR = nAddedSTR + 7
    end

    -- Khanda
    if J.HasItem(bot, 'item_angels_demise')
    then
        nAddedAGI = nAddedAGI + 8
        nAddedSTR = nAddedSTR + 8
    end

    -- Ogre Axe
    if J.HasItem(bot, 'item_ogre_axe')
    then
        nAddedSTR = nAddedSTR + 10
    end

    -- Black King Bar
    if J.HasItem(bot, 'item_black_king_bar')
    then
        nAddedSTR = nAddedSTR + 10
    end

    -- Eagle Song
    if J.HasItem(bot, 'item_eagle')
    then
        nAddedAGI = nAddedAGI + 25
    end

    -- Butterfly
    if J.HasItem(bot, 'item_eagle')
    then
        nAddedAGI = nAddedAGI + 35
    end

    -- Reaver
    if J.HasItem(bot, 'item_reaver')
    then
        nAddedSTR = nAddedSTR + 25
    end

    -- Satanic
    if J.HasItem(bot, 'item_satanic')
    then
        nAddedSTR = nAddedSTR + 25
    end

    -- Diffusal Blade
    if J.HasItem(bot, 'item_diffusal_blade')
    then
        nAddedAGI = nAddedAGI + 15
    end

    -- Disperser
    if J.HasItem(bot, 'item_disperser')
    then
        nAddedAGI = nAddedAGI + 40
    end

    -- Scepter
    if bot:HasModifier('modifier_item_ultimate_scepter')
    then
        nAddedAGI = nAddedAGI + 10
        nAddedSTR = nAddedSTR + 10
    end

    -- Ultimate Orb
    if bot:HasModifier('item_ultimate_orb')
    then
        nAddedAGI = nAddedAGI + 15
        nAddedSTR = nAddedSTR + 15
    end

    -- Skadi
    if bot:HasModifier('item_skadi')
    then
        nAddedAGI = nAddedAGI + 22
        nAddedSTR = nAddedSTR + 22
    end

    -- Stats
    count = 0
    if bot:GetLevel() >= 26 then count = 7
    elseif bot:GetLevel() >= 24 then count = 6
    elseif bot:GetLevel() >= 23 then count = 5
    elseif bot:GetLevel() >= 22 then count = 4
    elseif bot:GetLevel() >= 21 then count = 3
    elseif bot:GetLevel() >= 19 then count = 2
    elseif bot:GetLevel() >= 17 then count = 1
    end

    -- Stats Talents
    local talent_15 = bot:GetAbilityInSlot(12)
    local talent_25 = bot:GetAbilityInSlot(16)

    if talent_15 ~= nil and talent_15:IsTrained() then
        nAddedAGI = nAddedAGI + 15
    end

    if talent_25 ~= nil and talent_25:IsTrained() then
        nAddedSTR = nAddedSTR + 35
    end

    nAddedAGI = nAddedAGI + 2 * count * 2 -- from innate
    nAddedSTR = nAddedSTR + 2 * count * 2 -- from innate

    local nBaseAGI = AGI_BASE + AGI_GROWTH_RATE * (bot:GetLevel() - 1)
    local nBaseSTR = STR_BASE + STR_GROWTH_RATE * (bot:GetLevel() - 1)

    local nTotalAGI = bot:GetAttributeValue(ATTRIBUTE_AGILITY)
    local nTotalSTR = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)

    local nShiftedAGI = nTotalAGI - nBaseAGI
    local nShiftedSTR = nTotalSTR - nBaseSTR

    local nEffAGI = nBaseAGI + nShiftedAGI - nAddedAGI
    local nEffSTR = nBaseSTR + nShiftedSTR - nAddedSTR

    nAGIRatio = nEffAGI / (nEffAGI + nEffSTR)
    nSTRRatio = nEffSTR / (nEffAGI + nEffSTR)
end

function X.CountItemsInInventory(itemName)
    local count = 0
    for i = 0, 5
    do
        local item = bot:GetItemInSlot(i)
        if  item ~= nil
        and item:GetName() == itemName
        then
            count = count + 1
        end
    end

	return count
end

return X