extends RigidBody2D

export(bool) var is_key = false


var hazard = preload("res://Prefabs/Enemies/Hazard.tscn")
var health = preload("res://Prefabs/Blob 2.0/Health.tscn")
var orb
var orbParent

#onready var hazardParent = get_node("../../../Hazard")
#onready var healthParent = get_node("../../../Health")
onready var hazardParent = get_node("/root/ProtoLvl").get_node("Hazard")
onready var healthParent = get_node("/root/ProtoLvl").get_node("Health")
onready var collision_pol = $CollisionPolygon2D
onready var graphic_pol = $Polygon2D
onready var path = $Path2D
onready var line = $Line2D
export(bool) var is_curved
var rng

export(float) var splineLength = 15#12.0
export var amountOfOrbsToExpulse = 5

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var r = rng.randi_range(0,1)
	if r == 0:
		orb = hazard
		orbParent = hazardParent
	else:
		orb = health
		orbParent = healthParent

	add_to_group("Push")
	if is_key:
		add_to_group("keyes")
	
	if is_curved:
		update_sprite()
		graphic_pol.polygon = path.curve.tessellate()
	else:
		graphic_pol.polygon = collision_pol.polygon
		pass
	
	#var end: PoolVector2Array = []
	
	line.points = path.curve.get_baked_points()
	#line.position = position
	#print(line.points)
	#graphic_pol.color.a = 2/mass
	#graphic_pol.color.a = clamp(graphic_pol.color.a,0.0,0.9)

func getpoint(i):
	var pointCount = path.curve.get_point_count()
	i = wrapi(i,0,pointCount -1)
	return path.curve.get_point_position(i)
	pass

func getSpline(i):
	var lastPoint = getpoint(i-1)
	var nextPoint = getpoint(i +1)
	var spline = lastPoint.direction_to(nextPoint) * splineLength
	return spline
	pass

func update_sprite():
	var end: PoolVector2Array = [collision_pol.polygon[0]]
	var pol_points  = collision_pol.polygon + end
	path.curve.clear_points()
	
	for i in pol_points:
		path.curve.add_point(i)
	
	#poner curbas
	var point_count = path.curve.get_point_count()
	for i in point_count:
		#use spline 
		var spline = getSpline(i)
		path.curve.set_point_in(i,-spline)
		path.curve.set_point_out(i,spline)
		pass
	pass

func _draw():
	if !is_curved:
		return
	var bakedPoints = Array(path.curve.get_baked_points())
	var drawPoints = bakedPoints + []
	
	if Geometry.triangulate_polygon(drawPoints).empty():
		drawPoints = Geometry.convex_hull_2d(bakedPoints)
		pass
	
	#line.points = drawPoints
	draw_polyline(drawPoints,Color.black,8.0,false)
	
	draw_polygon(drawPoints,[Color(0.5,0.5,1.0,1.0)])
	pass

func destroyOnCollision():
	#This function gets called when the boss 1 hits the box.
	#It destroys the box and generates hazards
	
	
	for _i in range(amountOfOrbsToExpulse):
		rng.randomize()
		var h = orb.instance()
		h.mode = MODE_RIGID
		h.set_global_position(self.get_global_position())
		h.linear_damp = 2
		h.mass = 2
		if orb == health:
			h.explosion = true
			h.is_life_infite = true
		h.apply_central_impulse(Vector2( rng.randf_range(-1,1),rng.randf_range(-1,1) ) * 1200 )
		#orbParent.add_child(h) #old system
		orbParent.call_deferred("add_child",h)
		pass
	get_parent().hasBox = false;
	queue_free()
	pass
