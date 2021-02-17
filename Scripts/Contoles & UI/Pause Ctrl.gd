extends Control

onready var vinetta = $ColorRect
onready var anim = $AnimationPlayer
onready var save_label = $Saving

var is_saving = false


func _ready():
	anim.play("hide")
	

func _process(_delta):
	if !is_saving:
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
			#get_tree().reload_current_scene()
			get_tree().change_scene("res://Levels/GameOver_Reloder.tscn")
			
			pass
	pass

func saving():
	anim.play("Saving")
	save_label.show()
	is_saving = true
	get_tree().paused = true
	pass

func stop_saving():
	is_saving = false
	save_label.hide()
	get_tree().paused = false
