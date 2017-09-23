mob/dummy
	icon = '_Zombie.dmi'
	icon_state = "feeder"
	step_size = 1
	layer = MOB_LAYER + 2
	New()
		icon += rgb(rand(130,200),rand(130,200),rand(130,200))
		walk_rand(src,world.tick_lag * 4,step_size)

mob/player
	var tmp
		UI/Container
			Main_Menu
			Credits_Menu
		list/menu_buttons = new
		obj/screen_obj/button/selected_button
	proc
		init_main_menu()
			Main_Menu = GenerateContainer(/UI/Container,0,6,6,4,4,"Main Menu")
			init_menu_buttons()

		init_menu_buttons()
			menu_buttons += new /obj/screen_obj/button/Play("CENTER,CENTER+3")
		//	menu_buttons += new /obj/screen_obj/button/Options("CENTER,CENTER+1")
		//	menu_buttons += new /obj/screen_obj/button/Credits("CENTER,CENTER-1")
		//	menu_buttons += new /obj/screen_obj/button/Quit("CENTER,CENTER-3")
			client.screen += menu_buttons

obj/screen_obj/button
	plane = 5
	maptext_width = 192
	maptext_height = 64
	maptext_y = -24
	mouse_opacity = 2
	MouseEntered()
		var mob/player/p = usr
		Highlight(p)
	New(_loc,obj/screen_obj/button/Credits_Content/_partner) // sets location, displaces if text, sets partner for scroll
		screen_loc = _loc
		if(_partner && _partner != 0)
			var/obj/screen_obj/button/Credits_Content/this = src
			this.partner = _partner
			_partner.partner = this
			this.transform = matrix(-4,0,MATRIX_TRANSLATE)
			_partner.transform = matrix(-12,0,MATRIX_TRANSLATE)
		else if(_partner != 0)
			transform = matrix(-88,0,MATRIX_TRANSLATE)
		spawn FadeIn(src)
	Click(mob/player/p) // kill current menu
		p.client.screen -= p.menu_buttons
		p.menu_buttons.Cut()
	proc
		Highlight(mob/player/p) // expand text
			var/obj/screen_obj/button/old_button = p.selected_button
			if(old_button) old_button.Deselect()
			maptext = "<div class = 'menu-big'>[name]"
			p.selected_button = src
		Deselect() // shrink
			maptext = "<div class = 'menu'>[name]"
	Play
		maptext = "<div class = 'menu'>Play"
		Click()
			var/mob/player/p = usr
			p.DissassembleContainer(p.Main_Menu)
			..(p)
			p.load_save()
	Options
//		maptext = "<div class = 'menu'>Options"
	Credits
		maptext = "<div class = 'menu'>Credits"
		Click() // build the credits menu
			var/mob/player/p = usr
			var/text = credits[1]
			..(p)
			var/obj/left = new /obj/screen_obj/button/Credits_Content/Credits_Left("CENTER-5,CENTER:8",0)
			p.menu_buttons += left
			p.menu_buttons += new /obj/screen_obj/button/Back_to_Menu("CENTER,CENTER-3")
			p.menu_buttons += new /obj/screen_obj/button/Credits_Content/Credits_Right("CENTER+5,CENTER:8",left)
			p.client.screen += p.menu_buttons
			p.Credits_Menu = p.GenerateContainer(/UI/Container,0.3,5,5,2,3,"Credits",text = "[text]", dark = 1)
			p.DescBox.maptext_x = -3
	Quit
		maptext = "<div class = 'menu'>Quit"
	Back_to_Menu
		maptext = "<div class = 'menu'>Back to Menu"
		Click()
			var/mob/player/p = usr
			..(p)
			p.DissassembleContainer(p.Credits_Menu)
			p.init_menu_buttons()
	Credits_Content
		icon = 'Arrows.dmi'
		var
			obj/screen_obj/button/Credits_Content/partner
			page = 1
		Click(mob/player/p)
			if(page > credits.len) page = 1
			else if(page == 0) page = credits.len
			partner.page = page
			var/text = credits[page]
			p.DescBox.maptext = "[text]"
		Highlight(mob/player/p)
			var/obj/screen_obj/button/old_button = p.selected_button
			if(old_button) old_button.Deselect()
			p.selected_button = src
		Credits_Left
			appearance_flags = PIXEL_SCALE
			icon_state = "left"
			Click()
				var/mob/player/p = usr
				page--
				..(p)
			Highlight()
				..()
				icon_state = "left-big"
			Deselect() icon_state = "left"
		Credits_Right
			appearance_flags = PIXEL_SCALE
			icon_state = "right"
			Click()
				var/mob/player/p = usr
				page++
				..(p)
			Highlight()
				..()
				icon_state = "right-big"
			Deselect() icon_state = "right"