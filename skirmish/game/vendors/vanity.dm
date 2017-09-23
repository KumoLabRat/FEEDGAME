mob/player
	MakeVendor(type)
		..()
		if(type == "vanity")
			VanityVendor(VendorUI)
			var/UI/vanityOverlay	= vanityList[1]
			BuildBase(VendorUI,arms.icon_state,pants.icon_state,face.icon_state,shirt.icon_state,hair.icon_state,vanityOverlay.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>VANITY VENDOR</class>")
			ItemSelect 				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,vanityList)
	proc/VanityVendor(UI/Container/c)
		vanityList = new
		var/pos = 1
		for(var/i = 0,i <= 13,i++)
			if(!(i in inv_vanity_vendor)) continue
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "vanity"
			o.icon = 'player/vanity.dmi'
			o.icon_state = "vanity[i]"
			switch(i)
				if(0)
					o.none	= 1
					o.price	= 0
					o.name	= "No Vanity"
					o.desc	= "Why does everybody gotta be so vain?"
				if(1)
					o.price		= 20
					o.name		= "Red Bandana"
					o.desc		= "A rougish red bandana."
					o.transform = matrix(-1, -8,MATRIX_TRANSLATE)
				if(2)
					o.price		= 20
					o.name		= "Blue Bandana"
					o.desc		= "A rougish blue bandana."
					o.transform = matrix(-1, -8,MATRIX_TRANSLATE)
				if(3)
					o.price		= 20
					o.name		= "Arrrgh, I'm a pirate!"
					o.desc		= "An eyepatch from a Halloween costume."
					o.transform = matrix(0, -11,MATRIX_TRANSLATE)
				if(4)
					o.price		= 20
					o.name		= "Monocle"
					o.desc		= "For the sophisticated and blind."
					o.transform = matrix(-7, -11,MATRIX_TRANSLATE)
				if(5)
					o.price		= 50
					o.name		= "Doobie Trouble"
					o.desc		= "$10 Blue Dream joint. 420BLAZEIT."
					o.transform = matrix(-4, -8,MATRIX_TRANSLATE)
				if(6)
					o.price		= 50
					o.name		= "Nerdy"
					o.desc		= "Fancy glasses for an intelligent look."
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
				if(7)
					o.price		= 50
					o.name		= "The Stevie Wonders"
					o.desc		= "Get it? Because he's blind?"
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
				if(8)
					o.price		= 50
					o.name		= "Black Bandana"
					o.desc		= "A rougish black bandana."
					o.transform = matrix(-1, -8,MATRIX_TRANSLATE)
				if(9)
					o.price		= 100
					o.name		= "Blue Shades"
					o.desc		= "Glasses with blue tinted lenses."
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
				if(10)
					o.price		= 100
					o.name		= "Red Shades"
					o.desc		= "Glasses with red tinted lenses."
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
				if(11)
					o.price		= 100
					o.name		= "Green Shades"
					o.desc		= "Glasses with green tinted lenses."
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
				if(12)
					o.price		= 150
					o.name		= "3D Glasses"
					o.desc		= "Classic 3D glasses."
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
				if(13)
					o.price		= 150
					o.name		= "Bandito Supremo"
					o.desc		= "lol"
					o.transform = matrix(-2.5, -11,MATRIX_TRANSLATE)
			vanityList += o
			VendorUI.pieces += o
			if(vanity.icon_state == "[o.icon_state]") o.price = 0
			if(i == 0)
				o.none 	= 1
				o.price = 0