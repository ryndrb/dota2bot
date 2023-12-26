# Dota 2 Bot Script

This is a Dota 2 Bot Script based mostly on Beginner:AI by (dota2jmz@163.com). Some changes are based upon other existing bot scripts; personal use mostly; adding heroes. Trying to get use to the API and code base.
It's not necessarily better than the origin script (due to Push/Defend logic/timings, can get cook early game), though this wins quite a lot against it when spectating (if no Sniper/Viper).

- ***Key Scripts***
    - BOT Experiment (by Furiospuppy)
    - ExtremePush (https://github.com/insraq/dota2bots)
    - PhalanxBot (https://steamcommunity.com/sharedfiles/filedetails/?id=2873408973&searchtext=)

# Tinkering About
- ***Heroes (Pos: 1,2,3,4,5)***
    - Heroes can't be core or support in their possible roles; strictly core/supports; due to ability usage
    - ***Added***
        - [2,3] Timbersaw
        - [3] Mars
        - [2] Storm Spirit
        - [2] Ember Spirit
        - [1] Faceless Void
        - [1] Alchemist
        - [1] Terrorblade
        - [1] Ursa
        - [2] Void Spirit
        - [2] Earth Spirit
    - ***Changed***
        - [2] Necrophos
        - [2] Lina
        - [2] Queen Of Pain (buggy?)

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
    - ***Improve***
        - [ ] Some heroes ability usage
        - [ ] Item usage
    