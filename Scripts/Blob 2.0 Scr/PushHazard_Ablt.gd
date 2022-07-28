extends Area2D

var col = Color.pink
var is_showing = false

func _ready():
	modulate.a = 0
	pass

func _process(delta):
	if is_showing:
		modulate.a += 0.5*delta
		modulate.a  = clamp(modulate.a,0,1.0)
		pass
	pass

func _draw():
	#draw_circle(Vector2.ZERO,50,col)
	pass


func _on_PushHazard_Ablt_body_entered(body):
	body.get_parent().unlock_ability("push_Hazard")
	queue_free()
	pass # Replace with function body.

func appear_item():
	is_showing = true 
	pass
