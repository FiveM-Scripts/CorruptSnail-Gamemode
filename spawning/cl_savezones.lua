local GUARD_MODEL = GetHashKey("u_m_y_juggernaut_01")

local GUARDSPAWN_ID_DECOR = "_GUARD_SPAWNID"
DecorRegister(GUARDSPAWN_ID_DECOR, 3)

AddTextEntry("SAFEZONE_BLIP_NAME", "Safezone")

local function SpawnGuard(guardSpawn)
    local guard = Utils.CreatePed(GUARD_MODEL, 25, vector3(guardSpawn[1], guardSpawn[2], guardSpawn[3]), guardSpawn[4])

    SetPedRelationshipGroupHash(guard, SAFEZONE_GUARD_GROUP)

    SetEntityInvincible(guard, true)
    SetPedSeeingRange(guard, 75.0)
    SetPedHearingRange(guard, 75.0)

    GiveWeaponToPed(guard, GetHashKey(Config.Spawning.Safezones.GUARD_WEAPONS[math.random(1, #Config.Spawning.Safezones.GUARD_WEAPONS)]),
        9999, true, true)

    SetPedAccuracy(guard, 100)
    SetPedFiringPattern(guard, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
    SetPedCombatAttributes(guard, 0, false)

    SetPedCanRagdoll(guard, false)
    SetPedAlertness(guard, 3)

    SetPedSphereDefensiveArea(guard, guardSpawn[1], guardSpawn[2], guardSpawn[3], 25.0)
    SetPedDesiredHeading(guard, guardSpawn[4])
    SetPedToInformRespectedFriends(guard, 20.0, 1)

    DecorSetInt(guard, GUARDSPAWN_ID_DECOR, guardSpawn.Id)
end

local function HandleGuardSpawning()
    local untilPause = 10
    local spawnedIds = {}
    for ped, pedData in pairs(g_peds) do
        if pedData.IsGuard then
            local guardCoords = GetEntityCoords(ped)

            if not Utils.IsPosNearAPlayer(guardCoords, Config.Spawning.Safezones.SPAWN_DIST) then
                SetPedAsNoLongerNeeded(ped)
            else
                spawnedIds[DecorGetInt(ped, GUARDSPAWN_ID_DECOR)] = true
            end
            
            untilPause = untilPause - 1
            if untilPause == 0 then
                untilPause = 10

                Wait(0)
            end
        end
    end

    for _, safezone in ipairs(Config.Spawning.Safezones.SAFEZONES) do
        for _, guardSpawn in ipairs(safezone.GuardSpawns) do
            if guardSpawn.Id and not spawnedIds[guardSpawn.Id] then
                SpawnGuard(guardSpawn)
            end
        end
    end
end

Utils.CreateLoadedInThread(function()
    Wait(250)

    if Player.IsSpawnHost() then
        HandleGuardSpawning()
    end
end)

Citizen.CreateThread(function()
    local id = 0

    for _, safezone in ipairs(Config.Spawning.Safezones.SAFEZONES) do
        local blipCoords = safezone.Core
        local blip = AddBlipForCoord(blipCoords[1], blipCoords[2], blipCoords[3])

        SetBlipSprite(blip, 487)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.9)
        EndTextCommandSetBlipName(blip)
        SetBlipNameFromTextFile(blip, "SAFEZONE_BLIP_NAME")

        for _, guardSpawn in ipairs(safezone.GuardSpawns) do
            guardSpawn.Id = id
            id = id + 1
        end
    end
end)