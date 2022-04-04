extends "res://lib/TimeTrigger.gd"

export(bool) var night = false

onready var set = get_parent()

func _on_update(time, nt, open):
	if open:
		set.visible = self.night
	else:
		set.visible = !self.night
