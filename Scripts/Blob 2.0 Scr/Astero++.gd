extends Area2D

var col = Color.green

func _draw():
	#draw_circle(Vector2.ZERO,50,col)
	pass

func _on_Astero_body_entered(body):
	body.get_parent().unlock_ability("Asteropp")
	queue_free()
	pass 
