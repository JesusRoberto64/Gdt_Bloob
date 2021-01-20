extends Node2D

onready var anim = $"Menu controller/AnimationPlayer"
onready var win = $"Menu controller/Sprites/Sprite3"
onready var sprites = $"Menu controller/Sprites"

func _ready():
	sprites.set_visible(false)
	pass

func anim_intro():
	sprites.set_visible(true)
	anim.play("Intro")
	pass

func anim_win():
	anim.play("Intro")
	sprites.set_visible(true)
	win.set_visible(true)
	pass
