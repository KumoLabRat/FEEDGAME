
/*
		points are collected by killing enemies and doing various tasks and completing waves. Different events give different amounts of points.
	points gained in a match do not carry over to new games, but instead all points a player has at the end of a game will get tallied into their
	career_score which reflects the player's general skill-level.

	accumulated points can also be spent at in-game vendors that show up on post-boss intermissions in exchange for weapons, revives, and support items.
*/


mob/player
	var
		career_score	= 0 // this is the player's total score from all of the games they've played put together.
		points			= 0 // this is the player's score for an individual match; this resets every match.

	proc
		give_points(p = 0)
			/* called to give or take points from a player. Negative values will take points, positive values will give points.
			*/
	//		world << "check 2; [p]"
			cashflow += p
			points += p
			if(points > 999999) points = 9999999
			if(points < 0)		points = 0
