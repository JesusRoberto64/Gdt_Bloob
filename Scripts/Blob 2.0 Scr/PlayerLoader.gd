extends Node2D

export(Script) var game_save_class
onready var Plank_pos = find_node("Area2D")
var save_vars = ["player_pos","hours","Asteros_limit","red_Shield"]
var play_time = 0
onready var Plank_status = get_child(0)
onready var Plank_Hud = find_node("Health_HUD")
signal is_saving # this should be connceted to the Puase CTRL to see animationa

func _ready():
	if not load_status():
		print("error loading")
	
	pass

func _process(delta):
	if Input.is_action_just_released("Save"):
		#save_status()
		pass
	
	play_time += delta
	
	pass

func save_status():
	var new_save = game_save_class.new()
	new_save.player_pos = Plank_pos.global_position
	new_save.hours = play_time
	new_save.Asteros_limit = Plank_status.max_asteros
	new_save.red_Shield = Plank_status.blob[0].can_push 
	#gaurdia 
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	
	ResourceSaver.save("res://saves/save_01.tres",new_save)
	print("salvo ")
	print("en psosicion ", new_save.player_pos)
	print("poss anterior", position)
	emit_signal("is_saving")
	pass

func load_status():
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		print("ERROR loading")
		return false
		pass
	
	var status_save = load("res://saves/save_01.tres")
	if not verify_save(status_save):
		return false
	
	position = status_save.player_pos
	play_time = status_save.hours
	Plank_status.max_asteros = status_save.Asteros_limit
	Plank_Hud.max_asteros = status_save.Asteros_limit
	
	if status_save.red_Shield:
		Plank_status.unlock_ability("push_Hazard")
		pass
	
	print(get_play_time())
	return true
	pass

func verify_save(status_save):
	for v in save_vars:
		if status_save.get(v) == null:
			return false
	return true
	pass

func get_play_time()-> String:
	var seconds = fmod(play_time,60)
	var minutes = fmod(play_time,3600) / 60
	var hours = float(play_time/3600)
	
	var str_elapsed = "%02d : %02d : %02d" % [hours,minutes,seconds]
	return str_elapsed
	pass
