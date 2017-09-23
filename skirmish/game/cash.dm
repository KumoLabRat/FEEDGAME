



atom/movable
	proc
		drop_cash(value = 5)
			/* called to drop a cash drop on the ground. The cash amount will be equal to [i].
			*/
			var/list/dropspots	= new/list()
			for(var/turf/t in oview(1,src))
				if(t.density) continue
				dropspots += t

			if(dropspots.len)
				for(var/i = rand(1, round(dropspots.len/2)), i, i--)
					var/obj/item/cash/c = garbage.Grab(/obj/item/cash)
					if(c)
						c.cashamount 	= value
						c.icon_state	= "cash[pick(1,2)]"
						c.SetLoc(loc, step_x, step_y)
						animate(c, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
						animate(pixel_y = rand(-8,8), time = 3)
						animate(transform = matrix(), time = 20)
						c.spawndel(300)
					sleep world.tick_lag
cash_fade
	parent_type = /atom/movable
	plane = 2
	layer = 100
	is_garbage = 1
	proc/_fade(amount,mob/mob)
		pixel_z = 0
		maptext = "<center><font color='green'>$[amount]"
		SetCenter(mob)
		pixel_x	= rand(0,8)
		animate(src,alpha = 0,pixel_z = 40,time = 5)
		spawndel(5)