extends Node2D

#STATE MACHINE
enum STATE {IDLE, MOVING, PUPPET, HURT, DYING}

var cur_state = STATE.MOVING

var points = 11 # 12 maximo
export var radius = 17.0 # 
var circunferenceMultiplier = 0.2

var area = radius * radius * PI
var circunference = radius *2.0* PI * circunferenceMultiplier
var length =  circunference *1.15 / float(points)
var iterations = 25 # 25 minimo  maomenos 80 maximo

var blob = []
var blobOld = []
var acumulatedDisplacements = {}
var normals = []
var center = Vector2(0.0,0.0)
var gravity = Vector2(0.0,0.0) #default (0.0,30.0)
export(float) var splineLength = 12.0
export(Curve2D) var curve

var coll_Point = preload("res://Prefabs/Blob 2.0/Collision_Point.tscn") 
var item_pulled = preload("res://Prefabs/Blob 2.0/Health.tscn")

##CONTROL IMPLMETATION 
export var move_accel = 550 #550
export var max_speed = 1000 #1500
var drag = 1
var velocity: Vector2
var move_vec =  Vector2.ZERO
var is_Stop = true
var inertia = true
var friction_mult = 0.94 # 1 is toal friction
# Camera 
var camera: Camera2D
# implement ITEM ========
var item_direct = Vector2.ZERO

#STATE MACHINE
onready var Movement_ctrl = $Movement
onready var Graphics_ctrl = $Graphics
onready var State_timer = $StateTimer

signal dead
signal door

# CORE health 
const growth_mult = 1
var bodies_health = []

signal hud_sync(amount)
onready var health_var = $CanvasLayer/Health_HUD

# Shrink feel
var is_Turbo = true
onready var turbo_Realace = $Turbo

# Area enies detection 
onready var area_enemies = $Area2D

func verletIntegrate(i):
	var temp = blob[i].position
	#var vel =  (blob[i].position - blobOld[i])
	blob[i].position = (blob[i].position + (blob[i].position - blobOld[i])*friction_mult)
	blobOld[i] = temp
	pass

func setDistance(currentPoint,anchor,distance):
	var toAnchor = currentPoint - anchor
	toAnchor = toAnchor.normalized() * distance
	return toAnchor + anchor
	pass

func _ready():
	#connect hud 
	connect("hud_sync",health_var,"update_display")
	emit_signal("hud_sync",radius)
	Movement_ctrl.cur_state = cur_state
	camera = $Camera2D
	drag = float(move_accel) / max_speed
	resetBlob()
	
	pass 

func findCentroid():
	var x = 0.0
	var y = 0.0
	for i in range(points):
		# new iplemation global
		x += blob[i].position.x
		y += blob[i].position.y
	var cent = Vector2(0.0,0.0)
	cent.x = x/float(points)
	cent.y = y/float(points)
	return cent
	pass

func getPoint(i):
	var pointCount = curve.get_point_count()
	i = wrapi(i,0,pointCount -1)
	return curve.get_point_position(i)
	pass

func getSpline(i):
	var lastPoint = getPoint(i - 1)
	var nextPoint = getPoint(i + 1)
	var spline = lastPoint.direction_to(nextPoint) * splineLength
	return spline
	pass

func updateSprite():
	var polBlob = blob + [blob[0]]
	curve.clear_points()
	for i in range(points + 1):
		var point = polBlob[i].position
		curve.add_point(point)
		#print("my blob ",curve.get_baked_points())
	
	var point_count = curve.get_point_count()
	for i in point_count:
		var spline = getSpline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)
		pass
	pass

func getCurArea ():
	var new_area = 0.0
	var j = points - 1
	for i in range(points):
		new_area += (blob[j].position.x + blob[i].position.x) * (blob[j].position.y - blob[i].position.y)
		j = i
		pass
	return abs(new_area / 2.0)
	pass

func _draw():
	var bakedPoints = Array(curve.get_baked_points())
	var drawPoints = bakedPoints + []
	if Geometry.triangulate_polygon(drawPoints).empty():
		drawPoints = Geometry.convex_hull_2d(bakedPoints)
		pass
	
	# darw line
	var state_line = Graphics_ctrl.line_color
	draw_polyline(drawPoints, state_line, 14.0, true)
	
	var state_color = Graphics_ctrl.fill_color
	draw_polygon(drawPoints,[state_color])
	#collison_area.polygon = drawPoints
	pass

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	is_Stop = true
	var cur_move_vec = Vector2.ZERO # nbegining
	if Input.is_action_pressed("ui_right"):
		cur_move_vec += Vector2.RIGHT
		item_direct = Vector2.LEFT #the opsite
		is_Stop = false
		pass
	elif Input.is_action_pressed("ui_left"):
		cur_move_vec += Vector2.LEFT
		item_direct = Vector2.RIGHT #the opsite
		is_Stop = false
		pass
	if Input.is_action_pressed("ui_up"):
		cur_move_vec += Vector2.UP
		item_direct = Vector2.DOWN #the opsite
		is_Stop = false
		pass
	elif Input.is_action_pressed("ui_down"):
		cur_move_vec += Vector2.DOWN
		item_direct = Vector2.UP #the opsite
		is_Stop = false
		pass
	
	# State machine logic.
	Movement_ctrl.cur_state = cur_state
	Graphics_ctrl.cur_state = cur_state
	
	move_vec = vec_movement(cur_move_vec)
	
	#Camera
	if !cur_state == STATE.DYING:
		var cam_cent = findCentroid()
		#cam_cent.x = round(cam_cent.x)
		#cam_cent.y = round(cam_cent.y)
		#camera.position = cam_cent
		
	# enemies detection 
	area_enemies.position = findCentroid()
	#print(area_enemies.position)
	#print(position, "deberia")
	#SHIRNK MECNIC  ================
	
	move_accel = 900
	if Input.is_action_pressed("shrink"):
		if is_Turbo:
			#shink()
			#shink()
			shink()
			is_Turbo = false
			turbo_Realace.start()
			pass
		#max_speed = 2500
		if radius > 15:
			move_accel = 1200#1800
		else:
			#move_accel = 900
			move_accel = lerp(move_accel,900,0.1)
		#move_accel = 900
		pass
	
	
	if Input.is_action_pressed("grow"):
		#grow()
#		for i in blob.size():
#			blob[i].can_push = true
		pass
	
	pass

func _physics_process(delta):
	for i in range(points):
		# match
		if inertia:
			verletIntegrate(i)
		#velocity += move_accel*delta*move_vec - velocity * Vector2(drag,drag) + gravity #OLD SYSTEM
		velocity += Movement_ctrl.movement(move_accel,delta,move_vec,velocity,drag,gravity)
		blob[i].move_and_slide(velocity,Vector2.ZERO,false,1, 0.785398,false)
		
		pass
	for _iterate in range(iterations):
		for i in range(points):
			var segment = blob[i].position
			var nextIndex = i + 1
			if i == points -1:
				nextIndex = 0
				pass
			var nextSegment = blob[nextIndex].position
			var toNext = segment - nextSegment
			if toNext.length() > length:
				toNext = toNext.normalized() * length
				var offset = (segment - nextSegment) - toNext
				acumulatedDisplacements[(i * 3)] -= offset.x / 2.0
				acumulatedDisplacements[(i * 3) + 1] -= offset.y / 2.0
				acumulatedDisplacements[(i * 3) + 2] += 1.0
				acumulatedDisplacements[(nextIndex * 3)] += offset.x / 2.0
				acumulatedDisplacements[(nextIndex * 3) + 1] += offset.y / 2.0
				acumulatedDisplacements[(nextIndex * 3) +  2] += 1.0
				pass
			pass
		var deltaArea = 0.0
		var curArea = getCurArea()
		if curArea < area * 2.0:
			deltaArea = area - curArea
			pass
		var dilationDistance = deltaArea / circunference
		for i in range(points):
			var prevIndex = i - 1
			if i == 0:
				prevIndex = points - 1
				pass
			var nextIndex = i + 1
			if i == points - 1:
				nextIndex = 0
				pass
			var normal = blob[nextIndex].position - blob[prevIndex].position
			normal = Vars.getVectorByLA(1, rad2deg(normal.angle())- 90.0)
			normals[i][0] = blob[i].position
			normals[i][1] = blob[i].position + (normal * 200.0)
			acumulatedDisplacements[(i * 3)] += normal.x * dilationDistance
			acumulatedDisplacements[(i * 3) + 1] += normal.y * dilationDistance
			acumulatedDisplacements[(i * 3) + 2] += 1.0
			pass
		for i in range(points):
			if (acumulatedDisplacements[(i *3) + 2] > 0):
				var mov_x = acumulatedDisplacements[(i * 3)]
				var move_y = acumulatedDisplacements[(i * 3) + 1] #/ acumulatedDisplacements[(i * 3) + 2]
				var mov_div = Vector2(mov_x,move_y / acumulatedDisplacements[(i * 3) + 2]) 
				# checked
				mov_div = blob[i].move_and_slide(mov_div,Vector2.ZERO,false,1, 0.785398,false)
				pass
		for i in range(points * 3):
			acumulatedDisplacements[i] = 0
			pass
		pass
	
	#Camera
	#var cam_cent = findCentroid()
	#cam_cent.x = round(cam_cent.x)
	#cam_cent.y = round(cam_cent.y)
	#camera.position = cam_cent
	#print(cam_cent, " seted")
	updateSprite()
	update()
	pass

func resetBlob():
	blob = []
	blobOld = []
	normals = []
	acumulatedDisplacements = {}
	for i in range(points):
		var delta = Vars.getVectorByLA(radius,(360.0/float(points))*i)
		## new integration with PHYSIC BODY
		var coll_Point_inst = coll_Point.instance()
		blob.append(coll_Point_inst)
		blob[i].position += delta
		add_child(coll_Point_inst)
		blobOld.append(position + delta)
		normals.append([])
		normals[i].append(position + delta)
		normals[i].append(position + delta * 1.5)
		pass
	for i in range(points * 3):
		acumulatedDisplacements[i] = 0.0 
		pass
	updateSprite()
	update()
	pass

func vec_movement(move_vec):
	var _move_vec = move_vec.normalized()
	#print(_move_vec)
	return _move_vec
	pass

func shink():
	
	if radius < 15:
		#print("regreso")
		#print(radius, "en return")
		return
	
	radius -= growth_mult
	radius = clamp(radius,14,76)
	area = radius * radius * PI
	circunference = radius * 2.0 * PI * circunferenceMultiplier
	length = circunference * 1.15 / float(points)
	
	emit_signal("hud_sync",radius) # to update hud 
	
	var item_expulse_inst = item_pulled.instance()
	item_expulse_inst.position = findCentroid()
	item_expulse_inst.can_collide = false
	item_expulse_inst.direction = item_direct
	
	if cur_state == STATE.HURT:
		item_expulse_inst.life_time = 1.0
		item_expulse_inst.col = Color.blue
		get_parent().call_deferred("add_child",item_expulse_inst)
		#to just expulse once DEPREQUETED
		return
		pass
	item_expulse_inst.is_projectile = true # use to hurt
	get_parent().add_child(item_expulse_inst)
	
	pass

func grow(body):
	if !bodies_health.has(body):
		bodies_health.append(body)
		bodies_health.push_front(body)
		pass
	else:
		return
	
	if bodies_health.size() >= 3:
		bodies_health.resize(3)
	
	radius += growth_mult
	radius = clamp(radius,14,76)
	area = radius * radius * PI
	circunference = radius * 2.0 * PI * circunferenceMultiplier
	length = circunference * 1.15 / float(points)
	
	emit_signal("hud_sync",radius)
	
	pass

func grow_debug():
	radius += growth_mult
	radius = clamp(radius,14,76)
	area = radius * radius * PI
	circunference = radius * 2.0 * PI * circunferenceMultiplier
	length = circunference * 1.15 / float(points)
	print(radius, "en grow")
	pass

func hurt():
	#shink()
	if cur_state == STATE.DYING or cur_state == STATE.HURT:
		return
	
	cur_state = STATE.HURT
	if radius <= 14:
		emit_signal("dead")
		set_visible(false)
		cur_state = STATE.DYING
	shink()
	shink()
	shink()
	#shink()
	State_timer.start()

func _on_StateTimer_timeout():
	if cur_state == STATE.DYING:
		return
	cur_state = STATE.MOVING
	
	pass # Replace with function body.

func enter_door():
	emit_signal("door")
	#print("open the door")
	set_visible(false)
	pass


func _on_Turbo_timeout():
	is_Turbo = true
	pass # Replace with function body.

func unlock_ability(abilty: String):
	# a match logic
	if abilty == "push_Hazard":
		for i in blob.size():
				blob[i].can_push = true
		
		pass
