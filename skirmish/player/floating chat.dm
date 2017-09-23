

/* float text is used to display messages on the map that float in place or over an atom.
*/


obj/floatText
	maptext_width		= 128
	maptext_height		= 64
	plane				= 2
	is_garbage			= 1
	appearance_flags	= NO_CLIENT_COLOR
	pixel_x				= -56
	pixel_y				= 25

	GC()
		maptext	= null
		..()

proc
	float_text(_loc = null, _text = null, _time = 5, mob/_owner = null, atom/movable/_track = null)
		set waitfor	= 0
		/* called to draw floating text over a location.
			_loc 	= where the text should be displayed.
			_text	= what the text should say.
			_time	= how many seconds the text should stay before it fades.
			_owner	= if this mob is near _loc, don't remove the text from the map.
			_track 	= if this atom moves or loses it's loc; it will make the text display go away.
		*/
		if(_loc && _text)
			for(var/obj/floatText/ft in _loc)
				if(ft.maptext == "<center>[_text]") return	//if there's already a popup for that atom
			var/ogLoc
			var/obj/floatText/floater	= garbage.Grab(/obj/floatText)
			floater.maptext				= "<center>[_text]"
			floater.alpha				= 0
			floater.loc					= _loc
			if(_track) ogLoc			= _track.loc
			animate(floater, alpha = 255, time = 6, pixel_y = 30, easing = QUAD_EASING)
			while(active_game.started == 2)
				sleep _time*10	// 10 = 1 sec; so sleep for _time seconds.
				if(!_owner || (_track && _track.loc != ogLoc) || (_owner && !(_owner in obounds(_loc, 2)))) break	// if the player is still near the _loc, don't clear the text.
			animate(floater, alpha = 0, time = 2, pixel_y = 25, easing = QUAD_EASING)
			sleep 2
			floater.loc					= null
			floater.alpha				= 255
			floater.maptext				= null
			floater.GC()



