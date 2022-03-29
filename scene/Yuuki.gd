extends "res://lib/TimeTrigger.gd"

const godash = preload("res://addons/godash/godash.gd")
	
const STATES = [
	{
		"anim": "Idle",
		"anchor": "Idle",
		"toggle": null,
	},
	{
		"anim": "Sitting",
		"anchor": "Sitting",
		"toggle": "toggle:sit",
	},
	{
		"anim": "SittingChat",
		"anchor": "Sitting",
		"toggle": "toggle:sit",
	},
	{
		"anim": "Idle",
		"anchor": "Chat",
		"toggle": null,
	},
	{
		"anim": "Idle",
		"anchor": "Counter",
		"toggle": null,
	}
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
	
		
	if s.toggle:
		for i in get_tree().get_nodes_in_group(s.toggle):
			i.visible = false
	global_position = anchors.get_node(s.anchor).global_position	
	sprite.animation = s.anim
