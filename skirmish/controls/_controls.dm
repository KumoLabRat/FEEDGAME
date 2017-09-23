

mob/player
	var
		obj/weapon/equipped_weapon	//= new /obj/weapon/gun/pistol
		obj/weapon/equipped_special	//= new /obj/weapon/special/grenade

		tmp
			trigger1 			= 0
			trigger2 			= 0
			trigger3 			= 0
			trigger4 			= 0
			shooting 			= 0		// 1 if actively shooting a weapon.
			last_trigger		= 0		// the last direction the player shot towards.
			trigger_dir			= 0		// tracks the direction that the player is shooting.
			trigger_down		= 0		// tracks whether or not a trigger is being held down.
			trigger_break		= 0		// used to track when the movement loop should ignore held triggers. mainly used for non-automatic weapons.
			strafe_dir			= 0
			secondary_toggle	= 0
			reloading			= 0
	proc
		weapon_loop()
			set waitfor = 0
			while(src)
				if((trigger1 || trigger2 || trigger3 || trigger4) || controller_dir)
					last_trigger 	= trigger_dir			// remember the current trigger_dir before updating it.
					trigger_dir 	= (controller_dir ? controller_dir : resolve_trigger())		// update the trigger_dir.
					strafe_dir 		= trigger_dir
					if(trigger_dir)
						if(health && !frozen)
							if(!secondary_toggle && equipped_weapon && equipped_weapon.can_use && !reloading && !shooting)
								shooting = 1
								spawn
									equipped_weapon.use(src)
									shooting = 0
							if(secondary_toggle && equipped_special && equipped_special.can_use)
								equipped_special.use(src)
				else
					if(trigger_dir)
						last_trigger 	= trigger_dir
						trigger_dir		= null
						spawn(2) if(!trigger_dir) strafe_dir = null
				sleep world.tick_lag

		resolve_trigger()
			var
				dir_x
				dir_y
			switch(trigger1)
				if(NORTH)	if(trigger2 != SOUTH && trigger3 != SOUTH && trigger4 != SOUTH)	dir_y = NORTH
				if(SOUTH)	if(trigger2 != NORTH && trigger3 != NORTH && trigger4 != NORTH)	dir_y = SOUTH
				if(EAST)	if(trigger2 != WEST && trigger3 != WEST && trigger4 != WEST)	dir_x = EAST
				if(WEST)	if(trigger2 != EAST && trigger3 != EAST && trigger4 != EAST)	dir_x = WEST
			switch(trigger2)
				if(NORTH)	if(trigger1 != SOUTH && trigger3 != SOUTH && trigger4!=SOUTH)	dir_y = NORTH
				if(SOUTH)	if(trigger1 != NORTH && trigger3 != NORTH && trigger4!=NORTH)	dir_y = SOUTH
				if(EAST)	if(trigger1 != WEST && trigger3 != WEST && trigger4!=WEST)		dir_x = EAST
				if(WEST)	if(trigger1 != EAST && trigger3 != EAST && trigger4!=EAST)		dir_x = WEST
			switch(trigger3)
				if(NORTH)	if(trigger1 != SOUTH && trigger2 != SOUTH && trigger4 != SOUTH)	dir_y = NORTH
				if(SOUTH)	if(trigger1 != NORTH && trigger2 != NORTH && trigger4 != NORTH)	dir_y = SOUTH
				if(EAST)	if(trigger1 != WEST && trigger2 != WEST && trigger4 != WEST)	dir_x = EAST
				if(WEST)	if(trigger1 != EAST && trigger2 != EAST && trigger4 != EAST)	dir_x = WEST
			switch(trigger4)
				if(NORTH)	if(trigger1 != SOUTH && trigger2 != SOUTH && trigger3 != SOUTH)	dir_y = NORTH
				if(SOUTH)	if(trigger1 != NORTH && trigger2 != NORTH && trigger3 != NORTH)	dir_y = SOUTH
				if(EAST)	if(trigger1 != WEST && trigger2 != WEST && trigger3 != WEST)	dir_x = EAST
				if(WEST)	if(trigger1 != EAST && trigger2 != EAST && trigger3 != EAST)	dir_x = WEST
			if(dir_x)
				if(dir_y) return dir_x+dir_y
				else return dir_x
			else
				if(dir_y)return dir_y
				else return 0


		triggerSet(_dir)
			trigger_down ++
			if(trigger1)
				if(trigger1 == _dir) return
				if(trigger2)
					if(trigger2 == _dir) return
					if(trigger3)
						if(trigger3 == _dir) return
						trigger4=_dir
					else trigger3=_dir
				else trigger2=_dir
			else trigger1=_dir

		triggerDel(_dir)
			set hidden = 1
			if(trigger_down) trigger_down --
			if(trigger1==_dir)
				trigger1=trigger2
				trigger2=trigger3
				trigger3=trigger4
				trigger4=0
			else
				if(trigger2==_dir)
					trigger2=trigger3
					trigger3=trigger4
					trigger4=0
				else
					if(trigger3==_dir)
						trigger3=trigger4
						trigger4=0
					else trigger4=0

	verb
		pause_game()
			set hidden = 1
			if(players.len > 1 || client.address || active_game.started != 2) return
			if(active_game.pause)
				active_game.pause = 0
				move_disabled = 0
				client.screen -= pause_screen
			else
				active_game.pause = 1
				move_disabled = 1
				client.screen += pause_screen
		toggle_secondary_down()
			set hidden = 1
			usr:specNew()
			if(equipped_special && !secondary_toggle)
				secondary_toggle = 1
		toggle_secondary_up()
			set hidden = 1
			if(secondary_toggle)
				secondary_toggle = 0
		reload()
			set hidden = 1
			if(reloading) return
			if(equipped_weapon && istype(equipped_weapon, /obj/weapon/gun) && equipped_weapon.can_use)
				var/obj/weapon/gun/weapon = equipped_weapon
				if(weapon.mag < weapon.mag_size) weapon.reload(src)
		tnorth()
			set
				hidden=1
				instant=1
			src.triggerSet(NORTH)
		tnorth_up()
			set
				hidden=1
				instant=1
			src.triggerDel(NORTH)
		tsouth()
			set
				hidden=1
				instant=1
			src.triggerSet(SOUTH)
		tsouth_up()
			set
				hidden=1
				instant=1
			src.triggerDel(SOUTH)
		teast()
			set
				hidden=1
				instant=1
			src.triggerSet(EAST)
		teast_up()
			set
				hidden=1
				instant=1
			src.triggerDel(EAST)
		twest()
			set
				hidden=1
				instant=1
			src.triggerSet(WEST)
		twest_up()
			set
				hidden=1
				instant=1
			src.triggerDel(WEST)