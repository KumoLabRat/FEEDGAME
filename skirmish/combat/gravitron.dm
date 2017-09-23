






proc
	gravity(turf/_loc, px_rng = 64, mob/_owner)
		// pulls mobs and stuff to the center point
	//	set waitfor = 1
		if(_loc)
			for(var/i = 200, i > 0, i--)
		//		world << i
				for(var/atom/movable/a in obounds(_loc, px_rng))
					if(a.can_kb && (ismob(a) || istype(a, /obj/barricade)))
						a.knockback(1, get_dir(a, _loc))
						// pulls stuff towards the core!
				//	sleep world.tick_lag
				sleep world.tick_lag
		//	world << "all done! gravitron byby"





