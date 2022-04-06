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
	_hyperspace_invi_timer=0
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

	if self._hyperspace_invi_timer < 3 then
		self._hyperspace_invi_timer = self._hyperspace_invi_timer + dtime
	end

	if vel.y < 0 then
		self.object:set_velocity({x=vel.x*0.93,y=vel.y*0.96,z=vel.z*0.93})
	else
		self.object:set_velocity({x=vel.x*0.93,y=vel.y*0.93,z=vel.z*0.93})
	end
	if abs(vel.x)+abs(vel.y)+abs(vel.z)<self._speed_max then
		self.object:add_velocity(vector.multiply(look_dir, (self._throttle/5)))
	end

	if self._last_vel then
		if abs(vel.x - self._last_vel.x) > 10 or abs(vel.y - self._last_vel.y) > 10 or abs(vel.z - self._last_vel.z) > 10 then
			if self._hyperspace_invi_timer > 3 then
				self._destroyed = true
			end
		end
	end


	if self._driver then

		self._driver:set_pos(self.object:get_pos())

		local dirver_pos = self._driver:get_pos()

		local control = self._driver:get_player_control()

		if control.left and control.right and control.aux1 and self._hyperdrive==true and not multidimensions.registered_dimensions[multidimensions.player_pos[self._driver:get_player_name()].name] then
			multidimensions.form(self._driver,self.object)
		end

		--self._driver:set_eye_offset({x=0,y=0,z=0},{x=0,y=10,z=5})

		local dtime_rounded = round(dtime, 1)
		if dtime_rounded < 0.1 then
			dtime_rounded = 0.1
		end
		local look_offset_yaw = self._driver:get_look_horizontal()-rot.y
		local look_offset_pitch = ((self._driver:get_look_vertical()*2-rot.x)*.5+rot.x)*-1
		if abs(look_offset_yaw) < 4 then
			look_offset_yaw = look_offset_yaw*((abs(vel.x)+abs(vel.y)+abs(vel.z))/self._speed_max*dtime_rounded*self._yaw_snap)
		end


		if control.aux1 and not (control.left and control.right) then
			sw_blasters.shoot_entity(nil, self._driver, self._driver:get_wielded_item(), "sw_blasters:blast_entity", 90, 0, 20, {"sw_blasters_blast_red.png"}, 0, 0, look_dir)
		end

		self.object:set_rotation({x=look_offset_pitch*((abs(vel.x)+abs(vel.y)+abs(vel.z))/self._speed_max), y=look_offset_yaw+rot.y, z=look_offset_yaw*-15*(self._throttle/self._tilt_devider)+self._roll})

		if self._throttle > 3 and self.object:get_properties().textures ~= {self._textures[1].."_jet.png"} then
			self.object:set_properties({textures={self._textures[1].."_jet.png"}})
		elseif self.object:get_properties().textures ~= {self._textures[1]..".png"} then
			self.object:set_properties({textures={self._textures[1]..".png"}})
		end

		if control.up and self._throttle<self._throttle_max then
			self._throttle = self._throttle+0.3
		elseif control.down and self._throttle>0 then
			self._throttle = self._throttle-0.1
		end

		--[[
		if control.left then
			self._roll = self._roll+0.1
		elseif control.right then
			self._roll = self._roll-0.1
		end]]

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
			clicker:set_attach(self.object, "Main", {x=0,y=0,z=0}, {x=0,y=0,z=0})
		else
			self._driver=nil
			clicker:set_detach()
			clicker:set_pos(self.object:get_pos())
		end
	end
end

function sw_ships.register_ship(name, max_throttle, max_speed, textures, mesh, size, tilt, yaw_snap, collbox)
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
end
