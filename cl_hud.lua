local hurt = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        local myHealth = GetEntityHealth(GetPlayerPed(-1))
        SendNUIMessage({
            health = myHealth;
        })
        if myHealth <= 159 then
            playerHurt()
        elseif hurt == true and myHealth > 130 then
            playerNotHurt()
        end
    end
end)

function playerHurt()
    hurt = true
	RequestAnimSet('move_m@injured')
	SetPedMovementClipset(GetPlayerPed(-1), 'move_m@injured', true)
end

function playerNotHurt()
    hurt = false
    ResetPedMovementClipset(GetPlayerPed(-1))
	ResetPedWeaponMovementClipset(GetPlayerPed(-1))
	ResetPedStrafeClipset(GetPlayerPed(-1))
end
