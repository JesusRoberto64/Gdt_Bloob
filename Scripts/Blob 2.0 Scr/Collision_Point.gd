extends KinematicBody2D
onready var colission = $CollisionShape2D
onready var area = $Area2D
signal area_size(body)
signal hurt
signal enter_door

onready var planc = get_parent()

var is_hurt = false

onready var timer = $Timer

func _ready():
	connect("area_size",get_parent(),"grow")
	connect("hurt",get_parent(),"hurt")
	connect("enter_door",get_parent(),"enter_door")
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Health"):
		body.queue_free()
		emit_signal("area_size",body)
	
	if body.is_in_group("Hazard"):
		#print("Touched Hazard")
		emit_signal("hurt")
		is_hurt = true
		timer.start()
		update()
		pass
	
	if body.is_in_group("Door"):
		
		emit_signal("enter_door")
		pass
	
	pass 


func _draw():
	if !is_hurt:
		draw_circle(Vector2.ZERO,10.0,Color.greenyellow)
	else:
		draw_circle(Vector2.ZERO,10.0,Color.red)
	pass

func _on_Timer_timeout():
	is_hurt = false
	update()
	pass # Replace with function body.
