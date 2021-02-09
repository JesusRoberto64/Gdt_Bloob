extends Area2D

signal save # conncect to loader:: save_status and UI animation:: saving
var init_save = true

func _draw():
	draw_circle(Vector2.ZERO,50,Color.blue)

func _on_SavePoint_body_entered(body): # coenct to loader and UI saving
	if !init_save:
		emit_signal("save")
	init_save = false
	pass 
