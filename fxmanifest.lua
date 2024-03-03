fx_version 'cerulean'
games { 'gta5' }
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'm-dev.eu'
description 'Farming'
version '0.0.0'
license 'GNU General Public License v3.0'

dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_script 'init.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua'
}

files {
    'modules/**/client.lua',
    'modules/**/shared.lua',
    'locales/*.json',
    'data/*.lua',
    'client.lua',
}