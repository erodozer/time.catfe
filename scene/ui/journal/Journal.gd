extends Control

const GuestRecord = preload("./Guest.tscn")

onready var anim = get_node("AnimationPlayer")

var open = false

func _ready():
	var list = get_node("PanelContainer/MarginContainer/VBoxContainer/GuestList")
	
	for i in ["Maia", "Chie", "Elveira"]:
		var record = GuestRecord.instance()
		record.name = i
		list.add_child(record)
		
	var time = GameState.ref("played", 0)
	time.connect("react", self, "update_time")
	
	update_time(time.value, 0)
		
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if open:
				close_journal()
	
# Called when the node enters the scene tree for the first time.
func _notification(n):
	match n:
		MainLoop.NOTIFICATION_WM_MOUSE_ENTER:
			if not open:
				anim.play("ShowIcon")
		MainLoop.NOTIFICATION_WM_MOUSE_EXIT:
			if not open:
				anim.play_backwards("ShowIcon")

func open_journal(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		accept_event()
		open = true
		anim.play("ShowJournal")
		
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		mouse_filter = Control.MOUSE_FILTER_STOP
	
func close_journal():
	anim.play_backwards("ShowJournal")
	open = false

	mouse_default_cursor_shape = Control.CURSOR_ARROW
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func update_time(new_time, old_time):
	var minutes = int(new_time / (1000 * 60)) % 60
	var hours = int(new_time / (60 * 60 * 1000)) % 24
	var days = int(new_time / (24 * 60 * 60 * 1000))
	get_node("PanelContainer/MarginContainer/VBoxContainer/Time Spent/Time").text = "%03dd %02dh %02dm" % [
		days,
		hours,
		minutes
	]
