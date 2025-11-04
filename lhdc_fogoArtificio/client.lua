local fireworking = false
-- UI --

local isUIOpen = false

-- Function to convert config to UI format
local function getLocationsFromConfig()
    local locations = {}
    local index = 1
    
    local configKeys = Config.Keys
    
    for _, key in ipairs(configKeys) do
        local configEntry = Config[key]
        if configEntry then
            table.insert(locations, {
                id = index,
                configKey = key,
                name = configEntry.Alias,
                coords = {
                    x = configEntry.Location[1],
                    y = configEntry.Location[2],
                    z = configEntry.Location[3]
                },
                active = configEntry.enabled
            })
            index = index + 1
        end
    end
    
    return locations
end

-- Command to open/close the UI
RegisterCommand('fireworks', function()
        -- Permission Check
    if not (exports['wasabi_discord']:checkForRole(953180998215024656) -- Admin
    -- or exports['wasabi_discord']:checkForRole(953180998215024653) -- Developer
    ) then
        print("No permission.")
        return
    end

    isUIOpen = not isUIOpen
    
    if isUIOpen then
        local locations = getLocationsFromConfig()
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'setVisible',
            visible = true,
            locations = locations
        })
        print('Opening fireworks UI')
    else
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'setVisible',
            visible = false
        })
        print('Closing fireworks UI')
    end
end, false)

-- Handle closing the UI
RegisterNUICallback('closeUI', function(data, cb)
    print('closeUI callback received')
    isUIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'setVisible',
        visible = false
    })
    cb('ok')
end)

-- Handle individual firework toggle
RegisterNUICallback('toggleFirework', function(data, cb)
    -- print('Toggling firework at ' .. data.name)
    -- print('Config Key: ' .. data.configKey)
    -- print('Active: ' .. tostring(data.active))
    -- print(json.encode(data))
    -- Update the config
    --Config[data.configKey].enabled = data.active
    TriggerServerEvent('lhdc_fogoArtificio:updateConfig', -1, data.active, tostring(data.name))
    
    cb('ok')
end)

-- Handle all fireworks toggle
RegisterNUICallback('toggleAllFireworks', function(data, cb)
    -- print('Toggling all fireworks: ' .. tostring(data.active))
    print(json.encode(data))

    for _, location in ipairs(data.locations) do
        -- print('Location: ' .. location.name)
        TriggerServerEvent('lhdc_fogoArtificio:updateConfig', -1, data.active, location.name)
    end
    
    cb('ok')
end)

--------

RegisterNetEvent('lhdc_fogoArtificio:updateEnabledStatus')
AddEventHandler('lhdc_fogoArtificio:updateEnabledStatus', function(status, alias)
    -- Loop through Config entries and match alias
    for key, data in pairs(Config) do
        if type(data) == "table" and data.Alias and data.Alias == alias then
            data.enabled = status -- update enabled state
            --print(("Fireworks at '%s' set to: %s"):format(alias, tostring(status)))
            return
        end
    end

    --print("No config entry found with alias:", alias)
end)

RegisterNetEvent("lhdc_fogoArtificio:recieveUpdatedConfig")
AddEventHandler("lhdc_fogoArtificio:recieveUpdatedConfig", function(newConfig)
    Config = newConfig
end)

loadedClient = false
Citizen.CreateThread(function() --Starts Fireworks if player joins during event
	while not loadedClient do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('lhdc_fogoArtificio:requestUpdatedConfig')
            loadedClient = true
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        local anyEnabled = false

        for key, data in pairs(Config) do
            if type(data) == "table" and data.enabled == true then
                anyEnabled = true
                break  -- no need to check further once you find one true
            end
        end

        if anyEnabled then
            fireworking = true
        else
            fireworking = false
        end
        Citizen.Wait(1000) -- Check every second
    end
end)

Citizen.CreateThread(function()
	local pos = Config.SpawnFireworksInMazebankTower.Location -- Maze Bank

    local pos1 = Config.SpawnFireworksInCenterPark.Location -- Center Park

    local pos2 = Config.SpawnFireworksInVinewoodLogo.Location -- PT Logo

    local pos3 = Config.SpawnFireworksInMazeBank.Location -- maze bank arena

    local pos4 = Config.SpawnFireworksInRedBridge.Location -- Red Bridge

    local pos5 = Config.SpawnFireworksInRichardsMajestic.Location -- Richards Majestic

    local pos6 = Config.SpawnFireworksInObservatory.Location -- Observatory

    local pos7 = Config.SpawnFireworksInYacht.Location -- Yacht

    local pos8 = Config.SpawnFireworksInSandyShores.Location -- Sandy Shores

    local pos9 = Config.SpawnFireworksInMRC.Location -- MRC

    local pos10 = Config.SpawnFireworksInChiliad.Location -- Chiliad

    local pos11 = Config.SpawnFireworksInRoxwood.Location -- Roxwood

    local pos12 = Config.SpawnFireworksInJuniperByTheShore.Location -- Juniper By The Shore

    local pos13 = Config.SpawnFireworksInMarinaBeachLightHouse.Location -- Marina Beach Light House

    local pos14 = Config.SpawnFireworksInElGordoDrive.Location -- El Gordo Drive

    local pos15 = Config.SpawnFireworksInMountJosiah.Location -- Mount Josiah

    local pos16 = Config.SpawnFireworksInCargoShip.Location -- Cargo Ship

    local pos17 = Config.SpawnFireworksInCayoPerico.Location -- Cayo Perico

	local delay = 400

    local asset1 = "proj_indep_firework"
    RequestNamedPtfxAsset(asset1)
    while not HasNamedPtfxAssetLoaded(asset1) do
        Citizen.Wait(1)
    end
    local asset2 = "proj_indep_firework_v2"
    RequestNamedPtfxAsset(asset2)
	while not HasNamedPtfxAssetLoaded(asset2) do
        Citizen.Wait(1)
    end
	local asset3 = "scr_indep_fireworks"
    RequestNamedPtfxAsset(asset3)
	while not HasNamedPtfxAssetLoaded(asset3) do
        Citizen.Wait(1)
    end
    local asset4 = "proj_xmas_firework"
    RequestNamedPtfxAsset(asset4)
    while not HasNamedPtfxAssetLoaded(asset4) do
        Citizen.Wait(1)
    end

    while true do
        if(fireworking)then
            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos7[1] + math.random(-50, 50), pos7[2] + math.random(-50, 50), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos8[1] + math.random(-50, 50), pos8[2] + math.random(-50, 50), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset1)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end

            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos[1] + math.random(-200, 200), pos[2] + math.random(-200, 200), pos[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos1[1] + math.random(-100, 100), pos1[2] + math.random(-200, 200), pos1[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos2[1] + math.random(-200, 200), pos2[2] + math.random(-200, 200), pos2[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_spiral_burst_rwb", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end

            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(100, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end

            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false) 
            end

            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end

            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos[1], pos[2], pos[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos1[1], pos1[2], pos1[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos2[1], pos2[2], pos2[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos3[1], pos3[2], pos3[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos4[1], pos4[2], pos4[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos5[1], pos5[2], pos5[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos6[1], pos6[2], pos6[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos7[1], pos7[2], pos7[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos8[1], pos8[2], pos8[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos9[1], pos9[2], pos9[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos10[1], pos10[2], pos10[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos11[1], pos11[2], pos11[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos12[1], pos12[2], pos12[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos13[1], pos13[2], pos13[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos14[1], pos14[2], pos14[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos15[1], pos15[2], pos15[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos16[1], pos16[2], pos16[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset3)
                local part = StartParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", pos17[1], pos17[2], pos17[3], 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
        
            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset4)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_xmas_repeat_burst_rgw", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end

            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
            end
                
            Citizen.Wait(delay)
            if(Config.SpawnFireworksInMazebankTower.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos[1] + math.random(-100, 100), pos[2] + math.random(-100, 100), pos[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCenterPark.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos1[1] + math.random(-50, 50), pos1[2] + math.random(-100, 100), pos1[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInVinewoodLogo.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos2[1] + math.random(-100, 100), pos2[2] + math.random(-100, 100), pos2[3] + 25 + math.random(50, 200), 0.0, 0.0, 0.0, 5.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMazeBank.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos3[1] + math.random(-100, 100), pos3[2] + math.random(-100, 100), pos3[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRedBridge.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos4[1] + math.random(-100, 100), pos4[2] + math.random(-100, 100), pos4[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRichardsMajestic.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos5[1] + math.random(-100, 100), pos5[2] + math.random(-100, 100), pos5[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInObservatory.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos6[1] + math.random(-100, 100), pos6[2] + math.random(-100, 100), pos6[3] + 25 + math.random(100, 150), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInYacht.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos7[1] + math.random(-100, 100), pos7[2] + math.random(-100, 100), pos7[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInSandyShores.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos8[1] + math.random(-100, 100), pos8[2] + math.random(-100, 100), pos8[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMRC.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos9[1] + math.random(-50, 50), pos9[2] + math.random(-50, 50), pos9[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInChiliad.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos10[1] + math.random(-50, 50), pos10[2] + math.random(-50, 50), pos10[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInRoxwood.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos11[1] + math.random(-50, 50), pos11[2] + math.random(-50, 50), pos11[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInJuniperByTheShore.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos12[1] + math.random(-50, 50), pos12[2] + math.random(-50, 50), pos12[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMarinaBeachLightHouse.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos13[1] + math.random(-50, 50), pos13[2] + math.random(-50, 50), pos13[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInElGordoDrive.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos14[1] + math.random(-50, 50), pos14[2] + math.random(-50, 50), pos14[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInMountJosiah.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos15[1] + math.random(-50, 50), pos15[2] + math.random(-50, 50), pos15[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCargoShip.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos16[1] + math.random(-50, 50), pos16[2] + math.random(-50, 50), pos16[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
            if(Config.SpawnFireworksInCayoPerico.enabled)then
                UseParticleFxAssetNextCall(asset2)
                local part = StartParticleFxNonLoopedAtCoord("scr_xmas_firework_burst_fizzle", pos17[1] + math.random(-50, 50), pos17[2] + math.random(-50, 50), pos17[3] + 25 + math.random(50, 100), 0.0, 0.0, 0.0, 2.0, false, false, false)
                RemoveParticleFx(part, false)
            end
        else
            Citizen.Wait(1100)
        end
    end
end)

RegisterNetEvent("lhdc_fogoArtificio:start")
AddEventHandler("lhdc_fogoArtificio:start", function()
    fireworking = true
end)
RegisterNetEvent("lhdc_fogoArtificio:stop")
AddEventHandler("lhdc_fogoArtificio:stop", function()
    fireworking = false
end)