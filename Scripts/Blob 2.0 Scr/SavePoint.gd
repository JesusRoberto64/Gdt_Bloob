extends Area2D

signal save # conncect to loader:: save_status and UI animation:: saving
var init_save = true
var player = null
var pause


func _ready():
	player = get_tree().get_nodes_in_group("Player")[0].get_parent().get_parent()
	pause = get_tree().get_nodes_in_group("Pause")[0]
	connect("save",player,"save_status")
	connect("save",pause,"saving")
	
	
	pass

func _on_SavePoint_body_entered(_body): # coenct to loader and UI saving
	
	if Vars.can_save:
		emit_signal("save")
	
	pass 

func _on_SavePoint_body_exited(_body):
	Vars.can_save = true
	pass # Replace with function body.
