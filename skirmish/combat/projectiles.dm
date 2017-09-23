
var/tmp
	list/active_projectiles	= new

proc
	projectile_loop()
		/*
			all the active projectiles on the map are tracked by this proc.
		*/
		set waitfor = 0
		for()
			if(active_game.pause) while(active_game.pause && active_game.started == 2) sleep 5
			if(active_projectiles.len && active_game.started == 2) for(var/obj/projectile/p in active_projectiles)
				if(!p.timeout && !p.exploded)
					p.take_step()
				if(!(p.loc))
					active_projectiles -= p							// projectiles cleaned here.
			//		world << "Projectile stuck in limbo; culled."
			sleep world.tick_lag

atom
	var/d_ignore		= 0	// toggle this on a dense atom and projectiles will ignore the atom's density.

obj
	projectile
		icon			= 'projectiles.dmi'
		is_garbage		= 1
		step_size		= 8
		bound_x			= 7
		bound_y			= 4
		bound_width		= 3
		bound_height	= 3
		plane			= 2
		density			= 1
		layer			= EFFECTS_LAYER
		var/tmp
			hp_modifier	= -1		// the hp of mobs that the projectile hits will be effected by this value. positive will heal, negative will damage.
			penetration	= 100	// the probability of the projectile penetrating through a collided mob.
			px_range	= 128	// the distance(in pixels) that the projectile can travel before being being culled.(** if(step_size*total_steps > px_range) **)
			accuracy	= 100	// every [accuracy] pixels, the projectile will stray 1px off from true center.
			total_steps	= 0		// the number of steps the projectile has made since being spawned.   damage falloff = (damage)-
			kb_dist		= 4
			velocity	= 1.5
		/*
			these variables cannot be edited.
	*/
			sway 			= 1	// positive or negative ; used to help track the direction that projectiles should sway
			mob/owner
			atom/movable/last_hit	// the last moveable atom the projectile hit. (used to help prevent projectiles from hitting targets multiple times when penetrating)
			accur_assist	= 0	// used to assist with tracking accuracy offsets.
			is_crit			= 0	// used to keep track of critical shots.
			timeout			= 0

		GC()
//			if(icon_state == "pickle1")
//				world << "debug pickle1!!1!"
//				if(owner && istype(owner, /mob/player))
//					if(owner:current_weapon.type == /obj/weapon/gun/gherkin)
//						owner:current_weapon.can_use = 1
			hp_modifier		= -1	// important to reset to 0 so that it gets recognized as a new projectile when reused.
			penetration		= 100
			total_steps		= 0
			owner			= null
			last_hit		= null
			accur_assist	= 0
			is_crit			= 0
			color			= null
			is_explosive 	= 0
			..()

		Bump(atom/a)
			if(istype(a, /obj/projectile) || a.d_ignore || owner == a || (istype(a, /mob/npc/support) && owner && owner.type == /mob/player && !active_game.PvP))
				if(a.type == type && a:owner != owner) // if they're the same types

					a:GC()
					GC()
					// end them both!
					return
				if(dir == WEST) step_x -= step_size
				if(dir == EAST) step_x += step_size
				if(dir == NORTH)step_y += step_size
				if(dir == SOUTH)step_y -= step_size
				if(dir == NORTHEAST)
					step_x += step_size
					step_y += step_size
				if(dir == SOUTHEAST)
					step_x += step_size
					step_y -= step_size
				if(dir == NORTHWEST)
					step_x -= step_size
					step_y += step_size
				if(dir == SOUTHWEST)
					step_x -= step_size
					step_y -= step_size
			else
			//	loc	= null
				. = 0
				if(ismob(a))
					var/mob/m 	= a
					if(m.can_hit)
						if(last_hit && last_hit == m) // we already hit this mob and penetrated it!
						//	world << "hit stack prevented!"
							if(dir == WEST) step_x -= step_size
							if(dir == EAST) step_x += step_size
							if(dir == NORTH)step_y += step_size
							if(dir == SOUTH)step_y -= step_size
							if(dir == NORTHEAST)
								step_x += step_size
								step_y += step_size
							if(dir == SOUTHEAST)
								step_x += step_size
								step_y -= step_size
							if(dir == NORTHWEST)
								step_x -= step_size
								step_y += step_size
							if(dir == SOUTHWEST)
								step_x -= step_size
								step_y -= step_size
							return
						if(owner && !last_hit) owner.hit_streak ++ // lets add a successful hit to the hit streak counter!
						last_hit = m	// m was hit by the projectile.. let's remember that.
						if(icon_state == "pickle1")
							if(owner && owner.type == m.type) hp_modifier = 10 // if same types, recover m's hp

						if(kb_dist) m.knockback(kb_dist, dir)
						m.edit_health((is_crit ? hp_modifier : hp_modifier+hp_modifier), owner, 0, gib = is_crit)
						if((icon_state == "firebullet" || icon_state == "fireblast" || (icon_state == "fireball" && prob(25))) && m.health) m.burn()
						if(m) m.penetrate()
						if(prob(penetration) && step_size*total_steps < px_range)
							. = 1
							if(dir == WEST) step_x -= step_size
							if(dir == EAST) step_x += step_size
							if(dir == NORTH)step_y += step_size
							if(dir == SOUTH)step_y -= step_size
							if(dir == NORTHEAST)
								step_x += step_size
								step_y += step_size
							if(dir == SOUTHEAST)
								step_x += step_size
								step_y -= step_size
							if(dir == NORTHWEST)
								step_x -= step_size
								step_y += step_size
							if(dir == SOUTHWEST)
								step_x -= step_size
								step_y -= step_size
						else // if it didn't penetrate..
							if(icon_state == "bolt") // and it was an arrow..
								m.stick_arrow()
						if(icon_state == "tako")
							. = 1
							Explode(42, -100, owner)
				if(istype(a, /atom/movable))
					if(a:is_explosive && !ismob(a))
						if(owner && !last_hit) owner.hit_streak ++ // explosives count as hits!
						a:Explode(42, -100, owner)
					else
						if(icon_state == "tako")
							. = 1
							Explode(42, -100, owner)
				else
					if(icon_state == "tako")
						flick("explode",src)
						Explode(42, -100, owner)
				if(. == 0) GC()



		proc
			take_step()
				/*
					called to handle the projectile's step behavior.
				*/
				set waitfor = 0
				timeout = 1
				if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
					if(owner && !last_hit) owner.hit_streak = 0 // reset the streak if a projectile expires without hitting anything
					GC()
				else
					if(loc)
						total_steps ++
						if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
							accur_assist = round((step_size*total_steps)/accuracy)
							if(dir == EAST || dir == WEST)	step_y += sway
							else 							step_x += sway
			//			if(icon_state == "bullet") for(var/mob/player/p in obounds(src,2))				//	THIS IS FOR BULLET WHIZ SOUND EFFECT
			//				if(p != owner) p.ps('bulletwhiz1.wav')
						trail(is_crit, dir)
						step(src, dir)
						if(icon_state == "fireblast" && prob(5))
							drop_fire(2, owner)
						sleep world.tick_lag*velocity
				timeout = 0


			trail(crit = 0, _dir = null)
				var/obj/o = new/obj
				o.SetCenter(Cx(),Cy(),z)
				o.icon = 'projectiles.dmi';o.icon_state = "[icon_state]-trail";o.plane = 2;o.layer = EFFECTS_LAYER-1;o.dir = _dir
				if(o.icon_state != "firebullet-trail" && o.icon_state != "fireball-trail" && owner && owner.client) o.color = owner:namecolor
				if(crit) 	animate(o, alpha=0, transform = turn(transform, 360), color = "red",time=5)
				else		animate(o, alpha=0, transform = turn(transform, 360), time=5)
				o.spawndel(5)

		missile
			icon_state	= "rocket1"
			density		= 0
			step_size	= 6
			bound_x		= 7
			bound_y		= 4
			bound_width	= 3
			bound_height= 3

			hp_modifier	= -5
			penetration	= 0
			accuracy	= 8	// every [accuracy] pixels, the projectile will stray 1px off from true center.
			kb_dist		= 0
			velocity	= 0.5
			px_range	= 60
			plane		= 2

			GC()
				icon_state		= "rocket1"
				is_explosive	= 0
				if(src in active_projectiles) active_projectiles -= src
				..()

			take_step()
				/*
					called to handle the projectile's step behavior.
				*/
				set waitfor = 0
				timeout = 1
				if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
					is_explosive = 1
					Explode(42, -100, owner)
				else
					if(loc)
						if(total_steps == 1)
							animate(src, alpha = 150, time = 1, loop = 1)
						if(total_steps == 4)
							animate(src, alpha = 255, transform = matrix(), time = 2, loop = 1)
						total_steps ++
						if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
							accur_assist = round((step_size*total_steps)/accuracy)
							if(dir == EAST || dir == WEST) step_y += sway
							else step_x += sway
						step(src, SOUTH)
						rocketcloud()
						sleep world.tick_lag*1.5
				timeout = 0


		thrown
			icon			= 'projectiles.dmi'
			is_garbage		= 1
			step_size		= 4
			bound_x			= 7
			bound_y			= 4
			bound_width		= 3
			bound_height	= 3
			plane			= 2
			density			= 1
			var/tmp
				end_step 	= 0
			boomerang
				icon_state	= "boomerang"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 0

				hp_modifier	= -15
				plane		= 2
				penetration	= 85
				px_range	= 192
				accuracy	= 50	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5
				var/found	= 0
				var/obj/weapon/special/boomerang/origin
				GC()
					end_step = 0
					..()
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore)
						loc = get_step(src, dir)
						return
					if(istype(a,/mob/npc/hostile))
						var/mob/m = a
						m.edit_health(rand(-5,-10),owner)
						if(prob(penetration) && step_size*total_steps < px_range)
							if(dir == WEST) step_x -= step_size
							if(dir == EAST) step_x += step_size
							if(dir == NORTH)step_y += step_size
							if(dir == SOUTH)step_y -= step_size
							if(dir == NORTHEAST)
								step_x += step_size
								step_y += step_size
							if(dir == SOUTHEAST)
								step_x += step_size
								step_y -= step_size
							if(dir == NORTHWEST)
								step_x -= step_size
								step_y += step_size
							if(dir == SOUTHWEST)
								step_x -= step_size
								step_y -= step_size

						else end_step = 1
						return
					if(owner == a)
						found = 1
						//owner.arms_state("base-boomerang")
						origin.can_use = 1
						GC()
					else if(a.density)
						if(!end_step) end_step = 1
						else switch(get_dir(src, owner))
							if(WEST) step_x -= step_size
							if(EAST) step_x += step_size
							if(NORTH)step_y += step_size
							if(SOUTH)step_y -= step_size
							if(NORTHEAST)
								step_x += step_size
								step_y += step_size
							if(SOUTHEAST)
								step_x += step_size
								step_y -= step_size
							if(NORTHWEST)
								step_x -= step_size
								step_y += step_size
							if(SOUTHWEST)
								step_x -= step_size
								step_y -= step_size

				take_step()
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range || end_step) // if the projectile has taken its maximum amount of steps..
						find_owner()
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if((step_size*total_steps) < (px_range/2))
								if(dir == EAST || dir == WEST) pixel_y += 1
							else
								if(dir == EAST || dir == WEST) pixel_y -= 1
							step(src, dir)
							sleep world.tick_lag
						timeout = 0

				proc/find_owner()
					while(!found)
						step(src,get_dir(src,owner))
						sleep world.tick_lag
				kaboomerang
					icon_state		= "kaboomerang"
					bound_x			= 2
					bound_y			= 2
					bound_width		= 4
					bound_height	= 4
					is_explosive	= 0
					hp_modifier		= -10
					plane			= 2
					penetration		= 56
					px_range		= 192
					accuracy		= 50	// every [accuracy] pixels, the projectile will stray 1px off from true center.
					kb_dist			= 0
					velocity		= 0.5
					Bump(atom/a)
						if(istype(a, /obj/projectile) || a.d_ignore)
							loc = get_step(src, dir)
							return
						if(istype(a,/mob/npc/hostile) && a != owner)
							var/mob/m = a
							m.edit_health(rand(-5,-10),owner)
							if(prob(penetration) && step_size*total_steps < px_range)
								if(dir == WEST) step_x -= step_size
								if(dir == EAST) step_x += step_size
								if(dir == NORTH)step_y += step_size
								if(dir == SOUTH)step_y -= step_size
								if(dir == NORTHEAST)
									step_x += step_size
									step_y += step_size
								if(dir == SOUTHEAST)
									step_x += step_size
									step_y -= step_size
								if(dir == NORTHWEST)
									step_x -= step_size
									step_y += step_size
								if(dir == SOUTHWEST)
									step_x -= step_size
									step_y -= step_size
							else end_step = 1
							spontaneous_explosion(loc, active_game.PvP, -55)
							return
						if(owner == a)
							found 			= 1
							origin.can_use 	= 1
							GC()
						else if(a.density)
							if(!end_step) end_step = 1
							else switch(get_general_dir(src, owner))
								if(WEST) step_x -= step_size
								if(EAST) step_x += step_size
								if(NORTH)step_y += step_size
								if(SOUTH)step_y -= step_size
			smoker_g
				icon_state	= "smoker-g"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 0

				hp_modifier	= -5
				penetration	= 0
				px_range	= 64
				accuracy	= 25	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5

				GC()
					end_step	= 0
					density		= 1
					icon_state	= initial(icon_state)
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range || end_step) // if the projectile has taken its maximum amount of steps..
						density	= 0
						. = 0
						sleep 15
						for(var/i = 10, i > 0, i--)
							greensmoke()
							sleep world.tick_lag*2

					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if((step_size*total_steps) < (px_range/2))
								if(dir == EAST || dir == WEST) pixel_y += 1
								animate(src, transform = transform*1.1, alpha = alpha-10, time = 1)
							else
								if(dir == EAST || dir == WEST) pixel_y -= 1
								animate(src, transform = transform/1.1, alpha = alpha+10, time = 1)
							step(src, dir)
							sleep world.tick_lag
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step 	= 1
						animate(src, transform = matrix(), alpha = 255, time = 2)


			grenade
				icon_state	= "grenade"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 1

				hp_modifier	= -5
				penetration	= 0
				px_range	= 64
				accuracy	= 25	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5

				GC()
					end_step	= 0
					density		= 1
					icon_state	= initial(icon_state)
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range || end_step) // if the projectile has taken its maximum amount of steps..
						density	= 0
						. = 0
						if((istype(src,/obj/projectile/thrown/grenade/sticky_grenade) || istype(src,/obj/projectile/thrown/grenade/sticky_bomb)) && end_step)
							var/obj/projectile/thrown/grenade/s = src
							var/atom/a = s:stuck
							a.overlays += src
							loc = locate(0,0,0)
							sleep(15)
							if(a) a.overlays -= src
							if(a && a.loc) loc = a.loc
						else sleep 15
						if(istype(src, /obj/projectile/thrown/grenade/sticky_bomb))
							. = 1 // green smoke!
						if(istype(src, /obj/projectile/thrown/grenade/gravity_grenade))
							world << "Gravity!!!!!"
							gravity(loc, 64, owner)
							GC()
						else
							Explode(42, -50, owner,, .)
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if((step_size*total_steps) < (px_range/2))
								if(dir == EAST || dir == WEST) pixel_y += 1
								animate(src, transform = transform*1.1, alpha = alpha-10, time = 1)
							else
								if(dir == EAST || dir == WEST) pixel_y -= 1
								animate(src, transform = transform/1.1, alpha = alpha+10, time = 1)
							step(src, dir)
							sleep world.tick_lag
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step 	= 1
						animate(src, transform = matrix(), alpha = 255, time = 2)
				sticky_grenade
					icon 		= '_Bullets.dmi'
					icon_state	= "sticky_grenade"
					accuracy 	= 20
					px_range 	= 50
					var
						atom/movable/stuck
						tick = 15
					Bump(atom/a)
						if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
							loc = get_step(src, dir)
							return
						if(a.density)
							stuck = a
							end_step = 1
							animate(src, transform = matrix(), alpha = 255, time = 2)
				gravity_grenade
					icon 		= 'projectiles.dmi'
					icon_state	= "gravade"
					accuracy 	= 20
					px_range 	= 70
					var
						tick = 15
					Bump(atom/a)
						if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
							loc = get_step(src, dir)
							return
						if(a.density)
							end_step = 1
				sticky_bomb
					icon		= 'projectiles.dmi'
					icon_state	= "stickybomb"
					accuracy 	= 20
					px_range 	= 80
					var
						atom/movable/stuck
						tick = 20
					Bump(atom/a)
						if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
							loc = get_step(src, dir)
							return
						if(a.density)
							stuck = a
							end_step = 1
							animate(src, transform = matrix(), alpha = 255, time = 2)
			molotov
				icon_state	= "molotov"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 0

				hp_modifier	= -5
				penetration	= 0
				px_range	= 75
				accuracy	= 15	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5

				GC()
					end_step = 0
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						drop_fire(6, owner)
						GC()
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if((step_size*total_steps) < (px_range/2))
								if(dir == EAST || dir == WEST) pixel_y += 1
								animate(src, transform = transform*1.1, alpha = alpha-10, time = 1)
							else
								if(dir == EAST || dir == WEST) pixel_y -= 1
								animate(src, transform = transform/1.1, alpha = alpha+10, time = 1)
							step(src, dir)
							sleep world.tick_lag
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1
						animate(src, transform = matrix(), alpha = 255, time = 2)
					drop_fire(6, owner, 150)
					GC()


			airstrike
				icon_state	= "airstrike"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4

				hp_modifier	= -5
				penetration	= 0
				px_range	= 64
				accuracy	= 8	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.5
				var
					atom/movable/stuck
					tick = 20
				New()
					..()
					draw_spotlight(x_os = -38, y_os = -38, hex = "#FFCC00")
				GC()
					end_step = 0
					stuck = null
					alpha = 255
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range || end_step) // if the projectile has taken its maximum amount of steps..
						var/atom/a = stuck
						density = 0
						if(a)
							a.overlays += src
							loc = locate(0,0,0)
							sleep(15)
							if(a) a.overlays -= src
							if(a && a.loc) loc = a.loc
						else sleep(15)
						alpha = 0
						airstrike((a ? a.loc : loc), owner)
						spawndel(5)
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if((step_size*total_steps) < (px_range/2))
								if(dir == EAST || dir == WEST) pixel_y += 1
								animate(src, transform = transform*1.1, alpha = alpha-10, time = 1)
							else
								if(dir == EAST || dir == WEST) pixel_y -= 1
								animate(src, transform = transform/1.1, alpha = alpha+10, time = 1)
							step(src, dir)
							sleep world.tick_lag
					timeout = 0

				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						stuck = a
						end_step = 1
						animate(src, transform = matrix(), alpha = 255, time = 2)

			portal
				icon_state	= "portalbeam"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4
				is_explosive= 0

				hp_modifier	= -2
				penetration	= 0
				px_range	= 60
				accuracy	= 25	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 0.7

				GC()
					end_step 	= 0
					color		= null
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range) // if the projectile has taken its maximum amount of steps..
						draw_portal(loc, (owner ? owner:namecolor : ), 60, owner)
						GC()
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							step(src, dir)
							trail(dir, color)
							sleep world.tick_lag
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1
					draw_portal(loc, (owner ? owner:namecolor : ), 60, owner)
					GC()

				trail(_dir = null, _color)
					var/obj/o = new/obj
					o.SetCenter(Cx(),Cy(),z)
					o.icon = 'projectiles.dmi';o.icon_state = "[icon_state]-trail[rand(1,4)]";o.plane = 2;o.layer = EFFECTS_LAYER-1;o.dir = _dir;o.color = _color
					animate(o, alpha=0, transform = (turn(transform, rand(180,-180)))/2, time=5)
					o.spawndel(5)

////////////////////////////////





			glowstick
				icon_state	= "glowstick"
				bound_x		= 2
				bound_y		= 2
				bound_width	= 4
				bound_height= 4

				hp_modifier	= 0
				penetration	= 0
				px_range	= 64
				accuracy	= 4	// every [accuracy] pixels, the projectile will stray 1px off from true center.
				kb_dist		= 0
				velocity	= 1
				New()
					..()
					color = pick("#0096D6","#008080","#FF7373","#00FF00","#FF00FF")
					draw_spotlight(x_os = -38, y_os = -38, hex = color)
				GC()
					end_step = 0
					..()

				take_step()
					/*
						called to handle the projectile's step behavior.
					*/
					set waitfor = 0
					timeout = 1
					if(step_size*total_steps >= px_range || end_step) // if the projectile has taken its maximum amount of steps..
						density	= 0
						spawndel(150)
					else
						if(loc)
							total_steps ++
							if(round((step_size*total_steps)/accuracy) > accur_assist) // accur_Assist is always the sum of the total pixels traveled divided by accuracy.
								accur_assist = round((step_size*total_steps)/accuracy)
								if(dir == EAST || dir == WEST) step_y += sway
								else step_x += sway
							if((step_size*total_steps) < (px_range/2))
								if(dir == EAST || dir == WEST) pixel_y += 1
								animate(src, transform = transform*1.1, alpha = alpha-10, time = 1)
							else
								if(dir == EAST || dir == WEST) pixel_y -= 1
								animate(src, transform = transform/1.1, alpha = alpha+10, time = 1)
							step(src, dir)
							sleep world.tick_lag
					timeout = 0
				Bump(atom/a)
					if(istype(a, /obj/projectile) || a.d_ignore || owner == a)
						loc = get_step(src, dir)
						return
					if(a.density)
						end_step = 1
						animate(src, transform = matrix(), alpha = 255, time = 2)
