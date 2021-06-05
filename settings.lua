-- Slingshot settings

--- Slingshot mod settings.
--
--  @module settings


--- Slingshot specicif settings.
--
--  Settings unique to this mod.
--
--  @section settings_specific


--- Require rubber band for slingshot craft recipe.
--
--  @setting slingshot.require_rubber_band
--  @settype bool
--  @default true
slingshot.require_rubber_band = core.settings:get_bool("slingshot.require_rubber_band", true)


--- General settings.
--
--  Settings commom to core & other mods.
--
--  @section settings_general


--- Enables/Disables wear when used.
--
--  @setting enable_weapon_wear
--  @settype bool
--  @default true
slingshot.enable_wear = core.settings:get_bool("enable_weapon_wear", true)

--- Log extra messages.
--
--  @setting log_mods
--  @settype bool
--  @default false
slingshot.log_mods = core.settings:get_bool("log_mods", false)

--- Log extra debug messages.
--
--  @setting enable_debug_mods
--  @settype bool
--  @default false
slingshot.debug = core.settings:get_bool("enable_debug_mods", false)

--- Determines if game is being run in creative mode.
--
--  @setting creative_mode
--  @settype bool
--  @default false
slingshot.creative = core.settings:get_bool("creative_mode", false)

--- Time in seconds for item entity (dropped items) to live.
--
--  Setting it to -1 disables the feature.
--
--  @setting item_entity_ttl
--  @settype int
--  @default 890
slingshot.thrown_duration = tonumber(core.settings:get("item_entity_ttl")) or 890

--- Determines if PVP is enabled.
--
--  @setting enable_pvp
--  @settype bool
--  @default false
slingshot.enable_pvp = core.settings:get_bool("enable_pvp", false)
