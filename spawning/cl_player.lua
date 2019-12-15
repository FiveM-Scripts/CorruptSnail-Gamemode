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

function Spawn.GetRandomMultiPlayerModel()
    local modelHash = "mp_m_freemode_01"
    local playerPed = PlayerPedId()

    SetPedHeadBlendData(playerPed, 0, math.random(45), 0,math.random(45), math.random(5), math.random(5),1.0,1.0,1.0,true)
    SetPedHairColor(playerPed, math.random(1, 4), 1)
        
    SetPedComponentVariation(playerPed, 0, math.random(0, 5), 0, 2)
    SetPedComponentVariation(playerPed, 2, math.random(1, 17), 3, 2)
    SetPedComponentVariation(playerPed, 3, 0, 0, 2)

    SetPedComponentVariation(playerPed, 4, 1, math.random(0, 15), 2)
    SetPedComponentVariation(playerPed, 6, 3, math.random(0, 15), 2)
    SetPedComponentVariation(playerPed, 8, 0, 240, 0)
    SetPedComponentVariation(playerPed, 10, 0, 0, 2)
    SetPedComponentVariation(playerPed, 11, 0, math.random(0, 5), 0)            
end


function SendNotification(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", true)
    DrawNotification(true, true)
end

AddEventHandler("onClientGameTypeStart", function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        spawnPos = Spawn.GetRandomSafeZoneCoords()
        if Config.Spawning.MULTIPLAYER_MODEL then
            exports.spawnmanager:spawnPlayer({
                x = spawnPos.x,
                y = spawnPos.y,
                z = spawnPos.z,
                model = "mp_m_freemode_01"
            }, function()
                Spawn.GetDetfaultWeapons()
                Spawn.GetRandomMultiPlayerModel()
            end)
        else
            exports.spawnmanager:spawnPlayer({
                x = spawnPos.x,
                y = spawnPos.y,
                z = spawnPos.z,
                model = Spawn.GetRandomSinglePlayer()
            }, function()
                Spawn.GetDetfaultWeapons()
            end)
        end
    end)

    exports.spawnmanager:setAutoSpawn(true)

    if GetIsLoadingScreenActive() or not IsGameplayCamRendering() then
        exports.spawnmanager:forceRespawn()
    end

    Wait(3000)
    
    Utils.LoadInteriors()
    SendNotification("CHAR_LESTER_DEATHWISH", 1, "CorruptSnail", "", GetLabelText("collision_9a0v4k"))
end)