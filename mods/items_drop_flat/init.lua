-- Minetest: builtin/item_entity.lua

function minetest.spawn_item(pos, item)
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = minetest.add_entity(pos, "__builtin:item")
	-- Don't use obj if it couldn't be added to the map.
	if obj then
		obj:get_luaentity():set_item(stack:to_string())
	end
	return obj
end

-- If item_entity_ttl is not set, enity will have default life time
-- Setting it to -1 disables the feature

local time_to_live = tonumber(minetest.settings:get("item_entity_ttl")) or 900
local gravity = tonumber(minetest.settings:get("movement_gravity")) or 9.81


minetest.register_entity(":__builtin:item", {
	initial_properties = {
		hp_max = 1,
		physical = true,
		collide_with_objects = true,
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		visual = "wielditem",
		visual_size = {x = 0.4, y = 0.4},
		textures = {""},
		is_visible = false,
	},

	itemstring = "",
	moving_state = true,
	physical_state = true,
	-- Item expiry
	age = 0,
	-- Pushing item out of solid nodes
	force_out = nil,
	force_out_start = nil,

	set_item = function(self, item)
		local stack = ItemStack(item or self.itemstring)
		self.itemstring = stack:to_string()
    self.itemstring_name = stack:get_name()
		if self.itemstring == "" then
			-- item not yet known
			return
		end

		-- Backwards compatibility: old clients use the texture
		-- to get the type of the item
		local itemname = stack:is_known() and stack:get_name() or "unknown"

		local max_count = stack:get_stack_max()
		local count = math.min(stack:get_count(), max_count)
		local size = 0.2 + 0.1 * (count / max_count) ^ (1 / 3)
		local def = minetest.registered_items[itemname]
		local glow = def and def.light_source and
			math.floor(def.light_source / 2 + 0.5)

		local size_bias = 1e-3 * math.random() -- small random bias to counter Z-fighting
		local c = {-size, -size*.1, -size, size, size*.1, size}
    if minetest.registered_nodes[self.itemstring_name] and minetest.registered_nodes[self.itemstring_name].drawtype ~= "plantlike" and minetest.registered_nodes[self.itemstring_name].drawtype ~= "torchlike" then
      size = size *2
      c = {-size, -size, -size, size, size, size}
    end
		self.object:set_properties({
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x = size + size_bias, y = size + size_bias},
			collisionbox = c,
			--automatic_rotate = math.pi * 0.5 * 0.2 / size,
			wield_item = self.itemstring,
			glow = glow,
		})

		-- cache for usage in on_step
		self._collisionbox = c
	end,

	get_staticdata = function(self)
		return minetest.serialize({
			itemstring = self.itemstring,
			age = self.age,
			dropped_by = self.dropped_by
		})
	end,

	on_activate = function(self, staticdata, dtime_s)
    self._rotating = vector.multiply(vector.new(math.random(-50,50),math.random(-50,50),math.random(-50,50)), .003)
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = minetest.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				self.age = (data.age or 0) + dtime_s
				self.dropped_by = data.dropped_by
			end
		else
			self.itemstring = staticdata
		end
		self.object:set_armor_groups({immortal = 1})
		self.object:set_velocity({x = 0, y = 2, z = 0})
		self.object:set_acceleration({x = 0, y = -gravity, z = 0})
		self._collisionbox = self.initial_properties.collisionbox
		self:set_item()
	end,

	try_merge_with = function(self, own_stack, object, entity)
		if self.age == entity.age then
			-- Can not merge with itself
			return false
		end

		local stack = ItemStack(entity.itemstring)
		local name = stack:get_name()
		if own_stack:get_name() ~= name or
				own_stack:get_meta() ~= stack:get_meta() or
				own_stack:get_wear() ~= stack:get_wear() or
				own_stack:get_free_space() == 0 then
			-- Can not merge different or full stack
			return false
		end

		local count = own_stack:get_count()
		local total_count = stack:get_count() + count
		local max_count = stack:get_stack_max()

		if total_count > max_count then
			return false
		end
		-- Merge the remote stack into this one

		local pos = object:get_pos()
		pos.y = pos.y + ((total_count - count) / max_count) * 0.15
		self.object:move_to(pos)

		self.age = 0 -- Handle as new entity
		own_stack:set_count(total_count)
		self:set_item(own_stack)

		entity.itemstring = ""
		object:remove()
		return true
	end,

	enable_physics = function(self)
		if not self.physical_state then
			self.physical_state = true
			self.object:set_properties({physical = true})
			self.object:set_velocity({x=0, y=0, z=0})
			self.object:set_acceleration({x=0, y=-gravity, z=0})
		end
	end,

	disable_physics = function(self)
		if self.physical_state then
			self.physical_state = false
			self.object:set_properties({physical = false})
			self.object:set_velocity({x=0, y=0, z=0})
			self.object:set_acceleration({x=0, y=0, z=0})
		end
	end,

	on_step = function(self, dtime, moveresult)
		self.age = self.age + dtime
		if time_to_live > 0 and self.age > time_to_live then
			self.itemstring = ""
			self.object:remove()
			return
		end

    local kickspeed = 1
    local oriantatioin = 0
    if minetest.registered_nodes[self.itemstring_name] and minetest.registered_nodes[self.itemstring_name].drawtype ~= "plantlike" and minetest.registered_nodes[self.itemstring_name].drawtype ~= "torchlike" then
      local oriantatioin = 1.57
      kickspeed = 0.1
    end

    for _,object in ipairs(minetest.get_objects_inside_radius(self.object:get_pos(), 1)) do
  		if object:is_player() then
        if not minetest.registered_nodes[self.itemstring_name] then
          self.object:set_rotation(vector.new(1.57, oriantatioin, minetest.dir_to_yaw(self.object:get_velocity())))
        end
  			self.object:add_velocity(vector.multiply(vector.direction(self.object:get_pos(), object:get_pos()), -kickspeed))
  		end
  	end

    if math.abs(self.object:get_velocity().y) < 0.2 and not self._landed then
--      self._rotating = vector.new(0,0,0)
      self.object:set_rotation({x=1.57, y=oriantatioin, z=self.object:get_rotation().z})
      self._landed=true
    elseif math.abs(self.object:get_velocity().y) > 0.2 then
      self._landed=false
      self.object:set_rotation(vector.add(self._rotating, self.object:get_rotation()))
    end

		local pos = self.object:get_pos()
		local node = minetest.get_node_or_nil({
			x = pos.x,
			y = pos.y + self._collisionbox[2] - 0.05,
			z = pos.z
		})
		-- Delete in 'ignore' nodes
		if node and node.name == "ignore" then
			self.itemstring = ""
			self.object:remove()
			return
		end

		if self.force_out then
			-- This code runs after the entity got a push from the is_stuck code.
			-- It makes sure the entity is entirely outside the solid node
			local c = self._collisionbox
			local s = self.force_out_start
			local f = self.force_out
			local ok = (f.x > 0 and pos.x + c[1] > s.x + 0.5) or
				(f.y > 0 and pos.y + c[2] > s.y + 0.5) or
				(f.z > 0 and pos.z + c[3] > s.z + 0.5) or
				(f.x < 0 and pos.x + c[4] < s.x - 0.5) or
				(f.z < 0 and pos.z + c[6] < s.z - 0.5)
			if ok then
				-- Item was successfully forced out
				self.force_out = nil
				self:enable_physics()
				return
			end
		end

		if not self.physical_state then
			return -- Don't do anything
		end

		assert(moveresult,
			"Collision info missing, this is caused by an out-of-date/buggy mod or game")

		if not moveresult.collides then
			-- future TODO: items should probably decelerate in air
			return
		end

		-- Push item out when stuck inside solid node
		local is_stuck = false
		local snode = minetest.get_node_or_nil(pos)
		if snode then
			local sdef = minetest.registered_nodes[snode.name] or {}
			is_stuck = (sdef.walkable == nil or sdef.walkable == true)
				and (sdef.collision_box == nil or sdef.collision_box.type == "regular")
				and (sdef.node_box == nil or sdef.node_box.type == "regular")
		end

		if is_stuck then
			local shootdir
			local order = {
				{x=1, y=0, z=0}, {x=-1, y=0, z= 0},
				{x=0, y=0, z=1}, {x= 0, y=0, z=-1},
			}

			-- Check which one of the 4 sides is free
			for o = 1, #order do
				local cnode = minetest.get_node(vector.add(pos, order[o])).name
				local cdef = minetest.registered_nodes[cnode] or {}
				if cnode ~= "ignore" and cdef.walkable == false then
					shootdir = order[o]
					break
				end
			end
			-- If none of the 4 sides is free, check upwards
			if not shootdir then
				shootdir = {x=0, y=1, z=0}
				local cnode = minetest.get_node(vector.add(pos, shootdir)).name
				if cnode == "ignore" then
					shootdir = nil -- Do not push into ignore
				end
			end

			if shootdir then
				-- Set new item moving speed accordingly
				local newv = vector.multiply(shootdir, 3)
				self:disable_physics()
				self.object:set_velocity(newv)

				self.force_out = newv
				self.force_out_start = vector.round(pos)
				return
			end
		end

    local keep_movement = false

    local vel = self.object:get_velocity()

		self.object:set_velocity({x=vel.x*.85, y=vel.y, z=vel.z*.85})

		if self.moving_state == keep_movement then
			-- Do not update anything until the moving state changes
			return
		end
		self.moving_state = keep_movement

		-- Only collect items if not moving
		if self.moving_state then
			return
		end
		-- Collect the items around to merge with
		local own_stack = ItemStack(self.itemstring)
		if own_stack:get_free_space() == 0 then
			return
		end
		local objects = minetest.get_objects_inside_radius(pos, 1.0)
		for k, obj in pairs(objects) do
			local entity = obj:get_luaentity()
			if entity and entity.name == "__builtin:item" then
				if self:try_merge_with(own_stack, obj, entity) then
					own_stack = ItemStack(self.itemstring)
					if own_stack:get_free_space() == 0 then
						return
					end
				end
			end
		end
	end,

	on_punch = function(self, hitter)
		local inv = hitter:get_inventory()
		if inv and self.itemstring ~= "" then
			local left = inv:add_item("main", self.itemstring)
			if left and not left:is_empty() then
				self:set_item(left)
				return
			end
		end
    self.object:move_to(vector.add(hitter:get_pos(), vector.new(0,1.3,0)))
    minetest.after(0.2,function()
      self.itemstring = ""
      self.object:remove()
    end)
	end,
})
