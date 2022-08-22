local S = minetest.get_translator(minetest.get_current_modname())


minetest.register_node("sw_ships:yg_8018_engine_s12", {
	description = "Starship engine\n\n"..minetest.colorize("#00b61b", "YG series-8018 - s12"),
	tiles = {"sw_ships_engine_yg_8018_s12.png", "sw_ships_engine_yg_8018_s12_1.png", "sw_ships_engine_yg_8018_s12_1.png", "sw_ships_engine_yg_8018_s12_2.png", "sw_ships_engine_yg_8018_s12_2.png"},
	groups = {pickaxey=1, ship_material=1},
	--sounds = mcl_sounds.node_sound_stone_defaults(),
})

minetest.register_node("sw_ships:yg_hull_doonium_s12", {
	description = "Starship hull\n\n"..minetest.colorize("#00b61b", "YG - Doonium shell compound - s12"),
	tiles = {"sw_ships_yg_hull_doonium_s12.png"},
	groups = {pickaxey=1, ship_material=1},
	--sounds = mcl_sounds.node_sound_stone_defaults(),
})
