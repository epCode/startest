
local function purgil_brain(self)
	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		return
	end

	if mobkit.is_queue_empty_high(self) and not self._jump_status then

	end

end



minetest.register_entity("sw_mobs:rodian",{
											-- common props
	max_hp = 20,
	physical = true,
	collide_with_objects = true,
	collisionbox = {-0.4, -0, -0.4, 0.4, 1.6, 0.4},
	visual = "mesh",
	mesh = "3d_armor_character_rodian_male.b3d",
	visual_size = {x = 0.9, y = 0.9},
	textures = {
		{
			"3d_armor_trans.png", -- armor
			"player_species_gungan_skin.png", -- texture
			"3d_armor_trans.png", -- wielded_item
		},
	},
	--spritediv = {x = 1, y = 1},
	--initial_sprite_basepos = {x = 0, y = 0},

	static_save = true,
	makes_footstep_sound = false,

	on_step = mobkit.stepfunc,	-- required
	on_activate = mobkit.actfunc,		-- required
	get_staticdata = mobkit.statfunc,
											-- api props
	springiness=0,
	buoyancy = 0.75,					-- portion of hitbox submerged
	max_speed = 10,
	planets = {"tattooine"},
	jump_height = 1.26,
	view_range = 95,
	lung_capacity = 100, 		-- seconds
	timeout=600,
	attack={melee_range=8,speed = 20, damage_groups={fleshy=20}},
	sounds = {
		--attack='player_damage',
		},
	animation = {
		--def={range={x=1,y=20},speed=10,loop=true},
    fly = {range = {x = 1, y = 37}, speed = 24, frame_blend = 0.3, loop = true},
    hyperspace_stance = {range = {x = 45, y = 80}, speed = 10, frame_blend = 0, loop = false},
    hyperspace_jump = {range = {x = 81, y = 90}, speed = 44, frame_blend = 0, loop = false},
	},
	brainfunc = purgil_brain,

	on_punch= function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		cube_mobkit.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	end,

	-- dig on attack hitting
	on_attack_hit=function(self, target)

	end,

	drops = {
		--{name="default:copper_lump", min=1, max=1,prob=255/6},
	},

})

cube_mobkit.mob_names[#cube_mobkit.mob_names+1] = "sw_mobs:purgil"
