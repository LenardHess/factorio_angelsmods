if settings.startup["angels-override-map-gen-preset"].value
then
  -- Hijack the default prefix
  data.raw["map-gen-presets"]["default"]["angels-default"] = data.raw["map-gen-presets"]["default"]["default"]
  data.raw["map-gen-presets"]["default"]["default"] = nil
  data.raw["map-gen-presets"]["angels-default"] = data.raw["map-gen-presets"]["default"]
  data.raw["map-gen-presets"]["angels-default"].name = "angels-default"
  data.raw["map-gen-presets"]["default"] = nil

  local map_gen_presets = data.raw["map-gen-presets"]["angels-default"]
  local map_settings = data.raw["map-settings"]["map-settings"]

  -- Recreate the basegame default prefix
  -- Yes, the key is strange :D
  map_gen_presets["angels-basegame-default"] = {
      order = "ab", -- Place this right beneath the new angels default
  }

  -- Locate all the other presets
  local other_presets = {}
  for k, v in pairs(map_gen_presets)
  do
    other_presets[k] = true
  end
  -- Remove keys that aren't presets: "type", "name", "default"
  other_presets["type"] = nil
  other_presets["name"] = nil
  other_presets["default"] = nil
  -- Also ignore our default ("angels-default")
  other_presets["angels-default"] = nil
  -- Remaining are other map presets

  -- Fixup other preset to not have our pending adjustments
  -- Only adjust settings that were using the now-modified default
  for preset_name, _ in pairs(other_presets)
  do
    map_gen_presets[preset_name].basic_settings = map_gen_presets[preset_name].basic_settings or {}
    map_gen_presets[preset_name].advanced_settings = map_gen_presets[preset_name].advanced_settings or {}

    local basic_settings = map_gen_presets[preset_name].basic_settings
    local adv_settings = map_gen_presets[preset_name].advanced_settings

    basic_settings.peaceful_mode = map_settings.peaceful_mode

    adv_settings.pollution = adv_settings.pollution or {}
    if adv_settings.pollution.enabled == nil
    then
      adv_settings.pollution.enabled = map_settings.pollution.enabled
    end

    adv_settings.enemy_evolution = adv_settings.enemy_evolution or {}
    if adv_settings.enemy_evolution.enabled == nil
    then
      adv_settings.enemy_evolution.enabled = map_settings.enemy_evolution.enabled
    end

    adv_settings.enemy_expansion = adv_settings.enemy_expansion or {}
    if adv_settings.enemy_expansion.enabled == nil
    then
      adv_settings.enemy_expansion.enabled = map_settings.enemy_expansion.enabled
    end
  end

  -- Adjust the actual defaults
  map_settings.peaceful_mode = true -- THIS DOES NOT ACTUALLY EXIST :(
  map_settings.pollution.enabled = false
  map_settings.enemy_evolution.enabled = false
  map_settings.enemy_expansion.enabled = false
end