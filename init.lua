
slingshot = {}
slingshot.modname = minetest.get_current_modname()
slingshot.modpath = minetest.get_modpath(slingshot.modname)


if minetest.settings:get_bool('log_mods') then
	minetest.log('action', '[slingshot] Require rubber band: ' .. tostring(slingshot.require_rubber_band))
end


local scripts = {
	'settings',
	'api',
	'weapons',
}

for index, script in ipairs(scripts) do
	dofile(slingshot.modpath .. '/' .. script .. '.lua')
end
