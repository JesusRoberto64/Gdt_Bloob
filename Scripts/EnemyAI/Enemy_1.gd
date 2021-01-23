extends Node2D

onready var raycast = get_node("RayCastParent/RayCast2D")
onready var stunTimer = $StunedTimer

var player = null
var bodyDetected = false
var rotationBase = null
var canSeePlayerFlag = false
var health_Orbs = []
var stunCount = 0
var stuned = false


export var pullForce = 15
export var pullOrbForce = 10
export var amounToStun = 2 #This value is the number of health orbs needed to stun the enemy
# Called when the node enters the scene tree for the first time.
func _ready():	
	#player = get_node("/root/Main/Blob")
	player = get_tree().get_nodes_in_group("Player")[0]
	
	rotationBase = get_node("Base")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	if !stuned:
		FollowPlayer()
		RaycastToPlayer()
#	if(bodyDetected):
#		var dir = (get_transform().origin - player.get_transform().origin).normalized()
#		#player.add_central_force (dir*pullForce)
#
#		pass
	
	pass

func _physics_process(_delta):
	if !stuned:
		if(bodyDetected and canSeePlayerFlag):
			var dir = (get_transform().origin - player.get_transform().origin).normalized()
			
			if player.get_global_position().x > position.x:
				dir.x *= -1
				pass
			if player.get_global_position().y > position.y:
				dir.y *= -1
				pass
			#print(dir)
			player.get_parent().gravity = Vector2(dir*pullForce)
			pass
		
		if ( !health_Orbs.empty() and canSeePlayerFlag):
			for orb in health_Orbs:
				var dirToOrb = (get_global_transform().origin - orb.get_global_transform().origin).normalized()
				orb.add_central_force(dirToOrb*pullOrbForce);
				pass			
			pass
		
	
	pass

func RaycastToPlayer():

	if player == null:
		return
	#var dir = self.get_position().direction_to(Vector2.ZERO)
	raycast.get_parent().look_at(player.get_global_position())
	var detectedObject = raycast.get_collider()
	if(detectedObject != player):
		if(canSeePlayerFlag):
			canSeePlayerFlag = false
			OnBodyExited()
	else:
		canSeePlayerFlag = true
		pass
	pass

func FollowPlayer():
	if player == null:
		return
	rotationBase.look_at(player.get_global_position())
	
	pass

#Detect when player enters the vision's area
func _on_Area2D_body_entered(body):
	if(player == body):
		bodyDetected = true
		#print("paso")
	else:
		if(body.is_in_group("Health")):
			if body.is_life_infite == false:
				#Start absorbing orb expulsated by the player
				health_Orbs.append(body)
			
		
	

#Detect when player leaves vision's area
func _on_Area2D_body_exited(body):
	if(player == body):
		bodyDetected = false
		#player.set_applied_force(Vector2.ZERO)
		player.get_parent().gravity = Vector2.ZERO
	else:
		if(body.is_in_group("Health")):
			if body.is_life_infite == false:
				#Stop absorbing helth orb
				health_Orbs.erase(body)
			

func OnBodyExited():
	#print("Player Outside of vision")
	#player.set_applied_force(Vector2.ZERO)
	player.get_parent().gravity = Vector2.ZERO
	pass


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
