Citizen.CreateThread(function()
    DisplayRadar(not Config.HIDE_RADAR)
    SetBlackout(Config.ENABLE_BLACKOUT)
    SetAudioFlag("DisableFlightMusic", true)
    SetAudioFlag("PoliceScannerDisabled", true)

    if Config.FIRST_PERSON_LOCK then
        SetFollowPedCamViewMode(4)
        SetFollowVehicleCamViewMode(4)
    end

    for i = 1, 15 do
        EnableDispatchService(i, false)
    end

    Utils.AddSafeZoneBlips()
    
    while true do
        Wait(0)

        local playerId = PlayerId()

        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(13)
        
        if not Config.ENABLE_PEDS then
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        end

        if not Config.ENABLE_TRAFFIC then
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
        end
        
        if IsPlayerWantedLevelGreater(playerId, 0) then
            ClearPlayerWantedLevel(playerId)
        end        

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