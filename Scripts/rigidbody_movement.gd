extends RigidBody2D

var vertexPref = preload("res://Prefabs/pref_vertex.tscn")
var polygonPref = preload("res://Prefabs/pref_BlobTexture.tscn")
var numberOfVertex = 25
var polygonObj = null
var vertices = []
var radius = 50
var moveForce = 75.0
var vertexRadius = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	Create_Circle()
	Configure_Joints()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Connect_Vertex2Polygon()
	Input_button(delta)
	
func Input_button(var delta):
	if Input.is_action_pressed("ui_up"):
		apply_impulse(Vector2.ZERO, Vector2.UP  * moveForce)
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2.ZERO, Vector2.LEFT  * moveForce)
	if Input.is_action_pressed("ui_down"):
		apply_impulse(Vector2.ZERO, Vector2.DOWN  * moveForce)
	if Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2.ZERO, Vector2.RIGHT * moveForce)
	

func Create_Circle():
	polygonObj = polygonPref.instance()
	add_child(polygonObj)
	var polyVertices = []

	for i in range(numberOfVertex):
		#Calculates the circle radium
		var angle = i * PI * 2 / numberOfVertex
		var pos = Vector2(cos(angle), sin(angle))*radius
		#Add the position into an Array
		polyVertices.append(pos)
		
		#Instantiates a collision vertex 
		var vertex = vertexPref.instance()
		vertex.name = "vertex " + str(i+1)
		vertex.position = pos
		vertices.append(vertex)
		get_node("Polygon2D").add_child(vertex)

	#Creates a polygon using the Array's positions
	polygonObj.set_polygon(polyVertices)
	
		
func Configure_Joints():
	vertexRadius = vertices[0].position.distance_to(vertices[1].position)/2
	for vertex in vertices:
		#Sets the vertex's Node A and B
		var pinJoint = vertex.get_node("PinJoint2D")
		pinJoint.set_node_a(pinJoint.get_parent().get_path())
		pinJoint.set_node_b(get_node(".").get_path())
		
		#Sets vertex collision size
		var circleShape = vertex.get_node("CollisionShape2D").get_shape()
		circleShape.set_radius(vertexRadius);
		
	pass
	
func Connect_Vertex2Polygon():
	var newPositions = []
	for vertex in vertices:
		var angle = get_node("Polygon2D").position.direction_to(vertex.position)
		var distance = get_node("Polygon2D").position.distance_to(vertex.position) + vertexRadius
		var offset = angle*distance
		newPositions.append(offset)	
		
	polygonObj.set_polygon(newPositions)
