UI/BaseObject
	icon 				= 'player/_BaseT.dmi'
	icon_state 			= "base-"
	screen_loc 			= "CENTER-2:14,CENTER - 3"
	layer 				= HUD_LAYER + 1.1
	appearance_flags	= KEEP_TOGETHER
	dir					= SOUTH
	var/
		tmp/
			UI/BaseObject/pants/pants
			UI/BaseObject/shirt/shirt
			UI/BaseObject/vanity/vanity
			UI/BaseObject/hair/hair
			UI/BaseObject/face/face
			UI/BaseObject/arms/arms
			UI/BaseObject/special/special
	Background
		icon_state = "box"
		layer = HUD_LAYER + 1
	arms
		icon = 'arms.dmi'
		layer = HUD_LAYER + 1.6
	pants
		icon = '_Clothes.dmi'
		layer = HUD_LAYER + 1.3
	shirt
		icon = '_Clothes.dmi'
		layer = HUD_LAYER + 1.3
	vanity
		icon = 'vanity.dmi'
		layer = HUD_LAYER + 1.5
	hair
		icon = '_Hair.dmi'
		layer = HUD_LAYER + 1.4
	face
		icon = '_Face.dmi'
		layer = HUD_LAYER + 1.2
	special
		icon = 'items.dmi'
		layer = HUD_LAYER + 1.2

mob/player
	proc/BuildBase(UI/Container/parent,Arms,Pants,Face,Shirt,Hair,Vanity,_loc,special) // puts the initial base together -- will probably need to generalize this for use in other areas
		//if(!parent.baseObject)
		var/UI/BaseObject/b = garbage.Grab(/UI/BaseObject/)
		b.overlays = null
		if(!special) b.icon = 'player/_BaseT.dmi'
		else b.icon = null
		parent.pieces += b
		if(Arms)
			b.arms = garbage.Grab(/UI/BaseObject/arms/)
			b.arms.icon_state = Arms
			b.arms.pixel_x = -16
			b.overlays += b.arms
		if(Pants)
			b.pants = garbage.Grab(/UI/BaseObject/pants/)
			b.pants.icon_state = Pants
			b.overlays += b.pants
		if(Face)
			b.face = garbage.Grab(/UI/BaseObject/face/)
			b.face.icon_state = Face
			b.overlays += b.face
		if(Shirt)
			b.shirt = garbage.Grab(/UI/BaseObject/shirt/)
			b.shirt.icon_state = Shirt
			b.overlays += b.shirt
		if(Hair)
			b.hair = garbage.Grab(/UI/BaseObject/hair/)
			b.hair.icon_state = Hair
			if(b.hair.icon_state == "style11" || b.hair.icon_state == "style13" || b.hair.icon_state == "style14" || b.hair.icon_state == "style16"|| b.hair.icon_state == "style31")
				b.hair.pixel_x = -5
			if(b.hair.icon_state == "micke1" || b.hair.icon_state == "style21")
				b.hair.pixel_x = -4
			b.overlays += b.hair
		if(Vanity)
			b.vanity = garbage.Grab(/UI/BaseObject/vanity/)
			b.vanity.icon_state = Vanity
			b.overlays += b.vanity
		if(special)
			b.special = garbage.Grab(/UI/BaseObject/special)
			b.special.icon_state = special
			b.transform = matrix(19, 5,MATRIX_TRANSLATE)
			b.overlays += b.special
		else b.transform = matrix(16, 3,MATRIX_TRANSLATE)
		parent.baseObject = b
		var/UI/BaseObject/Background/b2 = garbage.Grab(/UI/BaseObject/Background/)
		if(_loc)
			b.screen_loc = _loc
			b2.screen_loc = _loc
		parent.pieces += b2
		b2.transform = matrix(11, 0,MATRIX_TRANSLATE)
		parent.baseBackground = b2
		parent.basePreview.pieces += b
		parent.basePreview.pieces += b2
		animate(parent.baseBackground,alpha = 0,0)
		animate(parent.baseObject,alpha = 0,0)
		animate(parent.baseBackground,alpha = 255,8)
		animate(parent.baseObject,alpha = 255,8)
		client.screen += parent.baseBackground
		client.screen += parent.baseObject