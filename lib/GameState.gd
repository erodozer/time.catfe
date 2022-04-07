extends Node

const godash = preload("res://addons/godash/godash.gd")

signal stat(id, params)

var data = {}

func _ready():
	if not load_game():
		save_game()
	
func save_game():
	var save_game = File.new()
	save_game.open("user://catfe.save", File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
	
func load_game():
	var path = "user://catfe.save"
	var f = File.new()
	if not f.file_exists(path):
		return false
		
	f.open(path, File.READ)
	
	data = parse_json(f.get_as_text())
	return true
	
