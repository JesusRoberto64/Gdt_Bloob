extends Node2D

enum STATE {IDLE, MOVING, PUPPET, HURT, DYING}
var cur_state = STATE.PUPPET # defalut movment

var fill_color: Color
var line_color: Color

var has_shield = false

func _ready():
	fill_color = Color(0.0,0.0,0.0,1.0)
	line_color = Color(0.0,0.0,0.0,1.0)
	pass

func _process(_delta):
	#var color = Color(0.0,0.0,0.0,0.0) # es verde
	match cur_state:
		STATE.IDLE:
			pass
		STATE.MOVING:
			
			fill_color = Color(0.0,1.0,0.0,0.5)
			if has_shield:
				line_color = Color.green
			else:
				line_color = Color.greenyellow
			
			pass
		STATE.HURT:
			fill_color = Color.red
			line_color = Color.black
			pass
		STATE.PUPPET:
			pass
		STATE.DYING:
			pass
	pass

