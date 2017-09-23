mob/player
	var tmp/list/selected
	proc/purge_dancers()
		if(selected)
			for(var/atom/a in selected)
				a.stop_dancing()
				if(a.icon_state == "right-light") a.icon_state = "right"
				if(a.icon_state == "left-light") a.icon_state = "left"
				selected -= a

atom
	proc
		dance(mob/player/p)
			if(!p.selected)
				p.selected = new
			p.selected += src
			animate(src,time = 5,transform = matrix(x_offset,-1,MATRIX_TRANSLATE),loop = -1)
			animate(time = 5,transform = matrix(x_offset,y_offset,MATRIX_TRANSLATE))
		stop_dancing()
			animate(src,transform = matrix(x_offset,y_offset,MATRIX_TRANSLATE))