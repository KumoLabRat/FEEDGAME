
mob/player
	appearance_flags	= KEEP_TOGETHER
	icon				= '_BaseT.dmi'
	icon_state			= "base-"
	density				= 1
	step_size			= 3
	bound_width			= 13
	bound_x				= 4
	can_dopple			= 1
	var
		obj/arms 		= new /obj/player/arms
		obj/shirt		= new /obj/player/shirt
		obj/pants		= new /obj/player/pants
		obj/hair 		= new /obj/player/hair
		obj/vanity		= new /obj/player/vanity
		obj/face		= new /obj/player/face
		obj/pl_indicator	= new /obj/player/indicator


		flicking		= 0	// set to 1 if the player is already flicking an icon state. Prevents a couple graphic issues.
		hair_lock		= 0	// set to 1 if the player shouldn't be allowed to customize their hair (useful when players have custom icons)

	proc
		draw_base()
			draw_planes()
			draw_nametag("[name]", level)
			if(namecolor) new_color(namecolor)
			refresh_hud()
			/* if you need to override certain base appearances for certain players, it's easiest to go about it this way.
			*/
			if(is_GM) pl_indicator.color = "ea51ff"
			overlays += arms
			overlays += shirt
			overlays += pants
			overlays += hair
			overlays += vanity
			overlays += face
			underlays += pl_indicator


		flick_arms(fstate = "base-")
			if(flicking) return
			flicking = 1
			var/ogstate = arms.icon_state
			overlays -= arms
			arms.icon_state = "[fstate]"
			overlays += arms
			sleep 1
			overlays -= arms
			arms.icon_state = "[ogstate]"
			overlays += arms
			flicking = 0


		arms_state(nstate = "base-")
			overlays -= arms
			arms.icon_state	= "[nstate]"
			overlays += arms


obj/player

	arms
		icon		= 'arms.dmi'
		pixel_x		= -16
		layer		= FLOAT_LAYER+0.23

	shirt
		icon		= '_Clothes.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.1
	pants
		icon		= '_Clothes.dmi'
		icon_state	= "pants"
		layer		= FLOAT_LAYER+0.1
	hair
		icon		= '_Hair.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.21
	face
		icon		= '_Face.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.20
	vanity
		icon		= 'vanity.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.22
	indicator
		icon				= 'game/misc_effects.dmi'
		icon_state			= "indicator"
		pixel_y				= -4
		pixel_x				= 1
		layer				= TURF_LAYER+0.3
		appearance_flags	= NO_CLIENT_COLOR | KEEP_APART