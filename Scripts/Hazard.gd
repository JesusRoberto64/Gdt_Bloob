extends RigidBody2D

func _ready():
	add_to_group("Hazard")

func _draw():
	draw_circle(Vector2.ZERO,15,Color.red)
	pass
