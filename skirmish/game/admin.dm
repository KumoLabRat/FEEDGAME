

/*
			here is where you put your gm codes  kek
		*/

var
	list
		FeedTeam	= list("Kumorii", "Amelia Pond", "Unwanted4Murder", "Ghost of ET")

mob/player
	var/tmp
		is_GM = 0
	gm
		verb
			float()
				set category = "admin"
				if(density)
					density = 0
				else density = 1

			alert_all()
				set category = "admin"
				var/t = input(src, "What would you like to say in the global alert?","Alert Input")as text|null
				if(t)
					for(var/mob/player/p in players)
						alert(p, "[t]", "[src]- alert")

			raise_level()
				set category 		= "admin"
				var/mob/player/p	= input(src, "Who's level would you like to raise?", "Raise Level")as mob in players|null
				if(p)
					if(p.level < LEVEL_CAP)	// make sure that we can't raise their level higher than the level cap.
						p.give_exp(p.max_exp-p.exp)	// adds the exact amount of exp needed to level up.

			clear_scoreboard()
				set category = "admin"
				if(usr.key == "Kumorii")
					var/A = alert(usr,"Are you sure?","Clear Scoreboard?","Yes","No")
					if(A == "Yes")
						var/keys = world.GetScores(38, "Kills")
						if(keys)
							var/list/params = params2list(keys)
							world<<"<b>Players</b>"
							for(var/i=1, i<=params.len, ++i)
								var/player = params[i]
								world<<"[i]. [player]"
							for(var/i=1, i<=params.len, ++i)
								var/M = params[i]
								world<<"Clearing [M].."
								world.SetScores(M)
			reboot()
				set category = "admin"
				if(usr.key == "Kumorii")
					switch(alert(usr, "Sure you wanna reboot?", "Reboot?", "Yes","No"))
						if("Yes")
							world << "<font color = red><b>World is rebooting.. </font></b>"
							sleep 40
							world.Reboot()
			shut_down()
				set category = "admin"
				switch(alert(usr, "Sure you wanna shut down?", "Shutdown?", "Yes","No"))
					if("Yes")
						world << "<font color = red><b>World is shutting down.. </font></b>"
						sleep 40
						shutdown()