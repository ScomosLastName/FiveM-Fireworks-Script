# FiveM-Fireworks-Script
FiveM Fireworks Script for New Year, will automatically start fireworks for all players at 00:00 on New Year

# How-To
Drag and Drop the script in you server resources folder, add 'ensure lhdc_fogoArtificio' in your server.cfg

# Commands
Use `fireworks` in either F8 of `/fireworks` in your chat if you have a supported chat resource, to bring up the control UI

# Exports
```lua
exports.lhdc_fogoArtificio.ToggleFireworks(alias, status)
```
Toggle the active status of any 1 firework location:<br>
`alias`: One of the Alias values related to the location you intend to toggle you can find these with the GetLocationData() export<br>
`status`: `true` or `false`
```lua
exports.lhdc_fogoArtificio.GetLocationKeys()
```
Returns All location keys defined in the config
```lua
exports.lhdc_fogoArtificio.GetLocationData()
```
Returns Data Related to All Locations
