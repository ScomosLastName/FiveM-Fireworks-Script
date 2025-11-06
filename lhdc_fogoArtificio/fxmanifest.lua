fx_version 'adamant'

game 'gta5'

author "M0chi_"
description "Fireworks Script Forked From GasparMPereira on GitHub"
version '1.0.0'

client_scripts {
    'client.lua',
    'client_exports.lua'
}
server_script 'server.lua'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

ui_page 'html/index.html'
files {
    "html/index.html",
}

-- I ♡ Claude