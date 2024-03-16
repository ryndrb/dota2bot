# Dota 2 Bot Script

This is a Dota 2 Bot Script based off of Beginner:AI by (dota2jmz@163.com). Some changes are based upon other existing bot scripts; personal use mostly; adding heroes. Trying to get use to the API and code base.
Just trying to alleviate cheesiness and make bots movement more organic and objective base. It's a work in progress.

Might want to scale Push desire with core networths so that bots farm more and increase their CS (though my vscript Buff alleviate this). Also, evasion/damage reduction/aura
items are just too good in bots games (since itemization isn't dynamic), so it's still lineup dependent.

Worth noting that I also use a vscript to improve the bots GPM and XPM (AP only), and also have them able to get neutral items (Check Buff).

To anyone who've found this or is using it, if you have any feedback in improving the script, kindly post them on the Steam Workshop page: https://steamcommunity.com/workshop/filedetails/discussion/3139791706/4143942846477191222/

- ***To Use***
    - Since Valve hasn't fixed the workshop bug yet, bot scripts (that were uploaded after the bug occured) are only playable through local host lobby.
    - To use this:
        - Go to Steam/steamapps/common/dota 2 beta/game/dota/scripts/vscripts. You will see that there is a `bots` folder inside. Either delete this folder or rename it.
            - Once you've deleted or renamed the bots folder, create a new folder called `bots`.
            - Download the files on this repo by going to `<> Code` and Under `Local`, select `Download ZIP`.
            - Extract the contents of the zip inside the `bots` folder.
            - Alternatively, if you have Git installed (ignore 2-3 from above):
                - Open Command Prompt inside the folder (Right Click on Windows 11). Type: `git clone https://github.com/ryndrb/dota2bot.git`.
                - The contents of this repository will then be downloaded. And everytime this repository is updated, open Command Prompt inside the `bots` folder. Type: `git pull` to update the files inside the folder.
        - Then, launch DotA 2.
        - Click `Play Dota`. Under `Custom Lobbies`, select `Create`.
        - Under the `Lobby Settings` at the bottom, select `Edit`. Then, in the drop down `Radiant Bots` and `Dire Bots` menus, select `Local Dev Script`.
        - The `Server Location` must be `Local Host`.
        - Click OK, and it should be good to go.
            - The lobby has 5 slots (This is for Radiant only for now):
                -  1st is for Position 2 (Mid Lane)
                -  2nd is for Position 3 (Off Lane)
                -  3rd is for Position 1 (Safe Lane)
                -  4th is for Position 5 (Support Safe Lane)
                -  5th is for Position 4 (Support Off Lane)
        - (For non-Git) Everytime there is an update, you have to re-download the files and replaced the ones on the `bots` folder.

- ***Key Scripts***
    - BOT Experiment (by Furiospuppy)
    - ExtremePush (https://github.com/insraq/dota2bots)

# Tinkering About
- ***Heroes (Pos: 1,2,3,4,5)***
    - All Supports are both 4 and 5 for now.
    - ^. Supports that does damage, CC, or is Ranged are just inherently 'better' for the most part in bot games compared to Melee or non-. (Since positioning and movement are Valve default.)
    - ^. AoE spells are just too good.
    - ***Added***
        - [4,5] Abaddon
        - [1] Alchemist
        - [4,5] Ancient Apparition
        - [2,3] Batrider
        - [3] Beastmaster
        - [3] Brewmaster
        - [2,3] Broodmother
        - [3] Centaur
        - [4,5] Chen
        - [1,2] Clinkz
        - [4,5] Clockwerk
        - [3] Dark Seer
        - ~~[4,5] Dark Willow~~
        - [3] Dawnbreaker
        - [4,5] Disruptor
        - [3] Doom
        - [2] Earth Spirit
        - [4,5] Earthshaker
        - [2] Ember Spirit
        - [4,5] Enchantress
        - [3] Enigma
        - [1] Faceless Void
        - [4,5] Grimstroke
        - [1] Gyrocopter
        - ~~[4,5] Hoodwink~~
        - [2] Invoker
        - [2] Keeper of the Light
        - [2] Leshrac
        - [1] Lifestealer
        - [3] Lycan
        - [3] Magnus
        - ~~[1,3] Marci~~
        - [3] Mars
        - [1,2] Meepo
        - [1,2] Monkey King
        - ~~[1] Muerta~~
        - [1,3] Nature's Prophet
        - [3] Night Stalker
        - [4,5] Nyx Assassin
        - [2] Outworld Destroyer
        - [2,3] Pangolier
        - [4,5] Phoenix
        - ~~[2,3] Primal Beast~~
        - [2] Puck
        - [2,3] Pudge
        - [4,5] Shadow Demon
        - [2] Snapfire
        - [1] Spectre
        - [3] Spirit Breaker
        - [2] Storm Spirit
        - [1] Terrorblade
        - [3] Timbersaw
        - [1,2] Tiny
        - [4,5] Treant
        - [1] Troll Warlord
        - [4,5] Tusk
        - [1] Ursa
        - [2] Void Spirit
    - ***Later***
        - Lone Druid
        - Morphling
        - Rubick
        - Techies
        - Tinker
    - ***Changed***
        - [2,3] Death Prophet
        - [1,2] Lina
        - [2,3] Necrophos
        - [2] Queen Of Pain
        - [2] Zeus
    - ***Bugged (Internal)***
        - Dark Willow
            - Passive.
        - Elder Titan
            - Passive.
        - Hoodwink
            - Hardly enters Attack mode (Valve default).
        - IO
            - Passive.
        - Marci
            - Passive.
        - Muerta
            - Passive.
        - Primal Beast
            - Passive.

- ***Items***
    - Bots will sell items on the fly in Turbo Mode
    - Item progressions (some need changing)
    - Reduced most Halberd/Crimson Guards/Aura items (bots sucks at playing around these items). They're OP; A lot of what makes the bots 'harder' in Beginner AI.

- ***Plan To "Fix/Add/Improve" (if possible)***
    - ***Fix***
        - [x] Warding
            - Sentries are planted when pinged or they're after someone.
            - Pos 4 -> Sentry
            - Pos 5 -> Observer
                - Due to how ward slots work. No API func to tell which ward is in front.
            - Use Danger Ping (Crtl + Alt + Left Click) to tell bots to Ward the ping location if they're suitable to do so.
                - Must be within 1200 units to the pinged bot (for now).
        - [ ] Rune behaviour
        - [ ] Doom apparently not able to Devour abilities (might just be Valve bug tho)
    - ***Add***
        - [x] Tormentor
            - Desire decreases starting at minute (20; 35 (AP)).
            - Tricky to harmonize with others due to its nature.
        - [x] Outpost
        - [ ] Spell usage for Tormentor and Roshan
        - [ ] Dynamic item builds
        - [ ] Clear wave faster with abilities
        - [x] vscript to increase bots GPM and XPM (AP only), and for them to acquire neutral items (local host only)
        - [x] Functionality for new active ablities gained through Aghs/Shard
            | Hero                  | Shard   | Scepter | Spell Usage Imp. Count
            |:---------------------:|:-------:|:-------:|:----------------------:
            | Abaddon               | -       | -       | 1
            | Alchemist             | &check; | &cross; | 1
            | Ancient Apparition    | -       | -       | 1
            | Antimage              | &check; | &check; | 0
            | Arc Warden            | -       | -       | 0
            | Axe                   | -       | -       | 0
            | Bane                  | -       | -       | 0
            | Batrider              | -       | -       | 1
            | Beastmaster           | -       | -       | 1
            | Bloodseeker           | -       | &check; | 0
            | Bounty Hunter         | -       | &check; | 0
            | Brewmaster            | -       | &cross; | 1
            | Bristleback           | &check; | &check; | 0
            | Broodmother           | -       | &cross; | 1
            | Centaur               | -       | &check; | 1
            | Chaos Knight          | -       | -       | 0
            | Chen                  | &cross; | &cross; | 0
            | Clinkz                | &check; | &check; | 0
            | Clockwerk             | &check; | &check; | 0
            | Crystal Maiden        | &check; | &check; | 0
            | Dark Seer             | -       | -       | 0
            | ~~Dark Willow~~       | &check; | -       | 0
            | Dawnbreaker           | -       | -       | 0
            | Dazzle                | -       | -       | 0
            | Death Prophet         | -       | -       | 0
            | Disruptor             | -       | -       | 0
            | Doom                  | -       | -       | 0
            | Dragon Knight         | -       | -       | 0
            | Drow Ranger           | &check; | -       | 0
            | Earth Spirit          | &check; | &cross; | 0
            | Earthshaker           | -       | -       | 0
            | Ember Spirit          | -       | -       | 0
            | Enchantress           | &check; | &check; | 0
            | Enigma                | -       | -       | 0
            | Faceless Void         | &check; | -       | 0
            | Grimstroke            | -       | &check; | 0
            | Gyrocopter            | -       | -       | 0
            | ~~Hoodwink~~          | &check; | &check; | 0
            | Huskar                | -       | -       | 0
            | Invoker               | -       | &check; | 0
            | Jakiro                | &check; | -       | 0
            | Juggernaut            | -       | &check; | 0
            | Keeper of the Light   | &check; | &check; | 0
            | Kunkka                | &check; | &check; | 0
            | Legion Commander      | -       | -       | 0
            | Leshrac               | -       | &check; | 0
            | Lich                  | &check; | &check; | 0
            | Lifestealer           | &check; | -       | 0
            | Lina                  | -       | &check; | 0
            | Lion                  | -       | -       | 0
            | Luna                  | -       | &check; | 0
            | Lycan                 | -       | &cross; | 0
            | Magnus                | -       | &check; | 0
            | Mars                  | -       | -       | 0
            | ~~Marci~~             | -       | -       | 0
            | Medusa                | -       | -       | 0
            | Meeepo                | &check; | &check; | 0
            | Mirana                | -       | -       | 0
            | Monkey King           | &cross; | -       | 0
            | ~~Muerta~~            | -       | -       | 0
            | Naga Siren            | -       | &check; | 0
            | Nature's Prophet      | -       | &check; | 0
            | Necrophos             | &check; | -       | 0
            | Night Stalker         | &check; | -       | 0
            | Nyx Assassin          | &check; | -       | 0
            | Ogre Magi             | &check; | &check; | 0
            | Omniknight            | -       | -       | 0
            | Oracle                | &check; | -       | 0
            | Outworld Destroyer    | -       | -       | 0
            | Pangolier             | &check; | -       | 0
            | Phantom Assasin       | &check; | -       | 0
            | Phantom Lancer        | &check; | -       | 0
            | Phoenix               | -       | -       | 0
            | ~~Primal Beast~~      | -       | -       | 0
            | Puck                  | -       | -       | 0
            | Pugna                 | -       | -       | 0
            | Pudge                 | -       | &cross; | 0
            | Queen of Pain         | -       | -       | 0
            | Razor                 | -       | -       | 0
            | Riki                  | -       | -       | 0
            | Sand King             | -       | -       | 0
            | Shadow Demon          | &check; | -       | 0
            | Shadow Fiend          | &cross; | -       | 0
            | Shadow Shaman         | -       | -       | 0
            | Silencer              | -       | -       | 0
            | Skywrath Mage         | -       | -       | 0
            | Slardar               | -       | -       | 0
            | Slark                 | -       | -       | 0
            | Snapfire              | -       | &cross; | 0
            | Sniper                | -       | -       | 0
            | Spectre               | -       | &check; | 0
            | Spirit Breaker        | &check; | -       | 0
            | Storm Sprit           | -       | -       | 0
            | Sven                  | -       | &cross; | 0
            | Templar Assasin       | -       | &cross; | 0
            | Terrorblade           | &check; | &check; | 0
            | Tidehunter            | &check; | -       | 0
            | Timbersaw             | &check; | &check; | 0
            | Tiny                  | -       | &check; | 0
            | Treant                | -       | &check; | 0
            | Troll Warlord         | -       | -       | 0
            | Tusk                  | -       | &cross; | 0
            | Ursa                  | -       | -       | 0
            | Viper                 | -       | &check; | 0
            | Void Spirit           | -       | -       | 0
            | Warlock               | -       | -       | 0
            | Witch Doctor          | &check; | -       | 0
            | Wraith King           | -       | -       | 0
            | Zeus                  | &check; | &check; | 0
    - ***Improve***
        - [ ] Some heroes ability usage (too spammy, ends up not having enough mana)
        - [ ] Item usage
        - [ ] Re(factor/write) old code for consistency
        - [ ] Blinking (especially by range heroes)
        - [ ] More skill checks (eg. stuns, projectiles, etc)
        - [ ] Early added heroes to follow current standard
    