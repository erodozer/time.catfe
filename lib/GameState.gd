extends Node

const godash = preload("res://addons/godash/godash.gd")

signal stat(id, params)

class Reactive:
	var value setget set_value
	
	signal react(new_value, old_value)
	
	func _init(initial_value = null):
		value = initial_value
	
	func set_value(v):
		var old = value
		value = v
		
		emit_signal("react", v, old)
	
var data = {}

func ref(name, initial_value = null) -> Reactive:
	var r = data.get(name, Reactive.new(initial_value))
	data[name] = r
	return r

func _ready():
	if not load_game():
		save_game()
	
func save_game():
	var save_game = File.new()
	
	var save = {}
	
	for ref in data:
		save[ref] = data[ref].value
	
	save_game.open("user://catfe.save", File.WRITE)
	save_game.store_line(to_json(save))
	save_game.close()
	
func load_game():
	var path = "user://catfe.save"
	var f = File.new()
	if not f.file_exists(path):
		return false
		
	f.open(path, File.READ)
	
	var save = parse_json(f.get_as_text())
	
	data = {}
	for record in save:
		data[record] = Reactive.new(save[record])
	
	return true
	
