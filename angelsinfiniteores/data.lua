--INITIALIZE
angelsmods = angelsmods or {}
angelsmods.ores = angelsmods.ores or {}
angelsmods.functions = angelsmods.functions or {}
angelsmods.functions.store = angelsmods.functions.store or {}
angelsmods.functions.store.update = angelsmods.functions.store.update or {}
angelsmods.functions.store.make = angelsmods.functions.store.make or {}

--SET MOD OPTIONS
angelsmods.ores.yield = settings.startup["angels-infinite-yield"].value
angelsmods.ores.loweryield = settings.startup["angels-lower-infinite-yield"].value
angelsmods.ores.enablefluidreq = settings.startup["angels-enablefluidreq"].value
angelsmods.ores.disable_ore_override = angelsmods.refining and angelsmods.refining.disable_ore_override or false

--LOAD RESOURCE GENERATOR
require("prototypes.generation.resource-builder")

--GENERATE PROTOTYPES
require("prototypes.generation.vanilla-ore-inf")

require("prototypes.generation.angels-ore-inf")

require("prototypes.generation.bob-ore-inf")

require("prototypes.generation.py-ore-inf")

require("prototypes.generation.yuoki-ore-inf")

require("prototypes.generation.dm-tenemut")

log(data.raw["noise-expression"]["default-coal-patches"].expression)
-- EXECUTE FUNCTIONS
angelsmods.functions.make_resource()


log(data.raw["noise-expression"]["default-coal-patches"].expression)
log(data.raw["noise-expression"]["default-infinite-coal-patches"].expression)

-- EXPERIMENT: Kill the "blob" noise from the ore generator function, turning ore circles into simple circles (not for starting area tho)
log(serpent.block(data.raw["noise-function"]["resource_autoplace_all_patches"].local_functions))
data.raw["noise-function"]["resource_autoplace_all_patches"].local_functions.regular_blob_amplitude_at.expression="0"


-- ------- Reference example from Keithen ----------------------------------
-- local copper = data.raw["noise-expression"]["default-copper-ore-patches"]
-- local iron = data.raw["noise-expression"]["default-iron-ore-patches"]

-- copper.expression = iron.expression:gsub("resource_autoplace_all_patches", "resource_autoplace_all_patches_infinite")

-- local cp = table.deepcopy(data.raw["noise-function"]["resource_autoplace_all_patches"])
-- cp.name = "resource_autoplace_all_patches_infinite"
-- cp.local_expressions.regular_patches =
-- 	"(spot_noise{x = x,y = y,density_expression = regular_density_at(distance),spot_quantity_expression = regular_spot_quantity_expression,spot_radius_expression = min(32, regular_rq_factor * regular_spot_quantity_expression ^ (1/3)),spot_favorability_expression = 1,seed0 = map_seed,seed1 = seed1,region_size = 1024,candidate_spot_count = candidate_spot_count,suggested_minimum_candidate_point_spacing = 45.254833995939045,skip_span = regular_patch_set_count,skip_offset = regular_patch_set_index,hard_region_target_quantity = 0,basement_value = basement_value,maximum_spot_basement_radius = 128} + (blobs0 + basis_noise{x = x, y = y, seed0 = map_seed, seed1 = seed1, input_scale = 1/64, output_scale = 1.5} - 1/3) * regular_blob_amplitude_at(distance)) * 2 - 10000"
-- data.extend({ cp })
-- -------------------------------------------------------------------------


-- Create a copy of the base game resource patch noise function
-- We'll use this to make "coupled" resource patches, i.e. small infinite patches in the center of normal ones.
local cp = table.deepcopy(data.raw["noise-function"]["resource_autoplace_all_patches"])
cp.name = "resource_autoplace_all_patches_coupled"
-- We modify the expression for regular patches by wrapping the spot_noise expression with extra controls
-- It is necessary to keep the spot_noise function identical across coupled usages.
-- If we have multiple distinct spot_noise expressions, they will not generate identical output,
-- as the output spots "avoid" each other.
local expression_regular_patches = cp.local_expressions.regular_patches
cp.local_expressions.regular_patches = "(" .. expression_regular_patches .. ") * 2 - 7500" --* 2 - 10000"
data.extend({ cp })

-- Couple the infinite coal to the normal coal
-- This is done by first copying the expression (thus having identical parameters),
-- and then substituting the expression with our wrapping expression
-- local coal_normal   = data.raw["noise-expression"]["default-coal-patches"]
-- local coal_infinite = data.raw["noise-expression"]["default-infinite-coal-patches"]
-- coal_infinite.expression = coal_normal.expression:gsub("resource_autoplace_all_patches", "resource_autoplace_all_patches_coupled")

log(data.raw["noise-expression"]["default-coal-patches"].expression)
log(data.raw["noise-expression"]["default-infinite-coal-patches"].expression)
