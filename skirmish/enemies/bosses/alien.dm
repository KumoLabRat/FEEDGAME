
mob/npc
	hostile
		alien
			icon				= 'player/_alien.dmi'
			icon_state			= "base-"
			density				= 1
			step_size			= 3
			base_health			= 325
			can_censor			= 1
			appearance_flags	= KEEP_TOGETHER
			is_garbage			= 1
			plane				= 0
			explosion_proof		= 0
			has_spotlight		= 1
			lock_step			= 1
			kill_score			= 10

			var
				obj/weapon/gun/skill1 		= new /obj/weapon/gun/el_verde
				obj/weapon/special/skill2 	= new /obj/weapon/special/smoker_g

				obj/arms 					= new /obj/player/arms
				obj/shirt					= new /obj/player/shirt
				obj/pants					= new /obj/player/pants
				obj/hair 					= new /obj/player/hair
				obj/vanity					= new /obj/player/vanity

			New()
				..()
			//	. = rand(5, 14)
			//	draw_nametag("Alien", .)
				draw_health(-5, 32)
				arms.icon		= 'player/_alien_arms.dmi'
				arms.icon_state = "base-elverde"
				shirt.icon_state= "[pick("shirt9","amelia-shirt")]"
				pants.icon_state= "[pick("pants2","amelia-pants")]"
				if(prob(65))
					hair.icon_state	= "style7"
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
				layer = EFFECTS_LAYER+2
				death_animation()
				spontaneous_explosion(loc, 0)
				GC()
				active_game.progress_check()


			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init && active_game.started == 2)
					resting = 1
					if(prob(1)) gs('doppel.ogg')
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
								sleep 5

							else if(get_dist(src, target) < 8 && skill1.can_use && shot_lineup())
								dir = get_general_dir(src, target)
								skill1.use(src)
								sleep 2
							else if(get_dist(src, target) < 5 && skill2.can_use && shot_lineup() && prob(5))
								dir = get_general_dir(src, target)
								skill2.use(src)
							else if(!kb_init)
								step(src, step_dir)

					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/p in (active_game.participants+support_ai))
							if(!p.health || !p.loc) continue
							if(!target)
								target = p

							else if(get_dist(src, p) < get_dist(src, target))
								target = p

					sleep world.tick_lag*2
					resting = 0
			proc
				flick_arms(fstate = "base-")
					set waitfor = 0
					var/ogstate = arms.icon_state
					overlays -= arms
					arms.icon_state = "[fstate]"
					overlays += arms
					sleep 1
					overlays -= arms
					arms.icon_state = "[ogstate]"
					overlays += arms