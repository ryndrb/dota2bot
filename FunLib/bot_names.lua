local U = require( GetScriptDirectory()..'/FunLib/lua_util' )

local X = {}

-- only relevant team rosters

local tProTeams = {
    [27] = {
        ['team_org'] = 'Alliance',
        ['alias'] = 'Alliance',
        ['rosters'] = {
            [1] = {"Loda", "s4", "AdmiralBulldog", "EGM", "Akke"},
            [2] = {"miCKe", "qojqva", "Boxi", "Taiga", "iNSaNiA"},
            [3] = {"Nikobaby", "LIMMP", "s4", "Handsken", "fng"},
        }
    },
    [34] = {
        ['team_org'] = 'Team Aster',
        ['alias'] = 'Aster',
        ['rosters'] = {
            [1] = {"Monet", "Ori", "Xxs", "BoBoKa", "皮球"},
            [2] = {"Monet", "SumaiL", "Xxs", "Kaka", "皮球"},
        }
    },
    [1] = {
        ['team_org'] = 'Aurora',
        ['alias'] = 'Aurora',
        ['rosters'] = {
            [1] = {"23", "lorenof", "Jabz", "Q", "Oli"},
            [2] = {"23savage", "lorenof", "Jabz", "Q", "Oli"},
        }
    },
    [2] = {
        ['team_org'] = 'Azure Ray',
        ['alias'] = 'AR',
        ['rosters'] = {
            [1] = {"Lou", "Somnus", "chalice", "fy", "天命"},
            [2] = {"Lou", "XM", "Xxs", "XinQ", "天命"},
            [3] = {"Lou", "Ori", "Bach", "fy", "天命"},
        }
    },
    [3] = {
        ['team_org'] = 'beastcoast',
        ['alias'] = 'bc',
        ['rosters'] = {
            [1] = {"K1", "Chris Luck", "Wisper", "Scofied", "Stinger"},
            [2] = {"Parker", "DarkMago♡", "Sacred", "Scofield", "Stinger"},
        }
    },
    [4] = {
        ['team_org'] = 'BetBoom Team',
        ['alias'] = 'BetBoom',
        ['rosters'] = {
            [1] = {"Nightfall", "gpk-", "Pure", "Save-", "TORONTOTOKYO"},
            [2] = {"Nightfall", "gpk-", "MieRo`", "Save-", "TORONTOTOKYO"},
            [3] = {"Saika", "gpk-", "MieRo`", "Save-", "TORONTOTOKYO"},
            [4] = {"Pure", "kiyotaka", "MieRo`", "Save-", "Kataomi`"},
            [5] = {"Pure", "gpk-", "MieRo`", "Save-", "Kataomi`"},
        }
    },
    [5] = {
        ['team_org'] = 'Boom Esports',
        ['alias'] = 'Boom',
        ['rosters'] = {
            [1] = {"JaCkky", "Yopaj-", "Fbz", "TIMS", "skem"},
            [2] = {"Pakazs", "DarkMago♡", "Sacred", "Mathew", "Yadomi"},
        }
    },
    [32] = {
        ['team_org'] = 'CDEC Gaming',
        ['alias'] = 'CDEC',
        ['rosters'] = {
            [1] = {"Agressif", "Shiki", "Xz", "Garder", "Q"},
        }
    },
    [6] = {
        ['team_org'] = 'Cloud Nine',
        ['alias'] = 'C9',
        ['rosters'] = {
            [1] = {"EternaLEnVy", "FATA-", "MSS", "Aui_2000", "pieliedie"},
            [2] = {"EternaLEnVy", "Ace♠", "Sneyking", "MISERY", "pieliedie"},
            [3] = {"医者watson`", "No[o]ne-", "DM", "Kataomi`", "Fishman"},
        }
    },
    [33] = {
        ['team_org'] = 'Digital Chaos',
        ['alias'] = 'DC',
        ['rosters'] = {
            [1] = {"Resolut1on", "w33", "Moo", "Saksa", "MiSeRy"},
        }
    },
    [30] = {
        ['team_org'] = 'EHOME',
        ['alias'] = 'EHOME',
        ['rosters'] = {
            [1] = {"820", "QQQ", "X!!", "LaNm", "SJQ"},
        }
    },
    [7] = {
        ['team_org'] = 'Entity',
        ['alias'] = 'Entity',
        ['rosters'] = {
            [1] = {"Pure", "Stormstormer", "Tobi", "Kataomi`", "Fishman"},
            [2] = {"医者watson`", "Stormstormer", "Gabbi", "Kataomi`", "Fishman"},
            [3] = {"医者watson`", "No[o]ne-", "DM", "Kataomi`", "Fishman"},
        }
    },
    [8] = {
        ['team_org'] = 'Evil Geniuses',
        ['alias'] = 'EG',
        ['rosters'] = {
            [1] = {"mason", "Arteezy", "UNiVeRsE", "zai", "ppd"},
            [2] = {"Fear", "SumaiL", "UNiVeRsE", "Aui_2000", "ppd"},
            [3] = {"Fear", "SumaiL", "UNiVeRsE", "zai", "ppd"},
            [4] = {"rtz", "SumaiL", "UNiVeRsE", "zai", "Cr1t-"},
            [5] = {"rtz", "SumaiL", "s4", "Cr1t-", "Fly"},
            [6] = {"天鸽", "Abed", "iceiceice", "Cr1t-", "Fly"},
            [7] = {"天鸽", "Abed", "Nightfall", "Cr1t-", "Fly"},
            [8] = {"Pakazs", "C.smile <", "Wisper", "Mathew", "Panda"},
        }
    },
    [36] = {
        ['team_org'] = 'Fnatic',
        ['alias'] = 'Fnatic',
        ['rosters'] = {
            [1] = {"EternaLEnVy", "Abed", "UNiVeRsE", "DJ", "pieliedie"},
            [2] = {"Jabz", "Abed", "iceiceice", "DJ", "DuBu"},
        }
    },
    [9] = {
        ['team_org'] = 'Invictus Gaming',
        ['alias'] = 'iG',
        ['rosters'] = {
            [1] = {"Zhou", "Ferrari_430", "YYF", "ChuaN", "Faith"},
            [2] = {"flyfly", "Emo", "JT-", "Kaka", "Oli"},
            [3] = {"Monet", "NothingToSay", "JT-", "BoBoKa", "xNova"},
        }
    },
    [10] = {
        ['team_org'] = 'Gaimin Gladiators',
        ['alias'] = 'GG',
        ['rosters'] = {
            [1] = {"dyrachyo", "BOOM", "Ace", "tOfu", "Seleri"},
            [2] = {"dyrachyo", "Quinn", "Ace", "tOfu", "Seleri"},
            [3] = {"医者watson`", "Quinn", "Ace", "tOfu", "Seleri"},
        }
    },
    [11] = {
        ['team_org'] = 'HEROIC',
        ['alias'] = 'HEROIC',
        ['rosters'] = {
            [1] = {"K1", "4nalog <01", "Davai Lama", "Scofield", "KJ"},
            [2] = {"ɹǝʞɹɐd", "4nalog <01", "Davai Lama", "Scofield", "KJ"},
            [2] = {"Yuma", "4nalog", "Wisper", "Scofield", "KJ"},
        }
    },
    [12] = {
        ['team_org'] = 'Natus Vincere',
        ['alias'] = "Na'Vi",
        ['rosters'] = {
            [1] = {"ArtStyle", "Dendi", "XBOCT", "Puppey", "LighTofHeaveN"},
            [2] = {"XBOCT", "Dendi", "LighTofHeaveN", "Puppey", "ARS-ART"},
            [3] = {"XBOCT", "Dendi", "Funn1k", "Puppey", "KuroKy"},
        }
    },
    [28] = {
        ['team_org'] = 'Newbee',
        ['alias'] = 'Newbee',
        ['rosters'] = {
            [1] = {"Hao", "Mu", "xiao8", "Banana", "SanSheng"},
            [2] = {"Moogy", "Sccc", "kpii", "Kaka", "Faith"},
            [3] = {"YawaR", "CCnC", "Sneyking", "MSS", "pieliedie"},
        }
    },
    [13] = {
        ['team_org'] = 'Nigma Galaxy',
        ['alias'] = 'Nigma',
        ['rosters'] = {
            [1] = {"Miracle-", "w33", "MinD_ContRoL", "Gh", "KuroKy"},
            [2] = {"iLTW", "Miracle-", "MinD_ContRoL", "Gh", "KuroKy"},
            [3] = {"Miracle-", "SumaiL", "MinD_ContRoL", "Gh", "KuroKy"},
            [4] = {"AMMAR_THE_F", "SumaiL", "MinD_ContRoL", "Gh", "KuroKy"},
            [5] = {"Miracle-", "SumaiL", "Fbz", "Gh", "KuroKy"},
            [6] = {"Miracle-", "SumaiL", "No!ob", "OmaR", "GH"},
        }
    },
    [14] = {
        ['team_org'] = 'nouns esports',
        ['alias'] = 'nouns',
        ['rosters'] = {
            [1] = {"Costabile", "Gunnar", "Moo", "ZfreeK", "Husky"},
            [2] = {"K1", "Gunnar", "Moo", "Lelis", "Yamsum"},
            [3] = {"Yuma", "copiwra", "Gunnar", "Lelis", "Fly"},
        }
    },
    [15] = {
        ['team_org'] = 'OG Esports',
        ['alias'] = 'OG',
        ['rosters'] = {
            [1] = {"N0tail", "Miracle-", "MoonMeander", "Cr1t-", "Fly"},
            [2] = {"N0tail", "ana", "s4", "JerAx", "Fly"},
            [3] = {"ana.bit", "Topson", "Ceb", "JerAx", "N0tail"},
            [4] = {"SumaiL", "Topson", "Ceb", "Saksa", "N0tail"},
            [5] = {"Yuragi", "bzm", "AMMAR_THE_F", "Taiga", "Misha"},
            [6] = {"Timado", "bzm", "Wisper", "Ari", "Ceb"},
        }
    },
    [16] = {
        ['team_org'] = 'PSG Esports',
        ['alias'] = 'PSG',
        ['rosters'] = {
            [1] = {"LGD.Ame^^", "LGD.Somnus丶M", "LGD.Chalice", "LGD.fy", "LGD.xNova"},
            [2] = {"LGD.萧瑟", "LGD.Somnus丶M", "LGD.Chalice", "LGD.fy", "LGD.xNova"},
            [3] = {"LGD.萧瑟", "LGD.NothingToSay", "LGD.Faith_bian", "LGD.XinQ", "LGD.y`"},
            [4] = {"LGD.shiro", "LGD.NothingToSay", "LGD.niu", "LGD.planet", "LGD.y`"},
            [5] = {"Quest.TA2000", "Quest.No!ob", "Quest.Malik", "Quest.OmaR", "Quest.Dukalis"},
        }
    },
    [17] = {
        ['team_org'] = 'Quincy Crew',
        ['alias'] = 'QC',
        ['rosters'] = {
            [1] = {"YawaR", "Quinn", "Lelis", "MSS", "Fata"},
            [2] = {"YawaR", "Quinn", "LESLÃO", "MSS", "Fata"},
        }
    },
    [18] = {
        ['team_org'] = 'Shopify Rebellion',
        ['alias'] = 'SR',
        ['rosters'] = {
            [1] = {"天鸽", "Abed", "SabeRLight-", "Cr1t-", "Fly"},
            [2] = {"天鸽", "Yopaj-", "SabeRLight", "Thiolicor", "Kitrak"},
            [3] = {"天鸽", "Yopaj-", "MinD_ContRoL", "Kitrak", "skem"},
        }
    },
    [19] = {
        ['team_org'] = 'T1',
        ['alias'] = 'T1',
        ['rosters'] = {
            [1] = {"23savage", "Karl", "Kuku", "Xepher", "Whitemon"},
            [2] = {"ana", "Topson", "Kuku", "Xepher", "Whitemon"},
        }
    },
    [20] = {
        ['team_org'] = 'Talon Esports',
        ['alias'] = 'Talon',
        ['rosters'] = {
            [1] = {"23savage", "Mikoto", "kpii", "Q", "Hyde"},
            [2] = {"23savage", "Mikoto", "Jabz", "Q", "Oli"},
            [3] = {"Natsumi", "Mikoto", "Ws", "Jhocam", "Kuku"},
        }
    },
    [35] = {
        ['team_org'] = 'Team DK',
        ['alias'] = 'DK',
        ['rosters'] = {
            [1] = {"BurNIng", "Super", "rOtk", "QQQ", "MMY!"},
            [2] = {"BurNIng", "Mushi", "iceiceice", "LaNm", "MMY!"},
        }
    },
    [37] = {
        ['team_org'] = 'Team Falcons',
        ['alias'] = 'FLCN',
        ['rosters'] = {
            [1] = {"skiter", "Malr1ne", "AMMAR_THE_F", "Cr1t-", "Sneyking"},
        }
    },
    [21] = {
        ['team_org'] = 'Team Liquid',
        ['alias'] = 'Liquid',
        ['rosters'] = {
            [1] = {"MATUMBAMAN", "FATA-", "MinD_ContRoL", "JerAx", "KuroKy"},
            [2] = {"MATUMBAMAN", "Miracle-", "MinD_ContRoL", "GH", "KuroKy"},
            [3] = {"Miracle-", "w33", "MinD_ContRoL", "Gh", "KuroKy"},
            [4] = {"miCKe", "qojqva", "Boxi", "Taiga", "iNSaNiA"},
            [5] = {"MATUMBAMAN", "miCKe", "zai", "Boxi", "iNSaNiA"},
            [6] = {"miCKe", "Nisha", "zai", "Boxi", "iNSaNiA"},
            [7] = {"miCKe", "Nisha", "33", "Boxi", "iNSaNiA"},
            [8] = {"miCKe", "Nisha", "SabeRLight", "Boxi", "iNSaNiA"},
        }
    },
    [22] = {
        ['team_org'] = 'Team Secret',
        ['alias'] = 'Secret',
        ['rosters'] = {
            [1] = {"KuroKy", "s4", "Simbaaa", "Puppey", "BigDaddy"},
            [2] = {"Arteezy", "s4", "zai", "Puppey", "KuroKy"},
            [3] = {"Arteezy", "EternaLEnVy", "BuLba", "Puppey", "pieliedie"},
            [4] = {"Ace", "MidOne", "Fata", "YapzOr", "Puppey"},
            [5] = {"Nisha", "MidOne", "zai", "YapzOr", "Puppey"},
            [6] = {"MATUMBAMAN", "Nisha", "zai", "YapzOr", "Puppey"},
            [7] = {"Crystallis", "Nisha", "Resolut1on", "Zayac", "Puppey"},
        }
    },
    [23] = {
        ['team_org'] = 'Team Spirit',
        ['alias'] = 'TSpirit',
        ['rosters'] = {
            [1] = {"Yatoro雨", "TORONTOTOKYO", "Collapse", "Mira", "Miposhka"},
            [2] = {"YATOROGOD雨", "TORONTOTOKYO", "Collapse", "Mira", "Miposhka"},
            [3] = {"Yatoro雨", "Larl", "Collapse", "Mira", "Miposhka"},
            [4] = {"Raddan", "Larl", "Collapse", "Mira", "Miposhka"},
            [5] = {"Satanic", "Larl", "Malik", "Rue", "Miposhka"},
        }
    },
    [24] = {
        ['team_org'] = 'Tundra Esports',
        ['alias'] = 'Tundra',
        ['rosters'] = {
            [1] = {"skiter", "Nine", "33", "Sneyking", "Fata"},
            [2] = {"skiter", "Nine", "33", "Saksa", "Sneyking"},
            [3] = {"skiter", "Topson", "33", "Nine", "Sneyking"},
            [4] = {"Pure~", "Topson", "RAMZES666", "9Class", "Whitemon"},
            [5] = {"Nightfall", "lorenof", "33", "Saksa", "Whitemon"},
            [6] = {"dyrachyo", "bzm", "33", "Saksa", "Whitemon"},
        }
    },
    [25] = {
        ['team_org'] = 'Virtus.pro',
        ['alias'] = 'VP',
        ['rosters'] = {
            [1] = {"RAMZES666", "No[o]ne", "9Pasha", "Lil", "Solo"},
            [2] = {"RAMZES666", "No[o]ne", "9Pasha", "RodjER", "Solo"},
            [3] = {"Nightfall", "gpk", "DM", "Save-", "Kingslayer"},
        }
    },
    [31] = {
        ['team_org'] = 'Vici Gaming',
        ['alias'] = 'VG',
        ['rosters'] = {
            [1] = {"Sylar", "Super", "rOtk", "Fenrir", "fy"},
        }
    },
    [29] = {
        ['team_org'] = 'Wings Gaming',
        ['alias'] = 'Wings',
        ['rosters'] = {
            [1] = {"shadow", "bLink", "Faith_bian", "y`", "iceice"},
        }
    },
    [26] = {
        ['team_org'] = 'Xtreme Gaming',
        ['alias'] = 'XG',
        ['rosters'] = {
            [1] = {"Ame", "Xm", "Xxs", "XinQ", "Dy"},
        }
    },
    [38] = {
        ['team_org'] = 'PARIVISION',
        ['alias'] = 'PARIVISION',
        ['rosters'] = {
            [1] = {"Crystallis", "No[o]ne-", "DM", "9Class", "Dukalis"},
            [2] = {"Satanic", "No[o]ne-", "DM", "9Class", "Dukalis"},
        }
    },
    [39] = {
        ['team_org'] = 'AVULUS',
        ['alias'] = 'AVULUS',
        ['rosters'] = {
            [1] = {"Smiling Knight", "Stormstormer", "Xibbe", "Ekki", "SoNNeikO"},
        }
    },
}

local G2 = {"Monet", "NothingToSay", "JT-", "BoBoKa", "xNova"}

local tKanjis = {
    "あ", "い", "う", "え", "お",
    "か", "き", "く", "け", "こ",
    "さ", "し", "す", "せ", "そ",
    "た", "ち", "つ", "て", "と",
    "な", "に", "ぬ", "ね", "の",
    "は", "ひ", "ふ", "へ", "ほ",
    "ま", "み", "む", "め", "も",
    "や", "ゆ", "よ",
    "ら", "り", "る", "れ", "ろ",
    "わ", "を", "ん"
}

function X.GetBotNames()
    local names = {}

    local rep = tKanjis[RandomInt(1, #tKanjis)]
    local idx = RandomInt(1, #tProTeams)
    if GetTeam() == TEAM_RADIANT
    then while idx % 2 ~= 0 do idx = RandomInt(1, #tProTeams) end
    else while idx % 2 ~= 1 do idx = RandomInt(1, #tProTeams) end end

    local team = tProTeams[idx]
    local currTeam = team['rosters'][RandomInt(1, #team['rosters'])]

    -- pos 2, 3, 1, 5, 4
    currTeam[1], currTeam[2] = currTeam[2], currTeam[1]
    currTeam[2], currTeam[3] = currTeam[3], currTeam[2]
    currTeam[4], currTeam[5] = currTeam[5], currTeam[4]

    for _, pName in pairs(currTeam)
    do
        if U.tablesEqual(currTeam, G2)
        then
            table.insert(names, 'G2.'..team['alias']..'.'..pName..'.'..rep..'TA')
        else
            table.insert(names, team['alias']..'.'..pName..'.'..rep..'TA')
        end
    end

    return names
end

return X