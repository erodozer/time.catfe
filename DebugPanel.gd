extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false 

	var tz = get_node("VBoxContainer/TimeZone")
	tz.value = Clock.tz
	tz.connect("value_changed", Clock, "set_tz")

	var modes = get_node("VBoxContainer/TimeMode")
	modes.add_item("Auto")
	modes.add_item("Day")
	modes.add_item("Night")
	modes.select(0)
	modes.connect("item_selected", Clock, "set_mode")
	
	get_node("VBoxContainer/NextAction").connect("pressed", Clock, "next")
	get_node("VBoxContainer/EjectAction").connect("pressed", self, "eject_guests")

func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible
	
func eject_guests():
	for g in get_tree().get_nodes_in_group("actor"):
		g.eject_from_shop()
