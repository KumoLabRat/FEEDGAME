/*
	this is where the mechanics for portals and player portal creation goes!


 ---
		this will be the next big gameplay mechanic. Players will play the role of "portal masters" which have the ability to create portals.
	idk what the button will be yet but basically players will have an ability to throw out a portal a few tiles ahead in their direction.
	portals will take players to another random location on the map.
	think of it as a panic button.
	portals will also have support capability by using on players to immediately portal them away or portalling at enemies to help clear the area.


	*/

atom/movable
	var
		can_teleport	= 1	// whether or not the atom can be sent through a portal.

	proc
		portal(mob/_owner, obj/hazard/portal/fromportal)
			set waitfor = 0
			if(can_teleport && (active_game.portals.len > 1))
				can_teleport = 0
				if(istype(src, /mob/npc/hostile))
					if(!src:health || !loc || !(src in ai_list))
						sleep 5
						can_teleport = 1
						return
				if(istype(src, /obj/projectile) && !(src in active_projectiles))
					sleep 5
					can_teleport = 1
					return
				for(var/obj/hazard/portal/p in active_game.portals-fromportal)
					if(p.owner == _owner)
						. = p.loc
						break
				if(.)
					for(var/mob/a in .)
						a.knockback(20, rand(1,8))
						sleep world.tick_lag
					animate(src, alpha = 0, transform = (turn(transform,180))/5, color = "green", time = 1)
					sleep 1
					if(istype(src, /obj/projectile) && !(src in active_projectiles))
						sleep 5
						can_teleport	= 1
						alpha			= 255
						transform		= matrix()
						return
					if(istype(src, /mob/npc/hostile))
						if(!src:health || !loc || !(src in ai_list))
							sleep 5
							can_teleport 	= 1
							alpha			= 255
							transform		= matrix()
							return
					if(loc) loc = .
					animate(src, alpha = 255, transform = matrix(), color = null, time = 1)
					sleep 10
				can_teleport = 1

proc
	draw_portal(turf/_loc, _color = "#FFFFFF", _time = 45, mob/player/_owner = null)
		/* called to draw a new portal at a defined location.
			_state determines which color icon_state to use.
			_time determines how many seconds the portal stays before despawning.
		*/
		if(_loc && !_loc.density)
		//	for(var/atom/a in _loc)
		//		if(a.density) return
			// if we get to here, there wasn't anything stopping the portal from being drawn!
			var/obj/hazard/portal/p = garbage.Grab(/obj/hazard/portal)
			p.icon_state	= "portal-open" //[active_game.portals.len ? "open" : "closed"]"
			p.owner			= _owner
			p.loc			= _loc
			p.color			= _color
			active_game.portals += p
			_owner.portals_out ++
			p.spawndel(_time*10)

obj/hazard
	portal
		icon				= 'game/misc_effects.dmi'
		icon_state			= "portal-open"
		appearance_flags	= NO_CLIENT_COLOR
		plane				= 2
		bound_x				= 3
		var/tmp/mob/owner

		Crossed(atom/movable/a)
			if(a.can_teleport && icon_state == "portal-open")
				flick("portal-use",src)
				a:portal(owner, src)
		GC()
			if(owner && istype(owner, /mob/player))
				owner:portals_out --
			active_game.portals -= src
			..()

mob/player
	var
		portal_limit	= 3	// max number of portals a player can make.
		portals_out		= 0	// number of portals a player has made.
		can_portalcast	= 1

	verb
		portal_beam()
			set hidden = 1
			if(!can_portalcast) return
			can_portalcast = 0
		//	world << ">> debug: portal cast!"
			// called to throw a portal out.
			if(portals_out >= portal_limit)
				// if the player has the max number of portals out, they can still cast one, but it will replace a random existing portal(owned by the player).
				for(var/obj/hazard/portal/p in active_game.portals)
					if(p.owner == src)
						p.GC()
						break
			// here we can go ahead and cast the beam now that we purged one of the existing ones.
			. = dir
			flick_arms("base-portal-cast")
		//	gs('portal.ogg')
			var/obj/projectile/p 	= throw_special( /obj/projectile/thrown/portal, . )
			p.loc 					= loc
			p.owner					= src
			p.accuracy				= 55
			p.sway					= 1
			p.color					= namecolor
			switch(.)
				if(NORTH)
					p.step_x	= step_x
					p.step_y	= step_y+16
				if(NORTHEAST)
					p.step_x	= step_x+16
					p.step_y	= step_y+16
				if(NORTHWEST)
					p.step_x	= step_x-8
					p.step_y	= step_y+16
				if(SOUTHEAST)
					p.step_x	= step_x+16
					p.step_y	= step_y-6
				if(SOUTHWEST)
					p.step_x	= step_x-8
					p.step_y	= step_y-6
				if(SOUTH)
					p.step_x	= step_x+6
					p.step_y	= step_y-6
				if(EAST)
					p.step_x	= step_x+16
					p.step_y	= step_y+6
				if(WEST)
					p.step_x	= step_x-8
					p.step_y	= step_y+6
			active_projectiles += p
			sleep 10
			can_portalcast	= 1
