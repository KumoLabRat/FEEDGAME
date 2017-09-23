mob/player
	MakeVendor(type)
		..()
		if(type == "shirt")
			ShirtVendor(VendorUI)
			var/UI/shirtOverlay		= shirtList[1]
			BuildBase(VendorUI,arms.icon_state,pants.icon_state,face.icon_state,shirtOverlay.icon_state,hair.icon_state,vanity.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>SHIRT VENDOR</class>")
			ItemSelect 				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,shirtList)
	proc/ShirtVendor(var/UI/Container/c)
		shirtList = new
		var/pos = 1
		for(var/i = 0,i <= 20,i++)
			if(i == 10||i == 12|| !(i in inv_shirt_vendor)) continue
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent 		= c
			o.itemType 		= "shirt"
			o.position 		= pos
			pos++
			o.icon 			= 'player/_Clothes.dmi'
			o.icon_state 	= "shirt[i]"
			o.transform 	= matrix(-6, -4,MATRIX_TRANSLATE)
			o.transform 	*= 0.7
			shirtList 		+= o
			VendorUI.pieces += o
			if(shirt.icon_state == "[o.icon_state]") o.price = 0
			if(i == 0)
				o.none 	= 1
				o.price = 0
			switch(i)
				if(0)
					o.none	= 1
					o.price	= 0
					o.name	= "Skins"
					o.desc	= "Shirts are overrated. #FreeTheNip"
				if(1)
					o.price		= 500
					o.name		= "Plain White V-Neck"
					o.desc		= "Like that one band, but totally cooler."
				if(2)
					o.price		= 500
					o.name		= "Black and Red Stripes"
					o.desc		= "Perfect flex piece for your skater-goth wardrobe."
				if(3)
					o.price		= 500
					o.name		= "Blue and White Stripes"
					o.desc		= "It's like the other shirt, but different colors."
				if(4)
					o.price		= 500
					o.name		= "Grey and White Stripes"
					o.desc		= "Surprise! More stripes!"
				if(5)
					o.price		= 1000
					o.name		= "Grey Gentleman"
					o.desc		= "Look like a total sir while curb-stomping motherfeeders."
				if(6)
					o.price		= 1000
					o.name		= "Maroon Gentleman"
					o.desc		= "Look like a sir, while also hiding dirt and stains."
				if(7)
					o.price		= 1500
					o.name		= "Red V-Neck"
					o.desc		= "Is it overpriced? You tell me!"
				if(8)
					o.price		= 2000
					o.name		= "Hero's Tunic"
					o.desc		= "The tunic worn by a hero from a distant land."
				if(9)
					o.price		= 2077
					o.name		= "Vault Suit"
					o.desc		= "Now, just imagine the feeders as feral ghouls."
				if(10)
					o.price		= 2500
					o.name		= "Grey Necktie"
					o.desc		= "A dapper look for a rad cat."
				if(11)
					o.price		= 3000
					o.name		= "Bat Suit"
					o.desc		= "A high-performance combat suit formerly worn by a guardian of the night."
				if(13)
					o.price		= 3000
					o.name		= "Steve's Shirt"
					o.desc		= "... Who's Steve?"
				if(14)
					o.price		= 3000
					o.name		= "Fire Sage Shirt"
					o.desc		= "Clothes of a powerful fire sage."
				if(15)
					o.price		= 3500
					o.name		= "Lemon-Lime Plaid"
					o.desc		= "Channel your inner nerd."
				if(16)
					o.price		= 3500
					o.name		= "Blue and Black Stripes!"
					o.desc		= "You didn't seriously think there wouldn't be more stripes, did you?"
				if(17)
					o.price		= 4000
					o.name		= "Red Hoodie"
					o.desc		= "Everybody loves hoodies; teenagers, murderers, feeders. The red helps to hide blood!"
				if(18)
					o.price		= 4000
					o.name		= "Contrast Plaid"
					o.desc		= "Black and white will always be a timeless color combo.. even moreso in PLAID!"
				if(19)
					o.price		= 5000
					o.name		= "Pink Pimpcoat"
					o.desc		= "Bet you can't say, \"Pimpin' Pink Pimps Pimpin' Hoes \" five times fast."
				if(20)
					o.price		= 5000
					o.name		= "Poncho Libre"
					o.desc		= "El Poncho Libre es muy especial. Hecho en China."
		if(key == "Kumorii")
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "shirt"
			o.icon = 'player/_Clothes.dmi'
			o.icon_state = "shirt10"
			o.transform = matrix(-6, -4,MATRIX_TRANSLATE)
			o.transform *= 0.7
			shirtList += o
			VendorUI.pieces += o
			if(shirt.icon_state == "[o.icon_state]") o.price = 0
		if(key == "Amelia Pond")
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "shirt"
			o.icon = 'player/_Clothes.dmi'
			o.icon_state = "amelia-shirt"
			o.transform = matrix(-6, -4,MATRIX_TRANSLATE)
			o.transform *= 0.7
			shirtList += o
			VendorUI.pieces += o
			if(shirt.icon_state == "[o.icon_state]") o.price = 0