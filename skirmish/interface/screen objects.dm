
mob/player
	var
		obj/screen_obj/wave_complete/waveComplete 	= new
		obj/screen_obj/wave_start/waveStart	 		= new
		obj/screen_obj/deathmatch/deathmatch		= new
		obj/screen_obj/scanlines/scanlines			= new

	proc
		hurtflash()
			set waitfor = 0
			animate(client, color = "red", time = 2)//, flags = ANIMATION_PARALLEL)
			animate(color = null, time = 1)


		fx_waveStart(red_flash = 0)
			set waitfor 			= 0
			waveStart.alpha			= 0
			client.screen += waveStart
			if(red_flash)	animate(waveStart, alpha = 255, color = "red", transform = turn(matrix(), 360), time = 10, easing = BACK_EASING, loop = 1)
			else			animate(waveStart, alpha = 255, transform = turn(matrix(), 360), time = 10, easing = BACK_EASING, loop = 1)
			sleep 20
			animate(waveStart, alpha = 0, color = null, time = 5, loop = 1)
			sleep 5
			client.screen -= waveStart


		fx_waveEnd(red_flash = 0)
			set waitfor 			= 0
			waveComplete.alpha		= 0
			client.screen += waveComplete
			if(red_flash)	animate(waveComplete, alpha = 255, color = "red", transform = turn(matrix(), 360), time = 10, easing = BACK_EASING, loop = 1)
			else			animate(waveComplete, alpha = 255, transform = turn(matrix(), 360), time = 10, easing = BACK_EASING, loop = 1)
			sleep 20
			animate(waveComplete, alpha = 0, color = null, time = 5, loop = 1)
			sleep 5
			client.screen -= waveComplete


		fx_deathmatch(red_flash = 0)
			set waitfor 		= 0
			deathmatch.alpha	= 0
			client.screen += deathmatch
			if(red_flash)	animate(deathmatch, alpha = 255, color = "red", transform = turn(matrix(), 360), time = 10, easing = BACK_EASING, loop = 1)
			else			animate(deathmatch, alpha = 255, transform = turn(matrix(), 360), time = 10, easing = BACK_EASING, loop = 1)
			sleep 20
			animate(deathmatch, alpha = 0, color = null, time = 5, loop = 1)
			sleep 5
			client.screen -= deathmatch


obj
	screen_obj
		plane 		= 3
		is_garbage	= 0

	//	background
	//		icon				= 'backdrop.png'
		wave_complete
			icon				= 'wavecomplete.png'
			screen_loc			= "SOUTHWEST"
		wave_start
			icon				= 'wavestart.png'
			screen_loc			= "SOUTHWEST"
		deathmatch
			icon				= 'deathmatchwave.png'
			screen_loc			= "SOUTHWEST"
		scanlines
			icon				= 'interface/x16.dmi'
			icon_state			= "scanlines"
			screen_loc			= "SOUTHWEST to NORTHEAST"
			alpha				= 40
			appearance_flags	= BLEND_MULTIPLY

