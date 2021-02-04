extends Control

onready var vinetta = $ColorRect
onready var anim = $AnimationPlayer

func _ready():
	anim.play("hide")


func _process(_delta):
	
	if Input.is_action_just_released("Pause"):
		if get_tree().paused == false:
			get_tree().paused = true
			#vinetta.show()
			anim.play("show")
		else :
			get_tree().paused = false
			#vinetta.hide()
			anim.play("hide")
		pass
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		pass
	
	if Input.is_action_just_pressed("restart"):
		
		get_tree().paused = false
		get_tree().reload_current_scene()
		pass
	
	pass
