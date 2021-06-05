
title = "Slingshot for Minetest"
project = "Slingshot"
format = "discount"
not_luadoc = true
wrap = true
boilerplate = true
ignore = true


local function italic(value)
	return "<i>" .. value .. "</i>"
end

new_type("setting", "Configuration Settings")
custom_tags = {
	{"settype",
		title = "Type",
		format = italic,
	},
	{"default",
		title = "Default",
		format = italic,
	},
}
