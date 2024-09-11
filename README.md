# DotA 2 Bot Script: Tinkering ABo(u)t [7.37]

This is a DotA 2 Bot Script based on [Beginner:AI NEW](https://steamcommunity.com/sharedfiles/filedetails/?id=1627071163); it's mainly for personal use.
This is where I update this script. I very rarely, if ever, update the Steam Workshop page.

Since this is an inherently RB system, the best viable way to make bots "good" is through aura stacking. Evasion, damage reduction, and aura items tend to be really strong
in bot games. Though if there are multiple decent human players vs bots, it won't really matter much. Also, performance can still be hit or miss depending on the team composition. Point-Click AoE heroes are good.

Worth noting that I'm also using a [vscript](https://github.com/ryndrb/dota2bot/tree/master/Buff) to boost bots GPM and XPM in All Pick mode, and they can get Neutral Items too. This is recommended to use.

If you’ve come across this script or is using it, good feedback is always welcome. Drop any suggestion on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3139791706) page or open an Issue or Pull Request.

- ***To Use***
    - Since Valve hasn't fixed the workshop bug yet, bot scripts (that were uploaded after the bug occured) are only playable through `Local Host` lobby.
    - To use this:
        - Go to `Steam/steamapps/common/dota 2 beta/game/dota/scripts/vscripts`. You will see that there is a `bots` folder inside. Either delete this folder or rename it.
            - Once you've deleted or renamed the bots folder, create a new folder called `bots`.
            - Download the files on this repo by going to `<> Code` and Under `Local`, select `Download ZIP`.
            - Extract the contents of the zip inside the `bots` folder.
            - Alternatively, if you know how to use Git, just clone/pull this inside the `bots` folder.
        - Then, launch DotA 2.
        - Click `Play Dota`. Under `Custom Lobbies`, select `Create`.
        - Under the `Lobby Settings` at the bottom, select `Edit`. Then, in the drop down `Radiant Bots` and `Dire Bots` menus, select `Local Dev Script`.
        - The `Server Location` must be `Local Host`.
        - Click OK, and it should be good to go. Bot names should be: `(team.name.(kanji)TA)`.
            - The lobby has 5 slots:
                -  1st is for Position 2 (Mid Lane)
                -  2nd is for Position 3 (Off Lane)
                -  3rd is for Position 1 (Safe Lane)
                -  4th is for Position 5 (Support Safe Lane)
                -  5th is for Position 4 (Support Off Lane)
        - (For non-Git) Everytime there is an update, you have to re-download the files and replaced the ones on the `bots` folder. If you've made personal changes to some files, you have to make a backup to those files, or fix the conflicts yourself.
    - How I test:
        - Added in launch options: `+cl_clock_recvmargin_enable 0`
        - Bots v Bots
        - (Turbo, only if I'm testing spell and item usage/synergy; All Pick otherwise)
        - `Enable Cheats`
        - Type: `sv_cheats 1` in console.
        - Type: `host_timescale 2` or `host_timescale 4` in console.
        - Type: `script_reload_code bots/Buff/buff` in console (pick phase).
        - Type: `host_timescale 0` in console to pause.

- ***Key Scripts***
    - BOT Experiment (by Furiouspuppy)
    - ExtremePush (https://github.com/insraq/dota2bots)

# Tinkering ABo(u)t (ryndrb)
- ***Heroes (Pos: 1,2,3,4,5)***
    - <ins>Heroes Implemented Count:</ins> **118** / 125
    - ***Added***
        - [1,2,3,4,5] Abaddon
        - [1,2,3] Alchemist
        - [2,4,5] Ancient Apparition
        - [2,3,4,5] Batrider
        - [3] Beastmaster
        - [3] Brewmaster
        - [1,2,3] Broodmother
        - [2,3] Centaur
        - [5] Chen
        - [1,2,4,5] Clinkz
        - [4,5] Clockwerk
        - [3] Dark Seer
        - ~~[4,5] Dark Willow~~
        - [2,3,4,5] Dawnbreaker
        - [4,5] Disruptor
        - [2,3] Doom
        - [2,3,4,5] Earth Spirit
        - [2,3,4] Earthshaker
        - ~~[4,5] Elder Titan~~
        - [2] Ember Spirit
        - [3,5] Enchantress
        - [3,4,5] Enigma
        - [1] Faceless Void
        - [4,5] Grimstroke
        - [1,2,4,5] Gyrocopter
        - ~~[4,5] Hoodwink~~
        - [2] Invoker
        - [2,4,5] Keeper of the Light
        - [2,3] Leshrac
        - [1] Lifestealer
        - ~~[2] Lone Druid~~
        - [1,2,3] Lycan
        - [3] Magnus
        - ~~[1,3] Marci~~
        - [3] Mars
        - [1,2] Meepo
        - [1,2] Monkey King
        - [1,2] Morphling
        - [1] Muerta
        - [1,2,3,4,5] Nature's Prophet
        - [3] Night Stalker
        - [4,5] Nyx Assassin
        - [2] Outworld Destroyer
        - [2,3] Pangolier
        - [4,5] Phoenix
        - ~~[2,3] Primal Beast~~
        - [2] Puck
        - [2,3,4,5] Pudge
        - [4,5] Ringmaster
        - [2,4,5] Rubick
        - [4,5] Shadow Demon
        - [2,4,5] Snapfire
        - [1] Spectre
        - [2,3,4,5] Spirit Breaker
        - [2] Storm Spirit
        - [4,5] Techies
        - [1] Terrorblade
        - [2,3] Timbersaw
        - [2,4,5] Tinker
        - [1,2,3,4,5] Tiny
        - [4,5] Treant
        - [1] Troll Warlord
        - [2,3,4,5] Tusk
        - [3] Underlord
        - [5] Undying
        - [1,3] Ursa
        - [4,5] Vengeful Spirit
        - [4,5] Venomancer
        - [2,3] Visage
        - [2] Void Spirit
        - [1,4,5] Weaver
        - [1,2,3,4,5] Windranger
        - [2,3,4,5] Winter Wyvern
    - ***Later***
        - Morphling Ult
    - ***Bugged (Internal; some will be selected)***
        - Dark Willow
            - Hardly enters Attack mode (Valve default).
            - ^ Does enter since she uses spells, but won't engage/attack. Just always keeping distance.
        - Elder Titan
            - Does not listen to lane assignments. Forces Mid.
        - Hoodwink
            - Hardly enters Attack mode (Valve default).
            - ^ Does enter since she uses spells, but won't engage/attack. Just always keeping distance.
        - IO
            - Passive.
        - Lone Druid
            - The Bear is considered a "hero", and not a unit like Visage's Familiars, etc,. Uncontrollable.
        - Marci
            - Passive.
        - ~~Muerta~~
            - ~~Passive.~~
            - ~~Passable with generic laning Think(). Will add later as she can actually engage (Attack Mode) and attack enemies.~~
        - Primal Beast
            - Passive.

- ***Aghs/Shard func list***
    | Hero                  | Shard   | Scepter |
    |:---------------------:|:-------:|:-------:|
    | Abaddon               | -       | -       |
    | Alchemist             | &check; | &cross; |
    | Ancient Apparition    | -       | -       |
    | Anti-Mage             | &check; | &check; |
    | Arc Warden            | -       | -       |
    | Axe                   | -       | -       |
    | Bane                  | -       | -       |
    | Batrider              | -       | -       |
    | Beastmaster           | -       | -       |
    | Bloodseeker           | -       | &check; |
    | Bounty Hunter         | -       | &check; |
    | Brewmaster            | -       | &check; |
    | Bristleback           | &check; | &check; |
    | Broodmother           | -       | &cross; |
    | Centaur               | -       | &check; |
    | Chaos Knight          | -       | -       |
    | Chen                  | &cross; | &cross; |
    | Clinkz                | &check; | &check; |
    | Clockwerk             | &check; | &check; |
    | Crystal Maiden        | &check; | &check; |
    | Dark Seer             | -       | -       |
    | ~~Dark Willow~~       | &check; | -       |
    | Dawnbreaker           | -       | -       |
    | Dazzle                | -       | -       |
    | Death Prophet         | -       | -       |
    | Disruptor             | -       | -       |
    | Doom                  | -       | -       |
    | Dragon Knight         | -       | -       |
    | Drow Ranger           | &check; | -       |
    | Earth Spirit          | &check; | &cross; |
    | Earthshaker           | -       | &check; |
    | ~~Elder Titan~~       | -       | -       |
    | Ember Spirit          | -       | -       |
    | Enchantress           | &check; | &check; |
    | Enigma                | -       | -       |
    | Faceless Void         | &check; | -       |
    | Grimstroke            | -       | &check; |
    | Gyrocopter            | -       | -       |
    | ~~Hoodwink~~          | &check; | &check; |
    | Huskar                | -       | -       |
    | Invoker               | -       | &check; |
    | Jakiro                | &check; | -       |
    | Juggernaut            | -       | &check; |
    | Keeper of the Light   | &check; | &check; |
    | Kunkka                | &check; | &check; |
    | Legion Commander      | -       | -       |
    | Leshrac               | -       | &check; |
    | Lich                  | &check; | &check; |
    | Lifestealer           | &check; | -       |
    | Lina                  | -       | &check; |
    | Lion                  | -       | -       |
    | ~~Lone Druid~~        | -       | -       |
    | Luna                  | -       | &check; |
    | Lycan                 | -       | &cross; |
    | Magnus                | -       | &check; |
    | Mars                  | -       | -       |
    | ~~Marci~~             | -       | -       |
    | Medusa                | -       | -       |
    | Meeepo                | &check; | &check; |
    | Mirana                | -       | -       |
    | Monkey King           | &cross; | -       |
    | Morphling             | -       | &cross; |
    | Muerta                | -       | &check; |
    | Naga Siren            | -       | &check; |
    | Nature's Prophet      | -       | &check; |
    | Necrophos             | &check; | -       |
    | Night Stalker         | &check; | -       |
    | Nyx Assassin          | &check; | -       |
    | Ogre Magi             | &check; | &check; |
    | Omniknight            | -       | -       |
    | Oracle                | &check; | -       |
    | Outworld Destroyer    | -       | -       |
    | Pangolier             | &check; | -       |
    | Phantom Assasin       | &check; | -       |
    | Phantom Lancer        | &check; | -       |
    | Phoenix               | -       | -       |
    | ~~Primal Beast~~      | -       | -       |
    | Puck                  | -       | -       |
    | Pugna                 | -       | -       |
    | Pudge                 | -       | &cross; |
    | Queen of Pain         | -       | -       |
    | Razor                 | -       | -       |
    | Riki                  | -       | -       |
    | Ringmaster            | &check; | -       |
    | Rubick                | -       | -       |
    | Sand King             | -       | -       |
    | Shadow Demon          | &check; | -       |
    | Shadow Fiend          | &cross; | -       |
    | Shadow Shaman         | -       | -       |
    | Silencer              | -       | -       |
    | Skywrath Mage         | -       | -       |
    | Slardar               | -       | -       |
    | Slark                 | -       | -       |
    | Snapfire              | -       | &cross; |
    | Sniper                | -       | -       |
    | Spectre               | -       | &check; |
    | Spirit Breaker        | &check; | -       |
    | Storm Sprit           | -       | -       |
    | Sven                  | -       | &cross; |
    | Techies               | -       | -       |
    | Templar Assasin       | -       | &cross; |
    | Terrorblade           | &check; | &check; |
    | Tidehunter            | &check; | -       |
    | Timbersaw             | &check; | &check; |
    | Tinker                | &check; | -       |
    | Tiny                  | -       | &check; |
    | Treant                | -       | &check; |
    | Troll Warlord         | -       | -       |
    | Tusk                  | -       | &cross; |
    | Underlord             | -       | -       |
    | Undying               | &cross; | -       |
    | Ursa                  | -       | -       |
    | Vengeful Spirit       | -       | &check; |
    | Venomancer            | &check; | -       |
    | Viper                 | -       | &check; |
    | Visage                | -       | &check; |
    | Void Spirit           | -       | -       |
    | Warlock               | -       | -       |
    | Weaver                | -       | &check; |
    | Windranger            | &check; | -       |
    | Winter Wyvern         | -       | -       |
    | Witch Doctor          | &check; | -       |
    | Wraith King           | -       | -       |
    | Zeus                  | &check; | &check; |
    