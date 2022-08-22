
local function rodian_brain(self)
	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		mobkit.animate(self, "still")
		minetest.after(1.2, function()
			if self and self.object then
				local rot = self.object:get_rotation()
				self.object:set_rotation({x=rot.x, y=rot.y, z=rot.z-1.57})
				mobkit.animate(self, "die")
			end
		end)
		return
	end

	---wander


	if mobkit.is_queue_empty_high(self) then
		mobkit.animate(self, "idle")
	end

end



minetest.register_entity("sw_mobs:rodian",{







											-- common props
	max_hp = 20,
	physical = true,
	collide_with_objects = false,
	collisionbox = {-0.25, -0, -0.25, 0.25, 1.6, 0.25},
	visual = "mesh",
	mesh = "3d_armor_character_rodian_male.b3d",
	visual_size = {x = 0.9, y = 0.9},
	textures = {
		"player_species_rodian_skin.png",
		"3d_armor_trans.png",
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
		still={range={x=1,y=2},speed=10,loop=true},
    idle = {range = {x = 0, y = 79}, speed = 30, frame_blend = 0.3, loop = true},
    walk = {range = {x = 168, y = 187}, speed = 30, frame_blend = 0.3, loop = true},
    die = {range = {x = 162, y = 166}, speed = 30, frame_blend = 0.3, loop = true},
    sit = {range = {x = 162, y = 166}, speed = 30, frame_blend = 0.3, loop = true},
    attack = {range = {x = 81, y = 160}, speed = 30, frame_blend = 0.3, loop = true},
	},
	brainfunc = rodian_brain,

	on_punch= function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		cube_mobkit.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
		self.angry_at = puncher
	end,

	-- dig on attack hitting
	on_attack_hit=function(self, target)

	end,

	drops = {
		--{name="default:copper_lump", min=1, max=1,prob=255/6},
	},

})

cube_mobkit.mob_names[#cube_mobkit.mob_names+1] = "sw_mobs:rodian"
