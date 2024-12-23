This script is insprired by Fretbots. It runs in conjuction with the bot script. When playing with AP, bots are typically underpowered due to their tendency to roam and not really farm much.
So, I made this to increase their GPM and XPM. I only care about increasing their GPM and XPM, hence I'm not using Fretbots.

I also added a functionality for bots to get neutral items. It is random for now.

# To Use
1. Launch DotA 2 with console enabled.
2. For local host only, so Create a Lobby. Make sure that `Enable Cheats` is checked. 
3. In Hero Selection (pick phase), open the console, and type: `sv_cheats 1` then `script_reload_code bots/Buff/buff`.
4. The script is now running (`Buff mode enabled!` message in chat).

Enabling this also adds `Lifestealer's missing Rage`, and `Faceless Void's missing Chronosphere` from patch 7.37.

Set `bTowerBuff` to `false` to disable tower buff.
- [x] Enabled?

It can be use with other bot scripts; just change some stuff accordingly, to suit whichever script. Or use fretbots.