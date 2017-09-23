//#include <kaiochao/absolutepositions/absolute positions/absolute positions.dme>



mob
	proc/PointArrow(obj/Arrow, atom/Target, MinDistance, ArrowDistance)
		/* called to refresh a target arrow and update it's positioning.
		*/
		#if DM_VERSION < 509
		if(isnull(MinDistance)) MinDistance = min(client.ViewPixelWidth(), client.ViewPixelHeight()) * (5/8)
		if(isnull(ArrowDistance)) ArrowDistance = min(client.ViewPixelWidth(), client.ViewPixelHeight()) * (3/8)
		#else
		if(isnull(MinDistance)) MinDistance = min(client.bound_width, client.bound_height) * (5/8)
		if(isnull(ArrowDistance)) ArrowDistance = min(client.bound_width, client.bound_height) * (3/8)
		#endif
		var dx = Target.Cx() - Cx()
		var dy = Target.Cy() - Cy()
		var dot = dx*dx + dy*dy
		if(dot < MinDistance * MinDistance || !loc || !Target.loc || Target.z != z)
			Arrow.screen_loc = null
			return
		Arrow.screen_loc = "CENTER"
		var matrix/m = new
		m.Translate(0, ArrowDistance)
		m.Turn(dx > 0 ? arccos(dy / sqrt(dot)) : -arccos(dy / sqrt(dot)))
		Arrow.transform = initial(Arrow.transform) * m



	player
		var
			target_arrows[]	// a list of arrows that are targeting enemies.
			player_arrows[]	// a list of arrows that are targeting other players/friendly NPCs.



		proc
			remove_target(mob/m)
				/* called to remove a targeted enemy from a player's screen.
				*/
				if(!(m in target_arrows)) return
				client.screen -= target_arrows[m]
				target_arrows -= m
				if(!target_arrows.len)
					target_arrows = null



			add_target(mob/m)
				/* called to add a new enemy target to a player's screen.
				*/
				if(m in target_arrows) return
				if(!target_arrows)
					target_arrows = new

				target_arrows[m] = new /obj/arrow
				client.screen += target_arrows[m]
				var/ref_arrow = target_arrows[m]	// remember this incase the target is deleted somehow so we can still clear it.
				spawn while(src && (m in target_arrows)) // update the arrow every frame.
					if(!m || !m.loc || !m.health)	// if any of these are true, we need to stop targeting m.
						if(m) 						// as long as m exists, it's easy.
							remove_target(m)
						else 						// however in rare circumstances m might not exist anymore(d/c'd bug, etc.) so we need to handle things a little more manually.
							client.screen -= ref_arrow //first we remove the arrow from the hud via our handy reference from earlier.
							purge_targets()			// this will remove all broken references from the target list.
						break 						// lastly end the loop since it's no longer needed.
					PointArrow(target_arrows[m], m)	// if we made it this far, we can go ahead and refresh the arrow!
					sleep world.tick_lag



			purge_targets()
				/* called to remove all null references from the list of targets.
				*/
				for(var/p in target_arrows)		// first lets clear any broken references already in their arrows.
					if(!p) target_arrows.Remove(p)
				//		.++	 this is leftover from debugging -- will tell you how many broken arrows were purged.




/***************************************************************************************************
*************  The following is basically the same as the above, however it is specifically
						for players and friendly support AI instead of enemies!
*******************************************************************************************************************/


			remove_p_target(mob/m)
				/* called to remove a targeted friendly from a player's screen.
				*/
				if(!(m in player_arrows)) return
				client.screen -= player_arrows[m]
				player_arrows -= m
				if(!player_arrows.len)
					player_arrows = null



			add_p_target(mob/m)
				/* called to add a new friendly target to a player's screen.
				*/
				if(m in player_arrows) return
				if(!player_arrows)
					player_arrows = new

				player_arrows[m] = new /obj/pl_arrow
				client.screen += player_arrows[m]
				var/ref_arrow = player_arrows[m]
				spawn while(src && (m in player_arrows))
					if(!m || !m.loc || !m.health || (m.client && m:died_already))
						if(m)
							remove_p_target(m)
						else
							client.screen -= ref_arrow
							purge_p_targets()
						break
					PointArrow(player_arrows[m], m)
					sleep world.tick_lag



			purge_p_targets()
				/* called to remove all null references from the list of targets.
				*/
				for(var/p in player_arrows)
					if(!p) player_arrows.Remove(p)


//////////////////


			update_pl_targets()
				/* makes sure the proper mobs are all being tracked!
					also will clear our arrows that shouldn't be shown!
				*/
				for(var/mob/p in player_arrows)		// first lets clear any broken references already in their arrows.
					if(!p || p.loc == null || !p.health)
						remove_p_target(p)

				for(var/mob/p in (active_game.participants+support_ai)-player_arrows)	// then find all the unreferenced ones!
					if(p.health && !(p in player_arrows)) // if alive and not tracked; track them.
						add_p_target(p)




obj/arrow
	icon			= 'effects/arrow.dmi'
	icon_state 		= "arrow"
	mouse_opacity 	= FALSE
	plane			= 3
	appearance_flags= PIXEL_SCALE

obj/pl_arrow
	icon			= 'effects/arrow.dmi'
	icon_state 		= "smallarrow"
	mouse_opacity 	= FALSE
	plane			= 3
	appearance_flags= PIXEL_SCALE
