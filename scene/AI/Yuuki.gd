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
		"slot": "chair",
	},
	{
		"anim": "SittingChat",
		"anchor": "Sitting",
		"toggle": "toggle:sit",
		"slot": "chair",
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
	},
	{
		"anim": "Play",
		"anchor": "Playing",
		"interact": "cat",
		"toggle": null,
		"slot": "play",
	},
	{
		"anim": "Singing",
		"anchor": "Idle",
		"toggle": null,
		"onlyOne": true,
	},
	{
		"anim": "Kitchen",
		"anchor": "Kitchen",
		"toggle": null,
	},
	{
		"anim": "Kitchen",
		"anchor": "Coffee",
		"toggle": null,
	},
]

const NIGHT_STATES = [
	{
		"anim": "Sleeping",
		"anchor": "Idle",
		"toggle": null,
	},
	{
		"anim": "Sleeping_02",
		"anchor": "Idle",
		"toggle": null,
	}
]

onready var container = get_parent()
onready var sprite = get_node("../AnimatedSprite")
onready var anchors = get_node("Anchors")

var current = STATES[0]
var slot = null

func _on_update(_time, night):
	var selection = STATES if not night else NIGHT_STATES
	
	
	
	var s = godash.rand_choice(selection)
	
	for i in get_tree().get_nodes_in_group("toggle"):
		i.visible = true
	
	if s.toggle:
		var toggled = get_tree().get_nodes_in_group(s.toggle)
		for i in toggled:
			i.visible = false
	
	container.global_position = anchors.get_node(s.anchor).global_position	
	sprite.animation = s.anim
	
	current = s
	
