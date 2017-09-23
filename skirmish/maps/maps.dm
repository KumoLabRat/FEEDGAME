

var
	list/available_maps	= newlist(/map/streetside, /map/theatre)

map
	var
		name
		desc		= "no info available."
		spawn_cap	= 10	// the maximum number of enemies that can be alive at once on the map.
		dmm_file

	streetside
		name		= "Streetside"
		desc		= "The classic debut map returns with a little more space!"
		dmm_file	= 'maps/streetside.dmm'
		spawn_cap	= 30

	theatre
		name		= "Theatre"
		desc		= "A decrepit old theatre full of dangers."
		dmm_file	= 'maps/theatre.dmm'
		spawn_cap	= 30

	evacuate
		name		= "Evacuate"
		desc		= "Downtown is evacuated and the streets are overrun! Can you survive the onslaught?"
		dmm_file	= 'maps/evacuate.dmm'
		spawn_cap	= 25

	test_range
		name		= "Secret Test Room"
		desc		= "testing!"
		dmm_file	= 'maps/test range.dmm'
		spawn_cap	= 5
	crap_map
		name 		= "Crap Map"
		desc		= "This map is crappy."
		dmm_file 	= 'maps/crap_map.dmm'
		spawn_cap = 20