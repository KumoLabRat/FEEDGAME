
game
	proc

		boss_trump()
			set waitfor = 0
			change_song('audio/music/doppeltheme-game.ogg')
			for(var/mob/player/p in active_game.participants)
				p.fx_waveStart(1)
			sleep 10
			var/total = round((active_game.participants.len)/1.5)
			if(total <= 0) total = 1
			for(var/i = 0, i < total, i++)
				var/mob/npc/hostile/trump/boss = garbage.Grab(/mob/npc/hostile/trump)
				boss.can_hit	= 1
				boss.step_size	= 6
				boss.health		= boss.base_health
				boss.loc		= pick(player_spawns)
				ai_list += boss
				sleep world.tick_lag
			world_sound('audio/sounds/voice_wave_begin.ogg')


		end_trump()
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
mob/npc
	hostile
		trump
			icon				= 'enemies/_trump.dmi'
			icon_state			= "base-"
			density				= 1
			step_size			= 6
			base_health			= 8000
			can_censor			= 0
			appearance_flags	= KEEP_TOGETHER
			is_garbage			= 1
			plane				= 0
			explosion_proof		= 0
			has_spotlight		= 1
			lock_step			= 1
			kill_score			= 100

			var
				obj/weapon/gun/skill1 		= new /obj/weapon/gun/uzi
				obj/weapon/special/skill2 	= new /obj/weapon/special/airstrike

				obj/arms 					= new /obj/player/arms
				obj/shirt					= new /obj/player/shirt
				obj/pants					= new /obj/player/pants
				obj/hair 					= new /obj/player/hair
				obj/vanity					= new /obj/player/vanity

			New()
				..()
				. = rand(20)
				draw_nametag("Mr.Trump", .)
				draw_health(-5, 32)
				arms.icon_state = "base-uzi"
				shirt.icon_state= "shirt5"
				pants.icon_state= "pants1"
				hair.icon_state	= "trump"
				overlays += arms
				overlays += shirt
				overlays += pants
				overlays += hair
				overlays += vanity
				shield_of_russia()

			GC()
				alpha	= 255
				target	= null
				..()

			death()
				ai_list -= src
				if(ai_list.len == 0 && active_game.boss_mode)
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
				var/obj/item/h = garbage.Grab(pick( /obj/item/revive_pack, /obj/item/gun/red_baron, /obj/item/shield_tier3))
				h.loc 	= loc
				alpha 	= 0
				density = 0
				sleep 10
				if(.)	// if it's the last doppel killed during a doppel boss fight.
					for(var/mob/player/c in active_game.participants+active_game.spectators)
						c.client.eye = c
					active_game.end_trump()
				if(!active_game.boss_mode && active_game.enemies_left) active_game.enemies_left --
				GC() // untargeting hostiles is handled by the parent GC() which gets called via ..()


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
								target.knockback(8, step_dir)
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

					sleep world.tick_lag*1.5
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