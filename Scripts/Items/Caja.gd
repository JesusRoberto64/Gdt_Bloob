extends RigidBody2D

export(bool) var is_key = false

onready var collision_pol = $CollisionPolygon2D
onready var graphic_pol = $Polygon2D
onready var path = $Path2D
export(bool) var is_curved

export(float) var splineLength = 15#12.0

func _ready():
	add_to_group("Push")
	if is_key:
		add_to_group("keyes")
	
	if is_curved:
		update_sprite()
		graphic_pol.polygon = path.curve.tessellate()
	else:
		graphic_pol.polygon = collision_pol.polygon
		pass
	
	graphic_pol.color.a = 2/mass
	graphic_pol.color.a = clamp(graphic_pol.color.a,0.0,0.9)

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
	
	draw_polyline(drawPoints,Color.black,8.0,false)
	
	draw_polygon(drawPoints,[Color(0.5,0.5,1.0,1.0)])
	pass


