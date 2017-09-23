

atom/movable
	proc

		drop_boom()
			/*
				called to drop a charred object to simulate an explosion point.
			*/
			var/obj/gore/boom/b		= garbage.Grab(/obj/gore/boom)
			b.icon					= 'gore.dmi'
			b.icon_state			= "boom[pick(1,2)]"
			b.SetCenter(Cx(),Cy(),z)
			animate(b, pixel_y = -8, time = 3)
			b.spawndel(100)

		penetrate()
			/*
				called to drop a brief blood splatter animation for when bullets penetrate a mob.
			*/
			var/obj/gore/splatter/b	= garbage.Grab(/obj/gore/splatter)
			b.icon					= 'gore.dmi'
			b.icon_state			= "penetrate"
			b.SetCenter(Cx(),Cy(),z)
			b.spawndel(300)

		drop_blood(var/i = 1, splat = 0)
			/*
				called to drop blood from an arom.
				i = how many blood drops to.. well, drop...toplemondrop
			*/
			if(!splat)
				for(var/obj/gore/blood/bl in obounds(src, 4))
					. ++
		//		spawn(2)
		//			b.gs(pick('audio/sounds/blood1.ogg','audio/sounds/blood2.ogg','audio/sounds/blood3.ogg'))
				if(. < 5) for(var/v = 0 to i)
					var/obj/gore/blood/b	= garbage.Grab(/obj/gore/blood)
					b.icon					= 'gore.dmi'
					b.icon_state			= "blood[rand(1,11)]"
					b.layer					= TURF_LAYER+0.15
					b.transform				= b.transform/4
					b.SetCenter(Cx(),Cy(),z)
					animate(b, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
					animate(pixel_y = rand(-8,8), time = 3)
					animate(transform = matrix(), time = 20)
					b.spawndel(300)
				//	sleep world.tick_lag
			else
				var/obj/gore/blood/b	= garbage.Grab(/obj/gore/blood)
				b.icon					= 'gore.dmi'
				b.icon_state			= "splat[rand(1,3)]"
				b.SetCenter(Cx(),Cy(),z)
				animate(b, pixel_y = -8, time = 3)
				b.spawndel(300)
				for(var/obj/gore/blood/bl in obounds(src, 4))
					. ++
				b.gs(pick('audio/sounds/blood1.ogg','audio/sounds/blood2.ogg','audio/sounds/blood3.ogg'))
				if(. < 5) for(var/v = 0 to i)
					var/obj/gore/blood/g	= garbage.Grab(/obj/gore/blood)
					g.icon					= 'gore.dmi'
					g.icon_state			= "gut[rand(1,5)]"
					g.layer					= TURF_LAYER+0.16
					g.SetCenter(Cx(),Cy(),z)
					animate(g, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
					animate(pixel_y = rand(-8,8), time = 3)
					g.spawndel(300)
				//	sleep world.tick_lag*2

obj/gore
	icon				= 'gore.dmi'
	layer				= TURF_LAYER+0.15
	is_garbage			= 1
	appearance_flags	= PIXEL_SCALE

	blood

	boom
		layer = TURF_LAYER+0.17

	splatter
		layer = MOB_LAYER+3

