extends Label

var hr24_mode = false

const Months = [
	"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
]

const WkDay = [
	"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	var dt = OS.get_datetime_from_unix_time(OS.get_unix_time() + (3600 * Clock.tz))
	
	var wkd = WkDay[dt.weekday]
	var month = Months[dt.month - 1]
	
	if hr24_mode:
		self.text = "%s %d %s\n%02d:%02d:%02d" % [month, dt.day, wkd, dt.hour, dt.minute, dt.second]
	else:
		var afternoon = "PM" if dt.hour >= 12 else "AM"
		var to_12 = 12 if dt.hour % 12 == 0 else dt.hour % 12
		self.text = "%s %d %s\n%02d:%02d:%02d %s" % [month, dt.day, wkd, to_12, dt.minute, dt.second, afternoon]

func _on_Label_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
				hr24_mode = !hr24_mode
