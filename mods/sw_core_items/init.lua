local register_node = minetest.register_node
local register_alias = minetest.register_alias


register_node('sw_core_items:sand_desert_light', {
    tiles = { 'sw_core_items_sand_desert_light.png' },
    groups = { oddly_breakable_by_hand = 3 },
    is_ground_content = true
})

register_node('sw_core_items:sand_desert_light_packed', {
    tiles = { 'sw_core_items_sand_desert_light_packed.png' },
    groups = { oddly_breakable_by_hand = 1 },
    is_ground_content = true
})

register_node('sw_core_items:sand_desert_light_hard', {
    tiles = { 'sw_core_items_sand_desert_light_hard.png'},
    groups = { oddly_breakable_by_hand = 1 },
    is_ground_content = true
})

register_node('sw_core_items:sandstone_desert_light', {
    tiles = { 'sw_core_items_sandstone_desert_light.png' },
    groups = { },
    is_ground_content = true
})

register_node('sw_core_items:bedrock', {
    tiles = { 'sw_core_items_grass.png' },
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
