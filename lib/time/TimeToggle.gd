extends "./TimeTrigger.gd"

export(Clock.Period, FLAGS) var active_time = Clock.Period.DAY
export(int, FLAGS, "open", "closed") var cafe_state = 3

onready var container = get_parent()

func _on_update(time, period, flags):
	var cafe_open = flags[0]
	
	var f = 1 if cafe_open else 2
	
	if cafe_state == 3:
		container.visible = period & active_time > 0
	else:
		container.visible = cafe_state & f > 0
	
