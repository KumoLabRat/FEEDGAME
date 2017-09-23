proc/FadeIn(atom/a)
	a.alpha = 0
	animate(a,alpha = 255,time = 8)

proc/FadeOut(atom/a)
	animate(a,alpha = 0,8,flags = ANIMATION_PARALLEL)

UI
	parent_type 	= /obj
	plane 			= 4
	layer 			= HUD_LAYER
	icon  			= 'interface/ui/UIGeneration.dmi'
	var
		tmp/list/pieces
	Container
		var/tmp/
			UI/Container/basePreview
			UI/BaseObject
				baseObject
				Background/baseBackground
			UI/Button/Done
				donebutton
				cancelbutton

/*//////// CONTAINER ARGUMENTS ////////////////
type - for if you ned a specific type of UI/Container (optional)
x1 - the leftmost side of the container
x2 - the rightmost side of the container
x3 - the distance from the right to the rightmost side of the container
y1 - the bottommost side of the container
y2 - the topmost side of the container
y3 - the distance from the top to the topmost side of the container
name - the name of the container, in case you need to look it up (optional)
parent - the parent of the container (optional)
text - the text of any text you're using (optional)
	WARNING: does not register any y value except for y1
text_icon - the icon file of the text you are using (optional)
y_Offset - the text's offset along the y axis (optional)
x_Offset - the text's offset along the x axis (optional)
dark - a darker version of a standard UI box (optional)
*//////////////////////////////////////////////



mob/player/proc/GenerateContainer(type,hudlayer,x1 = 1,x2 = 13,y1 = 1,y2 = 10,name,UI/parent,text,side_Left,side_Right,dark)
	if(text)
		//var/xx = (((x2 - x1) / 2) + 1)
		if(y2 == 100)
			var/UI/Tube = garbage.Grab(/UI/)
			Tube.icon_state = "TUBE"
			if(x1 < 0) Tube.screen_loc = "CENTER + [-x1],CENTER + [y1]"
			else Tube.screen_loc = "CENTER - [x1],CENTER + [y1]"
			Tube.layer = HUD_LAYER + hudlayer
			client.screen += Tube
			Tube.maptext_width = ((x1 + x2) + 1) * 16
			Tube.maptext = "[text]"
			Tube.maptext_y = 1
			Tube.layer = HUD_LAYER + hudlayer + 0.1
			var/icon/i = icon(Tube.icon)
			i.Scale(Tube.maptext_width,Tube.maptext_height)
			Tube.icon = i
			if(parent) parent.pieces += Tube
			if(side_Left)
				Tube.maptext_x = -14
				Tube.maptext_width += 16
				var/UI/LSide = garbage.Grab(/UI/)
				LSide.icon_state = "tubel"
				LSide.screen_loc = "CENTER - [x1 + 1],CENTER + [y1]"
				LSide.layer = HUD_LAYER + hudlayer
				client.screen += LSide
				if(parent) parent.pieces += LSide
				FadeIn(LSide)
			if(side_Right)
				Tube.maptext_width += 16
				var/UI/RSide = garbage.Grab(/UI/)
				RSide.icon_state = "tuber"
				RSide.screen_loc = "CENTER + [x2 + 1],CENTER + [y1]"
				RSide.layer = HUD_LAYER + hudlayer
				client.screen += RSide
				if(parent) parent.pieces += RSide
				FadeIn(RSide)
			FadeIn(Tube)
			return Tube
	var/UI/Container/c = garbage.Grab(type)
	c.pieces = new
	c.name = name
	if(text)
		var/UI/Text = garbage.Grab(/UI/)
		Text.maptext_width = (((x1 + x2) + 1) * 16) - 13
		Text.maptext_height = ((y1 + y2) + 1) * 16
		Text.layer = HUD_LAYER + hudlayer + 0.1
		Text.x_offset = 7
		//Text.maptext_x = x_offset
		Text.transform = matrix(Text.x_offset,0,MATRIX_TRANSLATE)
		Text.maptext_y = 1
		Text.maptext = "[text]"
		Text.screen_loc = "CENTER - [x1],CENTER - [y1]"
		client.screen += Text
		if(parent) parent.pieces += Text
		else c.pieces += Text
		DescBox = Text
		FadeIn(DescBox)
	if(dark)
		var/UI/LBCorn = garbage.Grab(/UI/)
		LBCorn.icon_state = "DBL"
		LBCorn.screen_loc = "CENTER - [x1],CENTER - [y1]"
		//LBCorn.icon += color
		LBCorn.layer = HUD_LAYER + hudlayer
		c.pieces += LBCorn
		client.screen += LBCorn
		var/UI/RBCorn = garbage.Grab(/UI/)
		RBCorn.icon_state = "DBR"
		RBCorn.screen_loc = "CENTER + [x2],CENTER - [y1]"
		//RBCorn.icon += color
		RBCorn.layer = HUD_LAYER + hudlayer
		c.pieces += RBCorn
		client.screen += RBCorn
		var/UI/LTCorn = garbage.Grab(/UI/)
		LTCorn.icon_state = "DTL"
		LTCorn.screen_loc = "CENTER - [x1],CENTER + [y2]"
		//RBCorn.icon += color
		RBCorn.layer = HUD_LAYER + hudlayer
		c.pieces += LTCorn
		client.screen += LTCorn
		var/UI/RTCorn = garbage.Grab(/UI/)
		RTCorn.icon_state = "DTR"
		RTCorn.screen_loc = "CENTER + [x2],CENTER + [y2]"
		//RTCorn.icon += color
		RTCorn.layer = HUD_LAYER + hudlayer
		c.pieces += RTCorn
		client.screen += RTCorn
		var/UI/B = garbage.Grab(/UI/)
		B.icon_state = "DB"
		B.screen_loc = "CENTER - [x1 - 1],CENTER - [y1] to CENTER + [x2 - 1],CENTER - [y1]"
		//B.icon += color
		B.layer = HUD_LAYER + hudlayer
		c.pieces += B
		client.screen += B
		var/UI/T = garbage.Grab(/UI/)
		T.icon_state = "DT"
		T.screen_loc = "CENTER - [x1 - 1],CENTER + [y2] to CENTER + [x2 - 1],CENTER + [y2]"
		//T.icon += color
		T.layer = HUD_LAYER + hudlayer
		c.pieces += T
		client.screen += T
		var/UI/R = garbage.Grab(/UI/)
		R.icon_state = "DR"
		R.screen_loc = "CENTER + [x2],CENTER - [y1 - 1] to CENTER + [x2],CENTER + [y2 - 1]"
		//R.icon += color
		R.layer = HUD_LAYER + hudlayer
		c.pieces += R
		client.screen += R
		var/UI/L = garbage.Grab(/UI/)
		L.icon_state = "DL"
		L.screen_loc = "CENTER - [x1],CENTER - [y1 - 1] to CENTER - [x1],CENTER + [y2 - 1]"
		//L.icon += color
		L.layer = HUD_LAYER + hudlayer
		c.pieces += L
		client.screen += L
		var/UI/M = garbage.Grab(/UI/)
		M.icon_state = "DM"
		M.screen_loc = "CENTER - [x1 - 1],CENTER - [y1 - 1] to CENTER + [x2 - 1],CENTER + [y2 - 1]"
		//M.icon += color
		M.layer = HUD_LAYER + hudlayer
		c.pieces += M
		client.screen += M
	else
		var/UI/LBCorn = garbage.Grab(/UI/)
		LBCorn.icon_state = "BL"
		LBCorn.screen_loc = "CENTER - [x1],CENTER - [y1]"
		//LBCorn.icon += color
		LBCorn.layer = HUD_LAYER + hudlayer
		c.pieces += LBCorn
		client.screen += LBCorn
		var/UI/RBCorn = garbage.Grab(/UI/)
		RBCorn.icon_state = "BR"
		RBCorn.screen_loc = "CENTER + [x2],CENTER - [y1]"
		//RBCorn.icon += color
		RBCorn.layer = HUD_LAYER + hudlayer
		c.pieces += RBCorn
		client.screen += RBCorn
		var/UI/LTCorn = garbage.Grab(/UI/)
		LTCorn.icon_state = "TL"
		LTCorn.screen_loc = "CENTER - [x1],CENTER + [y2]"
		//RBCorn.icon += color
		RBCorn.layer = HUD_LAYER + hudlayer
		c.pieces += LTCorn
		client.screen += LTCorn
		var/UI/RTCorn = garbage.Grab(/UI/)
		RTCorn.icon_state = "TR"
		RTCorn.screen_loc = "CENTER + [x2],CENTER + [y2]"
		//RTCorn.icon += color
		RTCorn.layer = HUD_LAYER + hudlayer
		c.pieces += RTCorn
		client.screen += RTCorn
		var/UI/B = garbage.Grab(/UI/)
		B.icon_state = "B"
		B.screen_loc = "CENTER - [x1 - 1],CENTER - [y1] to CENTER + [x2 - 1],CENTER - [y1]"
		//B.icon += color
		B.layer = HUD_LAYER + hudlayer
		c.pieces += B
		client.screen += B
		var/UI/T = garbage.Grab(/UI/)
		T.icon_state = "T"
		T.screen_loc = "CENTER - [x1 - 1],CENTER + [y2] to CENTER + [x2 - 1],CENTER + [y2]"
		//T.icon += color
		T.layer = HUD_LAYER + hudlayer
		c.pieces += T
		client.screen += T
		var/UI/R = garbage.Grab(/UI/)
		R.icon_state = "R"
		R.screen_loc = "CENTER + [x2],CENTER - [y1 - 1] to CENTER + [x2],CENTER + [y2 - 1]"
		//R.icon += color
		R.layer = HUD_LAYER + hudlayer
		c.pieces += R
		client.screen += R
		var/UI/L = garbage.Grab(/UI/)
		L.icon_state = "L"
		L.screen_loc = "CENTER - [x1],CENTER - [y1 - 1] to CENTER - [x1],CENTER + [y2 - 1]"
		//L.icon += color
		L.layer = HUD_LAYER + hudlayer
		c.pieces += L
		client.screen += L
		var/UI/M = garbage.Grab(/UI/)
		M.icon_state = "M"
		M.screen_loc = "CENTER - [x1 - 1],CENTER - [y1 - 1] to CENTER + [x2 - 1],CENTER + [y2 - 1]"
		//M.icon += color
		M.layer = HUD_LAYER + hudlayer
		c.pieces += M
		client.screen += M
	for(var/UI/i in c.pieces)
		animate(i,alpha = 0,0, flags = ANIMATION_PARALLEL)
		animate(i,alpha = 255, 8, flags = ANIMATION_PARALLEL)
	if(parent) for(var/UI/i in c.pieces) parent.pieces += i
	return c

mob/proc/ShowContainer(UI/Container/c)
	for(var/UI/i in c.pieces)
		client.screen += i
		animate(i, alpha = 255, 8)

mob/player/proc/NormalizeUI(UI/i)
	i.icon = initial(i.icon)
	//i.icon_state = initial(i.icon_state)
	i.transform = initial(i.transform)
	//i.screen_loc = initial(i.screen_loc)
	i.layer = initial(i.layer)
	i.pixel_y = initial(i.pixel_y)

mob/player/proc/DissassembleContainer(UI/Container/c)
	for(var/atom/movable/i in c.pieces)
		animate(i, alpha = 0, 8)
		spawn(8)
			client.screen -= i
			i = new
			i.GC()
			c.pieces -= i
	spawn(8)
		if(Credits_Menu) Credits_Menu = null
		else if(Main_Menu) Main_Menu = null
		else if(CharacterCreation) CharacterCreation = null
		else if(VendorUI) VendorUI = null
		c = new
		del(c)