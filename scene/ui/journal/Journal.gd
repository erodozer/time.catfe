extends Control

const GuestRecord = preload("./Guest.tscn")

onready var anim = get_node("AnimationPlayer")
onready var awake_time = get_node("TimeManagement/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/AwakeTime")
onready var open_time = get_node("TimeManagement/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/OpenTime")
onready var sleep_time = get_node("TimeManagement/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/SleepTime")
onready var close_time = get_node("TimeManagement/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CloseTime")

var open = false

var menu = null

func _ready():
	var list = get_node("PanelContainer/MarginContainer/VBoxContainer/GuestList")
	
	for i in ["Maia", "Chie", "Elveira"]:
		var record = GuestRecord.instance()
		record.name = i
		list.add_child(record)
		
	var time = GameState.ref("played", 0)
	time.connect("react", self, "update_time")
	
	update_time(time.value, 0)
	
	sleep_time.value = Clock.sleep_time
	awake_time.value = Clock.awake_time
	close_time.value = Clock.close_time
	open_time.value = Clock.open_time	
		
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if open and menu == "journal":
				close_journal()
			elif open and menu == "time":
				close_time_management()
	
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
		menu = "journal"
	
func close_journal():
	anim.play_backwards("ShowJournal")
	open = false

	mouse_default_cursor_shape = Control.CURSOR_ARROW
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func open_time_management(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		accept_event()
		open = true
		anim.play("ShowTime")
		
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		mouse_filter = Control.MOUSE_FILTER_STOP
		menu = "time"
	
func close_time_management():
	anim.play_backwards("ShowTime")
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

func _validate_open_time(value):
	if value >= Clock.close_time:
		value = Clock.close_time - 1
		open_time.value = value
	
	Clock.open_time = value
	
	if value < Clock.awake_time:
		awake_time.value = value
		Clock.awake_time = value
	
func _validate_awake_time(value):
	if value >= Clock.sleep_time:
		value = Clock.sleep_time - 1
		awake_time.value = value
		
	Clock.awake_time = value
	
	if Clock.open_time < value:
		open_time.value = value
		Clock.open_time = value

func _validate_close_time(value):
	if value <= Clock.open_time:
		value = Clock.open_time + 1
		close_time.value = value
		
	Clock.close_time = value
	
	if Clock.sleep_time < value:
		sleep_time.value = value
		Clock.sleep_time = value

func _validate_sleep_time(value):
	if value <= Clock.awake_time:
		value = Clock.awake_time + 1
		close_time.value = value

	Clock.sleep_time = value
	
	if Clock.close_time > value:
		close_time.value = value
		Clock.close_time = value
	
