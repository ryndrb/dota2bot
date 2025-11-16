local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_witch_doctor'
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
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_aghanims_shard",
				"item_ancient_janggo",
				"item_lotus_orb",--
				"item_ultimate_scepter",
				"item_boots_of_bearing",--
				"item_black_king_bar",--
				"item_refresher",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_refresher",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_aghanims_shard",
				"item_mekansm",
				"item_lotus_orb",--
				"item_ultimate_scepter",
				"item_guardian_greaves",--
				"item_black_king_bar",--
				"item_refresher",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_refresher",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_priest' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
		and hMinionUnit:GetUnitName() ~= 'npc_dota_witch_doctor_death_ward'
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local ParalyzingClask = bot:GetAbilityByName('witch_doctor_paralyzing_cask')
local VoodooRestoration = bot:GetAbilityByName('witch_doctor_voodoo_restoration')
local Maledict = bot:GetAbilityByName('witch_doctor_maledict')
local VoodooSwitcheroo = bot:GetAbilityByName('witch_doctor_voodoo_switcheroo')
local DeathWard = bot:GetAbilityByName('witch_doctor_death_ward')

local ParalyzingClaskDesire, ParalyzingClaskTarget
local VoodooRestorationDesire
local MaledictDesire, MaledictLocation
local VoodooSwitcherooDesire
local DeathWardDesire, DeathWardLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	X.ConsiderInvisible()

	if J.CanNotUseAbility(bot) then return end

	ParalyzingClask = bot:GetAbilityByName('witch_doctor_paralyzing_cask')
	VoodooRestoration = bot:GetAbilityByName('witch_doctor_voodoo_restoration')
	Maledict = bot:GetAbilityByName('witch_doctor_maledict')
	VoodooSwitcheroo = bot:GetAbilityByName('witch_doctor_voodoo_switcheroo')
	DeathWard = bot:GetAbilityByName('witch_doctor_death_ward')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	VoodooSwitcherooDesire = X.ConsiderVoodooSwitcheroo()
	if VoodooSwitcherooDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(VoodooSwitcheroo)
		return
	end

	MaledictDesire, MaledictLocation = X.ConsiderMaledict()
	if MaledictDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Maledict, MaledictLocation)
		return
	end

	ParalyzingClaskDesire, ParalyzingClaskTarget = X.ConsiderParalyzingClask()
	if ParalyzingClaskDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ParalyzingClask, ParalyzingClaskTarget)
		return
	end

	VoodooRestorationDesire = X.ConsiderVoodooRestoration()
	if VoodooRestorationDesire > 0 then
		bot:ActionQueue_UseAbility(VoodooRestoration)
		return
	end

	DeathWardDesire, DeathWardLocation, bShouldBKB = X.ConsiderDeathWard()
	if DeathWardDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		if bShouldBKB then
			local hItem = J.IsItemAvailable('item_black_king_bar')
			if J.CanCastAbility(hItem) then
				local manaCost = hItem:GetManaCost() + DeathWard:GetManaCost() + 100
				if bot:GetMana() > manaCost then
					bot:ActionQueue_UseAbility(hItem)
					bot:ActionQueue_UseAbilityOnLocation(DeathWard, DeathWardLocation)
					return
				end
			end
		end

		bot:ActionQueue_UseAbilityOnLocation(DeathWard, DeathWardLocation)
		return
	end
end

function X.ConsiderParalyzingClask()
	if not J.CanCastAbility(ParalyzingClask) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ParalyzingClask:GetCastRange()
	local nCastPoint = ParalyzingClask:GetCastPoint()
	local nRadius = ParalyzingClask:GetSpecialValueInt('bounce_range')
	local nDamage = ParalyzingClask:GetSpecialValueInt('base_damage')
	local nSpeed = ParalyzingClask:GetSpecialValueInt('speed')
	local nManaCost = ParalyzingClask:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Maledict, VoodooSwitcheroo, DeathWard})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 200)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 + 0.1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		then
			local nLocationAoE_Heroes = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
			local nLocationAoE_Creeps = bot:FindAoELocation(true, false, botTarget:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE_Heroes.count >= 2 or nLocationAoE_Creeps.count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				local nLocationAoE_Heroes = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				local nLocationAoE_Creeps = bot:FindAoELocation(true, false, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE_Heroes.count >= 2 or nLocationAoE_Creeps.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
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

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
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

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsOtherAllysTarget(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                    if string.find(sCreepName, 'ranged') then
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end

                    nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius * 0.75, 0, nDamage * 2)
                    if fManaAfter > fManaThreshold1 + 0.1 and nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 3 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderVoodooRestoration()
	if not J.CanCastAbility(VoodooRestoration) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = VoodooRestoration:GetSpecialValueInt('radius')
	local nManaCost = VoodooRestoration:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ParalyzingClask, VoodooRestoration, Maledict, VoodooSwitcheroo, DeathWard})

	local bIsToggled = VoodooRestoration:GetToggleState()

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nRadius)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not allyHero:HasModifier('modifier_fountain_aura_buff')
		and allyHero:GetUnitName() ~= 'npc_dota_hero_medusa'
		and allyHero:GetUnitName() ~= 'npc_dota_hero_huskar'
		and J.GetHP(allyHero) < 0.75
		then
			if fManaAfter > fManaThreshold1 + 0.1 then
				if not bIsToggled then
					return BOT_ACTION_DESIRE_HIGH
				else
					return BOT_ACTION_DESIRE_NONE
				end
			end
		end
	end

	if bIsToggled then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderMaledict()
	if not J.CanCastAbility(Maledict) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Maledict:GetCastRange()
	local nCastPoint = Maledict:GetCastPoint()
	local nRadius = Maledict:GetSpecialValueInt('radius')
	local nManaCost = Maledict:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {VoodooSwitcheroo, DeathWard})

	if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1 then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_maledict')
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot) and fManaAfter > fManaThreshold1 then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderVoodooSwitcheroo()
	if not J.CanCastAbility(VoodooSwitcheroo) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 600
	local nManaCost = VoodooSwitcheroo:GetManaCost()

	if DeathWard and DeathWard:IsTrained() then
		nRadius = DeathWard:GetSpecialValueInt('attack_range_tooltip')
	end

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 800)
		or (J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth())
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
			if (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.0) > bot:GetHealth())
			or (J.IsStunProjectileIncoming(bot, 800))
			or (#nInRangeEnemy >= 2)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDeathWard()
	if not J.CanCastAbility(DeathWard) then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nCastRange = DeathWard:GetCastRange()
	local nCastPoint = DeathWard:GetCastPoint()
	local nRadius = DeathWard:GetSpecialValueInt('attack_range_tooltip')
	local nDamage = DeathWard:GetSpecialValueInt('damage')
	local nDuration = DeathWard:GetSpecialValueInt('AbilityChannelTime')
	local nManaCost = DeathWard:GetManaCost()

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 800) then
			return BOT_ACTION_DESIRE_NONE, 0, false
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0

		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsChasingTarget(bot, enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
			and enemyHero:GetHealth() > 500
			then
				local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), hTarget:GetLocation(), Min(GetUnitToUnitDistance(bot, hTarget), nCastRange)), true
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsChasingTarget(bot, botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and botTarget:GetHealth() > 500
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if not (#nInRangeAlly >= #nInRangeEnemy + 3) then
				if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, nDuration - 1) > botTarget:GetHealth()
				or J.IsDisabled(botTarget)
				then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), Min(GetUnitToUnitDistance(bot, botTarget), nCastRange)), false
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderInvisible()
	if DeathWard and DeathWard:IsTrained() and DeathWard:IsChanneling() and not J.IsRealInvisible(bot) then
		local hItem = J.IsItemAvailable('item_shadow_amulet')
		if J.CanCastAbility(hItem) then
			bot:Action_UseAbilityOnEntity(hItem, bot)
			return
		end

		hItem = J.IsItemAvailable('item_glimmer_cape')
		if J.CanCastAbility(hItem) then
			bot:Action_UseAbilityOnEntity(hItem, bot)
			return
		end

		hItem = J.IsItemAvailable('item_invis_sword')
		if J.CanCastAbility(hItem) then
			bot:Action_UseAbility(hItem)
			return
		end

		hItem = J.IsItemAvailable('item_silver_edge')
		if J.CanCastAbility(hItem) then
			bot:Action_UseAbility(hItem)
			return
		end
	end
end

return X
