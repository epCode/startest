local shiplist = {
	"sw_ships:yg_8018_engine_s12",
	---WINGS
	"+1,+1,+0,sw_core_items:sand_desert_light_packed",
	"+2,+2,+0,sw_core_items:sand_desert_light_packed",
	"-1,+1,+0,sw_core_items:sand_desert_light_packed",
	"-2,+2,+0,sw_core_items:sand_desert_light_packed",
-----WING2
	"+1,-1,+0,sw_core_items:sand_desert_light_packed",
	"+2,-2,+0,sw_core_items:sand_desert_light_packed",
	"-1,-1,+0,sw_core_items:sand_desert_light_packed",
	"-2,-2,+0,sw_core_items:sand_desert_light_packed",

---BODY:
	"+0,+0,+1,sw_core_items:sandstone_desert_pale_with_brown_band_top",
	"+0,+0,+2,sw_core_items:sandstone_desert_pale_with_brown_band_top",
	"+0,+0,+3,sw_core_items:sandstone_desert_pale_with_brown_band_top",
	"+0,+0,+4,sw_core_items:sandstone_desert_pale_with_brown_band_top",

}
sw_ships.register_ship("sw_ships:x_wing", {
	description=("X Wing"),
	max_throttle = 10,
	max_speed = 30,
	textures = {"sw_ships_x_wing"},
	mesh = "sw_ships_x_wing.b3d",
	visual_size = {x=40,y=40},
	turn_roll_amount = 13,
	collisionbox = {-1, -1, -1, 1, 1, 1},
	ship_build_schem = shiplist,
	thruster_size=10,
	thruster_length=0.1,
	thruster_textures={"sw_ships_jet_anim_red_lr.png"},
	thruster_positions = {vector.new(1,-0.5,-2.3), vector.new(-1,-0.5,-2.3), vector.new(1,.3,-2.3), vector.new(-1,.3,-2.3)},
	blast_points = {vector.new(2.7,-0.9,0), vector.new(-2.7,-0.9,-1), vector.new(2.7,-2.8,0), vector.new(-2.7,-2.8,0)},
})


shiplist = {"sw_ships:yg_8018_engine_s12", "+0,+2,-1,sw_core_items:sandstone_desert_pale"}

sw_ships.register_ship("sw_ships:tie_fighter", {
	description=("Tie fighter"),
	max_throttle = 15,
	max_speed = 40,
	textures = {"sw_ships_tie_fighter"},
	mesh = "sw_ships_tie_fighter.b3d",
	visual_size = {x=42,y=42},
	turn_roll_amount = 13,
	collisionbox = {-1.5, -2, -1.5, 1.5, 2, 1.5},
	ship_build_schem = shiplist,
	thruster_length=0.1,
	thruster_size=4,
	thruster_textures={"red.png"},
	thruster_positions = {},
	blast_points = {vector.new(0.4,-2,0), vector.new(-0.4,-2,0)},
})

shiplist = {"sw_ships:yg_8018_engine_s12", "+0,+2,-1,sw_core_items:sandstone_desert_pale"}

sw_ships.register_ship("sw_ships:a_wing", {
	description=("A Wing"),
	max_throttle = 15,
	max_speed = 40,
	textures = {"sw_ships_a_wing"},
	mesh = "sw_ships_a_wing.b3d",
	visual_size = {x=20,y=20},
	turn_roll_amount = 13,
	collisionbox = {-1.5, -0.4, -1.5, 1.5, 0.7, 1.5},
	ship_build_schem = shiplist,
	thruster_length=0.1,
	thruster_size=4,
	thruster_textures={"red.png"},
	thruster_positions = {},
	blast_points = {vector.new(0.4,-2,0), vector.new(-0.4,-2,0)},
})

shiplist = {"sw_ships:yg_8018_engine_s12", "+0,+2,-1,sw_core_items:sandstone_desert_pale"}

sw_ships.register_ship("sw_ships:star_destroyer", {
	description=("Star Destroyer"),
	max_throttle = 15,
	max_speed = 40,
	textures = {"sw_ships_destroyer"},
	mesh = "sw_ships_star_destroyer.b3d",
	visual_size = {x=50,y=50},
	turn_roll_amount = 13,
	collisionbox = {-20, -20, -20, 20, 20, 20},
	ship_build_schem = shiplist,
	thruster_length=0.1,
	thruster_size=4,
	thruster_textures={"red.png"},
	thruster_positions = {},
	blast_points = {vector.new(0.4,-2,0), vector.new(-0.4,-2,0)},
})
