extends RigidBody2D

var circle_limit = 360# 360 int number to limit orbiet bodies
var angle_const = 20# var of angle between orbits int 10 
var orbit_bodies : Array# decalre array to orbit bodies
var father_shape : CircleShape2D
var Radius : float = 50 # 110

var vertex = preload("res://Scnes Bloob/Vertex.tscn")
var faher_spring = preload("res://Scnes Bloob/Father_sping.tscn")

var father_Node_Path 
var fathers_Springs : Array
var orbit_count: int = 0
var spring_conected = true

var impulse: Vector2 = Vector2.ZERO
var force: float = 1850
var total_force: Vector2
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
		#spring_Father.length = 200 #Radius
		spring_Father.node_a = father_Node_Path
		fathers_Springs.append(spring_Father)
		
		circle_limit -= angle_const # substract   limt - angle
		pass
	 
	
	
	pass

func _physics_process(delta):
	
	if mode == 3:
		position += impulse.normalized()*force*delta
		#move_and_slice(impulse*force*delta)
		pass
	else:
		#add_central_force(impulse.normalized()*force)
		pass
	
	total_force = Vector2.ZERO
	
	for force in orbit_bodies:
		var set_force = impulse.normalized()
		force.set_applied_force(impulse)
		total_force += force.get_applied_force() 
		pass
	
	#print(total_force)
	pass

func _process(_delta):
	
	if spring_conected:
		for orbit in orbit_bodies:
			var spring_Fha = fathers_Springs[orbit_count]
			spring_Fha.node_b = orbit.get_path()
			orbit_count += 1
			
			var spring_Bro = orbit.get_child(1)
			var spring_Bro2 = orbit.get_child(4)
			if spring_Bro is DampedSpringJoint2D:
				spring_Bro.node_a = orbit.get_path()
				if orbit_count > orbit_bodies.size() -1 :
					#spring_Bro.node_b = orbit_bodies[0].get_path()
					spring_Bro.node_b = orbit_bodies[1].get_path()
					pass
				elif orbit_count > orbit_bodies.size()-2:
					spring_Bro.node_b = orbit_bodies[0].get_path()
					pass
				if orbit_count <= orbit_bodies.size() -2:
					#spring_Bro.node_b = orbit_bodies[orbit_count].get_path()
					spring_Bro.node_b = orbit_bodies[orbit_count+1].get_path()
					pass
			
			if spring_Bro2 is DampedSpringJoint2D:
				spring_Bro2.node_a = orbit.get_path()
				if orbit_count > orbit_bodies.size() - 1:
					spring_Bro2.node_b = orbit_bodies[0].get_path()
					pass
				else:
					spring_Bro2.node_b = orbit_bodies[orbit_count].get_path()
					pass
				
				pass
			
			var pin_point = orbit.get_child(2)
			var pin_point2 = orbit.get_child(3)
			if pin_point is PinJoint2D:
				pin_point.node_a = orbit.get_path()
				if orbit_count > orbit_bodies.size() - 1:
					pin_point.node_b = orbit_bodies[0].get_path()
					pass
				else:
					pin_point.node_b = orbit_bodies[orbit_count].get_path()
					pass
				pass
			
			if pin_point2 is PinJoint2D:
				pin_point2.node_a = orbit.get_path()
				if orbit_count == 1:
					#pin_point2.node_b = orbit_bodies[orbit_bodies.size() -1].get_path()
					pass
				else:
					#pin_point2.node_b = orbit_bodies[orbit_count-1].get_path()
					pass
				
				pass
			
		spring_conected = false
	
	
	
	pass

func _input(event):
	var right = Input.is_action_pressed('ui_right') 
	var left = Input.is_action_pressed('ui_left') 
	var up = Input.is_action_pressed("ui_up") 
	var down = Input.is_action_pressed("ui_down") 
	
	impulse = Vector2.ZERO
	
	if right:
		impulse.x = Vector2.RIGHT.x*force
	elif left:
		impulse.x = Vector2.LEFT.x*force
	if up:
		impulse.y = Vector2.UP.y*force
	elif down:
		impulse.y = Vector2.DOWN.y*force
	
	pass

func radian_formula(angle: int, radio: float)-> Vector2: # make fuction orbit creation 
	var vec_pos = Vector2.ZERO
	vec_pos.x = position.x + cos(angle)*radio
	vec_pos.y = position.y + sin(angle)*radio
	return vec_pos
	pass
