extends Node

func _ready():
	Clock.connect("update", self, "_on_update")
