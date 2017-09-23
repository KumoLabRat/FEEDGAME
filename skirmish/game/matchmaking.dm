
#define RAIN 1
#define SNOW 2
#define BLOODRAIN 3

var
	game/active_game 	= new /game		// the datum of the current active game.
	list/players		= new /list()	// a list of all the connected players.	(better reference than active_game.participants)


	list
		inv_hair_vendor
		inv_gun_vendor
		inv_shirt_vendor
		inv_vanity_vendor

mob/player
	verb
		vote_to_skip()
			set hidden = 1
			if(winget(src, "pane-lobby.to-skip", "is-checked") == "true")
				active_game.votes_to_skip --
			else
				active_game.votes_to_skip ++


game
	var
		started			= 0	/*
								0 - game has not been initiated and is currently sleeping while waiting for players.
								1 - game is initialized and preparing; connecting players should still be dumped in the lobby but
										should also see a timer and any pre-game lobby stuff.
								2 - game is prepared and active; connecting players should be dropped into the game.
							*/
		interm			= 0		// 1 if an intermission
		current_round	= 1		// the current round.
		last_match_round= 1		// the last wave reached on the last match.
		last_map		= "Limbo"// the name of the last map played.
		exp_multiplier	= 1		// multiply exp gain by this.
		enemies_left	= 1		// how many enemies are currently alive.
		enemies_total	= 1		// how many enemies to be spawned total.
		map_spawnlimit	= 30
		toggle_regen	= 1		// use to toggle health regeneration on/off.
		toggle_revive	= 1		// use to toggle revives on/off.
		votes_to_skip	= 0
		needed_skips	= 0
		intermission	= 0		// 1 if it's an intermission between waves.
		gameover		= 1
		last_five		= 0		// 1 if the last five enemies have been targeted already.
		PvP				= 0		// 1 if the wave is PvP enabled (this effects who can hurt support npcs)
		no_auto_rev		= 0		// 1 if auto reviving should be disabled.
		total_respawning= 0		// how many enemies are respawning rn; limted to 5 at once.
		/*
			vv Unique wave flags. vv
		*/
		phantom_enemies		= 0		// use to toggle alpha'd enemies.
		crawler_only		= 0		// use to make only crawlers spawn.
		abstract_only		= 0		// use to make only abstracts spawn.
		beholder_only		= 0		// use to make only beholders spawn.
		blaze_only			= 0		// use to make only blazes spawn.
		aliens_only			= 0		// use to make only aliens spawn.
		doppel_spawn		= 0		// use to make a doppelganger spawn into the round.

		censorship			= 0		// use to give all mobs censor bars.
		explosive_enemies	= 0		// use to make all enemies explode on death.
		dis_regenerate		= 0		// use to disable health regeneration.
		laser_madness		= 0		// use to make all projectiles lasers.
		nyan_madness		= 0		// use to make all projectiles nyan cats.
		fire_madness		= 0		// use to make all projectiles fire bullets.
		trippy_mane			= 0		// use to make the screen shift between colors.
		blackout			= 0		// use to make the wave super dark.
		boss_mode			= 0
		toggle_weather		= 1		// 1 if its weathering
		weather_type		= BLOODRAIN	// what kind of weather; RAIN, SNOW, BLOODRAIN

		list/participants	= new/list()		// a list of every player that is playing.
		list/spectators		= new/list()		// a list of every player that is spectating.
		list/player_spawns	= new/list()		// a list of all the locs players can spawn on.
		list/enemy_spawns	= new/list()
		list/hazard_spawns	= new/list()		// a list of locs that map hazards can spawn on(i.e. lava).
		list/medcrates		= new/list()		// a list of all the medcrates on the map! (too many lists)
		list/portals		= new/list()		// a list of all the portals on the map.
		list/weather_turfs	= new/list()
		list/spawnlist		= new/list()		// a list of all the enemy types already in the mix of enemies that can be spawned
		list/enemy_list		= list(/mob/npc/hostile/crawler, /mob/npc/hostile/puker, /mob/npc/hostile/shade,  \
								 	/mob/npc/hostile/charger, \
									/mob/npc/hostile/beholder, /mob/npc/hostile/blaze)//, /mob/npc/hostile/alien)///mob/npc/hostile/puppet_master,) // list of all the enemies that can possibly spawn on the map
		list/vendors		= new/list()
		list/vendor_spawns	= new/list()
		list/_paths			= new/list()	// a list of all the path points on the map!
		map/next_map				// this is the map that's currently being chosen to be played.
		mob/top_player
		pause				= 0		// 1 if the game is paused; freezes all global loops.(ai, projectiles)
		timer				= 0		// used for a number of things but notably it makes players have a timer HUD element show up
		combined_level		= 0


	proc
		wait_loop()
			/*
				This procedure runs when nobody is connected to the server and keeps the game suspended in the lobby
					until players connect.
				*/
			set waitfor = 0
			if(started) return
			for()
				if(length(participants))
					break
				sleep 10
			init_game()


		init_game()
			/*
				This is called to initialize a new match.
			When players are in the lobby this will manage the countdown timer until the game starts and map/game setup.
			also handles initial spawning and round 1 startup.
			*/
			started = 1
			if(!players.len) world.Reboot()
			/*	map selection
				*/
			next_map 		= pick(available_maps)
			needed_skips 	= ((participants.len > 1) ? round(participants.len/1.5) : 1)	// the number of votes needed to skip the map.
			update_grid()
			for(var/mob/player/p in players)
				if(p.connected)
					winset(p,"default","macro=\"lobby\"")
					winset(p,,"child1.left=\"pane-lobby\"")
					winset(p,,"pane-lobby.next-map.text=\"[next_map.name]\"")
					winset(p,,"pane-lobby.map-info.text=\"[next_map.desc]\"")
					winset(p, "pane-lobby.to-skip", "text=0/[needed_skips]")
					winset(p, "pane-lobby.skip-button", "is-checked=\"false\"")
					winset(p, "pane-lobby.specbutton", "is-disabled=\"false\"")
					if(p in participants) {winset(p, "pane-lobby.specbutton", "is-checked=\"false\"");combined_level += p.level}
					else winset(p, "pane-lobby.specbutton", "is-checked=\"true\"")
					players << output("<b>++ <font color = [p.namecolor]>[p]</font> joined the lobby.</b>","lobbychat")


			for(var/i = 15, i > 0, i--)
				if(votes_to_skip >= needed_skips)
					next_map		= pick(available_maps-next_map)
					votes_to_skip	= 0
				for(var/mob/player/p in players)
					if(!p.connected) continue
					if(i == 14) winset(p, "pane-lobby.specbutton", "is-disabled=\"false\"")
					if("[winget(p, "pane-lobby.next-map", "text")]" != "[next_map.name]")
						winset(p,,"pane-lobby.next-map.text=\"[next_map.name]\"")
						winset(p,,"pane-lobby.map-info.text=\"[next_map.desc]\"")
						winset(p, "pane-lobby.skip-button", "is-checked=\"false\"")
					winset(p, "pane-lobby.to-skip", "text=[votes_to_skip]/[needed_skips]")
					winset(p, "pane-lobby.game-countdown", "text=\"Game in [i]..\"")
					if(i == 5) winset(p, "pane-lobby.specbutton", "is-disabled=\"true\"")
					if(i <= 1) winset(p, "pane-lobby.game-countdown", "text=\"Loading..\"")
					sleep world.tick_lag
				sleep 10
				if(i == 1 && !participants.len)
					i = 15
					sleep
				sleep world.tick_lag


			/* player setup/spawning.
			*/
			last_map					= next_map.name
			var/dmm_suite/new_reader 	= new()
			new_reader.load_map(next_map.dmm_file, 2)	// all maps should get instanced on z-levels 2 and higher. Never on z-1.
			var/list/speclist 			= new/list()
			for(var/mob/player/p in players)
				if(!p.connected) continue
				winset(p,,"child1.left=\"pane-map\"")
				winset(p, "pane-map.map1", "focus=\"true\"")
				if(p in participants)
					winset(p,"default","macro=\"play\"")
					p.shield(1, 0)
					p.points 	= 0
					p.kills		= 0
					spawn_pl(p)
					p.update_pl_targets()	//////////////////    this makes sure all players are tracking eachother at the start of the game.

				else speclist += p	// make sure we handle spectators last so that the participants are ready to be spectated.
			if(speclist.len) for(var/mob/player/p in speclist)
				winset(p,"default","macro=\"spectate\"")
				p.spectate_rand()

			spawnlist		= new/list()
			intermission	= 1
			gameover		= 0
			started 		= 2
			current_round	= (combined_level>10 ? 5 : 1)
			combined_level	= 0
			weather_loop()
			init_wave()


		init_wave()
			/* called to start a wave.
			*/
			if(!players.len) world.Reboot()
			last_match_round 	= current_round
			var/i_ 				= 15	// how many seconds the intermission should last.
			if((current_round-1) && (current_round-1)%5==0) // if it's an extended intermission!
				i_ = 90 // intermission will last 90 seconds.
				spawn_vendors()
				. = 1
			world << "<b>Wave [current_round] will begin in [i_] seconds."
			for(i_, i_, i_--)
				timer	= i_
				if(active_game.pause) while(active_game.pause) sleep 5
				sleep 10
			if(.) for(var/mob/m in vendors)
				support_ai -= m
				m.GC()
				vendors -= m
			timer = null
			if(!players.len) world.Reboot()
			change_song(pick(game_music))	// set the current song to a random track from the gamemusic list.
			ambient_color	= pick("#000000", "#240202", "#211d29", "#1d2926")
			intermission 	= 0
			weather_type 	= pick(RAIN, SNOW, BLOODRAIN)
			max_darkness 	= rand(180, 210)
			min_darkness 	= 160 //rand(112, 145)
			speed_modifier()
		//	if(!support_ai.len && prob(1)) // if there isn't a support npc yet and there probability is right.
		//		spawn_support()


			/* below we will determine what wave modifiers/variants will be activated. First we check for boss rounds, though!
			*/
			if(current_round == 20)
				boss_mode 		= 1
				max_darkness	= 225
				boss_orojoro()
			if(current_round == 10)
				boss_mode 		= 1
				max_darkness	= 225
				boss_doppelganger()
			else if(participants.len > 1 && (current_round == 17 || (current_round > 17 && prob(5))))
				boss_mode 		= 1
				max_darkness	= 200
				boss_deathmatch()

			/* if a boss round isn't initiated, let's check out some stackable modifiers!
			*/
			if(!boss_mode && prob(55))
				if(prob(2)) doppel_spawn = 1
				if(prob(5+current_round))
					blackout		= 1
					max_darkness	= 245
					min_darkness	= 235
				if(prob(10))	phantom_enemies = 1
				if(prob(5))		censorship		= 1
				if(current_round > 5 && prob(15))
					switch(pick(1,2))
						if(1) if(current_round > 5)
							crawler_only	= 1
						if(2) beholder_only	= 1
				//		if() abstract_only	= 1
				//		if(4) blaze_only	= 1
				if(prob(5) && !abstract_only)
					explosive_enemies	= 1
				if(prob(5)) switch(rand(1,3))
					if(1) laser_madness	= 1
					if(2) nyan_madness	= 1
					if(3) fire_madness	= 1
		//		if(prob(5*current_round))
		//			trippy_mane	= 1


			if(!boss_mode)
				enemies_total	= (beholder_only||blaze_only?round(2*current_round):round(5*current_round+3*participants.len))
				enemies_left	= enemies_total
				world_sound('audio/sounds/voice_wave_begin.ogg')
				for(var/mob/player/p in participants)
					p.fx_waveStart()
				//	if(trippy_mane)
				//		animate(p.client, color = "#DA1AC7", time = 10, easing = ELASTIC_EASING, loop = -1)
				//		animate(color = "#66EF01", time = 10)
				//		animate(color = "#C7DA1A", time = 10)
				//		animate(color = "#3A5CBA", time = 10)
					if(censorship) p.censor()
				/* enemy spawning
				*/
				var/tmp/list/_spawnlist = generate_spawnlist()
				for(var/i = 1 to enemies_total)
					if(active_game.pause) while(active_game.pause && active_game.started == 2) sleep 5
					while(ai_list.len >= map_spawnlimit) sleep 5
					if(started == 1) break
				/* okay, so individual enemies have a spawn_rate var that determines how common or uncommon they are to come across.
				*/
					var/mob/npc/hostile/h	// this is the var for the enemy that will get spawned!
					if(doppel_spawn)		// special spawns should be gotten out of the way first.
						h 				= garbage.Grab(/mob/npc/hostile/doppelganger)
						doppel_spawn	= 0	// make false since we spawned it.
					if(!h)					// if there weren't any special spawns..
						h	= garbage.Grab(pick(_spawnlist))	//pick a random!
						if((current_round%5 != 0) && (!prob(h.spawn_rate)) && !blaze_only && !crawler_only && !abstract_only && !beholder_only)	// if their prob chance fails, just default to feeders.
							h.GC()	// don't forget to return h to the garbage pool!
							h = garbage.Grab(/mob/npc/hostile/feeder)
				/* now we can check for any effects that certain enemy types can get!
				*/
					if(istype(h, /mob/npc/hostile/crawler))
						h.icon_state = pick("grey", "white")
						if(prob(5+active_game.current_round))
							h.bounds_scale(2)
							h.transform 	= matrix()*2
					/*		h.bound_x 		= 0
							h.bound_width 	= 32
							h.bound_height	= 20
							h.bound_y		= -16 */
							h.is_giant		= 1
							h.can_kb		= 0
							h.base_health	= 120
							h.health		= 120
					if(istype(h, /mob/npc/hostile/feeder))
						if(prob(5+active_game.current_round))
							h.bounds_scale(2)
							h.transform 	= matrix()*2
				/*			h.bound_x 		= 10
							h.bound_width 	= 16
							h.bound_height	= 20
							h.bound_y		= -16 */
							h.is_giant		= 1
							h.can_kb		= 0
							h.base_health	= 120
							h.health		= 120
						else
							var/_size = pick(1,1.5)
							h.transform = matrix()*_size
							h.bounds_scale(_size)
						if(prob(5)) h.shield(rand(1,3), 1)
						h.step_size = 4
						if(prob(30)) h.step_size = 3 //slower
						if(prob(15)) h.step_size = 5
					if(istype(h, /mob/npc/hostile/puppet_master))
						h:shiftiness = rand(1,100)
						var/mob/npc/hostile/puppet = garbage.Grab(pick(active_game.spawnlist + /mob/npc/hostile/feeder))
						h:puppet = puppet
						puppet.puppet_master = h
						puppet.generate_gibs()
					if(h.can_phantom && (phantom_enemies || prob(10)))
						animate(h, alpha = 150, time = 20, loop = -1, easing = ELASTIC_EASING)
						animate(alpha = 120, time = 20, loop = -1, easing = ELASTIC_EASING)
					if(explosive_enemies || prob(5))
						h.is_explosive = 1
				/* now we just have to spawn the enemy can move onto the next!
				*/
					h.generate_gibs()
					spawn_en(h)
					sleep world.tick_lag*2
				/* can't forget to reset variables that only needed to be tracked while spawning enemies
				*/
				if(dis_regenerate)		dis_regenerate 		= 0
				if(crawler_only)		crawler_only		= 0
				if(beholder_only)		beholder_only		= 0
				if(abstract_only)		abstract_only		= 0
				if(blaze_only)			blaze_only			= 0
				if(aliens_only)			aliens_only			= 0
				if(phantom_enemies)		phantom_enemies		= 0
				if(explosive_enemies)	explosive_enemies	= 0
				if(blackout)			blackout			= 0


		generate_spawnlist()
			/* called to determine what enemy types will be in the mix for this round's spawn list.
			*/

			/* this section is for enemy-specific wave modifiers. Only the defined enemy should spawn.
			*/
			var/list/return_list	= new/list()
			if(crawler_only)
				return_list += /mob/npc/hostile/crawler
				return return_list
			if(abstract_only)
				return_list.Add(/mob/npc/hostile/abstract, /mob/npc/hostile/abstract2)
				return return_list
			if(beholder_only)
				return_list += /mob/npc/hostile/beholder
				return return_list
			if(blaze_only)
				return_list += /mob/npc/hostile/blaze
				return return_list
			if(aliens_only)
				return_list += /mob/npc/hostile/alien
				return return_list

			/* this section is for if a new enemy type is introduced. When that happens, ONLY that enemy type can spawn.
			*/
			if(current_round < 50 && (current_round % 5 == 0))	// if the current round is a multiple of 5..
				return_list += pick(enemy_list-spawnlist) // picks a random enemy type from a list of enemies that aren't included yet
				spawnlist += return_list	// don't forget to add the new enemy type to the main spawnlist, too..
				return return_list

			return_list.Add(spawnlist, /mob/npc/hostile/feeder)
			return return_list



		progress_check()
			if(gameover || started != 2) return
			if(!participants.len)
				spawn end_game()
				return

			if(boss_mode || enemies_left)
				var/mob/player/p
				if(participants.len) if(!support_ai.len) for(var/i = 1 to participants.len)
					p = participants[i]
					if(!p)
						world << "<font color = red><b>DEBUG: Have a clientless player in participants! Investigate: [p]"
						continue
					if(p.health) break
					if(!p.health && i == participants.len)
						gameover = 1
						world_sound('audio/sounds/voice_all_players_dead.ogg')
						world << sound(null, 0, 0, 3)
						spawn end_game()
						return
					sleep world.tick_lag
				else
					spawn end_game()
					return
				if(enemies_left == 5 && !boss_mode && !last_five)
					last_five = 1
					for(var/mob/player/m in participants)
						if(m.health) for(var/mob/npc/hostile/h in ai_list)
							m.add_target(h)
			else if(!intermission)
				intermission 	= 1
				last_five		= 0
				sleep 20
				world_sound('audio/sounds/voice_wave_complete.ogg')
				current_round ++
				if(laser_madness)	laser_madness	= 0
				if(nyan_madness)	nyan_madness	= 0
				if(fire_madness)	fire_madness	= 0
				if(censorship)		censorship		= 0
			//	if(trippy_mane) 	trippy_mane 	= 0;animate(client, color = null)
				for(var/mob/player/p in participants)
					if(p.censored) p.censor(1)
					if(trippy_mane) animate(p.client, color = null)
					if(top_player && top_player != p)
						if(p.kills > top_player.kills)
							top_player.overlays.Remove(CROWN_OVERLAY)
							p.overlays.Add(CROWN_OVERLAY)
							top_player = p
						if(p.kills == top_player.kills)
							top_player.overlays.Remove(CROWN_OVERLAY)
							top_player = null
					else
						top_player = p
						p.overlays.Add(CROWN_OVERLAY)
					p.fx_waveEnd()
					if(p.health)
						if(p.health < p.base_health/2)
							p.health = round(p.base_health/2)				/// players with less than half their hp get it restored to half.
					if(!p.health) spawn_pl(p) // respawn players.
				init_wave()


		end_game()
			if(!players.len) world.Reboot()
			if(started == 1) return
			started 			= 1
			sleep 40
			current_round		= 1
			exp_multiplier		= 1
			enemies_left		= 1
			enemies_total		= 1
			toggle_regen		= 1
			toggle_revive		= 1
			laser_madness		= 0
			nyan_madness		= 0
			fire_madness		= 0
			crawler_only		= 0
			beholder_only		= 0
			abstract_only		= 0
			blaze_only			= 0
			explosive_enemies	= 0
			boss_mode			= 0
			PvP					= 0
			trippy_mane			= 0
			last_five			= 0
			censorship			= 0
			player_spawns		= new/list()
			enemy_spawns		= new/list()
			ai_list				= new/list()
			active_projectiles	= new/list()
			medcrates			= new/list()
			portals				= new/list()
			weather_turfs		= new/list()
			support_ai			= new/list()
			res_ai				= new/list()
			vendors				= new/list()
			vendor_spawns		= new/list()
			_paths				= new/list()
			change_song(pick(interm_music))
			if(top_player)
				top_player.overlays -= CROWN_OVERLAY
				top_player 			= null
			for(var/mob/player/p in participants)
				animate(p.client, color = null)
				winset(p, "default","macro=\"lobby\"")
				winset(p, "pane-lobby.game-countdown", "text=\"Submitting Scores..\"")
				winset(p,,"child1.left=\"pane-lobby\"")
				p.SetLoc(locate(20,21,1),8,8)
				p.client.eye		= p
				p.density			= 1
				p.can_hit			= 0
				p.died_already		= 1
				p.move_disabled		= 1
				p.career_score 		+= p.points
				p.submit_scores()
			for(var/mob/player/p in spectators)
				p.client.eye	= p
				winset(p, "default","macro=\"lobby\"")
				winset(p,,"child1.left=\"pane-lobby\"")
			for(var/area/a in world) del a
			for(var/turf/t in world)
				if(t.z == 1) continue
				if(t.contents) for(var/atom/movable/a in t)
					if(a.is_garbage)
						a.GC()
					else del a
				new /turf(t)
			world.maxx	= 50
			world.maxy	= 50
			init_game()

		spawn_support()
			var/sup = "kett" //pick("kett","steve")
			if(sup == "kett")
				var/mob/npc/support/kett/v 	= garbage.Grab( /mob/npc/support/kett )
				v.step_size					= 4
				v.health					= v.base_health
				v.loc						= pick(player_spawns)
				v.alive 					= 1
				support_ai += v
				for(var/mob/player/p in active_game.participants)
					p.update_pl_targets(v)

			else if(sup == "steve")
				var/mob/npc/support/steve/v = new
				v.draw_nametag("Steve", v.level) //,, -44)
				v.draw_health(-5, 32)
				v.arms.icon_state 	= "base-krossbow"
				v.shirt.icon_state	= "shirt13"
				v.hair.icon_state	= "style15"
				v.pants.icon_state	= "pants3"
				v.overlays += v.arms
				v.overlays += v.shirt
				v.overlays += v.pants
				v.overlays += v.hair
				v.step_size	= 4
				v.health	= v.base_health
				v.loc		= pick(player_spawns)
				v.alive 	= 1
				support_ai += v
				var/mob/npc/support/blue/b = new
				b.draw_nametag("Blue", v.level) //,, -44)
				b.draw_health(-5, 32)
				b.step_size	= 4
				b.health	= b.base_health
				b.loc		= pick(player_spawns)
				b.alive 	= 1
				b.closest_friend = v
				support_ai += b


	// WAVE VARIANT PROCS --- the following procs run in the background of waves and manage the more complicated aspects of their event type.


		spawn_vendors()
			/* called to spawn the NPC vendors to the map
				*/
			inv_hair_vendor 	= new/list()
			inv_gun_vendor 		= new/list()
			inv_shirt_vendor 	= new/list()
			inv_vanity_vendor 	= new/list()
			for(var/i = 31, i, i--)
				if(i > 6 && prob(50))	// 45% chance a given object won't be listed.
					continue
				inv_hair_vendor += i
			for(var/i = 12, i, i--)
				if(i > 6 && prob(50))	// 45% chance a given object won't be listed.
					continue
				inv_gun_vendor += i
			for(var/i = 20, i, i--)
				if(i > 6 && prob(50))	// 45% chance a given object won't be listed.
					continue
				inv_shirt_vendor += i
			for(var/i = 13, i, i--)
				if(i > 6 && prob(50))	// 45% chance a given object won't be listed.
					continue
				inv_vanity_vendor += i


			var/mob/npc/support/gun_vendor/gun_seller 			= garbage.Grab(/mob/npc/support/gun_vendor)
			var/mob/npc/support/face_vendor/face_seller			= garbage.Grab(/mob/npc/support/face_vendor)
			var/mob/npc/support/hair_vendor/hair_seller			= garbage.Grab(/mob/npc/support/hair_vendor)
			var/mob/npc/support/special_vendor/special_seller	= garbage.Grab(/mob/npc/support/special_vendor)
			var/mob/npc/support/vanity_vendor/vanity_seller		= garbage.Grab(/mob/npc/support/vanity_vendor)
			var/mob/npc/support/shirt_vendor/shirt_seller		= garbage.Grab(/mob/npc/support/shirt_vendor)
			gun_seller.loc			= return_vspawn()
			face_seller.loc			= return_vspawn()
			hair_seller.loc			= return_vspawn()
			special_seller.loc		= return_vspawn()
			vanity_seller.loc		= return_vspawn()
			shirt_seller.loc		= return_vspawn()
			vendors.Add(gun_seller, face_seller, hair_seller, special_seller, vanity_seller, shirt_seller)
			support_ai += vendors

		boss_deathmatch()
			/* last man standing!
			*/
			set waitfor = 0
			PvP = 1
			no_auto_rev	= 1
			world << "Last Man Standing -- PvP Round!"
			world_sound('audio/sounds/voice_wave_begin.ogg')
			for(var/mob/player/p in active_game.participants)
				p.fx_deathmatch()
			sleep world.tick_lag
			change_song(pick(game_music))
			var/timer = 0	// used to track the deathmatch duration to initiate sudden death when needed.
			while(started == 2)
				timer ++
				var/living_players = 0
				if(timer == 30) world << "Sudden Death!"
				for(var/mob/player/p in participants)
					if(p.health)
						living_players ++
					if(timer >= 30) // 30*20 = one minute roughly
						//sudden death time
						missile_strike(p.loc)
				if(living_players <= 1)
					if(living_players) for(var/mob/player/p in participants)
						if(p.health && !p.died_already)
							p << "you win!"
							p.shield(3)
							p.has_revive = 2
							break
					break
				sleep 20
			sleep 25 // this is here to give time for the last player that died to get processed.
			if(!intermission)
				intermission = 1
				no_auto_rev = 0
				world_sound('audio/sounds/voice_wave_complete.ogg')
				current_round ++
				sleep 5// revive dead players, etc.
				for(var/mob/player/p in participants)
					p.fx_waveEnd()
					if(p.health && (p.health < p.base_health/2))
						p.health = round(p.base_health/2)
					if(!p.health) spawn_pl(p)
				boss_mode 	= 0
				PvP			= 0
				init_wave()