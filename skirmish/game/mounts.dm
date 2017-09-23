
/*
		Mounts are special things that can be rode into battle; riding a mount will lock your movement speed regardless of your weapon
	and will make you look like a total fucking badass.
*/


mob

	var
		obj/mount/mount 					= null	// if the mob has a mount, this is where it'd be referenced.
		obj/mount_straddle/mount_straddle	= new
		lock_step							= 0		// 1 to make the mob's step_size un-changeable
//	Click()
//		usr.ride_mount(new/obj/mount/giraffe)

	proc
		ride_mount(obj/mount/m = null)
			/* called to make the mob ride a mount.
			*/
			if(m)
				mount 		= m
				pixel_y		= 16
				underlays -= src:pl_indicator
				src:pl_indicator.pixel_y = 0
				underlays += src:pl_indicator
				step_size	= 5
				lock_step	= 1
				m.pixel_x 	= -38
				m.pixel_y	= -14
				overlays.Add(m, mount_straddle)



obj
	mount
		appearance_flags 	= KEEP_APART
		layer				= MOB_LAYER+2

		giraffe
			icon			= 'game/mount-giraffe.dmi'
			icon_state		= "Giraffe"
			bound_x			= 38
			bound_height	= 16
			bound_width		= 16
	mount_straddle
		icon			= 'player/_Clothes.dmi'
		icon_state		= "mounted"
		layer			= MOB_LAYER+3
		appearance_flags= KEEP_APART


