Config = {
    -- Time and weather sync (disable if you have your own solution)
    ENV_SYNC = true,
    -- Hide Radar
    HIDE_RADAR = true,
    -- First person only
    FIRST_PERSON_LOCK = true,
    -- Enable blackout
    ENABLE_BLACKOUT = false,
    -- Enable or disable AI peds.
    ENABLE_PEDS = false,
    -- Enable or disable AI traffic.
    ENABLE_TRAFFIC = false,
}

Config.Spawning = {
    -- Min distance between players to decide one "host"
    HOST_DECIDE_DIST = 200.0,
    -- Set the default spawnpoints when joining the server.
    SPAWN_POINTS = {
        {x = -1041.74, y = -2744.13, z = 21.36},
        {x = -1158.01, y = -2035.35, z = 13.17},
        {x = 774.52, y = -3196.33, z = 5.90},
        {x = 278.12, y = -3219.67, z = 5.79},
        {x = -1207.2, y = -1796.74, z = 3.91},
        {x = -2542.0256, y = 2341.4169, z = 33.059909},
        {x = -2328.2419, y = 3245.5944, z = 33.0539665},
        {x = 2853.88, y = 1574.5, z = 24.57},
        {x = 2662.8, y = 1445.18, z = 20.97},
        {x = 2945.86, y = 2746.16, z = 43.3},
        {x = 3724.9, y = 4517.88, z = 20.96},
        {x = 3319.43, y = 5170.69, z = 18.44},
        {x = 1459.32, y = 6547.12, z = 14.63},
        {x = 1718.77, y = 6421.56, z = 33.37},
        {x = 402.45, y = 6630.64, z = 28.24},
        {x = 1511.46, y = 6334.95, z = 23.98},
        {x = 41.62, y = 3663.17, z = 39.55},
        {x = 374.1, y = 3582.86, z = 33.29},
        {x = 1968.7, y = 5178.15, z = 47.85}
    },
    -- Set this to true or false to switch between MP or SP skins.
    MULTIPLAYER_MODEL = false,
    -- Set the single player models that players can spawn with.
    SP_MODELS = {
        "a_m_y_vinewood_01", "a_m_m_bevhills_02", "a_m_m_mexlabor_01", "g_m_y_strpunk_02", "a_m_y_genstreet_01"
    },
    -- Set the default weapons for each player
    DEFAULT_WEAPONS = {
        "WEAPON_PISTOL", "WEAPON_HAMMER"
    }
}

Config.Spawning.Zombies = {
    -- Max amount of spawned zombies at once by you
    MAX_AMOUNT = 75,
    -- Chance a zombie receives a special attributes (per attribute, 0 - 100)
    ATTR_CHANCE = 25,
    -- Max Health
    MAX_HEALTH = 300,
    -- Max Armor
    MAX_ARMOR = 200,
    -- The speed at which zombies are walking towards enemies
    WALK_SPEED = 1.0,
    -- Enable zombie sounds
    ENABLE_SOUNDS = true,
    -- Min spawn distance
    MIN_SPAWN_DISTANCE = 100.0,
    -- Despawn distance (should always be at least 2x min spawn distance)
    DESPAWN_DISTANCE = 200.0,
    -- Model of zombies
    -- TODO: List of models
    ZOMBIE_MODEL = "u_m_y_zombie_01"
}

Config.Spawning.Safezones = {
    -- Min distance to safezone to spawn guards
    SPAWN_DIST = 300.0,
    -- Guard Weapons
    GUARD_WEAPONS = {
        "WEAPON_COMBATMG",
        "WEAPON_MINIGUN",
        "WEAPON_ASSAULTSHOTGUN"
    },
    -- Safezones
    SAFEZONES = {
        {
            -- LS Lester's Hideout
            Core = { 717.25, -964.09 },
            GuardSpawns = {
                { 711.76, -979.43, 24.11, 183.15 },
                { 723.64, -978.59, 24.13, 223.51 },
                { 742.28, -969.73, 24.52, 272.48 },
                { 689.58, -1028.74, 22.43, 242.04 },
                { 663.61, -1020.4, 22.28, 187.31 },
                { 659.81, -941.82, 21.88, 322.89 },
                { 750.31, -936.90, 24.96, 172.58 }
            }
        },
        {
            -- Sandy Shores Police Station
            Core = { 1853.61, 3686.79 },
            GuardSpawns = {
                { 1849.08, 3678.36, 34.27, 210.17 },
                { 1864.21, 3686.78, 34.27, 212.44 },
                { 1848.68, 3699.51, 34.27, 31.72 },
                { 1817.18, 3680.22, 34.28, 58.85 },
                { 1815.68, 3669.67, 34.28, 117.48 },
                { 1961.26, 3735.42, 32.37, 201.27 },
                { 1971.52, 3741.76, 32.33, 160.78 }
            }
        },
        {
            -- Paleto Bay Bank
            Core = { -106.72, 6466.90 },
            GuardSpawns = {
                { -110.63, 6457.0, 31.46, 165.7 },
                { -116.71, 6462.79, 31.47, 91.52 },
                { -142.54, 6466.9, 31.72, 98.25 },
                { -111.89, 6440.0, 31.48, 283.98 }
            }
        },
        {
            -- LS Michael's House
            Core = { -806.56, 177.16 },
            GuardSpawns = {
                { -816.0, 180.16, 72.15, 247.69 },
                { -825.08, 184.42, 71.88, 148.37 },
                { -848.01, 164.45, 66.62, 135.81 },
                { -848.42, 153.59, 65.36, 69.32 },
                { -793.51, 169.16, 71.66, 200.26 },
                { -780.34, 185.82, 72.84, 112.88 },
                { -797.5, 186.38, 72.61, 167.02 }
            }
        },
        {
            -- LS Franklin's (Old) House
            Core = { -12.39, -1435.02 },
            GuardSpawns = {
                { -11.39, -1447.97, 30.72, 200.2 },
                { -17.55, -1448.32, 30.65, 128.65 },
                { -10.64, -1421.21, 30.68, 1.72 },
                { -8.97, -1476.65, 30.52, 311.24 },
                { -80.54, -1460.95, 32.60, 169.36 },
                { -56.04, -1479.99, 32.16, 54.37 }
            }
        },
        {
            -- Mount Chilliad Altruist Camp
            Core = { -1128.17, 4923.42 },
            GuardSpawns = {
                { -1035.24, 4908.41, 207.77, 336.9 },
                { -1041.7, 4920.35, 207.42, 327.48 },
                { -1087.33, 4896.38, 214.41, 352.9 },
                { -1083.72, 4933.76, 229.22, 118.28 },
                { -1137.07, 4935.04, 222.27, 253.97 },
                { -1143.03, 4912.33, 220.97, 324.59 },
                { -1184.75, 4927.64, 222.82, 84.36 },
                { -1065.5, 4892.92, 223.07, 238.06 },
                { -1086.82, 4975.08, 209.41, 347.96 }
            }
        }
    }
}