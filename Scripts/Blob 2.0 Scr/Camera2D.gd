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

# shaking camera 
var is_shaking = false
var shake_amnt = 0.5
var time_Shake = 0.0
var time_Shake_Max = 0.5

# Animation camera 
onready var anim_cam 
var is_cinematic = false 

# move camera 
var move_Point = Vector2.ZERO

func _ready():
	anim_cam = $AnimationPlayer
	
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		print("ERROR loading")
		pass
	
	var status_save = load("res://saves/save_01.tres")
	
	if status_save.get("first_Time") != null:
		#is_cinematic = true
		#anim_cam.play("LevelsIntro_Demo")
		#state = CAM_STATE.CINEMATIC
		#planc.cur_state = planc.STATE.PUPPET
		pass
	
#	if is_cinematic:
#		anim_cam.play("LevelsIntro_Demo")
#		state = CAM_STATE.CINEMATIC
#		planc.cur_state = planc.STATE.PUPPET
#		pass
	

func _process(delta):
	
	##imputs 
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		if state == CAM_STATE.CINEMATIC:
			return
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
	
	if Input.is_action_pressed("grow"):
		is_shaking = true
	

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
			
			if is_shaking:
				#shakig(delta)
				state = CAM_STATE.MOVING
			
			
			pass
		CAM_STATE.CINEMATIC:
			
			global_position = lerp(global_position,move_Point,0.1)
			timer.start()
			if global_position.distance_to(move_Point) <= 0.01:
				#is_cinematic = false
				#state = CAM_STATE.STOP
				#planc.cur_state = planc.STATE.MOVING
				cinematic("LevelsIntro_Demo")
				pass
			
			pass
	
	if !is_cinematic:
		var cam_pos = planc.findCentroid()
		cam_pos.x = stepify(cam_pos.x,1)
		cam_pos.y = stepify(cam_pos.y,1)
		position = cam_pos 
		#print(position, " form planc")
	
	prev_camera_center = get_camera_screen_center()
	
	if is_shaking:
		shakig(delta,100)
	
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

func shakig(delta,amnt):
	var _amnt = amnt
	position.x += rand_range(0,shake_amnt*_amnt)
	position.y += rand_range(0,shake_amnt*_amnt)
	
	time_Shake += delta
	if time_Shake > time_Shake_Max:
		is_shaking = false
		time_Shake = 0.0
	pass

func cinematic_off():
	state = CAM_STATE.MOVING
	planc.cur_state = planc.STATE.MOVING
	is_cinematic = false

func cinematic(play_anim: String):
	state = CAM_STATE.CINEMATIC
	planc.cur_state = planc.STATE.PUPPET
	anim_cam.play(play_anim)
	pass

func move_cam(pos: Vector2):
	state = CAM_STATE.CINEMATIC
	is_cinematic =  true
	planc.cur_state = planc.STATE.PUPPET
	move_Point = pos
	timer.stop()
	pass







