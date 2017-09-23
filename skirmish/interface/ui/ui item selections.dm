UI
	Container
		ItemSelect
			var/tmp
				mob/player/p
				currentProduct = 1
				list/products
				list/currentProducts
				UI/Button/ItemScroll/Scroll/ScrollLeft
				UI/Button/ItemScroll/Scroll/ScrollRight
			New()
				..()
				spawn(1)
					pieces = new
					currentProducts = new
					products = new
					var/UI/Button/Item/Selected = garbage.Grab(/UI/Button/Item/)
					pieces += Selected
					p.client.screen += Selected
					FadeIn(Selected)
					ScrollLeft = garbage.Grab(/UI/Button/ItemScroll/Scroll/)
					ScrollLeft.set_position(WEST)
					ScrollLeft.transform = matrix(ScrollLeft.x_offset, 0,MATRIX_TRANSLATE)
					ScrollLeft.parent = src
					pieces += ScrollLeft
					p.client.screen += ScrollLeft
					FadeIn(ScrollLeft)
					ScrollRight = garbage.Grab(/UI/Button/ItemScroll/Scroll/)
					ScrollRight.set_position(EAST)
					ScrollRight.transform = matrix(ScrollRight.x_offset, 0,MATRIX_TRANSLATE)
					ScrollRight.parent = src
					pieces += ScrollRight
					p.client.screen += ScrollRight
					FadeIn(ScrollRight)
					var/UI/Background/ItemScroll/Sides/Right = garbage.Grab(/UI/Background/ItemScroll/Sides/)
					Right.left = 0
					pieces += Right
					p.client.screen += Right
					FadeIn(Right)
					var/UI/Background/ItemScroll/Sides/Left = garbage.Grab(/UI/Background/ItemScroll/Sides/)
					Left.left = 1
					pieces += Left
					p.client.screen += Left
					FadeIn(Left)
			proc/ChangeProducts(mob/player/p,list/l,currentPos = 1)
				spawn(1)
					products = l
					currentProduct = currentPos
					ArrangeProducts(p)
			proc/ArrangeProducts(mob/player/p,fade)
				if(currentProducts)
					p.client.screen -= currentProducts
					currentProducts.Cut()
				var/i2 = 0
				var/i3 = 1
				for(var/i = 1,i <= 5,i++)
					var/UI/Button/Item/Product
					if(i < 3)
						if((currentProduct - i) <= 0)
							Product = products[products.len - i2]
							i2++
						else Product = products[currentProduct - i]
					else if(i == 3)
						Product = products[currentProduct]
						Product.layer = HUD_LAYER + 50
						p.CurrentProduct = Product
						if(p.VendorUI)
							p.DescBox.maptext = "<p class='vendor'>[Product.desc]</class>"
							p.ProductName.maptext = "<p class='vendor'>[Product.name]</class>"
							p.VendorCost.maptext = "<p class='vendor'><font color='red'>Cost: [Product:price]</class></font>"
							if((!Product:price||Product:price > p.cashflow) && !Product:none)
								p.VendorUI.donebutton.icon_state = "toomuch"
							else
								p.VendorUI.donebutton.icon_state = "doneb"
						//Product.icon = initial(Product.icon)
					else
						if(((currentProduct + i) - 3) > products.len)
							Product = products[i3]
							i3++
						else Product = products[(currentProduct + i) - 3]
					if(i < 3) Product.screen_loc = "CENTER-[i],CENTER+2"
					else Product.screen_loc = "CENTER+[i - 3],CENTER+2"
					currentProducts += Product
					p.client.screen += Product
					if(fade) spawn(8) FadeIn(Product)

UI/Button/ItemScroll/Scroll
	layer 			= HUD_LAYER + 2
	var UI/Container/ItemSelect/parent
	MouseEntered()
		var mob/player/p = usr

		p.purge_dancers()

		parent.ScrollRight.icon_state = "right-light"
		parent.ScrollLeft.icon_state = "left-light"

		for(var/atom/a in parent.pieces)
			a.dance(p)

		if(p.Highlight) p.Highlight.position = 3
	Click()
		..()
		var/mob/player/p = usr
		if(dir == WEST) p.ItemSelect.currentProduct--
		if(dir == EAST) p.ItemSelect.currentProduct++
		if(p.ItemSelect.currentProduct > p.ItemSelect.products.len) p.ItemSelect.currentProduct = 1
		if(p.ItemSelect.currentProduct < 1) p.ItemSelect.currentProduct = p.ItemSelect.products.len
		var/UI/Button/Product = p.ItemSelect.products[p.ItemSelect.currentProduct]
		Product.Click()
	proc/set_position(_dir)
		dir = _dir
		if(_dir == WEST)
			x_offset = 4
			icon_state = "left"
			screen_loc = "CENTER-3,CENTER+2"
		if(_dir == EAST)
			x_offset = -4
			icon_state = "right"
			screen_loc = "CENTER+3,CENTER+2"

UI/Background/ItemScroll/Sides
	icon_state 		= "box"
	layer 			= HUD_LAYER + 0.1
	screen_loc 		= "CENTER+1,CENTER+2 to CENTER+2,CENTER+2"
	var/tmp/left 	= 0
	New()
		..()
		spawn()
			if(left) screen_loc 	= "CENTER-2,CENTER+2 to CENTER-1,CENTER+2"