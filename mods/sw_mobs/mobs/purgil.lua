
local function purgil_brain(self)
	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		return
	end

	self._lights_timer = self._lights_timer + 0.1

	if self._lights_index and self._lights_timer > 0.2 then
		self._lights_timer = 0
		if self._lights_index == 5 then
			self._lights_index = 1
		else
			self._lights_index = self._lights_index + 1
		end
		self.object:set_properties({textures = {"sw_mobs_purgil.png^sw_mobs_purgil_lights_"..self._lights_index..".png"}})
	end

	if mobkit.timer(self,1) then


		if (math.random(1, 10) == 1 or self.hyperspace_signal) and not self._jump_status then
			self._lights_index = 1
			self._jump_status = "readying"
			mobkit.clear_queue_high(self)
			mobkit.clear_queue_low(self)
			if self.hyperspace_signal then

			else
				self.nearby_objects = minetest.get_objects_inside_radius(self.object:get_pos(), 60)
				for i,obj in pairs(self.nearby_objects) do
					if mobkit.is_alive(obj) and obj ~= self.object and obj:get_luaentity() and obj:get_luaentity().name == "sw_mobs:purgil" and not self.hyperspace_signal then
						obj:get_luaentity().hyperspace_signal = self.object
					end
				end
			end
			mobkit.animate(self,'hyperspace_stance')
			minetest.after(5, function()
				if self and self.object then
					mobkit.animate(self,'hyperspace_jump')
					minetest.after(0.1, function()
						self._jump_status = "jumping"
					end)
				end
			end)
		end
	end


	if self._jump_status == "jumping" then
		self.object:set_properties({physical = false})
		local look_dir = vector.rotate(vector.new(0,0,1), self.object:get_rotation())
		self.object:set_velocity(vector.multiply(look_dir, 1000))
	elseif self._jump_status == "readying" then
		self.object:set_velocity(vector.multiply(self.object:get_velocity(), 0.95))
	end



	if mobkit.is_queue_empty_high(self) and not self._jump_status then
		local _rot = self.object:get_rotation()
		self._rot_vel = {x = 0, y = 0, z = 0}
		self._rot_vel.y = (self._rot_vel.y+math.random(1, 20)-10+self._rot_vel.y)*0.003
		self.object:set_rotation(vector.add(self._rot_vel, _rot))
		local look_dir = vector.rotate(vector.new(0,0,1), self.object:get_rotation())
		self.object:set_velocity(vector.multiply(look_dir, 11))
		mobkit.animate(self,'fly')
	end

end



minetest.register_entity("sw_mobs:purgil",{
											-- common props
	max_hp = 200,
	physical = true,
	collide_with_objects = true,
	collisionbox = {-5, -5, -5, 5, 5, 5},
	visual = "mesh",
	mesh = "sw_mobs_purgil.b3d",
	visual_size = {x = 5, y = 5},
	textures = {"sw_mobs_purgil.png"},
	spritediv = {x = 1, y = 1},
	initial_sprite_basepos = {x = 0, y = 0},
	gravity = 0,
	_jump_status = nil,

	static_save = true,
	makes_footstep_sound = false,

	on_step = mobkit.stepfunc,	-- required
	on_activate = cube_mobkit.actfunc,		-- required
	get_staticdata = mobkit.statfunc,
											-- api props
	springiness=0,
	buoyancy = 0.75,					-- portion of hitbox submerged
	max_speed = 10,
	planets = {"space"},
	jump_height = 1.26,
	view_range = 95,
	lung_capacity = 100, 		-- seconds
	timeout=600,
	_lights_timer = 0,
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
		--target:punch(self.object,1,self.attack)
	end,

	drops = {
		--{name="default:copper_lump", min=1, max=1,prob=255/6},
	},

})

cube_mobkit.mob_names[#cube_mobkit.mob_names+1] = "sw_mobs:purgil"
