extends HBoxContainer

func _ready():
	if has_node("GuestName"):
		get_node("GuestName").text = name
	var ref = GameState.ref("%s:interact" % [name.to_lower()], 0)
	ref.connect("react", self, "_on_interact")
	_on_interact(ref.value, 0)

func _on_interact(new_count, old_count):
	get_node("TimesFed").text = "%02d" % new_count
