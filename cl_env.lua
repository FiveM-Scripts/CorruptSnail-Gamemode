Citizen.CreateThread(function()
    while true do
        Wait(0)

        SetBlackout(true)

        SetMaxWantedLevel(0)

        SetVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)

        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

        DisplayRadar(not Config.HIDE_RADAR)

        if Config.FIRST_PERSON_LOCK then
            DisableControlAction(0, 0, true)
            SetFollowPedCamViewMode(4)
            SetFollowVehicleCamViewMode(4)
        end
        
        if Config.ENV_SYNC then
            NetworkOverrideClockTime(NetworkGetServerTime()) -- Simple time sync
            SetWeatherTypeNowPersist("FOGGY") -- TODO: Weather system!!!
        end
    end
end)