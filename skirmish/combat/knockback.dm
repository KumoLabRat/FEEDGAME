


atom/movable
	var/tmp
		kb_init	= 0
		can_kb	= 1
	proc
		knockback(dist = 2, _dir = NORTH)
			set waitfor = 0
			if(kb_init || !can_kb) return
			kb_init 	= 1
			if(istype(src, /mob/player))
				src:client.screen_shake((dist > 5 ? 15 : 5),4)
			var/i		= dist
			var/og_dir	= dir
			while(i > 0 && kb_init)
				if(!loc) break
				dust()
				step(src, _dir, 3)
				dir	= og_dir
				i --
				sleep world.tick_lag
			if(kb_init) kb_init = 0

