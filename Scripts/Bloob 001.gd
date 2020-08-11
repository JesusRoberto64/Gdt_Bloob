extends RigidBody2D

var force: Vector2
var circle_limit = 360# 360 int number to limit orbiet bodies
var angle_const = 10# var of angle between orbits int 10 
var orbit_bodies : Array# decalre array to orbit bodies
var father_shape : CircleShape2D
var Radius : float = 110 # 112

var vertex = preload("res://Scnes Bloob/Vertex.tscn")
var faher_spring = preload("res://Scnes Bloob/Father_sping.tscn")

var father_Node_Path 
var fathers_Springs : Array
var orbit_count: int = 0
var spring_conected = true

func _ready():
	
	father_Node_Path = self.get_path()
	#print(father_Node_Path)
	
	while circle_limit > 0: #make a while loop to creat obrit bodies if limit <= 0
		var Orbit = vertex.instance()# create the new static body
		get_parent().call_deferred("add_child",Orbit) # add to the parent
		#Orbit.global_position = global_position - Vector2(0,10)
		Orbit.global_position = radian_formula(circle_limit,Radius)
		orbit_bodies.append(Orbit)  # add to the obrtis array instance id 
		
		var spring_Father = faher_spring.instance()
		call_deferred("add_child",spring_Father)
		spring_Father.rotation_degrees = -circle_limit
		spring_Father.length = 1 #Radius
		spring_Father.node_a = father_Node_Path
		fathers_Springs.append(spring_Father)
		
		circle_limit -= angle_const # substract   limt - angle
		pass
	 
	
	
	pass

func _physics_process(_delta):
	
	#apply_central_impulse(Vector2(30,0))
	
	pass

func _process(_delta):
	
	if spring_conected:
		for orbit in orbit_bodies:
			var spring_Fha = fathers_Springs[orbit_count]
			spring_Fha.node_b = orbit.get_path()
			orbit_count += 1
			
			var spring_Bro = orbit.get_child(1)
			if spring_Bro is DampedSpringJoint2D:
				spring_Bro.node_a = orbit.get_path()
				if orbit_count > orbit_bodies.size() -1 :
					#spring_Bro.node_b = orbit_bodies[0].get_path()
					spring_Bro.node_b = orbit_bodies[1].get_path()
				elif orbit_count > orbit_bodies.size()-2:
					spring_Bro.node_b = orbit_bodies[0].get_path()
					pass
				if orbit_count <= orbit_bodies.size() -2:
					#spring_Bro.node_b = orbit_bodies[orbit_count].get_path()
					spring_Bro.node_b = orbit_bodies[orbit_count+1].get_path()
					pass
				
			
		print(orbit_count,"las itera")
		print(orbit_bodies.size(), " los bofdie")
		spring_conected = false
	
	pass

func radian_formula(angle: int, radio: float)-> Vector2: # make fuction orbit creation 
	var vec_pos = Vector2.ZERO
	vec_pos.x = position.x + cos(angle)*radio
	vec_pos.y = position.y + sin(angle)*radio
	return vec_pos
	pass
