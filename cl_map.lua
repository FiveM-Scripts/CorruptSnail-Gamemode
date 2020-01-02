--[[TO DO:
*Add good places for map locations
--]]

--[[Reworked]]
local Map = "prop_tourist_map_01"
local MapCoords ={
	{x= 719.52940, y= -963.195, z=31.3872}
}
local Maps = {}
local collected = false

AddEventHandler('playerSpawned',function()
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
	
Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(1)
		for i, MapSpawning in pairs(Maps) do
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			propX, propY, propZ = table.unpack(GetEntityCoords(MapSpawning, true))
			if(Vdist(playerX, playerY, playerZ, propX, propY, propZ) < 1.5) then				
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
	for id = 0, 64 do
		if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
			ped = GetPlayerPed( id )
			blip = GetBlipFromEntity( ped )
			if not DoesBlipExist( blip ) then -- Add blip and create head display on player
				blip = AddBlipForEntity( ped )
				SetBlipSprite( blip, 1 )
				Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
			else -- update blip
				veh = GetVehiclePedIsIn( ped, false )
				blipSprite = GetBlipSprite( blip )
				if not GetEntityHealth( ped ) then -- dead
					if blipSprite ~= 274 then
						SetBlipSprite( blip, 274 )
						Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
					end
				elseif veh then
					vehClass = GetVehicleClass( veh )
					VehModel = GetEntityModel( veh )
					if vehClass == 15 then -- jet
						if blipSprite ~= 422 then
							SetBlipSprite( blip, 422 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
						end
					elseif vehClass == 16 then -- plane
						if vehModel == GetHashKey( "besra" ) or vehModel == GetHashKey( "hydra" )
							or vehModel == GetHashKey( "lazer" ) then -- jet
							if blipSprite ~= 424 then
								SetBlipSprite( blip, 424 )
								Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
							end
						elseif blipSprite ~= 423 then
							SetBlipSprite( blip, 423 )
							Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
						end
					elseif vehClass == 14 then -- boat
						if blipSprite ~= 427 then
							SetBlipSprite( blip, 427 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
						end
					elseif vehModel == GetHashKey( "insurgent" ) or vehModel == GetHashKey( "insurgent2" )
						or vehModel == GetHashKey( "limo2" ) then -- insurgent (+ turreted limo cuz limo blip wont work)
						if blipSprite ~= 426 then
							SetBlipSprite( blip, 426 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
						end
					elseif vehModel == GetHashKey( "rhino" ) then -- tank
						if blipSprite ~= 421 then
							SetBlipSprite( blip, 421 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator
						end
					elseif blipSprite ~= 1 then -- default blip
						SetBlipSprite( blip, 1 )
						Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
					end
						-- Show number in case of passangers
					passengers = GetVehicleNumberOfPassengers( veh )
					if passengers then
						if not IsVehicleSeatFree( veh, -1 ) then
							passengers = passengers + 1
						end
						ShowNumberOnBlip( blip, passengers )
					else
						HideNumberOnBlip( blip )
					end
				else
						-- Remove leftover number
					HideNumberOnBlip( blip )
					if blipSprite ~= 1 then -- default blip
						SetBlipSprite( blip, 1 )
						Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
					end
				end
				SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) ) -- update rotation
				SetBlipNameToPlayerName( blip, id ) -- update blip name
				SetBlipScale( blip,  0.85 ) -- set scale
					-- set player alpha
				if IsPauseMenuActive() then
					SetBlipAlpha( blip, 255 )
				else
					x1, y1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
					x2, y2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
					distance = ( math.floor( math.abs( math.sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) ) ) / -1 ) ) + 900
					if distance < 0 then
						distance = 0
					elseif distance > 255 then
						distance = 255
					end
					SetBlipAlpha( blip, distance )
				end
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