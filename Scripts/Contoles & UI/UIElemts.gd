extends Node2D

onready var anim = $AnimationPlayer

func show_ui():
	anim.play("dead")
	
