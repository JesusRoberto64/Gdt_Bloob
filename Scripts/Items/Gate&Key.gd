extends Node2D

onready var lock_N_Key = $"Lock&KeyArea" 
onready var gate_kine = $Gatekine
var dir_open = Vector2.ZERO
#var dir_close = Vector2.ZERO # negative from open
var gate_vel = 50
var is_opening = true
var limit_gate = false

enum DIR_GATE {UP,DOWN,RIGHT,LEFT,ZERO}
export(DIR_GATE) var direction_gate

var collition_vel

func _ready():
	match direction_gate:
		DIR_GATE.DOWN:
			dir_open = Vector2.DOWN
		DIR_GATE.UP:
			dir_open = Vector2.UP
		DIR_GATE.RIGHT:
			dir_open = Vector2.RIGHT
		DIR_GATE.LEFT:
			dir_open = Vector2.LEFT
	pass
	

func _physics_process(delta):
	
	if is_opening and !limit_gate:
		gate_kine.move_and_collide(dir_open *gate_vel*delta)
		
	pass

func unlocked_Gate():
	is_opening = true
	pass
