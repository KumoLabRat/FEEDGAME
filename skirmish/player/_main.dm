

client
//	fps				= 100 		/// 60 or remove if 100 doesn't work out
	perspective		= (EYE_PERSPECTIVE | EDGE_PERSPECTIVE)
//	control_freak 	= (CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS)
atom/appearance_flags = PIXEL_SCALE


mob
	var/tmp
		kills 		= 0
		connected	= 0
		C_ID		= 0

	player
		var/tmp
			died_already = 1

		proc/CharacterLoaded()
			if(!class) switch(input(src, "Please select a class. (lol shiitty input windowlolol)", "Class Selection")in list("Portal Master", "Medic", "Tank"))
				if("Portal Master")
					set_class(PORTAL)
				if("Medic")
					set_class(MEDIC)
				if("Tank")
					set_class(TANK)
			loc = locate(1,1,1)
			draw_base()
			MovementLoop()
			weapon_loop()
			sleep 10
			active_game.participants += src
			src << output("<center><u>## Welcome to Feed ##</u></center>","lobbychat")
			src << output("<center><b><u>Controls</u><br>W,A,S,D to move.<br>Arrow keys to shoot.<br>Shift to dash.<br>Space+Arrow keys to use specials.<br>E to pickup weapons/spectate new.<br>F to cast a portal<br>F1 to fullscreen.</b><hr>","lobbychat")
			if(active_game.started == 2) // if game is already going on..
				/*	Players shouldn't get dumped into an active game.
					They should spectate and be able to opt into the game at will OR spectate until the start of the next wave.
				*/
				winset(src,,"child1.left=\"pane-map\"")
				winset(src,"default","macro=\"play\"")
				world << "<b>++ <font color = [namecolor]>[src]</font> connected.</b>"
				spawn_pl(src)
				for(var/mob/player/p in active_game.participants)
					p.update_pl_targets()	///////////////////////////////////////////////////////////////////////////////////
					sleep world.tick_lag

			if(active_game.started == 1)
				winset(src,,"child1.left=\"pane-lobby\"")
				winset(src,"default","macro=\"lobby\"")
				winset(src,,"pane-lobby.next-map.text=\"[active_game.next_map.name]\"")
				winset(src, "pane-lobby.to-skip", "text=0/[active_game.participants.len>1?round(active_game.participants.len/2.5):1]")
				winset(src, "pane-lobby.skip-button", "is-checked=\"false\"")
				winset(src, "pane-lobby.specbutton", "is-checked=\"false\"")
				active_game.participants << output("<b>++ <font color = [namecolor]>[src]</font> connected.</b>","lobbychat")
				active_game.spectators << output("<b>++ <font color = [namecolor]>[src]</font> connected.</b>","lobbychat")
				world << "<b>++ <font color = [namecolor]>[src]</font> connected.</b>"
				active_game.update_grid()

		Login()
			..()
			winset(src,null,"hwmode=true;")	// make sure the game starts in hardware mode
			winset(src,"default","macro=\"textinput\"") // start off all clients on the textinput macro
			C_ID = client.computer_id
			winset(src, "debugwindow.tab1","tabs=\"+chatwindow\"")
			if(key == "Kumorii" || key == "Unwanted4Murder")
				world << "<font color = teal><b>Be warned, for a deity is among us!</b></font>"
				verbs += typesof(/mob/player/gm/verb)
				winset(src, "debugwindow.tab1","tabs=\"+adminCP\"")
				is_GM = 1		 // if the key or comp_id of a client is in the staff list, make them GM.

			players 		+= src
			client.screen 	+= scanlines
			play_song(pick(interm_music))
			SetLoc(locate(20,21,1),8,8)
			alpha = 0
			splash_frakture()
			sleep 10
			init_main_menu()


		Logout()
			players -= src
			if(connected)
				save_account()
				remove_spectators()
				world << "<b>-- <font color = [namecolor]>[src]</font> disconnected."
				active_game.participants << output("<b>-- <font color = [namecolor]>[src]</font> disconnected.","lobbychat")
				active_game.spectators << output("<b>-- <font color = [namecolor]>[src]</font> disconnected.","lobbychat")
				if(src in active_game.spectators)
					active_game.spectators -= src
				if(src in active_game.participants)
					active_game.participants -= src
					if(active_game.started == 2) spawn active_game.progress_check()
				active_game.update_grid()
			if(!players.len) world.Reboot()
			del src


		death()
			if(client.eye != src || died_already) return
			died_already 	= 1
			..()
			if(prob(5)) gs('wilhelm_scream.ogg')
			remove_spectators()
			if(censored)	censor(1)
			client.eye		= loc
			cashflow -= round(cashflow/10)
			drop_cash(round((cashflow/10)/4))
			loc				= locate(1,1,1)
			move_disabled 	= 1
			alpha			= 0
			world << "<b><font color = [namecolor]>[src]</font> died! ([kills] kills)"
			active_game.participants << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
			active_game.spectators << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
			active_game.progress_check()
			spawn(10) if(active_game.started == 2)	// if the game is still active after the player dies..
				spectate_rand()
				if(!active_game.no_auto_rev) auto_revive(active_game.current_round)	// if the game is still on after the player dies, auto revive them a minute after dying(if the game is still on)
