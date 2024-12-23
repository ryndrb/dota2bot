# simple python script to make a neutral items table for a weighted distribution selection
# run from time to time
import requests

STRATZ_API_URL = "https://api.stratz.com/graphql"

headers = {
    "User-Agent": "STRATZ_API",
    "Authorization": "Bearer {KEY HERE}"
}

hero_query_template = """
{
  constants {
    heroes {
      id
      name
    }
  }
}
"""

item_query_template = """
{
  heroStats {
    itemNeutral(heroId: HERO_ID, bracketBasicIds: [DIVINE_IMMORTAL]) {
      itemId
      equippedMatchCount
      item {
        name
        stat {
          neutralItemTier
        }
      }
    }
  }
}
"""

# it keeps hitting the rate limit when trying to have it by positions (1+126*5) too using a default token, so it'll be just be a general one; for now anyway
def Fetch__GraphQL(query):
    response = requests.post(STRATZ_API_URL, json={"query": query}, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"FAIL with status code {response.status_code}: {response.text}")

# TODO: "fix" tier 5's
try:
    hero_data = Fetch__GraphQL(hero_query_template)
    heroes = hero_data["data"]["constants"]["heroes"]

    lua_table = "local hHeroList = {\n"

    for hero in heroes:
        hero_id = hero["id"]
        hero_name = hero["name"]

        print(f'At {hero_name} ..')

        item_query = item_query_template.replace("HERO_ID", str(hero_id))
        item_data = Fetch__GraphQL(item_query)

        items = item_data["data"]["heroStats"]["itemNeutral"]
        
        tier_data = {}
        for item in items:
            tier = item["item"]["stat"]["neutralItemTier"]
            if tier is None:
                continue
            if tier not in tier_data:
                tier_data[tier] = []
            tier_data[tier].append(item)
        
        lua_table += f"  ['{hero_name}'] = {{\n"
        
        for tier, tier_items in sorted(tier_data.items()):
            tier_items = sorted(tier_items, key=lambda item: item['equippedMatchCount'], reverse=True)
        
            total_matches = sum(item['equippedMatchCount'] for item in tier_items)
            if total_matches > 0:
                lua_table += f"    ['{tier}'] = {{"
                for item in tier_items:
                    item_name = item['item']['name']
                    match_count = item['equippedMatchCount']
                    pick_rate = (match_count / total_matches) * 100
                    lua_table += f"['{item_name}']={pick_rate:.2f}, "
                lua_table = lua_table.rstrip(", ") + "},\n"

        lua_table += "  },\n"

    lua_table += "}\n"
    lua_table += "return hHeroList\n"

    with open("ndata.lua", "w") as lua_file:
        lua_file.write(lua_table)

    print("'ndata.lua' has been generated!")
except Exception as e:
    print(f"Error: {e}")
