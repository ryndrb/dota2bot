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
            
                "item_bottle",
                "item_magic_wand",
                "item_arcane_boots",
                "item_phylactery",
                "item_ultimate_scepter",
                "item_octarine_core",--
                "item_black_king_bar",--
                "item_cyclone",
                "item_angels_demise",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_wind_waker",--
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_cyclone",
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
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_boots",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_aether_lens",
                "item_blink",
                "item_ancient_janggo",
                "item_force_staff",--
                "item_boots_of_bearing",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_wind_waker",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_arcane_blink",--
                "item_ethereal_blade",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ancient_janggo",
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
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_aether_lens",
                "item_blink",
                "item_mekansm",
                "item_force_staff",--
                "item_guardian_greaves",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_wind_waker",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_arcane_blink",--
                "item_ethereal_blade",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_mekansm",
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

local botTarget

if bot.shouldBlink == nil then bot.shouldBlink = false end

-- cache
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
	if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    StolenSpell1 = bot:GetAbilityInSlot(3)
    StolenSpell2 = bot:GetAbilityInSlot(4)

    SpellStealDesire, SpellStealTarget = X.ConsiderSpellSteal()
    if SpellStealDesire > 0
    then
        bot:Action_UseAbilityOnEntity(SpellSteal, SpellStealTarget)
        return
    end

    HandleStolenSpell(StolenSpell1)
    HandleStolenSpell(StolenSpell2)

    TelekinesisDesire, TelekinesisTarget = X.ConsiderTelekinesis()
    if TelekinesisDesire > 0
    then
        bot.teleTarget = TelekinesisTarget
        bot:Action_UseAbilityOnEntity(Telekinesis, TelekinesisTarget)
        return
    end

    TelekinesisLandDesire, TelekinesisLandLocation = X.ConsiderTelekinesisLand()
    if TelekinesisLandDesire > 0
    then
        bot:Action_UseAbilityOnLocation(TelekinesisLand, TelekinesisLandLocation)
        bot.isChannelLand = false
        bot.isSaveUltLand= false
        bot.isEngagingLand = false
        bot.isRetreatLand = false
        bot.isSaveAllyLand = false
        return
    end

    FadeBoltDesire, FadeBoltTarget = X.ConsiderFadeBolt()
    if FadeBoltDesire > 0
    then
        bot:Action_UseAbilityOnEntity(FadeBolt, FadeBoltTarget)
        return
    end
end

function X.ConsiderTelekinesis()
    if not J.CanCastAbility(Telekinesis)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Telekinesis:GetCastRange())

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                bot.isChannelLand = true
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
        -- no way to check shard
        -- for _, allyHero in pairs(nInRangeAlly)
        -- do
        --     if  J.IsValidHero(allyHero)
        --     and J.IsCore(allyHero)
        --     and not J.IsSuspiciousIllusion(allyHero)
        --     and not allyHero:IsInvulnerable()
        --     and not allyHero:IsAttackImmune()
        --     and not allyHero:HasModifier('modifier_legion_commander_duel')
        --     and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        --     then
        --         if allyHero:HasModifier('modifier_enigma_black_hole_pull')
        --         or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        --         then
        --             bot.isSaveUltLand = true
        --             return BOT_ACTION_DESIRE_HIGH, allyHero
        --         end
        --     end
        -- end

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_furion_sprout_damage')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

            if not (#nInRangeAlly >= #nInRangeEnemy + 2)
            then
                bot.isEngagingLand = true
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_furion_sprout_damage')
            and bot:WasRecentlyDamagedByHero(enemyHero, 4)
            and J.IsChasingTarget(enemyHero, bot)
			then
                bot.isRetreatLand = true
                return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

    -- no way to check shard
    -- local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    -- for _, allyHero in pairs(nAllyHeroes)
    -- do
    --     if  J.IsValidHero(allyHero)
    --     and J.IsRetreating(allyHero)
    --     and allyHero:WasRecentlyDamagedByAnyHero(4)
    --     and not allyHero:IsIllusion()
    --     then
    --         local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

    --         if J.IsValidHero(nAllyInRangeEnemy[1])
    --         and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
    --         and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
    --         and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
    --         and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
    --         and not J.IsDisabled(nAllyInRangeEnemy[1])
    --         and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
    --         and not nAllyInRangeEnemy[1]:HasModifier('modifier_furion_sprout_damage')
    --         and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
    --         and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
    --         and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
    --         then
    --             bot.isSaveAllyLand = true
    --             return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
    --         end
    --     end
    -- end

	if J.IsDoingRoshan(bot)
	then
        -- Remove Spell Block
		if  J.IsRoshan(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and botTarget:HasModifier('modifier_roshan_spell_block')
		then
			return BOT_ACTION_DESIRE_LOW, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTelekinesisLand()
    if not J.CanCastAbility(TelekinesisLand)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nDistance = TelekinesisLand:GetSpecialValueInt('radius')
    local nTalent8 = bot:GetAbilityByName('special_bonus_unique_rubick_8')
    if nTalent8:IsTrained()
    then
        nDistance = nDistance + nTalent8:GetSpecialValueInt('value')
    end

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if  J.IsValidHero(botTarget)
    and not J.IsSuspiciousIllusion(botTarget)
    then
        nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1600)
        nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1600)
    end

    if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
    and J.IsValid(bot.teleTarget)
    then
        if bot.isChannelLand
        then
            if J.WeAreStronger(bot, 1600)
            then
                if J.IsInRange(bot, bot.teleTarget, nDistance)
                then
                    return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                end

                if not J.IsInRange(bot, bot.teleTarget, nDistance)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot.teleTarget, bot:GetLocation(), nDistance)
                end
            end

            if #nInRangeEnemy > #nInRangeAlly
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot.teleTarget, J.GetEnemyFountain(), nDistance)
            end
        end

        -- can't check for shard rn
        -- if bot.isSaveUltLand
        -- then
        --     return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nDistance)
        -- end

        if bot.isEngagingLand
        then
            if J.IsInRange(bot, bot.teleTarget, nDistance)
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end

            if not J.IsInRange(bot, bot.teleTarget, nDistance)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot.teleTarget, bot:GetLocation(), nDistance)
            end
        end

        if bot.isRetreatLand
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot.teleTarget, J.GetEnemyFountain(), nDistance)
        end

        -- can't check for shard rn
        -- if bot.isSaveAllyLand
        -- then
        --     return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot.teleTarget, J.GetTeamFountain(), nDistance)
        -- end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFadeBolt()
    if not J.CanCastAbility(FadeBolt)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, FadeBolt:GetCastRange())
    local nDamage = FadeBolt:GetSpecialValueInt('damage')
    local nRadius = FadeBolt:GetSpecialValueInt('radius')
    local manaCost = FadeBolt:GetManaCost()

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_rubick_telekinesis')
        then
            if J.IsInEtherealForm(enemyHero)
            then
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

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        and (not J.IsCore(bot) or not J.CanCastAbility(Telekinesis))
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and J.IsAttacking(nAllyInRangeEnemy[1])
            and not J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_rubick_telekinesis')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
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
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (J.IsChasingTarget(enemyHero, bot) or J.GetHP(bot) < 0.5)
            and not J.IsInRange(bot, enemyHero, 300)
            and bot:WasRecentlyDamagedByHero(enemyHero, 4.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(math.min(nCastRange, 1600), true)
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]
        end
    end

    if J.IsDefending(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
        end
    end

    if J.IsFarming(bot)
    and J.IsAttacking(bot)
    and J.GetManaAfter(manaCost) > 0.35
    then
        local nCreeps = bot:GetNearbyCreeps(math.min(nCastRange, 1600), true)
        if J.IsValid(nCreeps[1])
        and (#nCreeps >= 2 or #nCreeps >= 1 and nCreeps[1]:IsAncientCreep())
        and J.CanBeAttacked(nCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nCreeps[1]
        end
    end

    if  J.IsLaning(bot)
    and (not J.IsCore(bot) and not J.IsThereCoreNearby(1200) or J.IsCore(bot))
	then
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
            and J.GetMP(bot) > 0.3
			then
				if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 600
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                table.insert(creepList, creep)
            end
		end

        if  J.GetMP(bot) > 0.3
        and (#nEnemyHeroes >= 1 and #creepList >= 2 or #creepList >= 3)
        and J.CanBeAttacked(creepList[1])
        then
            return BOT_ACTION_DESIRE_HIGH, creepList[1]
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

-- function X.ConsiderStolenSpell1()
--     if StolenSpell1:GetName() == 'rubick_empty1'
--     or not StolenSpell1:IsFullyCastable()
--     then
--         return BOT_ACTION_DESIRE_HIGH, 0, ''
--     end

--     R.ConsiderStolenSpell(StolenSpell1)

--     return BOT_ACTION_DESIRE_HIGH, 0, ''
-- end

-- function X.ConsiderStolenSpell2()
--     if StolenSpell2:GetName() == 'rubick_empty2'
--     or not StolenSpell2:IsFullyCastable()
--     then
--         return BOT_ACTION_DESIRE_HIGH, 0, ''
--     end

--     R.ConsiderStolenSpell(StolenSpell2)

--     return BOT_ACTION_DESIRE_HIGH, 0, ''
-- end

function X.ConsiderSpellSteal()
    if not J.CanCastAbility(SpellSteal)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    if math.floor(DotaTime()) % 2 == 0 then
        return 0, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SpellSteal:GetCastRange())

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange + 300)
    for _, enemyHero in pairs(nInRangeEnemy)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not J.IsMeepoClone(enemyHero)
        then
            if enemyHero:IsUsingAbility()
            or enemyHero:IsCastingAbility()
            or J.IsCastingUltimateAbility(enemyHero)
            then
                if bot:HasScepter()
                then
                    if  SPL.GetSpellReplaceWeight(StolenSpell1) * 100 >= RandomInt(1, 100)
                    and SPL.GetSpellReplaceWeight(StolenSpell2) * 100 >= RandomInt(1, 100)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end

                    if SPL.GetSpellReplaceWeight(StolenSpell2) * 100 >= RandomInt(1, 100)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    if SPL.GetSpellReplaceWeight(StolenSpell1) * 100 >= RandomInt(1, 100)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X