Utils = {}

local function WaitForModel(model)
    if IsModelValid(model) then
        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(0)
        end
    end
end

function Utils.CreatePed(model, pedType, pos, heading)
    if IsModelAPed(model) then
        WaitForModel(model)

        local ped = CreatePed(pedType, model, pos.x, pos.y, pos.z, heading, true)
        
        SetModelAsNoLongerNeeded(model)

        return ped
    end
end

function Utils.CreateVehicle(model, pos, heading)
    if IsModelAVehicle(model) then
        WaitForModel(model)

        local veh = CreateVehicle(model, table.unpack(pos), heading, true)

        SetModelAsNoLongerNeeded(model)

        return veh
    end
end

function Utils.CreateProp(model, pos, dynamic, placeOnGround)
    if IsModelValid(model) then
        WaitForModel(model)

        local x, y, z = table.unpack(pos)
        local prop = CreateObject(model, x, y, GetGroundZFor_3dCoord(x, y, z), true, false, dynamic)

        SetModelAsNoLongerNeeded(model)

        return prop
    end
end

function Utils.GetDistanceBetweenCoords(pos1, pos2)
    return math.abs(#pos1 - #pos2)
end

function Utils.GetRandomPosOffsetFromEntity(entity, minDistance, maxDistance)
    local angle = math.random() * math.pi * 2
    local r = math.sqrt(math.random()) * maxDistance
    local x = r * math.cos(angle)
    local y = r * math.sin(angle)

    return GetOffsetFromEntityInWorldCoords(entity, x, y, 0.0)
end

function Utils.FindGoodSpawnPos(minDistance)
    local goodSpawnFound = false
    local maxDistance = Config.Spawning.Zombies.DESPAWN_DISTANCE
    local newPos

    local mPlayerPedId = PlayerPedId()

    local tries = 5
    while not goodSpawnFound do
        goodSpawnFound = true

        newPos = Utils.GetRandomPosOffsetFromEntity(mPlayerPedId, minDistance, maxDistance)

        if not newPos then
            goodSpawnFound = false
            tries = tries - 1
        else
            for _, playerId in ipairs(GetActivePlayers()) do
                if Utils.GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(playerId)), newPos) < minDistance then
                    goodSpawnFound = false
                    tries = tries - 1

                    break
                end
            end
        end

        if tries == 0 then
            return nil
        end
    end

    return newPos
end

function Utils.ZToGround(pos)
    local found, z = GetGroundZFor_3dCoord(table.unpack(pos))

    if found then
        return z
    end
end

function Utils.IsPosNearAPlayer(pos, maxDistance)
    local nearbyPlayer = false

    for _, playerId in ipairs(GetActivePlayers()) do
        if Utils.GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(playerId)), pos) < maxDistance then
            nearbyPlayer = true

            break
        end
    end

    return nearbyPlayer
end

function Utils.GetRandomPlayer()
    return math.random(#GetActivePlayers())
end

function Utils.AddSafeZoneBlips()
    for k,v in pairs(Config.Spawning.SPAWN_POINTS) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite(blip, 487)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.9)
        SetBlipNameFromTextFile(blip, "BLIP_CPOINT")
    end
end

function Utils.LoadInteriors()
    RequestIpl("shr_int")
    local PDM = GetInteriorAtCoords(-59.7936, -1098.784, 27.2612)
    LoadInterior(PDM)
    while not IsInteriorReady(PDM) do
        Wait(0)
    end

    EnableInteriorProp(PDM, "csr_beforeMission")
    EnableInteriorProp(PDM, "shutter_closed")
    RefreshInterior(PDM)

    RequestIpl("id2_14_during_door")
    RequestIpl("id2_14_during1")

    RequestIpl("sp1_10_real_interior")
    RequestIpl("sp1_10_real_interior_lod")

    RequestIpl("methtrailer_grp1")
    RequestIpl("bkr_bi_hw1_13_int")
    
    RequestIpl("RC12B_Destroyed")
    RequestIpl("RC12B_HospitalInterior")
end