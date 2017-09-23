var
	tmp/list/pause_screen	= newlist(/obj/hud/pause_fade, /obj/hud/pause)

mob
	var
		obj/hud/frakture_splash/frak_splash	= new
		obj/hud/feedlogo/feedlogo			= new
		obj/hud/health_meter/health_disp	= new
		obj/hud/reload_meter/reload_disp	= new
	proc
		splash_frakture()
			/* called to show the frakture studios splash.
			*/
			frak_splash.alpha 	= 0
			feedlogo.alpha		= 0
			client.screen += frak_splash
			animate(frak_splash, alpha = 255, time = 10)
			sleep 15
			animate(frak_splash, alpha = 0, time = 10)
			sleep 5
			client.screen -= frak_splash
			sleep 10


		draw_health(x_offset = 0, y_offset = 0)
			health_disp.icon 		= 'meterhealth.dmi'
			health_disp.icon_state	= "29"
			health_disp.pixel_x 	= x_offset
			health_disp.pixel_y		= y_offset
			overlays += health_disp
			if(!client) health_loop()

		health_loop()
			set waitfor = 0
			while(src)
				if(!loc) sleep 10
				else if(health_disp && active_game.started == 2)
					if(health_disp.icon_state != "[round((health/base_health)*29)]")
						overlays -= health_disp
						health_disp.icon_state 	= "[round((health/base_health)*29)]"
						overlays += health_disp
				sleep 2


	player
		proc
			refresh_hud()
				/*
					this proc loops on the player when they log in and handles all the HUD stuff.
				*/
				set waitfor = 0
				toggle_daynight(1)	// add the lighting layer.
				draw_health(-5, 32)
				client.screen 	+= new /obj/hud/clip_status
				client.screen 	+= new /obj/hud/kill_counter
				client.screen 	+= new /obj/hud/wave_counter
				client.screen 	+= new /obj/hud/cash_counter
				client.screen 	+= new /obj/hud/timer_counter
				overlays 		+= REVIVES
				var/i = 0
				while(src)
					i++
					if(i >= 5 && health && health < base_health)
						i = 0
						health += ( class == MEDIC ? 10 : 5 )
					if(health_disp)
						if(health_disp.icon_state != "[round((health/base_health)*29)]")
							overlays -= health_disp
							health_disp.icon_state 	= "[round((health/base_health)*29)]"
							overlays += health_disp
					if(REVIVES)
						if(REVIVES.icon_state != "revive[has_revive]")
							overlays -= REVIVES
							REVIVES.icon_state = "revive[has_revive]"
							overlays += REVIVES

					for(var/obj/hud/h in client.screen)	// only loop through hud objects that are currently being displayed.
						h.refresh(src)					// refresh each! If you need to reference the player in the refresh proc, just add it to the object's refresh proc's arguments.
						sleep world.tick_lag
					sleep 2




obj/hud
	/* you can build your own hud system around this(it's a good setup) or just port the important parts to your own setup.
		*/
	proc
		refresh()
			/* called on each /obj/hud in the client's screen every 5 ticks.
				what you put in this proc for each object will be carried out as long as the object is in client.screen
			*/

	health_meter
		icon				= 'meterhealth.dmi'
		icon_state			= "14"
		appearance_flags	= NO_CLIENT_COLOR+RESET_TRANSFORM
		plane				= 3

	reload_meter
		icon 			= 'reloading.dmi'
		icon_state 		= "0"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM

	clip_status
		/*	this is a HUD object that gets cast across client.screen so day/night effects can be easily enabled/disabled for different players depending on their
			location and such. (for example, if you're inside a cave, it shouldn't be sunny. Or if you're in a lit house at night, it shouldn't stay dark when you go inside.
			*/
		screen_loc			= "SOUTH+1,WEST"
		maptext_width		= 128
		maptext_height		= 32
		maptext				= "--/--"
		pixel_x				= 2
		plane				= 3
		mouse_opacity 		= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/last_mag

		refresh(mob/player/p)

			if(active_game.started == 2)

				if(p.client.fs && screen_loc != "SOUTH+1,WEST+1:2")
					screen_loc	= "SOUTH+1,WEST+1:2"
				if(!p.client.fs && screen_loc != "SOUTH+1,WEST:2")
					screen_loc	= "SOUTH+1,WEST:2"
				if(istype(p.equipped_weapon, /obj/weapon/gun))
					if(p.equipped_weapon:mag != last_mag)
						last_mag 	= p.equipped_weapon:mag
						maptext		= "[p.equipped_weapon:mag]/[p.equipped_weapon:mag_size]"
				else if(last_mag != "--/--")
					last_mag 	= "--/--"
					maptext		= "--/--"


	kill_counter
		screen_loc			= "NORTH-1,WEST"
		maptext_width		= 128
		maptext_height		= 32
		maptext				= "0 kills"
		pixel_x				= 2
		plane				= 3
		mouse_opacity 		= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/last_kills

		refresh(mob/player/p)

			if(active_game.started == 2)

				if(p.client.fs && screen_loc != "NORTH-1:-3,WEST+1:5")
					screen_loc	= "NORTH-1:-3,WEST+1:5"
				if(!p.client.fs && screen_loc != "NORTH:-14,WEST:2")
					screen_loc	= "NORTH:-14,WEST:2"
				if(last_kills != p.kills)
					last_kills = p.kills
					maptext	= "[last_kills] kills"


	wave_counter
		screen_loc			= "NORTH-1,CENTER"
		maptext_width		= 128
		maptext_height		= 32
		maptext				= "Wave -"
		plane				= 3
		mouse_opacity 		= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/last_wave

		refresh(mob/player/p)

			if(active_game.started == 2)
				if(p.client.fs && screen_loc != "NORTH-1:-3,CENTER-4")
					screen_loc	= "NORTH-1:-3,CENTER-4"
				if(!p.client.fs && screen_loc != "NORTH:-14,CENTER-4")
					screen_loc	= "NORTH:-14,CENTER-4"
				if(active_game.intermission)
					maptext = "<center><u>INTERMISSION"
				else if(last_wave != active_game.current_round)
					last_wave = active_game.current_round
					maptext	= "<center>Wave [last_wave]"

	cash_counter
		screen_loc			= "NORTH-3,WEST"
		maptext_width		= 128
		maptext_height		= 32
		maptext				= "$0"
		pixel_x				= 2
		plane				= 3
		mouse_opacity 		= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/last_cash

		refresh(mob/player/p)

			if(active_game.started == 2)
		//		world << "test"
				if(p.client.fs && screen_loc != "NORTH-2:-3,WEST+1:5")
					screen_loc	= "NORTH-2:-3,WEST+1:5"
				if(!p.client.fs && screen_loc != "NORTH-1:-14,WEST:2")
					screen_loc	= "NORTH-1:-14,WEST:2"
				if(last_cash != p.cashflow)
					last_cash = p.cashflow
					maptext	= "<font color = green>$[last_cash]"
			//		world << "last_score: [last_score]"

	timer_counter
		screen_loc			= "NORTH-1,EAST-2"
		maptext_width		= 128
		maptext_height		= 32
		maptext				= ""
		pixel_x				= -2
		plane				= 3
		mouse_opacity 		= 0
		appearance_flags	= NO_CLIENT_COLOR
		var/last_time

		refresh(mob/player/p)

			if(active_game.started == 2)

				if(p.client.fs && screen_loc != "NORTH-1:-3,EAST-3:-8")
					screen_loc	= "NORTH-1:-3,EAST-3:-8"
				if(!p.client.fs && screen_loc != "NORTH:-13,EAST-2:-6")
					screen_loc	= "NORTH:-13,EAST-2:-6"
				if(!active_game.timer && maptext)
					maptext = null
				else if(last_time != active_game.timer)
					last_time = active_game.timer
					maptext	= "Game in.. [active_game.timer]"
	pause_fade
		screen_loc			= "SOUTH,WEST to NORTH,EAST"
		icon				= 'fade.dmi'
		icon_state			= "pause"
		plane				= 4
		appearance_flags	= NO_CLIENT_COLOR
	pause
		screen_loc			= "SOUTH,WEST"
		icon				= 'interface/paused.png'
		plane				= 5
		appearance_flags	= NO_CLIENT_COLOR
	frakture_splash
		screen_loc			= "SOUTH,WEST"
		icon				= 'interface/frakturesplash.png'
		plane				= 5
		appearance_flags	= NO_CLIENT_COLOR
	feedlogo
		screen_loc			= "SOUTH,WEST"
		icon				= 'interface/feedlogo.png'
		plane				= 5
		appearance_flags	= NO_CLIENT_COLOR