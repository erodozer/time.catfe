extends "res://lib/TimeTrigger.gd"

enum CafeOpen {
	ALWAYS,
	OPEN,
	CLOSED
}

export(Clock.Period, FLAGS) var active_time = Clock.Period.DAY
export(CafeOpen) var cafe_open = CafeOpen.ALWAYS

onready var container = get_parent()

func _on_update(time, period, open):
	if open and cafe_open == CafeOpen.ALWAYS:
		container.visible = period & active_time > 0
	elif open and cafe_open == CafeOpen.OPEN:
		container.visible = true
	elif not open and cafe_open == CafeOpen.CLOSED:
		container.visible = true
	else:
		container.visible = false
