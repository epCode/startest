sw_holonet = {

}


function sw_holonet.get_holo_formspec(name)
  local h_formspec =
  "formspec_version[4]"..
  "size[20,10]"..
  "position[0.5,0.5]"..
  "background[0,0;20,10;gui_formbg.png]"..
  "background[0.5,0.5;12,9;gui_formbg_holo.png]"
  return h_formspec
end
