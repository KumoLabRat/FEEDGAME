



mob
	var
		base_health	= 125
		health		= 0
		can_die		= 1
		can_hit		= 1
		has_revive	= 0		// CAN HAVE A MAXIMUM OF TWO REVIVES. this number reflects the total amount the player has
		shield		= 0

	proc
		edit_health(damage, mob/dealer, bloody_mess = 0, gib = 0)
			if(active_game.started != 2) return
			if(damage > 0)			// restoring health
				health += damage
				if(health > base_health)
					health = base_health


			else if(!active_game.intermission && can_hit)	// or taking health
				if(istype(src, /mob/npc/hostile) && !(src in ai_list) && !src:puppet_master) return
				can_hit = 0
				if(dealer)
					if(dealer.type == /mob/player && istype(src, /mob/npc/hostile))
						src:last_attacker = dealer
				if(shield && !shielded)							// if they have a shield, we can avoid taking health.
					shield(-1, (client?0:1))
					play_sound('audio/sounds/shieldbreak.ogg',80)
				else if(!active_game.intermission)			// if they don't, however..
					health += damage
					if(dealer && dealer.client)
						dealer.client.screen_shake(2,2)
					for(var/i=0,i<rand(1,5),i++)
						FUCKINGRIGHTBOI(((dealer && dealer.client) ? dealer:namecolor : "#FFFFFF"))
					gs(pick('hit 1.ogg','hit 2.ogg'))
					if(client) src:hurtflash()
					if(bloody_mess)	// 1 if explosion
						gs('splatter.ogg')
						drop_blood(5,1)
						drop_blood(5)

						if(istype(src, /mob/npc/hostile/feeder) && prob(25)) 	// if a feeder was blown up, let's see about making a bleeder!
							var/mob/npc/hostile/b 	= garbage.Grab(/mob/npc/hostile/bleeder)
							b:bodcolor				= src:bodcolor
							b.icon					= initial(b.icon)
							b.icon					+= b:bodcolor
							b.overlays -= b:blood
							b:blood.icon_state		= src:blood.icon_state
							b.overlays += b:blood
							if(is_giant)
								b.is_giant 	= 1
								b.transform	= matrix()*2
								b.bounds_scale(2)
							b.loc					= loc
							b.step_x				= step_x
							b.step_y				= step_y
							b.density				= 1
							b.can_hit				= 1
							b.health				= b.base_health
							b.generate_gibs()
							ai_list					+= b
							ai_list					-= src
							src.GC()
							return

					else
						drop_blood(5)
				if(health <= 0)
					health = 0
					if(can_die)
						if(client && (has_revive || active_game.intermission))
							world << ">> <b><font color = [src:namecolor]>[src]</font> was revived!"
							if(has_revive) has_revive	--
							health 		= base_health
							can_hit 	= 1
						else
							if(dealer && dealer.client)
								dealer.give_exp(kill_score)
								dealer:give_points(kill_score)
							if(!active_game.intermission)
								. = loc
								if(!is_explosive && (bloody_mess||gib) && bodyparts) {gib(bodyparts,.,step_x,step_y);loc = null}
								death(bloody_mess)
							else health = round(base_health/2)
				if(health)
					can_hit = 1  //!client?3:10 //spawn(3) if(health) can_hit = 1
					if(prob(damage*(-1))) stun()
					blood_smear()
		//			if(prob(34)) world << "freeze!";freeze()// just for testing!

		death()
			density		= 0
			can_hit		= 0
			hit_streak	= 0
			if(is_explosive)
				animate(src, transform = transform*1.2, color = "#f4dd2c", time = 2, loop = 4)//, flags = ANIMATION_PARALLEL)
				animate(transform = transform/1.2, color = null, time=2)
				sleep 12
			else if(istype(src, /mob/player))
				animate(src, alpha = 0, time = 1, loop = 4)//, flags = ANIMATION_PARALLEL)
				animate(alpha = 255,time=1)
				sleep 10