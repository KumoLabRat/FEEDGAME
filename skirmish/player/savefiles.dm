var/CURRENT_PATCH = 8

mob/player
	proc

		save_account()
			world << ">> <b>Saving [src]</b>"
			var/savefile/F = new("saves/[src.C_ID].sav")
			F["name"]		<< name
			F["stepsize"]	<< step_size
			F["movedelay"]	<< move_delay
			F["health"] 	<< base_health
			F["defense"]	<< base_defense
			F["exp"] 		<< exp
			F["maxexp"]		<< max_exp
			F["level"]		<< level
			F["primary"]	<< equipped_weapon
			F["special"]	<< equipped_special
			F["namecolor"]	<< namecolor
			F["hair"]		<< hair.icon_state
			F["pants"]		<< pants.icon_state
			F["shirt"]		<< shirt.icon_state
			F["vanity"]		<< vanity.icon_state
			F["arms"]		<< arms.icon_state
			F["face"]		<< face.icon_state
			F["cashflow"]	<< round(cashflow/2)
			F["class"]		<< class
			F["patch"]		<< CURRENT_PATCH		// use this to track the version they last logged on. If you need to correct savefiles, compare the saved patch value to the actual one.

		delete_save()
			if(fexists("saves/[src.C_ID].sav"))
				fdel("saves/[src.C_ID].sav")
				world << ">> <b>deleted [src]'s savefile."

		load_save()
			top
			if(fexists("saves/[src.C_ID].sav"))
				var/savefile/F	= new ("saves/[src.C_ID].sav")
				if(F["patch"] == CURRENT_PATCH)
					F["name"]		>> name
					F["stepsize"]	>> step_size
					F["movedelay"]	>> move_delay
					F["health"] 	>> base_health
					F["defense"]	>> base_defense
					F["exp"] 		>> exp
					F["maxexp"]		>> max_exp
					F["level"]		>> level
					F["primary"]	>> equipped_weapon
					F["special"]	>> equipped_special
					F["namecolor"]	>> namecolor
					F["hair"]		>> hair.icon_state
					F["pants"]		>> pants.icon_state
					F["shirt"]		>> shirt.icon_state
					F["vanity"]		>> vanity.icon_state
					F["arms"]		>> arms.icon_state
					F["face"]		>> face.icon_state
					F["cashflow"]	>> cashflow
					F["class"]		>> class
					if(hair.icon_state == "style11" || hair.icon_state == "style13" || hair.icon_state == "style14" || hair.icon_state == "style16"|| hair.icon_state == "style31")
						hair.pixel_x = -5
					if(hair.icon_state == "micke1" || hair.icon_state == "style21")
						hair.pixel_x = -4
					connected = 1
					CharacterLoaded()
				else
					if(alert(src, "There has been an important patch regarding savefiles and your save must be wiped. We apologizes for the inconvenience.","Oops!", "Okay!") == "Okay!")
						delete_save()
						goto top
			else
				spawn(10)
					arms.icon_state		= "base-"
					equipped_weapon 	= new /obj/weapon/gun/pistol
					equipped_special	= pick(new /obj/weapon/special/molotov, new /obj/weapon/special/grenade)
					pants.icon_state 	= "pants[rand(1,3)]"

					if(key == "Amelia Pond")	 pants.icon_state = "amelia-pants"
					if(key == "Kumorii") 		 pants.icon_state = "pants1"
					if(key == "Unwanted4Murder") pants.icon_state = "pants3"
					LoadCharacterCreation()
			/*
				THIS IS WHERE THE TUTORIAL BIT WILL BE PLUGGED IN.
			*/