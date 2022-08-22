sw_ships = {
  hyperspace_invi_timer={}
}

local path = minetest.get_modpath("sw_ships")
dofile(path .. "/ship_api.lua")
dofile(path .. "/register_nodes.lua")
dofile(path .. "/register_starships.lua")
