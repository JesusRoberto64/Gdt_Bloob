extends Node

var vertexPref = preload("res://Prefabs/pref_vertex2.tscn")
var polyVertices = []
var vertices = []
var polygonObj = null
var pinJointSoftness = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	polygonObj = get_node("Polygon2D")
	polyVertices = polygonObj.get_polygon()
	InstantiateVertex()
	Configure_Joints()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Connect_Vertex2Polygon()
	Connect_Vertices()
	pass
	
func InstantiateVertex():
	var i = 0
	for pvertex in polyVertices:
		i += 1
		var vertex = vertexPref.instance()
		vertex.name = "vertex " + str(i)
		vertex.position = pvertex
		vertices.append(vertex)
		get_node(".").add_child(vertex)
	
	pass

func Configure_Joints():
	#var vertexRadius = 5
	for i in range(polyVertices.size()):
		
		#Sets the vertex's Node A and B
		var pinJoint = vertices[i].get_node("PinJoint2D")
		pinJoint.set_node_a(pinJoint.get_parent().get_path())
		pinJoint.set_node_b(get_node(".").get_path())
		pinJoint.set_softness(pinJointSoftness)
		
		#Sets vertex collision size
		var segmentShape = vertices[i].get_node("CollisionShape2D").get_shape()
		var angle
		var distance
		if i == (polyVertices.size()-1):
			angle = vertices[i].position.direction_to(vertices[0].position)
			distance = vertices[i].position.distance_to(vertices[0].position)	
		else:
			angle = vertices[i].position.direction_to(vertices[i+1].position)
			distance = vertices[i].position.distance_to(vertices[i+1].position)
			
		segmentShape.set_a(Vector2.ZERO)			
		segmentShape.set_b(angle*distance)
		
		
		
	pass
	
func Connect_Vertex2Polygon():
	var newPositions = []
	for vertex in vertices:
		newPositions.append(vertex.position)
		
	polygonObj.set_polygon(newPositions)
	
func Connect_Vertices():
	for i in range(polyVertices.size()):
		var segmentShape = vertices[i].get_node("CollisionShape2D").get_shape()
		var angle
		var distance
		if i == (polyVertices.size()-1):
			angle = vertices[i].position.direction_to(vertices[0].position)
			distance = vertices[i].position.distance_to(vertices[0].position)	
		else:
			angle = vertices[i].position.direction_to(vertices[i+1].position)
			distance = vertices[i].position.distance_to(vertices[i+1].position)
				
		segmentShape.set_a(Vector2.ZERO)			
		segmentShape.set_b(angle*distance)
