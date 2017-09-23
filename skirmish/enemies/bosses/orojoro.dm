
		/*
				The Doppelganger is a simple boss that is best enjoyed in a multiplayer game with multiple players.

			Doppelgangers' main gimmick is their ability to mimic the appearance and loadout of whoever they're targeting. Any weapon players have/can use,
			so can the Doppels. Multiple Doppels will also spawn in if there are multiple players. ***(formula is: round((active_game.participants.len)/1.5)  )***

				phase one will just attack the nearest player and keep charging at them.
				phase two is the same pattern, but will now sometimes teleport and attack from a different direction or attack a different player on the map altogether.
		*/


/*		first the match handling bits..
*/
game
	proc


		boss_orojoro()
			set waitfor = 0
			change_song('audio/music/doppeltheme-game.ogg')
			for(var/mob/player/p in active_game.participants)
				p.fx_waveStart(1)
			sleep 10
			var/mob/npc/hostile/orojoro/boss = garbage.Grab(/mob/npc/hostile/orojoro)
			boss.can_hit	= 1
			boss.step_size	= 4
			boss.health		= boss.base_health
			boss.loc		= pick(enemy_spawns)
			boss.level 		= active_game.current_round
			ai_list += boss
			sleep world.tick_lag
			world_sound('audio/sounds/voice_wave_begin.ogg')
		//	world_sound('audio/sounds/doppel.ogg')


		end_orojoro()
			if(!intermission && started == 2)
				intermission = 1
				sleep 35
				world_sound('audio/sounds/voice_wave_complete.ogg')
				current_round ++
				sleep 5// revive dead players, etc.
				for(var/mob/player/p in participants)
					p.fx_waveEnd()
					if(p.health && (p.health < p.base_health/2))
						p.health = round(p.base_health/2)
						p.shield(3)
						p.give_exp(50)
						p.give_points(50)
					if(!p.health) spawn_pl(p)
				sleep 15
				boss_mode 	= 0
				init_wave()



/*			now for orojoro's ai and behavior stuff.
*/

obj
	weapon
		special
			firefury
				recharge = 10

				use(mob/m)
					can_use 				= 0
					. 						= m.dir
					for(var/i = 1 to 8) // all 8 dirs!
						var/obj/projectile/p1	= get_projectile("fireball", i , -10, 1.5, 0, 123, 100, 2, 1)
						var/obj/projectile/p2	= get_projectile("fireball", i , -10, 1.5, 0, 123, 10, 2, 1)
						var/obj/projectile/p3 	= get_projectile("fireball", i , -10, 1.5, 0, 123, 10, 2, -1)

						m.gs('fireball.ogg')
						switch(i)
							if(NORTH)
								p1.SetLoc(m.loc,m.step_x,m.step_y+16)
								p2.SetLoc(m.loc,m.step_x,m.step_y+16)
								p3.SetLoc(m.loc,m.step_x,m.step_y+16)
							if(NORTHEAST)
								p1.SetLoc(m.loc,m.step_x+16,m.step_y+16)
								p2.SetLoc(m.loc,m.step_x+16,m.step_y+16)
								p3.SetLoc(m.loc,m.step_x+16,m.step_y+16)
							if(NORTHWEST)
								p1.SetLoc(m.loc,m.step_x-8,m.step_y+16)
								p2.SetLoc(m.loc,m.step_x-8,m.step_y+16)
								p3.SetLoc(m.loc,m.step_x-8,m.step_y+16)
							if(SOUTHEAST)
								p1.SetLoc(m.loc,m.step_x+16,m.step_y-6)
								p2.SetLoc(m.loc,m.step_x+16,m.step_y-6)
								p3.SetLoc(m.loc,m.step_x+16,m.step_y-6)
							if(SOUTHWEST)
								p1.SetLoc(m.loc,m.step_x-8,m.step_y-6)
								p2.SetLoc(m.loc,m.step_x-8,m.step_y-6)
								p3.SetLoc(m.loc,m.step_x-8,m.step_y-6)
							if(SOUTH)
								p1.SetLoc(m.loc,m.step_x+6,m.step_y-6)
								p2.SetLoc(m.loc,m.step_x+6,m.step_y-6)
								p3.SetLoc(m.loc,m.step_x+6,m.step_y-6)
							if(EAST)
								p1.SetLoc(m.loc,m.step_x+16,m.step_y+6)
								p2.SetLoc(m.loc,m.step_x+16,m.step_y+6)
								p3.SetLoc(m.loc,m.step_x+16,m.step_y+6)
							if(WEST)
								p1.SetLoc(m.loc,m.step_x-8,m.step_y+6)
								p2.SetLoc(m.loc,m.step_x-8,m.step_y+6)
								p3.SetLoc(m.loc,m.step_x-8,m.step_y+6)
						p1.owner			= m
						p2.owner			= m
						p3.owner			= m
						active_projectiles.Add(p1,p2,p3)

					spawn(recharge)
						can_use 			= 1

mob/npc
	hostile
		var tmp/list/loot_drop
		orojoro
			icon				= 'enemies/orojoro.dmi'
			icon_state			= "orojoro-"	// basically just a crawler, but gonna be super big
			density				= 1
			step_size			= 2
			base_health			= 2000
			can_censor			= 0
			appearance_flags	= KEEP_TOGETHER | PIXEL_SCALE
			is_garbage			= 1
			plane				= 0
			explosion_proof		= 0
			has_spotlight		= 1
			lock_step			= 1
			kill_score			= 50
			loot_drop 			= list(/obj/item/revive_pack, /obj/item/gun/red_baron, /obj/item/shield_tier3)

			var tmp
				obj/weapon
					gun/skill1 		= new /obj/weapon/special/shadowball
					special
						skill2 		= new /obj/weapon/special/fireblast
						skill3		= new /obj/weapon/special/firefury
				form

			proc
				change_form(_form)
					form = _form
					var num = 16 * form
					if(form == 1)
						animate(src,transform = matrix(0.8,MATRIX_SCALE),time = num * world.tick_lag)
						bounds_scale(0.9)
						form++
					else if(form == 2)
						animate(src,transform = matrix(0.6,MATRIX_SCALE),time = num * world.tick_lag)
						bounds_scale(0.7)
						form++
					for(var/i = 1 to num)
						fadetrail(30)
						dust()
		//				smoke()
						smoke()
						step(src, turn(dir,45), step_size+form+2)
						sleep world.tick_lag

			New()
				..()
				draw_nametag("<font color=red>Orojoro",level) //,, -44)
				draw_health(-5, 32)

			GC()
				alpha	= 255
				target	= null
				..()

			death()
				ai_list -= src
				if(ai_list.len == 0 && active_game.boss_mode)
					/* this little bit should only run if this is the last Doppel killed during a doppel boss fight.
						It makes other players spectate the doppel as it dies as a mini cutscene.
					*/
					. = 1
					for(var/mob/player/c in active_game.participants+active_game.spectators)
						c.client.eye = src

				layer = EFFECTS_LAYER+2
				for(var/i = 1 to 35)
					step(src, turn(dir,45), step_size+form+2)
					fadetrail(30)
					if(prob(30)) transform = matrix(45,MATRIX_ROTATE)
					sleep world.tick_lag * 1.5
				animate(src, pixel_x = -2, dir = WEST, time = 1, loop = 5, easing = ELASTIC_EASING)
				animate(pixel_x = 2, dir = EAST, time = 1, easing = ELASTIC_EASING)
				sleep 10
				animate(src,transform = matrix(),time = 15)
				spontaneous_explosion(loc, 0)
				var/obj/item/h = garbage.Grab(pick(loot_drop))
				h.SetCenter(src)
				alpha 	= 0
				density = 0
				sleep 10
				if(.)	// if it's the last doppel killed during a doppel boss fight.
					for(var/mob/player/c in active_game.participants+active_game.spectators)
						c.client.eye = c
					active_game.end_orojoro()
				if(!active_game.boss_mode && active_game.enemies_left) active_game.enemies_left --;active_game.progress_check()
				GC() // untargeting hostiles is handled by the parent GC() which gets called via ..()


			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init && active_game.started == 2)
					resting = 1
					if(prob(3)) gs('doppel.ogg')
					if(!form && health <= (base_health/1.5)) change_form(1)
					else if(form == 1 && health <= (base_health/2.5)) change_form(2)
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 15 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p

							if(bounds_dist(src, target) <= 2)	// if super close, melee attack.
								gs('doppel.ogg')
								target.knockback(16, step_dir)
								target.edit_health(-10)
								target.burn(,1)
								sleep 15

							else if(get_dist(src, target) < 6 && skill1.can_use && shot_lineup())
								icon_state = "orojoro-attack"
								dir = step_dir
								skill1.use(src)
								icon_state = "orojoro-"
								sleep 2
							else if(get_dist(src, target) < 4 && skill2.can_use && shot_lineup() && prob(35))
								icon_state = "orojoro-attack"
								dir = step_dir
								skill2.use(src)
								icon_state = "orojoro-"
							else if(!kb_init)
								step(src, step_dir)

							if(prob(10)||form == 1 && prob(20)||form == 2 && prob(30))
								for(var/i = 1 to 3)
									fadetrail(40)
									dust()
	//								smoke()
									step(src, get_general_dir(src,target), step_size+form+2)

							if(prob(5)||form == 1 && prob(20)||form == 2 && prob(50))
								animate(src, alpha = 0, time = 3, loop = 1)
								var/turf/junkloc = get_step(target, step_dir)
								if(!junkloc || junkloc.density) respawn()
								else
									if(prob((form + 1) * 25))
										var turf/trick_loc = get_step(target,turn(step_dir,180))
										if(trick_loc && !trick_loc.density)
											var obj/oro_dummy/dummy = garbage.Grab(/obj/oro_dummy)
											dummy.position(trick_loc,icon)
									loc = junkloc
									animate(src, alpha = 255, time = 3, loop = 1)
									icon_state = "orojoro-attack"
									if(bounds_dist(src, target) <= 2)	// if super close, melee attack.
										gs('doppel.ogg')
										target.knockback(16, step_dir)
										target.edit_health(-10)
										target.burn(,1)
									sleep 10
									icon_state = "orojoro-"
							if(prob(5) && form == 1 && skill3.can_use||prob(25) && form == 2 && skill3.can_use)
								icon_state = "orojoro-attack"
								skill3.use(src)
								sleep 8
								icon_state = "orojoro-"

					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/p in (active_game.participants+support_ai))
							if(!p.health || !p.loc) continue
							if(!target)
								target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*1.5
					resting = 0


obj/oro_dummy
	is_garbage = 1
	density = 0
	alpha = 200
	proc/position(_loc,_icon)
		spawn
			loc = _loc
			icon = _icon
			icon_state = "orojoro-attack"
			sleep 20
			GC()