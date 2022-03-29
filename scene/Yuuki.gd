extends "res://lib/TimeTrigger.gd"

const godash = preload("res://addons/godash/godash.gd")

const STATES = [
	"idle",
	"sit"
]

onready var sprite = get_node("AnimatedSprite")
onready var anchors = get_node("../Anchors")

func _on_update(_time, night):
	if night:
		sprite.animation = "Sleeping"
		return
	
	var s = godash.rand_choice(STATES)
	
	for i in get_tree().get_nodes_in_group("toggle"):
		i.visible = true
	
	match s:
		"sit":
			for i in get_tree().get_nodes_in_group("toggle:sit"):
				i.visible = false
		
			sprite.animation = "Sitting"
			global_position = anchors.get_node("Sitting").global_position
		_:
			sprite.animation = "Idle"
			global_position = anchors.get_node("Idle").global_position
