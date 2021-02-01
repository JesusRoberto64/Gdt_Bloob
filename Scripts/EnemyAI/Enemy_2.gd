extends Node2D
enum States {IDLE, MOVE, FOLLOW, RETURN}
enum Movement{SECUENTIAL, RANDOM}
onready var rng = RandomNumberGenerator.new()
onready var positioner = get_node("../Positioner")
onready var timer = get_node("Base/Timer")
onready var raycast = get_node("RayCastParent/RayCast2D")
onready var base = get_node("Base")
onready var points: Path2D = get_parent()
onready var nav2d = get_parent().get_parent()
onready var stunTimer = $Base/StunedTimer

var pathPositionIndex = -1
var pathPositions = []
var player = null
var bodyDetected = false
var bodyDetectedflag = false
var areaShape = null
var target = null
var waitTimer = 0.0
var canSeePlayerFlag = true
var path = []
var health_Orbs = []
var stunCount = 0
var stuned = false

export (Movement) var movementType = Movement.SECUENTIAL
export (States) var currentState = States.IDLE
export var pullForce = 20
export var patrolSpeed = 70
export var pursueSpeed = 80
export var idleWaitTime = 2
export var amounToStun = 2 
export var pullOrbForce = 10

# refrence to animation 
onready var anim = $"Base/Kinematic Body".get_node("Viewport/Stentor/AnimationPlayer")

func _ready():	
	if points.curve == null:
		print_debug("Enemy " + self.name + " has no path2D points established")
		return
	for i in points.curve.get_point_count():
		pathPositions.append(points.curve.get_point_position(i))
		pass
	
	rng.randomize()
	player = get_tree().get_nodes_in_group("Player")[0]
	
	pass # Replace with function body.

func _process(delta):
	#raycast.set_cast_to(player.global_transform.origin)
	#raycast.force_raycast_update ( )
	if !stuned:
		RaycastToPlayer()
		if(bodyDetected and canSeePlayerFlag):
			FollowPlayer(delta)

			pass
		else:
			if(target == null):
				target = GetNextPosition()
				positioner.set_position(target) 
				base.look_at(positioner.get_global_position())
				currentState = States.MOVE
				timer.stop()
				anim.play("patrol_loop")
			else:
				Patrol(delta)
				pass
			pass
	pass


func _physics_process(_delta):
	if !stuned:
		if ( !health_Orbs.empty() and canSeePlayerFlag):
			for orb in health_Orbs:
				var dirToOrb = (get_global_transform().origin - orb.get_global_transform().origin).normalized()
				orb.add_central_force(dirToOrb*pullOrbForce);
				pass			
			pass
		
	
	pass

func pullPlayer():
	var dir = (get_transform().origin - positioner.get_transform().origin).normalized()
	player.get_parent().gravity = Vector2(dir*pullForce)
		# if player.get_global_position().x > get_global_position().x:
		# 	dir.x *= -1
		# 	pass
		# if player.get_global_position().y > get_global_position().y:
		# 	dir.y *= -1
		# 	pass
		#print(dir)
	
	pass

func RaycastToPlayer():
	#var dir = self.get_position().direction_to(Vector2.ZERO)
	raycast.get_parent().look_at(player.get_global_position())
	var detectedObject = raycast.get_collider()
	
	if(detectedObject != player):
		
		if(canSeePlayerFlag):
			canSeePlayerFlag = false
			
			#OnBodyExited()
			bodyDetectedflag = false
		#if(bodyDetectedflag):
		#	OnBodyExited()
	else:
		canSeePlayerFlag = true
		pass
	pass

func GetNextPosition():
	if( movementType == Movement.SECUENTIAL):
		pathPositionIndex += 1
		if pathPositionIndex >= pathPositions.size():
			pathPositionIndex = 0
		return Vector2(pathPositions[pathPositionIndex].x, pathPositions[pathPositionIndex].y)
	else:
		var _newPos = pathPositionIndex
		while _newPos == pathPositionIndex:
			pathPositionIndex = rng.randi() % pathPositions.size()
		return Vector2(pathPositions[pathPositionIndex].x, pathPositions[pathPositionIndex].y)
	
	
func Patrol(delta):
	
	#var dir = self.get_global_position().direction_to(player.get_global_position())
	#self.translate(dir*delta*patrolSpeed)
	path = nav2d.get_simple_path(self.get_position(), positioner.get_position(), true)
	path.remove(0)
	var dist = patrolSpeed * delta
	var last_pos = self.get_position()
	for _i in range(path.size()):
		var dist_to_end = last_pos.distance_to(path[0])
		if(dist <= dist_to_end):
			self.set_position(last_pos.linear_interpolate(path[0], dist/dist_to_end))
			break
		elif (dist <= 0.5):
			self.set_position(path[0])
			break
		if(dist > dist_to_end):
			currentState = States.IDLE
			if(timer.is_stopped()):
				timer.start(idleWaitTime)	
		dist -= dist_to_end
		last_pos = path[0]
		path.remove(0)
		pass
	pass


func FollowPlayer(delta):
	#bodyDetectedflag helps to detect if the player has just left the field of vision of the enemy
	#While inside the field of vision the flag is true and the enemy follows the player
	#If the player leaves then the flag changes from true to false and starts an idle time.
	#When the idle time ends then the bodyDetected variable returns to false and the enemy choses to return to a new position
	if(bodyDetectedflag):
		positioner.set_global_position(player.get_global_position()) 
		base.look_at(positioner.get_global_position())
		#var dir = self.get_global_position().direction_to(player.get_global_position())
		#self.translate(dir*delta*patrolSpeed)
		path = nav2d.get_simple_path(self.get_position(), positioner.get_position(), true)
		path.remove(0)
		var dist = pursueSpeed * delta
		var last_pos = self.get_position()
		for _i in range(path.size()):
			var dist_to_end = last_pos.distance_to(path[0])
			if(dist <= dist_to_end):
				self.set_position(last_pos.linear_interpolate(path[0], dist/dist_to_end))
				break
			elif (dist <= 0.0):
				self.set_position(path[0])
				break
			dist -= dist_to_end
			last_pos = path[0]
			path.remove(0)
			pass
		pullPlayer()
		# var pullDir = (get_global_transform().origin - player.get_global_transform().origin).normalized()
		# player.add_central_force (pullDir*pullForce)
	else:
		if(timer.is_stopped()):
			timer.start(idleWaitTime)	
		pass
	pass


#Detect when player enters the vision's area
func _on_Area2D_body_entered(body):
	
	if(player == body):
		#print("Player Detected")
		bodyDetected = true
		bodyDetectedflag = true
		currentState = States.FOLLOW
		target = null
		timer.stop()
		anim.play("absorb_loop")
	else:
		if(body.is_in_group("Health")):
			if body.is_life_infite == false:
				#Start absorbing orb expulsated by the player
				health_Orbs.append(body)

#Detect when player leaves vision's area
func _on_Area2D_body_exited(body):
	if(player == body):
		OnBodyExited()
	else:
		if(body.is_in_group("Health")):
			if body.is_life_infite == false:
				#Stop absorbing helth orb
				health_Orbs.erase(body)

func OnBodyExited():
	bodyDetectedflag = false
	currentState = States.IDLE
	#print("Player Outside of vision")
	player.get_parent().gravity = Vector2.ZERO
	#player.get_parent().velocity = Vector2.ZERO
	#player.get_parent().drag = 0
	timer.stop()

func _on_Timer_timeout():
	target = null
	bodyDetected = false
	pass # Replace with function body.


func _on_CollisionArea_body_entered(body):
	#Collision Area for Health Orb Detection
	if(stunCount < amounToStun):
		if(body.is_in_group("Health")):
			#Delete orb
			stunCount += 1
			health_Orbs.erase(body)
			body.queue_free()
			
			if(stunCount >= amounToStun):
				#Stun Enemy
				stuned = true
				stunTimer.start()
				player.get_parent().gravity = Vector2.ZERO
			pass
	pass # Replace with function body.


func _on_StunedTimer_timeout():
	stuned = false
	stunCount = 0
	pass # Replace with function body.
