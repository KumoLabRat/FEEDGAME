mob/proc

	FUCKINGRIGHTBOI(_color = "#FFFFFF")

		var/obj/O = new/obj
		O.plane=3
		O.SetCenter(Cx(),Cy(),z)
		O.icon = 'slash.dmi'
		O.color = _color
		flick(pick("flash","slice","pop"),O)
		O.appearance_flags = PIXEL_SCALE
		var/matrix/M = matrix()
		M.Turn(rand(1,360))
		M.Scale(rand(5,20)*0.1)
		O.pixel_x = rand(-16,16)
		O.pixel_y = rand(-16,16)
		O.spawndel(5)