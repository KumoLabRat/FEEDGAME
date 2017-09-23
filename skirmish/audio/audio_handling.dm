

/* it's about time we got audio cleaned up and tidy.
*/

#define AMBIANCE 16

var
	list
		game_music		= list('loop-alienband-game.ogg','loop-discoants-game.ogg','loop-funky-game.ogg', 'loop-insane-game.ogg','loop-mayhem-game.ogg', \
							'loop-mayhem2-game.ogg', 'loop-mayhem3-game.ogg', 'loop-mayhem4-game.ogg', 'loop-zombies-game.ogg')
		interm_music	= list('loop-chimes-interm.ogg','loop-surreal-menu.ogg')


proc/change_song(sfile)
	/* called to set a new song.
	*/
	if(sfile) for(var/mob/player/p in players)
		p.play_song(sfile, 1, 60)


proc/world_sound(sfile)
	/* called to play a sound to all players.
	*/
	if(sfile) for(var/mob/player/p in players)
		if(p.connected) p.play_sound(sfile)

mob
	var
		music_volume		= 100
		sfx_volume			= 70
		music_on			= 1
		tmp
			current_song	= null


	verb
		toggle_music()
			set hidden = 1
			/* use this to toggle music on or off!
			*/
			if(music_on) music_on = 0
			else music_on = 1
			play_song(current_song, 1, 1)


	proc
		play_sound(sfile, vol = 100)
			/* called to play a sound effect to a client.
			*/
			if(client) src << sound(sfile, volume = vol*sfx_volume) //volume is factored in..


		play_song(sfile, do_repeat = 1, _volume = 60)
			/* called to make [sfile] the playing song
			*/
			if(sfile != current_song) // if the ambiance track isn't the one being played already, make it so!
				current_song = sfile
				if(music_on)	src << sound(sfile, repeat = do_repeat, channel = 16, volume = _volume*music_volume)
				else			src << sound(null, repeat = do_repeat, channel = 16)



atom/proc
	view_sound(sfile, _range = 8, _volume = 1, _frequency = 0)
		/* called to play a sound to all clients in [_range] of an atom(src).
		*/
		set waitfor = 0
		var/sound/S = sound(sfile)
		S.frequency = _frequency
		for(var/mob/M in hearers(_range, src))
			if(M.client)
				S.volume = _volume*M.sfx_volume
				M << S

	gs(f, _vol = 0.5)
		/* shorthand proc for the above; just supply a file and it will do the rest.
		*/
		set waitfor = 0
		if(f) view_sound(f, 13, _vol, rand(5,15)*0.1)
