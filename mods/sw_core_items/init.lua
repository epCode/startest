local register_node = minetest.register_node
local register_alias = minetest.register_alias
local S = minetest.get_translator(minetest.get_current_modname())
--##################################################--
--DESERT-----------------------------------------------------
--##################################################--
register_node('sw_core_items:sand_desert_light', {
    description=S("Light Desert Sand"),
    tiles = { 'sw_core_items_sand_desert_light.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})

register_node('sw_core_items:sand_desert_light_packed', {
    description=S("Light Desert Packed Sand"),
    tiles = { 'sw_core_items_sand_desert_light_packed.png' },
    groups = { oddly_breakable_by_hand = 1 },
    is_ground_content = true
})

register_node('sw_core_items:sand_desert_light_hard', {
    description=S("Light Desert Hard Sand"),
    tiles = { 'sw_core_items_sand_desert_light_hard.png'},
    groups = { oddly_breakable_by_hand = 1 },
    is_ground_content = true
})

register_node('sw_core_items:sandstone_desert_light', {
    description=S("Light Desert Sandstone"),
    tiles = { 'sw_core_items_sandstone_desert_light.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})

register_node('sw_core_items:sandstone_desert_pale', {
    description=S("Pale Desert Sandstone"),
    tiles = { 'sw_core_items_sandstone_desert_pale.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})

register_node('sw_core_items:sandstone_desert_pale_with_two_red_lines', {
    description=S("Pale Desert Sandstone with two Red Lines"),
    tiles = {  'sw_core_items_sandstone_desert_pale.png', 'sw_core_items_sandstone_desert_pale.png', 'sw_core_items_sandstone_desert_pale_with_two_red_lines.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})

register_node('sw_core_items:sandstone_desert_pale_with_brown_band_top', {
    description=S("Pale Desert Sandstone Brown Band Top"),
    tiles = { 'sw_core_items_sandstone_desert_pale.png', 'sw_core_items_sandstone_desert_pale.png', 'sw_core_items_sandstone_desert_pale_with_brown_band_top.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})
register_node('sw_core_items:sandstone_desert_pale_with_brown_band_bottom', {
    description=S("Pale Desert Sandstone Brown Band bottom"),
    tiles = { 'sw_core_items_sandstone_desert_pale.png', 'sw_core_items_sandstone_desert_pale.png', 'sw_core_items_sandstone_desert_pale_with_brown_band_bottom.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})


--[[
register_node('sw_core_items:water_source', {
    tiles = { 'sw_core_items_water_source.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})]]

--[[
register_alias('mapgen_stone', 'sw_core_items:stone')
register_alias('mapgen_water_source', 'sw_core_items:water_source')
register_alias('mapgen_river_water_source', 'sw_core_items:river_water_source')
]]
