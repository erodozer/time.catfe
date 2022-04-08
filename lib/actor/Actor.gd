extends "res://lib/time/TimeTrigger.gd"

const godash = preload("res://addons/godash/godash.gd")
const Behavior = preload("res://lib/actor/Behavior.gd")

const SHOP_STAY = 12 # stay for one hour
const SHOP_REVISIT = 16 # guests can appear only once per 1.5-3hr

export(String, "host", "guest", "cat") var actor_type = "host"

onready var behaviors = get_node("Behaviors").get_children()
onready var anchors = get_node("Anchors")
onready var container = get_parent()
onready var sprite = get_node("../AnimatedSprite")
onready var interact = get_node("../Interact")

var current = null
var actions = 0
var wait = 0
var interacted = false

func prioritize_action():
	for b in behaviors:
		var slot = Slots.locations[b.slot]
		var prioritized = b.prioritize and len(get_tree().get_nodes_in_group(b.prioritize)) > 0
		var balance = slot.balance
		var fits = balance + b.weight <= slot.capacity
		
		if prioritized and fits:
			return b
	return null

func pick_action(period, cafe_open, awake):
	var f = 1 if cafe_open else 2
	
	# only allow picking actions for the current time period
	var choices = []
	for b in behaviors:
		if actions > 0 and not b.inside:
			continue
			
		if actor_type == "host":
			if b.awake != awake or b.cafe_open & f == 0:
				continue
		
		var slot = Slots.locations[b.slot]
		
		if b.active_time & period > 0 \
		and not b.exclusive \
		and slot.balance + b.weight <= slot.capacity:
			choices.append(b)
	
	if len(choices) == 0:
		return false
	
	var a = godash.rand_choice(choices) as Behavior
		
	return a

func set_action(action: Behavior, time):
	var prev = current
	current = action
	
	if prev:
		for obj in prev.toggle_object:
			var toggled = get_tree().get_nodes_in_group(obj)
			for t in toggled:
				t.visible = true
		for obj in prev.toggle_on:
			var toggled = get_tree().get_nodes_in_group(obj)
			for t in toggled:
				t.visible = false
		remove_from_group("%s:%s" % [container.name.to_lower(), prev.name.to_lower()])
			
	container.global_position = action.node.global_position
	container.scale = action.node.scale
	container.z_index = action.node.z_index
	sprite.animation = action.animation
	
	var slot = Slots.locations[action.slot]
	slot.balance += action.weight
	for obj in action.toggle_object:
		var toggled = get_tree().get_nodes_in_group(obj)
		for t in toggled:
			t.visible = false
			
	for obj in action.toggle_on:
		var toggled = get_tree().get_nodes_in_group(obj)
		for t in toggled:
			t.visible = true
	
	if not prev or not prev.inside:
		if action.inside and actor_type == "guest":
			Slots.bodies += 1
			print("Actor entering: %s " % [container.name])
			actions = SHOP_STAY
	
	add_to_group("%s:%s" % [container.name.to_lower(), action.name.to_lower()])
	# print("actor groups: %s" % PoolStringArray(get_groups()).join(", "))
	
	var interacted = false
	
	if interact:
		interact.mouse_filter = Control.MOUSE_FILTER_IGNORE if not action.can_interact() else Control.MOUSE_FILTER_STOP
		
func eject_from_shop():
	if actor_type != "guest":
		return
		
	# remove body
	if current and current.inside:
		wait = SHOP_REVISIT + (randi() % SHOP_REVISIT)
		print("Actor ejected: %s " % [container.name])
		Slots.bodies -= 1
		
	# if the character has a behavior that renders them
	# outside the shop, put them there
	for b in behaviors:
		if not b.inside:
			set_action(b, 0)
			return
		
func _on_update(time, period, cafe_flags):
	if not container.visible:
		return
	
	var cafe_open = cafe_flags[0]
	var awake = cafe_flags[1]
	
	reset_interaction()
	
	if actor_type == "guest":
		# guests can not be in the shop after it closes
		if not cafe_open:
			eject_from_shop()
			return
		
		# keep outside until allowed
		if wait > 0 and current and not current.inside:
			wait -= 1
			return
		
		if current and current.inside:
			actions -= 1
			
			if actions <= 0:
				eject_from_shop()
				return
		elif Slots.bodies + 1 > Slots.capacity:
			eject_from_shop()
			return
		
	var a = prioritize_action()
	var attempt = 0
	while not a and (attempt < 3 or current == null):
		attempt += 1
		a = pick_action(period, cafe_open, awake)
		
	if a:
		set_action(a, time)

func reset_interaction():
	interacted = false
	
	if not current:
		return
	
	for obj in current.toggle_interact:
		var toggled = get_tree().get_nodes_in_group(obj)
		for t in toggled:
			t.visible = false
			
	if interact:
		interact.mouse_filter = Control.MOUSE_FILTER_IGNORE if not current.can_interact() else Control.MOUSE_FILTER_STOP
			
func _on_interact():
	if interacted:
		return
		
	if not current.interact:
		return
		
	interacted = true
	
	get_node("../AnimationPlayer").play("Emote")
	
	var interact_key = "%s:interact" % [container.name.to_lower()]
	var ref = GameState.ref(interact_key, 0)
	ref.value = ref.value + 1
	
	for obj in current.toggle_interact:
		var toggled = get_tree().get_nodes_in_group(obj)
		for t in toggled:
			t.visible = true
			
	interact.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# auto save each interaction
	GameState.save_game()
	
