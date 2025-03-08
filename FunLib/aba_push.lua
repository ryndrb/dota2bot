local Push = {}
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local ShouldNotPushLane = false
local LanePushCooldown = 0
local LanePush = LANE_MID

local GlyphDuration = 7
local ShoulNotPushTower = false
local TowerPushCooldown = 0

local pingTimeDelta = 5

function Push.GetPushDesire(bot, lane)
    if bot.laneToPush == nil then bot.laneToPush = lane end

    local nMaxDesire = 0.95 - 0.02
    local bMyLane = bot:GetAssignedLane() == lane

	if (not bMyLane and J.GetPosition(bot) == 1 and (DotaTime() < 12 * 60 and bot:GetNetWorth() <= 5000)) -- reduce carry feeds
    or (J.IsDoingRoshan(bot) and #J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 2800) >= 3)
    or (#J.GetAlliesNearLoc(J.GetTormentorLocation(GetTeam()), 1600) >= 3)
	then
		return BOT_MODE_DESIRE_NONE
	end

    for i = 1, 5
    do
		local member = GetTeamMember(i)
        if member ~= nil and member:GetLevel() < 8 then return BOT_MODE_DESIRE_NONE end
    end

    local human, humanPing = J.GetHumanPing()
	if human ~= nil and DotaTime() > pingTimeDelta
	then
		local isPinged, pingedLane = J.IsPingCloseToValidTower(GetOpposingTeam(), humanPing)
		if isPinged and lane == pingedLane
		and DotaTime() < humanPing.time + pingTimeDelta
		then
			return BOT_ACTION_DESIRE_ABSOLUTE * 0.95 - 0.01
		end
	end

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

    local nInRangeAlly_core = {}
    for _, ally in pairs(nInRangeAlly) do
        if J.IsValidHero(ally) and J.IsCore(ally) then
            table.insert(nInRangeAlly_core, ally)
        end
    end

    local nInRangeEnemy_core = {}
    for _, enemy in pairs(nInRangeEnemy) do
        if J.IsValidHero(enemy) and J.IsCore(enemy) then
            table.insert(nInRangeEnemy_core, enemy)
        end
    end

    if #nInRangeAlly < #nInRangeEnemy and #nInRangeAlly_core < #nInRangeEnemy_core then
        return BOT_MODE_DESIRE_NONE
    end

    if ShoulNotPushTower
    then
        if DotaTime() < TowerPushCooldown + GlyphDuration
        then
            return BOT_MODE_DESIRE_NONE
        else
            ShoulNotPushTower = false
            TowerPushCooldown = 0
        end
    end

    if ShouldNotPushLane
    then
        if DotaTime() < LanePushCooldown + 10
        then
            if LanePush == lane then
                return BOT_MODE_DESIRE_NONE
            end
        else
            ShouldNotPushLane = false
            LanePushCooldown = 0
        end
    end

    local aAliveCount = J.GetNumOfAliveHeroes(false)
    local eAliveCount = J.GetNumOfAliveHeroes(true)
    local allyKills = J.GetNumOfTeamTotalKills(false) + 1
    local enemyKills = J.GetNumOfTeamTotalKills(true) + 1
    local aAliveCoreCount = J.GetAliveCoreCount(false)
    local eAliveCoreCount = J.GetAliveCoreCount(true)
    local nPushDesire = GetPushLaneDesire(lane)

    local hEnemyAncient = GetAncient(GetOpposingTeam())
    if J.IsValidBuilding(hEnemyAncient)
    and J.CanBeAttacked(hEnemyAncient)
    and GetUnitToUnitDistance(bot, hEnemyAncient) < 2000
    then
        return BOT_MODE_DESIRE_HIGH - 0.01
    end

    local fEnemyLaneFrontAmount = GetLaneFrontAmount(GetOpposingTeam(), lane, true)
    if fEnemyLaneFrontAmount < 0.25 and GetUnitToUnitDistance(bot, hEnemyAncient) > 3500 then
        return BOT_MODE_DESIRE_HIGH - 0.01
    end

    local vEnemyLaneFrontLocation = GetLaneFrontLocation(GetOpposingTeam(), lane, 0)
    if nPushDesire > 0.7
    and Push.ShouldWaitForImportantItemsSpells(vEnemyLaneFrontLocation)
    and (  eAliveCount >= aAliveCount
        or eAliveCount >= aAliveCount and eAliveCoreCount >= aAliveCoreCount
        )
    then
        return BOT_MODE_DESIRE_NONE
    end

    local botTarget = bot:GetAttackTarget()
    if J.IsValidBuilding(botTarget)
    and not string.find(botTarget:GetUnitName(), 'tower1')
    and not string.find(botTarget:GetUnitName(), 'tower2')
    then
        if  botTarget:HasModifier('modifier_fountain_glyph')
        and not (aAliveCount >= eAliveCount + 2)
        then
            ShoulNotPushTower = true
            TowerPushCooldown = DotaTime()
            return BOT_MODE_DESIRE_NONE
        end

        if botTarget:HasModifier('modifier_backdoor_protection')
        or botTarget:HasModifier('modifier_backdoor_protection_in_base')
        or botTarget:HasModifier('modifier_backdoor_protection_active')
        then
            return BOT_MODE_DESIRE_NONE
        end
    end

    if bot:WasRecentlyDamagedByTower(3) and Push.IsInDangerWithinTower(bot, 0.4, 5.0)
    then
        return BOT_MODE_DESIRE_NONE
    end

    local hTeleports = GetIncomingTeleports()
    local nTPCount = 0
    for _, tp in pairs(hTeleports) do
        if tp ~= nil
        and J.GetDistance(vEnemyLaneFrontLocation, tp.location) <= 1600
        and Push.IsEnemyTP(tp.playerid)
        then
            nTPCount = nTPCount + 1
        end
    end

    if nTPCount > 0 then
        local nInRangeAlly__ = J.GetAlliesNearLoc(vEnemyLaneFrontLocation, 1600)
        local nInRangeEnemy__ = J.GetEnemiesNearLoc(vEnemyLaneFrontLocation, 1600)
        if (#nInRangeAlly__ < #nInRangeEnemy__ + nTPCount)
        then
            ShouldNotPushLane = true
            LanePushCooldown = DotaTime()
            LanePush = lane
            return BOT_MODE_DESIRE_NONE
        end
    end

    -- General Push
    if (not J.IsCore(bot) and (Push.WhichLaneToPush(bot) == lane))
    or (J.IsCore(bot) and ((J.IsLateGame() and (Push.WhichLaneToPush(bot) == lane)) or (J.IsEarlyGame() or J.IsMidGame())))
    then
        if eAliveCount == 0
        or aAliveCoreCount >= eAliveCoreCount
        or (aAliveCoreCount >= 1 and aAliveCount >= eAliveCount + 2)
        then
            if J.DoesTeamHaveAegis()
            then
                local aegis = 1.3
                nPushDesire = nPushDesire * aegis
            end

            if aAliveCount >= eAliveCount
            and J.GetAverageLevel(GetTeam()) >= 12
            then
                -- nPushDesire = nPushDesire * RemapValClamped(allyKills / enemyKills, 1, 2, 1, 2)
                nPushDesire = nPushDesire + RemapValClamped(allyKills / enemyKills, 1, 2, 0.0, 1)
            end

            bot.laneToPush = lane
            return Clamp(nPushDesire, 0, nMaxDesire)
        end
    end

    return BOT_MODE_DESIRE_NONE
end

local TeamLocation = {}
function Push.WhichLaneToPush(bot)
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if member ~= nil and member:IsAlive() then
            TeamLocation[member:GetPlayerID()] = member:GetLocation()
        end
    end

    local distanceToTop = 0
    local distanceToMid = 0
    local distanceToBot = 0

    for i, id in pairs(GetTeamPlayers(GetTeam()))
    do
        if TeamLocation[id] ~= nil and i <= 3
        then
            if IsHeroAlive(id)
            then
                distanceToTop = math.max(distanceToTop, #(GetLaneFrontLocation(GetTeam(),LANE_TOP, 0) - TeamLocation[id]))
                distanceToMid = math.max(distanceToMid, #(GetLaneFrontLocation(GetTeam(),LANE_MID, 0) - TeamLocation[id]))
                distanceToBot = math.max(distanceToBot, #(GetLaneFrontLocation(GetTeam(),LANE_BOT, 0) - TeamLocation[id]))
            end
        end
    end

    if  distanceToTop < distanceToMid
    and distanceToTop < distanceToBot
    then
        return LANE_TOP
    end

    if  distanceToMid < distanceToTop
    and distanceToMid < distanceToBot
    then
        return LANE_MID
    end

    if  distanceToBot < distanceToTop
    and distanceToBot < distanceToMid
    then
        return LANE_BOT
    end

    return nil
end

function Push.PushThink(bot, lane)
    if J.CanNotUseAction(bot) then return end

    local botAttackRange = bot:GetAttackRange()
    local fDeltaFromFront = (Min(J.GetHP(bot), 0.7) * 1000 - 700) + RemapValClamped(botAttackRange, 300, 700, 0, -600)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)
    local targetLoc = GetLaneFrontLocation(GetTeam(), lane, fDeltaFromFront)

    local nEnemyAncient = GetAncient(GetOpposingTeam())
    if  GetUnitToUnitDistance(bot, nEnemyAncient) < 1600
    and J.CanBeAttacked(nEnemyAncient)
    then
        bot:Action_AttackUnit(nEnemyAncient, true)
        return
    end

    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 800)
    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1000)
    if #nAllyHeroes > #nEnemyHeroes
    and J.IsValidHero(nEnemyHeroes[1]) and J.CanBeAttacked(nEnemyHeroes[1])
    and (nEnemyHeroes[1]:GetAttackTarget() == bot or J.IsChasingTarget(nEnemyHeroes[1], bot))
    then
        bot:Action_AttackUnit(nEnemyHeroes[1], true)
        return
    end

    local nCreeps = bot:GetNearbyLaneCreeps(math.min(700 + botAttackRange, 1600), true)
    if J.IsCore(bot) then
        nCreeps = bot:GetNearbyCreeps(math.min(700 + botAttackRange, 1600), true)
    end
    nCreeps = Push.GetSpecialUnitsNearby(bot, nCreeps, math.min(700 + botAttackRange, 1600))
    for _, creep in pairs(nCreeps) do
        if J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and not J.IsTormentor(creep)
        and not J.IsRoshan(creep)
        then
            bot:Action_AttackUnit(creep, true)
            return
        end
    end

    local nBarracks = bot:GetNearbyBarracks(math.min(700 + botAttackRange, 1600), true)
    if  nBarracks ~= nil and #nBarracks > 0
    and Push.CanBeAttacked(nBarracks[1])
    then
        bot:Action_AttackUnit(nBarracks[1], true)
        return
    end

    if  nEnemyTowers ~= nil and #nEnemyTowers > 0
    and Push.CanBeAttacked(nEnemyTowers[1])
    then
        bot:Action_AttackUnit(nEnemyTowers[1], true)
        return
    end

    local sEnemyTowers = bot:GetNearbyFillers(math.min(700 + botAttackRange, 1600), true)
    if  sEnemyTowers ~= nil and #sEnemyTowers > 0
    and Push.CanBeAttacked(sEnemyTowers[1])
    then
        bot:Action_AttackUnit(sEnemyTowers[1], true)
        return
    end

    bot:Action_MoveToLocation(targetLoc)
end

function Push.CanBeAttacked(building)
    if  building ~= nil
    and building:CanBeSeen()
    and not building:IsInvulnerable()
    then
        return true
    end

    return false
end

function Push.IsEnemyTP(nID)
    for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
        if id == nID then
            return true
        end
    end

    return false
end

function Push.IsInDangerWithinTower(hUnit, fThreshold, fDuration)
    local totalDamage = 0
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
        if J.IsValid(enemy)
        and J.IsInRange(hUnit, enemy, 1600)
        and (enemy:GetAttackTarget() == hUnit or J.IsChasingTarget(enemy, hUnit)) then
            totalDamage = totalDamage + hUnit:GetActualIncomingDamage(enemy:GetAttackDamage() * enemy:GetAttackSpeed() * fDuration, DAMAGE_TYPE_PHYSICAL)
        end
    end

    local hUnitHealth = hUnit:GetHealth()
    return (totalDamage / hUnitHealth * 1.2) > fThreshold
end

function Push.GetSpecialUnitsNearby(bot, hUnitList, nRadius)
    local hCreepList = hUnitList
    for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES)) do
        if unit ~= nil and unit:CanBeSeen() and J.IsInRange(bot, unit, nRadius) then
            local sUnitName = unit:GetUnitName()
            if string.find(sUnitName, 'invoker_forge_spirit')
            or string.find(sUnitName, 'lycan_wolf')
            or string.find(sUnitName, 'eidolon')
            or string.find(sUnitName, 'beastmaster_boar')
            or string.find(sUnitName, 'beastmaster_greater_boar')
            or string.find(sUnitName, 'furion_treant')
            or string.find(sUnitName, 'broodmother_spiderling')
            or string.find(sUnitName, 'skeleton_warrior')
            or string.find(sUnitName, 'warlock_golem')
            or unit:HasModifier('modifier_dominated')
            or unit:HasModifier('modifier_chen_holy_persuasion')
            then
                table.insert(hCreepList, unit)
            end
        end
    end

    return hCreepList
end

local function IsValidAbility(hAbility)
    if hAbility == nil
	or hAbility:IsNull()
	or hAbility:GetName() == ''
	or hAbility:IsPassive()
	or hAbility:IsHidden()
	or not hAbility:IsTrained()
	or not hAbility:IsActivated()
	then
		return false
	end

	return true
end

-- try, tentative
local hItemList = {
    'item_black_king_bar',
    'item_refresher'
}
-- do k,v
local hAbilityList = {
    ['ncp_dota_hero_alchemist'] = {'alchemist_chemical_rage'},
    ['ncp_dota_hero_axe'] = {'axe_culling_blade'},
    ['ncp_dota_hero_bristleback'] = {'bristleback_bristleback'},
    ['ncp_dota_hero_centaur'] = {'centaur_stampede'},
    ['ncp_dota_hero_chaos_knight'] = {'chaos_knight_phantasm'},
    ['ncp_dota_hero_dawnbreaker'] = {'dawnbreaker_solar_guardian'},
    ['ncp_dota_hero_doom_bringer'] = {'doom_bringer_doom'},
    ['ncp_dota_hero_dragon_knight'] = {'dragon_knight_elder_dragon_form'},
    ['ncp_dota_hero_earth_spirit'] = {'earth_spirit_magnetize'},
    ['ncp_dota_hero_earthshaker'] = {'earthshaker_echo_slam'},
    ['ncp_dota_hero_elder_titan'] = {'elder_titan_earth_splitter'},
    --huskar
    ['ncp_dota_hero_kunkka'] = {'kunkka_ghostship'},
    ['ncp_dota_hero_legion_commander'] = {'legion_commander_duel'},
    ['ncp_dota_hero_life_stealer'] = {'life_stealer_rage'},
    ['ncp_dota_hero_mars'] = {'mars_arena_of_blood'},
    ['ncp_dota_hero_night_stalker'] = {'night_stalker_darkness'},
    ['ncp_dota_hero_omniknight'] = {'omniknight_guardian_angel'},
    ['ncp_dota_hero_primal_beast'] = {'primal_beast_pulverize'},
    --pudge, slardar, spirit breaker
    ['ncp_dota_hero_sven'] = {'sven_gods_strength'},
    ['ncp_dota_hero_tidehunter'] = {'tidehunter_ravage'},
    --timbersaw, tiny
    ['ncp_dota_hero_treant'] = {'treant_overgrowth'},
    --tusk
    ['ncp_dota_hero_undying'] = {'undying_tombstone', 'undying_flesh_golem'},
    ['ncp_dota_hero_skeleton_king'] = {'skeleton_king_reincarnation'},

    ['npc_dota_hero_antimage'] = {'antimage_mana_void'},
    --arc
    ['npc_dota_hero_bloodseeker'] = {'bloodseeker_rupture'},
    --bounty
    ['npc_dota_hero_clinkz'] = {'clinkz_burning_barrage'},
    --drow ranger, ember
    ['npc_dota_hero_faceless_void'] = {'faceless_void_chronosphere'},
    ['npc_dota_hero_gyrocopter'] = {'gyrocopter_flak_cannon'},
    ['npc_dota_hero_hoodwink'] = {'hoodwink_sharpshooter'},
    ['npc_dota_hero_juggernaut'] = {'juggernaut_omni_slash'},
    --kez
    ['npc_dota_hero_luna'] = {'luna_eclipse'},
    ['npc_dota_hero_medusa'] = {'medusa_stone_gaze'},
    --meepo
    ['npc_dota_hero_monkey_king'] = {'monkey_king_wukongs_command'},
    --morphling
    ['npc_dota_hero_naga_siren'] = {'naga_siren_song_of_the_siren'},
    --phantom ass, phantom lance
    ['npc_dota_hero_razor'] = {'razor_static_link'},
    --riki
    ['npc_dota_hero_nevermore'] = {'nevermore_requiem'},
    ['npc_dota_hero_slark'] = {'slark_shadow_dance'},
    --sniper
    ['npc_dota_hero_spectre'] = {'spectre_haunt_single', 'spectre_haunt'},
    -- ta
    ['npc_dota_hero_terrorblade'] = {'terrorblade_metamorphosis', 'terrorblade_sunder'},
    ['npc_dota_hero_troll_warlord'] = {'troll_warlord_battle_trance'},
    ['npc_dota_hero_ursa'] = {'ursa_enrage'},
    ['npc_dota_hero_viper'] = {'viper_viper_strike'},
    ['npc_dota_hero_weaver'] = {'weaver_time_lapse'},

    ['npc_dota_hero_ancient_apparition'] = {'ancient_apparition_ice_blast'},
    ['npc_dota_hero_crystal_maiden'] = {'crystal_maiden_freezing_field'},
    ['npc_dota_hero_death_prophet'] = {'death_prophet_exorcism'},
    ['npc_dota_hero_disruptor'] = {'disruptor_static_storm'},
    --enchantress
    ['npc_dota_hero_grimstroke'] = {'grimstroke_dark_portrait', 'grimstroke_soul_chain'},
    ['npc_dota_hero_jakiro'] = {'jakiro_macropyre'},
    --kotl, leshrac
    ['npc_dota_hero_lich'] = {'lich_chain_frost'},
    ['npc_dota_hero_lina'] = {'lina_laguna_blade'},
    ['npc_dota_hero_lion'] = {'lion_finger_of_death'},
    ['npc_dota_hero_muerta'] = {'muerta_pierce_the_veil'},
    --np
    ['npc_dota_hero_necrolyte'] = {'necrolyte_ghost_shroud', 'necrolyte_reapers_scythe'},
    ['npc_dota_hero_oracle'] = {'oracle_false_promise'},
    ['npc_dota_hero_obsidian_destroyer'] = {'obsidian_destroyer_sanity_eclipse'},
    ['npc_dota_hero_puck'] = {'puck_dream_coil'},
    ['npc_dota_hero_pugna'] = {'pugna_life_drain'},
    ['npc_dota_hero_queenofpain'] = {'queenofpain_sonic_wave'},
    ['npc_dota_hero_ringmaster'] = {'ringmaster_wheel'},
    --rubick
    ['npc_dota_hero_shadow_demon'] = {'shadow_demon_disruption', 'shadow_demon_demonic_cleanse', 'shadow_demon_demonic_purge'},
    ['npc_dota_hero_shadow_shaman'] = {'shadow_shaman_mass_serpent_ward'},
    ['npc_dota_hero_silencer'] = {'silencer_global_silence'},
    ['npc_dota_hero_skywrath_mage'] = {'skywrath_mage_mystic_flare'},
    --storm, tinker
    ['npc_dota_hero_warlock'] = {'warlock_fatal_bonds', 'warlock_golem'},
    ['npc_dota_hero_witch_doctor'] = {'witch_doctor_voodoo_switcheroo', 'witch_doctor_death_ward'},
    ['npc_dota_hero_zuus'] = {'zuus_thundergods_wrath'},

    ['npc_dota_hero_abaddon'] = {'abaddon_borrowed_time'},
    ['npc_dota_hero_bane'] = {'bane_fiends_grip'},
    ['npc_dota_hero_batrider'] = {'batrider_flaming_lasso'},
    ['npc_dota_hero_beastmaster'] = {'beastmaster_primal_roar'},
    ['npc_dota_hero_brewmaster'] = {'brewmaster_primal_split'},
    ['npc_dota_hero_broodmother'] = {'broodmother_insatiable_hunger'},
    ['npc_dota_hero_chen'] = {'chen_hand_of_god'},
    --clockwerk
    ['npc_dota_hero_dark_seer'] = {'dark_seer_wall_of_replica'},
    ['npc_dota_hero_dark_willow'] = {'dark_willow_terrorize'},
    --dazzle
    ['npc_dota_hero_enigma'] = {'enigma_black_hole'},
    --invoker, io, ld
    ['npc_dota_hero_lycan'] = {'lycan_shapeshift'},
    ['npc_dota_hero_magnataur'] = {'magnataur_reverse_polarity'},
    ['npc_dota_hero_marci'] = {'marci_unleash'},
    --mirana, nyx
    ['npc_dota_hero_pangolier'] = {'pangolier_gyroshell'},
    ['npc_dota_hero_phoenix'] = {'phoenix_supernova'},
    ['npc_dota_hero_sand_king'] = {'sandking_epicenter'},
    ['npc_dota_hero_snapfire'] = {'snapfire_mortimer_kisses'},
    --techies
    ['npc_dota_hero_vengefulspirit'] = {'vengefulspirit_nether_swap'},
    ['npc_dota_hero_venomancer'] = {'venomancer_noxious_plague'},
    --visage, void spirit
    ['npc_dota_hero_windrunner'] = {'windrunner_focusfire'},
    ['npc_dota_hero_winter_wyvern'] = {'winter_wyvern_cold_embrace', 'winter_wyvern_winters_curse'},
}
function Push.ShouldWaitForImportantItemsSpells(vLocation)
    if J.IsMidGame() or J.IsLateGame() then
        for i = 1, 5 do
            local member = GetTeamMember(i)
            if member ~= nil and member:IsAlive() then
                for _, itemName in pairs(hItemList) do
                    local hItem = J.GetItem(itemName)
                    if hItem ~= nil
                    and (hItem:GetCooldownTimeRemaining() >
                        (GetUnitToLocationDistance(member, vLocation) / member:GetCurrentMovementSpeed())
                    )
                    then
                        return true
                    end
                end
            end
        end

        for i = 1, 5 do
            local member = GetTeamMember(i)
            if member ~= nil then
                local sMemberName = member:GetUnitName()
                local bCore = J.IsCore(member)
                if string.find(sMemberName, 'gyrocopter') and not bCore
                or string.find(sMemberName, 'weaver') and not bCore
                then
                    -- none
                else
                    -- do some mana later
                    if hAbilityList[sMemberName] ~= nil then
                        for _, abilityName in pairs(hAbilityList[sMemberName]) do
                            local hAbility = J.GetAbility(member, abilityName)
                            if IsValidAbility(hAbility)
                            and (hAbility:GetCooldownTimeRemaining() >
                                (GetUnitToLocationDistance(member, vLocation) / member:GetCurrentMovementSpeed())
                            )
                            then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

return Push