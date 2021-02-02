extends Area2D

var col = Color.pink

func _draw():
	draw_circle(Vector2.ZERO,50,col)


func _on_PushHazard_Ablt_body_entered(body):
	body.get_parent().unlock_ability("push_Hazard")
	queue_free()
	pass # Replace with function body.
