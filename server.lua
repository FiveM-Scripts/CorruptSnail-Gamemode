RegisterServerEvent("corruptsnail:new_zombie")

AddEventHandler("corruptsnail:new_zombie", function(zombie_net_handle)
	TriggerClientEvent("corruptsnail:client:new_zombie", -1, zombie_net_handle)
end)