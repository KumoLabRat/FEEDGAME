

mob
	player
		proc
			submit_scores()

				var/scoreboard_kills	= world.GetScores(name, "Kills")
				if(scoreboard_kills)
					var
						list/params		= params2list(scoreboard_kills)
					if(params["Kills"])
						scoreboard_kills	= text2num(params["Kills"])
						if(kills > scoreboard_kills)
							var/export_this = list("Kills" = kills, "Wave" = active_game.last_match_round, "Map" = active_game.last_map, "ID" = client.computer_id)
							world.SetScores(name, list2params(export_this))
				else
					var/export_this	= list("Kills" = kills, "Wave" = active_game.last_match_round, "Map" = active_game.last_map, "ID" = client.computer_id)
					world.SetScores(name, list2params(export_this))
