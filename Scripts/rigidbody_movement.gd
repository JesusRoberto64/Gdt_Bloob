extends RigidBody2D


var vertexPref = preload("res://Prefabs/pref_vertex.tscn")
var numberOfVertex = 20
var innerSprings = []
var vertices = []
var radius = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	Create_Circle()
	Set_Springs()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Input_button()
	
func Input_button():
	if Input.is_action_pressed("left"):
		add_force(Vector2(0,0), Vector2.LEFT)
		
	if Input.is_action_pressed("right"):
		add_force(Vector2(0,0), Vector2.RIGHT)

func Create_Circle():
	for i in range(numberOfVertex):
		var spring = DampedSpringJoint2D.new()
		spring.name = "spring " + str(i+1)
		get_child(1).add_child(spring)
		innerSprings.append(spring)
		
		var angle = i * PI * 2 / numberOfVertex
		var pos = Vector2(cos(angle), sin(angle))*radius
		var vertex = vertexPref.instance()
		vertex.name = "vertex " + str(i+1)
		add_child(vertex)
		vertex.position = pos
		vertices.append(vertex)
		
func Set_Springs():
	for i in range(numberOfVertex):
		innerSprings[i].set_node_a(get_node(".").get_path())
		innerSprings[i].set_node_b(vertices[i].get_node(".").get_path())
		innerSprings[i].set_exclude_nodes_from_collision(false)
		innerSprings[i].set_length(120)
		innerSprings[i].set_rest_length(120)
		innerSprings[i].set_stiffness(1)
		innerSprings[i].set_damping(16)
		
		var outerSpring = vertices[i].get_node("DampedSpringJoint2D")
		outerSpring.set_node_a(vertices[i].get_node(".").get_path())
		if i < numberOfVertex-2:
			outerSpring.set_node_b(vertices[i+2].get_node(".").get_path())
		else:
			outerSpring.set_node_b(vertices[i-numberOfVertex+2].get_node(".").get_path())
		
		outerSpring.set_exclude_nodes_from_collision(false)
		outerSpring.set_length(70)
		outerSpring.set_rest_length(10)
		outerSpring.set_stiffness(1)
		outerSpring.set_damping(16)
	
