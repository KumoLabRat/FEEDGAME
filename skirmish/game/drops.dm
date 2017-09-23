

atom/movable
	proc
		drop_loot()
			/* called to drop random loot from a movable atom.
			*/
			var/obj/item/drop_this = get_drop()
			if(drop_this)
				var/obj/item/_drop = garbage.Grab(drop_this)
				if(prob(_drop.drop_rate)) // if it's spawn_rate passes we can spawn it.
					_drop.loc = loc
					_drop.spawndel(600)
				else _drop.GC()	// otherwise, it's back to the garbage lists.
			drop_cash(rand(5,30))




proc
	get_drop()
		var/obj/item/drop_this = /obj/item/health_pack
		switch(rand(1,3))
			if(1) // tier one items
				drop_this 			= pick( /obj/item/health_pack, /obj/item/gun/kobra, /obj/item/special/molotov, /obj/item/shield_tier1, /obj/item/special/glowsticks, \
											/obj/item/gun/shotgun, /obj/item/special/grenade, /obj/item/special/sticky_grenade, /obj/item/special/boomerang )
			if(2)
				if(prob(75))
					drop_this 		= pick( /obj/item/health_pack, /obj/item/gun/edge_lord, /obj/item/gun/spas_12, /obj/item/shield_tier2, /obj/item/gun/krossbow,\
											/obj/item/gun/pink_dream, /obj/item/special/fireball, /obj/item/special/cowbell, /obj/item/gun/uzi, /obj/item/special/mine)
			if(3)
				if(prob(50))
					drop_this		= pick( /obj/item/revive_pack, /obj/item/shield_tier3, /obj/item/special/airstrike, /obj/item/gun/hellsredeemer, \
										/obj/item/gun/flamethrower, /obj/item/gun/red_baron )
		return drop_this


obj
	item

		icon				= 'items.dmi'
		is_garbage			= 1
		appearance_flags	= NO_CLIENT_COLOR
		layer				= OBJ_LAYER
		var
			drop_rate		= 100
			can_float_text	= 1

		Crossed(atom/movable/a)
			if(istype(a, /mob/player))
				var/mob/player/p = a
				if(p.health && (p in active_game.participants))
					effect(p)
		proc
			effect(mob/player/p)
				/*
					the effect that gets carried out on the player when crossing the item.
				*/
		health_pack
			icon_state	= "healthkit"
			drop_rate	= 100
			effect(mob/player/p)
				if(p.health < p.base_health)
					if(p.on_fire) p.on_fire = 0
					p.edit_health(round(p.base_health/5))
					if(can_float_text)
						can_float_text = 0
						float_text(loc, "<font color = #55F047>HP++", 1)
						can_float_text = 1
					GC()

		revive_pack
			icon_state	= "revive"
			drop_rate	= 70
			effect(mob/player/p)
				if(p.has_revive < 2)
					p.has_revive ++
					if(can_float_text)
						can_float_text = 0
						float_text(loc, "<font color = #00ECFF>REVIVE++", 1)
						can_float_text = 1
					GC()
		cash
			icon_state		= "cash1"
			drop_rate		= 60
			var/cashamount	= 0	// how much cash the drop is worth!
			effect(mob/player/p)
				var/cash_fade/fade = garbage.Grab(/cash_fade)
				fade._fade(cashamount,p)
				p.give_points(cashamount)
			//	world << "debug: [p] +$[cashamount]"
				GC()

		shield_tier1
			icon_state	= "shield1"
			drop_rate	= 50
			effect(mob/player/p)
				if(p.shield < 3)
					p.shield(1, 0)
					GC()
		shield_tier2
			icon_state	= "shield2"
			drop_rate	= 50
			effect(mob/player/p)
				if(p.shield < 3)
					p.shield(2, 0)
					GC()
		shield_tier3
			icon_state	= "shield3"
			drop_rate	= 50
			effect(mob/player/p)
				if(p.shield < 3)
					p.shield(3, 0)
					GC()

		gun
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
				step		= 3
			pistol
				icon_state	= "pistol"
				state		= "pistol"
				gun_type	= /obj/weapon/gun/pistol
				step		= 3
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Pistol", 1, p, src)
					can_float_text = 1
			elverde
				icon_state	= "elverde"
				state		= "elverde"
				gun_type	= /obj/weapon/gun/el_verde
				step		= 4
				drop_rate	= 7
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>El Verde", 1, p, src)
					can_float_text = 1
			kobra
				icon_state	= "kobra"
				state		= "kobra"
				gun_type	= /obj/weapon/gun/kobra
				step		= 3
				drop_rate	= 100
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Kobra", 1, p, src)
					can_float_text = 1
			edge_lord
				icon_state	= "3dg3-10rd"
				state		= "3dg3-10rd"
				gun_type	= /obj/weapon/gun/edge_lord
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>3dg3 10rd", 1, p, src)
					can_float_text = 1
			pink_dream
				icon_state	= "pinkdream"
				state		= "pinkdream"
				gun_type	= /obj/weapon/gun/pink_dream
				step		= 4
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Pink Dream", 1, p, src)
					can_float_text = 1
			krossbow
				icon_state	= "krossbow"
				state		= "krossbow"
				gun_type	= /obj/weapon/gun/krossbow
				step		= 5
				drop_rate	= 80
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Krossbow", 1, p, src)
					can_float_text = 1
			uzi
				icon_state	= "uzi"
				state		= "uzi"
				gun_type	= /obj/weapon/gun/uzi
				step		= 4
				drop_rate	= 50
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Uzi", 1, p, src)
					can_float_text = 1
			red_baron
				icon_state	= "redbaron"
				state		= "redbaron"
				gun_type	= /obj/weapon/gun/red_baron
				step		= 3
				drop_rate	= 25
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Red Baron", 1, p, src)
					can_float_text = 1
			shotgun
				icon_state	= "shotgun"
				state		= "shotgun"
				gun_type	= /obj/weapon/gun/shotgun
				step		= 3
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Shotgun", 1, p, src)
					can_float_text = 1
			hellsredeemer
				icon_state	= "hellredeemer"
				state		= "hellredeemer"
				gun_type	= /obj/weapon/gun/hellsredeemer
				step		= 2
				drop_rate	= 25
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Hell's Redeemer", 1, p, src)
					can_float_text = 1
			flamethrower
				icon_state	= "flamethrower"
				state		= "flamethrower"
				gun_type	= /obj/weapon/gun/flamethrower
				step		= 2
				drop_rate	= 25
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Flamethrower", 1, p, src)
					can_float_text = 1
			spas_12
				icon_state	= "spas12"
				state		= "spas12"
				gun_type	= /obj/weapon/gun/spas_12
				step		= 2
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>SPAS12", 1, p, src)
					can_float_text = 1
			lysergia
				icon_state	= "lysergia"
				state		= "lysergia"
				gun_type	= /obj/weapon/gun/lysergia
				step		= 4
				drop_rate	= 5
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>Lysergia", 1, p, src)
					can_float_text = 1
			stalker
				icon_state	= "stalker"
				state		= "stalker"
				gun_type	= /obj/weapon/gun/stalker
				step		= 3
				drop_rate	= 5
				pixel_x		= -4
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>Stalker", 1, p, src)
					can_float_text = 1
			wicked_one
				icon_state	= "wickedone"
				state		= "wickedone"
				gun_type	= /obj/weapon/gun/wicked_one
				step		= 4
				drop_rate	= 5
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>Wicked One", 1, p, src)
					can_float_text = 1
			jabberjaw
				icon_state	= "jabberjaw"
				state		= "jabberjaw"
				gun_type	= /obj/weapon/gun/jabberjaw
				step		= 4
				drop_rate	= 8
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>Jabberjaw", 1, p, src)
					can_float_text = 1
			gherkin
				icon_state	= "gherkin"
				state		= "gherkin"
				gun_type	= /obj/weapon/gun/gherkin
				step		= 4
				drop_rate	= 10
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>The Gherkin", 1, p, src)
					can_float_text = 1
			tako
				icon_state	= "tako"
				state		= "tako"
				gun_type	= /obj/weapon/gun/tako
				step		= 4
				drop_rate	= 10
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #47F91F>TAKOS", 1, p, src)
					can_float_text = 1
		melee
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
				step		= 2

		special
			var/tmp
				state		= null // the icon_state tag for the weapon.
				gun_type	= null // the path of the gun's weapon datum
			boomerang
				icon_state 	= "boomerang"
				state		= "boomerang"
				gun_type 	= /obj/weapon/special/boomerang
				drop_rate 	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Boomerang", 1, p, src)
					can_float_text = 1
			kaboomerang
				icon_state 	= "kaboomerang"
				state		= "kaboomerang"
				gun_type 	= /obj/weapon/special/boomerang/kaboomerang
				drop_rate 	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Kaboomerang", 1, p, src)
					can_float_text = 1
			grenade
				icon_state	= "grenade"
				state		= "grenade"
				gun_type	= /obj/weapon/special/grenade
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Grenades", 1, p, src)
					can_float_text = 1
			sticky_grenade
				icon_state	= "sticky_grenade"
				state		= "sticky_grenade"
				gun_type	= /obj/weapon/special/grenade/sticky_grenade
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Sticky 'Nades", 1, p, src)
					can_float_text = 1
			gravity_grenade
				icon_state	= "gravade"
				state		= "gravade"
				gun_type	= /obj/weapon/special/grenade/gravity_grenade
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Gravades", 1, p, src)
					can_float_text = 1
			molotov
				icon_state	= "molotov"
				state		= "molotov"
				gun_type	= /obj/weapon/special/molotov
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Molotovs", 1, p, src)
					can_float_text = 1
			airstrike
				icon_state	= "airstrike"
				state		= "airstrike"
				gun_type	= /obj/weapon/special/airstrike
				drop_rate	= 30
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Airstrikes", 1, p, src)
					can_float_text = 1
			fireball
				icon_state	= "fireball"
				state		= "fireball"
				gun_type	= /obj/weapon/special/fireball
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Fireballs", 1, p, src)
					can_float_text = 1
			glowsticks
				icon_state	= "glowsticks"
				state		= "glowsticks"
				gun_type	= /obj/weapon/special/glowsticks
				drop_rate	= 80
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Glowsticks", 1, p, src)
					can_float_text = 1
			cowbell
				icon_state	= "cowbell"
				state		= "cowbell"
				gun_type	= /obj/weapon/special/cowbell
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Cowbell", 1, p, src)
					can_float_text = 1
			mine
				icon_state	= "mine"
				state		= "mine"
				gun_type	= /obj/weapon/special/mine
				drop_rate	= 75
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Landmines", 1, p, src)
					can_float_text = 1
			gasoline
				icon_state	= "gasoline"
				state		= "gasoline"
				gun_type	= /obj/weapon/special/gasoline
				drop_rate	= 15
				effect(mob/player/p)
					if(!can_float_text) return
					can_float_text = 0
					float_text(loc, "\[<font color = #FAC324>Interact</font>] - <font color = #E1E1E1>Gasoline", 1, p, src)
					can_float_text = 1