extends Node2D

func _ready():
	var clock = get_tree().get_nodes_in_group("game_clock")
	if len(clock) > 0:
		clock[0].connect("update", self, "_on_update")
