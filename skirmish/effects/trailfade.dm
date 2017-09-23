

/*
	this is an effect that causes a trail of the mob's icon to be left behind.
*/


mob
	proc
		fadetrail(fadetime = 15)
			// fadetime is how long the fade will persist before being recycled (also dictates how fast it's animation is)
			set waitfor = 0
			if(health_disp && health_disp in overlays) . = 1; overlays -= health_disp
			var/obj/details/o 	= garbage.Grab(/obj/details)
			o.layer				= EFFECTS_LAYER
			o.appearance		= appearance
			o.color 			= list(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)
			o.alpha				= 100
			o.SetLoc(loc, step_x, step_y)
			if(.) overlays += health_disp
			var/t = round(fadetime/3)
			animate(o, alpha = 125, time = t, easing = ELASTIC_EASING)
			animate(alpha = 0, time =  t*2, easing = QUAD_EASING)
			sleep t*3
			o.GC()
