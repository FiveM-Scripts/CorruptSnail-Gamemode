Citizen.CreateThread(function()
    DisplayRadar(not Config.HIDE_RADAR)

    SetBlackout(true)

    SetMaxWantedLevel(0)

    if Config.FIRST_PERSON_LOCK then
        SetFollowPedCamViewMode(4)
        SetFollowVehicleCamViewMode(4)
    end

    while true do
        Wait(0)

        SetVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)

        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

        if Config.FIRST_PERSON_LOCK then
            DisableControlAction(0, 0, true)
        end
    end
end)

Citizen.CreateThread(function()
    if Config.ENV_SYNC then
        while true do
            Wait(10000)

            if Config.ENV_SYNC then
                NetworkOverrideClockTime(NetworkGetServerTime()) -- Simple time sync
                SetWeatherTypeNowPersist("FOGGY") -- TODO: Weather system!!!
            end
        end
    end
end)