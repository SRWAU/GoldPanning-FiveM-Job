fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Gold Panning Script'
author 'v4nte'
description 'A simple gold panning script using ox_target for FiveM'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_target',
    'es_extended',
    'progressBars'
}