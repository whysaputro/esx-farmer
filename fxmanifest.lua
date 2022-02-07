fx_version 'bodacious'

game 'gta5'

description 'Job Petani'
author 'Whysaputro'

version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/creds.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}




