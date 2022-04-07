extends HBoxContainer

func _ready():
	if has_node("GuestName"):
		get_node("GuestName").text = name
	GameState.ref("%s:interact" % [name.to_lower()], 0).connect("react", self, "_on_interact")

func _on_interact(new_count, old_count):
	get_node("TimesFed").text = "%02d" % new_count
