---------
-- Bat --
---------


local function get_ceiling_positions(pos, range)
    local walkable = minetest.find_nodes_in_area(
        {x = pos.x + range, y = pos.y + range, z = pos.z + range},
        {x = pos.x - range, y = pos.y, z = pos.z - range},
        animalia.walkable_nodes
    )
    if #walkable < 1 then return {} end
    local output = {}
    for i = 1, #walkable do
        local i_pos = walkable[i]
        local under = {
            x = i_pos.x,
            y = i_pos.y - 1,
            z = i_pos.z
        }
        if minetest.get_node(under).name == "air"
        and minetest.registered_nodes[minetest.get_node(i_pos).name].walkable then
            table.insert(output, i_pos)
        end
    end
    return output
end

local guano_accumulation = minetest.settings:get_bool("guano_accumulation")

-- Math --

local function clamp(val, min, max)
	if val < min then
		val = min
	elseif max < val then
		val = max
	end
	return val
end

local random = math.random
local floor = math.floor

-- Vector Math --

local vec_dist = vector.distance
local vec_add = vector.add

local function vec_raise(v, n)
    return {x = v.x, y = v.y + n, z = v.z}
end

local function is_node_walkable(name)
    local def = minetest.registered_nodes[name]
    return def and def.walkable
end

creatura.register_mob("animalia:purgil", {
  -- Stats
  max_health = 200,
  armor_groups = {fleshy = 100},
  damage = 20,
  speed = 12,
	tracking_range = 16,
  despawn_after = 2500,
	-- Entity Physics
	stepheight = 10.1,
	max_fall = 0,
	turn_rate = 0.2,
    -- Visuals
    mesh = "ai_beings_purgil.b3d",
    hitbox = {
		width = 3.5,
		height = 7,
	},
    visual_size = {x = 5, y = 5},
	textures = {
		"ai_beings_purgil.png"
	},
	animations = {
		stand = {range = {x = 1, y = 37}, speed = 24, frame_blend = 0.3, loop = true},
		walk = {range = {x = 1, y = 37}, speed = 24, frame_blend = 0.3, loop = true},
    fly = {range = {x = 1, y = 37}, speed = 24, frame_blend = 0.3, loop = true},
    hyperspace_jump = {range = {x = 45, y = 80}, speed = 24, frame_blend = 0, loop = false}
	},
    -- Misc
	sounds = {
		random = {
            name = "animalia_bat",
            gain = 0.5,
            distance = 16,
      			variations = 2
        },
    },
	catch_with_net = false,
	catch_with_lasso = false,
  -- Function
	utility_stack = {
		  {
			utility = "animalia:aerial_flock",
      get_score = function(self)
        local pos = self.object:get_pos()
        if self:get_utility() then
          minetest.chat_send_all(self:get_utility())
        end
				return 1, {self, 10}
			end
    },
	},
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, direction, damage)
		creatura.basic_punch_func(self, puncher, time_from_last_punch, tool_capabilities, direction, damage)
	end,
  activate_func = function(self)
    self.stamina = self:recall("stamina") or 120
  end,
})

creatura.register_spawn_egg("animalia:purgil", "392517", "321b0b")
