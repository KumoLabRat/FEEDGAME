mob/player
	MakeVendor(type)
		..()
		if(type == "special")
			SpecialVendor(VendorUI)
			var/UI/specialOverlay	= specialList[1]
			BuildBase(VendorUI,special = specialOverlay.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>SPECIAL VENDOR</class>")
			ItemSelect 				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,specialList)
	proc/SpecialVendor(UI/Container/c)
		specialList = new
		for(var/i = 1,i <= 7,i++)
			var/UI/Button/Item/Vendor/Gun/o = garbage.Grab(/UI/Button/Item/Vendor/Gun/)
			o.parent = c
			o.itemType = "special"
			o.icon = 'game/items.dmi'
			o.position = i
			o.layer = HUD_LAYER + 3
			switch(i)
				if(1)
					o.price 		= 50
					o.name 			= "Boomerang"
					o.icon_state	= "boomerang"
					o.gun_type		= /obj/weapon/special/boomerang
					o.desc 			= "A boomerang.  Do you seriously not know what a boomerang is?"
				if(2)
					o.price 		= 200
					o.name 			= "Kaboomerang"
					o.icon_state	= "kaboomerang"
					o.gun_type		= /obj/weapon/special/boomerang/kaboomerang
					o.desc			= "Just like a boomerang except it fucking explodes."
				if(3)
					o.price 		= 100
					o.name 			= "Grenade"
					o.icon_state	= "grenade"
					o.gun_type		= /obj/weapon/special/grenade
					o.desc 			= "It's a grenade.  You throw it.  Boom."
				if(4)
					o.price 		= 150
					o.name 			= "Sticky 'Nade"
					o.icon_state	= "sticky_grenade"
					o.gun_type		= /obj/weapon/special/grenade/sticky_grenade
					o.desc 			= "It's a grenade, but sticky.  I... kind of don't want to know why."
				if(5)
					o.price 		= 125
					o.name 			= "Molotov"
					o.icon_state	= "molotov"
					o.gun_type		= /obj/weapon/special/molotov
					o.desc 			= "A rag stuffed in a bottle of booze.  Great for starting forest fires."
				if(6)
					o.price 		= 1000
					o.name 			= "Airstrike"
					o.icon_state	= "airstrike"
					o.gun_type		= /obj/weapon/special/airstrike
					o.desc 			= "Thrown beacon device that will trigger an airstrike on the beacon's location."
				if(7)
					o.price 		= 1000
					o.name 			= "Gravity Grenade"
					o.icon_state	= "gravade"
					o.gun_type		= /obj/weapon/special/grenade/gravity_grenade
					o.desc 			= "Thrown device that temporarily emits a powerful gravitational pull on nearby things."
			if(equipped_special.type == o.gun_type)
				o.price = 0
			specialList += o
			c.pieces += o