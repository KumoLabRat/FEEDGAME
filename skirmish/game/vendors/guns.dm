mob/player
	MakeVendor(type)
		..()
		if(type == "gun")
			GunVendor(VendorUI)
			var/UI/gunOverlay		= gunList[1]
			BuildBase(VendorUI,gunOverlay.icon_state,pants.icon_state,face.icon_state,shirt.icon_state,hair.icon_state,vanity.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>GUN VENDOR</class>")
			ItemSelect				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,gunList)
			VendorUI.baseObject.dir 	= EAST
	proc/GunVendor(UI/Container/c)
		gunList = new
		var gun_pos = 1
		for(var/i = 1,i <= 13,i++)
			//if(!(i in inv_gun_vendor)) continue
			var/UI/Button/Item/Vendor/Gun/o = garbage.Grab(/UI/Button/Item/Vendor/Gun/)
			o.parent 						= c
			o.itemType 						= "gun"
			o.icon 							= 'game/vendors/guns.dmi'
			o.position 						= gun_pos
			o.layer 						= HUD_LAYER + 3
			gun_pos++
			switch(i)
				if(1)
					o.price 		= 5
					o.name 			= "Pistol"
					o.icon_state	= "base-pistol"
					o.gun_type		= /obj/weapon/gun/pistol
					o.step			= 4
					o.desc 			= "A regular ol' pistol."
					o.transform 	= matrix(-26, -2,MATRIX_TRANSLATE)
				if(2)
					o.price 		= 500
					o.name 			= "Kobra"
					o.icon_state	= "base-kobra"
					o.gun_type		= /obj/weapon/gun/kobra
					o.step			= 4
					o.desc			= "Like a pistol, but kooler."
					o.transform 	= matrix(-28, -2,MATRIX_TRANSLATE)
				if(3)
					o.price 		= 500
					o.name 			= "Krossbow"
					o.icon_state	= "base-krossbow"
					o.gun_type		= /obj/weapon/gun/krossbow
					o.step			= 4
					o.desc 			= "Less gun and more antiquated method of medieval warfare."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(4)
					o.price 		= 1000
					o.name 			= "3DG3-10RD"
					o.icon_state	= "base-3dg3-10rd"
					o.gun_type		= /obj/weapon/gun/edge_lord
					o.step			= 4
					o.desc 			= "The perfect gun for people who think Hitler did nothing wrong."
					o.transform 	= matrix(-28, -3,MATRIX_TRANSLATE)
				if(5)
					o.price 		= 1000
					o.name 			= "Pink Dream"
					o.icon_state	= "base-pinkdream"
					o.gun_type		= /obj/weapon/gun/pink_dream
					o.step			= 4
					o.desc 			= "If a gun were a relaxing candlelit bubblebath, it would be the Pink Dream."
					o.transform 	= matrix(-28, -3,MATRIX_TRANSLATE)
				if(6)
					o.price 		= 2000
					o.name 			= "El Verde"
					o.icon_state	= "base-elverde"
					o.gun_type		= /obj/weapon/gun/el_verde
					o.step			= 4
					o.desc 			= "Intergalactic laser pistol originally crafted by little green men. Far out."
					o.transform 	= matrix(-28, -3,MATRIX_TRANSLATE)
				if(7)
					o.price 		= 2000
					o.name 			= "The Gherkin"
					o.icon_state	= "base-gherkin"
					o.gun_type		= /obj/weapon/gun/gherkin
					o.step			= 4
					o.desc 			= "Gherkin shoot pickle. Pickle good for comrade. Heal comrade's comrades"
					o.transform 	= matrix(-33, -13,MATRIX_TRANSLATE) * 0.7
				if(8)
					o.price 		= 3000
					o.name 			= "Jabberjaw"
					o.icon_state	= "base-jabberjaw"
					o.gun_type		= /obj/weapon/gun/jabberjaw
					o.step			= 4
					o.desc 			= "Burstfire rifle with a wild spread. It's.. kind of a big deal."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(9)
					o.price 		= 4000
					o.name 			= "Uzi"
					o.icon_state	= "base-uzi"
					o.gun_type		= /obj/weapon/gun/uzi
					o.step			= 4
					o.desc 			= "An automatic SMG that handles even better than your mother."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(10)
					o.price 		= 4500
					o.name 			= "Red Baron"
					o.icon_state	= "base-redbaron"
					o.gun_type		= /obj/weapon/gun/red_baron
					o.step			= 4
					o.desc 			= "Automatic assault rifle that's as red as the blood of its enemies." //Last half of mag will set enemies ablaze."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(11)
					o.price 		= 7000
					o.name 			= "Lysergia"
					o.icon_state	= "base-lysergia"
					o.gun_type		= /obj/weapon/gun/lysergia
					o.step			= 4
					o.desc 			= "Interdimensional weapon tech that shoots bombs of explosive plasma."
					o.transform 	= matrix(-24, -5,MATRIX_TRANSLATE) * 0.9
				if(12)
					o.price 		= 8000
					o.name 			= "Stalker"
					o.icon_state	= "base-stalker"
					o.gun_type		= /obj/weapon/gun/stalker
					o.step			= 4
					o.desc 			= "Automatic laser weapon with high fire rate. Crafted by space gunsmiths."
					o.transform 	= matrix(-33, -13,MATRIX_TRANSLATE) * 0.7
				if(13)
					o.price 		= 9000
					o.name 			= "TAKOS"
					o.icon_state	= "base-tako"
					o.gun_type		= /obj/weapon/gun/tako
					o.step			= 4
					o.desc 			= "The Tactical Assault Killing Operating System -- the TAKOS gun, for short. It shoots tacos!"
					o.transform 	= matrix(-36.5, -37,MATRIX_TRANSLATE) * 0.5
			if(arms.icon_state == "[o.icon_state]")
				o.price = 0
			gunList += o
			c.pieces += o