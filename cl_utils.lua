Utils = {}

local function _WaitForModel(model)
    if IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end
end

function Utils.CreatePed(model, pedType, pos, heading)
    if IsModelAPed(model) then
        _WaitForModel(model)
        local ped = CreatePed(pedType, model, pos.x, pos.y, pos.z, heading, true)
        SetModelAsNoLongerNeeded(model)
        return ped
    end
end

function Utils.CreateVehicle(model, pos, heading)
    if IsModelAVehicle(model) then
        _WaitForModel(model)
        local veh = CreateVehicle(model, table.unpack(pos), heading, true)
        SetModelAsNoLongerNeeded(model)
        return veh
    end
end

function Utils.CreateProp(model, pos, dynamic, placeOnGround)
    if IsModelValid(model) then
        _WaitForModel(model)
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
    local coord1 = (math.random(0, 1) == 0 and math.random(minDistance, maxDistance / 2) or math.random(-maxDistance / 2, -minDistance)) + 0.0
    local coord2 = math.random(-maxDistance, maxDistance) + 0.0
    if math.random(0, 1) == 1 then
        return GetOffsetFromEntityInWorldCoords(entity, coord1, coord2, 0.0)
    else
        return GetOffsetFromEntityInWorldCoords(entity, coord2, coord1, 0.0)
    end
end

function Utils.FindGoodSpawnPos(minDistance)
    local goodSpawnFound = false
    local maxDistance = Config.Spawning.Zombies.DESPAWN_DISTANCE
    local newPos
    while not goodSpawnFound do
        goodSpawnFound = true
        newPos = Utils.GetRandomPosOffsetFromEntity(PlayerPedId(), minDistance, maxDistance)
        for _, player in ipairs(Utils.GetAllPlayers()) do
            if Utils.GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), newPos) < minDistance then
                goodSpawnFound = false
                break
            end
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
    for _, player in ipairs(Utils.GetAllPlayers()) do
        if Utils.GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), pos) < maxDistance then
            nearbyPlayer = true
            break
        end
    end
    return nearbyPlayer
end

function Utils.GetAllPlayers()
    local players = {}
    for i=0, GetNumberOfPlayers() - 1 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function Utils.GetRandomPlayer()
    return math.random(GetNumberOfPlayers() - 1)
end