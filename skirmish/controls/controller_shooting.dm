
mob/player
	var/tmp
		weaponwait 		= 0
		controller_dir	= 0
		last_x			= 0
		last_y			= 0
	verb
		use_weapon_stick(x as num, y as num)
			set hidden 	= 1
	//		world << "debug: [x] [y]"
			if(weaponwait || (x < last_x+0.05 && x > last_x-0.05) && (y < last_y+0.05 && y > last_y-0.05))
				if(x < 0.25 && y < 0.25)
					if(x > -0.25 && y > -0.25) controller_dir = null
				return
			weaponwait = 1
			var/_dir 	= 0
			if(x > 0.25)
				if(y > 0.15)		_dir = NORTHEAST
				else if(y < -0.15) 	_dir = SOUTHEAST
				else 				_dir = EAST
			else if(x < -0.25)
				if(y > 0.15) 		_dir = NORTHWEST
				else if(y < -0.15) 	_dir = SOUTHWEST
				else 				_dir = WEST
			else if(y > 0.25) 		_dir = NORTH
			else if(y < -0.25) 		_dir = SOUTH
			else					_dir = 0
			last_x = x
			last_y = y
			controller_dir 	= _dir
			sleep world.tick_lag
			weaponwait = 0