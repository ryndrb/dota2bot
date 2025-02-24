-- Action_ClearActions( bStop )

-- Clear action queue and return to idle and optionally stop in place with bStop true

-- Action_MoveToLocation( vLocation )
-- ActionPush_MoveToLocation( vLocation )
-- ActionQueue_MoveToLocation( vLocation )

-- Command a bot to move to the specified location, this is not a precision move
-- Action_MoveDirectly( vLocation )
-- ActionPush_MoveDirectly( vLocation )
-- ActionQueue_MoveDirectly( vLocation )

-- Command a bot to move to the specified location, bypassing the bot pathfinder. Identical to a user's right-click.
-- Action_MovePath( tWaypoints )
-- ActionPush_MovePath( tWaypoints )
-- ActionQueue_MovePath( tWaypoints )

-- Command a bot to move along the specified path.
-- Action_MoveToUnit( hUnit )
-- ActionPush_MoveToUnit( hUnit )
-- ActionQueue_MoveToUnit( hUnit )

-- Command a bot to move to the specified unit, this will continue to follow the unit
-- Action_AttackUnit( hUnit, bOnce )
-- ActionPush_AttackUnit( hUnit, bOnce )
-- ActionQueue_AttackUnit( hUnit, bOnce )

-- Tell a unit to attack a unit with an option bool to stop after one attack if true
-- Action_AttackMove( vLocation )
-- ActionPush_AttackMove( vLocation )
-- ActionQueue_AttackMove( vLocation )

-- Tell a unit to attack-move a location.
-- Action_UseAbility( hAbility )
-- ActionPush_UseAbility( hAbility )
-- ActionQueue_UseAbility( hAbility )

-- Command a bot to use a non-targeted ability or item
-- Action_UseAbilityOnEntity( hAbility, hTarget )
-- ActionPush_UseAbilityOnEntity( hAbility, hTarget )
-- ActionQueue_UseAbilityOnEntity( hAbility, hTarget )

-- Command a bot to use a unit targeted ability or item on the specified target unit
-- Action_UseAbilityOnLocation( hAbility, vLocation )
-- ActionPush_UseAbilityOnLocation( hAbility, vLocation )
-- ActionQueue_UseAbilityOnLocation( hAbility, vLocation )

-- Command a bot to use a ground targeted ability or item on the specified location
-- Action_UseAbilityOnTree( hAbility, iTree )
-- ActionPush_UseAbilityOnTree( hAbility, iTree )
-- ActionQueue_UseAbilityOnTree( hAbility, iTree )

-- Command a bot to use a tree targeted ability or item on the specified tree
-- Action_PickUpRune( nRune )
-- ActionPush_PickUpRune( nRune )
-- ActionQueue_PickUpRune( nRune )

-- Command a hero to pick up the rune at the specified rune location.
-- Action_PickUpItem( hItem )
-- ActionPush_PickUpItem( hItem )
-- ActionQueue_PickUpItem( hItem )

-- Command a bot to pick up the specified item
-- Action_DropItem( hItem, vLocation )
-- ActionPush_DropItem( hItem, vLocation )
-- ActionQueue_DropItem( hItem, vLocation )

-- Command a bot to drop the specified item and the provided location
-- Action_UseShrine( hShrine )
-- ActionPush_UseShrine( hShrine )
-- ActionQueue_UseShrine( hShrine )

-- Command a bot to use the specified shrine
-- Action_Delay( fDelay )
-- ActionPush_Delay( fDelay )
-- ActionQueue_Delay( fDelay )

-- Command a bot to delay for the specified amount of time.

-- int ActionImmediate_PurchaseItem ( sItemName )

-- Command a bot to purchase the specified item. Item names can be found here.
-- ActionImmediate_SellItem( hItem )

-- Command a bot to sell the specified item
local o_ActionImmediate_SellItem = CDOTA_Bot_Script.ActionImmediate_SellItem
function CDOTA_Bot_Script:ActionImmediate_SellItem(hItem)
    if hItem == nil then
        if self:DistanceFromSecretShop() <= 500 then
            self.secret_shop_succesful = false
        end
        print('Trace: ', debug.traceback())
        return
    else
        if self:DistanceFromSecretShop() <= 500 then
            self.secret_shop_succesful = true
        end
        return o_ActionImmediate_SellItem(self, hItem)
    end
end

-- ActionImmediate_DisassembleItem( hItem )

-- Command a bot to disassemble the specified item
-- ActionImmediate_SetItemCombineLock( hItem, bLocked )

-- Command a bot to lock or unlock combining of the specified item
-- ActionImmediate_SwapItems( index1, index2 )

-- Command a bot to swap the items in index1 and index2 in their inventory. Indices are zero based with 0-5 corresponding to inventory, 6-8 are backpack and 9-15 are stash
-- ActionImmediate_Courier( hCourier, nAction )

-- Command the courier specified by hCourier to perform one of the courier Actions.
-- ActionImmediate_Buyback()

-- Tell a hero to buy back from death.
-- ActionImmediate_Glyph()

-- Tell a hero to use Glyph.
-- ActionImmediate_LevelAbility ( sAbilityName )

-- Command a bot to level an ability or a talent. Ability and talent names can be found here
-- ActionImmediate_Chat( sMessage, bAllChat )

-- Have a bot say something in team chat, bAllChat true to say to all chat instead
-- ActionImmediate_Ping( fXCoord, fYCoord, bNormalPing )

-- Command a bot to ping the specified coordinates with bNormalPing setting the ping type

-- int GetCurrentActionType ()

-- Get the type of the currently active Action.
-- int NumQueuedActions()

-- Get number of actions in the action queue.
-- int GetQueuedActionType( nAction )

-- Get the type of the specified queued action.

-- bool IsBot()

-- Returns whether the unit is a bot (otherwise they are a human).
-- int GetDifficulty()

-- Gets the difficulty level of this bot.
-- string GetUnitName()

-- Gets the name of the unit. Note that this is the under-the-hood name, not the normal (localized) name that you'd see for the unit.
local o_GetUnitName = CDOTA_Bot_Script.GetUnitName
function CDOTA_Bot_Script:GetUnitName()
    if self ~= nil and self:CanBeSeen() and string.find(o_GetUnitName(self), 'lone_druid_bear') then
        return 'npc_dota_hero_lone_druid_bear'
    end
    return o_GetUnitName(self)
end

-- int GetPlayerID()

-- Gets the Player ID of the unit, used in functions that refer to a player rather than a specific unit.
-- int GetTeam()

-- Gets team to which this unit belongs.
-- bool IsHero()

-- Returns whether the unit is a hero.
-- bool IsIllusion()

-- Returns whether the unit is an illusion. Always returns false on enemies.
-- bool IsCreep()

-- Returns whether the unit is a creep.
-- bool IsAncientCreep()

-- Returns whether the unit is an ancient creep.
-- bool IsBuilding()

-- Returns whether the unit is a building. This includes towers, barracks, filler buildings, and the ancient.
-- bool IsTower()

-- Returns whether the unit is a tower.
-- bool IsFort()

-- Returns whether the unit is the ancient.

-- bool CanBeSeen()

-- Check if a unit can currently be seen by your team.

-- int GetActiveMode()

-- Get the bots currently active mode. This may not track modes in complete takeover bots.
-- float GetActiveModeDesire()

-- Gets the desire of the currently active mode.

-- int GetHealth()

-- Gets the health of the unit.
local o_GetHealth = CDOTA_Bot_Script.GetHealth
function CDOTA_Bot_Script:GetHealth()
    if self ~= nil and (self:GetUnitName() == 'npc_dota_hero_medusa')
    then
        local nHealth = o_GetHealth(self) + self:GetMana()
        return nHealth
    end
    return o_GetHealth(self)
end

-- int GetMaxHealth()

-- Gets the maximum health of the specified unit.
local o_GetMaxHealth = CDOTA_Bot_Script.GetMaxHealth
function CDOTA_Bot_Script:GetMaxHealth()
    if self ~= nil and (self:GetUnitName() == 'npc_dota_hero_medusa')
    then
        local nHealth = o_GetMaxHealth(self) + self:GetMaxMana()
        return nHealth
    end
    return o_GetMaxHealth(self)
end

-- int GetHealthRegen()

-- Gets the current health regen per second of the unit.
-- int GetMana()

-- Gets the current mana of the unit.
local o_GetMana = CDOTA_Bot_Script.GetMana
function CDOTA_Bot_Script:GetMana()
    if self ~= nil and (self:GetUnitName() == 'npc_dota_hero_huskar')
    then
        return 0
    end
    return o_GetMana(self)
end

-- int GetMaxMana()

-- Gets the maximum mana of the unit.
local o_GetMaxMana = CDOTA_Bot_Script.GetMaxMana
function CDOTA_Bot_Script:GetMaxMana()
    if self ~= nil and (self:GetUnitName() == 'npc_dota_hero_huskar')
    then
        return 0
    end
    return o_GetMaxMana(self)
end

-- int GetManaRegen()

-- Gets the current mana regen of the unit.

-- int GetBaseMovementSpeed()

-- Gets the base movement speed of the unit.
-- int GetCurrentMovementSpeed()

-- Gets the current movement speed (base + modifiers) of the unit.

-- bool IsAlive()

-- Returns true if the unit is alive.
-- float GetRespawnTime()

-- Returns the number of seconds remaining for the unit to respawn. Returns -1.0 for non-heroes.
-- bool HasBuyback()

-- Returns true if the unit has buyback available. Will return false for enemies or non-heroes.
-- int GetBuybackCost()

-- Returns the current gold cost of buyback. Will return -1 for enemies or non-heroes.
-- float GetBuybackCooldown()

-- Returns the current cooldown for buyback. Will return -1.0 for enemies or non-heroes.
-- float GetRemainingLifespan()

-- Returns the remaining lifespan in seconds of units with limited lifespans.

-- float GetBaseDamage()

-- Returns the average base damage of the unit.
-- float GetBaseDamageVariance()

-- Returns the +/- variance in the base damage of the unit.
-- float GetAttackDamage()

-- Returns actual attack damage (with bonuses) of the unit.
-- int GetAttackRange()

-- Returns the range at which the unit can attack another unit.
-- int GetAttackSpeed()

-- Returns the attack speed value of the unit.
-- float GetSecondsPerAttack()

-- Returns the number of seconds per attack (including backswing) of the unit.
-- float GetAttackPoint()

-- Returns the point in the animation where a unit will execute the attack.
-- float GetLastAttackTime()

-- Returns the time that the unit last executed an attack.
-- hUnit GetAttackTarget()

-- Returns a the attack target of the unit.
-- int GetAcquisitionRange()

-- Returns the range at which this unit will attack a target.
-- int GetAttackProjectileSpeed()

-- Returns the speed of the unit's attack projectile.

-- float GetActualIncomingDamage( nDamage, nDamageType )

-- Gets the incoming damage value after reductions depending on damage type.
-- float GetAttackCombatProficiency( hTarget )

-- Gets the damage multiplier when attacking the specified target.
-- float GetDefendCombatProficiency( hAttacker )

-- Gets the damage multiplier when being attacked by the specified attacker.

-- float GetSpellAmp()

-- Gets the spell amplification debuff percentage of this unit.
-- float GetArmor()

-- Gets the armor of this unit.
-- float GetMagicResist()

-- Gets the magic resist value of this unit.
-- float GetEvasion()

-- Gets the evasion percentage of this unit.

-- int GetPrimaryAttribute()

-- Gets the primary stat of this unit.
-- int GetAttributeValue( nAttrib )

-- Gets the value of the specified stat. Returns -1 for non-heroes.

-- int GetBountyXP()

-- Gets the XP bounty value for killing this unit.
-- int GetBountyGoldMin()

-- Gets the minimum gold bounty value for killing this unit.
-- int GetBountyGoldMax()

-- Gets the maximum gold bounty value for killing this unit.

-- int GetXPNeededToLevel()

-- Gets the amount of XP needed for this unit to gain a level. Returns -1 for non-heroes.
-- int GetAbilityPoints()

-- Get the number of ability points available to this bot.
-- int GetLevel()

-- Gets the level of this unit.

-- int GetGold()

-- Gets the current gold amount for this unit.
-- int GetNetWorth()

-- Gets the current total net worth for this unit.
-- int GetStashValue()

-- Gets the current value of all items in this unit's stash.
-- int GetCourierValue()

-- Gets the current value of all items on couriers that this unit owns.

-- int GetLastHits()

-- Gets the current last hit count for this unit.
-- int GetDenies()

-- Gets the current deny count for this unit.

-- float GetBoundingRadius()

-- Gets the bounding radius of this unit. Used for attack ranges and collision.
-- vector GetLocation()

-- Gets the location of this unit.
-- int GetFacing()

-- Gets the facing of this unit on a 360 degree rotation. (0 - 359). Facing East is 0, North is 90, West is 180, South is 270.
-- bool IsFacingLocation( vLocation, nDegrees )

-- Returns if the unit is facing the specified location, within an nDegrees cone.
-- float GetGroundHeight()

-- Gets ground height of the location of this unit. Note: This call can be very expensive! Use sparingly.
-- vector GetVelocity()

-- Gets the unit's current velocity.

-- int GetDayTimeVisionRange()

-- Gets the unit's vision range during the day.
-- int GetNightTimeVisionRange()

-- Gets the unit's vision range during the night.
-- int GetCurrentVisionRange()

-- Gets the unit's current vision range.

-- int GetHealthRegenPerStr()

-- Returns the health regen per second per point in strength.
-- int GetManaRegenPerInt()

-- Returns the mana regen per second per point in intellect.

-- int GetAnimActivity()

-- Returns the current animation activity the unit is playing.
-- float GetAnimCycle()

-- Returns the amount through the current animation (0.0 - 1.0)

-- hAbility GetAbilityByName( sAbilityName )

-- Gets a handle to the named ability. Ability names can be found in here
-- hAbility GetAbilityInSlot( nAbilitySlot )

-- Gets a handle to ability in the specified slot. Slots range from 0 to 23.
-- hItem GetItemInSlot( nIventorySlot )

-- Gets a handle to item in the specified inventory slot. Slots range from 0 to 16.
-- int FindItemSlot( sItemName )

-- Gets the inventory slot the named item is in. Item names can be found here.
-- int GetItemSlotType( nIventorySlot )

-- Gets the type of the specified inventory slot.

-- bool IsChanneling()

-- Returns whether the unit is currently channeling an ability or item.
-- bool IsUsingAbility()

-- Returns whether the unit's active ability is a UseAbility action. Note that this will be true while a is currently using an ability or item.
-- bool IsCastingAbility()

-- Returns whether the unit is actively casting an ability or item. Does not include movement or backswing.
-- hAbility GetCurrentActiveAbility()

-- Gets a handle to ability that's currently being used.

-- bool IsAttackImmune()

-- Returns whether the unit is immune to attacks.
-- bool IsBlind()

-- Returns whether the unit is blind and will miss all of its attacks.
-- bool IsBlockDisabled()

-- Returns whether the unit is disabled from blocking attacks.
-- bool IsDisarmed()

-- Returns whether the unit is disarmed and unable to attack.
-- bool IsDominated()

-- Returns whether the unit has been dominated.
-- bool IsEvadeDisabled()

-- Returns whether the unit is unable to evade attacks.
-- bool IsHexed()

-- Returns whether the unit is hexed into an adorable animal.
-- bool IsInvisible()

-- Returns whether the unit has an invisibility effect. Note that this does NOT guarantee invisibility to the other team -- if they have detection, they can see you even if IsInvisible() returns true.
-- bool IsInvulnerable()

-- Returns whether the unit is invulnerable to damage.
local o_IsInvulnerable = CDOTA_Bot_Script.IsInvulnerable
function CDOTA_Bot_Script:IsInvulnerable()
    if self ~= nil and self:CanBeSeen() then
        -- some dazzle fix idk, but he moves
        if self == GetBot() and self:HasModifier('modifier_dazzle_nothl_projection_soul_debuff') then
            return false
        end
    end

    return o_IsInvulnerable(self)
end

-- bool IsMagicImmune()

-- Returns whether the unit is magic immune.
local o_IsMagicImmune = CDOTA_Bot_Script.IsMagicImmune
function CDOTA_Bot_Script:IsMagicImmune()
    if self ~= nil and self:CanBeSeen() then
        if o_IsMagicImmune(self)
        or self:HasModifier('modifier_magic_immune')
        or self:HasModifier('modifier_juggernaut_blade_fury')
        or self:HasModifier('modifier_life_stealer_rage')
        or self:HasModifier('modifier_black_king_bar_immune')
        or self:HasModifier('modifier_huskar_life_break_charge')
        or self:HasModifier('modifier_grimstroke_scepter_buff')
        or self:HasModifier('modifier_pangolier_rollup')
        or self:HasModifier('modifier_lion_mana_drain_immunity')
        or self:HasModifier('modifier_dawnbreaker_fire_wreath_magic_immunity_tooltip')
        or self:HasModifier('modifier_rattletrap_cog_immune')
        or self:HasModifier('modifier_legion_commander_press_the_attack_immunity')
        then
            return true
        end
    end

    return false
end

-- bool IsMuted()

-- Returns whether the unit is item muted.
-- bool IsNightmared()

-- Returns whether the unit is having bad dreams.
-- bool IsRooted()

-- Returns whether the unit is rooted in place.
-- bool IsSilenced()

-- Returns whether the unit is silenced and unable to use abilities.
-- bool IsSpeciallyDeniable()

-- Returns whether the unit is deniable by allies due to a debuff.
-- bool IsStunned()

-- Returns whether the unit is stunned.
-- bool IsUnableToMiss()

-- Returns whether the unit will not miss due to evasion or attacking uphill.
-- bool HasScepter()

-- Returns whether the unit has ultimate scepter upgrades.

-- bool WasRecentlyDamagedByAnyHero( fInterval )

-- Returns whether the unit has been damaged by a hero in the specified interval.
-- float TimeSinceDamagedByAnyHero()

-- Returns whether the amount of time passed the unit has been damaged by a hero.
-- bool WasRecentlyDamagedByHero( hUnit, fInterval )

-- Returns whether the unit has been damaged by the specified hero in the specified interval.
-- float TimeSinceDamagedByHero( hUnit )

-- Returns whether the amount of time passed the unit has been damaged by the specified hero.
-- bool WasRecentlyDamagedByPlayer( nPlayerID, fInterval )

-- Returns whether the unit has been damaged by the specified player in the specified interval.
-- float TimeSinceDamagedByPlayer( nPlayerID )

-- Returns whether the amount of time passed the unit has been damaged by the specified hero.
-- bool WasRecentlyDamagedByCreep( fInterval )

-- Returns whether the unit has been damaged by a creep in the specified interval.
-- float TimeSinceDamagedByCreep()

-- Returns whether the amount of time passed the unit has been damaged by a creep.
-- bool WasRecentlyDamagedByTower( fInterval )

-- Returns whether the unit has been damaged by a tower in the specified interval.
-- float TimeSinceDamagedByTower()

-- Returns whether the amount of time passed the unit has been damaged by a tower.

-- int DistanceFromFountain()

-- Gets the unit’s straight-line distance from the team’s fountain (0 is in the fountain).
-- int DistanceFromSecretShop()

-- Gets the unit’s straight-line distance from the closest secret shop (0 is in a secret shop).
-- int DistanceFromSideShop()

-- Gets the unit’s straight-line distance from the closest side shop (0 is in a side shop).

-- SetTarget( hUnit )

-- Sets the target to be a specific unit. Doesn't actually execute anything, just potentially useful for communicating a target between modes/items.
-- hUnit GetTarget()

-- Gets the target that's been set for a unit.
-- SetNextItemPurchaseValue( nGold )

-- Sets the value of the next item to purchase. Doesn't actually execute anything, just potentially useful for communicating a purchase target for modes like Farm.
-- int GetNextItemPurchaseValue()

-- Gets the purchase value that's been set.

-- int GetAssignedLane()

-- Gets the assigned lane of this unit.
-- fix lane of Elder Titan (and IO)
local o_GetAssignedLane = CDOTA_Bot_Script.GetAssignedLane
function CDOTA_Bot_Script:GetAssignedLane()
    if self ~= nil
    and (self:GetUnitName() == 'npc_dota_hero_elder_titan' or self:GetUnitName() == 'npc_dota_hero_wisp')
    and self.lane ~= nil then
        return self.lane
    end
    return o_GetAssignedLane(self)
end

-- float GetOffensivePower()

-- Gets an estimate of the current offensive power of a unit. Derived from the average amount of damage it can do to all enemy heroes.
-- float GetRawOffensivePower()

-- Gets an estimate of the current offensive power of a unit. Derived from the average amount of damage it can do to all enemy heroes, ignoring cooldown and mana status.
-- float GetEstimatedDamageToTarget( bCurrentlyAvailable, hTarget, fDuration, nDamageTypes )

-- Gets an estimate of the amount of damage that this unit can do to the specified unit. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.
-- float GetStunDuration( bCurrentlyAvailable )

-- Gets an estimate of the duration of a stun that a unit can cast. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.
-- float GetSlowDuration( bCurrentlyAvailable )

-- Gets an estimate of the duration of a slow that a unit can cast. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.

-- bool HasBlink( bCurrentlyAvailable )

-- Returns whether the unit has a blink available to them.
-- bool HasMinistunOnAttack()

-- Returns whether the unit has a ministun when they attack.
-- bool HasSilence( bCurrentlyAvailable )

-- Returns whether the unit has a silence available to them.
-- bool HasInvisibility( bCurrentlyAvailable )

-- Returns whether the unit has an invisibility-causing item or ability available to them.
-- bool UsingItemBreaksInvisibility()

-- Returns whether using an item would break the unit's invisibility.

-- { hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)

-- Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE, searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.
-- { hUnit, ... } GetNearbyCreeps( nRadius, bEnemies )

-- Returns a table of creeps, sorted closest-to-furthest. nRadius must be less than 1600.
-- { hUnit, ... } GetNearbyLaneCreeps( nRadius, bEnemies )

-- Returns a table of lane creeps, sorted closest-to-furthest. nRadius must be less than 1600.
-- { hUnit, ... } GetNearbyNeutralCreeps( nRadius )

-- Returns a table of neutral creeps, sorted closest-to-furthest. nRadius must be less than 1600.
-- { hUnit, ... } GetNearbyTowers( nRadius, bEnemies )

-- Returns a table of towers, sorted closest-to-furthest. nRadius must be less than 1600.
-- { hUnit, ... } GetNearbyBarracks( nRadius, bEnemies )

-- Returns a table of barracks, sorted closest-to-furthest. nRadius must be less than 1600.
-- { hUnit, ... } GetNearbyShrines( nRadius, bEnemies )

-- Returns a table of shrines, sorted closest-to-furthest. nRadius must be less than 1600.
-- { int, ... } GetNearbyTrees ( nRadius )

-- Returns a table of Tree IDs, sorted closest-to-furthest. nRadius must be less than 1600.

-- { int count, vector targetloc } FindAoELocation( bEnemies, bHeroes, vBaseLocation, nMaxDistanceFromBase, nRadius, fTimeInFuture, nMaxHealth)

-- Gets the optimal location for AoE to hit the maximum number of units described by the parameters. Returns a table containing the values targetloc that is a vector for the center of the AoE and count that will be equal to the number of units within the AoE that mach the description.

-- vector GetExtrapolatedLocation( fTime )

-- Returns the extrapolated location of the unit fTime seconds into the future, based on its current movement.
-- float GetMovementDirectionStability()

-- Returns how stable the direction of the unit's movement is -- a value of 1.0 means they've been moving in a straight line for a while, where 0.0 is completely random movement.
-- bool HasModifier( sModifierName )

-- Returns whether the unit has the specified modifer.
-- int GetModifierByName( sModifierName )

-- Returns the modifier index for the specified modifier.
-- int NumModifiers()

-- Returns the number of modifiers on the unit.
-- int GetModifierName( nModifier )

-- Returns the name of the specified modifier.
-- int GetModifierStackCount( nModifier )

-- Returns stack count of the specified modifier.
-- int GetModifierRemainingDuration( nModifier )

-- Returns remaining duration of the specified modifier.
-- int GetModifierAuxiliaryUnits( nModifier )

-- Returns a table containing handles to units that the modifier is responsible for, such as Ember Spirit remnants.
-- {time, location, normal_ping} GetMostRecentPing()

-- Returns a table containing the time and location of the unit's most recent ping, and whether it was a normal or danger ping.

-- { { location, caster, player, ability, is_dodgeable, is_attack }, ... } GetIncomingTrackingProjectiles()

-- Returns information about all projectiles incoming towards this unit.