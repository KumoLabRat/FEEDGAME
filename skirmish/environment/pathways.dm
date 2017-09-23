

/*
		these are pathway stuff. like, if you need to go through a doorway to get inside a building,
							these will manage the teleportation when going inside.
		*/

mob/player
	var
		can_pathtext	= 1

atom/movable
	proc
		PathTo(to_id)
			/*
				called to teleport a movable atom to the path destination.
			*/
			for(var/obj/_path/p in active_game._paths)
				if(p.path_id == to_id)
					loc 	= p.loc
					step_x	= 0
					step_y	= 0
					return

obj
	_path
		var
			path_id		// path_id is a unique id for each path point.
			path_to		// the [path_id] of where this path point will lead to.

		New()
			..()
			if(active_game)
				active_game._paths += src

		Crossed(atom/movable/a)
			if(istype(a, /mob/player))
				var/mob/player/p = a
				if(p.health && (p in active_game.participants) && p.can_pathtext)
					p.can_pathtext = 0
					spawn
						float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Enter", 1)
						p.can_pathtext = 1