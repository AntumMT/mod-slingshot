-- Functions for slingshot mod

--- Slingshot mod API.
--
--  @module api


local tmp_throw = {}
local tmp_throw_timer = 0


-- Registers 'cooldown' time for repeat throws
core.register_globalstep(function(dtime)
	tmp_throw_timer = tmp_throw_timer + dtime
	if tmp_throw_timer < 0.2 then return end

	-- Reset cooldown
	tmp_throw_timer = 0
	for i, t in pairs(tmp_throw) do
		local puncher = core.get_player_by_name(t.user)
		t.timer = t.timer-0.25
		if t.timer <= 0 or t.ob == nil or t.ob:get_pos() == nil then table.remove(tmp_throw, i) return end
		for ii, ob in pairs(core.get_objects_inside_radius(t.ob:get_pos(), 1.5)) do
			if (not ob:get_luaentity()) or (ob:get_luaentity() and (ob:get_luaentity().name ~= "__builtin:item")) then
				-- Which entities can be attacked (mobs & other players unless PVP is enabled)
				if (not ob:is_player()) or (ob:is_player() and ob:get_player_name(ob) ~= t.user and slingshot.enable_pvp) then
					ob:punch(puncher, 1.0, {damage_groups=t.damage_groups}, nil)
					t.ob:set_velocity({x=0, y=0, z=0})
					t.ob:set_acceleration({x=0, y=-10, z=0})
					t.ob:set_velocity({x=0, y=-10, z=0})
					table.remove(tmp_throw, i)
					core.sound_play("slingshot_hard_punch", {pos=ob:get_pos(), gain=1.0, max_hear_distance=5,})
					break
				end
			end
		end
	end
end)


--- Action to take when slingshot is used.
--
--  @local
--  @function on_throw
--  @param itemstack
--  @param user
--  @param veloc
local function on_throw(itemstack, user, veloc, wear_rate, damage_groups)
	local pos = user:get_pos()
	local upos = {x=pos.x, y=pos.y+2, z=pos.z}
	local dir = user:get_look_dir()
	local item = itemstack:to_table()

	-- Throw items in slot to right
	local item = user:get_inventory():get_stack("main", user:get_wield_index()+1):get_name()

	if item == "" then return itemstack end

	local e = core.add_item({x=pos.x, y=pos.y+2, z=pos.z}, item)
	if e then
		e:set_velocity({x=dir.x*veloc, y=dir.y*veloc, z=dir.z*veloc})
		e:set_acceleration({x=dir.x*-3, y=-5, z=dir.z*-3})
		e:get_luaentity().age = slingshot.thrown_duration

		if damage_groups == nil then
			damage_groups = {fleshy=1}
		end

		table.insert(tmp_throw, {ob=e, timer=2, user=user:get_player_name(), damage_groups=damage_groups})

		if not slingshot.creative then
			if slingshot.enable_wear then
				if wear_rate == nil then
					wear_rate = 100
				end

				slingshot.log("debug", "Wear rate: " .. tostring(wear_rate))

				itemstack:add_wear(wear_rate)
			end

			user:get_inventory():remove_item("main", item)
		end

		core.sound_play("slingshot_throw", {pos=pos, gain=1.0, max_hear_distance=5,})
		return itemstack
	end
end


--- Registers a new slingshot.
--
--  'def' should include 'description', 'damage_groups', & 'velocity'.
--
--  @function slingshot.register
--  @tparam string name Name of the slingshot (e.g. ***"iron"***).
--  @tparam table def Slingshot definition table (see [slingshot.register.def](#slingshot.register.def)).
function slingshot.register(name, def)
	if def.inventory_image then
		-- Inventory image will override image if set
		def.image = def.inventory_image
	end

	if not def.image then
		-- The default slingshot
		if name == "slingshot" then
			def.image = "slingshot.png"
		else
			def.image = "slingshot_" .. name .. ".png"
		end
	end

	if not def.wield_image then
		-- Use inventory image
		def.wield_image = def.image
	end

	core.register_tool("slingshot:" .. name, {
		description = def.description,
		range = 4,
		inventory_image = def.image,
		wield_image = def.wield_image,

		on_use = function(itemstack, user, pointed_thing)
			--[[ Disabled picking up items with slingshot in hand
			if pointed_thing.ref and pointed_thing.ref:is_player() == false and pointed_thing.ref:get_luaentity().name == "__builtin:item" then
				pointed_thing.ref:punch(user, {full_punch_interval=1.0, damage_groups=def.damage_groups}, "", nil)
				return itemstack
			end
			]]
			on_throw(itemstack, user, def.velocity, def.wear_rate, def.damage_groups)
			return itemstack
		end,
	})

	-- def.ingredient overrides def.recipe
	if def.ingredient ~= nil then
		if slingshot.require_rubber_band and core.global_exists("technic") then
			-- More complicated recipe for technic
			def.recipe = {
				{def.ingredient, "slingshot:rubber_band", def.ingredient},
				{"", def.ingredient, ""},
				{"", def.ingredient, ""},
			}
		else
			def.recipe = {
				{def.ingredient, "", def.ingredient},
				{"", def.ingredient, ""},
				{"", def.ingredient, ""},
			}
		end
	end

	-- Optional register a craft recipe
	if def.recipe ~= nil then
		core.register_craft({
			output = "slingshot:" .. name,
			recipe = def.recipe,
		})
	end

	-- Optionally register aliases
	if def.aliases ~= nil then
		for index, alias in ipairs(def.aliases) do
			core.register_alias(alias, "slingshot:" .. name)
		end
	end
end


--- Function Definition Tables.
--
--  @section fdtables

--- Slingshot definition table.
--
--  @table slingshot.register.def
--  @tfield string description Human-readable description of slingshot (e.g. ***"Wooden Slinghot"***).
--  @tfield table damage_groups
--  - Same as [minetest.register_tool.tool_capabilities.damage_groups](https://github.com/minetest/minetest/blob/71b02d6/doc/lua_api.txt#L1551)
--  - Default: {fleshy=1}
--  @tfield int velocity Speed & distance at which items will be thrown.
--  @tfield int wear_rate Rate at which the slingshot will wear & break.
--  @tfield table recipe A custom recipe to use for crafting.
--  @tfield string ingredient Creates a standard craft recipe using this ingredient (overrides ***recipe***).
--  @tfield table aliases List of item names that should be uses as aliases for this slingshot.
--  @see slingshot.register
