UI/Button
	appearance_flags = PIXEL_SCALE
	Cancel
		icon_state = "cancel"
		screen_loc = "CENTER:-8,CENTER-4"
		layer = HUD_LAYER + 1
		MouseEntered()
			var mob/player/p = usr
			p.purge_dancers()
			dance(p)
			if(p.Highlight) p.Highlight.position = 2
		Click()
			..()
			var/mob/player/p = usr
			p.DissassembleContainer(p.VendorUI)
			p.DissassembleContainer(p.ItemSelect)
			winset(p,"default","macro=\"play\"")
			p.move_disabled	= 0
	Buy
		icon_state = "doneb"
		screen_loc = "CENTER:8,CENTER-4"
		layer = HUD_LAYER + 1
		MouseEntered()
			var mob/player/p = usr
			p.purge_dancers()
			dance(p)
			if(p.Highlight) p.Highlight.position = 1
		Click()
			..()
			var/mob/player/p = usr
			if(icon_state == "toomuch")
				if(!p.CurrentProduct.price) p.DescBox.maptext = "<p class='vendor'>You already own this item.  I feel like it might be a dick move to charge you twice."
				else p.DescBox.maptext = "<p class='vendor'>You don't have enough money to buy that."
				return
			p.cashflow -= p.CurrentProduct.price
			p.CurrentCash.maptext = "<p class='vendor'><font color = green>Cash: [p.cashflow]"
			if(p.VendorUI.baseObject.vanity)
				if(p.VendorUI.baseObject.vanity.icon_state != "[p.vanity.icon_state]")
					p.overlays -= p.vanity
					p.vanity.icon_state = p.VendorUI.baseObject.vanity.icon_state
					p.overlays += p.vanity
			if(p.VendorUI.baseObject.shirt)
				if(p.VendorUI.baseObject.shirt.icon_state != "[p.shirt.icon_state]")
					p.overlays -= p.shirt
					p.shirt.icon_state = p.VendorUI.baseObject.shirt.icon_state
					p.overlays += p.shirt
			if(p.VendorUI.baseObject.face)
				if(p.VendorUI.baseObject.face.icon_state != "[p.face.icon_state]")
					p.overlays -= p.face
					p.face.icon_state = p.VendorUI.baseObject.face.icon_state
					p.overlays += p.face
			if(p.VendorUI.baseObject.arms)
				if(p.arms.icon_state != "[p.VendorUI.baseObject.arms.icon_state]")
					var/UI/Button/Item/Vendor/Gun/currentGun = p.CurrentProduct
					var/obj/item/DROP		= garbage.Grab(p.equipped_weapon.drop_type)
					DROP.loc				= p.loc
					DROP.step_x				= p.step_x
					DROP.step_y				= p.step_y
					p.equipped_weapon 		= new currentGun.gun_type
					p.arms_state("[p.VendorUI.baseObject.arms.icon_state]")
					p.step_size				= currentGun.step
			if(p.VendorUI.baseObject.hair)
				if(p.VendorUI.baseObject.hair.icon_state != "[p.hair.icon_state]")
					p.overlays -= p.hair
					p.hair.pixel_x = 0
					p.hair.icon_state = p.VendorUI.baseObject.hair.icon_state
					if(p.hair.icon_state == "style11" || p.hair.icon_state == "style13" || p.hair.icon_state == "style14" || p.hair.icon_state == "style16"|| p.hair.icon_state == "style31")
						p.hair.pixel_x = -5
					if(p.hair.icon_state == "micke1" || p.hair.icon_state == "style21")
						p.hair.pixel_x = -4
					p.overlays += p.hair
			if(p.VendorUI.baseObject.special)
				var/UI/Button/Item/Vendor/Gun/currentGun = p.CurrentProduct
				var/obj/item/DROP		= garbage.Grab(p.equipped_special.drop_type)
				DROP.loc				= p.loc
				DROP.step_x				= p.step_x
				DROP.step_y				= p.step_y
				p.equipped_special		= new currentGun.gun_type
			p.DissassembleContainer(p.ItemSelect) // fades the container from the screen and adds it to the garbage pile
			p.DissassembleContainer(p.VendorUI)
			winset(p,"default","macro=\"play\"")
			p.move_disabled	= 0
	Done
		icon_state = "doneb"
		screen_loc = "CENTER,CENTER - 4"
		layer = HUD_LAYER + 0.2
		MouseEntered()
			var mob/player/p = usr
			p.purge_dancers()
			dance(p)
			if(p.Highlight) p.Highlight.position = 1
		Click() // what happens when you click the checkmark
			var/mob/player/p = usr
			if(!p.nameGood) return
			p.SetLoc(locate(20,21,1),8,8)
			p.shirt.icon_state = ""
			p.vanity.icon_state = ""
			p.hair.icon_state = ""
			if(p.CharacterCreation.baseObject.vanity) p.vanity.icon_state = p.CharacterCreation.baseObject.vanity.icon_state
			if(p.CharacterCreation.baseObject.shirt) p.shirt.icon_state = p.CharacterCreation.baseObject.shirt.icon_state
			if(p.CharacterCreation.baseObject.hair)
				p.hair.icon_state = p.CharacterCreation.baseObject.hair.icon_state
				if(p.hair.icon_state == "style11" || p.hair.icon_state == "style13" || p.hair.icon_state == "style14" || p.hair.icon_state == "style16"|| p.hair.icon_state == "style31")
					p.hair.pixel_x = -5
				if(p.hair.icon_state == "micke1" || p.hair.icon_state == "style21")
					p.hair.pixel_x = -4
			p.arms.icon_state = "base-pistol"
			p.connected = 1
			p.DissassembleContainer(p.ItemSelect) // fades the container from the screen and adds it to the garbage pile
			p.DissassembleContainer(p.CharacterCreation)
			p.name = p.nameGood
			playerNames.Add(p.nameGood)
			p.CharacterLoaded()

	Item
		screen_loc 		= "CENTER,CENTER+2"
		layer 			= HUD_LAYER + 0.1
		icon_state 		= "boxl"
		mouse_opacity 	= 2
		var/
			tmp/
				itemType
				first = 1
				position
				offset_pos
				UI/Container/parent
		Click() // code for adding items to the base. sets pixel offsets for certain hairs and stuff
			..()
			var/mob/player/p = usr
			p.ItemSelect.currentProduct = position
			p.ItemSelect.ArrangeProducts(p)
			if(itemType == "vanity")
				p.curVanity = position
				if(!parent.baseObject.vanity)
					parent.baseObject.vanity = garbage.Grab(/UI/)
					parent.baseObject.vanity.layer = HUD_LAYER + 1.3
				else parent.baseObject.overlays -= parent.baseObject.vanity
				parent.baseObject.vanity.icon = icon
				parent.baseObject.vanity.icon_state = icon_state
				parent.baseObject.overlays += parent.baseObject.vanity
			if(itemType == "hair")
				p.curHair = position
				if(!parent.baseObject.hair)
					parent.baseObject.hair = garbage.Grab(/UI/)
					parent.baseObject.hair.layer = HUD_LAYER + 1.4
				else parent.baseObject.overlays -= parent.baseObject.hair
				parent.baseObject.hair.icon 		= icon
				parent.baseObject.hair.icon_state 	= icon_state
				parent.baseObject.hair.pixel_x		= 0
				if(icon_state == "style11"||icon_state == "style13"||icon_state == "style14"||icon_state == "style16"||icon_state == "style31") parent.baseObject.hair.pixel_x = -5
				if(icon_state == "micke1" || icon_state == "style21") parent.baseObject.hair.pixel_x = -4
				parent.baseObject.overlays += parent.baseObject.hair
			if(itemType == "shirt")
				p.curShirt = position
				if(!parent.baseObject.shirt)
					parent.baseObject.shirt = garbage.Grab(/UI/)
					parent.baseObject.shirt.layer = HUD_LAYER + 1.2
				else parent.baseObject.overlays -= parent.baseObject.shirt
				parent.baseObject.shirt.icon = icon
				parent.baseObject.shirt.icon_state = icon_state
				parent.baseObject.overlays += parent.baseObject.shirt
			if(itemType == "gun")
				if(!parent.baseObject.arms)
					parent.baseObject.arms = garbage.Grab(/UI/)
					parent.baseObject.arms.layer = HUD_LAYER + 1.5
				else parent.baseObject.overlays -= parent.baseObject.arms
				parent.baseObject.arms.icon_state = icon_state
				parent.baseObject.overlays += parent.baseObject.arms
			if(itemType == "special")
				if(!parent.baseObject.special)
					parent.baseObject.special = garbage.Grab(/UI/)
					parent.baseObject.special.layer = HUD_LAYER + 1.2
				else parent.baseObject.overlays -= parent.baseObject.special
				parent.baseObject.special.icon_state = icon_state
				parent.baseObject.overlays += parent.baseObject.special
			if(itemType == "face")
				if(!parent.baseObject.face)
					parent.baseObject.face = garbage.Grab(/UI/)
					parent.baseObject.face.layer = HUD_LAYER + 1.2
				else parent.baseObject.overlays -= parent.baseObject.face
				parent.baseObject.face.icon_state = icon_state
				parent.baseObject.overlays += parent.baseObject.face