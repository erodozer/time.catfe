extends Node

const DAY_NIGHT = {
	Clock.Period.DAWN: {
		"background": "Dawn",
		"modulate": Color("#cc9bc7"),
	},
	Clock.Period.DAY: {
		"background": "Day",
		"modulate": Color("#ffffff"),
	},
	Clock.Period.DUSK: {
		"background": "Dusk",
		"modulate": Color("#ffd7c2"),
	},
	Clock.Period.NIGHT: {
		"background": "Night",
		"modulate": Color("#3f377a"),
	}
}

func _ready():
	Clock.connect("update", self, "_on_update")
	Clock.next()
	
func _on_update(time, period, cafe_open):
	var outside = get_node("Outside")
	var cafe = get_node("Cafe")
	
	cafe.modulate = DAY_NIGHT[period].modulate

	for c in outside.get_children():
		c.visible = false

	outside.get_node(DAY_NIGHT[period].background).visible = true
