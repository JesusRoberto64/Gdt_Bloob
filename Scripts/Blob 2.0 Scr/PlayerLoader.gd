extends Node2D

export(Script) var game_save_class
onready var Plank = find_node("Area2D")
var save_vars = ["player_pos","hours"]
var play_time = 0

func _ready():
	if not load_status():
		print("error loading")
	pass

func _process(delta):
	if Input.is_action_just_released("Save"):
		save_status()
	
	play_time += delta
	
	var seconds = fmod(play_time,60)
	var minutes = fmod(play_time,3600) / 60
	var hours = float(play_time/3600)
	
	var str_elapsed = "%02d : %02d : %02d" % [hours,minutes,seconds]
	
	#print("contador: ", str_elapsed)
	
	pass

func save_status():
	var new_save = game_save_class.new()
	new_save.player_pos = Plank.global_position
	new_save.hours = play_time
	#gaurdia 
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
	
	ResourceSaver.save("res://saves/save_01.tres",new_save)
	print("salvo ")
	print("en psosicion ", new_save.player_pos)
	print("poss anterior", position)
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
	return true
	pass

func verify_save(status_save):
	for v in save_vars:
		if status_save.get(v) == null:
			return false
	
	return true
	
	pass
