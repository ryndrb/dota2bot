local X = {}
local bot = GetBot()

local Hero = require(GetScriptDirectory()..'/FunLib/bot_builds/'..string.gsub(bot:GetUnitName(), 'npc_dota_hero_', ''))
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local nTalentBuildList = J.Skill.GetTalentBuild(Hero.TalentBuild[sRole][RandomInt(1, #Hero.TalentBuild[sRole])])
local nAbilityBuildList = Hero.AbilityBuild[sRole][RandomInt(1, #Hero.AbilityBuild[sRole])]

local sRand = RandomInt(1, #Hero.BuyList[sRole])
X['sBuyList'] = Hero.BuyList[sRole][sRand]
X['sSellList'] = Hero.SellList[sRole][sRand]

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

-- function X.ConsiderDevourAbility(DevouredAbility)
--     if DevouredAbility:IsPassive()
--     or not DevouredAbility:IsFullyCastable()
--     then
--         return BOT_ACTION_DESIRE_NONE, nil, ''
--     end

--     local nCastRange = 0
--     local nRadius = 0
--     local nDamage = 0

--     -- -- Tornado
--     -- if DevouredAbility:GetName() == 'enraged_wildkin_tornado'
--     -- -- Hurricane
--     -- if DevouredAbility:GetName() == 'enraged_wildkin_hurricane'

--     -- -- Thunder Clap
--     -- if DevouredAbility:GetName() == 'polar_furbolg_ursa_warrior_thunder_clap'

--     -- -- Ogre Smash!
--     -- if DevouredAbility:GetName() == 'ogre_bruiser_ogre_smash'
--     -- -- Ice Armor
--     -- if DevouredAbility:GetName() == 'ogre_magi_frost_armor'

--     -- -- Ensnare
--     -- if DevouredAbility:GetName() == 'dark_troll_warlord_ensnare'
--     -- -- Raise Dead
--     -- if DevouredAbility:GetName() == 'dark_troll_warlord_raise_dead'

--     -- -- Hurl Boulder
--     -- if DevouredAbility:GetName() == 'mud_golem_hurl_boulder'

--     -- -- Slam
--     -- if DevouredAbility:GetName() == 'big_thunder_lizard_slam'
--     -- -- Frenzy
--     -- if DevouredAbility:GetName() == 'big_thunder_lizard_frenzy'

--     -- -- Ice Fire Bomb
--     -- if DevouredAbility:GetName() == 'ice_shaman_incendiary_bomb'

--     -- -- Fireball
--     -- if DevouredAbility:GetName() == 'black_dragon_fireball'

--     -- -- Seed Shot
--     -- if DevouredAbility:GetName() == 'warpine_raider_seed_shot'

--     -- Vex
--     if DevouredAbility:GetName() == 'fel_beast_haunt'
--     then
--         nCastRange = 600

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.CanCastOnTargetAdvanced(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--             then
--                 local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                 local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--                 end
--             end
--         end

--         if  J.IsRetreating(bot)
--         and bot:GetActiveModeDesire() > 0.5
--         then
--             local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--             for _, enemyHero in pairs(nInRangeEnemy)
--             do
--                 if  J.IsValidHero(enemyHero)
--                 and J.CanCastOnNonMagicImmune(enemyHero)
--                 and J.CanCastOnTargetAdvanced(enemyHero)
--                 and J.IsChasingTarget(enemyHero, bot)
--                 and not J.IsSuspiciousIllusion(enemyHero)
--                 and not J.IsDisabled(enemyHero)
--                 and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--                 and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--                 then
--                     local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                     local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                     if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                     and ((#nTargetInRangeAlly > #nInRangeAlly)
--                         or bot:WasRecentlyDamagedByAnyHero(2))
--                     then
--                         return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                     end
--                 end
--             end
--         end
--     end

--     -- Take Off
--     if DevouredAbility:GetName() == 'harpy_scout_take_off'
--     then
--         if J.IsStuck(bot)
--         then
--             if DevouredAbility:GetToggleState() == false
--             then
--                 return BOT_ACTION_DESIRE_HIGH
--             else
--                 return BOT_ACTION_DESIRE_NONE
--             end
--         end

--         if DevouredAbility:GetToggleState() == true
--         then
--             return BOT_ACTION_DESIRE_HIGH
--         end
--     end

--     -- Chain Lightning
--     if DevouredAbility:GetName() == 'harpy_storm_chain_lightning'
--     then
--         nCastRange = J.GetProperCastRange(false, bot, DevouredAbility:GetCastRange())
--         nDamage = DevouredAbility:GetSpecialValueInt('initial_damage')
--         local nJumpDist = DevouredAbility:GetSpecialValueInt('jump_range')

--         local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nEnemyHeroes)
--         do
--             if  J.IsValidHero(enemyHero)
--             and J.CanCastOnNonMagicImmune(enemyHero)
--             and J.CanCastOnTargetAdvanced(enemyHero)
--             and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
--             and not J.IsSuspiciousIllusion(enemyHero)
--             and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
--             and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
--             and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
--             and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
--             then
--                 return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--             end
--         end

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.CanCastOnTargetAdvanced(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
--             and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
--             then
--                 local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--             for _, enemyHero in pairs(nInRangeEnemy)
--             do
--                 if  J.IsValidHero(enemyHero)
--                 and J.CanCastOnNonMagicImmune(enemyHero)
--                 and J.IsChasingTarget(enemyHero, bot)
--                 and not J.IsSuspiciousIllusion(enemyHero)
--                 and not J.IsDisabled(enemyHero)
--                 then
--                     local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                     local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                     if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                     and ((#nTargetInRangeAlly > #nInRangeAlly)
--                         or bot:WasRecentlyDamagedByAnyHero(2))
--                     then
--                         return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                     end
--                 end
--             end
--         end

--         if  J.IsFarming(bot)
--         and J.GetManaAfter(DevouredAbility:GetManaCost()) * bot:GetMana() > Doom:GetManaCost() * 2
--         then
--             local nCreeps = bot:GetNearbyCreeps(1600, true)
--             if  nCreeps ~= nil
--             and ((#nCreeps >= 3)
--                 or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
--             and J.IsAttacking(bot)
--             then
--                 for _, creep in pairs(nCreeps)
--                 do
--                     if  J.IsValid(creep)
--                     and J.CanBeAttacked(creep)
--                     then
--                         local nCreepCountAround = J.GetNearbyAroundLocationUnitCount(true, false, nJumpDist, creep:GetLocation())
--                         if nCreepCountAround >= 2
--                         then
--                             return BOT_ACTION_DESIRE_HIGH, creep, 'unit'
--                         end
--                     end
--                 end
--             end
--         end

--         if J.IsDoingRoshan(bot)
--         then
--             -- Remove Spell Block
--             if  J.IsRoshan(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--             end
--         end

--         if J.IsDoingTormentor(bot)
--         then
--             if  J.IsTormentor(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--             end
--         end
--     end

--     -- War Stomp
--     if DevouredAbility:GetName() == 'centaur_khan_war_stomp'
--     then
--         nDamage = DevouredAbility:GetAbilityDamage()
--         nRadius = DevouredAbility:GetSpecialValueInt('radius')

--         local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nEnemyHeroes)
--         do
--             if  J.IsValidHero(enemyHero)
--             and J.CanCastOnNonMagicImmune(enemyHero)
--             and not J.IsSuspiciousIllusion(enemyHero)
--             then
--                 if enemyHero:IsChanneling()
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end

--                 if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
--                 and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
--                 and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
--                 and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
--                 and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
--                 and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--                 and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
--             and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
--             then
--                 local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                 local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--             local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--             if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--             and J.IsValidHero(nInRangeEnemy[1])
--             and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
--             and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
--             and J.IsChasingTarget(nInRangeEnemy[1], bot)
--             and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
--             and not J.IsDisabled(nInRangeEnemy[1])
--             and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nTargetInRangeAlly ~= nil
--                 and ((#nTargetInRangeAlly > #nInRangeAlly)
--                     or (bot:WasRecentlyDamagedByAnyHero(2)))
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsDoingRoshan(bot)
--         then
--             if  J.IsRoshan(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             and not J.IsDisabled(botTarget)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end

--         if J.IsDoingTormentor(bot)
--         then
--             if  J.IsTormentor(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end
--     end

--     -- Intimidate
--     if DevouredAbility:GetName() == 'giant_wolf_intimidate'
--     then
--         nRadius = DevouredAbility:GetSpecialValueInt('radius')

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--             local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--             if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--             and J.IsValidHero(nInRangeEnemy[1])
--             and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
--             and J.IsChasingTarget(nInRangeEnemy[1], bot)
--             and J.IsAttacking(nInRangeEnemy[1])
--             and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
--             and not J.IsDisabled(nInRangeEnemy[1])
--             and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                 if  nTargetInRangeAlly ~= nil
--                 and ((#nTargetInRangeAlly > #nInRangeAlly)
--                     or (bot:WasRecentlyDamagedByAnyHero(1.5)))
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, nil, ''
--                 end
--             end
--         end

--         if J.IsDoingRoshan(bot)
--         then
--             if  J.IsRoshan(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             and not J.IsDisabled(botTarget)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end

--         if J.IsDoingTormentor(bot)
--         then
--             if  J.IsTormentor(botTarget)
--             and J.IsInRange(bot, botTarget, nRadius)
--             and J.IsAttacking(bot)
--             then
--                 return BOT_ACTION_DESIRE_HIGH, nil, ''
--             end
--         end
--     end

--     -- Purge
--     if DevouredAbility:GetName() == 'satyr_trickster_purge'
--     then
--         nCastRange = J.GetProperCastRange(false, bot, DevouredAbility:GetCastRange())

--         if  not bot:IsMagicImmune()
-- 		and not bot:IsInvulnerable()
--         then
--             if J.IsDisabled(bot)
--             or bot:HasModifier('modifier_bounty_hunter_track')
--             -- more here...
--             then
--                 return BOT_ACTION_DESIRE_HIGH, bot, 'unit'
--             end
--         end

--         local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
--         for _, allyHero in pairs(nAllyHeroes)
--         do
--             if  J.IsValidHero(allyHero)
--             and not allyHero:IsMagicImmune()
--             and not allyHero:IsInvulnerable()
--             and not J.IsSuspiciousIllusion(allyHero)
--             then
--                 if J.IsDisabled(allyHero)
--                 or allyHero:HasModifier('modifier_bounty_hunter_track')
--                 -- more here...
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, bot, 'unit'
--                 end
--                 return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit'
--             end
--         end

--         local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--         for _, enemyHero in pairs(nEnemyHeroes)
--         do
--             if  J.IsValidHero(enemyHero)
--             and not J.IsDisabled(enemyHero)
--             and not enemyHero:IsMagicImmune()
--             and not enemyHero:IsInvulnerable()
--             and not J.IsSuspiciousIllusion(enemyHero)
--             then
--                 if enemyHero:HasModifier('modifier_item_satanic_unholy')
--                 or enemyHero:HasModifier('modifier_rune_doubledamage')
--                 -- more here...
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                 end
--             end
--         end

--         if J.IsGoingOnSomeone(bot)
--         then
--             if  J.IsValidTarget(botTarget)
--             and J.CanCastOnNonMagicImmune(botTarget)
--             and J.CanCastOnTargetAdvanced(botTarget)
--             and J.IsInRange(bot, botTarget, nCastRange)
--             and J.IsChasingTarget(bot, botTarget)
--             and botTarget:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
--             and not J.IsSuspiciousIllusion(botTarget)
--             and not J.IsDisabled(botTarget)
--             and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
--             then
--                 local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
--                 local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

--                 if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
--                 and #nInRangeAlly >= #nInRangeEnemy
--                 then
--                     return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
--                 end
--             end
--         end

--         if J.IsRetreating(bot)
--         then
--             local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
--             for _, enemyHero in pairs(nInRangeEnemy)
--             do
--                 if  J.IsValidHero(enemyHero)
--                 and J.CanCastOnNonMagicImmune(enemyHero)
--                 and J.CanCastOnTargetAdvanced(enemyHero)
--                 and J.IsChasingTarget(enemyHero, bot)
--                 and not J.IsSuspiciousIllusion(enemyHero)
--                 and not J.IsDisabled(enemyHero)
--                 then
--                     local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
--                     local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

--                     if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
--                     and ((#nTargetInRangeAlly > #nInRangeAlly)
--                         or bot:WasRecentlyDamagedByAnyHero(2))
--                     and enemyHero:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
--                     then
--                         return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
--                     end
--                 end
--             end
--         end
--     end

--     -- -- Mana Burn
--     -- if DevouredAbility:GetName() == 'satyr_soulstealer_mana_burn'
--     -- -- Shock Wave
--     -- if DevouredAbility:GetName() == 'satyr_hellcaller_shockwave'

--     return BOT_ACTION_DESIRE_HIGH, nil, ''
-- end

-- function X.GetRangedOrSiegeCreep(nCreeps, lvl)
-- 	for _, creep in pairs(nCreeps)
-- 	do
-- 		if  J.IsValid(creep)
--         and J.CanBeAttacked(creep)
--         and creep:GetLevel() <= lvl
--         and (J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('ranged', creep))
--         and not J.IsRoshan(creep)
--         and not J.IsTormentor(creep)
-- 		then
-- 			return creep
-- 		end
-- 	end

-- 	return nil
-- end

return X