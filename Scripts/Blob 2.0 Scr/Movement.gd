extends Node2D

enum STATE {IDLE, MOVING, PUPPET, HURT, DYING}
var cur_state = STATE.PUPPET # defalut movment

func _ready():
	cur_state = get_parent().cur_state
	pass

func movement(move_accel,delta,move_vec,velocity,drag,gravity):
	#velocity += move_accel*delta*move_vec - velocity * Vector2(drag,drag) + gravity
	var _movement = Vector2.ZERO
	match cur_state:
		STATE.IDLE:
			pass
		STATE.MOVING:
			_movement = move_accel*delta*move_vec - velocity * Vector2(drag,drag) + gravity
			pass
		STATE.HURT:
			pass
		STATE.PUPPET:
			pass
		STATE.DYING:
			pass
	
	return _movement
	pass
