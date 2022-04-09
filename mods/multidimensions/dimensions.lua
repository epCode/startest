--[[local ores={
	["default:stone_with_coal"]=200,
	["default:stone_with_iron"]=400,
	["default:stone_with_copper"]=500,
	["default:stone_with_gold"]=2000,
	["default:stone_with_mese"]=10000,
	["default:stone_with_diamond"]=20000,
	["default:mese"]=40000,
	["default:gravel"]={chance=3000,chunk=2,}
}]]
--[[
local plants = {
	["flowers:mushroom_brown"] = 1000,
	["flowers:mushroom_red"] = 1000,
	["flowers:mushroom_brown"] = 1000,
	["flowers:rose"] = 1000,
	["flowers:tulip"] = 1000,
	["flowers:dandelion_yellow"] = 1000,
	["flowers:geranium"] = 1000,
	["flowers:viola"] = 1000,
	["flowers:dandelion_white"] = 1000,
	["default:junglegrass"] = 2000,
	["default:papyrus"] = 2000,
	["default:grass_3"] = 10,

	["multidimensions:tree"] = 1000,
	["multidimensions:aspen_tree"] = 1000,
	["multidimensions:pine_tree"] = 1000,
}]]
--[[
minetest.register_node("multidimensions:tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_treesnow", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:jungle_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:aspen_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:acacia_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})]]

multidimensions.register_dimension("tattooine",{
  grass = "sw_core_items:sand_desert_light",
  dirt = "sw_core_items:sand_desert_light_packed",
  sand = "sw_core_items:sand_desert_light_hard",
  stone = "sw_core_items:sandstone_desert_light",
  water = "sw_core_items:sand_desert_light_hard",
  terrain_density = .1,
  enable_water = false,
  map = {
    offset = 0,
    scale = .3,
    spread = {x=100,y=18,z=100},
    seeddiff = 1,
    octaves = 5,
    persist = 0.7,
    lacunarity = 1,
    flags = "absvalue",
   },
	--ground_ores = [],
	--stone_ores = [],
	--sand_ores={["default:clay"]={chunk=2,chance=5000}},
	--grass_ores={
		--["default:dirt_with_snow"]={chance=1,max_heat=20},
	--},
	--[[water_ores={
		["default:ice"]={chance=1,max_heat=20},
	},]]
})
multidimensions.register_dimension("planet2",{
  grass = "sw_core_items:sand_desert_light_hard",
  dirt = "sw_core_items:sand_desert_light_hard",
  sand = "sw_core_items:sand_desert_light_hard",
  stone = "sw_core_items:sand_desert_light_hard",
  water = "sw_core_items:sand_desert_light_hard",
  terrain_density = .1,
  enable_water = false,
  map = {
    offset = 0,
    scale = .3,
    spread = {x=100,y=18,z=100},
    seeddiff = 1,
    octaves = 5,
    persist = 0.7,
    lacunarity = 1,
    flags = "absvalue",
   },
	--ground_ores = [],
	--stone_ores = [],
	--sand_ores={["default:clay"]={chunk=2,chance=5000}},
	--grass_ores={
		--["default:dirt_with_snow"]={chance=1,max_heat=20},
	--},
	--[[water_ores={
		["default:ice"]={chance=1,max_heat=20},
	},]]
})
--[[
minetest.register_lbm({
	name = "multidimensions:lbm",
	run_at_every_load = true,
	nodenames = {"group:multidimensions_tree"},
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
		local tree=""
		if node.name=="multidimensions:tree" then
			tree=minetest.get_modpath("default") .. "/schematics/apple_tree.mts"
		elseif node.name=="multidimensions:pine_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/pine_tree.mts"
		elseif node.name=="multidimensions:pine_treesnow" then
			tree=minetest.get_modpath("default") .. "/schematics/snowy_pine_tree_from_sapling.mts"
		elseif node.name=="multidimensions:jungle_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/jungle_tree.mts"
		elseif node.name=="multidimensions:aspen_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/aspen_tree.mts"
		elseif node.name=="multidimensions:acacia_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/acacia_tree.mts"
		end
		minetest.place_schematic({x=pos.x,y=pos.y,z=pos.z}, tree, "random", {}, true)
	end,
})
]]

local tattooine = multidimensions.registered_dimensions["tattooine"]
local planet2 = multidimensions.registered_dimensions["planet2"]

minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	local planet = meta:get_string("spawn_planet")
  local pos = player:get_pos()
	if planet == "tattooine" then
		player:set_pos({x=pos.x,y=tattooine.dirt_start+tattooine.dirt_depth+10,z=pos.z})
	elseif planet == "planet2" then
		player:set_pos({x=pos.x,y=planet2.dirt_start+planet2.dirt_depth+10,z=pos.z})
	end
  return true
end)
