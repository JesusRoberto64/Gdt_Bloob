extends Node2D
enum Movement_Type{CLOCKWISE, ANTICLOCKWISE, INSIDE, OUTSIDE,PUPPET,FROMCENTER}

onready var points = get_parent().get_parent()
onready var follow = self.get_parent() #pathfollow2D
onready var path2d = self.get_parent().get_parent()
onready var moveTimer = get_node("Base/MoveTimer")
onready var pullTimer = get_node("Base/PullTimer")
onready var stunTimer = get_node("Base/StunedTimer")
onready var centerPosition = self.get_parent().get_node("../Center_Position")
onready var startPosition = self.get_parent().get_node("../Start_Position")
onready var base = $Base
onready var kBody = get_node("Base/Kinematic Body")
onready var colArea = get_node("Base/CollisionArea")

var player = null
var isStuned = false
var playerPull = false
var hazardOrbs = []

export (Movement_Type) var movement_Type = Movement_Type.CLOCKWISE
export var moveSpeed = 500
export var moveTime = 20 #The seconds the boss enemy moves before returning to the center
export var pullTime = 15 #The seconds the boss enemy tries to eat the player before moving again
export var stunedTime = 1.5
export var playerPullForce = 15
export var orbsPullForce = 20
export var health = 100
export var damagePerOrb = 5

# intro animation boss
onready var anim = $"Base/Kinematic Body/AnimationPlayer"

# system when animation intro is ended 
var is_ready = false
var is_defeated = false
signal defeated 

# Animations Mesh
onready var anim_mesh = $"Base/Kinematic Body/Viewport".find_node("AnimationPlayer")

# brute force facing 

onready var dummie: Position2D = $Dummie
var to_rotate: float = 0.0

func _ready():
	
	if points.curve == null:
		print_debug("Enemy " + self.name + " has no path2D points established")
		return
	else:
		startPosition.set_position( points.curve.get_point_position(0))
	
	#ChangeDirection(movement_Type)
	player = get_tree().get_nodes_in_group("Player")[0]
	moveTimer.set_wait_time(moveTime)
	pullTimer.set_wait_time(pullTime)
	stunTimer.set_wait_time(stunedTime)
	#moveTimer.start()
	pass

func _process(_delta):
	if Input.is_action_just_pressed("grow"):
		is_defeated = true
		puppet_mode()
		pass
	
	pass

func _physics_process(delta):
	if is_ready:
		Move(delta)
	pass

func Move(delta):
	if movement_Type == Movement_Type.CLOCKWISE or movement_Type == Movement_Type.ANTICLOCKWISE or  movement_Type == Movement_Type.FROMCENTER:
		#Circular Movement
		if !isStuned:
			follow.set_offset(follow.get_offset() + moveSpeed*delta)
			
		else:
			base.rotation_degrees = lerp(base.rotation_degrees,to_rotate,delta*3.5)
			
			if abs(base.rotation_degrees - to_rotate) <= 0.01:
				if movement_Type == Movement_Type.FROMCENTER:
					self.set_position(Vector2(100,0)) #====================
					follow.set_offset(0)
					base.rotation_degrees = 0.0
				isStuned = false
				moveTimer.set_paused(false)
			pass
		
	else:
		var pos
		if movement_Type == Movement_Type.INSIDE:
			#Move to Inside
			pos = centerPosition
		elif movement_Type == Movement_Type.OUTSIDE:
			#Move to Outside
			pos = startPosition
			pass
		
		
		MoveInsideOutside(pos, delta)
		
	
func MoveInsideOutside(var pos, delta):
	
	
	#If it hasn't reached its destination, move towards it
	if self.global_position.distance_to(pos.get_global_position()) > 5:
		
		dummie.global_position = lerp(dummie.global_position,pos.get_global_position(),delta)#implented facing brute force
		base.look_at(dummie.global_position)
		
		var direction = self.global_position.direction_to(pos.get_global_position())
		self.global_translate(direction * moveSpeed/2*delta)
	else: #If it has reached
		if movement_Type == Movement_Type.INSIDE: #Center position
			kBody.set_collision_mask_bit ( 4, true ) 
			colArea.set_collision_mask_bit ( 4, true )
			
			dummie.global_position = lerp(dummie.global_position,player.get_global_position(),delta)#implented facing brute force
			base.look_at(dummie.global_position)
			
			PullActtion()
			if pullTimer.is_stopped():
				kBody.add_to_group("InstaKill")
				pullTimer.start()
				pass
		elif movement_Type == Movement_Type.OUTSIDE: #Orbit
			
			ChangeDirection(Movement_Type.FROMCENTER)
			
			isStuned = true
			#follow.set_offset(0)
			#self.set_position(Vector2(100,0))
			
			if moveTimer.is_stopped():
				moveTimer.start()
				anim_mesh.play("patrol_loop")
				pass
			

func PullActtion():
	#This function is done when the boss enemy is on the center of the stage and starts pulling the player and hazards towards it
	if playerPull:
		var dir = (get_global_transform().origin - player.get_global_transform().origin).normalized()
		player.get_parent().gravity = Vector2(dir*playerPullForce)
		for orb in hazardOrbs:
			var d = (get_global_transform().origin - orb.get_global_transform().origin).normalized()
			orb.add_central_force(d*orbsPullForce) 
	anim_mesh.play("prepare")
	pass

func _on_MoveTimer_timeout():
	#Move time has finished and the boss enemy returns to center
	ChangeDirection(Movement_Type.INSIDE)
	moveTimer.stop()
	pass # Replace with function body.


func _on_PullTimer_timeout():
	ChangeDirection(Movement_Type.OUTSIDE)
	pullTimer.stop()
	pass # Replace with function body.


func _on_CollisionArea_body_entered(body):
	if body.get_collision_layer_bit ( 7 ): #Bit 7 = cajas
		#Si choca con la caja, destruirla y cambiar de direccion
		body.destroyOnCollision()
		isStuned = true
		moveTimer.set_paused(true)
		rotating()
		#if stunTimer.is_stopped():
			#stunTimer.start()
		#	pass
	if body.is_in_group("Hazard"):
		hazardOrbs.erase(body)
		body.queue_free()
		health -= damagePerOrb
		if health <= 0:
			#Derrota boss
			body.set_applied_force(Vector2.ZERO)
			is_defeated = true
			puppet_mode()
			#self.queue_free()
	pass # Replace with function body.


func _on_StunedTimer_timeout():
	#change direction
	if movement_Type == Movement_Type.CLOCKWISE:
		ChangeDirection(Movement_Type.ANTICLOCKWISE)
	elif movement_Type == Movement_Type.ANTICLOCKWISE:
		ChangeDirection(Movement_Type.CLOCKWISE)
	
	#isStuned = false
	#stunTimer.stop()
	pass # Replace with function body.

func rotating():
	
	if movement_Type == Movement_Type.CLOCKWISE:
		ChangeDirection(Movement_Type.ANTICLOCKWISE)
	elif movement_Type == Movement_Type.ANTICLOCKWISE:
		ChangeDirection(Movement_Type.CLOCKWISE)
	
	
	pass

func ChangeDirection(var moveType):
	movement_Type = moveType
	match movement_Type:
		Movement_Type.CLOCKWISE:
			#base.rotation_degrees = 0.0 
			
			to_rotate = base.rotation_degrees + rad2deg(1.5708) # 180
			dummie.position = Vector2(160,0)
			kBody.set_collision_mask_bit ( 7, true ) 
			colArea.set_collision_mask_bit ( 7, true ) 
			kBody.set_collision_mask_bit ( 4, false ) #Cannot detect nor hit hazards 
			colArea.set_collision_mask_bit ( 4, false )
			moveSpeed = abs(moveSpeed) 
		Movement_Type.ANTICLOCKWISE:
			#base.rotation_degrees = -180
			to_rotate = -180
			dummie.position = Vector2(-160,0)
			kBody.set_collision_mask_bit ( 7, true ) 
			colArea.set_collision_mask_bit ( 7, true )
			kBody.set_collision_mask_bit ( 4, false ) 
			colArea.set_collision_mask_bit ( 4, false ) 
			moveSpeed  = abs(moveSpeed) * -1
		Movement_Type.INSIDE:
			moveSpeed = abs(moveSpeed)
			kBody.set_collision_mask_bit ( 7, false ) #The enemy cannot hit the boxes
			colArea.set_collision_mask_bit ( 7, false ) #The enemy cannot detect the boxes
			self.set_scale(Vector2(1,1))
			pass
		Movement_Type.OUTSIDE:
			anim_mesh.play("patrol_loop")
			kBody.set_collision_mask_bit ( 4, false ) 
			colArea.set_collision_mask_bit ( 4, false )
			kBody.remove_from_group("InstaKill")
			pass
		Movement_Type.FROMCENTER:
			to_rotate = base.rotation_degrees + rad2deg(1.5708) # 180
			dummie.position = Vector2(160,0)
			kBody.set_collision_mask_bit ( 7, true ) 
			colArea.set_collision_mask_bit ( 7, true ) 
			kBody.set_collision_mask_bit ( 4, false ) #Cannot detect nor hit hazards 
			colArea.set_collision_mask_bit ( 4, false )
			pass

func puppet_mode():
	# aimation dead 
	is_ready = false
	if is_defeated:
		emit_signal("defeated")
		#disable all cossions 
		playerPull = false
		player.get_parent().gravity = Vector2.ZERO
		kBody.set_collision_mask_bit ( 0, false ) 
		kBody.set_collision_mask_bit ( 7, false ) 
		colArea.set_collision_mask_bit ( 7, false )
		kBody.set_collision_mask_bit ( 4, false ) 
		colArea.set_collision_mask_bit ( 4, false )
		# play animation defeated
		
		pass
	
	pass

func puppet_mode_off():
	is_ready = true
	moveTimer.start()
	pass

func taunt_anim():
	anim_mesh.play("attack_loop")
	pass

func patrol_anim():
	anim_mesh.play("patrol_loop")
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		playerPull = true
	if(body.is_in_group("Hazard")):
		
		hazardOrbs.append(body)
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		playerPull = false
		player.get_parent().gravity = Vector2.ZERO
	if(body.is_in_group("Hazard")):
		body.set_applied_force(Vector2.ZERO)
		hazardOrbs.erase(body)
	pass # Replace with function body.


