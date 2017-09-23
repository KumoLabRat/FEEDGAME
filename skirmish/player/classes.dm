

/*
			this will be where the bulk of class handling code will be kept!
		*/




mob
	player
		var
			class				= 0	//PORTAL, MEDIC, TANK
			dmg_modifier		= 1
			base_defense		= 1

			can_use_special		= 1	// 1 if the player can use their class ability.
			medcrate_deployed	= 0 // 1 if a medic player has deployed their medcrate.
			charging			= 0	// 1 if a tank player is charging.


		proc
			set_class(_class)
				/* called to set a mobs class. (_class should be PORTAL|MEDIC|TANK|etc.)
				*/
				if(_class) switch(_class)
					if(PORTAL)
						world << "setting [src]'s class to PORTAL MASTER!"
						base_health	= 100
						health		= 100
						dmg_modifier= 1 	//outgoing damage gets multiplied by this value.
						move_delay	= 0.5		// step delays get multiplied by this value.
						class		= PORTAL
					if(MEDIC)
						world << "setting [src]'s class to MEDIC!"
						base_health	= 80
						health		= 80
						dmg_modifier= 1.5 	//outgoing damage gets multiplied by this value.
						move_delay	= 0.3		// step delays get multiplied by this value.
						class		= MEDIC
					if(TANK)
						world << "setting [src]'s class to TANK!"
						base_health	= 200
						health		= 200
						dmg_modifier= 2 	//outgoing damage gets multiplied by this value.
						move_delay	= 0.6		// step delays get multiplied by this value.
						class		= TANK

		verb
			use_class_ability()
				/* call this to use the player's class-specific ability.
				*/
				set hidden = 1
				switch(class)
					if(PORTAL) // if they're a portal master class
						// cast portal here!
						src:portal_beam()
					if(MEDIC)
						// use medic ability here!
						src:deploy_medcrate()
					if(TANK)
						// use tank ability here!
						src:rhino_charge()



			deploy_medcrate()
				set hidden = 1
				if(!can_use_special) return
				can_use_special = 0
				if(medcrate_deployed)
					for(var/obj/hazard/medcrate/p in active_game.medcrates)
						if(p.owner == src)
							medcrate_deployed = 0
							active_game.medcrates -= p
							p.GC()
							break
				// here we can go ahead and cast the beam now that we purged one of the existing ones.
				var/turf/check_point
				. = 0
				check_point = get_step(get_step(src.loc, src.dir), src.dir)
				if(!check_point.density)
				//	world << 1
					for(var/atom/a in obounds(check_point, 16))
						if(a == src) continue
						if(a.density)
							if(!.) . = 1
							animate(a, color = "red", time = 2, easing = BOUNCE_EASING)
							animate( color = null, time = 2, easing = BOUNCE_EASING)
					if(!.)
					//	world << 2
						medcrate_deployed			= 1
						var/obj/hazard/medcrate/h	= garbage.Grab(/obj/hazard/medcrate)
						h.loc						= check_point
						h.step_x					= step_x-4
						h.step_y					= step_y-4
						h.owner						= src
						h.radi.loc 					= h.loc
						h.radi.step_x				= h.step_x
						h.radi.step_y				= h.step_y
						active_game.medcrates += h
						h.regen_loop()
						sleep 10
				can_use_special = 1


			rhino_charge()
				set hidden = 1
				if(!can_use_special) return
				can_use_special = 0
				charging		= 1
				. = dir
				for(var/i = 0, i < 40, i++)
					fadetrail(4)
					step(src, . , 8)
					sleep world.tick_lag
				sleep 5
				charging = 0
				sleep 20
				can_use_special = 1

obj
	medrange
		icon	= 'medradi.dmi'
		layer	= TURF_LAYER+0.2
		pixel_x	= -32
		pixel_y	= -32
		New()
			..()
			animate(src, alpha = 25, time = 20, easing = BOUNCE_EASING, loop = -1)
			animate(alpha = 180, time = 20, easing = BOUNCE_EASING, loop = -1)
turf
	proc/medthing()
		var/obj/o = new/obj
		o.SetCenter(Cx(),Cy(),z)
		o.icon = 'game/misc_effects.dmi';o.icon_state = "med";o.layer = EFFECTS_LAYER;o.alpha = 0;o.appearance_flags = PIXEL_SCALE;o.plane = 3
		animate(o, pixel_y = 16,alpha=200,time=rand(3,5))
		o.spawndel(6)


obj
	hazard

		medcrate
			icon			= '_new x32.dmi'
			icon_state		= "medcrate"
			is_garbage		= 1
			density			= 1
			bound_width		= 32
			bound_height	= 32
			var
				mob/owner	// this is who deployed the medcrate; used for culling old crates and managing regen bonuses for players abd their friends.
				obj/radi = new /obj/medrange
			New()
				..()
				draw_spotlight(x_os = -32, y_os = -32, hex = "#6ef442", size_modi = 2, alph = 195)
			GC()
				owner = null
				radi.loc = null
				..()


			proc
				regen_loop()
					/* i don't typically like running individual loops but i think this is an instance where it'd be better than
							trying to embed this all in a global loop.
					basically tracks players within 64px range and gradually regens their hp.
					*/
					spawn while(owner)
						// runs as long as an owner is defined -- GC() handles owner nulling automatically. So just GC() to shut down a medcrate.
						for(var/atom/a in obounds(src, 32))
							if(istype(a, /mob/player))
								var/mob/player/p = a
								if((p in active_game.participants) && !p.died_already)
									if(!p.color)
										animate(p, color = "green", time = 3, easing = QUAD_EASING, loop = 1)
										animate(color = null, time = 2, easing = QUAD_EASING, loop = 1)
									if(p.health < p.base_health)
										p.edit_health(25, owner)
							if(isturf(a) && prob(8)) a:medthing()
							sleep world.tick_lag
						sleep 5
