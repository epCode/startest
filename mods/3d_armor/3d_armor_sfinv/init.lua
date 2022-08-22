-- support for i18n
local S = minetest.get_translator(minetest.get_current_modname())

dofile(minetest.get_modpath("sw_holonet") .. "/holonet.lua")

if not minetest.global_exists("sfinv") then
	minetest.log("warning", S("3d_armor_sfinv: Mod loaded but unused."))
	return
end

sfinv.register_page("3d_armor:armor", {
	title = S("Armor"),
	get = function(self, player, context)
		local name = player:get_player_name()
		local formspec = armor:get_armor_formspec(name, true)
		return sfinv.make_formspec(player, context, formspec, false)
	end
})

sfinv.register_page("sw_holonet:holonet", {
	title = S("Holonet"),
	get = function(self, player, context)
		local name = player:get_player_name()
		local formspec = sw_holonet.get_holo_formspec(name)
		return sfinv.make_formspec(player, context, formspec, false)
	end
})


local function get_form_creative(player_name)
	return
	"formspec_version[4]"..
	"size[20,10]"..
	"position[0.5,0.5]"..
	"background[0,0;20,10;gui_formbg.png]"..
	"image_button[0.15,3;0.8,0.8;creative_prev_icon.png;creative_prev;]"..
	"image_button[10.64,3;0.8,0.8;creative_next_icon.png;creative_next;]"..
	"list[current_player;main;0.9,4.75;8,1;]"..
	"list[current_player;main;0.9,6;8,3;8]"..
	"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"..
	"listring[detached:creative_" .. player_name .. ";main]" ..
	"list[detached:creative_" .. player_name .. ";main;0.9,0.3;8,4;1,2]" ..
	"listcolors[#111111;#424242]"
end


sfinv.register_page("3d_amore:creative", {
	title = S("Creative"),
	get = function(self, player, context)
		local name = player:get_player_name()
		local formspec = get_form_creative(name)
		return sfinv.make_formspec(player, context, formspec, false)
	end
})
