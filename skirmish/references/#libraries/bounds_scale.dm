
/*	written by some faggot named Unwanted4Murder.
*/

// This uh... this is the whole thing.  Just call Bounds_Scale(whatever) and it'll set your bounds for you.  You're welcome.

mob/proc/bounds_scale(_scale)
	var icon/i = new(icon)
	if(_scale > 1)
		bound_x = (initial(bound_x) + (initial(bound_x) - (i.Width() / 2)) * (_scale - 1))
		bound_y = (initial(bound_y) + (initial(bound_y) - (i.Height() / 2)) * (_scale - 1))
	else
		bound_x = (initial(bound_x) - (initial(bound_x) - (i.Width() / 2)) * (_scale - 1))
		bound_y = (initial(bound_y) - (initial(bound_y) - (i.Height() / 2)) * (_scale - 1))
	bound_width = initial(bound_height) * _scale
	bound_height = initial(bound_width) * _scale