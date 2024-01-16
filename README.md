# Dota 2 Bot Script

This is a Dota 2 Bot Script based mostly on Beginner:AI by (dota2jmz@163.com). Some changes are based upon other existing bot scripts; personal use mostly; adding heroes. Trying to get use to the API and code base.
It's not necessarily better than the origin script (due to the changes Push/Defend logic/timings, can get cook early game). Just tryna alleviate cheesiness and make bots movement more organic and objective base.
It's a work in progress.

Might want to scale Push desire with core networths so that bots farm more and increase their CS (though my vscript Buff alleviate this). Also, evasion/damage reduction/aura
items are just too good in bots games (since itemization isn't dynamic), so it's still lineup dependent.

Worth noting that I also use a vscript to improve the bots GPM (XPM later) and also have them able to get neutral items (Check Buff).

- ***To Use***
    - Since Valve hasn't fixed the workshop bug yet, bot scripts (that were uploaded after the bug occured) are only playable through local host lobby.
    - To use this (ignore the first two if Git is installed):
        - Go to Steam/steamapps/workshop/content/570.
        - Find the folder inside 570 named: `3139791706`, then copy it.
        - Go to Steam/steamapps/common/dota 2 beta/game/dota/scripts/vscripts. You will see that there is a `bots` folder inside. Either delete this folder or rename it.
            - Alternatively, if you have Git installed (easier and better way):
                - Once you've deleted or renamed the bots folder, create a new folder called `bots`.
                - Open Command Prompt inside this folder (Right Click on Windows 11). Type: `git clone https://github.com/ryndrb/dota2bot.git`.
                - The contents of this repository will then be downloaded. And everytime this repository is updated, open Command Prompt inside the `bots` folder. Type: `git pull`.
                - Ignore 4.
        - Paste your copy of `3139791706`, and rename it to `bots`.
        - Then, launch DotA 2.
        - Click `Play Dota`. Under `Custom Lobbies`, select `Create`.
        - Under the `Lobby Settings` at the bottom, select `Edit`. Then, in the drop down `Radiant Bots` and `Dire Bots` menus, select `Local Dev Script`.
        - Click OK, and it should be good to go.
            - The lobby has 5 slots (This is for Radiant only for now):
                -  1st is for Position 2 (Mid Lane)
                -  2nd is for Position 3 (Off Lane)
                -  3rd is for Position 1 (Safe Lane)
                -  4th is for Position 5 (Support Safe Lane)
                -  5th is for Position 4 (Support Off Lane)
        - (For non-Git) Everytime there is an update, the contents inside the `3139791706` folder needs to be copy and pasted to the `bots` folder.

- ***Key Scripts***
    - BOT Experiment (by Furiospuppy)
    - ExtremePush (https://github.com/insraq/dota2bots)
    - PhalanxBot (https://steamcommunity.com/sharedfiles/filedetails/?id=2873408973&searchtext=)

# Tinkering About
- ***Heroes (Pos: 1,2,3,4,5)***
    - Heroes can't be core or support in their possible roles; strictly core/supports; due to ability usage
    - ***Added***
        - [3] Timbersaw
        - [3] Mars
        - [2] Storm Spirit
        - [2] Ember Spirit
        - [1] Faceless Void
        - [1] Alchemist
        - [1] Terrorblade
        - [1] Ursa
        - [2] Void Spirit
        - [2] Earth Spirit
        - [1,2] Tiny
    - ***Changed***
        - [2] Necrophos
        - [2] Lina
        - [2] Queen Of Pain (buggy?)
        - [2,3] Death Prophet
        - [2] Zeus

- ***"Attempted" Logic Changes (still)***
    - Pushing (Roughly default still)
    - Defending (Roughly default still)
    - Do Roshan

- ***Items***
    - Bots will sell items on the fly in Turbo Mode
    - Item progressions (some need changing)
    - Removed most Halberd and Crimson Guards (bots sucks at playing around these items)

- ***Plan To "Fix/Add/Improve" (if possible)***
    - ***Fix***
        - [ ] Warding
        - [ ] Rune behaviour
        - [ ] Bots standing around (related to PushThink?)
    - ***Add***
        - [ ] Tormentor
        - [ ] Dynamic item builds
        - [ ] Clear wave faster with abilities
        - [x] Functionality for new ablities gained through Aghs/Shard
            - Alchemist
                - [x] Shard
                - [ ] Scepter
            - Antimage
                - [x] Shard
                - [x] Scepter
            - Arc Warden
                - [N] Shard
                - [N] Scepter
            - Axe
                - [N] Shard
                - [N] Scepter
            - Bane
                - [N] Shard
                - [N] Scepter
            - Bloodseeker
                - [N] Shard
                - [x] Scepter
            - Bounty Hunter
                - [N] Shard
                - [x] Scepter
            - Bristleback
                - [x] Shard
                - [x] Scepter
            - Chaos Knight
                - [N] Shard
                - [N] Scepter
            - Crystal Maiden
                - [x] Shard
                - [x] Scepter
            - Dazzle
                - [N] Shard
                - [N] Scepter
            - Death Prophet
                - [N] Shard
                - [N] Scepter
            - Dragon Knight
                - [N] Shard
                - [N] Scepter
            - Drow Ranger
                - [x] Shard
                - [N] Scepter
            - Earth Spirit
                - [x] Shard
                - [ ] Scepter
            - Ember Spirit
                - [N] Shard
                - [N] Scepter
            - Huskar
                - [N] Shard
                - [N] Scepter
            - Jakiro
                - [x] Shard
                - [N] Scepter
            - Juggernaut
                - [N] Shard
                - [x] Scepter
            - Kunkka
                - [x] Shard
                - [x] Scepter
            - Legion Commander
                - [N] Shard
                - [N] Scepter
            - Lich
                - [x] Shard
                - [x] Scepter
            - Lina
                - [N] Shard
                - [x] Scepter
            - Lion
                - [N] Shard
                - [N] Scepter
            - Luna
                - [N] Shard
                - [x] Scepter
            - Mars
                - [N] Shard
                - [N] Scepter
            - Medusa
                - [N] Shard
                - [N] Scepter
            - Mirana
                - [N] Shard
                - [N] Scepter
            - Naga Siren
                - [N] Shard
                - [x] Scepter
        - [x] vscript to increase bots GPM (XPM later) and for them to acquire neutral items (local host only)
    - ***Improve***
        - [ ] Some heroes ability usage
        - [ ] Item usage
    