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

func _draw():
	draw_circle(Vector2.ZERO,50,Color.blue)

func _on_SavePoint_body_entered(body): # coenct to loader and UI saving
	if !init_save:
		emit_signal("save")
	init_save = false
	pass 
