local abs = math.abs
local function dir_to_pitch(dir)
	--local dir2 = vector.normalize(dir)
	local xz = math.abs(dir.x) + math.abs(dir.z)
	return -math.atan2(-dir.y, xz)
end

function round(num, dp)
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

minetest.register_on_joinplayer(function(player)
	sw_ships.throttle_hud[player:get_player_name()] = nil
end)

function sw_ships.add_throttle_hud(player)
	sw_ships.throttle_hud[player:get_player_name()] = {
		stress_bar = player:hud_add({
			hud_elem_type = "image",
			position = {x = 0.05, y = 0.7},
			scale = {x = 0, y = 0},
			text = "red.png",
			z_index = -100,
		}),
		stress_bar_outline = player:hud_add({
			hud_elem_type = "image",
			position = {x = 0.05, y = 0.7},
			scale = {x = 25, y = 25},
			text = "red.png^[colorize:#3e3e3e:255]",
			z_index = -101,
		}),
		engine_indicator = player:hud_add({
			hud_elem_type = "image",
			position = {x = 0.05, y = 0.3},
			scale = {x = 0, y = 0},
			text = "red.png",
			z_index = -101,
		}),
	}
end
function sw_ships.remove_throttle_hud(player)
	if sw_ships.throttle_hud[player:get_player_name()] then
		player:hud_remove(sw_ships.throttle_hud[player:get_player_name()].stress_bar)
		player:hud_remove(sw_ships.throttle_hud[player:get_player_name()].stress_bar_outline)
		player:hud_remove(sw_ships.throttle_hud[player:get_player_name()].engine_indicator)
		sw_ships.throttle_hud[player:get_player_name()] = nil
	end
end

function sw_ships.change_throttle_hud(player, id, param, thing)
	player:hud_change(sw_ships.throttle_hud[player:get_player_name()][id], param, thing)
end

local SHIP_ENTITY={
	use_texture_alpha = true,
	physical = true,
	pointable = true,
	visual = "mesh",
	mesh = "sw_ships_x_wing.b3d",
	visual_size = {x=7, y=7},
	textures = {"sw_ships_x_wing.png"},
	collisionbox = {-1, -1.5, -1, 1, 0.5, 1},
	collide_with_objects = true,

	_lastpos={},
	_driver=nil,
	_rotating_vel={x=0,y=0,z=0},
	_throttle=0,
	_throttle_max=0,
	_throttle_max=10,
	_tilt_devider=13,
	_speed_max=30,
	_destroyed=nil,
	_yaw_snap=0.05,
	_roll=0,
	_textures={},
	_hyperdrive=true,
	_hyperspace_invi_timer=0,
	_shoot_timer=0,
	friction=0,
	_jet_offsets={},
	_particle_timer=0,
	_last_vel=vector.new(0,0,0),
	_engine=false,
}


function SHIP_ENTITY.on_activate(self)
	self.object:set_acceleration({x=0,y=-9.81,z=0})
	self.object:set_properties({textures={self._textures[1]..".png"}})
end

function SHIP_ENTITY.on_deactivate(self)
	if self._driver then
		self._driver:set_detach()
		sw_ships.remove_throttle_hud(self._driver)
		self._driver:set_pos(self.object:get_pos())
		self._driver = nil
	end
end


function SHIP_ENTITY.on_step(self, dtime)

	local vel = self.object:get_velocity()
	local rot = self.object:get_rotation()
	local look_dir = vector.rotate(vector.new(0,0,1), rot)

	self._particle_timer=self._particle_timer+dtime

	self._shoot_timer=self._shoot_timer+dtime

	if self._hyperspace_invi_timer < 3 then
		self._hyperspace_invi_timer = self._hyperspace_invi_timer + dtime
	end

	if vel.y < 0 then
		self.object:set_velocity({x=vel.x*self.friction,y=vel.y,z=vel.z*self.friction})
	else
		self.object:set_velocity({x=vel.x*self.friction,y=vel.y*self.friction,z=vel.z*self.friction})
	end
	if abs(vel.x)+abs(vel.y)+abs(vel.z)<self._speed_max then
		local add_vel = vector.new(0,0,0)
		if self._driver then
			local control = self._driver:get_player_control()
			if control.left and control.right then
				add_vel = vector.new(0,0.6,0)
			end
		end
		self.object:add_velocity(vector.add(vector.multiply(look_dir, (self._throttle/5)), add_vel))
	end



	if self._driver then

		if not sw_ships.throttle_hud[self._driver:get_player_name()] then
			sw_ships.add_throttle_hud(self._driver)
		elseif sw_ships.throttle_hud[self._driver:get_player_name()].stress_bar then
			sw_ships.change_throttle_hud(self._driver, "stress_bar", "scale", {x = 20, y = self._throttle*8})
			sw_ships.change_throttle_hud(self._driver, "stress_bar_outline", "scale", {x = 25, y = self._throttle_max*8+5})
			sw_ships.change_throttle_hud(self._driver, "stress_bar", "position", {x = 0.05, y = self._throttle*-0.0076+0.7})
			sw_ships.change_throttle_hud(self._driver, "stress_bar_outline", "position", {x = 0.05, y = self._throttle_max*-0.0076+0.7})
			sw_ships.change_throttle_hud(self._driver, "stress_bar", "text", "red.png^[colorize:"..sfinv.num_to_color(self._throttle)..":255]")
			if self._engine == true then
				sw_ships.change_throttle_hud(self._driver, "engine_indicator", "scale", {x = 30, y = 30})
			else
				sw_ships.change_throttle_hud(self._driver, "engine_indicator", "scale", {x = 0, y = 0})
			end
		end

		local dname = self._driver:get_player_name()

		self._driver:set_pos(self.object:get_pos())

		local dirver_pos = self._driver:get_pos()

		local control = self._driver:get_player_control()

		if control.aux1 and not self._engine then
			minetest.after(1,function()
				if self and self.object and self._driver then
					self._engine = true
				end
			end)
		end

		if self._engine and control.left and control.right and control.aux1 and self._hyperdrive==true and not multidimensions.registered_dimensions[multidimensions.player_pos[self._driver:get_player_name()].name] then
			multidimensions.form(self._driver,self.object)
		end

		if self._engine and control.aux1 and not (control.left and control.right) and self._shoot_timer>0.2 and self._offsets then
			for i_=1, #self._offsets do
				self._shoot_timer = 0
				local offset=vector.rotate_around_axis(self._offsets[i_], vector.new(0,1,0), self.object:get_yaw())
				sw_blasters.shoot_entity(nil, self.object, self._driver:get_wielded_item(), "sw_blasters:blast_entity", 50, 0, 20, {"sw_blasters_blast_red.png"}, 0, 0, look_dir, {x=10,y=10}, vector.add(self.object:get_pos(), offset))
			end
		end


		local dtime_rounded = round(dtime, 1)
		if dtime_rounded < 0.1 then
			dtime_rounded = 0.1
		end
		dtime_rounded=dtime_rounded*10
		local ctrl_yaw = 0
		local ctrl_pitch = 0
		local ctrl_roll = 0

		if not sw_ships.ship_vector_vel[dname] then
			sw_ships.ship_vector_vel[dname] = vector.new(0,0,0)
		end

		local ctrl_yaw = 0
		if not (control.left and control.right) then
			if control.left then
				ctrl_yaw = -1
			elseif control.right then
				ctrl_yaw = 1
			end
		end
		if control.up then
			ctrl_pitch = 1
		elseif control.down then
			ctrl_pitch = -1
		end
		local ship_rot_vel = sw_ships.ship_vector_vel[dname]


		self._turning_speed = 0.008*(self._throttle/self._throttle_max+0.02)

		ship_rot_vel.y=(ship_rot_vel.y+(self._turning_speed*-ctrl_yaw*dtime_rounded))
		ship_rot_vel.x=(ship_rot_vel.x+(self._turning_speed*-ctrl_pitch*dtime_rounded))
		ship_rot_vel.z=-ship_rot_vel.y*2

		if not self._engine then
			ship_rot_vel.x=vel.y*10000000*0.0000000004
			ship_rot_vel.y=vel.y*10000000*0.0000000004
			ship_rot_vel.z=vel.y*10000000*0.0000000004
		end

		if minetest.registered_nodes[minetest.get_node(vector.add(self.object:get_pos(), vector.new(0,(self.collisionbox[2]-0.2),0))).name].walkable then
			rot.x=ship_rot_vel.x*((math.abs(vel.x)+math.abs(vel.z))*.05)
			rot.z=ship_rot_vel.z*((math.abs(vel.x)+math.abs(vel.z))*.05)
			self.friction=0.75
		else
			self.friction=0.93
		end


		--self.object:set_properties({automatic_rotate=ship_rot_vel.y*20})
		self.object:set_rotation({x=ship_rot_vel.x*dtime_rounded+rot.x, y=ship_rot_vel.y*dtime_rounded+rot.y, z=ship_rot_vel.z*dtime_rounded+rot.z*0.9})

		sw_ships.ship_vector_vel[dname] = vector.multiply(sw_ships.ship_vector_vel[dname], 0.9)

		if control.jump and self._throttle<self._throttle_max and self._engine then
			self._throttle = self._throttle+0.4
			if self._throttle>self._throttle_max then
				self._throttle = self._throttle_max
			end
		elseif control.sneak and self._throttle>0 and self._engine then
			self._throttle = self._throttle-0.5
			if self._throttle<0 then
				self._throttle = 0
			end
		elseif not self._engine then
			self._throttle = 0
		end
	end

	local points_of_collision = {
		vector.new(self.collisionbox[1]+0.3,0,0),
		vector.new(0,self.collisionbox[2]+0.3,0),
		vector.new(0,0,self.collisionbox[3]+0.3),
		vector.new(self.collisionbox[4]+0.3,0,0),
		vector.new(0,self.collisionbox[5]+0.3,0),
		vector.new(0,0,self.collisionbox[6]+0.3),
	}

	if math.abs(self._last_vel.x) > 10 and math.abs(vel.x)<0.01 then
		self._destroyed=true
	elseif math.abs(self._last_vel.y) > 10 and math.abs(vel.y)<0.01 then
		self._destroyed=true
	elseif math.abs(self._last_vel.z) > 10 and math.abs(vel.z)<0.01 then
		self._destroyed=true
	end

	if self._throttle > 0.1 and self._particle_timer > 0.3 then
		for i_=1, #self._jet_offsets do
			self._particle_timer = 0
			minetest.add_particlespawner({
				pos=self._jet_offsets[i_],
				time = 0.5,
				amount = 7,
				minvel = vector.new(-1.5,-1.5,-10+-self._throttle),
				maxvel = vector.new(1.5,1.5,-10+-self._throttle),
				collisiondetection = true,
				texture=self._thruster_textures[math.random(#self._thruster_textures)],
				size=self._thruster_size,
				glow=minetest.LIGHT_MAX,
				minexptime=self._thruster_length/2,
				maxexptime=self._thruster_length,
				animation={
					type = "vertical_frames",

	        aspect_w = 8,

	        aspect_h = 8,

	        length = 0.1,
				},
				attached=self.object,
			})

		end
	end

	if self._destroyed then
		if self._driver then
			self._driver:set_detach()
			sw_ships.remove_throttle_hud(self._driver)
			self._driver:set_hp(self._driver:get_hp()-30)
		end
		self.object:remove()
	end
	self._last_vel=vel
end

function SHIP_ENTITY.on_rightclick(self, clicker)
	if clicker:is_player() then
		if not self._driver then
			self._driver = clicker
			clicker:set_attach(self.object, "Main", {x=0,y=0,z=0}, {x=0,y=0,z=0}, true)
		else
			self._driver:set_pos(self.object:get_pos())
			self._driver=nil
			sw_ships.remove_throttle_hud(clicker)
			clicker:set_detach()
			clicker:set_pos(self.object:get_pos())
		end
	end
end

function sw_ships.register_ship(name, def)
	local NEW_SHIP_ENTITY = table.copy(SHIP_ENTITY)
	NEW_SHIP_ENTITY.collisionbox = def.collisionbox
	NEW_SHIP_ENTITY._throttle_max = def.max_throttle
	NEW_SHIP_ENTITY._speed_max = def.max_speed
	NEW_SHIP_ENTITY.mesh = def.mesh
	NEW_SHIP_ENTITY.visual_size = def.visual_size
	NEW_SHIP_ENTITY._textures = def.textures
	NEW_SHIP_ENTITY._turn_roll_amount = def.turn_roll_amount
	NEW_SHIP_ENTITY._yaw_snap = def.yaw_snap
	NEW_SHIP_ENTITY._offsets = def.blast_points
	NEW_SHIP_ENTITY._jet_offsets = def.thruster_positions
	NEW_SHIP_ENTITY._thruster_size = def.thruster_size
	NEW_SHIP_ENTITY._thruster_textures = def.thruster_textures
	NEW_SHIP_ENTITY._thruster_length = def.thruster_length or 0.3
	minetest.register_entity(name, NEW_SHIP_ENTITY)

	local shiplist = def.ship_build_schem
	--local shiplist = {"+0,+1,-1,sw_core_items:sandstone_desert_pale_with_two_red_lines", "+0,+1,-2,sw_core_items:sandstone_desert_pale_with_two_red_lines"}

	minetest.register_node(name, {
		description=def.description,
		stack_max=1,
		use_texture_alpha = "blend",
		wield_scale = {x=1,y=1,z=1},
		paramtype = "light",
		drawtype = "mesh",
		mesh=def.mesh,
		tiles = {def.textures[1]..".png"},
		on_place = function(itemstack, placer, pointed_thing)
			minetest.add_entity(vector.add(pointed_thing.above, {x=0,y=-minetest.registered_entities[name].collisionbox[2],z=0}), name)
			itemstack:take_item()
			return itemstack
		end,
	})


	minetest.register_abm({
		label = name,
		nodenames = {shiplist[1]},
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
	    local check = true
	    local ship_made=nil
	    for i=1, 4 do
	      local inv=i

	      if not ship_made then
	        check = true
					for id=1, #shiplist do
						if id ~= 1 then
		          local target_node=string.sub(shiplist[id], 10, -1)
		          local x_way=tonumber(string.sub(shiplist[id], 1, 2))
		          local y_way=tonumber(string.sub(shiplist[id], 4, 5))
		          local z_way=tonumber(string.sub(shiplist[id], 7, 8))
		          if inv==1 then
		            z_way=tonumber(string.sub(shiplist[id], 1, 2))
		            y_way=tonumber(string.sub(shiplist[id], 4, 5))
		            x_way=tonumber(string.sub(shiplist[id], 7, 8))
		          elseif inv==2 then
		            x_way=tonumber(string.sub(shiplist[id], 1, 2))*-1
		            y_way=tonumber(string.sub(shiplist[id], 4, 5))
		            z_way=tonumber(string.sub(shiplist[id], 7, 8))*-1
		          elseif inv==3 then
		            z_way=tonumber(string.sub(shiplist[id], 1, 2))*-1
		            y_way=tonumber(string.sub(shiplist[id], 4, 5))
		            x_way=tonumber(string.sub(shiplist[id], 7, 8))*-1
		          end
		          if check == true then
		            if minetest.get_node(vector.add(pos,vector.new(x_way,y_way,z_way))).name == target_node then
		              check = true
		            else
		              check = false
		            end
		          end
						end
	        end
	        if check==true then
	          ship_made=inv
	        end
	      end
	    end
	    if check == true then
				for id=1, #shiplist do
					if id ~= 1 then
						local target_node=string.sub(shiplist[id], 10, -1)
						local x_way=tonumber(string.sub(shiplist[id], 1, 2))
						local y_way=tonumber(string.sub(shiplist[id], 4, 5))
						local z_way=tonumber(string.sub(shiplist[id], 7, 8))
						if ship_made==1 then
							z_way=tonumber(string.sub(shiplist[id], 1, 2))
							y_way=tonumber(string.sub(shiplist[id], 4, 5))
							x_way=tonumber(string.sub(shiplist[id], 7, 8))
						elseif ship_made==2 then
							x_way=tonumber(string.sub(shiplist[id], 1, 2))*-1
							y_way=tonumber(string.sub(shiplist[id], 4, 5))
							z_way=tonumber(string.sub(shiplist[id], 7, 8))*-1
						elseif ship_made==3 then
							z_way=tonumber(string.sub(shiplist[id], 1, 2))*-1
							y_way=tonumber(string.sub(shiplist[id], 4, 5))
							x_way=tonumber(string.sub(shiplist[id], 7, 8))*-1
						end
						minetest.remove_node(vector.add(pos,vector.new(x_way,y_way,z_way)))
					end
					minetest.remove_node(pos)
					minetest.add_entity(pos, name)
		    end
			end
		end,
	})

end
