extends Node2D

onready var raycast = get_node("RayCastParent/RayCast2D")

var player = null
var bodyDetected = false
var rotationBase = null
var canSeePlayerFlag = false

export var pullForce = 10

# Called when the node enters the scene tree for the first time.
func _ready():	
	player = get_node("/root/Main/Blob")
	rotationBase = get_node("Base")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	FollowPlayer()
	RaycastToPlayer()
	if(bodyDetected and canSeePlayerFlag):
		var dir = (get_transform().origin - player.get_transform().origin).normalized()
		player.add_central_force (dir*pullForce)
		pass
		
	pass

func RaycastToPlayer():
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
	rotationBase.look_at(player.get_global_position())
	
	pass

#Detect when player enters the vision's area
func _on_Area2D_body_entered(body):
	if(player == body):
		bodyDetected = true
	pass # Replace with function body.

#Detect when player leaves vision's area
func _on_Area2D_body_exited(body):
	if(player == body):
		bodyDetected = false
		player.set_applied_force(Vector2.ZERO)
	pass # Replace with function body.

func OnBodyExited():
	#print("Player Outside of vision")
	player.set_applied_force(Vector2.ZERO)
