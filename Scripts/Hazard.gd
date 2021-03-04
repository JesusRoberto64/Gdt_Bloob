extends RigidBody2D

var col = Color.red
var is_changed = true
onready var life_timer = $LifeTimer

func _ready():
	add_to_group("Hazard")
	add_to_group("Push")


func _draw():
	if mode == MODE_RIGID:
		col = Color(1.0,0.0,0.5,1.0)
		#print("eta arigid")
		pass
	draw_circle(Vector2.ZERO,6,col)
	
	pass

func _on_LifeTimer_timeout():
	queue_free()
	pass # Replace with function body.
