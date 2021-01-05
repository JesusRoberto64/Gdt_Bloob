extends RigidBody2D

export(bool) var is_key = false

func _ready():
	add_to_group("Push")
	if is_key:
		add_to_group("keyes")
