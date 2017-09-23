
		/*
				Yvel is a simple, but dangerous boss that can be pretty scary to combat.

		phase 1:
				Yvel will first appear as a little eye on a stalk on the map somewhere cannot harm the players at all and will be killed with any hit.
			find and kill the stalk six times and phase 2 will start.

			**upon death, the stalks will create red smoke.**

		phase 2:
				upon killing the final stalk in phase 1, six pillars of spinning shadows will shoot up from the ground around the death location and all
			nearby player screens will shake when near these pillars. The pillars cannot be damaged and will do massive damage and knockback if touched.
			each of the pillars will always have a stalk that will spawn nearby them when a player is close and try to spawn under them to do damage and knockback.
			if the stalk misses(which is easy if you keep moving) it will have a brief stun where you can shoot it to kill it and destroy it's appropriate pillar

			once all the pillars are destroyed, phase 3 will begin.

		phase 3:
				upon killing the last pillar, Yvel will spawn once more but this time as a humanoid with a unique skin and apparal that will fight like a normal
			human enemy with a large health pool. Kill Yvel once more and the boss will be defeated.

			Yvel does have a special ability; portalcasting. Players will eventually also have this ability by default but this will be the first enemy to also
			have this power. Yvel will always keep a minimum distance from the player and attack from a distance and if the player gets too close, will portal
			away, and players will have a brief window to jump into the portal to persue him. If players don't make it, Yvel will do a teleport ambush attack.
		*/



/*		first the match handling bits..
*/




/* 		now the ai bits..
*/

		Yvel
			icon			= 'enemies/yvel.dmi'
			icon_state		= "yvel-"
			density			= 1
			step_size		= 4
			base_health		= 5000
			can_censor		= 0
			appearance_flags= KEEP_TOGETHER
			is_garbage		= 1
			plane			= 0
			explosion_proof	= 1
			has_spotlight	= 1
			lock_step		= 1
			kill_score		= 30
			var/obj/weapon/gun/skill1 	//	= new /obj/weapon/gun/pistol
			var/obj/weapon/special/skill2// 	= new /obj/weapon/special/molotov
			var/obj/weapon/special/skill3//	= new /obj/weapon/special/dopple
			var/tmp
				obj/arms 	= new /obj/player/arms
				obj/shirt	= new /obj/player/shirt
				obj/pants	= new /obj/player/pants
				obj/hair 	= new /obj/player/hair
				obj/vanity	= new /obj/player/vanity

			New()
				..()
				draw_nametag("<font color=red>Doppelganger", 16) //,, -44)
				draw_health(-5, 32)
				arms.icon_state = "base-pistol"
				overlays += arms
				overlays += shirt
				overlays += pants
				overlays += hair
				overlays += vanity
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
					step(src, dir)
					if(prob(25))
						gs('doppel.ogg')
						spontaneous_explosion(loc, 0)
						dir = turn(dir,pick(-45,45))
					sleep world.tick_lag*1.5
				animate(src, pixel_x = -2, dir = WEST, time = 1, loop = 5, easing = ELASTIC_EASING)
				animate(pixel_x = 2, dir = EAST, time = 1, easing = ELASTIC_EASING)
				sleep 10
				spontaneous_explosion(loc, 0)
				var/obj/item/gun/red_baron/h = garbage.Grab(pick( /obj/item/revive_pack, /obj/item/gun/red_baron, /obj/item/shield_tier3))
				h.loc 	= loc
				alpha 	= 0
				density = 0
				sleep 10
				if(.)	// if it's the last doppel killed during a doppel boss fight.
					for(var/mob/player/c in active_game.participants+active_game.spectators)
						c.client.eye = c
					active_game.end_doppel()
				GC() // untargeting hostiles is handled by the parent GC() which gets called via ..()

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init && active_game.started == 2)
					resting = 1
					if(prob(3)) gs('doppel.ogg')
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
										skill3.use(src)
							if(bounds_dist(src, target) <= 2)	// if super close, melee attack.
								gs('doppel.ogg')
								target.knockback(8, step_dir)
								target.edit_health(-10)
								sleep 10

							else if(get_dist(src, target) < 6 && skill1.can_use && shot_lineup())
								dir = get_general_dir(src, target)
								skill1.use(src)
								sleep 2
							else if(get_dist(src, target) < 4 && skill2.can_use && shot_lineup() && prob(45))
								dir = get_general_dir(src, target)
								skill2.use(src)
							else if(!kb_init)
								step(src, step_dir)
							if(health <= (base_health/2) && prob(1))
								smoke()
								smoke()
								smoke()
								animate(src, alpha = 0, time = 3, loop = 1)
								respawn()
								animate(src, alpha = 255, time = 3, loop = 1)

					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/p in (active_game.participants+support_ai))
							if(!p.health || !p.loc) continue
							if(!target)
								target = p
								skill3.use(src)
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
								skill3.use(src)
					sleep world.tick_lag*1.5
					resting = 0
