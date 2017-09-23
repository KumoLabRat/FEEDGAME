#define HUD_LAYER 100

/* All of this stuff pretty much just builds the containers for the vendors.  Hopefully it should all be pretty self-explanatory and really you
shouldn't even need to touch it.  All of the vendor-specific stuff is handled in their designated vendor files.
On that note, I didn't set prices or descriptions at all for anything except guns and specials and I mostly only did those so I could test
and make sure they worked properly.  You're on your own for the rest. :p */
mob/player/var/cashflow = 100
mob/player/var/tmp
	UI/CurrentCash
	UI/VendorCost
	UI/DescBox
	UI/ProductName
	UI/Container/VendorUI
	UI/Button/Item/Vendor/CurrentProduct
	currentItem 	= 1
	currentPrice 	= 0
	list/gunList
	list/specialList

mob/player
	proc/MakeVendor(type)
		..()
		if(VendorUI)
			DissassembleContainer(VendorUI)
			DissassembleContainer(ItemSelect)
		else
			VendorUI 					= GenerateContainer(/UI/Container,0,6,6,4,4,"VendorUI")
			CurrentCash 				= GenerateContainer(/UI/Container,0.1,5,-3,4,100,"Vendor Cash",VendorUI,"<p class='vendor'><font color='green'>Cash: [cashflow]",1)
			VendorCost 					= GenerateContainer(/UI/Container,0.1,-3,5,4,100,"Vendor Price",VendorUI,"<p class='vendor'><font color='red'>Cost: [currentPrice]",0,1)
			ProductName 				= GenerateContainer(/UI/Container,0.1,2,2,3,100,"Product Name",VendorUI,"<p class='vendor'></class>",1,1)
			GenerateContainer(/UI/Container,0.3,5,5,1,1,"Product Description",VendorUI,"<p class='vendor'></class>", dark = 1)
			VendorUI.basePreview		= GenerateContainer(/UI/Container,0.2,6,6,4,-1,"Base Preview Window",VendorUI,dark = 1)
			VendorUI.donebutton 		= garbage.Grab(/UI/Button/Buy/)
			VendorUI.pieces 	 		+= VendorUI.donebutton
			client.screen 				+= VendorUI.donebutton
			FadeIn(VendorUI.donebutton)
			VendorUI.cancelbutton = garbage.Grab(/UI/Button/Cancel/)
			VendorUI.pieces 			+= VendorUI.cancelbutton
			client.screen 				+= VendorUI.cancelbutton
			FadeIn(VendorUI.cancelbutton)
			winset(src,"default","macro=\"vendor\"")
			key1 = null
			key2 = null
			key3 = null
			key4 = null

UI/Button/Item/Vendor
	desc 		= "This is a description, son.  Generic af."
	name		= "Generic Item"
	var/tmp
		price 	= 1
		none	= 0
	Gun
		mouse_opacity = 0
		var/tmp
			gun_type
			step