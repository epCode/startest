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
}


function SHIP_ENTITY.on_activate(self)
	self.object:set_acceleration({x=0,y=-9.81,z=0})
	self.object:set_properties({textures={self._textures[1]..".png"}})
end

function SHIP_ENTITY.on_deactivate(self)
	if self._driver then
		self._driver:set_detach()
		self._driver:set_pos(self.object:get_pos())
		self._driver = nil
	end
end


function SHIP_ENTITY.on_step(self, dtime)

	local vel = self.object:get_velocity()
	local rot = self.object:get_rotation()
	local look_dir = vector.rotate(vector.new(0,0,1), rot)

	self._shoot_timer=self._shoot_timer+dtime

	if self._hyperspace_invi_timer < 3 then
		self._hyperspace_invi_timer = self._hyperspace_invi_timer + dtime
	end

	if vel.y < 0 then
		self.object:set_velocity({x=vel.x*0.93,y=vel.y*0.96,z=vel.z*0.93})
	else
		self.object:set_velocity({x=vel.x*0.93,y=vel.y*0.93,z=vel.z*0.93})
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

		local dname = self._driver:get_player_name()

		self._driver:set_pos(self.object:get_pos())

		local dirver_pos = self._driver:get_pos()

		local control = self._driver:get_player_control()

		if control.left and control.right and control.aux1 and self._hyperdrive==true and not multidimensions.registered_dimensions[multidimensions.player_pos[self._driver:get_player_name()].name] then
			multidimensions.form(self._driver,self.object)
		end

		if control.aux1 and not (control.left and control.right) and self._shoot_timer>0.2 then
			local offsets = {vector.new(2.7,-0.9,0), vector.new(-2.7,-0.9,0), vector.new(2.7,-2.8,0), vector.new(-2.7,-2.8,0)}
			for i_=1, #offsets do
				self._shoot_timer = 0
				local offset=vector.rotate_around_axis(offsets[i_], vector.new(0,1,0), self.object:get_yaw())
				sw_blasters.shoot_entity(nil, self._driver, self._driver:get_wielded_item(), "sw_blasters:blast_entity", 50, 0, 20, {"sw_blasters_blast_red.png"}, 0, 0, look_dir, {x=10,y=10}, vector.add(self.object:get_pos(), offset))
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


		ship_rot_vel.y=(ship_rot_vel.y+(0.01*-ctrl_yaw))
		ship_rot_vel.x=(ship_rot_vel.x+(0.01*-ctrl_pitch))
		ship_rot_vel.z=-ship_rot_vel.y*2

		if minetest.registered_nodes[minetest.get_node(vector.add(self.object:get_pos(), vector.new(0,(self.collisionbox[2]-0.2),0))).name].walkable then
			rot.x=ship_rot_vel.x*((math.abs(vel.x)+math.abs(vel.z))*.05)
			rot.z=ship_rot_vel.z*((math.abs(vel.x)+math.abs(vel.z))*.05)
		end

		--self.object:set_properties({automatic_rotate=ship_rot_vel.y*20})
		self.object:set_rotation({x=ship_rot_vel.x*dtime_rounded+rot.x, y=ship_rot_vel.y*dtime_rounded+rot.y, z=ship_rot_vel.z*dtime_rounded+rot.z*0.9})

		sw_ships.ship_vector_vel[dname] = vector.multiply(sw_ships.ship_vector_vel[dname], 0.9)

		if self._throttle > 3 and self.object:get_properties().textures ~= {self._textures[1].."_jet.png"} then
			--self.object:set_properties({textures={self._textures[1].."_jet.png"}})
		elseif self.object:get_properties().textures ~= {self._textures[1]..".png"} then
			--self.object:set_properties({textures={self._textures[1]..".png"}})
		end

		if control.jump and self._throttle<self._throttle_max then
			self._throttle = self._throttle+0.3
		elseif control.sneak and self._throttle>0 then
			self._throttle = self._throttle-0.1
		end

	end
	if self._destroyed then
		if self._driver then
			self._driver:set_detach()
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
			self._driver=nil
			clicker:set_detach()
			clicker:set_pos(self.object:get_pos())
		end
	end
end

function sw_ships.register_ship(name, max_throttle, max_speed, textures, mesh, size, tilt, yaw_snap, collbox, build_schem)
	local NEW_SHIP_ENTITY = table.copy(SHIP_ENTITY)
	NEW_SHIP_ENTITY.collisionbox = collbox
	NEW_SHIP_ENTITY._throttle_max = max_throttle
	NEW_SHIP_ENTITY._speed_max = max_speed
	NEW_SHIP_ENTITY.mesh = mesh
	NEW_SHIP_ENTITY.visual_size = size
	NEW_SHIP_ENTITY._textures = textures
	NEW_SHIP_ENTITY._tilt_devider = tilt
	NEW_SHIP_ENTITY._yaw_snap = yaw_snap
	minetest.register_entity(name, NEW_SHIP_ENTITY)

	local shiplist = build_schem
	--local shiplist = {"+0,+1,-1,sw_core_items:sandstone_desert_pale_with_two_red_lines", "+0,+1,-2,sw_core_items:sandstone_desert_pale_with_two_red_lines"}

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
