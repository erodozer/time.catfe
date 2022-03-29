extends "./TimeTrigger.gd"

export(bool) var night = false

func _on_update(_time, nt):
	if nt:
		visible = self.night
	else:
		visible = !self.night
