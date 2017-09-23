

/*

breakable objects can be destroyed, usually via explosion.
*/

turf
	terrain
		_breakable
			var
				destroyed	= 0
			proc
				destroy()
					if(!destroyed)
						destroyed 	= 1
						animate(src, pixel_x = 1, time = 2)
						animate(pixel_x = -1, time = 2)
						for(var/i = 0, i < 6, i++)
							dust()
						sleep 4
						density	= 0
						opacity	= 0
						alpha	= 0


			chainlink
				icon			= '_new x32.dmi'
				icon_state		= "chainlink1-b"
				density			= 1
				layer			= TURF_LAYER+2
				d_ignore		= 1
				New()
					..()
					overlays += new /obj/overlays/chainlink

			wall1
				icon			= 'new32x32.dmi'
				icon_state		= "wall1"
				density			= 1
				bound_height	= 32
				New()
					..()
					icon_state	= "wall[pick(1,5)]"

			wall2
				icon		= 'new32x32.dmi'
				icon_state	= "tile wall"
				density		= 1
				bound_height= 32

			hedge
				icon			= '_new x16.dmi'
				icon_state		= "hedge b"
				density			= 1
				layer			= TURF_LAYER+0.2
				d_ignore		= 1
				New()
					..()
					overlays += new /obj/overlays/hedge_tl
