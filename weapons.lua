-- Registrations for slinghot mod


local textures = {
	rubber_band = "rubber_band",
	wood = "wood",
	iron = "iron",
}
if slingshot.old_textures then
	for k, v in pairs(textures) do
		textures[k] = v .. "-old"
	end
end


core.register_craftitem("slingshot:rubber_band", {
	description = "Rubber band",
	inventory_image = "slingshot_" .. textures.rubber_band .. ".png",
})

if core.global_exists("technic") then
	core.register_craft({
		output = "slingshot:rubber_band 6",
		type = "shapeless",
		recipe = {"technic:rubber"},
	})

	core.register_craft({
		output = "slingshot:rubber_band 2",
		recipe = {
			{"technic:raw_latex", "technic:raw_latex", ""},
			{"technic:raw_latex", "", "technic:raw_latex"},
			{"", "technic:raw_latex", "technic:raw_latex"},
		}
	})
end


local ing_1 = "group:stick"
local ing_2 = ""
if core.global_exists("technic") and slingshot.require_rubber_band then
	ing_2 = "slingshot:rubber_band"
end

-- A wooden slingshot
slingshot.register("wood", {
	description = "Wooden slingshot",
	image = "slingshot_" .. textures.wood .. ".png",
	damage_groups = {fleshy=1},
	velocity = 10,
	wear_rate = 500,
})
for _, a in ipairs({slingshot.modname .. ":wooden", "wood_slingshot", "wooden_slingshot"}) do
	core.register_alias(a, slingshot.modname .. ":wood")
end

core.register_craft({
	output = slingshot.modname .. ":wood",
	recipe = {
		{ing_1, ing_2, ing_1},
		{"", ing_1, ""},
		{"", ing_1, ""},
	}
})


ing_1 = "default:steel_ingot"

-- A stronger iron slingshot
slingshot.register("iron", {
	description = "Iron Slingshot",
	image = "slingshot_" .. textures.iron .. ".png",
	damage_groups = {fleshy=3},
	velocity = 15,
	wear_rate = 250,
})
for _, a in ipairs({slingshot.modname .. ":slingshot", "iron_slingshot"}) do
	core.register_alias(a, slingshot.modname .. ":iron")
end

core.register_craft({
	output = slingshot.modname .. ":iron",
	recipe = {
		{ing_1, ing_2, ing_1},
		{"", ing_1, ""},
		{"", ing_1, ""},
	}
})
