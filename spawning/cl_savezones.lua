local GUARD_MODEL = GetHashKey("u_m_y_juggernaut_01")

AddTextEntry("SAFEZONE_BLIP_NAME", "Safezone")

local function SpawnGuard(guardSpawn)
    local guard = Utils.CreatePed(GUARD_MODEL, 25, vector3(guardSpawn[1], guardSpawn[2], guardSpawn[3]), guardSpawn[4])

    SetPedRelationshipGroupHash(guard, SAFEZONE_GUARD_GROUP)

    SetEntityInvincible(guard, true)
    SetPedSeeingRange(guard, 9999.0)

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
end

local function HandleGuardSpawning()
    local guardCounter = g_guardAmount
        
    local untilPause = 10
    for ped, pedData in pairs(g_peds) do
        if pedData.IsGuard then
            local guardCoords = GetEntityCoords(ped)

            if IsPedDeadOrDying(ped) or not Utils.IsPosNearAPlayer(guardCoords, Config.Spawning.Safezones.SPAWN_DIST) then
                SetPedAsNoLongerNeeded(ped)
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
            if guardCounter <= 0 then
                SpawnGuard(guardSpawn)
            else
                guardCounter = guardCounter - 1
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

Utils.CreateLoadedInThread(function()
    for _, safezone in ipairs(Config.Spawning.Safezones.SAFEZONES) do
        local blipCoords = safezone.Core
        local blip = AddBlipForCoord(blipCoords[1], blipCoords[2], blipCoords[3])

        SetBlipSprite(blip, 487)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.9)
        EndTextCommandSetBlipName(blip)
        SetBlipNameFromTextFile(blip, "SAFEZONE_BLIP_NAME")
    end
end)