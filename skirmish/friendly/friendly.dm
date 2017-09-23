/*
			SUPPORT AI ARE TO REMAIN DISABLED UNTIL THEY CAN BE PROPERLY INTEGRATED IN THE FUTURE.
		*/

var
	tmp
		list/support_ai	= new /list()
		list/res_ai		= new /list()

proc


	ressurect_ai()
		set waitfor = 0
		if(res_ai.len) for(var/mob/npc/support/m in res_ai)
			m.health		= m.base_health
			m.transform		= matrix()
			m.density 		= 1
			m.loc			= pick(active_game.player_spawns)
			m.move_disabled = 0
			m.alpha			= 255
			m.alive			= 1
			m.can_hit		= 1
			support_ai += m
			res_ai -= m
			world << ">> [m] was revived!"


mob
	var
		can_dopple	= 0	// 1 if the mob can be doppled by a doppleganger(requires hair, shirt, vanity, pants)
		tmp/pvp_on	= 0
	npc
		support
			explosion_proof	= 1
			is_garbage		= 1
			var/tmp
				obj/arms 			= new /obj/player/arms
				obj/shirt			= new /obj/player/shirt
				obj/pants			= new /obj/player/pants
				obj/hair 			= new /obj/player/hair
				obj/vanity			= new /obj/player/vanity
				obj/face			= new /obj/player/face
				mob/last_attacker
				mob/closest_friend
				turf/last_loc
				same_loc_steps		 // how many times the mob has been stuck in the same tile.
				res_on_die		= 0	// 1 if the npc should revive after dying.
				alive			= 0
				namecolor		= "#FFFFFF"
				awareness		= 55 // how likely the npc will check its surroundings. High probability will make the npc more aware of it's surroundings.
				target_range	= 15
				pushing			= 0
			New()
				..()
				if(has_spotlight) draw_spotlight(x_os = -30, y_os = -38, hex = "#FFFFFF")
			Bump(atom/a)
				..()
				if(kb_init)
					kb_init = 0
					if(istype(a, /mob/player) || istype(a, /mob/npc))
						a:knockback(12, get_dir(src, a))
					if(istype(a, /obj/barricade/crate))
						var/obj/barricade/crate/c = a
						c.Break()
				if(istype(a, /obj/barricade) && !a:broken && !pushing)
					pushing 				= 1
					var/obj/barricade/b 	= a
					b.last_pusher 			= src
					var/tmp/list/push_group	= new/list()
					push_group += b
					. = b
					top
					if(push_group.len < 3) for(var/obj/barricade/c in bounds(., 1))
						if(get_dir(.,c) == dir)
							c.last_pusher = src
							push_group += c
							. = c
							goto top
					if(push_group.len > 1)
						while(push_group.len)
							var/obj/barricade/d = push_group[push_group.len]
							if(step(d, dir)) spawn d.dust()
							push_group.Remove(d)
					else if(step(b, dir)) spawn b.dust()
					pushing = 0
				if(ismob(a) && !active_game.intermission)
					a:knockback(8, get_dir(src, a))
					if(on_fire) a:burn()
				if(!ig_bump && (closest_friend || target) && world.cpu < 45)
					ig_bump = 1
					if(target) step_to(src, target, 0,0)
					else if(closest_friend) step_to(src, closest_friend, 0,0)
					ig_bump = 0
				else sleep 10;dir = rand(1,8)
			GC()
				last_attacker	= null
				closest_friend	= null
				last_loc		= null
				health			= base_health
				transform		= matrix()
				density 		= 1
				move_disabled 	= 0
				..()

			death()
				if(alive)
					alive = 0
					support_ai -= src
					world 						<< "<b><font color = [namecolor]>[src]</font> died! ([kills] kills)"
					active_game.participants 	<< output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
					active_game.spectators 		<< output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
					density = 0
					death_animation()
					sleep 5
					remove_spectators()
					if(censored)	censor(1)
					loc				= null
					move_disabled 	= 1
					alpha			= 0
					if(res_on_die) // if the npc is set to be revived or if it should fuck off after dying.
						res_ai += src
					else
						GC()
					active_game.progress_check()



			///////////  ai for support npcs should be fairly complicated. i want them to be able to recognize their surroundings and react to potential explosives, traps, afire, etc.
			//////////////	different npcs will of course have different weapons and loadouts and behaviors. Some npcs will be more prone to hanging around
			//////////////	the acctive players and providing assising cover while others moreso just go about and attack every enemy it can.
			//////////////	some support npcs should be better and worse than others beit through poor ai behavcior pattersns or loadout types. This will
			//////////////	promote variety in reliability of npcs to know when one will be more helpful for reaching later waved.
			//////////////
			//////////////	some support npcs will also join randomly during some waves while others will need to be defended to survive/pass the wave.


			gun_vendor
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 2
				base_health		= 50000
				health			= 50000
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				can_dopple		= 0
				fireproof		= 1
				awareness		= 95
				target_range	= 20
				can_hit			= 0
				can_kb			= 0
				move_disabled 	= 0
				var/tmp
					vendor_type	= "gun"
					last_step	= 0
				New()
					..()
					switch(pick("Haze","Haze"))
						if("Haze")
							draw_nametag("\[SHOP] Haze")
							draw_health(-5, 32)
							arms.icon_state 	= "base-flamethrower"
							shirt.icon_state	= "shirt16"
							hair.icon_state		= "style20"
							vanity.icon_state	= "vanity9"
							pants.icon_state	= "pants1"
							face.icon_state		= "face5"
							hair.pixel_y += 1	// just to see what it looks like. delete later!	<-- famous last words
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity
					overlays += face

				ai_check()
					set waitfor = 0
					resting = 1
					if(last_step || (!move_disabled && prob(1)))
						. = 1
						if(last_step) last_step --
						else last_step = pick(5,10) // can step 5 or ten times in a row when walking before idling again.
						step(src, dir)
					else sleep 45
					if(!. && prob(18)) dir = turn(pick(-45,45,-90,90), dir)
					sleep world.tick_lag*1.8
					resting = 0

			face_vendor
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 2
				base_health		= 500000
				health			= 500000
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				can_dopple		= 0
				fireproof		= 1
				awareness		= 95
				target_range	= 20
				can_hit			= 0
				can_kb			= 0
				move_disabled 	= 0
				var/tmp
					vendor_type	= "face"
					last_step	= 0
				New()
					..()
					switch(pick("Poe","Poe"))
						if("Poe")
							draw_nametag("\[SHOP] Poe", 6)
							draw_health(-5, 32)
							arms.icon_state 	= "base-"
							shirt.icon_state	= "shirt5"
							hair.icon_state		= "style8"
							vanity.icon_state	= "vanity12"
							pants.icon_state	= "pants3"
							face.icon_state		= "face3"
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity
					overlays += face
				ai_check()
					set waitfor = 0
					resting = 1
					if(last_step || (!move_disabled && prob(1)))
						. = 1
						if(last_step) last_step --
						else last_step = pick(5,10) // can step 5 or ten times in a row when walking before idling again.
						step(src, dir)
					else sleep 45
					if(!. && prob(18)) dir = turn(pick(-45,45,-90,90), dir)
					sleep world.tick_lag*1.8
					resting = 0

			hair_vendor
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 2
				base_health		= 50000
				health			= 50000
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				can_dopple		= 0
				fireproof		= 1
				awareness		= 95
				target_range	= 20
				can_hit			= 0
				can_kb			= 0
				move_disabled 	= 0
				var/tmp
					vendor_type	= "hair"
					last_step	= 0
				New()
					..()
					switch(pick("Winston","Winston"))
						if("Winston")
							draw_nametag("\[SHOP] Winston")
							draw_health(-5, 32)
							arms.icon_state 	= "base-shotgun"
							shirt.icon_state	= "shirt5"
							hair.icon_state		= "style26"
							vanity.icon_state	= "vanity4"
							pants.icon_state	= "pants1"
							face.icon_state		= "face6"
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity
					overlays += face
				ai_check()
					set waitfor = 0
					resting = 1
					if(last_step || (!move_disabled && prob(1)))
						. = 1
						if(last_step) last_step --
						else last_step = pick(5,10) // can step 5 or ten times in a row when walking before idling again.
						step(src, dir)
					else sleep 45
					if(!. && prob(18)) dir = turn(pick(-45,45,-90,90), dir)
					sleep world.tick_lag*1.8
					resting = 0
			special_vendor
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 2
				base_health		= 50000
				health			= 50000
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				can_dopple		= 0
				fireproof		= 1
				awareness		= 95
				target_range	= 20
				can_hit			= 0
				can_kb			= 0
				move_disabled 	= 0
				var/tmp
					vendor_type	= "special"
					last_step	= 0
				New()
					..()
					switch(pick("Tank","Tank"))
						if("Tank")
							draw_nametag("\[SHOP] Tank")
							draw_health(-5, 32)
							arms.icon_state 	= "base-shotgun"
							shirt.icon_state	= "shirt4"
							hair.icon_state		= "style26"
							vanity.icon_state	= "vanity3"
							pants.icon_state	= "pants2"
							face.icon_state		= "face2"
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity
					overlays += face
				ai_check()
					set waitfor = 0
					resting = 1
					if(last_step || (!move_disabled && prob(1)))
						. = 1
						if(last_step) last_step --
						else last_step = pick(5,10) // can step 5 or ten times in a row when walking before idling again.
						step(src, dir)
					else sleep 45
					if(!. && prob(18)) dir = turn(pick(-45,45,-90,90), dir)
					sleep world.tick_lag*1.8
					resting = 0
			vanity_vendor
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 2
				base_health		= 50000
				health			= 50000
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				can_dopple		= 0
				fireproof		= 1
				awareness		= 95
				target_range	= 20
				can_hit			= 0
				can_kb			= 0
				move_disabled 	= 0
				var/tmp
					vendor_type	= "vanity"
					last_step	= 0
				New()
					..()
					switch(pick("Luna","Luna"))
						if("Luna")
							draw_nametag("\[SHOP] Luna", 15)
							draw_health(-5, 32)
							arms.icon_state 	= "base-uzi"
							shirt.icon_state	= "shirt10"
							hair.icon_state		= "style24"
							vanity.icon_state	= "vanity6"
							pants.icon_state	= "pants1"
							face.icon_state		= "face8"
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity
					overlays += face
				ai_check()
					set waitfor = 0
					resting = 1
					if(last_step || (!move_disabled && prob(1)))
						. = 1
						if(last_step) last_step --
						else last_step = pick(5,10) // can step 5 or ten times in a row when walking before idling again.
						step(src, dir)
					else sleep 45
					if(!. && prob(18)) dir = turn(pick(-45,45,-90,90), dir)
					sleep world.tick_lag*1.8
					resting = 0
			shirt_vendor
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 2
				base_health		= 50000
				health			= 50000
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				can_dopple		= 0
				fireproof		= 1
				awareness		= 95
				target_range	= 20
				can_hit			= 0
				can_kb			= 0
				move_disabled 	= 0
				var/tmp
					vendor_type	= "shirt"
					last_step	= 0
				New()
					..()
					switch(pick("Al","Al"))
						if("Al")
							draw_nametag("\[SHOP] Al", 15)
							draw_health(-5, 32)
							arms.icon_state 	= "base-redbaron"
							shirt.icon_state	= "shirt15"
							hair.icon_state		= "style19"
							vanity.icon_state	= "vanity6"
							pants.icon_state	= "pants2"
							face.icon_state		= ""
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity
					overlays += face
				ai_check()
					set waitfor = 0
					resting = 1
					if(last_step || (!move_disabled && prob(1)))
						. = 1
						if(last_step) last_step --
						else last_step = pick(5,10) // can step 5 or ten times in a row when walking before idling again.
						step(src, dir)
					else sleep 45
					if(!. && prob(18)) dir = turn(pick(-45,45,-90,90), dir)
					sleep world.tick_lag*1.8
					resting = 0

















			kett		// there will be different support npcs with their own appearance/loadout/ai and each game will spawn with a randomly chosen one.
				icon			= 'friendly/kett.dmi'
				icon_state		= "kett-"
				density			= 1
				step_size		= 4
				base_health		= 260
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 1
				plane			= 0
				pvp_on			= 0
				level			= 18
				can_dopple		= 1

				awareness		= 20
				target_range	= 64
				var/loop_track	= 0
				var/obj/weapon/gun/skill1 		= new /obj/weapon/gun/uzi
				var/obj/weapon/special/skill2 	= new /obj/weapon/special/airstrike
				var/obj/weapon/special/skill3	= new /obj/weapon/special/glowsticks

				New()
					..()
					draw_nametag("Kett", level) //,, -44)
					draw_health(-5, 32)
					arms.icon_state 	= "base-uzi"
					shirt.icon_state	= "shirt10"
					hair.icon_state		= "style18"
					vanity.icon_state	= "vanity8"
					pants.icon_state	= "pants1"
					overlays += arms
					overlays += shirt
					overlays += pants
					overlays += hair
					overlays += vanity


				ai_check()
					set waitfor = 0
					if(alive && !resting && !kb_init)
						resting = 1
						loop_track ++
						if(loop_track == awareness) // check surroundings every [awareness] loops.
							loop_track = 0	// reset the loop tracker.
							// first let's check for enemies..
							if(target)	// if kett already has a target..
								var/targ_dist = bounds_dist(src, target)
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc || h == target) continue
									if(bounds_dist(src, h) <= targ_dist) // if there's a closer enemy than the target, target the closer one.
										target = h

							else // if kett does not have a target..
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc) continue
									if(bounds_dist(src, h) <= target_range)	// checks for a target within range(in pixels).
										target = h

							// now we can find the closest friendly player.
							for(var/mob/player/p in active_game.participants)
								if(!p.health || !p.loc || p.died_already) continue
								if(closest_friend)
									if(bounds_dist(src, p) < bounds_dist(src, closest_friend))
										closest_friend = p
								else
									closest_friend = p

			/*		the above was for updating kett's awareness and knowledge of the surroundings.
				the below will be for actual behavior programming for kett. Think of these sections as the brain and body of the ai. */

						if(target)
							if(!target.health || !target.loc || bounds_dist(src, target) > target_range)
								target = null
							else
								var/targ_dist 	= bounds_dist(src, target)
								var/targ_dir	= get_dir(src, target)
							/* if kett still has a target in range, we need to figure out how to engage.
							if super close, we'll want kett to push the enemy away a few steps by simply bumping into them(like players can do).
						if a few tiles away, but still in sight we can shoot at them.
						if still in range, but can't use our gun for some reason, kett will throw a molotov! */
								if(targ_dist <= 8 && prob(20)) // if the target is within 8px away, bump them away!
									if(target.is_giant)
										for(var/i = 1, i < 3, i++)			// if super close, bump enemies away, unless they're a brute, ofc
											step(src, targ_dir)
											sleep world.tick_lag
									else	// if target is a brute, don't bump, just run!
										step_away(src, target)
										sleep world.tick_lag
								if(targ_dist > 4 && targ_dist < 112)
									if(skill1.can_use && prob(55) && shot_lineup())
										dir = get_general_dir(src, target)
										skill1.use(src)

									else if(skill2.can_use && prob(15) && shot_lineup())
										dir = get_dir(src, target)
										skill2.use(src)
										sleep world.tick_lag

								if(targ_dist >= 48)
									if(targ_dist > 80 && prob(15))
										for(var/i = 1 to 4)
											dust()
											step(src, targ_dir, step_size+2)
											sleep world.tick_lag
									else
										step(src, pick(targ_dir, turn(targ_dir,pick(90,-90,-45,45))))
										sleep world.tick_lag
						if(!target)
							step_rand(src)
						if(!active_game.intermission && skill3.can_use && prob(2))
							spawn skill3.use(src)
						sleep world.tick_lag*2
						resting = 0


			blue
				icon			= 'friendly/blue.dmi'
				icon_state		= ""
				name			= "Blue"
				density			= 1
				step_size		= 4
				base_health		= 100
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 0
				plane			= 0
				pvp_on			= 0
				level			= 5

				awareness		= 75
				target_range	= 20
				Bump(atom/a)
					..()
					if(istype(a,/mob/npc/hostile))
						// if we hit a zombie, bite 'em!
						var/mob/m = a
						flick("bite",src)
						m.edit_health(rand(-5,-10),src)
				ai_check()
					set waitfor = 0
					if(alive && !resting && !kb_init)
						resting = 1
						if(prob(awareness)) // if they're highly alert, check for hazards(or targets).
							// first let's check for enemies..
							if(target)	// if steve already has a target..
								var/targ_dist	= get_dist(src, target)
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc || h == target) continue
									if(get_dist(src, h) <= targ_dist)
										target = h
							else // if steve does not have a target..
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc) continue
									if(get_dist(src, h) <= target_range)
										target = h
			//		<-----------------------------------------------------------------------------------
						var/friend_dist = get_dist(src, closest_friend)
						if(target)
							/* let's keep blue simple -- if steve is too far, find him
							if he's closeby, let's chomp some zombies*/
							var/targ_dir	= get_dir(src, target)
							if(friend_dist >= 15)
								step(src, get_dir(src, closest_friend))
								sleep world.tick_lag
							else if(!target.health || !target.loc || get_dist(src, target) > target_range)
								target = null
							else
								step(src, targ_dir)
								sleep world.tick_lag
						if(!target)
							if(closest_friend.health)
								if(friend_dist > 5 && prob(30))
									for(var/i = 1 to 4)
										dust()
										step(src, get_dir(src, closest_friend), step_size+2)
										sleep world.tick_lag
								else if(friend_dist >= 3)
									step_towards(src, closest_friend)
									sleep world.tick_lag
								if(friend_dist <= 2)
									sleep 5
							else
								step_rand(src)
								sleep world.tick_lag
						sleep world.tick_lag*1.5
						resting = 0
			steve
				icon			= 'player/_BaseT.dmi'
				icon_state		= "base-"
				name			= "Steve"
				density			= 1
				step_size		= 4
				base_health		= 100
				can_censor		= 0
				appearance_flags= KEEP_TOGETHER
				is_garbage		= 0
				plane			= 0
				pvp_on			= 0
				level			= 8
				can_dopple		= 1

				awareness		= 55
				target_range	= 20
				var/obj/weapon/gun/skill1 		= new /obj/weapon/gun/krossbow
				var/obj/weapon/special/skill2 	= new /obj/weapon/special/grenade/sticky_grenade

				ai_check()
					set waitfor = 0
					if(alive && !resting && !kb_init)
						resting = 1
						if(prob(awareness)) // if they're highly alert, check for hazards(or targets).
							// first let's check for enemies..
							if(target)	// if kett already has a target..
								var/targ_dist	= bounds_dist(src, target)
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc || h == target) continue
									if(bounds_dist(src, h) <= targ_dist)
										target = h
							else // if kett does not have a target..
								for(var/mob/npc/hostile/h in ai_list)
									if(!h.health || !h.loc) continue
									if(bounds_dist(src, h) <= target_range)
										target = h
							for(var/mob/player/p in active_game.participants)
								if(!p.health || !p.loc || p.died_already) continue
								if(closest_friend)
									if(bounds_dist(src, p) < bounds_dist(src, closest_friend))
										closest_friend = p
								else
									closest_friend = p
			//		<-----------------------------------------------------------------------------------
						if(target)
							if(!target.health || !target.loc || get_dist(src, target) > target_range)
								target = null
							else
								var/targ_dist 	= bounds_dist(src, target)
								var/targ_dir	= get_dir(src, target)
							/* if kett still has a target in range, we need to figure out how to engage.
							if super close, we'll want kett to push the enemy away a few steps by simply bumping into them(like players can do).
						if a few tiles away, but still in sight we can shoot at them.
						if still in range, but can't use our gun for some reason, kett will throw a molotov! */
								if(targ_dist <= 8) // if the target is within 8px away, bump them away!
									if(target.is_giant)
										for(var/i = 1, i < 3, i++)			// if super close, bump enemies away, unless they're a brute, ofc
											step(src, targ_dir)
											sleep world.tick_lag
									step_away(src, target)
									sleep world.tick_lag
								else if(targ_dist < 32) // if target is three tiles or less away, make some room!
									step_away(src, target)
									sleep world.tick_lag
								if(targ_dist > 32 && targ_dist < 112)
									if(skill1.can_use && shot_lineup())
										dir = get_general_dir(src, target)
										skill1.use(src)
										sleep world.tick_lag
									else if(skill2.can_use && prob(15) && shot_lineup())
										dir = get_general_dir(src, target)
										skill2.use(src)
										sleep world.tick_lag
								if(targ_dist > 80)
									if(targ_dist > 160 && prob(35))
										for(var/i = 1 to 4)
											dust()
											step(src, targ_dir, step_size+2)
											sleep world.tick_lag
									else
										step(src, pick(targ_dir, turn(targ_dir,pick(-45,45))))
										sleep world.tick_lag
						if(!target)
							if(closest_friend)
								if(!closest_friend.health || !closest_friend.loc)
									closest_friend = null
								else
									var/friend_dist = bounds_dist(src, closest_friend)
									if(friend_dist > 80 && prob(30))
										for(var/i = 1 to 4)
											dust()
											step(src, get_dir(src, closest_friend), step_size+2)
											sleep world.tick_lag
									else if(friend_dist >= 48)
										step_towards(src, closest_friend)
										sleep world.tick_lag
									if(friend_dist <= 32)
										sleep 5
							else
								step_rand(src)
								sleep world.tick_lag
			// <------------------------------------------------------------------------------------



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