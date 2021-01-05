extends RigidBody2D

func _ready():
	add_to_group("Hazard")
	add_to_group("Push")

func _draw():
	draw_circle(Vector2.ZERO,15,Color.red)
	pass
