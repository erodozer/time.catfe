extends "res://lib/TimeTrigger.gd"

const godash = preload("res://addons/godash/godash.gd")
const Behavior = preload("res://lib/Behavior.gd")

onready var behaviors = get_node("Behaviors").get_children()
onready var anchors = get_node("Anchors")
onready var container = get_parent()
onready var sprite = get_node("../AnimatedSprite")

var current = null

func pick_action():
	var a = godash.rand_choice(behaviors) as Behavior
	
	var body_count = Slots.bodies
	if current and current.inside:
		body_count -= 1
	
	if a.inside and body_count + 1 > Slots.capacity:
		return false
	
	var slot = Slots.locations[a.slot]
	if slot.balance + a.weight > slot.capacity:
		return false
		
	return a

func set_action(action: Behavior):
	if current:
		Slots.locations[current.slot].balance -= current.weight
		if current.inside:
			Slots.bodies -= 1
		
	current = action
	
	container.global_position = action.node.global_position
	sprite.animation = action.animation
	Slots.locations[action.slot].balance += action.weight
	
	if action.inside:
		Slots.bodies += 1

func _on_update(time, night):
	for s in Slots.locations:
		var slot = Slots.locations[s]
		if slot.balance > 0:
			for b in behaviors:
				if b.night == night and b.prioritize and slot.balance + b.weight <= slot.capacity:
					set_action(b)
					return
	
	var a = null
	var attempt = 0
	while not a and attempt < 3:
		a = pick_action()
		if a and a.night != night:
			a = null
			continue
			
		attempt += 1
		
	if a:
		set_action(a)
