# simple python script to scrape matchup data from dotabuff
# run from time to time

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import time

hero_name_table = {
        "npc_dota_hero_abaddon": {
            "urlName": "abaddon",
            "visibleName": "Abaddon",
        },
        "npc_dota_hero_abyssal_underlord": {
            "urlName": "underlord",
            "visibleName": "Underlord",
        },
        "npc_dota_hero_alchemist": {
            "urlName": "alchemist",
            "visibleName": "Alchemist",
        },
        "npc_dota_hero_ancient_apparition": {
            "urlName": "ancient-apparition",
            "visibleName": "Ancinet Apparition",
        },
        "npc_dota_hero_antimage": {
            "urlName": "anti-mage",
            "visibleName": "Anti-Mage",
        },
        "npc_dota_hero_arc_warden": {
            "urlName": "arc-warden",
            "visibleName": "Arc Warden",
        },
        "npc_dota_hero_axe": {
            "urlName": "axe",
            "visibleName": "Axe",
        },
        "npc_dota_hero_bane": {
            "urlName": "bane",
            "visibleName": "Bane",
        },
        "npc_dota_hero_batrider": {
            "urlName": "batrider",
            "visibleName": "Batrider",
        },
        "npc_dota_hero_beastmaster": {
            "urlName": "beastmaster",
            "visibleName": "Beastmaster",
        },
        "npc_dota_hero_bloodseeker": {
            "urlName": "bloodseeker",
            "visibleName": "Bloodseeker",
        },
        "npc_dota_hero_bounty_hunter": {
            "urlName": "bounty-hunter",
            "visibleName": "Bounty Hunter",
        },
        "npc_dota_hero_brewmaster": {
            "urlName": "brewmaster",
            "visibleName": "Brewmaster",
        },
        "npc_dota_hero_bristleback": {
            "urlName": "bristleback",
            "visibleName": "Bristleback",
        },
        "npc_dota_hero_broodmother": {
            "urlName": "broodmother",
            "visibleName": "Broodmother",
        },
        "npc_dota_hero_centaur": {
            "urlName": "centaur-warrunner",
            "visibleName": "Centaur Warrunner",
        },
        "npc_dota_hero_chaos_knight": {
            "urlName": "chaos-knight",
            "visibleName": "Chaos Knight",
        },
        "npc_dota_hero_chen": {
            "urlName": "chen",
            "visibleName": "Chen",
        },
        "npc_dota_hero_clinkz": {
            "urlName": "clinkz",
            "visibleName": "Clinkz",
        },
        "npc_dota_hero_crystal_maiden": {
            "urlName": "crystal-maiden",
            "visibleName": "Crystal Maiden",
        },
        "npc_dota_hero_dark_seer": {
            "urlName": "dark-seer",
            "visibleName": "Dark Seer",
        },
        "npc_dota_hero_dark_willow": {
            "urlName": "dark-willow",
            "visibleName": "Dark Willow",
        },
        "npc_dota_hero_dawnbreaker": {
            "urlName": "dawnbreaker",
            "visibleName": "Dawnbreaker",
        },
        "npc_dota_hero_dazzle": {
            "urlName": "dazzle",
            "visibleName": "Dazzle",
        },
        "npc_dota_hero_disruptor": {
            "urlName": "disruptor",
            "visibleName": "Disruptor",
        },
        "npc_dota_hero_death_prophet": {
            "urlName": "death-prophet",
            "visibleName": "Death Prophet",
        },
        "npc_dota_hero_doom_bringer": {
            "urlName": "doom",
            "visibleName": "Doom",
        },
        "npc_dota_hero_dragon_knight": {
            "urlName": "dragon-knight",
            "visibleName": "Dragon Knight",
        },
        "npc_dota_hero_drow_ranger": {
            "urlName": "drow-ranger",
            "visibleName": "Drow Ranger",
        },
        "npc_dota_hero_earth_spirit": {
            "urlName": "earth-spirit",
            "visibleName": "Earth Spirit",
        },
        "npc_dota_hero_earthshaker": {
            "urlName": "earthshaker",
            "visibleName": "Earthshaker",
        },
        "npc_dota_hero_elder_titan": {
            "urlName": "elder-titan",
            "visibleName": "Elder Titan",
        },
        "npc_dota_hero_ember_spirit": {
            "urlName": "ember-spirit",
            "visibleName": "Ember Spirit",
        },
        "npc_dota_hero_enchantress": {
            "urlName": "enchantress",
            "visibleName": "Enchantress",
        },
        "npc_dota_hero_enigma": {
            "urlName": "enigma",
            "visibleName": "Enigma",
        },
        "npc_dota_hero_faceless_void": {
            "urlName": "faceless-void",
            "visibleName": "Faceless Void",
        },
        "npc_dota_hero_furion": {
            "urlName": "natures-prophet",
            "visibleName": "Nature's Prophet",
        },
        "npc_dota_hero_grimstroke": {
            "urlName": "grimstroke",
            "visibleName": "Grimstroke",
        },
        "npc_dota_hero_gyrocopter": {
            "urlName": "gyrocopter",
            "visibleName": "Gyrocopter",
        },
        "npc_dota_hero_hoodwink": {
            "urlName": "hoodwink",
            "visibleName": "Hoodwink",
        },
        "npc_dota_hero_huskar": {
            "urlName": "huskar",
            "visibleName": "Huskar",
        },
        "npc_dota_hero_invoker": {
            "urlName": "invoker",
            "visibleName": "Invoker",
        },
        "npc_dota_hero_jakiro": {
            "urlName": "jakiro",
            "visibleName": "Jakiro",
        },
        "npc_dota_hero_juggernaut": {
            "urlName": "juggernaut",
            "visibleName": "Juggernaut",
        },
        "npc_dota_hero_keeper_of_the_light": {
            "urlName": "keeper-of-the-light",
            "visibleName": "Keeper of the Light",
        },
        "npc_dota_hero_kez": {
            "urlName": "kez",
            "visibleName": "Kez",
        },
        "npc_dota_hero_kunkka": {
            "urlName": "kunkka",
            "visibleName": "Kunkka",
        },
        "npc_dota_hero_legion_commander": {
            "urlName": "legion-commander",
            "visibleName": "Legion Commander",
        },
        "npc_dota_hero_leshrac": {
            "urlName": "leshrac",
            "visibleName": "Leshrac",
        },
        "npc_dota_hero_lich": {
            "urlName": "lich",
            "visibleName": "Lich",
        },
        "npc_dota_hero_life_stealer": {
            "urlName": "lifestealer",
            "visibleName": "Lifestealer",
        },
        "npc_dota_hero_lina": {
            "urlName": "lina",
            "visibleName": "Lina",
        },
        "npc_dota_hero_lion": {
            "urlName": "lion",
            "visibleName": "Lion",
        },
        "npc_dota_hero_lone_druid": {
            "urlName": "lone-druid",
            "visibleName": "Lone Druid",
        },
        "npc_dota_hero_luna": {
            "urlName": "luna",
            "visibleName": "Luna",
        },
        "npc_dota_hero_lycan": {
            "urlName": "lycan",
            "visibleName": "Lycan",
        },
        "npc_dota_hero_magnataur": {
            "urlName": "magnus",
            "visibleName": "Magnus",
        },
        "npc_dota_hero_marci": {
            "urlName": "marci",
            "visibleName": "Marci",
        },
        "npc_dota_hero_mars": {
            "urlName": "mars",
            "visibleName": "Mars",
        },
        "npc_dota_hero_medusa": {
            "urlName": "medusa",
            "visibleName": "Medusa",
        },
        "npc_dota_hero_meepo": {
            "urlName": "meepo",
            "visibleName": "Meepo",
        },
        "npc_dota_hero_mirana": {
            "urlName": "mirana",
            "visibleName": "Mirana",
        },
        "npc_dota_hero_morphling": {
            "urlName": "morphling",
            "visibleName": "Morphling",
        },
        "npc_dota_hero_muerta": {
            "urlName": "muerta",
            "visibleName": "Muerta",
        },
        "npc_dota_hero_monkey_king": {
            "urlName": "monkey-king",
            "visibleName": "Monkey King",
        },
        "npc_dota_hero_naga_siren": {
            "urlName": "naga-siren",
            "visibleName": "Naga Siren",
        },
        "npc_dota_hero_necrolyte": {
            "urlName": "necrophos",
            "visibleName": "Necrophos",
        },
        "npc_dota_hero_nevermore": {
            "urlName": "shadow-fiend",
            "visibleName": "Shadow Fiend",
        },
        "npc_dota_hero_night_stalker": {
            "urlName": "night-stalker",
            "visibleName": "Night Stalker",
        },
        "npc_dota_hero_nyx_assassin": {
            "urlName": "nyx-assassin",
            "visibleName": "Nyx Assassin",
        },
        "npc_dota_hero_obsidian_destroyer": {
            "urlName": "outworld-destroyer",
            "visibleName": "Outworld Destroyer",
        },
        "npc_dota_hero_ogre_magi": {
            "urlName": "ogre-magi",
            "visibleName": "Ogre Magi",
        },
        "npc_dota_hero_omniknight": {
            "urlName": "omniknight",
            "visibleName": "Omniknight",
        },
        "npc_dota_hero_oracle": {
            "urlName": "oracle",
            "visibleName": "Oracle",
        },
        "npc_dota_hero_pangolier": {
            "urlName": "pangolier",
            "visibleName": "Pangolier",
        },
        "npc_dota_hero_phantom_lancer": {
            "urlName": "phantom-lancer",
            "visibleName": "Phantom Lancer",
        },
        "npc_dota_hero_phantom_assassin": {
            "urlName": "phantom-assassin",
            "visibleName": "Phantom Assassin",
        },
        "npc_dota_hero_phoenix": {
            "urlName": "phoenix",
            "visibleName": "Phoenix",
        },
        "npc_dota_hero_primal_beast": {
            "urlName": "primal-beast",
            "visibleName": "Primal Beast",
        },
        "npc_dota_hero_puck": {
            "urlName": "puck",
            "visibleName": "Puck",
        },
        "npc_dota_hero_pudge": {
            "urlName": "pudge",
            "visibleName": "Pudge",
        },
        "npc_dota_hero_pugna": {
            "urlName": "pugna",
            "visibleName": "Pugna",
        },
        "npc_dota_hero_queenofpain": {
            "urlName": "queen-of-pain",
            "visibleName": "Queen of Pain",
        },
        "npc_dota_hero_rattletrap": {
            "urlName": "clockwerk",
            "visibleName": "Clockwerk",
        },
        "npc_dota_hero_razor": {
            "urlName": "razor",
            "visibleName": "Razor",
        },
        "npc_dota_hero_riki": {
            "urlName": "riki",
            "visibleName": "Riki",
        },
        "npc_dota_hero_ringmaster": {
            "urlName": "ringmaster",
            "visibleName": "Ringmaster",
        },
        "npc_dota_hero_rubick": {
            "urlName": "rubick",
            "visibleName": "Rubick",
        },
        "npc_dota_hero_sand_king": {
            "urlName": "sand-king",
            "visibleName": "Sand King",
        },
        "npc_dota_hero_shadow_demon": {
            "urlName": "shadow-demon",
            "visibleName": "Shadow Demon",
        },
        "npc_dota_hero_shadow_shaman": {
            "urlName": "shadow-shaman",
            "visibleName": "Shadow Shaman",
        },
        "npc_dota_hero_shredder": {
            "urlName": "timbersaw",
            "visibleName": "Timbersaw",
        },
        "npc_dota_hero_silencer": {
            "urlName": "silencer",
            "visibleName": "Silencer",
        },
        "npc_dota_hero_skeleton_king": {
            "urlName": "wraith-king",
            "visibleName": "Wraith King",
        },
        "npc_dota_hero_skywrath_mage": {
            "urlName": "skywrath-mage",
            "visibleName": "Skywrath Mage",
        },
        "npc_dota_hero_slardar": {
            "urlName": "slardar",
            "visibleName": "Slardar",
        },
        "npc_dota_hero_slark": {
            "urlName": "slark",
            "visibleName": "Slark",
        },
        "npc_dota_hero_snapfire": {
            "urlName": "snapfire",
            "visibleName": "Snapfire",
        },
        "npc_dota_hero_sniper": {
            "urlName": "sniper",
            "visibleName": "Sniper",
        },
        "npc_dota_hero_spectre": {
            "urlName": "spectre",
            "visibleName": "Spectre",
        },
        "npc_dota_hero_spirit_breaker": {
            "urlName": "spirit-breaker",
            "visibleName": "Spirit Breaker",
        },
        "npc_dota_hero_storm_spirit": {
            "urlName": "storm-spirit",
            "visibleName": "Storm Spirit",
        },
        "npc_dota_hero_sven": {
            "urlName": "sven",
            "visibleName": "Sven",
        },
        "npc_dota_hero_techies": {
            "urlName": "techies",
            "visibleName": "Techies",
        },
        "npc_dota_hero_terrorblade": {
            "urlName": "terrorblade",
            "visibleName": "Terrorblade",
        },
        "npc_dota_hero_templar_assassin": {
            "urlName": "templar-assassin",
            "visibleName": "Templar Assassin",
        },
        "npc_dota_hero_tidehunter": {
            "urlName": "tidehunter",
            "visibleName": "Tidehunter",
        },
        "npc_dota_hero_tinker": {
            "urlName": "tinker",
            "visibleName": "Tinker",
        },
        "npc_dota_hero_tiny": {
            "urlName": "tiny",
            "visibleName": "Tiny",
        },
        "npc_dota_hero_treant": {
            "urlName": "treant-protector",
            "visibleName": "Treant Protector",
        },
        "npc_dota_hero_troll_warlord": {
            "urlName": "troll-warlord",
            "visibleName": "Troll Warlord",
        },
        "npc_dota_hero_tusk": {
            "urlName": "tusk",
            "visibleName": "Tusk",
        },
        "npc_dota_hero_undying": {
            "urlName": "undying",
            "visibleName": "Undying",
        },
        "npc_dota_hero_ursa": {
            "urlName": "ursa",
            "visibleName": "Ursa",
        },
        "npc_dota_hero_vengefulspirit": {
            "urlName": "vengeful-spirit",
            "visibleName": "Vengeful Spirit",
        },
        "npc_dota_hero_venomancer": {
            "urlName": "venomancer",
            "visibleName": "Venomancer",
        },
        "npc_dota_hero_viper": {
            "urlName": "viper",
            "visibleName": "Viper",
        },
        "npc_dota_hero_visage": {
            "urlName": "visage",
            "visibleName": "Visage",
        },
        "npc_dota_hero_void_spirit": {
            "urlName": "void-spirit",
            "visibleName": "Void Spirit",
        },
        "npc_dota_hero_warlock": {
            "urlName": "warlock",
            "visibleName": "Warlock",
        },
        "npc_dota_hero_weaver": {
            "urlName": "weaver",
            "visibleName": "Weaver",
        },
        "npc_dota_hero_windrunner": {
            "urlName": "windranger",
            "visibleName": "Windranger",
        },
        "npc_dota_hero_winter_wyvern": {
            "urlName": "winter-wyvern",
            "visibleName": "Winter Wyvern",
        },
        "npc_dota_hero_wisp": {
            "urlName": "io",
            "visibleName": "Io",
        },
        "npc_dota_hero_witch_doctor": {
            "urlName": "witch-doctor",
            "visibleName": "Witch Doctor",
        },
        "npc_dota_hero_zuus": {
            "urlName": "zeus",
            "visibleName": "Zeus",
        },
}

visible_to_internal = {
    data["visibleName"].lower(): internal
    for internal, data in hero_name_table.items()
}

def GetHeroCounters(hero_url_name):
    # past 12 months
    url = f"https://www.dotabuff.com/heroes/{hero_url_name}/counters?date=year"
    
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--disable-gpu")
    driver = webdriver.Chrome(options=options)
    driver.get(url)
    
    time.sleep(5)
    soup = BeautifulSoup(driver.page_source, "html.parser")
    driver.quit()
    
    counter_table = soup.find("table", {"class": "sortable"})
    if not counter_table:
        print(f"No counter table found for {hero_url_name}.")
        return {}
    
    counters = {}
    rows = counter_table.find_all("tr")
    
    for row in rows[1:]:
        cols = row.find_all("td")
        if len(cols) >= 3:
            hero = cols[1].get_text(strip=True).lower()
            advantage = cols[2].get_text(strip=True).replace("%", "")
            try:
                advantage = float(advantage)
                internal_name = visible_to_internal.get(hero)
                if internal_name:
                    counters[internal_name] = advantage
            except ValueError:
                continue
    
    return counters

matchup_dict = {}

try:
    # fetch
    for internal_name, data in hero_name_table.items():
        print(f"Fetching counters for {internal_name}...")
        counters = GetHeroCounters(data["urlName"])
        if counters:
            matchup_dict[internal_name] = counters
        else:
            print(f"No counters found for {internal_name}.")

    # generate lua file
    with open("matchups.lua", "w", encoding="utf-8") as lua_file:
        lua_file.write("-----\n-- This file is generated by bots/Buff/script/matchups.py\n-----\n\n")
        lua_file.write("local heroList = {\n")
        for hero, counter_dict in matchup_dict.items():
            lua_file.write(f"    ['{hero}'] = {{\n")
            for counterHero, advantage in counter_dict.items():
                lua_file.write(f"        ['{counterHero}'] = {advantage},\n")
            lua_file.write("    },\n")
        lua_file.write("}\n\nreturn heroList\n")

    print("matchups.lua has been generated!")
except Exception as e:
    print(f"Error: {e}")
