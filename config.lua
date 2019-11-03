Config = {
    -- Time and weather sync (disable if you have your own solution)
    ENV_SYNC = true,
    -- Hide Radar
    HIDE_RADAR = true,
    -- First person only
    FIRST_PERSON_LOCK = false,
    -- Enable blackout
    ENABLE_BLACKOUT = false
}

Config.Spawning = {
    -- Time between each "tick" for operations (in ms)
    TICK_RATE = 500,
    -- Min distance between players to decide one "host"
    HOST_DECIDE_DIST = 200.0,
    -- Set the default spawnpoints when joining the server.
    SPAWN_POINTS = {
        {x= 428.1125, y= -981.19305, z= 30.71015},
        {x= -2542.0256, y= 2341.4169, z= 33.059909},
        {x= -2328.2419, y= 3245.5944, z= 33.0539665}
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
    MAX_AMOUNT = 100,
    -- Chance a zombie receives a special attributes (per attribute, 0 - 100)
    ATTR_CHANCE = 25,
    -- Max Health
    MAX_HEALTH = 300,
    -- Max Armor
    MAX_ARMOR = 200,
    -- The speed at which zombies are walking towards enemies
    WALK_SPEED = 1.0,
    -- Min spawn distance
    MIN_SPAWN_DISTANCE = 100.0,
    -- Despawn distance (should always be at least 2x min spawn distance)
    DESPAWN_DISTANCE = 200.0,
    -- Model of zombies
    -- TODO: List of models
    ZOMBIE_MODEL = "u_m_y_zombie_01"
}