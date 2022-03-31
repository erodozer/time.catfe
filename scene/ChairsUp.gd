extends "res://lib/TimeTrigger.gd"

export(bool) var night = false

onready var set = get_parent()

func _on_update(_time, nt):
	if nt:
		set.visible = self.night
	else:
		set.visible = !self.night