player_species = {}

local tattooine = multidimensions.registered_dimensions["tattooine"]
--local naboo = multidimensions.registered_dimensions["naboo"]
--local illum = multidimensions.registered_dimensions["illum"]

--admin
minetest.register_privilege("GAMEjedi", {
	description = "A jedi player",
	give_to_singleplayer = false,
	give_to_admin = true,
})

minetest.register_privilege("GAMEmale", {
	description = "A male player",
	give_to_singleplayer = false,
})
minetest.register_privilege("GAMEfemale", {
	description = "A female player",
	give_to_singleplayer = false,
})
minetest.register_privilege("GAMEzabrak", {
	description = "A zabrak player",
	give_to_singleplayer = false,
})
minetest.register_privilege("GAMEtwilek", {
	description = "An twilek player",
	give_to_singleplayer = false,
})
minetest.register_privilege("GAMEman", {
	description = "A human player",
	give_to_singleplayer = false,
})
minetest.register_privilege("GAMErodian", {
	description = "An rodian player",
	give_to_singleplayer = false,
})
minetest.register_privilege("GAMEtogruta", {
	description = "A togruta player",
	give_to_singleplayer = false,
})

local race_chooser = "size[8,6]"..
	"background[8,6;1,1;gui_formbg.png;true]"..
	"label[0,0;" .. minetest.colorize("#A52A2A", "Please select the race you wish to be") .. "]"..
	"image[0.25,1.4;0.75,0.75;zabrak.png]"..
	"button_exit[1,1.5;2,0.5;zabrak;Zabrak]"..
	"image[4.75,1.4;0.75,0.75;twilek.png]"..
	"button_exit[5.5,1.5;2,0.5;twilek;twilek]"..
	"image[0.25,2.4;0.75,0.75;man.png]"..
	"button_exit[1,2.5;2,0.5;man;Man]"..
	"image[4.75,2.4;0.75,0.75;rodian.png]"..
	"button_exit[5.5,2.5;2,0.5;rodian;Rodian]"..
	"image[0.25,3.4;0.75,0.75;togruta.png]"..
	"button_exit[1,3.5;2,0.5;togruta;Togruta]"..
	"dropdown[5.5,3.4;2;gender;Male,Female;1]"

local fly_stuff = "button[1,4.75;2,0.5;fast;Fast]" ..
	"button[3,4.75;2,0.5;fly;Fly]" ..
	"button[5,4.75;2,0.5;noclip;Noclip]" ..
	"button[2.5,5.5;3,0.5;fast_fly_noclip;Fast, Fly & Noclip]"

local function give_stuff_zabrak(player)
	local inv = player:get_inventory()
	--[[
	inv:add_item('main', 'default:pick_steel')
	inv:add_item('main', 'lottweapons:steel_warhammer')
	inv:add_item('main', 'farming:bread 5')
	inv:add_item('main', 'default:torch 8')
	inv:add_item('main', 'lottinventory:crafts_book')
	inv:add_item('main', 'lottachievements:achievement_book')]]
end

local function give_stuff_twilek(player)
	local inv = player:get_inventory()
		--[[
	inv:add_item('main', 'default:pick_steel')
	inv:add_item('main', 'lottthrowing:bow_wood')
	inv:add_item('main', 'lottthrowing:arrow 25')
	inv:add_item('main', 'farming:bread 5')
	inv:add_item('main', 'lottblocks:elf_torch 8')
	inv:add_item('main', 'lottinventory:crafts_book')
	inv:add_item('main', 'lottachievements:achievement_book')]]
end

local function give_stuff_man(player)
	local inv = player:get_inventory()
		--[[
	inv:add_item('main', 'default:pick_bronze')
	inv:add_item('main', 'default:sword_bronze')
	inv:add_item('main', 'farming:bread 5')
	inv:add_item('main', 'default:torch 8')
	inv:add_item('main', 'lottinventory:crafts_book')
	inv:add_item('main', 'lottachievements:achievement_book')]]
end

local function give_stuff_rodian(player)
	local inv = player:get_inventory()
		--[[
	inv:add_item('main', 'lottweapons:orc_sword')
	inv:add_item('main', 'default:pick_steel')
	inv:add_item('main', 'lottfarming:orc_food 5')
	inv:add_item('main', 'lottblocks:orc_torch 8')
	inv:add_item('main', 'lottinventory:crafts_book')
	inv:add_item('main', 'lottachievements:achievement_book')]]
end

local function give_stuff_togruta(player)
	local inv = player:get_inventory()
		--[[
	inv:add_item('main', 'default:pick_stone')
	inv:add_item('main', 'farming:hoe_steel')
	inv:add_item('main', 'lottfarming:tomatoes_seed 2')
	inv:add_item('main', 'lottfarming:potato_seed 3')
	inv:add_item('main', 'lottfarming:pipe')
	inv:add_item('main', 'lottfarming:pipeweed_cooked 8')
	inv:add_item('main', 'lottinventory:crafts_book')
	inv:add_item('main', 'lottachievements:achievement_book')]]
end

local function give_stuff_jedi(player)
	local inv = player:get_inventory()
		--[[
	inv:add_item('main', 'default:pick_steel')
	inv:add_item('main', 'default:axe_steel')
	inv:add_item('main', 'default:shovel_steel')
	inv:add_item('main', 'default:sword_steel')
	inv:add_item('main', 'lottinventory:master_book')
	inv:add_item('main', 'lottachievements:achievement_book')]]
end

minetest.register_on_newplayer(function(player)
	local name = player:get_player_name()
	local privs = minetest.get_player_privs(name)
	local meta = player:get_meta()
	if minetest.get_player_privs(name).GAMEjedi then
		give_stuff_jedi(player)
	end
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local privs = minetest.get_player_privs(name)
	if not privs.GAMEjedi and not privs.GAMEfemale and not privs.GAMEmale then
		minetest.after(1, function()
			if minetest.is_singleplayer() then
				minetest.show_formspec(name, "race_selector", race_chooser .. fly_stuff)
			else
				minetest.show_formspec(name, "race_selector", race_chooser)
			end
		end)
	end
end)

local function player_race_stuff(race, text, mf, func, name, privs, player)
	minetest.chat_send_player(name, "You are now a member of the race of " .. text ..", fulfil your destiny.")
	privs["GAME" .. race] = true
	privs["GAME" .. mf] = true
	local pos = player:get_pos()
	player:set_pos({x=pos.x,y=tattooine.dirt_start+tattooine.dirt_depth+5,z=pos.z})
	minetest.set_player_privs(name, privs)
	if minetest.settings:get_bool("lott_give_initial_stuff", true) == true then
		func(player)
	end
	if mf == "male" or race == "rodian" or race == "jedi" then
		player_api.set_textures(player, {"player_species_" .. race .. "_skin.png", "3d_armor_trans.png", "3d_armor_trans.png", "3d_armor_trans.png"})
		armor.textures[name].skin = "player_species_" .. race .. "_skin.png"
		player_api.set_model(player, "3d_armor_character_"..race.."_male_1.b3d")
	elseif mf == "female" then
		player_api.set_textures(player, {"player_species_" .. race .. "_skinf.png", "3d_armor_trans.png", "3d_armor_trans.png", "3d_armor_trans.png"})
		player_api.set_model(player, "3d_armor_character_"..race.."_female_1.b3d")
		armor.textures[name].skin = "player_species_" .. race .. "_skinf.png"
	end
	minetest.log("action", name.. " chose to be a " .. race)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "race_selector" then return end
	local name = player:get_player_name()
	local privs = minetest.get_player_privs(name)
	if fields.gender == "Male" then
		if fields.zabrak then
			player_race_stuff("zabrak", "zabraks", "male", give_stuff_zabrak, name, privs, player)
		elseif fields.twilek then
			player_race_stuff("twilek", "twileks", "male", give_stuff_twilek, name, privs, player)
		elseif fields.man then
			player_race_stuff("man", "men", "male", give_stuff_man, name, privs, player)
		elseif fields.rodian then
			player_race_stuff("rodian", "rodians", "male", give_stuff_rodian, name, privs, player)
		elseif fields.togruta then
			player_race_stuff("togruta", "togrutas", "male", give_stuff_togruta, name, privs, player)
		end
	elseif fields.gender == "Female" then
		if fields.zabrak then
			player_race_stuff("zabrak", "zabraks", "female", give_stuff_zabrak, name, privs, player)
		elseif fields.twilek then
			player_race_stuff("twilek", "twileks", "female", give_stuff_twilek, name, privs, player)
		elseif fields.man then
			player_race_stuff("man", "men", "female", give_stuff_man, name, privs, player)
		elseif fields.rodian then
			player_race_stuff("rodian", "rodians", "female", give_stuff_rodian, name, privs, player)
		elseif fields.togruta then
			player_race_stuff("togruta", "togrutas", "female", give_stuff_togruta, name, privs, player)
		end
	end
	if fields.fast then
		privs.fast = true
		minetest.set_player_privs(name, privs)
		return
	elseif fields.fly then
		privs.fly = true
		minetest.set_player_privs(name, privs)
		return
	elseif fields.noclip then
		privs.noclip = true
		minetest.set_player_privs(name, privs)
		return
	elseif fields.fast_fly_noclip then
		privs.fly, privs.fast, privs.noclip = true, true, true
		minetest.set_player_privs(name, privs)
		return
	end

	if fields.quit then
		if not minetest.get_player_privs(name).GAMEjedi and not minetest.get_player_privs(name).GAMEfemale and not minetest.get_player_privs(name).GAMEmale then
			minetest.chat_send_player(name, minetest.colorize("red", "Please select a race!"))
			minetest.after(0.1, function()
				if minetest.is_singleplayer() then
					minetest.show_formspec(name, "race_selector", race_chooser .. fly_stuff)
				else
					minetest.show_formspec(name, "race_selector", race_chooser)
				end
			end)
		end
	end
end)

minetest.register_chatcommand("race", {
	params = "<name>",
	description = "print out privileges of player",
	func = function(name, param)
		param = (param ~= "" and param or name)
		if minetest.check_player_privs(param, {GAMEjedi = true}) then
			return true, "Race of " .. param .. ": Jedi"
		elseif minetest.check_player_privs(param, {GAMEzabrak = true}) then
			return true, "Race of " .. param .. ": Zabrak"
		elseif minetest.check_player_privs(param, {GAMEtwilek = true}) then
			return true, "Race of " .. param .. ": Twilek"
		elseif minetest.check_player_privs(param, {GAMEman = true}) then
			return true, "Race of " .. param .. ": Man"
		elseif minetest.check_player_privs(param, {GAMErodian = true}) then
			return true, "Race of " .. param .. ": Rodian"
		elseif minetest.check_player_privs(param, {GAMEtogruta = true}) then
			return true, "Race of " .. param .. ": Togruta"
		elseif minetest.check_player_privs(param, {shout = true}) ~= nil then
			if param == name then
				if minetest.is_singleplayer() then
					minetest.show_formspec(name, "race_selector", race_chooser .. fly_stuff)
				else
					minetest.show_formspec(name, "race_selector", race_chooser)
				end
			else
				return true, param .. " has not chosen a race!"
			end
		else
			return true, param .. " does not exist!"
		end
	end,
})
