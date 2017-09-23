
/*

derpy derpy doo

*/

mob/player
	proc
		draw_planes()	 // must apply this first
			client.screen += new/obj/lighting_plane
			draw_spotlight(-38, -38, "#FFFFFF", 0.8, 177)


atom/movable
	var
		obj/spotlight	// null by default because not everything will have one, obvi
	proc
		draw_spotlight(x_os = 0, y_os = 0, hex = "#FFFFFF", size_modi = 1, alph = 255)
			/* x_offset, y_offset, color value (if any)
				*/
			spotlight 			= new /obj/spotlight
			spotlight.pixel_x	= x_os
			spotlight.pixel_y	= y_os
			spotlight.color		= hex
			spotlight.transform	= matrix()*size_modi
			spotlight.alpha		= alph
			overlays += spotlight

		edit_spotlight(x_os, y_os, hex, size_modi, alph)
			/*
				call this proc to change a spotlight's variables on the fly
				only the variables that are there are changed, if null, no changes will be made.
			*/
			overlays -= spotlight
			spotlight.loc = loc
			animate(spotlight, pixel_x = ((!isnull(x_os)) ? x_os : spotlight.pixel_x), pixel_y = ((!isnull(y_os)) ? y_os : spotlight.pixel_y), color = (hex ? hex : spotlight.color), transform = (size_modi ? matrix()*size_modi : spotlight.transform), alpha = ((!isnull(alph)) ? alph : spotlight.alpha), time = 1)
			sleep 1
			spotlight.loc = null
			overlays += spotlight


obj/lighting_plane												// add this to the client's screen     This and the below comment are both done in the above proc
	screen_loc 			= "CENTER"
	plane 				= 1
	blend_mode 			= BLEND_MULTIPLY
	appearance_flags 	= PLANE_MASTER | NO_CLIENT_COLOR
	mouse_opacity 		= 0


obj/spotlight															// SyX add this to the player's overlays.
	plane 			= 1
	blend_mode 		= BLEND_ADD
	icon 			= 'lighting.dmi'  // a 96x96 white circle
	icon_state 		= "0"
	alpha			= 155
	pixel_x 		= -38
	pixel_y 		= -38
	layer			= 1+EFFECTS_LAYER
	appearance_flags= RESET_COLOR | RESET_ALPHA

