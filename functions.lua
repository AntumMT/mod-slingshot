-- Functions for slingshot mod


local hook_tmp_throw = {}
local hook_tmp_time = tonumber(minetest.setting_get('item_entity_ttl')) or 890


function slingshot.on_use(itemstack, user)
	local veloc = 15
	local pos = user:getpos()
	local upos = {x=pos.x, y=pos.y+2, z=pos.z}
	local dir = user:get_look_dir()
	local item = itemstack:to_table()
	local mode = minetest.deserialize(item['metadata'])
	if mode == nil then mode = 1 else mode = mode.mode end

	local item = user:get_inventory():get_stack('main', user:get_wield_index()+mode):get_name()
	if item == '' then return itemstack end
	local e = minetest.add_item({x=pos.x, y=pos.y+2, z=pos.z}, item)
	e:setvelocity({x=dir.x*veloc, y=dir.y*veloc, z=dir.z*veloc})
	e:setacceleration({x=dir.x*-3, y=-5, z=dir.z*-3})
	e:get_luaentity().age = hook_tmp_time
	table.insert(hook_tmp_throw, {ob=e, timer=2, user=user:get_player_name()})

	if item == 'slingshot:slingshot' then
	itemstack:set_wear(9999999)
	end

	user:get_inventory():remove_item('main', item)
	minetest.sound_play('slingshot_throw', {pos=pos, gain = 1.0, max_hear_distance = 5,})
	return itemstack
end
