fireworking = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local year, month, day, hours, minutes, seconds = os.date("%Y"), os.date("%m"), os.date("%d"), os.date("%H"), os.date("%M"), os.date("%S")
        if((month == '01') and (day == '01') and (hours == '00') and (minutes == '00') and (seconds == '00'))then
            print('Started Fireworks')
            fireworking = true
            TriggerClientEvent("lhdc_fogoArtificio:start", -1)
        end
        if((month == '01') and (day == '01') and (hours == '00') and (minutes == Config.FireworksTime) and (seconds == '00'))then
            print('Stoped Fireworks')
            fireworking = false
            TriggerClientEvent("lhdc_fogoArtificio:stop", -1)
        end
    end
end)

RegisterServerEvent('lhdc_fogoArtificio:isFireworking')
AddEventHandler('lhdc_fogoArtificio:isFireworking', function()
    local src = source
    TriggerClientEvent('lhdc_fogoArtificio:returnFireworkingStatus', src, fireworking)
end)

RegisterServerEvent('lhdc_fogoArtificio:updateConfig')
AddEventHandler('lhdc_fogoArtificio:updateConfig', function(source, status, alias)
        -- Loop through Config entries and match alias
        for key, data in pairs(Config) do
            if type(data) == "table" and data.Alias and data.Alias == alias then
                data.enabled = status -- update enabled state
                TriggerClientEvent('lhdc_fogoArtificio:updateEnabledStatus', -1, status, alias)
                print(("Fireworks at '%s' set to: %s"):format(alias, tostring(status)))
                return
            end
        end

        print("No config entry found with alias:", alias)
end)