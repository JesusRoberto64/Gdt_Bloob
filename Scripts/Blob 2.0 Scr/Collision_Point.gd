extends KinematicBody2D
onready var colission = $CollisionShape2D
onready var area = $Area2D
signal area_size
signal hurt
signal enter_door

onready var planc = get_parent()

func _ready():
	connect("area_size",get_parent(),"grow")
	connect("hurt",get_parent(),"hurt")
	connect("enter_door",get_parent(),"enter_door")
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Health"):
		body.queue_free()
		emit_signal("area_size")
	
	if body.is_in_group("Hazard"):
		#print("Touched Hazard")
		emit_signal("hurt")
		pass
	
	if body.is_in_group("Door"):
		
		emit_signal("enter_door")
		pass
	
	pass 

func _draw():
	draw_circle(Vector2.ZERO,5.0,Color.greenyellow)
	pass
