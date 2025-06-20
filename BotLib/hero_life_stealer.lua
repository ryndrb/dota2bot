local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_life_stealer'
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
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,3,3,6,3,2,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_double_gauntlets",
            
                "item_magic_wand",
                "item_orb_of_corrosion",
                "item_phase_boots",
                "item_armlet",
                "item_radiance",--
                "item_sange_and_yasha",--
                "item_aghanims_shard",
                "item_basher",
                "item_bloodthorn",--
                "item_abyssal_blade",--
                "item_skadi",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_gauntlets", "item_armlet",
                "item_gauntlets", "item_radiance",
                "item_quelling_blade", "item_sange_and_yasha",
                "item_magic_wand", "item_basher",
                "item_orb_of_corrosion", "item_bloodthorn",
                "item_armlet", "item_skadi"
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    for i = 0, 5 do
        local hAbility = hMinionUnit:GetAbilityInSlot(i)
        if hAbility ~= nil and hAbility:GetName() == 'life_stealer_consume' then
            if hMinionUnit:HasModifier('modifier_fountain_aura_buff') then
                hMinionUnit:Action_UseAbility(hAbility)
                return
            end

            if bot.infest_target == 'creep' then
                if J.IsInTeamFight(bot, 1600) and J.GetHP(bot) > 0.55 then
                    local nTeamFightLocation = J.GetTeamFightLocation(bot)
                    if nTeamFightLocation ~= nil then
                        hMinionUnit:Action_MoveToLocation(nTeamFightLocation)
                        return
                    end
                else
                    hMinionUnit:Action_MoveToLocation(J.GetTeamFountain())
                    return
                end
            else
                return
            end
        end
    end
    Minion.MinionThink(hMinionUnit)
end

end

local Rage          = bot:GetAbilityByName('life_stealer_rage')
-- local Feast         = bot:GetAbilityByName('life_stealer_feast')
-- local GhoulFrenzy   = bot:GetAbilityByName('life_stealer_ghoul_frenzy')
local OpenWounds    = bot:GetAbilityByName('life_stealer_open_wounds')
local Infest        = bot:GetAbilityByName('life_stealer_infest')
local Consume       = bot:GetAbilityByName('life_stealer_consume')

local RageDesire
local OpenWoundsDesire, OpenWoundsTarget
local InfestDesire, InfestTarget
local ConsumeDesire

local botTarget
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    if not bot:HasModifier('modifier_life_stealer_infest')
    then
        if J.CanNotUseAbility(bot) then return end
    end

    Rage          = bot:GetAbilityByName('life_stealer_rage')
    OpenWounds    = bot:GetAbilityByName('life_stealer_open_wounds')
    Infest        = bot:GetAbilityByName('life_stealer_infest')
    Consume       = bot:GetAbilityByName('life_stealer_consume')

    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    ConsumeDesire = X.ConsiderConsume()
    if ConsumeDesire > 0
    then
        bot:Action_UseAbility(Consume)
        return
    end

    InfestDesire, InfestTarget = X.ConsiderInfest()
    if InfestDesire > 0
    then
        bot:Action_UseAbilityOnEntity(Infest, InfestTarget)
        return
    end

    RageDesire = X.ConsiderRage()
    if RageDesire > 0
    then
        bot:Action_UseAbility(Rage)
        return
    end

    OpenWoundsDesire, OpenWoundsTarget = X.ConsiderOpenWounds()
    if OpenWoundsDesire > 0
    then
        bot:Action_UseAbilityOnEntity(OpenWounds, OpenWoundsTarget)
        return
    end
end

function X.ConsiderRage()
    if not J.CanCastAbility(Rage)
    or bot:HasModifier('modifier_life_stealer_infest')
    or bot:IsMagicImmune()
    or bot:IsInvulnerable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1400)

	if (J.IsGoingOnSomeone(bot) or J.IsRetreating(bot))
    and #nInRangeEnemy > 0
    and not bot:HasModifier('modifier_item_lotus_orb_active')
    and not bot:HasModifier('modifier_antimage_spell_shield')
	then
		if bot:IsRooted()
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 600)
		if bot:IsSilenced()
        and #nInRangeEnemy >= 2
        and not bot:HasModifier('modifier_item_mask_of_madness_berserk')
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsNotAttackProjectileIncoming(bot, 350)
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsWillBeCastUnitTargetSpell(bot, 500)
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsWillBeCastPointSpell(bot, 500)
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		if #nInRangeEnemy > #nAllyHeroes
        and J.GetHP(bot) < 0.6
        and J.IsValidHero(nInRangeEnemy[1])
        and (J.IsChasingTarget(nInRangeEnemy[1], bot) or nInRangeEnemy[1]:GetAttackTarget() == bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if bot:HasModifier('modifier_jakiro_macropyre_burn')
    or bot:HasModifier('modifier_lich_chainfrost_slow')
    or bot:HasModifier('modifier_crystal_maiden_freezing_field_slow')
    or bot:HasModifier('modifier_puck_coiled')
    or bot:HasModifier('modifier_skywrath_mystic_flare_aura_effect')
    or bot:HasModifier('modifier_snapfire_magma_burn_slow')
    or bot:HasModifier('modifier_sand_king_epicenter_slow')
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderOpenWounds()
    if not J.CanCastAbility(OpenWounds)
    or bot:HasModifier('modifier_life_stealer_infest')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, OpenWounds:GetCastRange())

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.CanCastOnTargetAdvanced(enemy)
            and bot:WasRecentlyDamagedByHero(enemy, 3.0)
            and J.IsChasingTarget(enemy, bot)
            and not J.IsDisabled(enemy)
            then
                return BOT_ACTION_DESIRE_HIGH, enemy
            end
        end
    end

	if  J.IsFarming(bot)
    and J.GetHP(bot) < 0.49
	then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)

		if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.IsAttacking(bot)
        and J.CanBeAttacked(nNeutralCreeps[1])
        and J.GetHP(nNeutralCreeps[1]) >= 0.75
        then
            return BOT_ACTION_DESIRE_HIGH, nNeutralCreeps[1]
        end
	end

	if J.IsDoingRoshan(bot)
	then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.GetHP(bot) < 0.6
        and not botTarget:HasModifier('modifier_roshan_spell_block')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

	if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.GetHP(bot) < 0.6
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderInfest()
    if not J.CanCastAbility(Infest)
    or bot:HasModifier('modifier_life_stealer_infest')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 900)
            if #nInRangeEnemy >= 2 then
                local hTarget = nil
                for _, allyHero in pairs(nAllyHeroes) do
                    if bot ~= allyHero
                    and J.IsValidHero(allyHero)
                    and J.IsInRange(bot, allyHero, 900)
                    and J.IsGoingOnSomeone(allyHero)
                    and (allyHero:GetAttackTarget() == botTarget or J.IsChasingTarget(allyHero, botTarget))
                    and not allyHero:IsIllusion()
                    and not J.IsMeepoClone(allyHero)
                    and allyHero:GetAttackRange() <= 324
                    then
                        hTarget = allyHero
                    end
                end

                if hTarget ~= nil then
                    bot.infest_target = 'hero'
                    return BOT_ACTION_DESIRE_HIGH, hTarget
                end
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
        if J.IsValidHero(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 700)
        and (J.IsChasingTarget(nInRangeEnemy[1], bot) or nInRangeEnemy[1]:GetAttackTarget() == bot)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
		then
            local enemyDamage = nInRangeEnemy[1]:GetEstimatedDamageToTarget(true, bot, 10.0, DAMAGE_TYPE_ALL)
            if enemyDamage > bot:GetHealth() * 1.25 then
                for _, allyHero in pairs(nAllyHeroes) do
                    if bot ~= allyHero
                    and J.IsValidHero(allyHero)
                    and J.IsInRange(bot, allyHero, 777)
                    and not J.IsGoingOnSomeone(allyHero)
                    and not allyHero:IsIllusion()
                    and not J.IsMeepoClone(allyHero)
                    then
                        bot.infest_target = 'hero'
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(777, false)
                for _, creep in pairs(nAllyLaneCreeps) do
                    if J.IsValid(creep) then
                        bot.infest_target = 'creep'
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end

                local nEnemyCreeps = bot:GetNearbyCreeps(777, true)
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and not creep:IsAncientCreep() then
                        bot.infest_target = 'creep'
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

-- too fast since mode switching a lot
function X.ConsiderConsume()
    if not J.CanCastAbility(Consume)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nDamage = Infest:GetSpecialValueInt('damage')
	local nRadius = Infest:GetSpecialValueInt('radius')

    if not J.IsRetreating(bot) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nRadius)
            and J.CanCastOnNonMagicImmune(enemy)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if J.IsInTeamFight(bot, nRadius) and J.GetHP(bot) > 0.55 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) then
        if #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.GetHP(bot) > 0.7 and #nAllyHeroes >= #nEnemyHeroes
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

return X