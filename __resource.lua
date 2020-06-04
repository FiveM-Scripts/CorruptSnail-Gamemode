resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
resource_type 'gametype' { name = 'CorruptSnail' }

shared_script "config.lua"

client_scripts {
	"cl_utils.lua",
	"cl_entityenum.lua",
	"cl_player.lua",
	"cl_env.lua",
	"cl_groupholder.lua",
	"cl_pedscache.lua",
	"spawning/cl_player.lua",
	"spawning/cl_zombies.lua",
	"spawning/cl_savezones.lua"
}

server_scripts{
    "spawning/sv_savezones.lua"
}