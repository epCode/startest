sw_ships = {
  hyperspace_invi_timer={},
  ship_vector_vel={},
  throttle_hud={}
}

local path = minetest.get_modpath("sw_ships")
dofile(path .. "/ship_api.lua")
dofile(path .. "/register_nodes.lua")
dofile(path .. "/register_starships.lua")
