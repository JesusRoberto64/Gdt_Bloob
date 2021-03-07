extends ColorRect

onready var gaussian_anim = $AnimationPlayer


func focus():
	gaussian_anim.play("focus")
	pass

func unfocus():
	
	pass

