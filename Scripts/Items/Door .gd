extends Area2D

signal Transition
onready var anim = $AnimationPlayer

func _ready():
	add_to_group("Door")


func _on_Door__body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("Transition")
		anim.play("Win")
		pass
	pass # Replace with function body.
