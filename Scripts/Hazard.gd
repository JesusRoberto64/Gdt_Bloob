extends RigidBody2D

var col = Color.red
var is_changed = true
onready var life_timer = $LifeTimer

enum STATE{FOOD,STATIC}
export (STATE) var state

var changed = false

func _ready():
	add_to_group("Hazard")
	add_to_group("Push")


func _draw():
	if mode == MODE_RIGID:
		col = Color(1.0,0.0,0.5,1.0)
		#print("eta arigid")
		state = STATE.FOOD
		if !changed:
			contact_monitor = true
			contacts_reported = 1
			changed = true
		
		pass
	draw_circle(Vector2.ZERO,15,col)
	pass

func _on_LifeTimer_timeout():
	queue_free()
	pass # Replace with function body.

func _on_Hazard_body_entered(body):
	if body.is_in_group("Brachi"):
		body.disable()
		queue_free()
	pass # Replace with function body.


