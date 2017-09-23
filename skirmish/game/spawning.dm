

proc

	spawn_pl(mob/player/p)
		/* called to spawn a player (p) to the map.
		*/
		if(!p) return
		p.health		= p.base_health
		p.client.eye	= p
		p.density		= 1
		p.move_disabled	= 1
		p.alpha			= 0
		p.died_already	= 0
		p.loc			= return_pspawn()
		if(prob(0)) // for special spawn-in effects
			draw_portal(p.loc, p.namecolor, 2, null)
			animate(p, alpha = 255, easing = QUAD_EASING, time = 1)
		else
			p.pixel_z = 64
			animate(p, pixel_z = 0, alpha = 255, easing = QUAD_EASING, time = 20)
		spawn(20)
			p.move_disabled 	= 0
			p.can_hit			= 1


	return_pspawn()
		/* returns an available player spawn point.
		*/
		top
		var/turf/t = pick(active_game.player_spawns)
		for(var/atom/movable/a in t)
			if(a.density)
				sleep 1
				goto top
		return t

	return_vspawn()
		/* returns an available vendor spawn point.
		*/
		top
		var/turf/t = pick(active_game.vendor_spawns)
		for(var/atom/movable/a in t)
			if(a.density)
				sleep 1
				goto top
		return t


	spawn_en(mob/npc/hostile/h)
		/* called to spawn a hostile (h) to the map.
		*/
		if(!h) return
		top
		var/turf/t
		var/found_spawn = 0
		while(!found_spawn && active_game.started == 2)	// we'll have to loop until we find a good spawn point.
			while(!active_game.enemy_spawns && active_game.started == 2) sleep 10 // wait if there aren't any spawn points.
			if(active_game.enemy_spawns)
				var/mob/player/m 		= pick(active_game.participants)
				var/list/spawn_options	= new/list() // list of the spawnpoints in range of [m].
				for(var/turf/e in oview(15, m))
					if(e in active_game.enemy_spawns) spawn_options += e // add to this to list
				//	sleep world.tick_lag
				t = pick(spawn_options)
				for(var/atom/movable/a in t)
					if(a.density)
						t = null
					sleep world.tick_lag
				if(t) // if we have a turf that passes the initial check...
			//		. = 0
					for(var/mob/player/p in oviewers(15, t))
						if(p)
					//		. = 1
							if(!(p in oviewers(t))) // if p isn't in view of the spawn.. keep checking
								continue
							else				// if t is null byy the end, it's a bad spawn.
								t = null
								break
						sleep world.tick_lag
					if(t) found_spawn = 1
			sleep 1
		// won't get to this point unless a spawn point is found.
		if(t)
			if(istype(h,/mob/npc/hostile/puppet_master))
				var/mob/npc/puppet = h:puppet
				puppet.loc 		= t
				puppet.health	= h.base_health+round(active_game.current_round*5)
				puppet.can_hit	= 1
			else
				h.loc 		= t
				h.health	= h.base_health+round(active_game.current_round*5)
				h.can_hit	= 1
			ai_list += h
			sleep 1
		else {world << "borked going to top!";goto top}


mob/npc
	proc
		respawn()
			/* called to respawn the mob to a new location on the map.
			*/
			var/turf/t
			var/found_spawn = 0
			while(!found_spawn && active_game.started == 2)	// we'll have to loop until we find a good spawn point.
				while(!active_game.enemy_spawns && active_game.started == 2) sleep 10 // wait if there aren't any spawn points.
				if(active_game.enemy_spawns && active_game.total_respawning < 5)
					active_game.total_respawning ++
					var/mob/player/m 		= pick(active_game.participants)
					var/list/spawn_options	= new/list() // list of the spawnpoints in range of [m].
					for(var/turf/e in oview(15, m))
						if(e in active_game.enemy_spawns) spawn_options += e // add to this to list
					//	sleep world.tick_lag
					t = pick(spawn_options)
					for(var/atom/movable/a in t)
						if(a.density)
							t = null
						sleep world.tick_lag
					if(t) // if we have a turf that passes the initial check...
				//		. = 0
						for(var/mob/player/p in oviewers(15, t))
							if(p)
						//		. = 1
								if(!(p in oviewers(t))) // if p isn't in view of the spawn.. keep checking
									continue
								else				// if t is null byy the end, it's a bad spawn.
									t = null
									break
							sleep world.tick_lag
						if(t) found_spawn = 1
					active_game.total_respawning --
				sleep 1

			if(t && health && src in ai_list)
				if(istype(src,/mob/npc/hostile/puppet_master))
					var/mob/npc/hostile/puppet = src:puppet
					puppet.loc 	= t
				else loc 		= t
				can_hit = 1
		//	else world << "uhhh"
