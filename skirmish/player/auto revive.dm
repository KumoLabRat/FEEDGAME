

mob/player
	proc
		auto_revive(diedon = 1)
			/*
				when a player dies and the game is still active (other players alive still), this gets called.
				Should revive the player automatically after one minute.
			*/
			set waitfor = 0
			sleep 600 // one minute
			if(active_game.started == 2 && active_game.current_round == diedon) // if the game is still active and its the same round the player died on..
				if(!health && (src in active_game.participants))	// and the player is still dead and participating..
					world << ">> <b><font color = [namecolor]>[src]</font> was auto revived!"
					spawn_pl(src)