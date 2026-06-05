-- Functions for slingshot mod

--- Slingshot mod API.
--
--  @module api


-- items currently in air
local tmp_throw = {}

-- times of last throw by users in milliseconds
local throw_timers = {}

local registered_ammos = {}

--- Register an item as ammunition for slingshot.
--
--  Any item can be thrown, but registering as ammo
--  allows custom attack value to be set.
--
--  @function slingshot.register_ammo
--  @tparam string name Item technical name.
--  @tparam int damage Damage value addon.
function slingshot.register_ammo(name, damage)
	registered_ammos[name] = damage
end

if slingshot.ammos and slingshot.ammos:trim() ~= "" then
	local ammos = string.split(slingshot.ammos:trim(), ",")
	for _, a in ipairs(ammos) do
		if a:find("=") then
			a = string.split(a, "=")
			local aname = a[1]:trim()
			local aval = tonumber(a[2]:trim()) or 0
			slingshot.register_ammo(aname, aval)
		end
	end
end


local get_thrown_target = function(thrown)
	for _, target in pairs(core.get_objects_inside_radius(thrown.ob:get_pos(), 1.5)) do
		repeat
			if target:get_luaentity() == nil then
				break
			elseif thrown.ob:is_player() then
				if thrown.ob:get_player_name() == thrown.user then
					-- ignore thrower
					break
				end

				if not slingshot.enable_pvp then
					return
				end
			elseif not target:get_luaentity() or (target:get_luaentity() and target:get_luaentity().name ~= "__builtin:item") then
				return target
			end
		until true
	end
end

-- Registers 'cooldown' time for repeat throws
--
-- FIXME: using  on_globalstep causes attack to miss when in sync
core.register_globalstep(function(dtime)
	for i, thrown in pairs(tmp_throw) do
		repeat
			if thrown.ob == nil or thrown.ob:get_pos() == nil then
				table.remove(tmp_throw, i)
				break
			end

			local velo = thrown.ob:get_velocity()
			if velo.x == 0 and velo.y == 0 and velo.z == 0 then
				-- thrown item has hit the ground
				thrown.ob:set_acceleration({x=0, y=0, z=0})
				table.remove(tmp_throw, i)
				break
			end
		until true

		local puncher = core.get_player_by_name(thrown.user)
		local target = get_thrown_target(thrown)
		if target ~= nil then
			-- DEBUG:
			slingshot.log("debug", "target: "..target:get_luaentity().name)

			-- FIXME: don't play hit sound if already implemented by entity/mod
			core.sound_play("slingshot_hard_punch", {pos=target:get_pos(), gain=1.0, max_hear_distance=5})
			target:punch(puncher, 1.0, {damage_groups=thrown.damage_groups}, nil)
			thrown.ob:set_acceleration({x=0, y=0, z=0})
			thrown.ob:set_velocity({x=0, y=-10, z=0})
			table.remove(tmp_throw, i)
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

	-- Throw items in slot to right
	local item = user:get_inventory():get_stack("main", user:get_wield_index()+1):get_name()

	if item == "" then return itemstack end

	local e = core.add_item({x=pos.x, y=pos.y+2, z=pos.z}, item)
	if e then
		e:set_velocity({x=dir.x*veloc, y=dir.y*veloc, z=dir.z*veloc})
		e:set_acceleration({x=dir.x*-3, y=-5, z=dir.z*-3})
		e:get_luaentity().age = slingshot.thrown_duration

		local dg = table.copy(damage_groups)

		if dg == nil then
			dg = {fleshy=1}
		end

		local addon = registered_ammos[item]
		if addon then
			for k, v in pairs(dg) do
				dg[k] = v + addon
			end
		end

		-- XXX: `timer` no longer used
		table.insert(tmp_throw, {ob=e, timer=2, user=user:get_player_name(), damage_groups=dg})

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


local register_repairable
if core.global_exists("xdecor") and xdecor.register_repairable then
	register_repairable = xdecor.register_repairable
elseif core.global_exists("workbench") and workbench.register_repairable then
	register_repairable = workbench.register_repairable
elseif core.global_exists("WB") and WB.register_repairable then
	register_repairable = WB.register_repairable
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

	local sname = "slingshot:" .. name

	core.register_tool(sname, {
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

			-- time of throw attempt in milliseconds
			local throw_time = math.floor(core.get_us_time() / 1000)
			local pname = user:get_player_name()
			-- TODO: configure cooldown in settings
			local cooldown = 200 - (throw_time - (throw_timers[pname] or 0))
			if cooldown > 0 then
				slingshot.log("debug", "player "..pname.." must wait "..(cooldown/1000).." seconds to throw again")
				return itemstack
			end

			-- update player throw time
			throw_timers[pname] = throw_time

			return on_throw(itemstack, user, def.velocity, def.wear_rate, def.damage_groups)
		end,
	})

	if register_repairable then register_repairable(nil, sname) end

	if def.recipe then
		slingshot.log("warning", "\"recipe\" attribute no longer supported in registration")
	end
	if def.ingredient then
		slingshot.log("warning", "\"ingredient\" attribute no longer supported in registration")
	end
	if def.aliases then
		slingshot.log("warning", "\"aliases\" attribute no longer supported in registration")
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
--  - Same as [core.register_tool.tool_capabilities.damage_groups](https://github.com/luanti-org/luanti/blob/71b02d6/doc/lua_api.txt#L1551)
--  - Default: {fleshy=1}
--  @tfield int velocity Speed & distance at which items will be thrown.
--  @tfield int wear_rate Rate at which the slingshot will wear & break.
--  @see slingshot.register
