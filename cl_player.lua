Player = {}

function Player.IsSpawnHost()
    local mPlayerId = PlayerId()
    local mServerId = GetPlayerServerId(playerId)

    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= mPlayerId then
            if GetPlayerServerId(playerId) > mServerId then
                return false
            end
        end
    end

    return true
end