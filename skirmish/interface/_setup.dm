
client/fps	= 60
var/fonto = 'UberBit7.ttf'
world
	name 			= "Feed -"
	view			= "13x10" //"25x20"  400x200 ||  13x10           208x160
	mob 			= /mob/player
	status			= "<b>Open Testing</b>"
	turf			= /turf/grass
	map_format		= TOPDOWN_MAP
	loop_checks 	= 0
	tick_lag		= 0.4
	icon_size		= 16
	fps				= 40
	hub				= "Kumorii.Feed"
	hub_password	= "feedcreep17"

	New()
		..()
		log = file("feedlog.txt")
		setup_world()
		active_game.wait_loop()
proc
	setup_world()
		pre_recycle()
		ai_loop()
		projectile_loop()
//		support_loop()


mob
	verb
		toggle_chat()
			set hidden = 1
			if(winget(src, "pane-map.mapchat", "is-visible")=="true")
				winset(src, "pane-map.mapchat", "is-visible=\"false\"")
				winset(src, "pane-map.mapinput", "is-visible=\"false\"")
			else
				winset(src, "pane-map.mapchat", "is-visible=\"true\"")
				winset(src, "pane-map.mapinput", "is-visible=\"true\"")