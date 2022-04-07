extends Node

enum Period {
	DAWN = 0b0001,
	DAY = 0b0010,
	DUSK = 0b0100,
	NIGHT = 0b1000,
}

const godash = preload("res://addons/godash/godash.gd")

export(int) var update_rate = 900
var tz = OS.get_time_zone_info().bias / 60

var next_update = 0

signal update(hour, period, cafe_open)

func next():
	Slots.reset()
	
	var dt = OS.get_datetime(true)
	
	dt.minute = dt.minute - (dt.minute % 15)
	dt.second = 0
	
	var now = OS.get_unix_time_from_datetime(dt)
	next_update = now + update_rate
	
	dt = OS.get_datetime_from_unix_time(OS.get_unix_time() + (3600 * Clock.tz)) # daytime/nighttime will match the rendered clock
	
	# toggle day and night elements
	var period
	var hour = dt.hour
	
	
	if dt.hour < 5:
		period = Period.NIGHT
	elif dt.hour < 7:
		period = Period.DAWN
	elif dt.hour < 18:
		period = Period.DAY
	elif dt.hour < 20:
		period = Period.DUSK
	else:
		period = Period.NIGHT
		
	var cafe_open = dt.hour >= 8 and dt.hour < 19
	
	emit_signal("update", hour, period, cafe_open)
	
func _process(_delta):
	var now = OS.get_unix_time()
	if now > next_update:
		next()
	
func set_tz(t):
	self.tz = t
	
