extends Node

const godash = preload("res://addons/godash/godash.gd")

export(int) var update_rate = 900
var tz = OS.get_time_zone_info().bias / 60
var mode = 0

var next_update = 0

signal update(time, night)

func next():
	var dt = OS.get_datetime(true)
	
	dt.minute = dt.minute - (dt.minute % 15)
	dt.second = 0
	
	var now = OS.get_unix_time_from_datetime(dt)
	next_update = now + update_rate
	
	dt = OS.get_datetime(false) # daytime/nighttime will match the rendered clock
	
	# toggle day and night elements
	var is_nighttime = dt.hour < 6 or dt.hour > 21
	
	emit_signal("update", now, (is_nighttime or mode == 2) and !(mode == 1))
	
func _process(_delta):
	var now = OS.get_unix_time()
	if now > next_update:
		next()

func set_mode(m):
	self.mode = m
	
func set_tz(t):
	self.tz = t
	
