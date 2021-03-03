extends Control

onready var vinetta = $ColorRect
onready var anim = $AnimationPlayer
onready var save_label = $Saving
onready var spr_pause = $Labels

var is_saving = false
#game Feel 
var is_hurted = false
const hurted_time_max = 0.1
var hurted_time = 0.0

func _ready():
	anim.play("hide")
	spr_pause.hide()

func _process(delta):
	if !is_saving:
		if Input.is_action_just_released("Pause") and is_hurted == false:
			if get_tree().paused == false:
				get_tree().paused = true
				#vinetta.show()
				spr_pause.show()
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
			Vars.reload_vars()
			get_tree().paused = false
			#get_tree().reload_current_scene()
			get_tree().change_scene("res://Levels/GameOver_Reloder.tscn")
			pass
	
	if is_hurted:
		hurted(delta)
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

func hurted(delta):
	
	hurted_time += delta
	get_tree().paused = true
	if hurted_time > hurted_time_max:
		get_tree().paused = false
		hurted_time = 0.0
		is_hurted = false
		pass
	
	pass

