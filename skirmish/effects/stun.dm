

/*
	stun is an effect that briefly immobilizes a mob. the effect dazes them, freezes them in place, and has stars circling their head.
*/


mob
	var
		stunned		= 0
		can_stun	= 1

	proc
		stun()
			set waitfor = 0
			if(!can_stun || stunned || !health || shield) return
			stunned = 1
			overlays += STUN_OVERLAY
			sleep rand(5, 10)
			overlays -= STUN_OVERLAY
			stunned = 0