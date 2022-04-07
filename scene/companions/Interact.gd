extends Control

export(NodePath) var controller_ref

signal interact

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("interact")
