local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local SPL = require( GetScriptDirectory()..'/FunLib/spell_list' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_faerie_fire",
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
            
                "item_bottle",
                "item_magic_wand",
                "item_null_talisman",
                "item_arcane_boots",
                "item_phylactery",
                "item_ultimate_scepter",
                "item_octarine_core",--
                "item_black_king_bar",--
                "item_wind_waker",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_arcane_blink",--
                "item_aghanims_shard",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_octarine_core",
                "item_null_talisman", "item_black_king_bar",
                "item_bottle", "item_wind_waker",
                "item_phylactery", "item_arcane_blink",
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
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_blink",
                "item_ancient_janggo",
                "item_cyclone",
                "item_octarine_core",--
                "item_boots_of_bearing",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_wind_waker",--
                "item_dagon_5",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_arcane_blink",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_blink",
                "item_mekansm",
                "item_cyclone",
                "item_octarine_core",--
                "item_guardian_greaves",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_wind_waker",--
                "item_dagon_5",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_arcane_blink",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
            },
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

local Telekinesis       = bot:GetAbilityByName('rubick_telekinesis')
local TelekinesisLand   = bot:GetAbilityByName('rubick_telekinesis_land')
local FadeBolt          = bot:GetAbilityByName('rubick_fade_bolt')
-- local ArcaneSupremacy   = bot:GetAbilityByName('rubick_null_field')
local StolenSpell1      = bot:GetAbilityByName('rubick_empty1')
local StolenSpell2      = bot:GetAbilityByName('rubick_empty2')
local SpellSteal        = bot:GetAbilityByName('rubick_spell_steal')

local TelekinesisDesire, TelekinesisTarget
local TelekinesisLandDesire, TelekinesisLandLocation
local FadeBoltDesire, FadeBoltTarget
local SpellStealDesire, SpellStealTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local telekinesis = { target = nil, is_channel = false, is_engage = false, is_retreat = false, is_save = false }

local heroAbilityUsage = {}
local function HandleStolenSpell(stolenSpell)
    if stolenSpell == nil then return end

    local stolenSpellName = stolenSpell:GetName()
    local stolenSpellHeroName = SPL.GetSpellHeroName(stolenSpellName)

    if stolenSpellHeroName == nil then return end

    if not heroAbilityUsage[stolenSpellHeroName]
    then
        heroAbilityUsage[stolenSpellHeroName] = dofile(GetScriptDirectory()..'/BotLib/'..string.gsub(stolenSpellHeroName, 'npc_dota_', ''))
    end

    local heroSpells = heroAbilityUsage[stolenSpellHeroName]
    if heroSpells and heroSpells.SkillsComplement
    then
        heroSpells.SkillsComplement()
    end
end

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    StolenSpell1 = bot:GetAbilityInSlot(3)
    StolenSpell2 = bot:GetAbilityInSlot(4)

    SpellStealDesire, SpellStealTarget = X.ConsiderSpellSteal()
    if SpellStealDesire > 0 then
        bot:Action_UseAbilityOnEntity(SpellSteal, SpellStealTarget)
        return
    end

    HandleStolenSpell(StolenSpell1)
    HandleStolenSpell(StolenSpell2)

    TelekinesisDesire, TelekinesisTarget = X.ConsiderTelekinesis()
    if TelekinesisDesire > 0 then
        telekinesis.target = TelekinesisTarget
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Telekinesis, TelekinesisTarget)
        return
    end

    TelekinesisLandDesire, TelekinesisLandLocation = X.ConsiderTelekinesisLand()
    if TelekinesisLandDesire > 0 then
        bot:Action_UseAbilityOnLocation(TelekinesisLand, TelekinesisLandLocation)
        return
    end

    FadeBoltDesire, FadeBoltTarget = X.ConsiderFadeBolt()
    if FadeBoltDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(FadeBolt, FadeBoltTarget)
        return
    end
end

function X.ConsiderTelekinesis()
    if not J.CanCastAbility(Telekinesis) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Telekinesis:GetCastRange())
    local bHasShard = Telekinesis:GetSpecialValueInt('shard_max_land_distance_bonus_pct')
    local nManaCost = Telekinesis:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Telekinesis, FadeBolt, SpellSteal})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling() then
                telekinesis.is_channel = true
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

    if bHasShard then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsCore(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and allyHero:WasRecentlyDamagedByAnyHero(1.0)
            then
                if allyHero:HasModifier('modifier_enigma_black_hole_pull')
                or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or (allyHero:IsRooted() and J.IsRetreating(allyHero))
                then
                    telekinesis.is_save = true
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_furion_sprout_damage')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if not (#nAllyHeroes >= #nEnemyHeroes + 2) then
                telekinesis.is_engage = true
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			then
                if J.IsChasingTarget(enemyHero, bot) or bot:WasRecentlyDamagedByAnyHero(3.0) then
                    telekinesis.is_retreat = true
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_LOW, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTelekinesisLand()
    if not J.CanCastAbility(TelekinesisLand) then
        telekinesis.target = nil
        telekinesis.is_channel = false
        telekinesis.is_engage = false
        telekinesis.is_retreat = false
        telekinesis.is_save = false
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = Telekinesis:GetCastRange()
    local nLandDistance = Telekinesis:GetSpecialValueInt('max_land_distance')

    if J.IsValid(telekinesis.target) then
        if telekinesis.is_retreat then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(telekinesis.target:GetLocation(), J.GetEnemyFountain(), nLandDistance)
        end

        if telekinesis.is_engage then
            local hTarget = nil
            local hTargetDamage = 0
            for i = 1, 5 do
                local allyHero = GetTeamMember(i)

                if  J.IsValidHero(allyHero)
                and J.IsGoingOnSomeone(allyHero)
                and J.IsInRange(allyHero, telekinesis.target, nCastRange)
                then
                    local allyHeroDamage = allyHero:GetEstimatedDamageToTarget(false, telekinesis.target, 5.0, DAMAGE_TYPE_ALL)
                    if allyHeroDamage > hTargetDamage then
                        hTarget = allyHero
                        hTargetDamage = allyHeroDamage
                    end
                end
            end

            if hTarget then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(telekinesis.target:GetLocation(), hTarget:GetLocation(), Min(nLandDistance, GetUnitToLocationDistance(telekinesis.target, hTarget:GetLocation())))
            end
        end

        if telekinesis.is_channel then
            if not J.IsRetreating(bot) then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(telekinesis.target:GetLocation(), bot:GetLocation(), Min(nLandDistance, GetUnitToLocationDistance(telekinesis.target, bot:GetLocation())))
            elseif #nEnemyHeroes > #nAllyHeroes then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(telekinesis.target:GetLocation(), J.GetEnemyFountain(), Min(nLandDistance, GetUnitToLocationDistance(telekinesis.target, J.GetEnemyFountain())))
            else
                return BOT_ACTION_DESIRE_HIGH, telekinesis.target:GetLocation()
            end
        end

        if telekinesis.is_save then
            return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(telekinesis.target:GetLocation(), J.GetTeamFountain(), Min(nLandDistance, GetUnitToLocationDistance(telekinesis.target, J.GetTeamFountain())))
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFadeBolt()
    if not J.CanCastAbility(FadeBolt) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, FadeBolt:GetCastRange())
    local nDamage = FadeBolt:GetSpecialValueInt('damage')
    local nRadius = FadeBolt:GetSpecialValueInt('radius')
    local nManaCost = FadeBolt:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Telekinesis, FadeBolt, SpellSteal})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_rubick_telekinesis')
        then
            if J.IsInEtherealForm(enemyHero) and fManaAfter > fManaThreshold1 + 0.15 and not J.IsRealInvisible(bot) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
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

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_rubick_telekinesis')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 + 0.2 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByAnyHero(3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 and #nEnemyHeroes <= 1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not enemyHero:HasModifier('modifier_rubick_telekinesis')
            then
                local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 3 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            and not J.IsOtherAllysTarget(creep)
			then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage * 2)
                if fManaAfter > fManaThreshold1 + 0.1 and nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 and #nEnemyHeroes > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSpellSteal()
    if not J.CanCastAbility(SpellSteal) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = SpellSteal:GetCastRange()

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
            if enemyHero:IsUsingAbility()
            or enemyHero:IsCastingAbility()
            or enemyHero:IsChanneling()
            then
                local fRand = RandomFloat(0, 1)
                local fWeightSpell1 = SPL.GetSpellReplaceWeight(StolenSpell1)
                local fWeightSpell2 = SPL.GetSpellReplaceWeight(StolenSpell2)

                if bot:HasScepter() then
                    if  fWeightSpell1 >= fRand
                    and fWeightSpell2 >= fRand
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end

                    if fWeightSpell2 >= fRand then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    if fWeightSpell1 >= fRand then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X