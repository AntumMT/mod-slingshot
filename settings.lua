-- Slingshot settings

--- Slingshot mod settings.
--
-- @module settings



--- Common Settings.
--
-- Settings shared with other mods.
--
-- @section settings_common


--- Determines if game is being run in creative mode.
--
-- @setting creative_mode
-- @settype bool

--- Enables/Disables wear/break of slingshots when used for attacking.
--
-- @setting enable_weapon_wear
-- @settype bool
-- @default true



--- Unique Settings.
--
-- Settings unique to this mod.
--
-- @section settings_unique


--- Require rubber band for slingshot craft recipe.
--
-- @setting slingshot.require_rubber_band
-- @settype bool
-- @default true
slingshot.require_rubber_band = core.settings:get_bool('slingshot.require_rubber_band') ~= false
