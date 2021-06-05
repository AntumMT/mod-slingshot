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
		output = "slingshot:rubber_band 20",
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


-- A wooden slingshot
slingshot.register("wood", {
	description = "Wooden slingshot",
	image = "slingshot_" .. textures.wood .. ".png",
	damage_groups = {fleshy=1},
	velocity = 10,
	wear_rate = 500,
	ingredient = "group:stick",
	aliases = {
		slingshot.modname .. ":wooden",
		"wood_slingshot",
		"wooden_slingshot",
	}
})


-- A stronger iron slingshot
slingshot.register("iron", {
	description = "Iron Slingshot",
	image = "slingshot_" .. textures.iron .. ".png",
	damage_groups = {fleshy=3},
	velocity = 15,
	wear_rate = 250,
	ingredient = "default:steel_ingot",
	aliases = {
		slingshot.modname,
		slingshot.modname .. ":slingshot",
		"iron_slingshot",
	},
})
