



client
	proc
		screen_shake(n,a=1)
			spawn()
				for(var/i=0,i<n,i++)
					animate(src,pixel_y = rand(-1,1)*a,pixel_x=rand(-1,1)*a,time=2)
					sleep(1)
				animate(src,pixel_y=0,pixel_x=0,time=2)
/*
mob/player
	var/tmp
		init_shake	= 0

	proc
		screenshake(shake_offset = 5)
		//	set waitfor = 0
			if(!init_shake)
				init_shake = 1
				animate(client, pixel_x = shake_offset, pixel_y = shake_offset, time = 2, loop = 1)//, flags = ANIMATION_PARALLEL)
				animate( pixel_x = (shake_offset-shake_offset), pixel_y = (shake_offset-shake_offset), time = 2)
				animate( pixel_x = shake_offset, time = 2)
				animate( pixel_x = (shake_offset-shake_offset), pixel_y = shake_offset, time = 2)
				animate( pixel_x = 0, pixel_y = 0, time = 2)
				sleep 10
				init_shake = 0

*/