Player = {}

function Player.GetDetfaultWeapons()
    GiveWeaponToPed(PlayerPedId(), "WEAPON_PISTOL", -1, false, true)
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