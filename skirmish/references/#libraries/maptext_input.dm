obj/input_box
	name			= "default"
	layer			= EFFECTS_LAYER
	mouse_opacity	= 2
	icon = 'interface/ui/UIGeneration.dmi'
	icon_state = "MI"
	plane = 5
	layer = HUD_LAYER + 5
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
	var/tmp
		text2disp	= ""	// the raw text that has been put into the input.
		is_password	= 0		// 1 if the input should hide the input date ("********" instead of "password")
		max_length	= 16		// the maximum characters that can be input.
		disabled	= 0		// 1 if it's disabled.
		enter_context = null
		UI/parent
		list/sides = new
	MouseEntered()
		var mob/player/p = usr
		p.purge_dancers()
		dance(p)
		for(var/atom/a in sides)
			a.dance(p)
		if(p.Highlight) p.Highlight.position = 2
	New(UI/Parent)
		..()
		spawn()
			var/icon/i = icon(icon)
			i.Scale(maptext_width,maptext_height)
			i += rgb(0, 0, 0)
			icon = i
			parent = Parent
			if(parent) parent.pieces += src
			animate(src, alpha = 255, time = 8)
			maptext_y = 1

	Click()
		if(disabled) return
		var/mob/player/p = usr
		if(p.active_input)
			if(p.active_input == src) return
			if(p.active_input.is_password)
				var/pass_disp
				for(var/i=1, i <= length(p.active_input.text2disp), i++)
					var/tmpdisp = "[copytext(pass_disp,1)]"
					pass_disp = "[tmpdisp]*"
				p.active_input.maptext	= "<p class='vendor'>[pass_disp]</font>"
			else
				p.active_input.maptext	= "<p class='vendor'>[p.active_input.text2disp]</font>"
		winset(p,"default","macro=\"textinput\"")

		p.active_input = src
		p.enter_context = enter_context
		if(p.active_input.is_password)
			var/pass_disp
			for(var/i=1, i <= length(p.active_input.text2disp), i++)
				var/tmpdisp = "[copytext(pass_disp,1)]"
				pass_disp = "[tmpdisp]*"
			p.active_input.maptext	= "<p class='vendor'>[pass_disp] <"
		else
			p.active_input.maptext	= "<p class='vendor'>[p.active_input.text2disp] <"


	proc
		get_text2disp()
			/*
				this returns the raw, unedited text that was entered into the field.
			*/
			return text2disp


client/Click(object)
	..()
	var/mob/player/p = mob
	if(p.active_input && !istype(object, /obj/input_box))
		// if the player has an input box selected but clicks elsewhere on the map, deselect the input box.
		if(p.active_input.is_password)
			var/pass_disp
			for(var/i=1, i <= length(p.active_input.text2disp), i++)
				var/tmpdisp = "[copytext(pass_disp,1)]"
				pass_disp = "[tmpdisp]*"
			p.active_input.maptext	= "<p class='vendor'>[pass_disp]</font>"
		else
			if(p.enter_context == "Choose Name")
				p.check_name()
			else
				p.active_input.maptext = "<p class='vendor'><font color = green>[p.active_input.text2disp]"
				p.active_input = null
				p.enter_context = null



mob/player
	var/tmp
		obj/input_box/active_input	= null	// the currently selected input box, if any.
		shift_down					= 0		// 1 if the shift key is down.
		backspace_timeout			= 0

	proc
		check_name()
			var/check = 0
			if(playerNames)
				for(var/i = 1 to playerNames.len)
					if("[playerNames[i]]" == "[active_input.text2disp]")
						nameGood = 0
						active_input.maptext = "<p class='vendor'><font color = red>NAME TAKEN!"
						check = 1
						break
			if(!check)
				if(length(active_input.text2disp) < 3)
					nameGood = 0
					active_input.maptext = "<p class='vendor'><font color = red>NOT LONG ENOUGH!"
				else
					nameGood = active_input.text2disp
					active_input.maptext = "<p class='vendor'><font color = green>[active_input.text2disp]"
			active_input = null
			enter_context = null
			winset(src,"default","macro=\"vendor\"")
		draw_input(_name, _loc, _width = 240, _height = 20, _default_text, _offset = 0, _is_password = 0, _enter_context, UI/_parent)
			if(_name && _loc)
				var/obj/input_box/i_box	= new()
				i_box.name				= _name
				i_box.screen_loc		= _loc
				i_box.maptext_width		= _width
				i_box.maptext_height	= _height
				i_box.maptext			= _default_text
				i_box.maptext_y			= _offset
				i_box.is_password		= _is_password
				i_box.enter_context		= _enter_context
				client.screen += i_box
				var/UI/LSide = garbage.Grab(/UI/)
				LSide.icon_state = "mil"
				LSide.screen_loc = "CENTER - 4,CENTER-3"
				LSide.layer = HUD_LAYER + 5
				client.screen += LSide
				var/UI/RSide = garbage.Grab(/UI/)
				RSide.icon_state = "mir"
				RSide.screen_loc = "CENTER + 4,CENTER-3"
				RSide.layer = HUD_LAYER + 5
				client.screen += RSide
				i_box.sides += LSide
				i_box.sides += RSide
				if(_parent)
					_parent.pieces += i_box
					_parent.pieces += LSide
					_parent.pieces += RSide

		get_ibox(i_box = "empty")
			// called to retrieve an input box with the given name.
			for(var/obj/input_box/i in client.screen)
				if(i.name == i_box)
					return i
		unselect_ibox(obj/input_box/i)
			if(i.is_password)
				var/pass_disp
				for(var/j=1, j <= length(i.text2disp), j++)
					var/tmpdisp = "[copytext(pass_disp,1)]"
					pass_disp = "[tmpdisp]*"
				i.maptext	= "<p class='vendor'>[pass_disp]</font>"
			else
				i.maptext = "<p class='vendor'>[i.text2disp]"
			active_input = null
			enter_context = null

		erase_input(_id_tag = "empty")
			if(_id_tag)
				for(var/obj/input_box/m in client.screen)
					if(m.name == _id_tag)
						animate(m, alpha = 0, time = 4, loop = 1)
						sleep 6
						del m
						break