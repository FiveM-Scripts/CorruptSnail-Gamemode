RegisterNetEvent("corruptsnail:newZombie")
AddEventHandler("corruptsnail:newZombie", function(zombieNetHandle)
	TriggerClientEvent("corruptsnail:client:newZombie", -1, zombieNetHandle)
end)

RegisterNetEvent("corruptsnail:updateTime")
AddEventHandler("corruptsnail:updateTime", function(newTimeH, newTimeM, newTimeS)
	timeH = newTimeH
	timeM = newTimeM
	timeS = newTimeS
end)

RegisterNetEvent("corruptsnail:timeSync")
AddEventHandler("corruptsnail:timeSync", function()
	if timeH and timeM and timeS then
		TriggerClientEvent("corruptsnail:client:timeSync", source, timeH, timeM, timeS)
	end
end)