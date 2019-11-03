local Spawn = {}

function Spawn.GetDetfaultWeapons()
    local playerPed = PlayerPedId()
    for k, v in pairs(Config.Spawning.DEFAULT_WEAPONS) do
        GiveWeaponToPed(playerPed, v, -1, false, true)
    end

    SetCurrentPedWeapon(playerPed, "WEAPON_UNARMED", true)
end

function Spawn.GetRandomSafeZoneCoords()    
    local keys = {}

    for key, value in pairs(Config.Spawning.SPAWN_POINTS) do
        keys[#keys+1] = key
    end

    math.randomseed(GetGameTimer())
    index = keys[math.random(1, #keys)]

    return Config.Spawning.SPAWN_POINTS[index]
end

function Spawn.GetRandomSinglePlayer()
    local keys = {}

    for key, value in pairs(Config.Spawning.SP_MODELS) do
        keys[#keys+1] = key
    end

    math.randomseed(GetGameTimer())
    index = keys[math.random(1, #keys)]

    return Config.Spawning.SP_MODELS[index]
end


AddEventHandler('onClientGameTypeStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        spawnPos = Spawn.GetRandomSafeZoneCoords()

        exports.spawnmanager:spawnPlayer({
            x = spawnPos.x,
            y = spawnPos.y,
            z = spawnPos.z,
            model = Spawn.GetRandomSinglePlayer()
        }, function()
            Spawn.GetDetfaultWeapons()
        end)
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)