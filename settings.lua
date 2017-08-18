-- Slingshot settings

--- Slingshot mod settings.
--
-- @module settings


--- Require rubber band for slingshot craft recipe.
--
-- @setting slingshot.require_rubber_band
-- @settype bool
-- @default true
slingshot.require_rubber_band = core.settings:get_bool('slingshot.require_rubber_band') ~= false
