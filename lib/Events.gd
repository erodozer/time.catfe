extends Node

const godash = preload("res://addons/godash/godash.gd")

export(bool) var force_nighttime = false
export(bool) var force_daytime = false
export(int) var update_rate = 900

var next_update = 0

signal update(time, night)

func _ready():	
	next()

func next():
	var dt = OS.get_datetime(true)
	
	dt.minute = dt.minute - (dt.minute % 15)
	dt.second = 0
	
	var now = OS.get_unix_time_from_datetime(dt)
	next_update = now + update_rate
	
	# toggle day and night elements
	var is_nighttime = dt.hour < 6 or dt.hour > 21
	
	emit_signal("update", now, (is_nighttime or force_nighttime) and !force_daytime)
	
func _process(_delta):
	var now = OS.get_unix_time()
	if now > next_update:
		next()
