

multidimensions.clear_dimensions=function()
	multidimensions.registered_dimensions = {}
end

multidimensions.setrespawn=function(object,pos)
	if not object:is_player() then return false end
	local name=object:get_player_name()
	if multidimensions.remake_home and minetest.get_modpath("sethome")~=nil then
		sethome.set(name, pos)
	end
end

multidimensions.form=function(player,object)
	local name=player:get_player_name()
	local info=""
	multidimensions.user[name]={}
	multidimensions.user[name].pos=object:get_pos()
	multidimensions.user[name].object=object
	if object:is_player() and object:get_player_name()==name then
		info="Teleport you"
	elseif object:is_player() and object:get_player_name()~=name then
		info="Teleport "..object:get_player_name()
	else
		info="Teleport object"
	end
	local list = "earth"
	local d = {"earth"}
	for i, but in pairs(multidimensions.registered_dimensions) do
		list = list .. ","..i
		table.insert(d,i)
	end
	multidimensions.user[name].dims = d
	local gui="size[3.5,5.5]"..
	"label[0,-0.2;" .. info .."]"..
	"textlist[0,0.5;3,5;list;" .. list .."]"
	minetest.after(0.1, function(gui)
		return minetest.show_formspec(player:get_player_name(), "multidimensions.form",gui)
	end, gui)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="multidimensions.form" then
		local name=player:get_player_name()
		if pressed.quit then
			multidimensions.user[name]=nil
			return
		end
		local pos=multidimensions.user[name].pos
		local object=multidimensions.user[name].object
		local dims = multidimensions.user[name].dims
		local dim = pressed.list and tonumber(pressed.list:sub(5,-1)) or 0
		local pos=object:get_pos()
		local d = multidimensions.registered_dimensions[dims[dim]]
		if not d then
			multidimensions.move(object,{x=pos.x,y=0,z=pos.z})
			if object:is_player() then
				multidimensions.apply_dimension(object)
			end
		else
			local pos2={x=pos.x,y=d.dirt_start+d.dirt_depth+1,z=pos.z}
			if d and minetest.is_protected(pos2, name)==false then
				multidimensions.move(object,pos2)
				if object:is_player() then
					multidimensions.apply_dimension(object)
				end
			end
		end
		multidimensions.user[name]=nil
		minetest.close_formspec(name,"multidimensions.form")
	end
end)


minetest.register_on_respawnplayer(function(player)
	multidimensions.apply_dimension(player)
end)
minetest.register_on_joinplayer(function(player)
	multidimensions.apply_dimension(player)
end)
minetest.register_on_leaveplayer(function(player)
	multidimensions.player_pos[player:get_player_name()] = nil
end)

multidimensions.pos_to_dimension=function(pos)
	p=pos
	for i, v in pairs(multidimensions.registered_dimensions) do
		if p.y > v.dim_y and p.y < v.dim_y+v.dim_height-500 then
			return i
		end
	end
end

multidimensions.apply_dimension=function(player)
	local p = player:get_pos()
	local name = player:get_player_name()
	local pp = multidimensions.player_pos[name]
	if pp and p.y > pp.y1 and p.y < pp.y2 then
		return
	elseif pp then
		local od = multidimensions.registered_dimensions[pp.name]
		if od and od.on_leave then
			od.on_leave(player)
		end
	end
	for i, v in pairs(multidimensions.registered_dimensions) do
		if p.y > v.dim_y and p.y < v.dim_y+v.dim_height-500 then
			multidimensions.player_pos[name] = {y1 = v.dim_y, y2 = v.dim_y+v.dim_height-500, name=i}
			player:set_physics_override({gravity=v.gravity})
			--[[
			if v.sky then
				player:set_sky(v.sky[1],v.sky[2],v.sky[3])
			else
				player:set_sky(nil,"regular",nil)
			end]]
			if v.on_enter then
				v.on_enter(player)
			end
			return
		end
	end
	player:set_physics_override({gravity=1})
	multidimensions.player_pos[name] = {
		y1 = multidimensions.earth.under,
		y2 = multidimensions.earth.above,
		name=""
	}
end

multidimensions.move=function(object,pos)
	local move=false
	if object:is_player() then
		multidimensions.player_dimension[object] = multidimensions.player_pos[object:get_player_name()].name
	elseif object:get_luaentity() and object:get_luaentity()._hyperspace_invi_timer then
		object:get_luaentity()._hyperspace_invi_timer = 0
	end
	object:set_pos({x=pos.x,y=pos.y+550,z=pos.z})
	multidimensions.setrespawn(object,pos)
	return true
end

local space_skybox = {
	"multidimensions_space.png",
	"multidimensions_space.png^multidimensions_tattooine.png",
	"multidimensions_space.png",
	"multidimensions_space.png",
	"multidimensions_space.png",
	"multidimensions_space.png"
}
local capg = 0
minetest.register_globalstep(function(dtime)
	capg=capg+dtime
	if capg > 2 then
		capg=0
		for _, player in pairs(minetest.get_connected_players()) do
			multidimensions.apply_dimension(player)


			if multidimensions.registered_dimensions[multidimensions.player_pos[player:get_player_name()].name] then
				player:get_meta():set_string("last_planet", multidimensions.player_pos[player:get_player_name()].name)
			elseif not player:get_meta():get_string("last_planet") then
				player:get_meta():set_string("last_planet", "tattooine")
			end
			if not multidimensions.registered_dimensions[multidimensions.player_pos[player:get_player_name()].name] then
	      player:set_sky({
	        type = "skybox",
	        textures = {
						"multidimensions_space.png",
						"multidimensions_space.png^multidimensions_"..player:get_meta():get_string("last_planet")..".png",
						"multidimensions_space.png",
						"multidimensions_space.png",
						"multidimensions_space.png",
						"multidimensions_space.png"
					},
	        clouds = false,
	        sunrise_visible = false,
	      })
	      player:set_stars({
	        visible = false,
	      })
	      player:set_sun({
	        sunrise_visible = false,
					texture = "multidimensions_sun_"..player:get_meta():get_string("last_planet")..".png",
	      })
				player:set_moon({
	        sunrise_visible = true,
					texture = "multidimensions_moon_"..player:get_meta():get_string("last_planet")..".png",
					scale = 1,
	      })
	      player:set_stars({
	        visible = false,
	      })
				player:override_day_night_ratio(1)
	    else
				player:override_day_night_ratio(nil)
	      player:set_sky({
	        type = "regular",
	        clouds = true,
	        sunrise_visible = true,
					sky_color = {
						night_sky = "#000000",
						night_horizon = "#000020",

					},
	      })
	      player:set_stars({
	        visible = true,
	      })
	      player:set_sun({
	        sunrise_visible = true,
					texture = "multidimensions_sun_"..player:get_meta():get_string("last_planet")..".png",
	      })
	      player:set_moon({
	        sunrise_visible = true,
					texture = "multidimensions_moon_"..player:get_meta():get_string("last_planet")..".png",
					scale = 6,
	      })
	      player:set_stars({
	        visible = true,
	      })
	    end
			multidimensions.player_dimension[player] = multidimensions.player_pos[player:get_player_name()].name
		end
	end
end)
