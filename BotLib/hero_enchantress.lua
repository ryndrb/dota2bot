local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_enchantress'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_heavens_halberd"}
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
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_circlet",
                "item_gauntlets",
                "item_quelling_blade",
            
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_bracer",
                "item_maelstrom",
                "item_dragon_lance",
                "item_hurricane_pike",--
                "item_mjollnir",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_monkey_king_bar",--
                "item_sheepstick",--
                "item_moon_shard",
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_dragon_lance",
                "item_magic_wand", "item_bloodthorn",
                "item_bracer", "item_monkey_king_bar",
                "item_bottle", "item_sheepstick",
            },
        },
    },
    ['pos_3'] = {
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
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_magic_stick",
                "item_double_branches",
                "item_circlet",
            
                "item_power_treads",
                "item_bracer",
                "item_magic_wand",
                "item_dragon_lance",
                "item_pipe",--
                "item_assault",--
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_orchid",
                "item_sheepstick",--
                "item_bloodthorn",
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_orchid",
                "item_bracer", "item_sheepstick",
            },
        },
    },
    ['pos_4'] = {
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
                [1] = {2,3,2,3,2,6,2,1,1,1,1,6,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_force_staff",
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_hurricane_pike",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_orchid",
                "item_sheepstick",--
                "item_bloodthorn",--
                "item_assault",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_assault",
            },
        },
    },
    ['pos_5'] = {
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
                [1] = {2,3,2,3,2,6,2,1,1,1,1,6,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_force_staff",
                "item_mekansm",
                "item_solar_crest",--
                "item_hurricane_pike",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_orchid",
                "item_sheepstick",--
                "item_bloodthorn",--
                "item_assault",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_assault",
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

local Impetus           = bot:GetAbilityByName('enchantress_impetus')
local Enchant           = bot:GetAbilityByName('enchantress_enchant')
local NaturesAttendant  = bot:GetAbilityByName('enchantress_natures_attendants')
local Sproink           = bot:GetAbilityByName('enchantress_bunny_hop')
local LittleFriends     = bot:GetAbilityByName('enchantress_little_friends')
-- local Untouchable       = bot:GetAbilityByName('enchantress_untouchable')

local ImpetusDesire, ImpetusTarget
local EnchantDesire, EnchantTarget
local NaturesAttendantDesire
local SproinkDesire
local LittleFriendsDesire, LittleFriendsTarget

local bAttacking = false
local botTarget, botHP, botAttackRange
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    Impetus           = bot:GetAbilityByName('enchantress_impetus')
    Enchant           = bot:GetAbilityByName('enchantress_enchant')
    NaturesAttendant  = bot:GetAbilityByName('enchantress_natures_attendants')
    Sproink           = bot:GetAbilityByName('enchantress_bunny_hop')
    LittleFriends     = bot:GetAbilityByName('enchantress_little_friends')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    botAttackRange = bot:GetAttackRange()
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    LittleFriendsDesire, LittleFriendsTarget = X.ConsiderLittleFriends()
    if LittleFriendsDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LittleFriends, LittleFriendsTarget)
        return
    end

    SproinkDesire = X.ConsiderSproink()
    if SproinkDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Sproink)
        return
    end

    NaturesAttendantDesire = X.ConsiderNaturesAttendant()
    if NaturesAttendantDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(NaturesAttendant)
        return
    end

    EnchantDesire, EnchantTarget = X.ConsiderEnchant()
    if EnchantDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Enchant, EnchantTarget)
        return
    end

    ImpetusDesire, ImpetusTarget = X.ConsiderImpetus()
    if ImpetusDesire > 0 then
        bot:Action_UseAbilityOnEntity(Impetus, ImpetusTarget)
        return
    end
end

function X.ConsiderImpetus()
    if not J.CanCastAbility(Impetus)
    or bot:IsDisarmed()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local botAttackDamage = bot:GetAttackDamage()
    local nCastPoint = Impetus:GetCastPoint()
    local nDistanceCap = Impetus:GetSpecialValueInt('distance_cap')
    local nDistancePct = Impetus:GetSpecialValueInt('distance_damage_pct') / 10
    local nManaCost = Impetus:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Enchant, NaturesAttendant, Sproink, LittleFriends})

    local bIsAutoCasted = Impetus:GetAutoCastState()

    if bot:HasModifier('modifier_item_hurricane_pike_range') then
        if not bIsAutoCasted then
            Impetus:ToggleAutoCast()
        end

        return BOT_ACTION_DESIRE_NONE
    else
        if bIsAutoCasted then
            Impetus:ToggleAutoCast()
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidTarget(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, botAttackRange + 300)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local dist = GetUnitToUnitDistance(bot, enemyHero)
            local nDamage = botAttackDamage + dist * RemapValClamped(dist, 0, nDistanceCap, 0, nDistancePct)
            local eta = ((dist - botAttackRange) / bot:GetCurrentMovementSpeed()) + ((dist - botAttackRange) / bot:GetAttackProjectileSpeed()) + nCastPoint --?

            if J.WillKillTarget(bot, nDamage, DAMAGE_TYPE_PURE, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
        and not J.IsInRange(bot, botTarget, botAttackRange / 2)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1 + 0.1
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end

        if fManaAfter > fManaThreshold1 + 0.05 then
            local hTarget = nil
            local hTargetHealth = math.huge
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, botAttackRange)
                and not J.IsInRange(bot, enemyHero, botAttackRange / 2)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    local enemyHeroHealth = enemyHero:GetHealth()
                    if enemyHeroHealth < hTargetHealth then
                        hTarget = enemyHero
                        hTargetHealth = enemyHeroHealth
                    end
                end
            end

            if hTarget then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
	end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        if  J.IsValid(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and not J.IsInRange(bot, botTarget, botAttackRange / 2)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.CanKillTarget(botTarget, botAttackDamage * 2, DAMAGE_TYPE_PURE)
        and not J.IsRoshan(botTarget)
        and not J.IsTormentor(botTarget)
        and not botTarget:IsBuilding()
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.IsInRange(bot, creep, botAttackRange + 300)
            and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
            then
				local sCreepName = creep:GetUnitName()
				local dist = GetUnitToUnitDistance(bot, creep)
                local nDamage = botAttackDamage + dist * RemapValClamped(dist, 0, nDistanceCap, 0, nDistancePct)
                local eta = ((dist - botAttackRange) / bot:GetCurrentMovementSpeed()) + ((dist - botAttackRange) / bot:GetAttackProjectileSpeed()) + nCastPoint

				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PURE, eta) then
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

    if (not J.IsInLaningPhase() or #nEnemyHeroes == 0) and not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.IsInRange(bot, creep, botAttackRange + 300)
            and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
            then
				local dist = GetUnitToUnitDistance(bot, creep)
                local nDamage = botAttackDamage + dist * RemapValClamped(dist, 0, nDistanceCap, 0, nDistancePct)
                local eta = ((dist - botAttackRange) / bot:GetCurrentMovementSpeed()) + ((dist - botAttackRange) / bot:GetAttackProjectileSpeed()) + nCastPoint

				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PURE, eta) then
                    return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and not J.IsInRange(bot, botTarget, botAttackRange / 2)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.15
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and not J.IsInRange(bot, botTarget, botAttackRange / 2)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.15
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderEnchant()
    if not J.CanCastAbility(Enchant) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Enchant:GetCastRange())
    local nMaxLevel = Enchant:GetSpecialValueInt('level_req')
    local nManaCost = Impetus:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {NaturesAttendant, Sproink, LittleFriends})

    for _, allyHero in pairs(nAllyHeroes)
    do
        if J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(5.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    local nGoodCreep = {
        ['npc_dota_neutral_alpha_wolf'] = true,
        ['npc_dota_neutral_centaur_khan'] = true,
        ['npc_dota_neutral_polar_furbolg_ursa_warrior'] = true,
        ['npc_dota_neutral_dark_troll_warlord'] = true,
        ['npc_dota_neutral_satyr_hellcaller'] = true,
        ['npc_dota_neutral_enraged_wildkin'] = true,
        ['npc_dota_neutral_warpine_raider'] = true,
        ['npc_dota_neutral_satyr_soulstealer'] = true,
        ['npc_dota_neutral_ogre_mauler'] = true,
        ['npc_dota_neutral_ogre_magi'] = true,
        ['npc_dota_neutral_mud_golem'] = true,
        ['npc_dota_neutral_grown_frog'] = true,
        ['npc_dota_neutral_grown_frog_mage'] = true,
    }

    if not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep)
            and J.CanCastOnTargetAdvanced(creep)
            and not J.IsRoshan(creep)
            and not J.IsTormentor(creep)
            and creep:GetLevel() <= nMaxLevel
            then
                local sCreepName = creep:GetUnitName()
                if (nGoodCreep[sCreepName])
                or (creep:IsDominated() and creep:GetHealth() >= 900)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                if J.IsInLaningPhase() then
                    if string.find(sCreepName, 'beastmaster_boar')
                    or string.find(sCreepName, 'forge_spirit')
                    or string.find(sCreepName, 'lycan_wolf')
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNaturesAttendant()
    if not J.CanCastAbility(NaturesAttendant) or J.IsRealInvisible(bot) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = NaturesAttendant:GetSpecialValueInt('radius')

    if (botHP < 0.65 and bot:DistanceFromFountain() > 800)
    or (botHP < 0.80 and bot:IsRooted() and bot:WasRecentlyDamagedByAnyHero(2.0))
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and bot ~= allyHero
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nRadius + 75)
        and not J.IsSuspiciousIllusion(allyHero)
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_ice_blast')
        and not allyHero:HasModifier('modifier_item_spirit_vessel_damage')
        then
            if J.IsDisabled(allyHero)
            or allyHero:GetCurrentMovementSpeed() < 200
            or math.abs(allyHero:GetCurrentMovementSpeed() - bot:GetCurrentMovementSpeed()) <= 20
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSproink()
    if not J.CanCastAbility(Sproink)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange / 2)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            then
                if GetUnitToLocationDistance(bot, J.GetTeamFountain()) < GetUnitToLocationDistance(enemyHero, J.GetTeamFountain()) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLittleFriends()
    if not J.CanCastAbility(LittleFriends) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, LittleFriends:GetCastRange())
    local nRadius = LittleFriends:GetSpecialValueInt('radius')
    local nDuration = LittleFriends:GetSpecialValueInt('duration')

    if J.IsGoingOnSomeone(bot, 1200) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nLocationAoE = bot:FindAoELocation(false, false, botTarget:GetLocation(), 0, nRadius * 0.8, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X