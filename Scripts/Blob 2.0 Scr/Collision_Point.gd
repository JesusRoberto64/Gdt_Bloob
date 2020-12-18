extends KinematicBody2D
onready var colission = $CollisionShape2D
onready var area = $Area2D
signal area_size

func _ready():
	connect("area_size",get_parent(),"grow")
	pass

func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Health"):
		body.queue_free()
		emit_signal("area_size")
	
	pass 
