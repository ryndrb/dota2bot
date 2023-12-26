-- local bot = GetBot()
-- local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

-- function GetDesire()
--     local RetreatDesire = 0
    
--     local BotHealth = bot:GetHealth()
--     local BotMaxHealth = bot:GetMaxHealth()
--     local BotMana = bot:GetMana()
--     local BotMaxMana = bot:GetMaxMana()
    
--     if bot:GetUnitName() == "npc_dota_hero_medusa" then
--         BotHealth = (BotHealth + BotMana)
--         BotMaxHealth = (BotMaxHealth + BotMaxMana)
--     end
    
--     local HealthMissing = (BotMaxHealth - BotHealth)
    
--     local HealthRetreatVal = 1 - BotHealth / BotMaxHealth
--     local RecentlyDamagedVal = 0.15 -- The amount to add if the bot is being attacked by a hero(s)
--     local OutnumberedVal = 0.25 -- Multiplier for every hero that outnumbers the bot's team
--     local OffensivePowerVal = 0.25 -- The amount to add if the enemy has enough raw power to kill the bot
--     local SafeVal = 0.25 -- How much to subtract from the desire to retreat if there are no visible enemy heroes
    
--     local BurstDamageThreshold = BotHealth -- Adjust according to the burst potential of enemy heroes
    
--     if (BotHealth <= (BotMaxHealth * 0.3) or BotMana <= (BotMaxMana * 0.2)) and bot:DistanceFromFountain() < 3500 then
--         UrgentRetreat = true
--     elseif UrgentRetreat and BotHealth > (BotMaxHealth * 0.95) then
--         UrgentRetreat = false
--     end
    
--     if UrgentRetreat then
--         return 0.9
--     end
    
--     RetreatDesire = HealthRetreatVal
    
--     if bot:WasRecentlyDamagedByAnyHero(1) or bot:WasRecentlyDamagedByTower(1) then
--         RetreatDesire = (RetreatDesire + RecentlyDamagedVal)
--     end
    
--     local Allies = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
--     local Enemies = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
--     local EnemyTowers = bot:GetNearbyTowers(1600, true)
    
--     local TrueAllies = FilterHeroes(Allies, false)
--     local TrueEnemies = FilterHeroes(Enemies, true)
    
--     local NearbyEnemies = CountNearbyEnemies(bot, 1600)
    
--     if (NearbyEnemies + (#EnemyTowers * 2)) - #TrueAllies > 0 then
--         local Difference = (#TrueEnemies - #TrueAllies)
--         local OVal = (OutnumberedVal * Difference)
--         RetreatDesire = (RetreatDesire + OVal)
--     end
    
--     local CombinedEnemiesOffensivePower = CombineOffensivePower(TrueEnemies, BurstDamageThreshold)
--     local CombinedAlliesOffensivePower = CombineOffensivePower(TrueAllies, BurstDamageThreshold)
    
--     if CombinedEnemiesOffensivePower > CombinedAlliesOffensivePower and J.IsInTeamFight(bot, 1600) then
--         RetreatDesire = (RetreatDesire + (CombinedEnemiesOffensivePower - CombinedAlliesOffensivePower) * 0.1)
--     end
    
--     if NearbyEnemies == 0 and #EnemyTowers == 0 then
--         RetreatDesire = (RetreatDesire - SafeVal)
--     end

--     if J.IsGoingOnSomeone(bot)
--     and not J.IsInTeamFight(bot, 1600)
--     and bot:GetTarget() ~= nil and bot:GetTarget():IsHero()
--     and not J.CanKillTarget(bot:GetTarget(), bot:GetOffensivePower(), DAMAGE_TYPE_ALL) then
--         RetreatDesire = RetreatDesire + 0.5
--         print(bot:GetUnitName()..": ", RetreatDesire)
--     end
    
--     local ClampedRetreatDesire = Clamp(RetreatDesire, 0.0, 1.0)
--     return ClampedRetreatDesire
-- end

-- -- Helper function to filter out illusions and clones
-- function FilterHeroes(heroes, isEnemy)
--     local filteredHeroes = {}
--     for _, hero in pairs(heroes) do
--         if not IsPossibleIllusion(hero) and not hero:HasModifier("modifier_arc_warden_tempest_double") then
--             table.insert(filteredHeroes, hero)
--         end
--     end
--     return filteredHeroes
-- end

-- -- Helper function to count nearby enemies within a certain range
-- function CountNearbyEnemies(unit, range)
--     local enemyIDs = GetTeamPlayers(GetOpposingTeam())
--     local count = 0
--     for _, enemyID in pairs(enemyIDs) do
--         local lastSeenInfo = GetHeroLastSeenInfo(enemyID)
--         if lastSeenInfo ~= nil and #lastSeenInfo > 0 then
--             local lastSeenLocation = lastSeenInfo[1].location
--             if GetUnitToLocationDistance(unit, lastSeenLocation) <= range then
--                 count = count + 1
--             end
--         end
--     end
--     return count
-- end

-- -- Helper function to combine offensive power of heroes
-- function CombineOffensivePower(heroes, burstDamageThreshold)
--     local combinedPower = 0
--     for _, hero in pairs(heroes) do
--         local heroDamage = hero:GetAttackDamage() + hero:GetPrimaryAttribute() * 1.5
--         if hero:GetAttackTarget() ~= nil and hero:GetAttackTarget():IsHero() then
--             heroDamage = heroDamage + hero:GetAttackTarget():GetHealthRegen()
--         end
--         if hero:GetCurrentActiveAbility() ~= nil then
--             heroDamage = heroDamage + hero:GetCurrentActiveAbility():GetAbilityDamage()
--         end
--         if heroDamage > burstDamageThreshold then
--             combinedPower = combinedPower + 1
--         end
--     end
--     return combinedPower
-- end

-- function IsPossibleIllusion(unit)
-- 	local bot = GetBot()

-- 	--Detect ally illusions
-- 	if unit:HasModifier('modifier_illusion') 
-- 	   or unit:HasModifier('modifier_phantom_lancer_doppelwalk_illusion') or unit:HasModifier('modifier_phantom_lancer_juxtapose_illusion')
--        or unit:HasModifier('modifier_darkseer_wallofreplica_illusion') or unit:HasModifier('modifier_terrorblade_conjureimage')	   
-- 	then
-- 		return true
-- 	else
-- 	   --Detect replicate and wall of replica illusions
-- 	    if GetGameMode() ~= GAMEMODE_MO then
-- 			if unit:GetTeam() ~= bot:GetTeam() then
-- 				local TeamMember = GetTeamPlayers(GetTeam())
-- 				for i = 1, #TeamMember
-- 				do
-- 					local ally = GetTeamMember(i)
-- 					if ally ~= nil and ally:GetUnitName() == unit:GetUnitName() then
-- 						return true
-- 					end
-- 				end
-- 			end
-- 		end
-- 		return false
-- 	end
-- end