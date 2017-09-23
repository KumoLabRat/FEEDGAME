
mob
	var
		level 		= 1
		exp			= 0
		max_exp		= 50
		kill_score	= 5	// how many points (and experience) are gained from killing a given mob.

		LEVEL_CAP	= 20


	proc
		give_exp(EXP_TOTAL = 0)
			/*
				call this proc to give experience to a mob. EXP_TOTAL is the amount of exp to give.
			*/
			if(EXP_TOTAL)
				if(level < LEVEL_CAP)
					exp += EXP_TOTAL
					if(exp >= max_exp)
						exp = 0
						max_exp += round(max_exp/1.5)
						level ++
						base_health += 10
				//		base_defense += 0.5
						if(client) if(src:move_delay > 0) src:move_delay -= 0.1
						health = base_health
						animate(src, color = "teal", time = 3, easing = CUBIC_EASING, loop = 1)//, flags = ANIMATION_PARALLEL)
						animate(color = null, time = 15, easing = CUBIC_EASING, loop = 1)//, flags = ANIMATION_PARALLEL)
						if(client) world << ">> <b><font color = [src:namecolor]>[src]</font> leveled up! (level [level])"
						if(nametag)
							overlays -= nametag
							nametag.change_text("[name]", level)
							overlays += nametag