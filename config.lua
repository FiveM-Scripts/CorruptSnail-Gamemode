Config = {
    -- Time and weather sync (disable if you have your own solution)
    ENV_SYNC = true,
    -- Hide Radar
    HIDE_RADAR = true,
    -- First person only
    FIRST_PERSON_LOCK = true
}

Config.Spawning = {
    -- Time between each "tick" for operations (in ms)
    TICK_RATE = 500,
    -- Min distance between players to decide one "host"
    HOST_DECIDE_DIST = 100
}

Config.Spawning.Zombies = {
    -- Max amount of spawned zombies at once by you
    MAX_AMOUNT = 50,
    -- Chance a zombie receives a special attributes (per attribute, 0 - 100)
    ATTR_CHANCE = 50,
    -- Max Health
    MAX_HEALTH = 500,
    -- Max Armor
    MAX_ARMOR = 500,
    -- Min spawn distance
    MIN_SPAWN_DISTANCE = 50.0,
    -- Despawn distance (should always be at least 2x min spawn distance)
    DESPAWN_DISTANCE = 200.0,
    -- Model of zombies
    -- TODO: List of models
    ZOMBIE_MODEL = "u_m_y_zombie_01"
}