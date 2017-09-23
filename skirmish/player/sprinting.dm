

mob
	player
		var
			can_sprint	= 1
			sprinting	= 0

		verb
			sprint()
				set hidden = 1
				if(health && loc && can_sprint)
					can_sprint 	= 0
					can_hit		= 0
					sprinting	= 1
					. = 0
					if(!on_fire && !fireproof || on_fire && prob(15))
						. = 1
						fireproof = 1
					play_sound('audio/sounds/jump.ogg')
					var/justahop=0
					if(key1)
						for(var/i = 1 to 8)
							if(i <= 4)
								pixel_z +=2
							else
								pixel_z -=2
							dust()
							stepDiagonal()
							step(src, dir, step_size+2)
							sleep world.tick_lag
					else
						animate(src, pixel_z = 8, time = 2)
						animate(pixel_z = 0, time = 2, easing = BOUNCE_EASING)
						dust()
						justahop = 1
					if(.) fireproof	= 0
					sprinting	= 0
					can_hit		= 1
					pixel_z		= 0
					sleep (justahop ? 2 : 5)
					can_sprint 	= 1

atom/movable
	proc/dust()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "dust[rand(1,3)]";o.pixel_x = -4;o.pixel_y = -12;o.appearance_flags = PIXEL_SCALE
		animate(o,transform = turn(matrix()*2,rand(180,360)),alpha=0,time=5)
		o.spawndel(5)

	proc/smoke()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "smoke[rand(1,3)]";o.layer = EFFECTS_LAYER;o.alpha = 0;o.appearance_flags = PIXEL_SCALE;o.plane = 2
		animate(o,transform = turn(matrix()*5,rand(120,240)), pixel_y = 16,alpha=60,time=10)
		animate(transform = turn(matrix()*8,rand(290,360)), alpha = 40, time = 90)
		animate(transform = turn(matrix()*10,rand(360,90)), alpha = 0, time = 40)
		o.spawndel(140)

	proc/rocketcloud()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'combat/projectiles.dmi';o.icon_state = "cloud[rand(1,3)]";o.plane = 3;o.appearance_flags = PIXEL_SCALE
		animate(o,transform = transform*2, pixel_y = 32, alpha = 100,time = 30)
		animate(transform = transform*5, pixel_y = 48, pixel_x = -32, alpha = 0,time = 50)
		o.spawndel(80)

	proc/greensmoke()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "greensmoke[rand(1,3)]";o.layer = EFFECTS_LAYER;o.alpha = 0;o.appearance_flags = PIXEL_SCALE
		animate(o,transform = turn(matrix()*5,rand(180,360)), pixel_y = 16,alpha=100,time=15)
		animate(transform = turn(matrix()*5,rand(180,360)), alpha = 0, time = 45)
		o.spawndel(60)