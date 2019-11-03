local Spawn = {}

function Spawn.GetRandomSafeZoneCoords()    
    local keys = {}

    for key, value in pairs(Config.Spawning.Player.SPAWN_POINTS) do
        keys[#keys+1] = key
    end

    math.randomseed(GetGameTimer())
    index = keys[math.random(1, #keys)]

    return Config.Spawning.Player.SPAWN_POINTS[index]
end


AddEventHandler('onClientGameTypeStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        spawnPos = Spawn.GetRandomSafeZoneCoords()
        
        exports.spawnmanager:spawnPlayer({
            x = spawnPos.x,
            y = spawnPos.y,
            z = spawnPos.z,
            model = 'a_m_m_skater_01'
        }, function()
            print('We joined the server')
            Player.GetDetfaultWeapons()
        end)
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 38) then
            local coords = GetEntityCoords(PlayerPedId(), true)
            print('Coords: ' .. coords.x ..",".. coords.y ..",".. coords.z)
        end
    end
end)