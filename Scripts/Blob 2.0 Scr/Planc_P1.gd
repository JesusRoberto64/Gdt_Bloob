extends Node2D

var points = 12
var radius = 50.0 # 
var circunferenceMultiplier = 0.2

var area = radius * radius * PI
var circunference = radius *2.0* PI * circunferenceMultiplier
var length =  circunference *1.15 / float(points)
var iterations = 40 # 25 minimo  maomenos 80 maximo

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
export var move_accel = 550
export var max_speed = 1500
var drag = 1
var velocity: Vector2
var move_vec =  Vector2.ZERO
var is_Stop = true
var inertia = true
var friction_mult = 0.94 # 1 is toal friction
# Camera 
onready var camera = $Camera2D
# implement ITEM ========
var item_direct = Vector2.ZERO

func verletIntegrate(i,delta):
	var temp = blob[i].position
	var vel =  (blob[i].position - blobOld[i])
	blob[i].position = (blob[i].position + (blob[i].position - blobOld[i])*friction_mult)
	blobOld[i] = temp
	pass

func setDistance(currentPoint,anchor,distance):
	var toAnchor = currentPoint - anchor
	toAnchor = toAnchor.normalized() * distance
	return toAnchor + anchor
	pass

func _ready():
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
	var area = 0.0
	var j = points - 1
	for i in range(points):
		area += (blob[j].position.x + blob[i].position.x) * (blob[j].position.y - blob[i].position.y)
		j = i
		pass
	return abs(area / 2.0)
	pass

func _draw():
	var bakedPoints = Array(curve.get_baked_points())
	var drawPoints = bakedPoints + []
	if Geometry.triangulate_polygon(drawPoints).empty():
		drawPoints = Geometry.convex_hull_2d(bakedPoints)
		pass
	# darw line
	draw_polyline(drawPoints, Color.black, 10.0, true)
	draw_polygon(drawPoints,[Color(0.0,1.0,0.0,1.0)])
	#collison_area.polygon = drawPoints
	pass

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	is_Stop = true
	var cur_move_vec = Vector2.ZERO
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
	
	move_vec = vec_movement(cur_move_vec)
	
	#Camera
	
	var cam_cent = findCentroid()
	cam_cent.x = round(cam_cent.x)
	cam_cent.y = round(cam_cent.y)
	camera.position = cam_cent
	
	#SHIRNK MECNIC  ================
	
#	if Input.is_action_pressed("shrink"):
#		shink()
#
#	if Input.is_action_pressed("grow"):
#		grow()
	
	pass

func _physics_process(delta):
	
	for i in range(points):
		# match
		if inertia:
			verletIntegrate(i,delta)
		
		velocity += move_accel*delta*move_vec - velocity * Vector2(drag,drag) + gravity
		blob[i].move_and_slide(velocity,Vector2.ZERO,false,1, 0.785398,false)
	
	for iterate in range(iterations):
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














