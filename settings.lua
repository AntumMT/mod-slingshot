-- Slingshot settings

--- Slingshot mod settings.
--
--  @module settings


--- Slingshot specific settings.
--
--  Settings unique to this mod.
--
--  @section settings_specific


--- Use old 16x16 textures.
--
--  @setting slingshot.old_textures
--  @settype bool
--  @default false
slingshot.old_textures = core.settings:get_bool("slingshot.old_textures", false)

--- Value of these items will be added to slingshot attack when thrown.
--
--  @setting slingshot.ammos
--  @settype string
--  @default default:mese_crystal=5
slingshot.ammos = core.settings:get("slingshot.ammos") or "default:mese_crystal=5"

--- Time in seconds for ammo to exist in world.
--
--  Setting to -1 disables expiration. Defaults to value of `item_entity_ttl` if not set.
--
--  FIXME: setting to 900 (same as `item_entity_ttl` default) breaks throwing
--
--  @setting slingshot.ammo_ttl
--  @settype int
--  @default 890
slingshot.thrown_duration = tonumber(core.settings:get("slingshot.ammo_ttl")) or 890
--~ slingshot.thrown_duration = tonumber(core.settings:get("slingshot.ammo_ttl")) or tonumber(core.settings:get("item_entity_ttl")) or 900


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

slingshot.creative = core.settings:get_bool("creative_mode", false)

slingshot.enable_pvp = core.settings:get_bool("enable_pvp", true)


-- settings not configured here

--- Item texture resolution to use when available.
--
--  @setting item_texture_res
--  @settype enum
--  @enum_values 16, 32
--  @default 16
