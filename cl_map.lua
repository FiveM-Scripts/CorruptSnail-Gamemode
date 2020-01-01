--[[TO DO:
*Add good places for map locations
*Make the map to be stored on player and only if map in inventory then show all players--]]
local Map = "prop_tourist_map_01"
local MapCoords ={
    {x= 719.52940, y= -963.195, z=31.3872},
}
local Maps = {}
local collected = false

Citizen.CreateThread(function()
	AddEventHandler('playerSpawned', function()
		Citizen.CreateThread(function()
			for _, prop in ipairs(MapCoords) do
				MapSpawning = CreateObject(GetHashKey(Map), prop.x, prop.y, prop.z - 1, false, false, true)
			
				blip = AddBlipForEntity(MapSpawning)
				SetBlipSprite(blip, 274)
				SetBlipAsShortRange(blip, true)
				SetBlipAlpha(blip, 255)
				SetBlipScale(blip, 0.5)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Map') 
				EndTextCommandSetBlipName(blip)
				table.insert(Maps, MapSpawning)
			end	
		end)
	end)
end)

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(1)
		for i, MapSpawning in pairs(Maps) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local propCoords = GetEntityCoords(MapSpawning)
			if(Vdist(playerCoords.x, playerCoords.y, playerCoords.z, propCoords.x, propCoords.y, propCoords.z) < 1.5) then				
				DisplayHelpText("Press ~INPUT_CONTEXT~ to get the map.")
				if IsControlJustReleased(1, 51) then
					ShowNotification("Picked up: ~g~[Map]")
					DeleteObject(MapSpawning)
					RemoveBlip(blip)
					table.remove(Maps, i)
					collected = true
				end
			end
			if IsPedDeadOrDying(PlayerPedId(), 1) == 1 then
				DeleteObject(MapSpawning)
				RemoveBlip(blip)
				table.remove(Maps, i)
				collected = false
			end
		end
		if collected == true then
			DisplayAllMap()
		end
	end
end)

function DisplayAllMap()
	local blips = {}
	local xPlayer = PlayerId()

	while true do
        Wait(100)
        local players = ShowPlayers()
        for player = 0, NetworkGetNumConnectedPlayers() do
            if player ~= xPlayer and NetworkIsPlayerActive(player) then
				local ped = GetPlayerPed(player)
				local playerName = GetPlayerName(player)
				RemoveBlip(blips[player])
				local new_blip = AddBlipForEntity(playerPed)
				SetBlipNameToPlayerName(new_blip, player)
				SetBlipColour(new_blip, 4)
				SetBlipCategory(new_blip, 2)
				SetBlipScale(new_blip, 0.3)
				blips[player] = new_blip 
			end
		end
	end
end
function ShowPlayers()
	local players = {}

	for i = 0, NetworkGetNumConnectedPlayers() do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end