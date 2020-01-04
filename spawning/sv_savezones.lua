Citizen.CreateThread(function()
    Citizen.Wait(500)
    local count = 0
    local spawned = false
    players = GetPlayers()
    for _ in ipairs(players) do
        count = count + 1
        if count == 1 and spawned == false then
            TriggerClientEvent("GuardSpawn", -1)
            spawned = true
        end
    end
end)