# Dota 2 Bot Script

This is a Dota 2 Bot Script based mostly on Beginner:AI by (dota2jmz@163.com). Some changes are based upon other existing bot scripts; personal use mostly; adding heroes. Trying to get use to the API and code base.
It's not necessarily better than the origin script (due to Push/Defend logic/timings, can get cook early game), though this wins quite a lot against it when spectating (if no Sniper/Viper/Warlock).

Might want to scale Push desire with core networths so that bots farm more and increase their CS, though it's only good if also going against this bot script. If matched against others, like Beginner:AI
(or any aggresive logic), they might get out-pushed (since those will bring all 5 everytime), which will make this script defend all the time and cores not able farm (non-Turbo). Also, evasion and damage reduction
items are just too good in bots games (since itemization isn't dynamic), so it's still lineup dependent.

Worth noting that I also use a vscript to improve the bots GPM (XPM later) and also have them able to get neutral items (Check Buff).

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
    - Pushing
    - Defending
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
        - [ ] Functionality for new hero ablities gained through Aghs/Shard
        - [/] vscript to increase bots GPM (XPM later) and for them to acquire neutral items
    - ***Improve***
        - [ ] Some heroes ability usage
        - [ ] Item usage
    