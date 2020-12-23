extends Node2D
enum States {IDLE, MOVE, FOLLOW, RETURN}
onready var rng = RandomNumberGenerator.new()
onready var positioner = get_node("../Positioner")
onready var timer = get_node("Base/Timer")
onready var raycast = get_node("RayCastParent/RayCast2D")
onready var base = get_node("Base")
onready var nav2d = get_parent().get_parent().get_parent()

var player = null
var bodyDetected = false
var bodyDetectedflag = false
var areaShape = null
var target = null
var waitTimer = 0.0
var canSeePlayerFlag = true
var path = []

export var currentState = States.IDLE
export var pullForce = 20
export var patrolSpeed = 70
export var pursueSpeed = 80
export var idleWaitTime = 2

func _ready():	
	rng.randomize()
	player = get_node("/root/Main/Blob")
	areaShape = get_parent().get_shape()
	pass # Replace with function body.

func _process(delta):
	
	#raycast.set_cast_to(player.global_transform.origin)
	#raycast.force_raycast_update ( )
	RaycastToPlayer()
	
	if(bodyDetected):
		FollowPlayer(delta)
		#FollowPlayer(delta)
		pass
	else:
		if(target == null):
			target = RandomPositionInArea()
			positioner.set_position(target) 
			base.look_at(positioner.get_global_position())
			currentState = States.MOVE
			timer.stop()
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
		canSeePlayerFlag = false
		#if(bodyDetectedflag):
		#	OnBodyExited()
	else:
		canSeePlayerFlag = true
		pass
	pass

func RandomPositionInArea():
	
	var a = rng.randf() * 2 * 3.1416
	var r = areaShape.radius * sqrt(rng.randf ( ))
	
	var x = r * cos(a)
	var y = r * sin(a)
	return Vector2(floor(x), floor(y))
	
func Patrol(delta):
	
	#var dir = self.get_global_position().direction_to(player.get_global_position())
	#self.translate(dir*delta*patrolSpeed)
	path = nav2d.get_simple_path(self.get_global_position(), positioner.get_global_position(), true)
	path.remove(0)
	var dist = patrolSpeed * delta
	var last_pos = self.get_global_position()
	for i in range(path.size()):
		var dist_to_end = last_pos.distance_to(path[0])
		if(dist <= dist_to_end):
			self.set_global_position(last_pos.linear_interpolate(path[0], dist/dist_to_end))
			break
		elif (dist <= 0.5):
			self.set_global_position(path[0])
			break
		if(dist_to_end <= 2):
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
		base.look_at(player.get_global_position())
		#var dir = self.get_global_position().direction_to(player.get_global_position())
		#self.translate(dir*delta*patrolSpeed)
		path = nav2d.get_simple_path(self.get_global_position(), player.get_global_position(), true)
		path.remove(0)
		var dist = pursueSpeed * delta
		var last_pos = self.get_global_position()
		for i in range(path.size()):
			var dist_to_end = last_pos.distance_to(path[0])
			if(dist <= dist_to_end):
				self.set_global_position(last_pos.linear_interpolate(path[0], dist/dist_to_end))
				break
			elif (dist <= 0.0):
				self.set_global_position(path[0])
				break
			dist -= dist_to_end
			last_pos = path[0]
			path.remove(0)
			pass
	
		var pullDir = (get_global_transform().origin - player.get_global_transform().origin).normalized()
		player.add_central_force (pullDir*pullForce)
	else:
		if(timer.is_stopped()):
			timer.start(idleWaitTime)	
		pass
	pass



#Detect when player enters the vision's area
func _on_Area2D_body_entered(body):
	
	if(player == body and canSeePlayerFlag):
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
	bodyDetectedflag = false
	currentState = States.IDLE
	#print("Player Outside of vision")
	player.set_applied_force(Vector2.ZERO)
	timer.stop()

func _on_Timer_timeout():
	target = null
	bodyDetected = false
	pass # Replace with function body.
