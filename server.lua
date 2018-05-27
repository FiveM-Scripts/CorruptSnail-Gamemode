--[[RegisterNetEvent("corruptsnail:newZombie")
AddEventHandler("corruptsnail:newZombie", function(zombieNetHandle)
	TriggerClientEvent("corruptsnail:client:newZombie", -1, zombieNetHandle)
end)
local timeH = 0
local timeM = 0
local timeS = 0

RegisterNetEvent("corruptsnail:updateTime")
AddEventHandler("corruptsnail:updateTime", function(newTimeH, newTimeM, newTimeS)
	timeH = newTimeH
	timeM = newTimeM
	timeS = newTimeS
end)

RegisterNetEvent("corruptsnail:timeSync")
AddEventHandler("corruptsnail:timeSync", function()
	TriggerClientEvent("corruptsnail:client:timeSync", source, timeH, timeM, timeS)
end)]]--