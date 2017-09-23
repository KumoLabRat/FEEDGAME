proc
	throw_special(obj/_type, _dir, origin)
		if(_type && _dir)
			var/obj/projectile/thrown/p 	= garbage.Grab(_type)
			p.dir							= _dir
			p.sway							= pick(-1,1)
			if(istype(p,/obj/projectile/thrown/boomerang)) p:origin = origin
			return p

obj
	weapon
		special


	/*****************************************************************************************************
		Thrown		these are skills/weapons that get thrown or shot by the user.	*/


			glowsticks
				recharge		= 10
				drop_type		= /obj/item/special/glowsticks

				use(mob/m)
					can_use 	= 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/glowstick, .)
					p.loc 					= m.loc
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1


			fireball
				recharge		= 3
				drop_type		= /obj/item/special/fireball

				use(mob/m)
					can_use 	= 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= get_projectile("fireball", . , -8, 1.5, 5, 123, 1, 4, 1)
					if(m.client) m:flick_arms("base-fireball")
					p.loc 					= m.loc
					m.gs('fireball.ogg')
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1


			airstrike
				recharge		= 100
				drop_type		= /obj/item/special/airstrike

				use(mob/m)
					can_use 	= 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/airstrike, . )
					if(m.client) m:flick_arms("base-airstrike")
					p.loc 					= m.loc
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1

			smoker_g
				recharge	= 30
			//	drop_type	= /obj/item/special/smoker_g

				use(mob/m)
					can_use = 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/smoker_g, . )
				//	if(m.client) m:flick_arms("base-flashbang")
					p.loc 					= m.loc
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1


			grenade
				recharge	= 20
				drop_type	= /obj/item/special/grenade

				use(mob/m)
					can_use = 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/grenade, . )
					if(m.client) m:flick_arms("base-grenade")
					p.loc 					= m.loc
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1


				sticky_grenade
					drop_type		= /obj/item/special/sticky_grenade

					use(mob/m)
						can_use 	= 0
						. 			= m.dir
						if(m.client)
							. 		= m:trigger_dir
							m.dir 	= .

						var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/grenade/sticky_grenade, . )
						if(m.client) m:flick_arms("base-stickygrenade")
						p.loc 					= m.loc
						switch(.)
							if(NORTH)
								p.step_x		= m.step_x
								p.step_y		= m.step_y+16
							if(NORTHEAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y+16
							if(NORTHWEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y+16
							if(SOUTHEAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y-6
							if(SOUTHWEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y-6
							if(SOUTH)
								p.step_x		= m.step_x+6
								p.step_y		= m.step_y-6
							if(EAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y+6
							if(WEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y+6
						p.owner					= m
						active_projectiles += p
						spawn(recharge)
							can_use 			= 1
				gravity_grenade
					drop_type		= /obj/item/special/gravity_grenade

					use(mob/m)
						can_use 	= 0
						. 			= m.dir
						if(m.client)
							. 		= m:trigger_dir
							m.dir 	= .

						var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/grenade/gravity_grenade, . )
						if(m.client) m:flick_arms("base-gravade")
						p.loc 					= m.loc
						switch(.)
							if(NORTH)
								p.step_x		= m.step_x
								p.step_y		= m.step_y+16
							if(NORTHEAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y+16
							if(NORTHWEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y+16
							if(SOUTHEAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y-6
							if(SOUTHWEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y-6
							if(SOUTH)
								p.step_x		= m.step_x+6
								p.step_y		= m.step_y-6
							if(EAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y+6
							if(WEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y+6
						p.owner					= m
						active_projectiles += p
						spawn(recharge)
							can_use 			= 1
			molotov
				recharge		= 40
				drop_type		= /obj/item/special/molotov

				use(mob/m)
					can_use 	= 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/molotov, . )
					if(m.client) m:flick_arms("base-molotov")
					p.loc 					= m.loc
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1


			boomerang
				drop_type		= /obj/item/special/boomerang

				use(mob/m)
					can_use 	= 0
					. 			= m.dir
					if(m.client)
						. 		= m:trigger_dir
						m.dir 	= .

					var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/boomerang, . , origin = src)
					if(m.client) m:flick_arms("base-boomerang")
					p.loc 					= m.loc
					switch(.)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p


				kaboomerang
					drop_type		= /obj/item/special/kaboomerang

					use(mob/m)
						can_use 	= 0
						. 			= m.dir
						if(m.client)
							. 		= m:trigger_dir
							m.dir 	= .

						var/obj/projectile/p 	= throw_special(/obj/projectile/thrown/boomerang/kaboomerang, . , origin = src)
						if(m.client) m:flick_arms("base-kaboomerang")
						p.loc 					= m.loc
						switch(.)
							if(NORTH)
								p.step_x		= m.step_x
								p.step_y		= m.step_y+16
							if(NORTHEAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y+16
							if(NORTHWEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y+16
							if(SOUTHEAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y-6
							if(SOUTHWEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y-6
							if(SOUTH)
								p.step_x		= m.step_x+6
								p.step_y		= m.step_y-6
							if(EAST)
								p.step_x		= m.step_x+16
								p.step_y		= m.step_y+6
							if(WEST)
								p.step_x		= m.step_x-8
								p.step_y		= m.step_y+6
						p.owner					= m
						active_projectiles += p


	/*****************************************************************************************************
		Useable		these are skills/weapons that can be used and have an effect. You don't throw or drop anything.	*/


			cowbell
				recharge		= 30
				drop_type		= /obj/item/special/cowbell

				use(mob/m)
					can_use		= 0
					m.gs('cowbell.ogg')
					m.cowbell()
					spawn(recharge)
						can_use = 1


	/*****************************************************************************************************
		Placeables		these are skills/weapons that get placed on the ground as traps to be walked over.	*/


			mine
				recharge	= 100
				drop_type	= /obj/item/special/mine

				use(mob/m)
					can_use = 0
					for(var/obj/hazard/h in m.loc)
						if(h) . = 1
					if(!.)
						var/obj/hazard/mine/p	= garbage.Grab(/obj/hazard/mine)
						p.loc					= m.loc
						p.owner					= m
						p.alpha					= 255
						spawn(recharge)
							can_use 			= 1
					else can_use 				= 1
			gasoline
				recharge	= 0.5
				drop_type	= /obj/item/special/gasoline

				use(mob/m)
					can_use = 0
					for(var/obj/hazard/h in m.loc)
						if(h) . ++
					if(. < 5)
						var/obj/hazard/oil/p	= garbage.Grab(/obj/hazard/oil)
						p.loc					= m.loc
						p.transform				= matrix()/2
						p.icon_state			= "oil"
						p.alpha					= 0
						p.pixel_y				= 8
						p.step_x				= rand(-8,8)
						p.step_y				= rand(-8,8)
						p.owner					= m
						animate(p, alpha = 255, transform = matrix(), pixel_y = 0, time = 1, loop = 0)
						spawn(recharge)
							can_use 			= 1
					else can_use 				= 1


	/*****************************************************************************************************
		NPC-only skills		these are abilities that players will never have that only NPCs can use.	*/


			shadowball
				recharge = 3

				use(mob/m)
					can_use 				= 0
					var/obj/projectile/p 	= get_projectile("shadowball", m.dir, -8, 0.5, 0, 123, 1, 4, 1)
					p.loc 					= m.loc
					m.gs('fireball.ogg')
					switch(m.dir)
						if(NORTH)
							p.step_x		= m.step_x
							p.step_y		= m.step_y+16
						if(NORTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+16
						if(NORTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+16
						if(SOUTHEAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y-6
						if(SOUTHWEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y-6
						if(SOUTH)
							p.step_x		= m.step_x+6
							p.step_y		= m.step_y-6
						if(EAST)
							p.step_x		= m.step_x+16
							p.step_y		= m.step_y+6
						if(WEST)
							p.step_x		= m.step_x-8
							p.step_y		= m.step_y+6
					p.owner					= m
					active_projectiles += p
					spawn(recharge)
						can_use 			= 1


			fireblast
				recharge = 7

				use(mob/m)
					can_use 				= 0
					. 						= m.dir
					for(var/i = 1 to 3)
						var/obj/projectile/p
						if(i == 1) p 		= get_projectile("fireball", . , -10, 1.5, 0, 123, 100, 2, 1)	// center
						if(i == 2) p 		= get_projectile("fireball", . , -10, 1.5, 0, 123, 10, 2, 1)	// left
						if(i == 3) p 		= get_projectile("fireball", . , -10, 1.5, 0, 123, 10, 2, -1)	// right
						p.loc 				= m.loc
						m.gs('fireball.ogg')
						switch(.)
							if(NORTH)
								p.step_x	= m.step_x
								p.step_y	= m.step_y+16
							if(NORTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+16
							if(NORTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+16
							if(SOUTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y-6
							if(SOUTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y-6
							if(SOUTH)
								p.step_x	= m.step_x+6
								p.step_y	= m.step_y-6
							if(EAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+6
							if(WEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						p.owner				= m
						active_projectiles += p
					spawn(recharge)
						can_use 			= 1


			quadbeam
				recharge = 10

				use(mob/m)
					can_use					= 0
					m.move_disabled			= 1
					var/obj/projectile/p1 	= get_projectile("laser2", NORTH, -15, 1.5, 65, 120, 1, 4, 1)
					p1.loc					= m.loc
					p1.step_x				= m.step_x
					p1.step_y				= m.step_y+7
					p1.owner				= m
					var/obj/projectile/p2 	= get_projectile("laser2", SOUTH, -15, 1.5, 65, 120, 1, 4, 1)
					p2.loc					= m.loc
					p2.step_x				= m.step_x
					p2.step_y				= m.step_y+7
					p2.owner				= m
					var/obj/projectile/p3 	= get_projectile("laser2", EAST, -15, 1.5, 65, 120, 1, 4, 1)
					p3.loc					= m.loc
					p3.step_x				= m.step_x
					p3.step_y				= m.step_y+7
					p3.owner				= m
					var/obj/projectile/p4 	= get_projectile("laser2", WEST, -15, 1.5, 65, 120, 1, 4, 1)
					p4.loc					= m.loc
					p4.step_x				= m.step_x
					p4.step_y				= m.step_y+7
					p4.owner				= m
					active_projectiles += p1
					active_projectiles += p2
					active_projectiles += p3
					active_projectiles += p4
					sleep recharge/2
					m.move_disabled			= 0
					sleep recharge/2
					can_use					= 1


			xbeam
				recharge = 10

				use(mob/m)
					can_use 				= 0
					m.move_disabled			= 1
					var/obj/projectile/p1 	= get_projectile("laser2", NORTHEAST, -15, 1.5, 65, 120, 1, 4, 1)
					p1.loc					= m.loc
					p1.step_x				= m.step_x
					p1.step_y				= m.step_y+7
					p1.owner				= m
					var/obj/projectile/p2 	= get_projectile("laser2", SOUTHWEST, -15, 1.5, 65, 120, 1, 4, 1)
					p2.loc					= m.loc
					p2.step_x				= m.step_x
					p2.step_y				= m.step_y+7
					p2.owner				= m
					var/obj/projectile/p3 	= get_projectile("laser2", SOUTHEAST, -15, 1.5, 65, 120, 1, 4, 1)
					p3.loc					= m.loc
					p3.step_x				= m.step_x
					p3.step_y				= m.step_y+7
					p3.owner				= m
					var/obj/projectile/p4 	= get_projectile("laser2", NORTHWEST, -15, 1.5, 65, 120, 1, 4, 1)
					p4.loc					= m.loc
					p4.step_x				= m.step_x
					p4.step_y				= m.step_y+7
					p4.owner				= m
					active_projectiles += p1
					active_projectiles += p2
					active_projectiles += p3
					active_projectiles += p4
					sleep recharge/2
					m.move_disabled			= 0
					sleep recharge/2
					can_use					= 1


			dopple
				recharge = 50

				use(mob/m)
					if(istype(m, /mob/npc/hostile/doppelganger) && m:target && m:target.can_dopple)
						var/mob/npc/hostile/doppelganger/d	= m
						animate(d, alpha = 0, color = "white", transform = matrix()*2, time = 5)
						if(m:target.client)
							d.skill1 						= new d.target:equipped_weapon.type
							d.skill2 						= new d.target:equipped_special.type
						d.overlays.Remove(d.hair)
						d.hair.icon_state 					= d.target:hair.icon_state
						d.hair.pixel_x						= 0
						if(d.hair.icon_state == "style11" || d.hair.icon_state == "style13" || d.hair.icon_state == "style14" || d.hair.icon_state == "style16"|| d.hair.icon_state == "style31")
							d.hair.pixel_x = -5
						if(d.hair.icon_state == "micke1" || d.hair.icon_state == "style21")
							d.hair.pixel_x = -4
						d.overlays.Add(d.hair)
						d.overlays.Remove(d.shirt)
						d.shirt.icon_state 					= d.target:shirt.icon_state
						d.overlays.Add(d.shirt)
						d.overlays.Remove(d.arms)
						d.arms.icon_state 					= "[d.target:arms.icon_state]"
						d.overlays.Add(d.arms)
						d.overlays.Remove(d.pants)
						d.pants.icon_state 					= d.target:pants.icon_state
						d.overlays.Add(d.pants)
						d.overlays.Remove(d.vanity)
						d.vanity.icon_state					= d.target:vanity.icon_state
						d.overlays.Add(d.vanity)
						d.overlays.Remove(d.nametag)
						d.nametag.change_text("[d.target]")
						d.overlays.Add(d.nametag)
						animate(d, alpha = 255, color = null, transform = matrix(), time = 5)
						sleep 15



