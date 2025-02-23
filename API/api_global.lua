-- hUnit GetBot()

-- Returns a handle to the bot on which the script is currently being run (if applicable).
-- int GetTeam()

-- Returns the team for which the script is currently being run. If it's being run on a bot, returns the team of that bot.

-- Returns a table of the Player IDs on the specified team
local o_GetTeamPlayers = GetTeamPlayers
function GetTeamPlayers(nTeam)
	local nIDs = o_GetTeamPlayers(nTeam)

	-- All humans should only be on one team.
	-- Since bot IDs assignment are all over the place in 7.38, having humans on either side can't be fixed without a proper call to get their slot IDs.
	if nTeam == TEAM_DIRE then
		local hHumanTable = {}
		for _, id in pairs(nIDs) do
			if not IsPlayerBot(id) and id < 5 then
				table.insert(hHumanTable, id)
			end
		end
		if #hHumanTable > 0 then
			nIDs = {}
			for _, id in pairs(o_GetTeamPlayers(TEAM_DIRE)) do
				if IsPlayerBot(id) and GetTeamForPlayer(id) == TEAM_DIRE then
					table.insert(nIDs, id)
				end
			end

			for _, id in pairs(hHumanTable) do
				if id < 5 then table.insert(nIDs, id + 1, id) end
			end
		end
	end

	return nIDs
end

-- hUnit GetTeamMember( nPlayerNumberOnTeam )

-- Returns a handle to the Nth player on the team.
-- bool IsTeamPlayer( nPlayerID )

-- Returns whether the player is on Radiant or Dire
-- bool IsPlayerBot( nPlayerID )

-- Returns whether the specified playerID is a bot.
-- int GetTeamForPlayer( nPlayerID )

-- Returns the team for the specified playerID

-- { hUnit, ... } GetUnitList( nUnitType )

-- Returns a list of units matching the specified unit type. Please keep in mind performance considerations when using GetUnitList(). The function itself is reasonably fast because it will build the lists on-demand and no more than once per frame, but the lists can be long and performing logic on all units (or even all creeps) can easily get pretty slow.

-- float DotaTime()

-- Returns the game time. Matches game clock. Pauses with game pause.
-- float GameTime()

-- Returns the time since the hero picking phase started. Pauses with game pause.
-- float RealTime()

-- Returns the real-world time since the app has started. Does not pause with game pause.

-- float GetUnitToUnitDistance( hUnit1, hUnit2 )

-- Returns the distance between two units.
-- float GetUnitToUnitDistanceSqr( hUnit1, hUnit2 )

-- Returns the squared distance between two units.
-- float GetUnitToLocationDistance( hUnit, vLocation )

-- Returns the distance between a unit and a location.
-- float GetUnitToLocationDistanceSqr( hUnit, vLocation )

-- Returns the squared distance between a unit and a location.
-- { distance, closest_point, within } PointToLineDistance( vStart, vEnd, vPoint )

-- Returns a table containing the distance to the line segment, the closest point on the line segment, and whether the point is "within" the line segment (that is, the closest point is not one of the endpoints).

-- { float, float, float, float } GetWorldBounds()

-- Returns a table containing the min X, min Y, max X, and max Y bounds of the world.
-- bool IsLocationPassable( vLocation )

-- Returns whether the specified location is passable.
-- bool IsRadiusVisible( vLocation, fRadius )

-- Returns whether a circle of the specified radius at the specified location is visible.
-- bool IsLocationVisible( vLocation )

-- Returns whether the specified location is visible.
-- int GetHeightLevel( vLocation )

-- Returns the height value (1 through 5) of the specified location.
-- { { string, vector }, ... } GetNeutralSpawners()

-- Returns a table containing a list of camp-type and location pairs. Camp types are one of "basic_N", "ancient_N", "basic_enemy_N", "ancient_enemy_N", where N counts up from 0.

-- int GetItemCost( sItemName )

-- Returns the cost of the specified item.
-- bool IsItemPurchasedFromSecretShop( sItemName )

-- Returns if the specified item is purchased from the secret shops.
-- bool IsItemPurchasedFromSideShop( sItemName )

-- Returns if the specified item can be purchased from the side shops.
-- int GetItemStockCount( sItemName )

-- Returns the current stock count of the specified item.
-- { { hItem, hOwner, nPlayer, vLocation }, ...} GetDroppedItemList()

-- Returns a table of tables that list the item, owner, and location of items that have been dropped on the ground.

-- float GetPushLaneDesire( nLane )

-- Returns the team's current desire to push the specified lane.
-- float GetDefendLaneDesire( nLane )

-- Returns the team's current desire to defend the specified lane.
-- float GetFarmLaneDesire( nLane )

-- Returns the team's current desire to farm the specified lane.
-- float GetRoamDesire()

-- Returns the team's current desire to roam to a target.
-- hUnit GetRoamTarget()

-- Returns the team's current roam target.
-- float GetRoshanDesire()

-- Returns the team's current desire to kill Roshan.

-- int GetGameState()

-- Returns the current game state.
-- float GetGameStateTimeRemaining()

-- Returns how much time is remaining in the current game state, if applicable.

-- int GetGameMode()

-- Returns the current game mode.

-- int GetHeroPickState()

-- Returns the current hero pick state.
-- bool IsPlayerInHeroSelectionControl( nPlayerID )

-- Returns whether the specified player is in selection control when picking a hero.
-- SelectHero( nPlayerID, sHeroName )

-- Selects a hero for the specified player.
-- string GetSelectedHeroName( nPlayerID )

-- Returns the name of the hero the specified player has selected.

-- bool IsInCMBanPhase()

-- Returns whether we're in a Captains Mode ban phase.
-- bool IsInCMPickPhase()

-- Returns whether we're in a Captains Mode pick phase.
-- float GetCMPhaseTimeRemaining()

-- Gets the time remaining in the current Captains Mode phase.
-- int GetCMCaptain()

-- Gets the Player ID of the Captains Mode Captain.
-- SetCMCaptain( nPlayerID )

-- Gets the Captains Mode Captain to the specified Player ID.
-- bool IsCMBannedHero( sHeroName )

-- Returns whether the specified hero has been banned in a Captains Mode game.
-- bool IsCMPickedHero( nTeam, sHeroName )

-- Returns whether the specified hero has been picked in a Captains Mode game.
-- CMBanHero( sHeroName )

-- Bans the specified hero in a Captains Mode game.
-- CMPickHero( sHeroName )

-- Picks the specified hero in a Captains Mode game.

-- int RandomInt( nMin, nMax )

-- Returns a random integer between nMin and nMax, inclusive.
-- float RandomFloat( fMin, fMax )

-- Returns a random float between nMin and nMax, inclusive.
-- vector RandomVector( fLength )

-- Returns a vector of fLength pointing in a random direction in the X/Y axis.
-- bool RollPercentage( nChance )

-- Rolls a numbmer from 1 to 100 and returns whether it is less than or equal to the specified number.

-- float Min( fOption1, fOption2 )

-- Returns the smaller of fOption1 and fOption2.
-- float Max( fOption1, fOption2 )

-- Returns the larger of fOption1 and fOption2.
-- float Clamp( fValue, fMin, fMax )

-- Returns fValue clamped within the bounds of fMin and fMax.

-- float RemapVal( fValue, fFromMin, fFromMax, fToMin, fToMax )

-- Returns fValue linearly remapped onto fFrom to fTo.
-- float RemapValClamped( fValue, fFromMin, fFromMax, fToMin, fToMax )

-- Returns fValue linearly remapped onto fFrom to fTo, while also clamping within their bounds.

-- int GetUnitPotentialValue( hUnit, vLocation, fRadius )

-- Gets the 0-255 potential location value of a hero at the specified location and radius.

-- bool IsCourierAvailable()

-- Returns if the courier is available to use.
-- int GetNumCouriers()

-- Returns the number of team couriers
-- hCourier GetCourier( nCourier )

-- Returns a handle to the specified courier (zero based index)
-- int GetCourierState( hCourier )

-- Returns the current state of the specified courier.

-- vector GetTreeLocation( nTree )

-- Returns the specified tree location.
-- vector GetRuneSpawnLocation( nRuneLoc )

-- Returns the location of the specified rune spawner.
-- vector GetShopLocation( nTeam, nShop )

-- Returns the location of the specified shop.

-- float GetTimeOfDay()

-- Returns the time of day -- 0.0 is midnight, 0.5 is noon.

-- hUnit GetTower( nTeam, nTower )

-- Returns the specified tower.
-- hUnit GetBarracks( nTeam, nBarracks )

-- Returns the specified barracks.
-- hUnit GetShrine( nTeam, nShrine )

-- Returns the specified shrine.
-- hUnit GetAncient( nTeam )

-- Returns the specified ancient.

-- float GetGlyphCooldown()

-- Get the current Glyph cooldown in seconds. Will return 0 if it is off cooldown.

-- float GetRoshanKillTime()

-- Get the last time that Roshan was killed.

-- float GetLaneFrontAmount( nTeam, nLane, bIgnoreTowers )

-- Return the lane front amount (0.0 - 1.0) of the specified team's creeps along the specified lane. Optionally can ignore towers.
-- vector GetLaneFrontLocation( nTeam, nLane, fDeltaFromFront )

-- Returns the location of the lane front for the specified team and lane. Always ignores towers. Has a third parameter for a distance delta from the front.
-- vector GetLocationAlongLane( nLane, fAmount )

-- Returns the location the specified amount (0.0 - 1.0) along the specified lane.
-- { amount, distance } GetAmountAlongLane( nLane, vLocation )

-- Returns the amount (0.0 - 1.0) along a lane, and distance from the lane of the specified location.

-- int GetOpposingTeam()

-- Returns the opposing Team ID.

-- bool IsHeroAlive( nPlayerID )

-- Returns whether the specified PlayerID's hero is alive.
-- int GetHeroLevel( nPlayerID )

-- Returns the specified PlayerID's hero's level.
-- int GetHeroKills( nPlayerID )

-- Returns the specified PlayerID's hero's kill count.
-- int GetHeroDeaths( nPlayerID )

-- Returns the specified PlayerID's hero's death count.
-- int GetHeroAssists( nPlayerID )

-- Returns the specified PlayerID's hero's assists count.

-- { {location, time_since_seen}, ...} GetHeroLastSeenInfo( nPlayerID )

-- Returns a table containing a list of locations and time_since_seen members, each representing the last seen location of a hero that player controls.

-- { {location, caster, player, ability, velocity, radius, handle }, ... } GetLinearProjectiles()

-- Returns a table containing info about all visible linear projectiles.
-- { location, caster, player, ability, velocity, radius } GetLinearProjectileByHandle( nProjectileHandle )

-- Returns a table containing info about the specified linear projectile.

-- { {location, ability, caster, radius }, ... } GetAvoidanceZones()

-- Returns a table containing info about all visible avoidance zones.

-- int GetRuneType( nRuneLoc )

-- Returns the rune type of the rune at the specified location, if known.
-- int GetRuneStatus( nRuneLoc )

-- Returns the status of the rune at the specified location.
-- float GetRuneTimeSinceSeen( nRuneLoc )

-- Returns how long it's been since we've seen the rune at the specified location.

-- float GetShrineCooldown( hShrine )

-- Returns the current cooldown of the specified Shrine.
-- bool IsShrineHealing( hShrine )

-- Returns whether the specified shrine is currently healing.

-- int AddAvoidanceZone( vLocationAndRadius )

-- Adds an avoidance zone for use with GeneratePath(). Takes a Vector with x and y as a 2D location, and z as as radius. Returns a handle to the avoidance zone.
-- RemoveAvoidanceZone( hAvoidanceZone )

-- Removes the specified avoidance zone.
-- GeneratePath( vStart, vEnd, tAvoidanceZones, funcCompletion )

-- Pathfinds from vStar to vEnd, avoiding all the specified avoidance zones and the ones specified with AddAvoidanceZone. Will call funcCompltion when done, which is a function that has two parameters: a distance of the path, and a table that contains all the waypoints of the path. If the pathfind fails, it will call that function with a distance of 0 and an empty waypoint table.

-- DebugDrawLine( vStart, vEnd, nRed, nGreen, nBlue )

-- Draws a line from vStar to vEnd in the specified color for one frame.
-- DebugDrawCircle( vCenter, fRadius, nRed, nGreen, nBlue )

-- Draws a circle at vCenter with radius fRadius in the specified color for one frame.
-- DebugDrawText( fScreenX, fScreenY, sText, nRed, nGreen, nBlue )

-- Draws the specified text at fScreenX, fScreenY on the screen in the specified color for one frame.

-- { location, time_remaining, playerid } GetIncomingTeleports()

-- Gets a table of all the teleports that are visibly happening.