exports('ToggleFireworks', function(Alias, status)
    TriggerServerEvent('lhdc_fogoArtificio:updateConfig', -1, status, Alias)
end)

exports('GetLocationKeys', function()
    return Config.Keys
end)

exports('GetLocationData', function()
    local result = {}

    for _, key in ipairs(Config.Keys) do
        if Config[key] and Config[key] then
            table.insert(result, Config[key])
        end
    end

    return result
end)
