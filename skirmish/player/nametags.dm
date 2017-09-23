/*
				:: Maptext Nametags by Kumorii

************************

		So this is a really simple bit of code I put together a few months ago but never really used. There are no issues that I'm aware of and
	editing/improving it should be effortless. If requested, I may revisit this and add some tweaks for color or something. Use it as you wish!

**********************

			:: How to use ::

		When you want to draw a nametag simply call src.draw_nametag("display name").  src being the atom that is recieving the nametag.
	if you want to change the text displayed, call src.nametag.change_text("new name") and that's it!

**********************

			:: Updates & Fixes ::


	---- none

**********************																															*/




atom/movable

	var/obj/nametag/nametag

	proc/draw_nametag(name_text, lvl)
		/*
			called to draw a new nametag for [src].
			gm = 1 if the player should have an indicator showing that they're staff.
		*/
		nametag	= new /obj/nametag("[name_text]", lvl)
		overlays += nametag



obj/nametag
	maptext_width		= 128
	maptext_height		= 18
	pixel_y				= -20	// x and y offsets to center the maptext bounds on src. totes obvi.
	pixel_x				= -56
	plane				= 3
	appearance_flags	= NO_CLIENT_COLOR+RESET_TRANSFORM+RESET_COLOR+KEEP_APART
	layer				= MOB_LAYER
	var
		disp_text					// The text to be displayed. can be removed, honestly. It's just there to simplify future ideas.
		disp_color		= "white"	// The color of the text. Default is the default text color set by the map control.

	New(t, lvl = 0)
		..()
		if(t) change_text(t, lvl)



	proc
		change_text(new_text, lvl)
			/*
				called to change an existing nametag's display text.
					new_text	- the new text to be output.
					gm			- true if the player is a gm.
			*/
			disp_text 	= "[copytext(new_text,1,16)]"
			maptext		= "<td align=center><font color = #FAC324>Lv.<font color = #FFED7E>[lvl] <font color = [disp_color]>[disp_text]"


		change_color(new_color = "white", lvl = 0)
			/*
				called to change an existing nametag's text color.
					new_color	- the desired color of the text.
			*/
			disp_color 	= new_color
			maptext		= "<td align=center><font color = #FAC324>Lv.<font color = #FFED7E>[lvl] <font color = [disp_color]>[disp_text]"