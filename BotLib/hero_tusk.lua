local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_tusk'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_pipe"}
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
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_tango",
                "item_double_branches",
                "item_double_gauntlets",
            
                "item_bottle",
                "item_magic_wand",
                "item_phase_boots",
                "item_soul_ring",
                "item_bfury",--
                "item_desolator",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_assault",--
                "item_satanic",--
                "item_moon_shard",
                -- "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_satanic",
            },
        },
    },
    ['pos_3'] = {
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
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_tango",
                "item_double_branches",
                "item_double_gauntlets",
            
                "item_magic_wand",
                "item_phase_boots",
                "item_soul_ring",
                "item_blink",
                "item_crimson_guard",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_cyclone",
                "item_assault",--
                "item_wind_waker",--
                "item_overwhelming_blink",--
                "item_moon_shard",
                -- "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_cyclone",
                "item_soul_ring", "item_assault",
            },
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
                [1] = {3,1,2,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_blink",
                "item_solar_crest",--
                "item_aghanims_shard",
                "item_boots_of_bearing",--
                "item_cyclone",
                "item_lotus_orb",--
                "item_black_king_bar",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_overwhelming_blink",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
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
                [1] = {3,1,2,3,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_blink",
                "item_solar_crest",--
                "item_aghanims_shard",
                "item_guardian_greaves",--
                "item_cyclone",
                "item_lotus_orb",--
                "item_black_king_bar",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_overwhelming_blink",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
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

local IceShards         = bot:GetAbilityByName('tusk_ice_shards')
local Snowball          = bot:GetAbilityByName('tusk_snowball')
local LaunchSnowball    = bot:GetAbilityByName('tusk_launch_snowball')
local TagTeam           = bot:GetAbilityByName('tusk_tag_team')
local DrinkingBuddies   = bot:GetAbilityByName('tusk_drinking_buddies')
local WalrusKick        = bot:GetAbilityByName('tusk_walrus_kick')
local WalrusPunch       = bot:GetAbilityByName('tusk_walrus_punch')

local IceShardsDesire, IceShardsLocation
local SnowballDesire, SnowballTarget
local LaunchSnowballDesire
local TagTeamDesire
local DrinkingBuddiesDesire, DrinkingBuddiesTarget
local WalrusKickDesire, WalrusKickTarget
local WalrusPunchDesire, WalrusPunchTarget

local bCannotUseAbility = false
local bSnowBallHold = false

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()
    bCannotUseAbility = J.CanNotUseAbility(bot)

    IceShards         = bot:GetAbilityByName('tusk_ice_shards')
    Snowball          = bot:GetAbilityByName('tusk_snowball')
    LaunchSnowball    = bot:GetAbilityByName('tusk_launch_snowball')
    TagTeam           = bot:GetAbilityByName('tusk_tag_team')
    DrinkingBuddies   = bot:GetAbilityByName('tusk_drinking_buddies')
    WalrusKick        = bot:GetAbilityByName('tusk_walrus_kick')
    WalrusPunch       = bot:GetAbilityByName('tusk_walrus_punch')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    TagTeamDesire = X.ConsiderTagTeam()
    if TagTeamDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(TagTeam)
        return
    end

    DrinkingBuddiesDesire, DrinkingBuddiesTarget = X.ConsiderDrinkingBuddies()
    if DrinkingBuddiesDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DrinkingBuddies, DrinkingBuddiesTarget)
        return
    end

    IceShardsDesire, IceShardsLocation = X.ConsiderIceShards()
    if IceShardsDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(IceShards, IceShardsLocation)
        return
    end

    LaunchSnowballDesire = X.ConsiderLaunchSnowball()
    if LaunchSnowballDesire > 0
    then
        bot:Action_UseAbility(LaunchSnowball)
        return
    end

    SnowballDesire, SnowballTarget = X.ConsiderSnowball()
    if SnowballDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Snowball, SnowballTarget)
        return
    end

    -- WalrusKickDesire, WalrusKickTarget = X.ConsiderWalrusKick()

    WalrusPunchDesire, WalrusPunchTarget = X.ConsiderWalrusPunch()
    if WalrusPunchDesire > 0
    then
        bot:Action_UseAbilityOnEntity(WalrusPunch, WalrusPunchTarget)
        return
    end
end

function X.ConsiderIceShards()
    if bCannotUseAbility
    or not J.CanCastAbility(IceShards)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = IceShards:GetCastRange()
	local nCastPoint = IceShards:GetCastPoint()
    local nRadius = IceShards:GetSpecialValueInt('shard_width')
    local nDistance = IceShards:GetSpecialValueInt('shard_distance')
	local nDamage = IceShards:GetSpecialValueInt('shard_damage')
	local nSpeed = IceShards:GetSpecialValueInt('shard_speed')
    local nAbilityLevel = IceShards:GetLevel()
    local nManaCost = IceShards:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IceShards, TagTeam, DrinkingBuddies, WalrusPunch})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {TagTeam, DrinkingBuddies, WalrusPunch})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta =  (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), nDistance)
            local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, nRadius)

            if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                if J.IsChasingTarget(bot, botTarget) or #nInRangeEnemy >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 800)
            and not J.IsInRange(bot, enemyHero, nDistance + 100)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
            and J.IsChasingTarget(enemyHero, bot)
			then
                local vLocation = (bot:GetLocation() + enemyHero:GetLocation()) / 2
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
			end
		end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if  J.IsPushing(bot)
    and nAbilityLevel >= 3
    and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0
    then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorAway(nLocationAoE.targetloc, bot:GetLocation(), 400)
                end
            end
        end
    end

    if  J.IsDefending(bot)
    and nAbilityLevel >= 3
    and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0
    then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorAway(nLocationAoE.targetloc, bot:GetLocation(), 400)
                end
            end
        end
	end

    if  J.IsFarming(bot)
    and nAbilityLevel >= 3
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
    and fManaAfter > fManaThreshold2 and bAttacking
    then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorAway(nLocationAoE.targetloc, bot:GetLocation(), 400)
                end
            end
        end
    end

    if  J.IsLaning(bot) and J.IsInLaningPhase()
    and fManaAfter > fManaThreshold2 and bAttacking
    and (J.IsCore(bot) or not J.IsThereCoreNearby(800))
	then
        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep)
            and string.find(creep:GetUnitName(), 'ranged')
            then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local nInRangeEnemy = J.GetEnemiesNearLoc(creep:GetLocation(), 500)
                    if #nInRangeEnemy > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorAway(creep:GetLocation(), bot:GetLocation(), 500)
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSnowball()
    if bCannotUseAbility
    or not J.CanCastAbility(Snowball)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Snowball:GetCastRange())
    local nDuration = Snowball:GetSpecialValueFloat('snowball_duration')
    local nManaCost = Snowball:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IceShards, WalrusPunch})

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 800
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
        then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            if #nInRangeAlly >= #nInRangeEnemy then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        local hTargetCreep = nil
        local hTargetCreepDistance = math.huge
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep)
            and J.CanCastOnTargetAdvanced(creep)
            then
                local creepBotDistance = GetUnitToUnitDistance(creep, bot)
                local creepFountainDistance = GetUnitToLocationDistance(creep, J.GetTeamFountain())
                local botFountainDistance = GetUnitToLocationDistance(bot, J.GetTeamFountain())

                if  creepFountainDistance < hTargetCreepDistance
                and creepBotDistance > 600
                and botFountainDistance > creepFountainDistance
                then
                    hTargetCreep = creep
                    hTargetCreepDistance = creepFountainDistance
                end
            end
        end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    for i = 0, 5 do
                        local hItem = bot:GetItemInSlot(i)
                        if hItem then
                            local sItemName = hItem:GetName()
                            if sItemName == 'item_blink' or sItemName == 'item_overwhelming_blink' or sItemName == 'item_swift_blink' or sItemName == 'item_arcane_blink' then
                                if hItem:GetCooldownTimeRemaining() <= nDuration then
                                    bSnowBallHold = true
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                                end
                            end
                        end
                    end

                    if hTargetCreep then
                        bSnowBallHold = false
                        return BOT_ACTION_DESIRE_HIGH, hTargetCreep
                    end

                    bSnowBallHold = true
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and J.CanKillTarget(botTarget, botTarget:GetAttackTarget() * 3, DAMAGE_TYPE_PHYSICAL)
        and botTarget:GetAttackTarget() == bot
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and botHP < 0.2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderLaunchSnowball()
    if not J.CanCastAbility(LaunchSnowball) then
        bSnowBallHold = false
        return BOT_ACTION_DESIRE_NONE
    end

    if bSnowBallHold then
        return BOT_ACTION_DESIRE_NONE
    end

    return BOT_ACTION_DESIRE_HIGH
end

function X.ConsiderTagTeam()
    if bCannotUseAbility
    or not J.CanCastAbility(TagTeam)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = TagTeam:GetSpecialValueInt('radius')
    local nManaCost = TagTeam:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IceShards, Snowball, WalrusPunch})

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		if #nInRangeEnemy >= 2 and fManaAfter > fManaThreshold1 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsMagicImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            local nInRangeAlly = bot:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
            if #nInRangeAlly >= 2 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            local nInRangeAlly = bot:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
            if #nInRangeAlly >= 2 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- no alt-cast support from the api
function X.ConsiderDrinkingBuddies()
    if bCannotUseAbility
    or not J.CanCastAbility(DrinkingBuddies)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DrinkingBuddies:GetCastRange())
    local nManaCost = DrinkingBuddies:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IceShards, Snowball, WalrusPunch})

    local hTarget = nil
	local hTargetDamage = 0
    for _, allyHero in pairs(nAllyHeroes) do
        if  allyHero ~= bot
        and J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        then
            local vLocation = (bot:GetLocation() + allyHero:GetLocation()) / 2
            if IsLocationPassable(vLocation) then
                if J.IsStuck(bot) or J.IsStuck(allyHero) then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end

                if J.IsDoingRoshan(bot) then
                    if  J.IsRoshan(botTarget)
                    and J.CanBeAttacked(botTarget)
                    and J.IsInRange(bot, botTarget, 800)
                    and bAttacking
                    and fManaAfter > fManaThreshold1
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                if J.IsDoingTormentor(bot) then
                    if  J.IsTormentor(botTarget)
                    and J.IsInRange(bot, botTarget, 500)
                    and bAttacking
                    and fManaAfter > fManaThreshold1
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                if  not J.IsDisabled(allyHero)
                and not J.IsWithoutTarget(allyHero)
                and not J.IsRetreating(allyHero)
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
                    if nDamage > hTargetDamage then
                        hTarget = allyHero
                        hTargetDamage = nDamage
                    end
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) and hTarget ~= nil then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local bBotChasing = J.IsChasingTarget(bot, botTarget)
            local bAllyChasing = J.IsChasingTarget(hTarget, botTarget)
            local distbotToTarget = GetUnitToUnitDistance(bot, botTarget)
            local distAllyToTarget = GetUnitToUnitDistance(hTarget, botTarget)
            if (not bBotChasing or (bBotChasing and bAllyChasing and distAllyToTarget < distbotToTarget and distAllyToTarget < 500))
            then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nAllyHeroes > 1 then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.IsChasingTarget(enemyHero, bot)
            then
                if (bot:WasRecentlyDamagedByAnyHero(3.0) and not J.IsSuspiciousIllusion(enemyHero))
                or (#nAllyHeroes + 2 <= #nEnemyHeroes)
                then
                    for _, allyHero in pairs(nAllyHeroes) do
                        if  allyHero ~= bot
                        and J.IsValidHero(allyHero)
                        and not J.IsSuspiciousIllusion(allyHero)
                        and J.IsRetreating(allyHero)
                        and GetUnitToUnitDistance(allyHero, enemyHero) > GetUnitToUnitDistance(bot, enemyHero)
                        and GetUnitToLocationDistance(enemyHero, ((bot:GetLocation() + allyHero:GetLocation()) / 2)) > 500
                        then
                            return BOT_ACTION_DESIRE_HIGH, allyHero
                        end
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWalrusPunch()
    if bCannotUseAbility
    or not J.CanCastAbility(WalrusPunch)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, WalrusPunch:GetCastRange())
    local nBonusDamage = WalrusPunch:GetSpecialValueInt('bonus_damage')
    local nCritMul = WalrusPunch:GetSpecialValueInt('crit_multiplier') / 100
    local nDamage = (bot:GetAttackDamage() + nBonusDamage) * nCritMul
    local nManaCost = WalrusPunch:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {IceShards, Snowball, WalrusPunch})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

    if  J.IsValid(botTarget)
    and J.CanBeAttacked(botTarget)
    and botTarget:IsCreep()
    and not J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_PHYSICAL)
    and not J.IsOtherAllysTarget(botTarget)
    and not bot:WasRecentlyDamagedByAnyHero(5.0)
    and bAttacking
    and fManaAfter > fManaThreshold1
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X