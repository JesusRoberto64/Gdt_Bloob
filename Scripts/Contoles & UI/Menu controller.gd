extends Node2D

onready var anim = $AnimationPlayer
onready var win = $Sprite3

func _ready():
	set_visible(false)
	pass

func anim_intro():
	set_visible(true)
	anim.play("Intro")
	pass

func anim_win():
	anim.play("Intro")
	set_visible(true)
	win.set_visible(true)
	pass
