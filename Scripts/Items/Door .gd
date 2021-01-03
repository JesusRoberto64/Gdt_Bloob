extends StaticBody2D

func _ready():
	add_to_group("Door")

func _draw():
	draw_circle(Vector2.ZERO,15,Color.goldenrod)
	pass
