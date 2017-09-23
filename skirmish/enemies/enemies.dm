q
var
	tmp
		list/ai_list 	= new/list()
	speed_modi			= 5


proc
	ai_loop()
		set waitfor = 0
		for()
			if(active_game.pause) while(active_game.pause && active_game.started == 2 ) sleep 5
			if((support_ai.len || ai_list.len) && active_game.started == 2) for(var/mob/npc/m in ai_list+support_ai)	// tracks support ai and enemy ai
				if(active_game.intermission && istype(m, /mob/npc/hostile))
		//			world << "debug: enemies leftover during intermission ; culling."
					m.health = 0
					m.GC()
					ai_list -= m
				else if(!m.stunned)
					if(istype(m,/mob/npc/hostile/puppet_master)) m:puppet.ai_check()
					m.ai_check()
			sleep world.tick_lag

	speed_modifier()
		/*
			call this to set the speed_modi variable which controls the speed enemies move.
			Enemies will get incrementally faster over the first 20 waves.
		*/
		var/divisor = round(active_game.current_round/2)
		if(divisor < 1) divisor = 1
		if(divisor > 10) divisor = 10
		speed_modi = 5/divisor
	//	world << "speed modi:: [speed_modi]"
		if(speed_modi < 0.7) speed_modi = 0.7

mob/var/is_giant = 0

mob/npc
	is_garbage			= 1
	bound_height		= 20
	var/tmp
		resting			= 0 // whether or not the npc should get ignored by the ai loop proc
		ig_bump			= 0 // 1 if Bump() should be ignored.
		auto_target		= 1	// 1 if the mob should automatically target the nearest player.
		has_spotlight 	= 1 // 1 if the mob should/can have a spotlight
		can_phantom		= 1	// 0 if the enemy is immune to phantom status
		mob/target


	proc
		generate_gibs()
			if(!bodyparts) bodyparts = new()
			if(bodyparts.len) bodyparts.Cut()
			for(var/i = 1,i <= 6, i++)
				var/obj/gib = garbage.Grab(/obj/gib/)
				gib.icon_state = "gut[i]"
				bodyparts += gib

		ai_check()
			// this is where you add the npcs behavior.
			if(!target) // target selection
				if(prob(55))
					/* when no target is had, add a chance to step around or do quirky stuff.
					*/
					step(src, pick(dir, turn(dir, pick(-45, 45))))
					if(prob(35)) // chance to hop in place.
						dust()
						animate(src, pixel_z = 8, time = 3)
						animate(pixel_z = 0, time = 2, easing = BOUNCE_EASING)
				for(var/mob/p in (active_game.participants+support_ai))
					if(!p.health || !p.loc || p.z != z) continue
					if(p.cowbell)
						target = p
						break	// since cowbells will attract every enemy.
					if(!target) if(get_dist(src, p) <= 15) target = p
					else if(get_dist(src, p) < get_dist(src, target))
						target = p
				if(!target && prob(25)) respawn()

	Bump(atom/a)
		if(kb_init)
			kb_init = 0
			if(istype(a, /mob/player) || istype(a, /mob/npc))
				a:knockback(12, get_dir(src, a))
			stun()
		if(istype(a, /obj/barricade))
			var/obj/barricade/b = a
			if((kb_init || src.is_giant) && istype(b, /obj/barricade/crate))
				b:Break()
			else
				b.last_pusher = src
				step(b, dir)
		if(!ig_bump && target && world.cpu < 40)
			ig_bump = 1
			step_to(src, target)
			ig_bump = 0

	hostile
		verb/killoffdel()
			set src in oview()
			if(!usr:is_GM) src << "You can't use this, guy.";return
			world << "<font color = red>del'ing [src]"
			del src

		var/tmp
			mob/player/last_attacker
			turf/last_loc
			same_loc_steps	// how many times the mob has been stuck in the same tile.
			spawn_rate	= 100
			mob/npc/hostile/puppet_master/puppet_master

		New()
			..()
			if(has_spotlight && !spotlight) draw_spotlight(x_os = -41, y_os = -38, hex = "#FFFFFF", size_modi = 0.8, alph = 155)//"#FF3333")
		GC()
			..()
			if(censored) censor(1)
			if(puppet_master) puppet_master = null
			if(can_smudge) clear_smudges(src)
			animate(src, 0)
			density			= 1
			alpha			= 255
			last_attacker	= null
			transform		= matrix()
			step_size		= initial(step_size)

		death(exploding)
//			world << "check?"
			if(puppet_master)
				ai_list -= puppet_master
				puppet_master.GC()
			else ai_list -= src
			if(last_attacker) last_attacker.kills ++
			density	= 0
			if(!exploding)
				death_animation()
				sleep 5
			..()
			active_game.enemies_left --
			if(prob(15)) drop_loot()
			if(is_explosive) // if is_explosive is toggled on for the mob, that means to blow it up when it dies!
				is_explosive = 0
				if(bodyparts) spontaneous_explosion(loc,1,-45,bodyparts)
				else spontaneous_explosion(loc, 1, -45)
			GC()
			active_game.progress_check()

//////////////////////////////////////

		feeder
			icon			= 'enemies/_Zombie.dmi'
			icon_state		= "feeder"
			density			= 1
			step_size		= 3
			bound_x			= 8
			base_health		= 18
			kill_score		= 5
			spawn_rate		= 100
			can_smudge		= 1
			pixel_x			= 2
			var/obj/blood	= new/obj
			var/obj/shirt	= new/obj
			var/bodcolor	= null
			New()
				if(has_spotlight && !spotlight) world << "woohoo";draw_spotlight(x_os = -33, y_os = -38, hex = "#FFFFFF", size_modi = 0.8, alph = 155)
				..()
				bodcolor			= rgb(rand(100,150),rand(100,150),rand(100,150))
				blood.icon			= 'enemies/_Zombie.dmi'
				blood.icon_state	= "blood[rand(1,4)]"
				blood.layer			= MOB_LAYER
				shirt.icon			= 'enemies/_Zombie.dmi'
				shirt.icon_state	= "shirt[pick(1,3)]"
				shirt.layer			= MOB_LAYER
				overlays.Add(shirt, blood)
				icon				+= bodcolor
			GC()
				if(is_giant)
					bounds_scale(1)	// resets the bounds to the default.
					transform 		= matrix()
					is_giant		= 0
					can_kb			= 1
					base_health		= 34
					health			= 34
				..()

			generate_gibs()
				..()
				for(var/i = 1, i <= 6, i++)
					var/obj/gib = garbage.Grab(/obj/gib/feeder)
					gib.icon_state = "[i]"
					gib.icon = initial(gib.icon)
					gib.icon += bodcolor //color
					gib.transform = (is_giant ? matrix()*2 : matrix())
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(0.5)) gs(pick('audio/sounds/growl1.ogg', 'audio/sounds/growl2.ogg'),1)
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 30 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								flick("[blood.icon_state]-attack", blood)
								target.knockback(12, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									if(prob(35)) // chance to hop in place.
										dust()
										animate(src, pixel_z = 8, time = 3)
										animate(pixel_z = 0, time = 2, easing = BOUNCE_EASING)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 8) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi
					resting = 0


		bleeder
			icon			= 'enemies/bleeder.dmi'
			icon_state		= "bleeder1"
			density			= 1
			bound_x			= 8
			step_size		= 3
			base_health		= 10
			kill_score		= 2
			var/obj/guts	= new/obj
			var/obj/blood	= new/obj
			var/bodcolor	= null
			New()
				..()
				bodcolor			= rgb(rand(100,200),rand(100,200),rand(100,200))
				guts.icon			= 'enemies/bleeder.dmi'
				guts.icon_state		= "guts1"
				guts.layer			= MOB_LAYER
				blood.icon			= 'enemies/bleeder.dmi'
				blood.layer			= MOB_LAYER
				overlays.Add(guts, blood)
				icon				+= bodcolor
				draw_spotlight(x_os = -33, y_os = -31, hex = "#FFFFFF", size_modi = 0.8, alph = 155)
			GC()
				if(is_giant)
					bounds_scale(1)
					transform	= matrix()
					is_giant	= 0
				..()

			generate_gibs()
				..()
				for(var/i = 1, i <= 2, i++)
					var/obj/gib = garbage.Grab(/obj/gib/bleeder)
					gib.icon_state = "[i]"
					gib.icon = initial(gib.icon)
					gib.icon += bodcolor //color
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(0.5)) gs(pick('audio/sounds/growl1.ogg', 'audio/sounds/growl2.ogg'),1)
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
						//		flick("[icon_state]-attack", src)
								target.knockback((is_giant ? 24 : 12), step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								drop_blood(1)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep 3.3
					resting = 0


		crawler
			icon			= 'enemies/_Crawler.dmi'
			icon_state		= "grey"
			density			= 1
			step_size		= 4
			base_health		= 20
			kill_score		= 10
			spawn_rate		= 80

			generate_gibs()
				..()
				for(var/i = 1, i <= 2, i++)
					var/obj/gib = garbage.Grab((icon_state == "grey" ? /obj/gib/crawlergrey : /obj/gib/crawlerwhite))
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(0.5)) gs(pick('audio/sounds/growl1.ogg', 'audio/sounds/growl2.ogg'))
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 30 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(4, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								if(prob(get_dist(src, target)))
									for(var/i = 1 to 6)
										fadetrail(5)
										dust()
										step(src, step_dir, step_size+2)
										sleep world.tick_lag
								else
									step(src, step_dir)
									if(last_loc == loc)
										same_loc_steps ++
										if(same_loc_steps > 70)
											. = 1
											for(var/mob/player/p in active_game.participants)
												if(get_dist(p, src) < 8) . = 0; break
											if(.) same_loc_steps = 0; respawn()
									else
										last_loc 		= loc
										same_loc_steps	= 0
					else ..()
					sleep speed_modi+0.5
					resting = 0


		hellbat
			icon			= 'enemies/hellbat.dmi'
			icon_state		= "hellbat"
			density			= 1
			step_size		= 3
			base_health		= 10
			fireproof		= 1
			explosion_proof	= 1
			can_censor		= 0
			bound_x			= 20
			bound_y			= 20
			has_spotlight	= 0
			can_phantom		= 0
			kill_score		= 10
			spawn_rate		= 35
			var/tmp/flying	= 0

			generate_gibs()
				..()
				bodyparts.Cut(6)
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/hellbat)
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(!flying)
						flying		= 1
						can_hit		= 0
						density		= 0
						animate(src, pixel_y = 32, alpha = 55, transform = matrix(), time = 5, easing = ELASTIC_EASING)
						for(var/i = 4, i, i--) step(src, dir);sleep 1
					if(target)
						if(!target.health || !target.loc || target.z != z)	// if the target is dead, off map,
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 8 && flying)
								flying 		= 0
								can_hit		= 1
								icon_state	= "hellbat-attack"
								animate(src, pixel_y = 0, alpha = 255, transform = transform/2, time = 5, easing = BOUNCE_EASING)
								density	= 1
								for(var/i = 4, i > 0, i--)
									step(src, get_dir(src, target))
									sleep 1
								if(target in obounds(src, 4))
									target.knockback(4, step_dir)
									target.edit_health(-10)
								dust()
								dust()
								icon_state	= "hellbat"
								sleep 20
							else if(!kb_init)
								step(src, step_dir)
					else ..()
					sleep 0.8
					resting = 0
////////////////////////////////////////

		puppet_master
			base_health = 35
			kill_score	= 20
			spawn_rate 	= 50
			var/tmp/
				mob/npc/hostile/puppet
				shiftiness = 100
				wait = 0

			ai_check()
				set waitfor = 0
				if(wait >= world.realtime)
					if(prob(shiftiness))
						animate(puppet,transform = matrix(0,0,MATRIX_SCALE),time = world.tick_lag * 10)
						puppet.smoke()
						sleep(world.tick_lag * 10)
						var/turf/spawnpoint 	= puppet.loc
						var/stepx 				= puppet.step_x
						var/stepy 				= puppet.step_y
						var/newhealth 			= puppet.health
						puppet.GC()
						puppet 					= garbage.Grab(pick(active_game.spawnlist + /mob/npc/hostile/feeder))
						puppet.SetLoc(spawnpoint,stepx,stepy)
						puppet.health 			= newhealth
						puppet.puppet_master 	= src
						puppet.transform 		= matrix(0,0,MATRIX_SCALE)
						puppet.can_hit			= 1
						animate(puppet,transform = matrix(1,1,MATRIX_SCALE),time = world.tick_lag * 10)
						wait = world.realtime + (100 * world.tick_lag)
			GC()
				puppet	= null
				loc 	= null
				..()






		shade
			icon			= 'enemies/shade.dmi'
			icon_state		= "shade"
			density			= 1
			step_size		= 2
			base_health		= 45
			fireproof		= 1
			can_censor		= 0
			kill_score		= 15
			spawn_rate		= 45
			var/obj/weapon/special/skill1 = new /obj/weapon/special/shadowball

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 30 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(get_dist(src, target) <= 2)
								if(!step_away(src, target))
									smoke()
									smoke()
									smoke()
									animate(src, alpha = 0, time = 3, loop = 1)
									loc = pick(active_game.enemy_spawns)
									animate(src, alpha = 255, time = 3, loop = 1)
							else if(get_dist(src, target) < 6 && skill1.can_use && shot_lineup())
								flick("shade-attack", src)
								sleep 2.2
								dir = get_general_dir(src, target)
								skill1.use(src)
								sleep 3
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 10) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1
					resting = 0


		slammer
			icon			= 'enemies/slammer.dmi'
			icon_state		= "slammer"
			density			= 1
			step_size		= 2
			base_health		= 35
			kill_score		= 10
			spawn_rate		= 5

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(14, step_dir)
								target.edit_health(-30)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1.5
					resting = 0
			generate_gibs()
				..()
				bodyparts.Cut(6)
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/slammer)
					gib.icon_state = "[i]"
					bodyparts += gib


		blaze
			icon			= 'enemies/_Blaze.dmi'
			icon_state		= "blaze"
			density			= 1
			step_size		= 2
			base_health		= 30
			fireproof		= 1
			can_censor		= 0
			can_phantom		= 0
			kill_score		= 15
			spawn_rate		= 20
			var/obj/weapon/special/skill1 = new /obj/weapon/special/fireblast

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					fadetrail(8)
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 30 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("blaze-attack", src)
								sleep 5
								target.knockback(12, step_dir)
								target.edit_health(-20)
								target.burn(src)
								sleep 15
							else if(prob(25) && get_dist(src, target) < 5 && skill1.can_use && shot_lineup())
								sleep 3
								flick("blaze-attack", src)
								sleep 1.2
								dir = get_general_dir(src, target)
								skill1.use(src)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(prob(30)) drop_fire(1, src, 5)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep world.tick_lag*2
					resting = 0
			generate_gibs()
				..()
				for(var/i = 1, i <= 4, i++)
					var/obj/gib = garbage.Grab(/obj/gib/blaze)
					gib.icon_state = "[i]"
					bodyparts += gib

		charger
			icon			= 'enemies/_Charger.dmi'
			icon_state		= "charger"
			density			= 1
			step_size		= 3
			base_health		= 20
			is_explosive	= 0
			kill_score		= 10
			spawn_rate		= 60
			var/obj/blood	= new/obj
			var/bodcolor	= null
			var/charging	= 0
			New()
				..()
				bodcolor			= rgb(rand(100,200),rand(100,200),rand(100,200))
				blood.icon			= 'enemies/_Charger.dmi'
				blood.icon_state	= "blood"
				blood.layer			= MOB_LAYER
				overlays			+= blood
				icon				+= bodcolor
			GC()
				charging		= 0
				is_explosive	= 0
				overlays -= overlays/////////////
				alpha 			= 255
				icon_state		= "charger"
				..()
			generate_gibs()
				..()
				for(var/i = 1, i <= 6, i++)
					var/obj/gib = garbage.Grab(/obj/gib/feeder)
					gib.icon_state = "[i]"
					gib.icon = initial(gib.icon)
					gib.icon += bodcolor //color
					bodyparts += gib
			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(5)) gs(pick('audio/sounds/growl1.ogg', 'audio/sounds/growl2.ogg'),1)
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 30 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if((bounds_dist(src, target) <= 20) && !charging)
								charging				= 1
								var/obj/mouthanim		= new/obj
								var/obj/tummyanim		= new/obj
								var/obj/mouth			= new/obj
								var/obj/tummy			= new/obj
								mouthanim.icon			= 'enemies/_Charger.dmi'
								mouthanim.icon_state	= "mouth_anim"
								mouthanim.layer			= MOB_LAYER
								tummyanim.icon 			= 'enemies/_Charger.dmi'
								tummyanim.icon_state	= "tummy_anim"
								tummyanim.layer			= MOB_LAYER
								tummyanim.icon			+= bodcolor
								mouth.icon				= 'enemies/_Charger.dmi'
								mouth.icon_state		= "mouth"
								mouth.layer				= MOB_LAYER
								tummy.icon 				= 'enemies/_Charger.dmi'
								tummy.icon_state		= "tummy"
								tummy.layer				= MOB_LAYER
								tummy.icon				+= bodcolor
								overlays				+= mouthanim
								overlays				+= tummyanim
								sleep(5.6)
								overlays				-= mouthanim
								overlays				-= tummyanim
								overlays				+= mouth
								overlays				+= tummy
							if(bounds_dist(src, target) <= 2)
								charging 		= 0
								is_explosive	= 1
								Explode(30,-30,src,1)
								death()
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					if(!charging) sleep 2
					else
						sleep world.tick_lag*1.5
					resting = 0


		puker
			icon			= 'enemies/_Puker.dmi'
			icon_state		= "blue"
			density			= 1
			step_size		= 3
			base_health		= 15
			can_slow		= 0
			kill_score		= 5
			spawn_rate		= 45

			generate_gibs()
				..()
				for(var/i = 1, i <= 4, i++)
					var/obj/gib = garbage.Grab(/obj/gib/puker)
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
				//	if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(prob(1))
						flick("[icon_state]-attack", src)
						var/obj/hazard/puke/f 	= garbage.Grab(/obj/hazard/puke)
						f.loc					= loc
						f.step_x				= step_x-8
						f.step_y				= step_y-8
						f.spawndel(150)
						sleep 10
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 30 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
						//		target.knockback(6, step_dir)
								target.edit_health(-5)
								var/obj/hazard/puke/f 	= garbage.Grab(/obj/hazard/puke)
								f.loc					= target.loc
								f.step_x				= target.step_x-8
								f.step_y				= target.step_y-8
								f.spawndel(150)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep world.tick_lag*3
					resting = 0



		beholder
			icon			= 'enemies/beholder.dmi'
			icon_state		= "beholder"
			density			= 1
			step_size		= 4
			base_health		= 20
			fireproof		= 1
			can_censor		= 0
			kill_score		= 5
			spawn_rate		= 25
			var/obj/weapon/special/skill1 = new /obj/weapon/special/fireball

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("beholder-attack", src)
								sleep 3
								target.knockback(5, step_dir)
								target.edit_health(-20)
								target.burn(src)
								sleep 10
							else if(get_dist(src, target) < 4 && skill1.can_use && shot_lineup())
								dir = get_general_dir(src, target)
								flick("beholder-attack", src)
								sleep 3
								skill1.use(src)
								sleep 3
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1
					resting = 0

			generate_gibs()
				..()
				bodyparts.Cut(6)
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/beholder)
					gib.icon_state = "[i]"
					bodyparts += gib

		abstract
			icon			= 'enemies/beholder.dmi'
			icon_state		= "abstract1"
			density			= 1
			step_size		= 3
			base_health		= 15
			fireproof		= 1
			can_censor		= 0
			has_spotlight	= 1
			kill_score		= 10
			spawn_rate		= 55
			var/obj/weapon/special/skill1 = new /obj/weapon/special/quadbeam

			generate_gibs()
				..()
				bodyparts.Cut(6)
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/abstract1)
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && shot_lineup())
								dir = get_dir(src, target)
								flick("abstract1-attack", src)
								sleep 3
								skill1.use(src)
								sleep 5
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+0.5
					resting = 0
			death()
				skill1.use(src)
				..()

		abstract2
			icon			= 'enemies/beholder.dmi'
			icon_state		= "abstract2"
			density			= 1
			step_size		= 3
			base_health		= 15
			fireproof		= 1
			can_censor		= 0
			has_spotlight	= 1
			kill_score		= 10
			spawn_rate		= 55
			var/obj/weapon/special/skill1 = new /obj/weapon/special/xbeam

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && diag_lineup())
								dir = get_dir(src, target)
								flick("abstract2-attack", src)
								sleep 8
								skill1.use(src)
								sleep 5
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+0.5
					resting = 0

			generate_gibs()
				..()
				bodyparts.Cut(6)
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/abstract2)
					gib.icon_state = "[i]"
					bodyparts += gib

			death()
				skill1.use(src)
				..()








		petite_feeder
			icon			= 'enemies/_Zombie.dmi'
			icon_state		= "girl"
			density			= 1
			step_size		= 3
			base_health		= 10
			kill_score		= 5
			spawn_rate		= 18
			var/obj/shirt	= new/obj
			New()
				..()
				shirt.icon			= 'enemies/_Zombie.dmi'
				shirt.icon_state	= "girlclothes1"
				shirt.layer			= MOB_LAYER
				overlays += shirt

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								flick("[shirt.icon_state]-attack", shirt)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 12) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*1.5
					resting = 0



	proc
		shot_lineup()
			if(loc && target && target.loc)
				switch(get_dir(src, target))
					// if tiles are lined up, line up the pixel coordinates!
					if(NORTH, SOUTH)
						if(target.step_x > step_x)	// target is further right on their tile than src.
							for(var/i = 1, i < pick(2,4), i++)
								step(src, EAST, 4)
								sleep world.tick_lag
						else
							for(var/i = 1, i < pick(2,4), i++)
								step(src, WEST, 4)
								sleep world.tick_lag
						return 1
					if(EAST, WEST)
						if(target.step_y > step_y)	// target is further north on their tile than src.
							for(var/i = 1, i < pick(2,4), i++)
								step(src, NORTH, 4)
								sleep world.tick_lag
						else
							for(var/i = 1, i < pick(2,4), i++)
								step(src, SOUTH, 4)
								sleep world.tick_lag
						return 1
				// otherwise, line up tiles.
					if(NORTHEAST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, EAST)
							else	step(src, NORTH)
							if(get_dir(src, target) == NORTH || get_dir(src, target) == EAST)
								return 0
							loops --
							sleep world.tick_lag
					if(NORTHWEST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, WEST)
							else	step(src, NORTH)
							if(get_dir(src, target) == NORTH || get_dir(src, target) == WEST)
								return 0
							loops --
							sleep world.tick_lag
					if(SOUTHEAST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, EAST)
							else	step(src, SOUTH)
							if(get_dir(src, target) == SOUTH || get_dir(src, target) == EAST)
								return 0
							loops --
							sleep world.tick_lag
					if(SOUTHWEST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, WEST)
							else	step(src, SOUTH)
							if(get_dir(src, target) == SOUTH || get_dir(src, target) == WEST)
								return 0
							loops --
							sleep world.tick_lag
			return 0



		diag_lineup()
			if(loc && target && target.loc)
				switch(get_dir(src, target))
					if(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						return 1
					else return 0