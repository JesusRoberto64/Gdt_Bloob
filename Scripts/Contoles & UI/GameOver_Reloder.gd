extends Node2D
var time = 0.0
var max_time = 0.5

func _process(delta):
	
	time += delta
	if time > max_time:
		get_tree().change_scene("res://Levels/ProtoLvl.tscn")
		
	pass
