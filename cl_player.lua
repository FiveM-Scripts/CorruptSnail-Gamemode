Player = {}

function Player.GetDetfaultWeapons()
    local playerPed = PlayerPedId()
    for k, v in pairs(Config.Spawning.Player.WEAPONS) do
        GiveWeaponToPed(playerPed, v, -1, false, true)
    end
end

function Player.IsSpawnHost()
    local mPlayerId = PlayerId()
    local mServerId = GetPlayerServerId(playerId)
    local mPlayerPedPos = GetEntityCoords(PlayerPedId())

    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= mPlayerId then
            if GetPlayerServerId(playerId) > mServerId and Util.GetDistanceBetweenCoords(mPlayerPedPos,
                GetEntityCoords(GetPlayerPed(playerId))) <= Config.Spawning.HOST_DECIDE_DIST then
                return false
            end
        end
    end

    return true
end