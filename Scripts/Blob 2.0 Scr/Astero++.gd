extends Area2D

var col = Color.green
onready var dummie = get_parent()

func _draw():
	#draw_circle(Vector2.ZERO,50,col)
	pass

func _on_Astero_body_entered(body):
	body.get_parent().unlock_ability("Asteropp")
	dummie.save_status()
	queue_free()
	pass 
