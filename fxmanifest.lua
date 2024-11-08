fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'GoodNetwork'
description 'The best FiveM hud'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}
client_scripts {
    'client/*.lua'
}

files {
    'html/index.html',
    'html/assets/js/**',
    'html/assets/css/**',
    'html/assets/img/**',
    'stream/minimap.ytd',
    'stream/minimap.gfx'
}

ui_page 'html/index.html'

data_file 'DLC_ITYP_REQUEST' 'stream/minimap.gfx'