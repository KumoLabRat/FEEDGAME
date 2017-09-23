


// blue scadoo we can too


obj
	details
		is_garbage = 1
		stuck_arrow
			icon				= 'bodymarks.dmi'
			icon_state			= "stuckarrow"
			layer				= FLOAT_LAYER+2
			appearance_flags	= RESET_COLOR+RESET_ALPHA+KEEP_TOGETHER
			is_garbage			= 1
			New()
				..()
				pixel_x = rand(-2,3)
				pixel_y	= rand(-5,4)
				if(prob(45))
					transform = turn(matrix(), rand(-25,25))
		blood_smear
			icon				= 'bodymarks.dmi'
			icon_state			= "bloodsmear1"
			layer				= MOB_LAYER+2
			appearance_flags	= RESET_COLOR+RESET_ALPHA+KEEP_TOGETHER
			is_garbage 			= 1
			New()
				..()
				pixel_x = rand(-2,3)
				pixel_y	= rand(-4,4)
				icon_state	= "bloodsmear[rand(1,3)]"
mob
	var
		can_smudge 		= 0
		list/smudges	= new/list()

	proc
		stick_arrow()
			if(can_smudge && !shield)
				var/obj/details/s = garbage.Grab(/obj/details/stuck_arrow)
				overlays += s
				smudges += s

		blood_smear()
			if(can_smudge && !shield) for(var/i = rand(1,4), i, i--)
				var/obj/details/s = garbage.Grab(/obj/details/blood_smear)
				overlays += s
				smudges += s
proc
	clear_smudges(mob/m)
		if(m)
			m.overlays -= m.smudges // remove the smudges from overlays
			for(var/obj/s in m.smudges) s.GC()
			m.smudges.len = 0 // clear the list