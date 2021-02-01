extends Node2D
enum States {IDLE, MOVE, FOLLOW, PREPARE}
enum Movement{SECUENTIAL, RANDOM}
onready var rng = RandomNumberGenerator.new()
onready var positioner = get_node("../Positioner")
onready var timer = get_node("Base/Timer")
onready var raycast = get_node("RayCastParent/RayCast2D")
onready var base = get_node("Base")
onready var nav2d = get_parent().get_parent()
onready var stunTimer = $Base/StunedTimer
onready var points: Path2D = get_parent()
onready var kBody = get_node("Base/Kinematic Body")

var pathPositionIndex = -1
var pathPositions = []
var player = null
var bodyDetected = false
var bodyDetectedflag = false
var areaShape = null
var target = null
var canSeePlayerFlag = true
var path = []
var waitAttackTimer =  0.0
var playerLastPosition
var stunCount = 0
var stuned = false

export (Movement) var movementType = Movement.SECUENTIAL
export var currentState = States.IDLE
export var patrolSpeed = 70
export var pursueSpeed = 400
export var idleWaitTime = 2
export var prepareAttackTime: float = 3
export var amounToStun = 1

# animtion integration

onready var anim = $"Base/Kinematic Body".find_node("AnimationPlayer")

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


func RaycastToPlayer():
	#var dir = self.get_position().direction_to(Vector2.ZERO)
	raycast.get_parent().look_at(player.get_global_position())
	var detectedObject = raycast.get_collider()
	if(detectedObject != player):
		if(bodyDetectedflag and (currentState == States.FOLLOW or currentState == States.PREPARE)):
			if(canSeePlayerFlag):
				canSeePlayerFlag = false
				OnBodyExited()
				bodyDetectedflag = false
				
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

func FollowPlayer(_delta):
	if(bodyDetectedflag):
		waitAttackTimer += _delta
		if waitAttackTimer >= prepareAttackTime:
			if playerLastPosition == null:
				playerLastPosition = positioner.get_position()
			AttackPlayer(_delta)
			pass
		else:
			positioner.set_global_position(player.get_global_position()) 	
			base.look_at(positioner.get_global_position())
			currentState = States.PREPARE
			anim.play("prepare")
			pass
	else:
		if(timer.is_stopped()):
			timer.start(idleWaitTime)	
		pass	
	pass


func AttackPlayer(var delta):
	currentState = States.FOLLOW
	path = nav2d.get_simple_path(self.get_position(), playerLastPosition, true)
	path.remove(0)
	var dist = pursueSpeed * delta
	var last_pos = self.get_position()
	anim.play("attack_loop")
	for _i in range(path.size()):
		
		var dist_to_end = last_pos.distance_to(path[0])
		
		if(dist <= dist_to_end):
			
			self.set_position(last_pos.linear_interpolate(path[0], dist/dist_to_end))
			break
		elif (dist <= 0.0):
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


#Detect when player enters the vision's area
func _on_Area2D_body_entered(body):
	if(player == body):
		#print("Player Detected")
		bodyDetected = true
		bodyDetectedflag = true
		currentState = States.FOLLOW
		target = null
		timer.stop()
	pass # Replace with function body.

#Detect when player leaves vision's area
func _on_Area2D_body_exited(body):
	if(player == body):
		OnBodyExited()
		pass
	pass # Replace with function body.

func OnBodyExited():
	if currentState != States.FOLLOW:
		bodyDetectedflag = false
		currentState = States.IDLE
		player.get_parent().gravity = Vector2.ZERO
		timer.stop()
	pass

func _on_Timer_timeout():
	target = null
	bodyDetected = false
	playerLastPosition = null
	waitAttackTimer = 0.0
	pass # Replace with function body.


func _on_CollisionArea_body_entered(body):
	if body.is_in_group("Hazard") and !body.is_in_group("Enemies"):
		stunCount += 1
		body.queue_free()
		if stunCount >= amounToStun:
			stuned = true
			kBody.remove_from_group("Hazard")
			#stunTimer.start()
		
	pass # Replace with function body.


func _on_StunedTimer_timeout():
	stuned = false
	stunCount = 0
	kBody.add_to_group("Hazard")
	pass # Replace with function body.
