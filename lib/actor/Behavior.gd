extends Node

const Period = preload("res://lib/time/Events.gd").Period

export(String, "center", "table_1", "table_2", "kitchen", "outside", "catbed") var slot = "center"
export(float, 0.0, 3.0) var weight = 1.0
export(NodePath) var anchor
export(String) var animation = "Idle"
export(String) var prioritize = ""
export(Period, FLAGS) var active_time = Period.DAY
export(bool) var awake = true
export(int, FLAGS, "open", "closed") var cafe_open = 3
export(bool) var inside = true
export(bool) var exclusive = false # can only occur on paired prioritization
export(Array, String) var toggle_object = []
export(Array, String) var toggle_on = []

export(bool) var interact = false
export(Array, String) var toggle_interact = []
	
var node setget ,_get_node

func _get_node():
	return get_node(anchor)

func can_interact():
	return len(toggle_interact) > 0 or interact
