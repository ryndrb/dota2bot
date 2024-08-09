local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bane'
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,2,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_enchanted_mango",
			
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_urn_of_shadows",
				"item_phylactery",
				"item_hand_of_midas",
				"item_spirit_vessel",
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_kaya_and_sange",--
				"item_angels_demise",--
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_travel_boots",
				"item_octarine_core",--
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_bottle",
				"item_magic_wand",
				"item_hand_of_midas",
				"item_spirit_vessel",
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
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_blood_grenade",
			
				"item_circlet",
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_aether_lens",--
				"item_solar_crest",--
				"item_glimmer_cape",--
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_ultimate_scepter",
				"item_aeon_disk",--
				"item_refresher",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_magic_wand",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {2,3,2,3,2,6,2,3,3,1,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_blood_grenade",
			
				"item_circlet",
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_aether_lens",--
				"item_glimmer_cape",--
				"item_aghanims_shard",
				"item_force_staff",--
				"item_guardian_greaves",--
				"item_ultimate_scepter",
				"item_aeon_disk",--
				"item_refresher",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_magic_wand",
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

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local Enfeeble
local BrainSap
local Nightmare
local FiendsGrip

local EnfeebleDesire, EnfeebleTarget
local BrainSapDesire, BrainSapTarget
local NightmareDesire, NightmareTarget
local FiendsGripDesire, FiendsGripTarget

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	Enfeeble = bot:GetAbilityByName( 'bane_enfeeble' )
	BrainSap = bot:GetAbilityByName( 'bane_brain_sap' )
	Nightmare = bot:GetAbilityByName( 'bane_nightmare' )
	FiendsGrip = bot:GetAbilityByName( 'bane_fiends_grip' )

	EnfeebleDesire, EnfeebleTarget = X.ConsiderEnfeeble()
    if EnfeebleDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Enfeeble, EnfeebleTarget)
        return
    end

	BrainSapDesire, BrainSapTarget = X.ConsiderBrainSap()
    if BrainSapDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if J.CheckBitfieldFlag(BrainSap:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)
        then
            bot:ActionQueue_UseAbilityOnEntity(BrainSap, BrainSapTarget)
        else
            bot:ActionQueue_UseAbilityOnLocation(BrainSap, BrainSapTarget:GetLocation())
        end

        return
    end

	FiendsGripDesire, FiendsGripTarget = X.ConsiderFiendsGrip()
    if FiendsGripDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
		J.SetQueueToInvisible(bot)
        bot:ActionQueue_UseAbilityOnEntity(FiendsGrip, FiendsGripTarget)
        return
    end


	NightmareDesire, NightmareTarget = X.ConsiderNightmare()
	if NightmareDesire > 0
	then
		J.SetQueuePtToINT( bot, true )
		bot:ActionQueue_UseAbilityOnEntity(Nightmare, NightmareTarget)
		return
	end
end

function X.ConsiderEnfeeble()
	if not J.CanCastAbility(Enfeeble)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nSkillLV = Enfeeble:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, Enfeeble:GetCastRange())
	local nInRangeEnemy = J.GetAroundEnemyHeroList(nCastRange)
    local botTarget = J.GetProperTarget(bot)

    if J.IsInTeamFight(bot, 1200)
    then
        local nTarget = J.GetHighestRightClickDamageHero(nInRangeEnemy)
        if J.IsValidHero(nTarget)
        and J.CanCastOnNonMagicImmune(nTarget)
        and J.CanCastOnTargetAdvanced(nTarget)
        and not nTarget:HasModifier('modifier_bane_enfeeble')
        and not nTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, nTarget
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 50)
        and not botTarget:HasModifier('modifier_bane_enfeeble')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if nSkillLV >= 2 or J.GetMP(bot) > 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end

		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_bane_enfeeble')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBrainSap()
	if not J.CanCastAbility(BrainSap)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nSkillLV = BrainSap:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, BrainSap:GetCastRange())
	local nCastPoint = BrainSap:GetCastPoint()
	local nManaCost = BrainSap:GetManaCost()
	local nDamage = BrainSap:GetSpecialValueInt('brain_sap_damage')
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nLostHealth = bot:GetMaxHealth() - bot:GetHealth()
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if bot:GetUnitName() == 'npc_dota_hero_bane'
    then
        local Talent8 = bot:GetAbilityByName('special_bonus_unique_bane_2')
        if Talent8 ~= nil then nDamage = nDamage + Talent8:GetSpecialValueInt('value') end
    end

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.WillMagicKillTarget(bot, enemyHero, nDamage, nCastPoint)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if bot:GetLevel() <= 7 and J.GetMP(bot) < 0.72 and nLostHealth < nDamage * 0.8
	then
        return BOT_ACTION_DESIRE_NONE
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nWeakestEnemy = nil
		local nWeakestEnemyHealth = 99999

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyHealth = enemyHero:GetHealth()
				if npcEnemyHealth < nWeakestEnemyHealth
				then
					nWeakestEnemyHealth = npcEnemyHealth
					nWeakestEnemy = enemyHero
				end
			end
		end

		if nWeakestEnemy ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nWeakestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 50)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if nSkillLV >= 2 or J.GetMP(bot) > 0.78 or J.GetHP(botTarget) < 0.38
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if  bot:WasRecentlyDamagedByAnyHero(3)
    and bot:GetLevel() >= 10
    and nLostHealth >= nDamage
    and not J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:IsFacingLocation(enemyHero:GetLocation(), 45)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsRetreating(bot) and nLostHealth > nDamage
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) or nLostHealth > nDamage * 2)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end

		if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and bot:GetLevel() >= 10
        and nLostHealth > nDamage * 1.5
        and not bot:WasRecentlyDamagedByAnyHero(3)
		then
			local nCreepList = bot:GetNearbyCreeps(1600, true)
			for _, creep in pairs(nCreepList)
			do
				if  J.IsValid(creep)
				and J.IsInRange(bot, creep, nCastRange)
                and J.CanCastOnNonMagicImmune(creep)
                and J.CanBeAttacked(creep)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if  J.IsFarming(bot)
    and J.IsAllowedToSpam(bot, nManaCost)
    and nSkillLV >= 3
	then
		local targetCreep = botTarget

		if  J.IsValid(targetCreep)
        and J.IsInRange(bot, targetCreep, nCastRange + 100)
        and targetCreep:GetTeam() == TEAM_NEUTRAL
        and not J.IsRoshan(targetCreep)
        and (targetCreep:GetMagicResist() < 0.3 or J.GetMP(bot) > 0.8)
        and not J.CanKillTarget(targetCreep, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming( bot ))
    and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
    and nSkillLV >= 3
    and DotaTime() > 8 * 60
    and (J.IsCore(bot) or (not J.IsCore(bot) and nAllyHeroes ~= nil and #nAllyHeroes <= 2))
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local keyWord = "ranged"
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and (J.IsKeyWordUnit(keyWord, creep) or J.GetMP(bot) > 0.6)
            and J.WillKillTarget(creep, nDamage, nDamageType, nCastPoint)
            and J.CanBeAttacked(creep)
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.38, DAMAGE_TYPE_PHYSICAL)
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

    if  J.IsLaning(bot)
    and (J.IsCore(bot) or (not J.IsCore(bot) and not J.IsThereCoreNearby(1000)))
	then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
            and J.WillKillTarget(creep, nDamage, nDamageType, nCastPoint)
            and not J.CanKillTarget( creep, bot:GetAttackDamage() * 1.38, DAMAGE_TYPE_PHYSICAL)
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) < 500
                and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and not J.IsDisabled(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
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

	if  (nEnemyHeroes ~= nil and #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero(3))
    and (not J.IsRetreating(bot) or #nAllyHeroes ~= nil and #nAllyHeroes >= 2)
    and bot:GetLevel() >= 12
    and nLostHealth > nDamage
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNightmare()
	if not J.CanCastAbility(Nightmare) then return 0 end

	local nCastRange = Nightmare:GetCastRange()
	local nInRangeEnemyList = J.GetAroundEnemyHeroList(nCastRange)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if  J.IsRetreating(bot)
    and (bot:WasRecentlyDamagedByAnyHero(3) or bot:GetActiveModeDesire() > 0.7)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcStrongestEnemy = nil
		local nStrongestPower = 0
		local nEnemyCount = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				nEnemyCount = nEnemyCount + 1
				if  J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
				then
					local npcEnemyPower = enemyHero:GetEstimatedDamageToTarget(true, bot, 6.0, DAMAGE_TYPE_ALL)
					if npcEnemyPower > nStrongestPower
					then
						nStrongestPower = npcEnemyPower
						npcStrongestEnemy = enemyHero
					end
				end
			end
		end

		if  npcStrongestEnemy ~= nil and nEnemyCount >= 2
		and J.IsInRange(bot, npcStrongestEnemy, nCastRange + 150)
		then
			return BOT_ACTION_DESIRE_HIGH, npcStrongestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
		then
			for _, enemyHero in pairs( nInRangeEnemyList )
			do
				if  J.IsValid(enemyHero)
                and enemyHero ~= botTarget
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:IsDisarmed()
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if  J.IsInRange(bot, botTarget, nCastRange)
            and not J.IsInRange(bot, botTarget, 500)
            and J.IsRunning(botTarget)
            and bot:IsFacingLocation(botTarget:GetLocation(), 30)
            and not botTarget:IsFacingLocation(bot:GetLocation(), 150)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.CanCastOnTargetAdvanced(botTarget)
			then
				local nInRangeAlly = botTarget:GetNearbyHeroes(600, true, BOT_MODE_NONE)
				if nInRangeAlly ~= nil and #nInRangeAlly == 0
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFiendsGrip()
	if not J.CanCastAbility(FiendsGrip)
	then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, FiendsGrip:GetCastRange())
	local nDamage = FiendsGrip:GetSpecialValueInt( 'fiend_grip_damage' ) * 6
	local nDamageType = DAMAGE_TYPE_PURE
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local botTarget = J.GetProperTarget(bot)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValid(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.IsInRange(bot, enemyHero, nCastRange + 75)
            and J.CanKillTarget(enemyHero, nDamage, nDamageType)
			and not J.IsHaveAegis(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

		end
	end

    if BrainSap ~= nil and BrainSap:IsFullyCastable() and bot:GetMana() > FiendsGrip:GetManaCost() + BrainSap:GetManaCost() then return BOT_ACTION_DESIRE_NONE, nil end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcStrongestEnemy = nil
		local nStrongestPower = 0

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not J.IsHaveAegis(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyPower = enemyHero:GetEstimatedDamageToTarget(true, bot, 6.0, DAMAGE_TYPE_ALL)
				if npcEnemyPower > nStrongestPower
				then
					nStrongestPower = npcEnemyPower
					npcStrongestEnemy = enemyHero
				end
			end
		end

		if  npcStrongestEnemy ~= nil
        and J.IsInRange(bot, npcStrongestEnemy, nCastRange + 150)
		then
			return BOT_ACTION_DESIRE_HIGH, npcStrongestEnemy
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(botTarget, bot, nCastRange + 75)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X