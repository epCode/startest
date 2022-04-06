sw_ships.register_ship("sw_ships:x_wing", 10, 30, {"sw_ships_x_wing"}, "sw_ships_x_wing.b3d", {x=42,y=42}, 13, 0.5, {-1, -1.5, -1, 1, 0.5, 1})

minetest.register_node("sw_ships:x_wing", {
	description=("X-Wing"),
	stack_max=1,
	use_texture_alpha = "blend",
	wield_scale = {x=1,y=1,z=1},
	paramtype = "light",
	drawtype = "mesh",
	mesh="sw_ships_x_wing.b3d",
	tiles = {"sw_ships_x_wing.png"},
	on_place = function(itemstack, placer, pointed_thing)
		minetest.add_entity(vector.add(pointed_thing.above, {x=0,y=1,z=0}), "sw_ships:x_wing")
		itemstack:take_item()
		return itemstack
	end,
})

sw_ships.register_ship("sw_ships:tie_fighter", 15, 40, {"sw_ships_tie_fighter"}, "sw_ships_tie_fighter.b3d", {x=42,y=42}, 16, 1, {-1.5, -2, -1.5, 1.5, 2, 1.5})

minetest.register_node("sw_ships:tie_fighter", {
	description=("Tie Fighter"),
	stack_max=1,
	use_texture_alpha = "blend",
	wield_scale = {x=1,y=1,z=1},
	paramtype = "light",
	drawtype = "mesh",
	mesh="sw_ships_tie_fighter.b3d",
	tiles = {"sw_ships_tie_fighter.png"},
	--tiles={"sw_ships_tie_fighter.png"},
	--inventory_image="sw_ships_tie_fighter_inv.png",
	on_place = function(itemstack, placer, pointed_thing)
		minetest.add_entity(vector.add(pointed_thing.above, {x=0,y=2,z=0}), "sw_ships:tie_fighter")
		itemstack:take_item()
		return itemstack
	end,
})
