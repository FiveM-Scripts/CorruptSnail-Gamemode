
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        local myHealth = GetEntityHealth(GetPlayerPed(-1))
        SendNUIMessage({
            health = myHealth;
        })
    end
end)

