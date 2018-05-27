local ids = {}

AddEventHandler("menu:setup", function()
	TriggerEvent("menu:registerModuleMenu", "Spawn Menu", function(id)
		table.insert(ids, id)
	
		TriggerEvent("menu:addModuleSubMenu", id, "Spawn Vehicle", function(id)
			table.insert(ids, id)
			TriggerEvent("menu:addModuleItem", id, "Faggio", nil, function(id) table.insert(ids, id) end, function(id) spawnVehicleToPlayer("FAGGIO") end)
			TriggerEvent("menu:addModuleItem", id, "Futo", nil, function(id) table.insert(ids, id) end, function(id) spawnVehicleToPlayer("FUTO") end)
			TriggerEvent("menu:addModuleItem", id, "Ingot", nil, function(id) table.insert(ids, id) end, function(id) spawnVehicleToPlayer("INGOT") end)
			TriggerEvent("menu:addModuleItem", id, "Sultan", nil, function(id) table.insert(ids, id) end, function(id) spawnVehicleToPlayer("SULTAN") end)
			TriggerEvent("menu:addModuleItem", id, "Technical", nil, function(id) table.insert(ids, id) end, function(id) spawnVehicleToPlayer("TECHNICAL") end)
		end, false)
		
		TriggerEvent("menu:addModuleSubMenu", id, "Give Weapon", function(id)
			table.insert(ids, id)
			TriggerEvent("menu:addModuleItem", id, "Give Knife", nil, function(id) table.insert(ids, id) end, function(id) giveWeaponToPlayer("WEAPON_KNIFE") end)
			TriggerEvent("menu:addModuleItem", id, "Give Baseball Bat", nil, function(id) table.insert(ids, id) end, function(id) giveWeaponToPlayer("WEAPON_BAT") end)
			TriggerEvent("menu:addModuleItem", id, "Give Pistol", nil, function(id) table.insert(ids, id) end, function(id) giveWeaponToPlayer("WEAPON_PISTOL") end)
			TriggerEvent("menu:addModuleItem", id, "Give Assault Rifle", nil, function(id) table.insert(ids, id) end, function(id) giveWeaponToPlayer("WEAPON_ASSAULTRIFLE") end)
		end, false)
	end, false)
end)

AddEventHandler("corruptsnail:inZone", function(state)
	for _, id in ipairs(ids) do
		TriggerEvent("menu:setGreyedOut", not state, id)
	end
end)

function giveWeaponToPlayer(weapon)
	local playerPed = GetPlayerPed(-1)
	GiveWeaponToPed(playerPed, GetHashKey(weapon), 9999, true, true)
end

function spawnVehicleToPlayer(model)
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	while not HasModelLoaded(model) do
		Wait(1)
		RequestModel(model)
	end
	
	local veh = CreateVehicle(model, x + 2.5, y + 2.5, z + 1, 0.0, true, false)
	SetVehicleAsNoLongerNeeded(veh)
	drawNotification("~g~Vehicle spawned!")
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end