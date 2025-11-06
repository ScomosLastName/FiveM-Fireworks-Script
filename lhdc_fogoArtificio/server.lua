RegisterServerEvent('lhdc_fogoArtificio:updateConfig')
AddEventHandler('lhdc_fogoArtificio:updateConfig', function(source, status, alias)
        -- Loop through Config entries and match alias
        for key, data in pairs(Config) do
            if type(data) == "table" and data.Alias and data.Alias == alias then
                data.enabled = status -- update enabled state
                TriggerClientEvent('lhdc_fogoArtificio:updateEnabledStatus', -1, status, alias)
                print(("Fireworks at '%s' set to: %s, By: %s"):format(alias, tostring(status), source))
                return
            end
        end

        print("No config entry found with alias:", alias)
end)

RegisterServerEvent('lhdc_fogoArtificio:requestUpdatedConfig')
AddEventHandler('lhdc_fogoArtificio:requestUpdatedConfig', function(source)
    TriggerClientEvent("lhdc_fogoArtificio:recieveUpdatedConfig", source, Config)
end)

lib.addCommand('fireworks', {restricted = 'admin'}, function(source, args, raw)
    if source > 0 then
        TriggerClientEvent('lhdc_fogoArtificio:toggleUI', source)
    end
end)