
slingshot = {
	modname = core.get_current_modname(),
	log = function() end
}
slingshot.modpath = core.get_modpath(slingshot.modname)

if core.global_exists("register_mod_logger") then
	register_mod_logger(slingshot)
end


local scripts = {
	"settings",
	"api",
	"weapons",
}

for index, script in ipairs(scripts) do
	dofile(slingshot.modpath .. "/" .. script .. ".lua")
end
