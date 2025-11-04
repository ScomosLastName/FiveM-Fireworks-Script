exports('StartFireworks', function(name, status)
    TriggerServerEvent('lhdc_fogoArtificio:updateConfig', -1, status, name)
end)

exports('GetLocationsKeys', function()
    return Config.Keys
end)