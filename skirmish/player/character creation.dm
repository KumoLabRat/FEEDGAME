// Code to save the usernames already taken

var/list/playerNames

world
	New()
		..()
		if(fexists("saves/names.sav"))
			var/savefile/F = new("saves/names.sav")
			if(F["patch"] == CURRENT_PATCH)
				F["TakenNames"] >> playerNames
			else
				playerNames = new
		else
			playerNames = new
	Del()
		var/savefile/F = new("saves/names.sav")
		F["TakenNames"] << playerNames

mob/player // player variables
	var/tmp/UI/Container/CharacterCreation
	var/tmp/UI/Container/ItemSelect/ItemSelect
	var/tmp/list
		vanityList
		hairList
		shirtList
	var/tmp
		curHair = 1
		curVanity = 1
		curShirt = 1
		nameGood = 0
		UI/Button/CharacterCreation/Scroll/ScrollLeft
		UI/Button/CharacterCreation/Scroll/ScrollRight

	proc/LoadCharacterCreation() // this builds the actual menu itself
		// GenerateContainer() returns a container to group other UI elements under -- see container generation.dm for more information on arguments
		winset(src,"default","macro=\"vendor\"")
		CharacterCreation = GenerateContainer(/UI/Container,0,6,6,4,4,"Character Creation")
		GenerateContainer(/UI/Container,0.1,5,5,4,100,"Character Creation",CharacterCreation,"<p class='vendor'>CREATE A CHARACTER",1,1)
		CreateLists(CharacterCreation)
		draw_input("Choose Name", "CENTER - 3,CENTER - 3", 112, 16, "<p class='vendor'>Pick a Name!",1,0,"Choose Name",CharacterCreation)
		CharacterCreation.basePreview = GenerateContainer(/UI/Container,0.2,6,6,4,-1,"Character Creation",CharacterCreation,dark = 1)
		BuildBase(CharacterCreation,arms.icon_state,pants.icon_state,face.icon_state,_loc = "CENTER-2:14,CENTER - 2")
		// item select can just be garbage collected, even though it's a container -- it only "contains" the items it lets you scroll through and the UI surrounding it
		ItemSelect = garbage.Grab(/UI/Container/ItemSelect/)
		ItemSelect.p = src
		ItemSelect.ChangeProducts(src,hairList) // but you need to make sure to feed it a player and a list to make everything displays properly
		var/UI/Button/Done/Done = garbage.Grab(/UI/Button/Done/)
		FadeIn(Done)
		CharacterCreation.pieces += Done
		CharacterCreation.donebutton = Done
		client.screen += Done
		ScrollLeft = garbage.Grab(/UI/Button/CharacterCreation/Scroll/)
		ScrollLeft.set_position(WEST)
		ScrollLeft.transform = matrix(ScrollLeft.x_offset, 0,MATRIX_TRANSLATE)
		client.screen += ScrollLeft
		FadeIn(ScrollLeft)
		spawn(1) // for some reason trying to garbage collect 2 of the same kind causes some weird bugs, so we have to wait before grabbing this one
			ScrollRight = garbage.Grab(/UI/Button/CharacterCreation/Scroll/)
			ScrollRight.set_position(EAST)
			ScrollLeft.linkedButton = ScrollRight
			ScrollRight.linkedButton = ScrollLeft
			ScrollLeft.Text = GenerateContainer(/UI/Container,0.1,4,4,3,100,"Character Creation",CharacterCreation,"<p class='vendor'>HAIR")
			ScrollRight.Text = ScrollLeft.Text
			ScrollRight.transform = matrix(ScrollRight.x_offset, 0,MATRIX_TRANSLATE)
			FadeIn(ScrollRight)
			CharacterCreation.pieces += ScrollRight
			CharacterCreation.pieces += ScrollRight.linkedButton
			client.screen += ScrollRight
	proc/CreateLists(UI/Container/c) // makes the lists of all the items inside the selection
		vanityList = new
		hairList = new
		shirtList = new
		var/pos = 1
		for(var/i = 0,i <= 12,i++) // start from zero to get the option to not pick anything
			var/UI/Button/Item/o = garbage.Grab(/UI/Button/Item/)
			o.offset_pos = i
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "vanity"
			o.icon = 'player/vanity.dmi'
			o.icon_state = "vanity[i]"
			switch(i) // set the pixel offsets for each individual item
				if(1) // 1
					o.x_offset = -1
					o.y_offset = -8
				if(2) // 1
					o.x_offset = -1
					o.y_offset = -8
				if(3) // 2
					o.x_offset = 0
					o.y_offset = -11
				if(4) // 3
					o.x_offset = -7
					o.y_offset = -11
				if(5) // 4
					o.x_offset = -4
					o.y_offset = -8
				if(6) // 5
					o.x_offset = -2.5
					o.y_offset = -11
				if(7) // 5
					o.x_offset = -2.5
					o.y_offset = -11
				if(8) // 1
					o.x_offset = -1
					o.y_offset = -8
				if(9) // 5
					o.x_offset = -2.5
					o.y_offset = -11
				if(10) // 5
					o.x_offset = -2.5
					o.y_offset = -11
				if(11) // 5
					o.x_offset = -2.5
					o.y_offset = -11
				if(12) // 5
					o.x_offset = -2.5
					o.y_offset = -11
			o.transform = matrix(o.x_offset,o.y_offset,MATRIX_TRANSLATE)
			vanityList += o // add it to the list that we're going to feed to
			CharacterCreation.pieces += o // always make sure that something is being stored in the parent UI's pieces
		pos = 1
		for(var/i = 0,i <= 17,i++)
			if(i == 14) continue
			var/UI/Button/Item/o = garbage.Grab(/UI/Button/Item/)
			o.offset_pos = i
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "hair"
			o.icon = 'player/_Hair.dmi'
			o.icon_state = "style[i]"
			switch(i)
				if(1)
					o.x_offset = -10
					o.y_offset = -23
				if(2)
					o.x_offset = -10
					o.y_offset = -24
				if(3)
					o.x_offset = -10
					o.y_offset = -19
				if(4)
					o.x_offset = -10
					o.y_offset = -19
				if(5)
					o.x_offset = -10
					o.y_offset = -23
				if(6)
					o.x_offset = -10
					o.y_offset = -22
				if(7)
					o.x_offset = -10
					o.y_offset = -19
				if(8)
					o.x_offset = -10
					o.y_offset = -24
				if(9)
					o.x_offset = -10
					o.y_offset = -20
				if(10)
					o.x_offset = -10
					o.y_offset = -23
				if(11)
					o.x_offset = -14
					o.y_offset = -23
				if(12)
					o.x_offset = -10
					o.y_offset = -24
				if(13)
					o.x_offset = -14
					o.y_offset = -23
				if(15)
					o.x_offset = -10
					o.y_offset = -23
				if(16)
					o.x_offset = -14
					o.y_offset = -23
				if(17)
					o.x_offset = -10
					o.y_offset = -22
			o.transform = matrix(o.x_offset,o.y_offset,MATRIX_TRANSLATE)
			o.transform *= 0.5
			hairList += o
			CharacterCreation.pieces += o
		if(key == "Amelia Pond")
			var/UI/Button/Item/o = garbage.Grab(/UI/Button/Item/)
			o.offset_pos = hairList.len + 1
			o.parent = c
			o.position = pos
			o.itemType = "hair"
			o.icon = 'player/_Hair.dmi'
			o.icon_state = "amelia1"
			o.transform = matrix(-10, -22,MATRIX_TRANSLATE)
			o.transform *= 0.5
			hairList += o
			CharacterCreation.pieces += o
		pos = 1
		for(var/i = 0,i <= 16,i++)
			if(i == 10||i == 12) continue
			var/UI/Button/Item/o = garbage.Grab(/UI/Button/Item/)
			o.offset_pos = i
			o.parent = c
			o.itemType = "shirt"
			o.position = pos
			pos++
			o.icon = 'player/_Clothes.dmi'
			o.icon_state = "shirt[i]"
			o.transform = matrix(-6, -4,MATRIX_TRANSLATE)
			o.transform *= 0.7
			shirtList += o
			CharacterCreation.pieces += o
		if(key == "Kumorii")
			var/UI/Button/Item/o = garbage.Grab(/UI/Button/Item/)
			o.offset_pos = shirtList.len + 1
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "shirt"
			o.icon = 'player/_Clothes.dmi'
			o.icon_state = "shirt10"
			o.transform = matrix(-6, -4,MATRIX_TRANSLATE)
			o.transform *= 0.7
			shirtList += o
			CharacterCreation.pieces += o
		if(key == "Amelia Pond")
			var/UI/Button/Item/o = garbage.Grab(/UI/Button/Item/)
			o.offset_pos = shirtList.len + 1
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "shirt"
			o.icon = 'player/_Clothes.dmi'
			o.icon_state = "amelia-shirt"
			o.transform = matrix(-6, -4,MATRIX_TRANSLATE)
			o.transform *= 0.7
			shirtList += o
			CharacterCreation.pieces += o

UI/Button/CharacterCreation/Scroll // these are the scroll buttons from up top
	layer = HUD_LAYER + 0.1
	var/
		tmp/
			scroll = 1
			UI/Button/CharacterCreation/Scroll/linkedButton
			UI/Container/Text
	proc/set_position(_dir)
		dir = _dir
		if(_dir == WEST)
			x_offset = 4
			icon_state = "left"
			screen_loc = "CENTER-5,CENTER+3"
		if(_dir == EAST)
			x_offset = -4
			icon_state = "right"
			screen_loc = "CENTER+5,CENTER+3"
	MouseEntered()
		var mob/player/p = usr

		p.purge_dancers()

		if(dir == EAST) icon_state = "right-light"
		if(dir == WEST) icon_state = "left-light"
		if(linkedButton.dir == EAST) linkedButton.icon_state = "right-light"
		if(linkedButton.dir == WEST) linkedButton.icon_state = "left-light"
		dance(p)
		linkedButton.dance(p)
		Text.dance(p)

		if(p.Highlight) p.Highlight.position = 4
	Click()
		..()
		var/mob/player/p = usr // this ugly-ass way of changing the text up top.  self explanatory but sloppy
		if(dir == EAST) scroll++
		else scroll--
		if(scroll < 1) scroll = 3
		if(scroll > 3) scroll = 1
		switch(scroll)
			if(1)
				Text.maptext = "<p class='vendor'>HAIR"
				p.ItemSelect.ChangeProducts(p,p.hairList,p.curHair)
			if(2)
				Text.maptext = "<p class='vendor'>VANITY"
				p.ItemSelect.ChangeProducts(p,p.vanityList,p.curVanity)
			if(3)
				Text.maptext = "<p class='vendor'>SHIRT"
				p.ItemSelect.ChangeProducts(p,p.shirtList,p.curShirt)
		linkedButton.scroll = scroll

