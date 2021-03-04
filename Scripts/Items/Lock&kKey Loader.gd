extends Node2D

enum LEVELS{DEMO,EDEN}
export(LEVELS) var level

export(Script) var game_save_class
var save_vars = ["Demo_data"]
var gates = []
signal is_saving

func _ready():
	for i in get_children():
		if i.is_in_group("Gate"):
			gates.append(i)
			pass
		pass
	
	if not load_status():
		print("error loading lock and key")
	
	pass

func _process(_delta):
	if Input.is_action_just_released("Save"):
		#save_status()
		pass
	
	pass

func save_status():
	var new_save = game_save_class.new()
	
	new_save.Demo_data["1_Door_open"] = gates[0].is_opening
	new_save.Demo_data["2_Door_open"] = gates[1].is_opening
	
	
	#gaurdia 
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	
	ResourceSaver.save("res://saves/save_level_01.tres",new_save)
	print("salvo ")
	emit_signal("is_saving")
	pass

func load_status():
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		print("ERROR loading lock and key")
		return false
		pass
	
	var status_save = load("res://saves/save_level_01.tres")
	if not verify_save(status_save):
		return false
	
#	position = status_save.player_pos
#	play_time = status_save.hours
#	Plank_status.max_asteros = status_save.Asteros_limit
#	Plank_Hud.max_asteros = status_save.Asteros_limit
	
	gates[0].is_opening = status_save.Demo_data["1_Door_open"]
	gates[1].is_opening = status_save.Demo_data["2_Door_open"]
	
	#print (status_save.Demo_data["1_Door_open"])
	
	return true
	pass

func verify_save(status_save):
	for v in save_vars:
		if status_save.get(v) == null:
			return false
	return true
	pass
