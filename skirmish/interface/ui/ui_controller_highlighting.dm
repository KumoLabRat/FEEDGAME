UI/Highlight
	var/tmp
		Type
		position


mob/player
	var/tmp
		UI/Highlight/Highlight
	verb
		Controller_Scroll_Up()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3

					purge_dancers()

					ItemSelect.ScrollRight.icon_state = "right-light"
					ItemSelect.ScrollLeft.icon_state = "left-light"

					for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
						a.dance(src)
				else if(CharacterCreation)
					purge_dancers()
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 4
					ScrollRight.icon_state = "right-light"
					ScrollLeft.icon_state = "left-light"
					ScrollRight.dance(src)
					ScrollLeft.dance(src)
					ScrollRight.Text.dance(src)

			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						Highlight.position = 1

						purge_dancers()

						VendorUI.donebutton.dance(src)
					else if(Highlight.position == 2)
						Highlight.position = 3

						purge_dancers()

						ItemSelect.ScrollRight.icon_state = "right-light"
						ItemSelect.ScrollLeft.icon_state = "left-light"

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)
					else if(Highlight.position == 1)
						Highlight.position = 2

						purge_dancers()

						VendorUI.cancelbutton.dance(src)

				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						purge_dancers()

						Highlight.position = 1
						CharacterCreation.donebutton.dance(src)

					else if(Highlight.position == 3)
						Highlight.position = 4

						purge_dancers()

						ScrollRight.icon_state = "right-light"
						ScrollLeft.icon_state = "left-light"

						ScrollRight.dance(src)
						ScrollLeft.dance(src)
						ScrollRight.Text.dance(src)

					else if(Highlight.position == 2)
						Highlight.position = 3

						purge_dancers()

						ItemSelect.ScrollRight.icon_state = "right-light"
						ItemSelect.ScrollLeft.icon_state = "left-light"

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)

					else if(Highlight.position == 1)
						Highlight.position = 2

						purge_dancers()

						var obj/input_box/i_box = get_ibox("Choose Name")
						i_box.dance(src)
						for(var/atom/a in i_box.sides)
							a.dance(src)

		Controller_Scroll_Down()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3

					purge_dancers()

					ItemSelect.ScrollRight.icon_state = "right-light"
					ItemSelect.ScrollLeft.icon_state = "left-light"

					for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
						a.dance(src)
				else if(CharacterCreation)
					purge_dancers()
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 4
					ScrollRight.icon_state = "right-light"
					ScrollLeft.icon_state = "left-light"
					ScrollRight.dance(src)
					ScrollLeft.dance(src)
					ScrollRight.Text.dance(src)
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						Highlight.position = 2

						purge_dancers()

						VendorUI.cancelbutton.dance(src)
					else if(Highlight.position == 1)
						Highlight.position = 3

						purge_dancers()

						ItemSelect.ScrollRight.icon_state = "right-light"
						ItemSelect.ScrollLeft.icon_state = "left-light"

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)
					else if(Highlight.position == 2)
						Highlight.position = 1

						purge_dancers()

						VendorUI.donebutton.dance(src)

				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						Highlight.position = 3

						purge_dancers()

						ItemSelect.ScrollRight.icon_state = "right-light"
						ItemSelect.ScrollLeft.icon_state = "left-light"

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)

					else if(Highlight.position == 3)
						Highlight.position = 2

						purge_dancers()

						var obj/input_box/i_box = get_ibox("Choose Name")
						i_box.dance(src)
						for(var/atom/a in i_box.sides)
							a.dance(src)

					else if(Highlight.position == 2)
						purge_dancers()

						Highlight.position = 1
						CharacterCreation.donebutton.dance(src)

					else if(Highlight.position == 1)
						Highlight.position = 4

						purge_dancers()

						ScrollRight.icon_state = "right-light"
						ScrollLeft.icon_state = "left-light"

						ScrollRight.dance(src)
						ScrollLeft.dance(src)
						ScrollRight.Text.dance(src)
		Controller_Scroll_Left()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3

					purge_dancers()

					ItemSelect.ScrollRight.icon_state = "right-light"
					ItemSelect.ScrollLeft.icon_state = "left-light"

					for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
						a.dance(src)
				else if(CharacterCreation)
					purge_dancers()
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 4
					ScrollRight.icon_state = "right-light"
					ScrollLeft.icon_state = "left-light"
					ScrollRight.dance(src)
					ScrollLeft.dance(src)
					ScrollRight.Text.dance(src)

			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						ItemSelect.ScrollLeft.Click()
					else if(Highlight.position == 2)
						Highlight.position = 3

						purge_dancers()

						ItemSelect.ScrollRight.icon_state = "right-light"
						ItemSelect.ScrollLeft.icon_state = "left-light"

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)
					else if(Highlight.position == 1)
						Highlight.position = 2

						purge_dancers()

						VendorUI.cancelbutton.dance(src)
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						if(!(ScrollRight.Text in selected))
							purge_dancers()
							ScrollRight.icon_state = "right-light"
							ScrollLeft.icon_state = "left-light"

							ScrollRight.dance(src)
							ScrollLeft.dance(src)
							ScrollRight.Text.dance(src)
						ScrollLeft.Click()
					else if(Highlight.position == 3)
						if(!(ItemSelect.ScrollLeft in selected)||!(ItemSelect.ScrollRight in selected))
							purge_dancers()

							for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
								a.dance(src)
							ItemSelect.ScrollRight.icon_state = "right-light"
							ItemSelect.ScrollLeft.icon_state = "left-light"
						ItemSelect.ScrollLeft.Click()
					else if(Highlight.position == 2)
						Highlight.position = 3

						purge_dancers()

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)

						var obj/input_box/i_box = get_ibox("Choose Name")
						i_box.stop_dancing()
						for(var/atom/a in i_box.sides)
							a.stop_dancing()
					else if(Highlight.position == 1)
						Highlight.position = 2

						purge_dancers()

						var obj/input_box/i_box = get_ibox("Choose Name")
						i_box.dance(src)
						for(var/atom/a in i_box.sides)
							a.dance(src)

		Controller_Scroll_Right()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3

					purge_dancers()

					ItemSelect.ScrollRight.icon_state = "right-light"
					ItemSelect.ScrollLeft.icon_state = "left-light"

					for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
						a.dance(src)
				else if(CharacterCreation)
					purge_dancers()
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 4
					ScrollRight.icon_state = "right-light"
					ScrollLeft.icon_state = "left-light"
					ScrollRight.dance(src)
					ScrollLeft.dance(src)
					ScrollRight.Text.dance(src)

			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						ItemSelect.ScrollRight.Click()
					else if(Highlight.position == 2)
						Highlight.position = 1

						purge_dancers()

						VendorUI.donebutton.dance(src)
					else if(Highlight.position == 1)
						Highlight.position = 3

						purge_dancers()

						ItemSelect.ScrollRight.icon_state = "right-light"
						ItemSelect.ScrollLeft.icon_state = "left-light"

						for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
							a.dance(src)
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						if(!(ScrollRight.Text in selected))
							purge_dancers()
							ScrollRight.icon_state = "right-light"
							ScrollLeft.icon_state = "left-light"

							ScrollRight.dance(src)
							ScrollLeft.dance(src)
							ScrollRight.Text.dance(src)

						ScrollRight.Click()
					else if(Highlight.position == 3)
						if(!(ItemSelect.ScrollLeft in selected)||!(ItemSelect.ScrollRight in selected))
							purge_dancers()

							for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
								a.dance(src)
							ItemSelect.ScrollRight.icon_state = "right-light"
							ItemSelect.ScrollLeft.icon_state = "left-light"
						ItemSelect.ScrollRight.Click()
					else if(Highlight.position == 2)
						var obj/input_box/i_box = get_ibox("Choose Name")
						i_box.stop_dancing()
						for(var/atom/a in i_box.sides)
							a.stop_dancing()

						Highlight.position = 1
						CharacterCreation.donebutton.dance(src)
					else if(Highlight.position == 1)
						Highlight.position = 4

						CharacterCreation.donebutton.stop_dancing()

						ScrollRight.icon_state = "right-light"
						ScrollLeft.icon_state = "left-light"

						ScrollRight.dance(src)
						ScrollLeft.dance(src)
						ScrollRight.Text.dance(src)
		Controller_Interact()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3

					purge_dancers()

					ItemSelect.ScrollRight.icon_state = "right-light"
					ItemSelect.ScrollLeft.icon_state = "left-light"

					for(var/atom/a in ItemSelect.ScrollRight.parent.pieces)
						a.dance(src)
				else if(CharacterCreation)
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 4
					ScrollRight.icon_state = "right-light"
					ScrollLeft.icon_state = "left-light"
					ScrollRight.dance(src)
					ScrollLeft.dance(src)
					ScrollRight.Text.dance(src)
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 2)
						DissassembleContainer(VendorUI)
						DissassembleContainer(ItemSelect)
						winset(src,"default","macro=\"play\"")
						move_disabled	= 0
						Highlight 		= null
						return
					if(Highlight.position == 1)
						VendorUI.donebutton.Click()
						Highlight = null
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 2)
						var/obj/input_box/ibox = get_ibox("Choose Name")
						if(ibox)
							ibox.Click()
					if(Highlight.position == 1)
						CharacterCreation.donebutton.Click()
						Highlight = null
		Controller_B()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.position = 2

					purge_dancers()

					VendorUI.cancelbutton.dance(src)
			else
				if(VendorUI)
					if(Highlight.position == 2)
						DissassembleContainer(VendorUI)
						DissassembleContainer(ItemSelect)
						winset(src,"default","macro=\"play\"")
						move_disabled	= 0
						Highlight 		= null
					else
						Highlight.position = 2

						purge_dancers()

						VendorUI.cancelbutton.dance(src)