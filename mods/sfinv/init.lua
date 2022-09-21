-- sfinv/init.lua

dofile(minetest.get_modpath("sfinv") .. "/api.lua")

function sfinv.num_to_color(num)
	num2 = tonumber(num)
	local color = "#000000"
	if num2 > 50 then
		color = "#0076ff"
	elseif num2 > 45 then
		color = "#00ff3c"
	elseif num2 > 40 then
		color = "#46ff00"
	elseif num2 > 35 then
		color = "#63ff00"
	elseif num2 > 30 then
		color = "#6aff00"
	elseif num2 > 25 then
		color = "#87ff00"
	elseif num2 > 20 then
		color = "#c0ff00"
	elseif num2 > 15 then
		color = "#ddff00"
	elseif num2 > 10 then
		color = "#faff00"
	elseif num2 > 5 then
		color = "#ffd100"
	elseif num2 > 0 then
		color = "#ff9800"
	elseif num2 > -5 then
		color = "#ff0000"
	end
	return color
end

-- Load support for MT game translation.
local S = minetest.get_translator("sfinv")

sfinv.register_page("sfinv:crafting", {
	title = S("Crafting"),
	get = function(self, player, context)
		local name = player:get_player_name()
		local player_model = armor.calculate_model(player)
		local player_texture = armor.calculate_texture(player)
		local armor_texture = "blank.png"
		if armor:set_player_armor(player) then
			armor_texture = armor:set_player_armor(player)
		else
			armor_texture = "blank.png"
		end
		local meta = player:get_meta()
		local alliances = {"",meta:get("alliances")}
		player_species.set_alliances_rep(player)

		alliances[1]=meta:get("alliances").."_rep_logo.png"
		if meta:get("alliances") == "mining_guild" then
			alliances[2]="The Mining Guild"
		elseif meta:get("alliances") == "the_empire" then
			alliances[2]="The Empire"
		elseif meta:get("alliances") == "rebels" then
			alliances[2]="The Rebels"
		elseif meta:get("alliances") == "transporation_guild" then
			alliances[2]="Transportation"
		elseif meta:get("alliances") == "bounty" then
			alliances[2]="The Bounty Guild"
		end

		return sfinv.make_formspec(player, context,
				"formspec_version[4]"..
				"size[20,10]"..
				"position[0.5,0.5]"..
				"background[8.5,0;11.545,10;gui_formbg2.png]"..
				"background[0,0;11.545,10;gui_formbg.png]"..
				"list[current_player;main;0.9,4.75;8,1;]"..
				"list[current_player;main;0.9,6;8,3;8]"..
				"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"..
				"listcolors[#111111;#424242]"..



				"model[-1,0.5;3,3;character_preview;"..player_model..";"..player_texture..","..armor_texture..";0,190;false;true;1,31]"..

				"label[16.2,.5;Reputation With:]"..
				"image[15.8,0.8;3.4,5.3;player_species_rodian.png^[colorize:#222222:255]"..



				"label[12.4,.5;Faction:]"..
				"image[12,0.8;3.4,1.3;player_species_rodian.png^[colorize:#222222:255]"..

				"image[12.2,1;3,0.9;player_species_rodian.png^[colorize:#5f5f5f:255]"..
				"image[12.3,1.1;.7,.7;"..alliances[1].."]"..
				"label[13,1.45;"..alliances[2].."]"..



				"image[16,1;3,0.9;player_species_rodian.png^[colorize:#5f5f5f:255]"..
				"image[18.8,1.1;0.1,0.7;player_species_rodian.png^[colorize:"..sfinv.num_to_color(meta:get("repGAMEminingguild"))..":255]"..
				"label[19.3,1.5;"..meta:get("repGAMEminingguild").."]"..
				"label[16.2,1.5;Mining Guild:]"..

				"image[16,2;3,0.9;player_species_rodian.png^[colorize:#5f5f5f:255]"..
				"image[18.8,2.1;0.1,0.7;player_species_rodian.png^[colorize:"..sfinv.num_to_color(meta:get("repGAMEtransportguild"))..":255]"..
				"label[19.3,2.5;"..meta:get("repGAMEtransportguild").."]"..
				"label[16.2,2.5;Transport Guild:]"..

				"image[16,3;3,0.9;player_species_rodian.png^[colorize:#5f5f5f:255]"..
				"image[18.8,3.1;0.1,0.7;player_species_rodian.png^[colorize:"..sfinv.num_to_color(meta:get("repGAMEtheempire"))..":255]"..
				"label[19.3,3.5;"..meta:get("repGAMEtheempire").."]"..
				"label[16.2,3.5;The Empire:]"..

				"image[16,4;3,0.9;player_species_rodian.png^[colorize:#5f5f5f:255]"..
				"image[18.8,4.1;0.1,0.7;player_species_rodian.png^[colorize:"..sfinv.num_to_color(meta:get("repGAMErebels"))..":255]"..
				"label[19.3,4.5;"..meta:get("repGAMErebels").."]"..
				"label[16.2,4.5;Rebel Aliance:]"..

				"image[16,5;3,0.9;player_species_rodian.png^[colorize:#5f5f5f:255]"..
				"image[18.8,5.1;0.1,0.7;player_species_rodian.png^[colorize:"..sfinv.num_to_color(meta:get("repGAMEbounty"))..":255]"..
				"label[19.3,5.5;"..meta:get("repGAMEbounty").."]"..
				"label[16.2,5.5;Bounty Hunters:]", true)
	end
})
