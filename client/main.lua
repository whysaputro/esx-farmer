ESX = nil

local playerCoords

local currentPlant = 1
local harvestPlant = 0

local Plants = {}

local jobStatus = {
	onDuty = false,
	plowing = false,
	crop   = nil,
	plantBlip = nil,
	vehicle = nil,
	loc = nil,
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	while true do
	playerCoords = GetEntityCoords(PlayerPedId())
	Citizen.Wait(250)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if playerCoords ~= nil and jobStatus.plowing then
			if jobStatus.loc == 'sawah' then
				local distance = #(playerCoords - Config.PlantMarkersSawah[currentPlant])
				if  distance < 20.0 then
					DrawGameMarker(Config.PlantMarkersSawah[currentPlant], 2, {2.0, 2.0, 2.0}, {0, 250, 0, 50}, 180.0)
					if distance < 3.0 and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == 'TRACTOR' then
							currentPlant = currentPlant + 1
							RemoveBlip(jobStatus.plantBlip)
							jobStatus.plantBlip = MissionMarker(Config.PlantMarkersSawah[currentPlant], 1, _U("plant_blip"), 2)
						end
					end
				end
			else
				local distance = #(playerCoords - Config.PlantMarkersKebun[currentPlant])
				if  distance < 20.0 then
					DrawGameMarker(Config.PlantMarkersKebun[currentPlant], 2, {2.0, 2.0, 2.0}, {0, 250, 0, 50}, 180.0)
					if distance < 3.0 and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == 'TRACTOR2' then
							currentPlant = currentPlant + 1
							RemoveBlip(jobStatus.plantBlip)
							jobStatus.plantBlip = MissionMarker(Config.PlantMarkersKebun[currentPlant], 1, _U("plant_blip"), 2)
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if currentPlant > 3 then
			currentPlant = 1
			ESX.Game.DeleteVehicle(jobStatus.vehicle)
			RemoveBlip(jobStatus.plantBlip)
			jobStatus = {
				onDuty    = jobStatus.onDuty,
				plowing	  = false,
				crop      = jobStatus.crop,
				plantBlip = nil,
				vehicle   = nil,
				loc 	  = jobStatus.loc
			}
			PlantCrops()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed)

		if jobStatus.onDuty and jobStatus.crop and IsPedOnFoot(plyPed) then
			if IsControlJustReleased(0, 38) and (DoesObjectOfTypeExistAtCoords(plyCoords, 1.0, GetHashKey('prop_veg_corn_01'), 0) or DoesObjectOfTypeExistAtCoords(plyCoords, 1.0, GetHashKey('prop_veg_crop_02'), 0)) then
				local plant = (jobStatus.loc == 'sawah') and GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey('prop_veg_corn_01'), 0, 1, 1) or GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey('prop_veg_crop_02'), 0, 1, 1)				
				TriggerEvent("rorp_progbar:progress", {
					name = "harvesting_crop",
					duration = 5000,
					label = _U("harvesting_crop"),
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "amb@world_human_gardener_plant@male@idle_a",
						anim = "idle_a",
					}
				}, function(status)
					if not status then
						DeleteEntity(plant)
						TriggerServerEvent('rorp_farmer:GiveCrop', jobStatus.crop)
						harvestPlant = harvestPlant + 1
					end
				end)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if harvestPlant == 100 then
			harvestPlant = 0
			jobStatus = {
				onDuty    = false,
				plowing	  = false,
				crop      = nil,
				plantBlip = nil,
				vehicle   = nil,
				loc 	  = nil
			}
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if playerCoords ~= nil and not jobStatus.onDuty then
			local distance = #(playerCoords - Config.StartJob.pos)
			if  distance < 10.0 then
				DrawGameMarker(Config.StartJob.pos, 39, {2.0, 2.0, 2.0}, {0, 250, 0, 50}, 0.0)
				if distance < 2.0 then
					ESX.ShowHelpNotification(_U('start_job'))
					if IsControlJustReleased(0, 38) then
						OpenJobMenu()
					end
				end
			end
		end
	end
end)

-- Blips
Citizen.CreateThread(function()
	DrawBlip(Config.ProcessCrops, 514, _U('sell_crops_blip'), 2, 0.6)
	DrawBlip(Config.StartJob.pos, 496, _U('start_job_blip'), 2, 0.8)
end)

function DrawGameMarker(coords, id, scale, colour, rotate)
	DrawMarker(id, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, rotate, 0.0, scale[1], scale[2], scale[3], colour[1], colour[2], colour[3], colour[4], false, true, 2, nil, nil, false)
end

function PlantCrops()
	if jobStatus.loc == 'sawah' then
		for k,v in ipairs(Config.CropLocationsSawah) do
			Citizen.Wait(1500, 3500)
			ESX.Game.SpawnLocalObject('prop_veg_corn_01', vector3(v.x, v.y, v.z - 1), function(crop)
				table.insert(Plants, crop)
			end)
		end
	else
		for k,v in ipairs(Config.CropLocationsKebun) do
			Citizen.Wait(1500, 3500)
			ESX.Game.SpawnLocalObject('prop_veg_crop_02', vector3(v.x, v.y, v.z - 1), function(crop)
				table.insert(Plants, crop)
			end)
		end
	end
end

function MissionMarker(coords, sprite, title, colour)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.0)
	SetBlipColour(blip, 2)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(title)
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 2)
	return blip
end

function DrawBlip(coords, sprite, title, colour, scale)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, colour)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(title)
	EndTextCommandSetBlipName(blip)
	return blip
end

function OpenJobMenu()

	local elements = {}

	for k,v in ipairs(Config.Seeds) do
		table.insert(elements, {label = v.label, value = v.DBname, lokasi = v.loc, veh = v.veh})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu',
	{
		title  = _U('job_menu'),
		elements = elements,
		align = 'left'
	},
	function(data, menu)
		if data.current.value then
			menu.close()
			ESX.Game.SpawnVehicle(data.current.veh, Config.StartJob.pos, Config.StartJob.heading, function(veh)
				if DoesEntityExist(veh) then
					jobStatus = {
						onDuty = true,
						plowing = true,
						crop   = data.current.value,
						plantBlip = (data.current.lokasi == 'sawah') and MissionMarker(Config.PlantMarkersSawah[currentPlant], 1, _U("plant_blip"), 1) or MissionMarker(Config.PlantMarkersKebun[currentPlant], 1, _U("plant_blip"), 1),
						vehicle = veh,
						loc = data.current.lokasi
					}
					SetPedIntoVehicle(PlayerPedId(), veh, -1)
					setUniform()
				end
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end
	)
end

function setUniform()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniform

		if skin.sex == 0 then
			uniform = Config.Uniform.male
		else
			uniform = Config.Uniform.female
		end

		if uniform then
			TriggerEvent('skinchanger:loadClothes', skin, uniform)
		end
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Plants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)