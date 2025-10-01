local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local SPL = require( GetScriptDirectory()..'/FunLib/spell_list' )

local sSelectedBuild = {}
local HeroBuild = {}
local nAbilityBuildList
local nTalentBuildList

if GetBot():GetUnitName() == 'npc_dota_hero_morphling'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

HeroBuild = {
    ['pos_1'] = {
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
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_circlet",
            
                "item_magic_wand",
                "item_power_treads",
                "item_vladmir",
                "item_manta",--
                "item_butterfly",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_skadi",--
                "item_moon_shard",
                "item_satanic",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_circlet", "item_black_king_bar",
                "item_magic_wand", "item_greater_crit",
                "item_power_treads", "item_skadi",
                "item_vladmir", "item_satanic",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_branches",
                "item_gloves",
            
                "item_magic_wand",
                "item_power_treads",
                "item_lifesteal",
                "item_mjollnir",--
                "item_butterfly",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_satanic",--
                "item_orchid",
                "item_moon_shard",
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_greater_crit",
                "item_power_treads", "item_bloodthorn",
            },
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
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_vladmir",
                "item_manta",--
                "item_butterfly",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_disperser",--
                "item_moon_shard",
                "item_satanic",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_circlet", "item_butterfly",
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_greater_crit",
                "item_power_treads", "item_disperser",
                "item_vladmir", "item_satanic",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {4,2,1,1,1,6,1,4,4,2,2,6,4,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_circlet",
            
                "item_bottle",
                "item_power_treads",
                "item_magic_wand",
                "item_maelstrom",
                "item_dragon_lance",
                "item_butterfly",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_revenants_brooch",--
                "item_mjollnir",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_circlet", "item_butterfly",
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_revenants_brooch",
                "item_power_treads", "item_bloodthorn",
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

sSelectedBuild = HeroBuild[sRole][1]

nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local bFlowFacet = false

if bot.IsMorphling == nil then bot.IsMorphling = true end

local nAGIRatio = 1
local nSTRRatio = 1

local AGI_BASE = 24
local STR_BASE = 23
local AGI_GROWTH_RATE = 3.9
local STR_GROWTH_RATE = 2.6

-- do similar thing as Rubick's
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
local nAverageCooldownTime = math.pi

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Waveform              = bot:GetAbilityByName('morphling_waveform')
    AdaptiveStrikeAGI     = bot:GetAbilityByName('morphling_adaptive_strike_agi')
    AdaptiveStrikeSTR     = bot:GetAbilityByName('morphling_adaptive_strike_str')
    AttributeShiftAGI     = bot:GetAbilityByName('morphling_morph_agi')
    AttributeShiftSTR     = bot:GetAbilityByName('morphling_morph_str')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    bFlowFacet = bot:GetPrimaryAttribute() == ATTRIBUTE_STRENGTH and true or false

    if bot:GetAbilityInSlot(0) == Waveform then bot.IsMorphling = true else bot.IsMorphling = false end

    if bot:HasModifier('modifier_morphling_replicate_manager') then
        -- replicate back
        if DotaTime() > nMorphTime[2] + nAverageCooldownTime + (0.25 + 0.1) then
            if bot.IsMorphling == true then
                if J.IsGoingOnSomeone(bot)
                and J.IsValidHero(botTarget)
                and J.IsInRange(bot, botTarget, 900)
                then
                    if (IsGoodToMorphBack(MorphedHeroName, true))
                    or (botHP > 0.8)
                    or (botHP > 0.5 and #nAllyHeroes > #nEnemyHeroes)
                    then
                        bot:Action_UseAbility(MorphReplicate)
                        nMorphTime[1] = DotaTime()
                        return
                    end
                end

                if J.IsRetreating(bot)
                and not J.IsRealInvisible(bot)
                and IsGoodToMorphBack(MorphedHeroName, false)
                and not J.CanCastAbility(Waveform, 3)
                then
                    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                    if #nInRangeEnemy > 0 and botHP > 0.4 then
                        bot:Action_UseAbility(MorphReplicate)
                        nMorphTime[1] = DotaTime()
                        return
                    end
                end
            end
        end

        -- give 3 seconds to cast any spells
        if DotaTime() < nMorphTime[1] + 3 + (0.25 + 0.1) then
            if bot.IsMorphling == false and J.CanCastAbility(MorphReplicate) then
                -- just average it out
                if nAverageCooldownTime == math.pi then
                    local bCanCastAnAbility = false
                    local count = 0
                    local weightedCooldownSum = 0
                    local totalWeight = 0

                    for i = 0, 7 do
                        local hAbility = bot:GetAbilityInSlot(i)
                        if  hAbility
                        and hAbility ~= MorphReplicate
                        and hAbility:IsTrained()
                        and not hAbility:IsPassive()
                        and string.find(hAbility:GetName(), string.gsub(MorphedHeroName, 'npc_dota_hero_',''))
                        and not string.find(hAbility:GetName(), 'morphling')
                        then
                            if J.CanCastAbilitySoon(hAbility, 1.5) then
                                bCanCastAnAbility = true
                            end

                            -- weigh shorter cooldowns more
                            local nCooldown = hAbility:GetCooldown()
                            if nCooldown > 0 then
                                local weight = 1 / math.sqrt(nCooldown)
                                weightedCooldownSum = weightedCooldownSum + (nCooldown * weight)
                                totalWeight = totalWeight + weight
                                count = count + 1
                            end
                        end
                    end

                    -- 'nothing' to cast
                    if not bCanCastAnAbility then
                        bot:Action_UseAbility(MorphReplicate)
                        nMorphTime[2] = DotaTime()
                        return
                    end

                    if count > 0 then
                        nAverageCooldownTime = Max(weightedCooldownSum / totalWeight, math.pi)
                    end
                end

                for i = 0, 6 do
                    local hAbility = bot:GetAbilityInSlot(i)
                    if hAbility ~= nil and hAbility ~= MorphReplicate then
                        HandleSpell(hAbility)
                    end
                end
            end
        else
            local bShouldReplicateToMorph = true

            if bot:HasModifier('modifier_terrorblade_metamorphosis')
            or bot:HasModifier('modifier_terrorblade_metamorphosis_transform')
            then
                if botHP > 0.4 and J.IsGoingOnSomeone(bot) then
                    bShouldReplicateToMorph = false
                end
            end

            if MorphedHeroName == 'npc_dota_hero_obsidian_destroyer' then
                local hAbility1 = bot:GetAbilityInSlot(0)
                local hAbility3 = bot:GetAbilityInSlot(2)
                if  (hAbility1 and hAbility1:IsTrained() and hAbility1:GetLevel() >= 3)
                and (hAbility3 and hAbility3:IsTrained() and hAbility1:GetLevel() >= 3)
                then
                    if J.IsGoingOnSomeone(bot) then
                        bShouldReplicateToMorph = false
                    end
                end
            end

            if bShouldReplicateToMorph then
                if bot.IsMorphling == false and J.CanCastAbility(MorphReplicate) then
                    bot:Action_UseAbility(MorphReplicate)
                    nMorphTime[2] = DotaTime()
                    return
                end
            end
        end
    else
        nAverageCooldownTime = math.pi
        nMorphTime = {0, math.huge}
        MorphedHeroName = ''
    end

    if bot.IsMorphling then
        X.SetRatios()

        AtttributeShiftDesire, Type = X.ConsiderAtttributeShift()
        if AtttributeShiftDesire > 0 then
            if Type == 'agi' then
                bot:Action_UseAbility(AttributeShiftAGI)
            else
                bot:Action_UseAbility(AttributeShiftSTR)
            end
            return
        end

        WaveformDesire, WaveformLocation = X.ConsiderWaveform()
        if WaveformDesire > 0 then
            J.SetQueuePtToINT(bot, false)
            bot:ActionQueue_UseAbilityOnLocation(Waveform, WaveformLocation)
            return
        end

        AdaptiveStrikeSTRDesire, AdaptiveStrikeSTRTarget = X.ConsiderAdaptiveStrikeSTR()
        if AdaptiveStrikeSTRDesire > 0 then
            bot:Action_UseAbilityOnEntity(AdaptiveStrikeSTR, AdaptiveStrikeSTRTarget)
            return
        end

        AdaptiveStrikeAGIDesire, AdaptiveStrikeAGITarget = X.ConsiderAdaptiveStrikeAGI()
        if AdaptiveStrikeAGIDesire > 0 then
            J.SetQueuePtToINT(bot, false)
            bot:ActionQueue_UseAbilityOnEntity(AdaptiveStrikeAGI, AdaptiveStrikeAGITarget)
            return
        end

        MorphDesire, MorphTarget = X.ConsiderMorph()
        if MorphDesire > 0 then
            bot:Action_UseAbilityOnEntity(Morph, MorphTarget)
            nMorphTime[1] = DotaTime()
            MorphedHeroName = MorphTarget:GetUnitName()
            return
        end
    end
end

function X.ConsiderWaveform()
    if not J.CanCastAbility(Waveform) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Waveform:GetCastRange())
	local nCastPoint = Waveform:GetCastPoint()
	local nSpeed = Waveform:GetSpecialValueInt('speed')
    local nDamage = Waveform:GetSpecialValueInt('#AbilityDamage')
    local nRadius = Waveform:GetSpecialValueInt('width')
    local nManaCost = Waveform:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AdaptiveStrikeAGI, Morph})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Waveform, AdaptiveStrikeAGI, Morph})

    local vTeamFountain = J.GetTeamFountain()
    local vLocationTeamFountain = J.VectorTowards(bot:GetLocation(), vTeamFountain, nCastRange)

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, vLocationTeamFountain
	end

    if not J.IsRealInvisible(bot) and not bot:IsMagicImmune() then
        if (J.IsStunProjectileIncoming(bot, 500))
        or (J.IsUnitTargetProjectileIncoming(bot, 500))
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400))
        then
            return BOT_ACTION_DESIRE_HIGH, vLocationTeamFountain
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local bStronger = J.WeAreStronger(bot, 1200)

            if #nAllyHeroes >= #nEnemyHeroes and bStronger then
                local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), 300)
                local bTowerNearby = botTarget:HasModifier('modifier_tower_aura_bonus')

                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    if IsLocationPassable(vLocation) then
                        if J.IsInLaningPhase() then
                            if not bTowerNearby or (J.WillKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL, eta)) then
                                return BOT_ACTION_DESIRE_HIGH, vLocation
                            end
                        else
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end

                if GetUnitToLocationDistance(bot, vLocation) > nCastRange and GetUnitToLocationDistance(bot, vLocation) < nCastRange + 350 then
                    if IsLocationPassable(vLocation) then
                        if J.IsInLaningPhase() then
                            if not bTowerNearby or (J.WillKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL, eta)) then
                                return BOT_ACTION_DESIRE_HIGH, vLocation
                            end
                        else
                            return BOT_ACTION_DESIRE_HIGH, vLocation
                        end
                    end
                end
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if (J.IsChasingTarget(enemyHero, bot) and not J.IsInTeamFight(bot, 1200) and bot:WasRecentlyDamagedByAnyHero(3.0))
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (botHP < 0.65 and bot:WasRecentlyDamagedByAnyHero(3.0))
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocationTeamFountain
                end
			end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and fManaAfter > 0.5 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and not J.IsLateGame() then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    local vLocation = J.VectorAway(nLocationAoE.targetloc, bot:GetLocation(), 350)
                    if IsLocationPassable(vLocation) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold2 and DotaTime() >= 6 * 60 then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			local vLocation = J.VectorTowards(bot:GetLocation(), bot.rune.location, Min(nCastRange, distance))
			if J.IsRunning(bot) and distance > nCastRange / 2 and distance < 1600 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsDoingRoshan(bot) and fManaAfter > fManaThreshold2 and fManaAfter > 0.5 then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 2000 and #nEnemyHeroes == 0 and IsLocationPassable(vRoshanLocation) then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), vRoshanLocation, nCastRange)
        end
    end

	if J.IsDoingTormentor(bot) and fManaAfter > fManaThreshold2 and fManaAfter > 0.5 then
		local vTormentorLocation = J.GetTormentorWaitingLocation(GetTeam())
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 2000 and #nEnemyHeroes == 0 and IsLocationPassable(vTormentorLocation) then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), vTormentorLocation, nCastRange)
        end
    end

    local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
    if nLocationAoE.count >= 5 and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 then
        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAdaptiveStrikeAGI()
    if not J.CanCastAbility(AdaptiveStrikeAGI) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, AdaptiveStrikeAGI:GetCastRange())
    local nCastPoint = AdaptiveStrikeAGI:GetCastPoint()
	local nMinAGI = AdaptiveStrikeAGI:GetSpecialValueFloat('damage_min')
	local nMaxAGI = AdaptiveStrikeAGI:GetSpecialValueFloat('damage_max')
	local nCurrAGI = bot:GetAttributeValue(ATTRIBUTE_AGILITY)
	local nCurrSTR = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
	local nDamage = AdaptiveStrikeAGI:GetSpecialValueInt('damage_base')
    local nSpeed = AdaptiveStrikeAGI:GetSpecialValueInt('projectile_speed')
    local nManaCost = AdaptiveStrikeAGI:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Waveform, Morph})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Waveform, AdaptiveStrikeAGI, Morph})
    local bUsingMax = nCurrAGI > nCurrSTR * 1.5

	if bUsingMax then
		nDamage = nDamage + nMaxAGI * nCurrAGI
	else
		nDamage = nDamage + nMinAGI * nCurrAGI
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if nCurrSTR > nCurrAGI * 1.5 then
                if enemyHero:HasModifier('modifier_teleporting') then
                    if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nDelay then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 and not J.IsRealInvisible(bot) and not J.IsRetreating(bot) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end

            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay)
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

    if J.IsInTeamFight(bot, 1200) or J.IsGoingOnSomeone(bot) and bUsingMax then
        local hTarget = nil
        local hTargetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            then
                if J.IsInEtherealForm(enemyHero) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end

                local enemyHeroDamage = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL) / enemyHero:GetHealth()
                if enemyHeroDamage > hTargetScore then
                    hTarget = enemyHero
                    hTargetScore = enemyHeroDamage
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
    end

	if J.IsGoingOnSomeone(bot) and bUsingMax then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_ursa_enrage')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bUsingMax then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			then
                if (botHP < 0.75 and bot:WasRecentlyDamagedByAnyHero(3.0))
                or (J.IsChasingTarget(enemyHero, bot))
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
			end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and (bFlowFacet or bUsingMax) then
        local creepTarget = nil
        local creepTargetScore = 0
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnTargetAdvanced(creep)
            and J.GetHP(creep) > 0.4
            then
                local creepScore = creep:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL) / creep:GetHealth()
                if creepScore > creepTargetScore then
                    creepTarget = creep
                    creepTargetScore = creepScore
                end
            end
        end

        if creepTarget then
            return BOT_ACTION_DESIRE_HIGH, creepTarget
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnTargetAdvanced(creep)
			and (not bFlowFacet and (J.IsKeyWordUnit('ranged', creep)
                    or J.IsKeyWordUnit('siege', creep)
                    or J.IsKeyWordUnit('flagbearer', creep))
                or fManaAfter > 0.5)
			then
                local nDelay = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nDelay) then
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
			end
		end
	end

	if J.IsDoingRoshan(bot) and bUsingMax then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) and bUsingMax then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
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

    local botNetworth = bot:GetNetWorth()
    local botAttackRange = bot:GetAttackRange()
    local bToggleState__AGI = AttributeShiftAGI:GetToggleState()
    local bToggleState__STR = AttributeShiftSTR:GetToggleState()

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
    local nEnemyTowers = bot:GetNearbyTowers(1100, true)
    local bStronger = J.WeAreStronger(bot, 1600)

    local nCurrAGI = bot:GetAttributeValue(ATTRIBUTE_AGILITY)
	local nCurrSTR = bot:GetAttributeValue(ATTRIBUTE_STRENGTH)
    local nCurrAGIRatio = nCurrAGI / nCurrSTR * 1.5

    if (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0)) then
        if bot:WasRecentlyDamagedByAnyHero(3.0) then
            if bToggleState__STR == false then
                return BOT_ACTION_DESIRE_HIGH, 'str'
            end
            return BOT_ACTION_DESIRE_NONE, ''
        end

        if bot:HasModifier('modifier_fountain_aura_buff') and #nInRangeEnemy == 0 then
            if nAGIRatio < 0.5 then
                if bToggleState__AGI == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nAGIRatio > 0.5 + 0.02 then
                    if bToggleState__STR == false then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                end
            end
            return BOT_ACTION_DESIRE_NONE, ''
        end

        if bToggleState__STR == true then
            return BOT_ACTION_DESIRE_HIGH, 'str'
        end
        return BOT_ACTION_DESIRE_NONE, ''
    end

    if bFlowFacet then
        -- balance ratio to do some right-click damage
        -- challenging to play around his ult (use spells), so can't take advantage of the spell amp

        if botNetworth > 30000 then
            if nCurrAGIRatio < 1.0 then
                if bToggleState__AGI == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nCurrAGIRatio > 1.0 + 0.02 then
                    if bToggleState__STR == false then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                end
            end
        else
            local ratio = J.IsInLaningPhase() and 0.4 or 0.6
            if botNetworth > 20000 then
                ratio = 0.5
            end

            if nAGIRatio < ratio then
                if bToggleState__AGI == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            end

            if nAGIRatio > ratio + 0.02 then
                if bToggleState__STR == false then
                    return BOT_ACTION_DESIRE_HIGH, 'str'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            end
        end
    else
        if J.IsGoingOnSomeone(bot) then
            if J.IsValidHero(botTarget)
            and (J.CanBeAttacked(botTarget) or #nInRangeEnemy > 1)
            and J.IsInRange(bot, botTarget, botAttackRange + 300)
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local ratio = RemapValClamped(botNetworth, 5000, 25000, 0.5, 0.90)

                if #nInRangeEnemy > #nInRangeAlly and not bStronger then
                    ratio = ratio * 0.75
                end

                if nAGIRatio < ratio and botHP > 0.3 then
                    if bToggleState__AGI == false then
                        return BOT_ACTION_DESIRE_HIGH, 'agi'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                else
                    if nAGIRatio > ratio + 0.02 then
                        if bToggleState__STR == false then
                            return BOT_ACTION_DESIRE_HIGH, 'str'
                        end
                        return BOT_ACTION_DESIRE_NONE, ''
                    end
                end
            end
        end

        if J.IsPushing(bot) or J.IsDefending(bot) then
            local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.5, 0.75)
            if #nInRangeEnemy > #nInRangeAlly and not bStronger then
                ratio = ratio * 0.75
            end

            if nAGIRatio < ratio and botHP > 0.3 then
                if bToggleState__AGI == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nAGIRatio > ratio + 0.02 then
                    if bToggleState__STR == false then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                end
            end
        end

        if J.IsLaning(bot) and J.IsInLaningPhase() then
            local ratio = RemapValClamped(bot:GetLevel(), 1, 6, 0.55, 0.6)

            if nAGIRatio < ratio then
                if bToggleState__AGI == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nAGIRatio > ratio + 0.02 then
                    if bToggleState__STR == false then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                end
            end
        end

        if J.IsFarming(bot) and botHP > 0.3 then
            local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.55, 0.85)
            if nAGIRatio < ratio then
                if bToggleState__AGI == false then
                    return BOT_ACTION_DESIRE_HIGH, 'agi'
                end
                return BOT_ACTION_DESIRE_NONE, ''
            else
                if nAGIRatio > ratio + 0.02 then
                    if bToggleState__STR == false then
                        return BOT_ACTION_DESIRE_HIGH, 'str'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                end
            end
        end

        if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
            if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, 1000)
            then
                local ratio = RemapValClamped(botNetworth, 5000, 20000, 0.5, 0.85)
                if nAGIRatio < ratio and botHP > 0.35 then
                    if bToggleState__AGI == false then
                        return BOT_ACTION_DESIRE_HIGH, 'agi'
                    end
                    return BOT_ACTION_DESIRE_NONE, ''
                else
                    if nAGIRatio > ratio + 0.02 then
                        if bToggleState__STR == false then
                            return BOT_ACTION_DESIRE_HIGH, 'str'
                        end
                        return BOT_ACTION_DESIRE_NONE, ''
                    end
                end
            end
        end
    end

    if bToggleState__STR == true then
        return BOT_ACTION_DESIRE_HIGH, 'str'
    end

    if bToggleState__AGI == true then
        return BOT_ACTION_DESIRE_HIGH, 'agi'
    end

    return BOT_ACTION_DESIRE_NONE, ''
end

function X.ConsiderMorph()
    if not J.CanCastAbility(Morph) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Morph:GetCastRange())

    if J.IsInTeamFight(bot, 1200) then
        local target = nil
        local targetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not string.find(enemyHero:GetUnitName(), 'huskar')
            and not string.find(enemyHero:GetUnitName(), 'invoker')
            then
                local enemyHeroScore = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_MAGICAL)
                                     + enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_PURE)
                if enemyHeroScore > targetScore then
                    target = enemyHero
                    targetScore = enemyHeroScore
                end
            end
        end

        if target then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and J.GetHP(botTarget) < 0.5
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        then
            local fDuration = 6.0
            local estimatedDamage = J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, fDuration)

            if  (estimatedDamage > (botTarget:GetHealth() + botTarget:GetHealthRegen() * fDuration))
            and (#nAllyHeroes >= #nEnemyHeroes)
            and (botHP > 0.4)
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if (not J.IsLateGame() and #nInRangeEnemy > 0)
                or (#nInRangeEnemy > 1)
                then
                    local target = nil
                    local targetScore = -math.huge
                    for _, enemyHero in pairs(nInRangeEnemy) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanCastOnTargetAdvanced(enemyHero)
                        and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
                        and not enemyHero:HasModifier('modifier_item_helm_of_the_undying_active')
                        then
                            local enemyHeroScore = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_MAGICAL)
                                                 + enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_PURE)
                            local engageScore = GetMorphEngageScore(enemyHero:GetUnitName()) * enemyHeroScore

                            if engageScore > targetScore then
                                target = enemyHero
                                targetScore = engageScore
                            end
                        end
                    end

                    if target ~= nil then
                        return BOT_ACTION_DESIRE_HIGH, target
                    end
                end
            end
        end
	end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH
    and bot:WasRecentlyDamagedByAnyHero(3.0)
    and not J.CanCastAbility(Waveform, 3.0)
    and botHP > 0.5
	then
        local target = nil
        local targetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and enemyHero:GetAttackTarget() == bot
            then
                local score = GetMorphRetreatScore(enemyHero:GetUnitName())
                if score > 0 and score > targetScore then
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

    local primaryAttribute = bot:GetPrimaryAttribute()

    local itemIndex = {0,1,2,3,4,5,16,17}
    for i = 1, #itemIndex do
        local hItem = bot:GetItemInSlot(itemIndex[i])
        if hItem then
            local sItemName = hItem:GetName()
            if string.find(sItemName, 'item_power_treads') then
                local bonusStats = hItem:GetSpecialValueInt('bonus_stat')
                local treadsState = hItem:GetPowerTreadsStat()
                if treadsState == ATTRIBUTE_AGILITY then
                    nAddedAGI = nAddedAGI + bonusStats
                elseif treadsState == ATTRIBUTE_STRENGTH then
                    nAddedSTR = nAddedSTR + bonusStats
                end
            end

            if string.find(sItemName, 'evolved') then
                local primaryStat = hItem:GetSpecialValueInt('primary_stat')
                if primaryAttribute == ATTRIBUTE_AGILITY then
                    nAddedAGI = nAddedAGI + primaryStat
                elseif primaryAttribute == ATTRIBUTE_STRENGTH then
                    nAddedSTR = nAddedSTR + primaryStat
                end
            end

            local allStats = hItem:GetSpecialValueInt('bonus_all_stats')

			nAddedAGI = nAddedAGI + hItem:GetSpecialValueInt('bonus_agility') + allStats
            nAddedSTR = nAddedSTR + hItem:GetSpecialValueInt('bonus_strength') + allStats
        end
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

    -- morphling's primary in flow is str
    -- but accumulation's x3 applies to agility...
    -- nAddedAGI = nAddedAGI + count * 3 + count * 2 -- from innate
    -- nAddedSTR = nAddedSTR + count * 2 -- from innate
    if primaryAttribute == ATTRIBUTE_AGILITY then
        nAddedAGI = nAddedAGI + count * 3 + count * 2 -- from innate
        nAddedSTR = nAddedSTR + count * 2 -- from innate
    elseif primaryAttribute == ATTRIBUTE_STRENGTH then
        nAddedAGI = nAddedAGI + count * 2 -- from innate
        nAddedSTR = nAddedSTR + count * 3 + count * 2 -- from innate
    end

    -- Stats Talents
    local talent__AGI = bot:GetAbilityInSlot(14)
	local talent__STR = bot:GetAbilityInSlot(16)

    if talent__AGI ~= nil and talent__AGI:IsTrained() then
        nAddedAGI = nAddedAGI + talent__AGI:GetSpecialValueInt('value')
    end

    if talent__STR ~= nil and talent__STR:IsTrained() then
        nAddedSTR = nAddedSTR + talent__STR:GetSpecialValueInt('value')
    end

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

    -- if math.floor(DotaTime()) % 3 == 0 then
    --     print(nAGIRatio, nSTRRatio)
    --     print(nEffAGI, nEffSTR)
    --     print(nAddedAGI, nAddedSTR)
    --     print('===')
    -- end
end

-- set builds
function X.SetItemBuild()
    bFlowFacet = bot:GetPrimaryAttribute() == ATTRIBUTE_STRENGTH and true or false

    local index = 1
    if bFlowFacet then index = 2 end

    sSelectedBuild = HeroBuild[sRole][index]

    X['sBuyList'] = sSelectedBuild.buy_list
    X['sSellList'] = sSelectedBuild.sell_list
end

function X.SetAbilityBuild()
    bFlowFacet = bot:GetPrimaryAttribute() == ATTRIBUTE_STRENGTH and true or false

    local index = 1
    if bFlowFacet then index = 2 end

    sSelectedBuild = HeroBuild[sRole][index]

    nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
    nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

    X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )
end

-- #### -----------------------
-- negligible overhead
local function CreateHeroData(sEngage, sRetreat, bEngageBack, bRetreatBack)
    return {
        scoreEngage = sEngage,
        scoreRetreat = sRetreat,
        goodToEngageBack = bEngageBack,
        goodToRetreatBack = bRetreatBack,
    }
end

local hHeroList = {
    ['npc_dota_hero_abaddon'] = CreateHeroData(0.3, 0.1, false, false),
    ['npc_dota_hero_abyssal_underlord'] = CreateHeroData(0.8, 0.5, true, true),
    ['npc_dota_hero_alchemist'] = CreateHeroData(0.4, 0.2, false, false),
    ['npc_dota_hero_ancient_apparition'] = CreateHeroData(0.7, 0.4, true, false),
    ['npc_dota_hero_antimage'] = CreateHeroData(0.5, 0.9, true, true),
    ['npc_dota_hero_arc_warden'] = CreateHeroData(0.4, 0.1, true, false),
    ['npc_dota_hero_axe'] = CreateHeroData(0.3, 0.5, false, false),
    ['npc_dota_hero_bane'] = CreateHeroData(0.8, 0.5, true, true),
    ['npc_dota_hero_batrider'] = CreateHeroData(0.3, 0.3, false, false),
    ['npc_dota_hero_beastmaster'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_bloodseeker'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_bounty_hunter'] = CreateHeroData(0.2, 0.6, false, true),
    ['npc_dota_hero_brewmaster'] = CreateHeroData(0.3, 0.3, false, false),
    ['npc_dota_hero_bristleback'] = CreateHeroData(0.4, 0.2, false, false),
    ['npc_dota_hero_broodmother'] = CreateHeroData(0.5, 0.1, false, false),
    ['npc_dota_hero_centaur'] = CreateHeroData(0.4, 0.3, true, false),
    ['npc_dota_hero_chaos_knight'] = CreateHeroData(0.6, 0.5, true, false),
    ['npc_dota_hero_chen'] = CreateHeroData(0.4, 0.1, false, false),
    ['npc_dota_hero_clinkz'] = CreateHeroData(0.3, 0.2, false, false),
    ['npc_dota_hero_crystal_maiden'] = CreateHeroData(0.8, 0.8, true, true),
    ['npc_dota_hero_dark_seer'] = CreateHeroData(0.2, 0.5, true, true),
    ['npc_dota_hero_dark_willow'] = CreateHeroData(0.6, 0.5, true, true),
    ['npc_dota_hero_dawnbreaker'] = CreateHeroData(0.6, 0.4, true, false),
    ['npc_dota_hero_dazzle'] = CreateHeroData(0.8, 0.2, true, false),
    ['npc_dota_hero_death_prophet'] = CreateHeroData(0.5, 0.2, true, false),
    ['npc_dota_hero_disruptor'] = CreateHeroData(0.8, 0.5, true, true),
    ['npc_dota_hero_doom_bringer'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_dragon_knight'] = CreateHeroData(0.6, 0.8, true, true),
    ['npc_dota_hero_drow_ranger'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_earth_spirit'] = CreateHeroData(0.8, 1, true, true),
    ['npc_dota_hero_earthshaker'] = CreateHeroData(1, 1, true, true),
    ['npc_dota_hero_elder_titan'] = CreateHeroData(0.1, 0.1, false, false),
    ['npc_dota_hero_ember_spirit'] = CreateHeroData(0.5, 0.4, true, true),
    ['npc_dota_hero_enchantress'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_enigma'] = CreateHeroData(0.2, 0.5, false, false),
    ['npc_dota_hero_faceless_void'] = CreateHeroData(0.5, 0.5, true, true),
    ['npc_dota_hero_furion'] = CreateHeroData(0.5, 0.5, true, true),
    ['npc_dota_hero_grimstroke'] = CreateHeroData(0.8, 0.4, true, true),
    ['npc_dota_hero_gyrocopter'] = CreateHeroData(0.6, 0.4, true, false),
    ['npc_dota_hero_hoodwink'] = CreateHeroData(0.5, 0.3, true, false),
    ['npc_dota_hero_huskar'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_invoker'] = CreateHeroData(0.5, 0.3, true, false),
    ['npc_dota_hero_jakiro'] = CreateHeroData(0.6, 0.6, true, false),
    ['npc_dota_hero_juggernaut'] = CreateHeroData(0.8, 0.3, true, true),
    ['npc_dota_hero_keeper_of_the_light'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_kunkka'] = CreateHeroData(0.4, 0.4, true, true),
    ['npc_dota_hero_legion_commander'] = CreateHeroData(0.6, 0.4, true, true),
    ['npc_dota_hero_leshrac'] = CreateHeroData(0.6, 0.4, true, true),
    ['npc_dota_hero_lich'] = CreateHeroData(0.7, 0.2, true, false),
    ['npc_dota_hero_life_stealer'] = CreateHeroData(0.8, 0.4, true, true),
    ['npc_dota_hero_lina'] = CreateHeroData(0.4, 0.2, true, true),
    ['npc_dota_hero_lion'] = CreateHeroData(1, 1, true, true),
    ['npc_dota_hero_lone_druid'] = CreateHeroData(0.1, 0.1, false, false),
    ['npc_dota_hero_luna'] = CreateHeroData(0.4, 0.2, false, false),
    ['npc_dota_hero_lycan'] = CreateHeroData(0.7, 0.2, true, false),
    ['npc_dota_hero_magnataur'] = CreateHeroData(0.4, 0.7, true, true),
    ['npc_dota_hero_marci'] = CreateHeroData(0.3, 0.3, false, false),
    ['npc_dota_hero_mars'] = CreateHeroData(0.7, 0.4, true, true),
    ['npc_dota_hero_medusa'] = CreateHeroData(0.1, 0.2, true, false),
    ['npc_dota_hero_meepo'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_mirana'] = CreateHeroData(0.3, 0.7, false, true),
    -- ['npc_dota_hero_morphling']          = { time_len = {0}, },
    ['npc_dota_hero_monkey_king'] = CreateHeroData(0.4, 0.4, true, false),
    ['npc_dota_hero_muerta'] = CreateHeroData(0.5, 0.3, true, false),
    ['npc_dota_hero_naga_siren'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_necrolyte'] = CreateHeroData(0.2, 0.1, true, true),
    ['npc_dota_hero_nevermore'] = CreateHeroData(0.2, 0.1, true, false),
    ['npc_dota_hero_night_stalker'] = CreateHeroData(0.5, 0.2, true, false),
    ['npc_dota_hero_nyx_assassin'] = CreateHeroData(0.6, 0.6, true, true),
    ['npc_dota_hero_obsidian_destroyer'] = CreateHeroData(0.8, 0.8, true, true),
    ['npc_dota_hero_ogre_magi'] = CreateHeroData(0.8, 0.7, true, true),
    ['npc_dota_hero_omniknight'] = CreateHeroData(0.3, 0.3, true, false),
    ['npc_dota_hero_oracle'] = CreateHeroData(0.3, 0.3, true, false),
    ['npc_dota_hero_pangolier'] = CreateHeroData(0.5, 0.5, true, true),
    ['npc_dota_hero_phantom_lancer'] = CreateHeroData(0.1, 0.3, false, true),
    ['npc_dota_hero_phantom_assassin'] = CreateHeroData(0.3, 0.3, false, true),
    ['npc_dota_hero_phoenix'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_primal_beast'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_puck'] = CreateHeroData(0.6, 0.5, true, true),
    ['npc_dota_hero_pudge'] = CreateHeroData(0.5, 0.1, true, false),
    ['npc_dota_hero_pugna'] = CreateHeroData(0.4, 0.1, true, true),
    ['npc_dota_hero_queenofpain'] = CreateHeroData(0.9, 0.9, true, true),
    ['npc_dota_hero_rattletrap'] = CreateHeroData(0.2, 0.2, true, false),
    ['npc_dota_hero_razor'] = CreateHeroData(0.8, 0.2, true, false),
    ['npc_dota_hero_riki'] = CreateHeroData(0.2, 0.2, true, true),
    ['npc_dota_hero_ringmaster'] = CreateHeroData(0.4, 0.1, false, false),
    ['npc_dota_hero_rubick'] = CreateHeroData(0.3, 0.5, false, true),
    ['npc_dota_hero_sand_king'] = CreateHeroData(1, 1, true, true),
    ['npc_dota_hero_shadow_demon'] = CreateHeroData(0.8, 0.5, true, false),
    ['npc_dota_hero_shadow_shaman'] = CreateHeroData(0.9, 0.8, true, true),
    ['npc_dota_hero_shredder'] = CreateHeroData(0.4, 0.8, true, true),
    ['npc_dota_hero_silencer'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_skeleton_king'] = CreateHeroData(0.2, 0.3, false, false),
    ['npc_dota_hero_skywrath_mage'] = CreateHeroData(0.5, 0.1, true, false),
    ['npc_dota_hero_slardar'] = CreateHeroData(0.5, 0.5, true, true),
    ['npc_dota_hero_slark'] = CreateHeroData(0.7, 0.7, true, true),
    ["npc_dota_hero_snapfire"] = CreateHeroData(0.5, 0.5, true, false),
    ['npc_dota_hero_sniper'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_spectre'] = CreateHeroData(0.1, 0.1, false, false),
    ['npc_dota_hero_spirit_breaker'] = CreateHeroData(0.5, 0.5, true, true),
    ['npc_dota_hero_storm_spirit'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_sven'] = CreateHeroData(0.5, 0.5, true, true),
    ['npc_dota_hero_techies'] = CreateHeroData(0.3, 0.2, false, false),
    ['npc_dota_hero_templar_assassin'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_terrorblade'] = CreateHeroData(0.5, 0.1, false, false),
    ['npc_dota_hero_tidehunter'] = CreateHeroData(0.3, 0.3, false, false),
    ['npc_dota_hero_tinker'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_tiny'] = CreateHeroData(0.9, 0.7, true, true),
    ['npc_dota_hero_treant'] = CreateHeroData(0.3, 0.2, false, false),
    ['npc_dota_hero_troll_warlord'] = CreateHeroData(0.2, 0.2, false, false),
    ['npc_dota_hero_tusk'] = CreateHeroData(0.3, 0.6, false, true),
    ['npc_dota_hero_undying'] = CreateHeroData(0.1, 0.1, false, false),
    ['npc_dota_hero_ursa'] = CreateHeroData(0.5, 0.3, true, false),
    ['npc_dota_hero_vengefulspirit'] = CreateHeroData(0.7, 0.6, true, true),
    ['npc_dota_hero_venomancer'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_viper'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_visage'] = CreateHeroData(0.2, 0.1, false, false),
    ['npc_dota_hero_void_spirit'] = CreateHeroData(0.6, 0.6, true, true),
    ['npc_dota_hero_warlock'] = CreateHeroData(0.4, 0.2, false, false),
    ['npc_dota_hero_weaver'] = CreateHeroData(0.2, 0.8, false, true),
    ['npc_dota_hero_windrunner'] = CreateHeroData(0.4, 0.5, true, true),
    ['npc_dota_hero_wisp'] = CreateHeroData(0.1, 0.1, false, false),
    ['npc_dota_hero_witch_doctor'] = CreateHeroData(0.5, 0.5, true, false),
    ['npc_dota_hero_zuus'] = CreateHeroData(0.5, 0.2, true, false),
}

function GetMorphEngageScore(sHeroName)
    if hHeroList[sHeroName] and hHeroList[sHeroName].scoreEngage then
        return hHeroList[sHeroName].scoreEngage
    end

    return 0.1
end

function GetMorphRetreatScore(sHeroName)
    if hHeroList[sHeroName] and hHeroList[sHeroName].scoreRetreat then
        if hHeroList[sHeroName].scoreRetreat >= 0.5 then
            return hHeroList[sHeroName].scoreRetreat
        end
    end

    return -1
end

function IsGoodToMorphBack(sHeroName, bEngage)
    if hHeroList[sHeroName] then
        if bEngage then
            if hHeroList[sHeroName].goodToEngageBack then
                return hHeroList[sHeroName].goodToEngageBack
            end
        else
            if hHeroList[sHeroName].goodToRetreatBack then
                return hHeroList[sHeroName].goodToRetreatBack
            end
        end
    end

    return false
end

return X