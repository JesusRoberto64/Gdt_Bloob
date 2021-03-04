extends Node2D

enum ITEMS{Astero,Shield}
export(ITEMS) var cur_item

export(Script) var game_save_class
var save_vars = ["Demo_data"]
signal is_saving

#key element 
export var item = "" 

func _ready():
	
	if not load_status():
		print("error loading ITEM")
	
	pass

func save_status():
	var new_save = game_save_class.new()
	#Checking previous save
	var previous_save = load("res://saves/save_01.tres")
	if not verify_save(previous_save):
		print("Error checking previous saved")
		return false
	
	new_save = previous_save
	new_save.first_Time = false
	#guardia 
	if !new_save.Demo_data.has(item):
		print("no data found item")
		return
		pass
	new_save.Demo_data[item] = false
	
	#gaurdia 
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	
	ResourceSaver.save("res://saves/save_01.tres",new_save)
	print("salvo ")
	emit_signal("is_saving")
	pass

func load_status():
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		print("ERROR loading item")
		return false
		pass
	
	var status_save = load("res://saves/save_01.tres")
	if not verify_save(status_save):
		return false
	#Guardia 
	
	if !status_save.Demo_data.has(item):
		print("no found load data item")
		return false
		pass
	
	if !status_save.Demo_data[item]:
		queue_free()
		pass
	
	return true
	pass

func verify_save(status_save):
	for v in save_vars:
		if status_save.get(v) == null:
			return false
	return true
	pass

