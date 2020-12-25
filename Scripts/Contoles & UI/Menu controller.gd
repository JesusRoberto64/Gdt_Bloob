extends Node2D

onready var anim = $AnimationPlayer

func _ready():
	set_visible(false)
	pass

func anim_intro():
	set_visible(true)
	anim.play("Intro")
	pass
