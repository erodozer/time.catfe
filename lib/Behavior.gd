extends Node

export(String, "center", "table_1", "table_2", "kitchen", "outside", "catbed") var slot = "center"
export(float, 0.0, 3.0) var weight = 1.0
export(NodePath) var anchor
export(String) var animation = "Idle"
export(String) var prioritize = ""
export(bool) var night = false
export(bool) var inside = true
export(bool) var exclusive = false # can only occur on paired prioritization
export(Array, String) var toggle_object = []
	
var node setget ,_get_node

func _get_node():
	return get_node(anchor)
