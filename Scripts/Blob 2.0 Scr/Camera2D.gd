extends Camera2D

enum CAM_STATE {MOVING,CENTERED,STOP,CINEMATIC}
var state = CAM_STATE.STOP
var direction_x = 0
var distance = 1.5#15
var is_stoped = false

onready var prev_camera_pos = get_camera_position()

onready var timer = $Timer

onready var planc = get_parent()



func _process(delta):
	
#	match state:
#		CAM_STATE.CENTERED:
#			#print("centro")
#			offset_h = lerp(offset_h,0,5*delta)
#
#			if !offset_h >= 0.01 and !offset_h <= -0.01:
#				state = CAM_STATE.STOP
#
#				pass 
#
#			pass
#		CAM_STATE.MOVING:
#			#print("movio")
#			if direction_x != 0:
#
#				offset_h = lerp(offset_h,distance*direction_x,1*delta)
#				print(offset_h)
#				pass
#
#			direction_facing()
#			drag_margin_h_enabled = false
#			pass
#		CAM_STATE.STOP:
#			#print("paro")
#			if direction_facing():
#				#state = CAM_STATE.MOVING
#
#				pass
#
#			#timer.start()
#			#drag_margin_h_enabled = true
#			pass
#		CAM_STATE.CINEMATIC:
#
#			pass
	
	#prev_camera_pos = get_camera_position()
	
	##imputs 
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		timer.start()
		pass
	pass

func _physics_process(delta):
	
	prev_camera_pos = position 
	#print(prev_camera_pos, " geted ")
	var cam_pos = planc.findCentroid()
	cam_pos.x = stepify(cam_pos.x,0.1)
	cam_pos.y = stepify(cam_pos.y,0.1)
	position = cam_pos 
	#print(position, " form planc")
	print(get_camera_screen_center())
	match state:
		CAM_STATE.CENTERED:
			#print("centro")
			pass
		CAM_STATE.MOVING:
			print("movio")
			
			pass
		CAM_STATE.STOP:
			
			
			if direction_facing():
				state = CAM_STATE.MOVING
				
				pass
			
			timer.stop()
			drag_margin_h_enabled = true
			pass
		CAM_STATE.CINEMATIC:
			
			pass
	
	pass

func direction_facing()-> bool:
	
	var new_direction = sign(position.x - prev_camera_pos.x)
	if new_direction != 0: # && direction != new_direction:
		direction_x = new_direction 
		return true
		pass
	return false
	pass
	

func _on_Timer_timeout():
	print("movend")
	state = CAM_STATE.CENTERED
	pass 
