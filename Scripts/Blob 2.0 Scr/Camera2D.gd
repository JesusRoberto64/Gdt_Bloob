extends Camera2D

enum CAM_STATE {MOVING,CENTERED,STOP,CINEMATIC}
var state = CAM_STATE.STOP
var direction_x = 0
var distance = 1.5#15
var is_stoped = false

#onready var prev_camera_pos = get_camera_position()
onready var prev_camera_center = get_camera_screen_center()

onready var timer = $Timer

onready var planc = get_parent()

var can_move = false

func _process(delta):
	
	##imputs 
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		timer.start()
		can_move = true
	else:
		can_move = false
	pass
	
	if Input.is_action_pressed("ZoomIn"):
		zoom.x += 1*delta
		zoom.y += 1*delta
	elif Input.is_action_pressed("ZoomOut"):
		zoom.x -= 1*delta
		zoom.y -= 1*delta
	

func _physics_process(delta):
	
	#prev_camera_pos = position 
	
	match state:
		CAM_STATE.CENTERED:
			#print("centro")
			
			if can_move:
				state = CAM_STATE.MOVING
			
			offset_h = lerp(offset_h,0,5*delta)
			if !offset_h >= 0.01 and !offset_h <= -0.01:
				#drag_margin_h_enabled = true
				smoothing_speed = 5
				state = CAM_STATE.STOP
				pass
			
			pass
		CAM_STATE.MOVING:
			#print("movio")
			smoothing_speed = lerp(smoothing_speed,15,0.4*delta)
			smoothing_speed = clamp(smoothing_speed,5,14)
			if direction_x != 0:
				offset_h = lerp(offset_h,distance*direction_x,1*delta) 
				pass
			
			direction_facing()
			drag_margin_h_enabled = false
			pass
		CAM_STATE.STOP:
			#print("stoped")
			
			if direction_facing():
				if can_move:
					state = CAM_STATE.MOVING
				
				pass
			
			timer.stop()
			drag_margin_h_enabled = true
			pass
		CAM_STATE.CINEMATIC:
			return
			pass
	
	
	var cam_pos = planc.findCentroid()
	cam_pos.x = stepify(cam_pos.x,1)
	cam_pos.y = stepify(cam_pos.y,1)
	position = cam_pos 
	#print(position, " form planc")
	
	prev_camera_center = get_camera_screen_center()
	pass

func direction_facing()-> bool:
	#var new_direction = sign(position.x - prev_camera_pos.x)
	var new_direction = sign(get_camera_screen_center().x - prev_camera_center.x)
	#print(new_direction)
	if new_direction != 0: # && direction != new_direction:
		direction_x = new_direction 
		return true
		pass
	return false
	pass
	

func _on_Timer_timeout():
	#print("movend")
	state = CAM_STATE.CENTERED
	pass 
