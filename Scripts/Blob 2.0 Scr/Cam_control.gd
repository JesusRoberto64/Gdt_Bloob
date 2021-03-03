extends Area2D

export var anim_string = "" 

onready var dummie = get_parent()

func _on_Cam_control_body_entered(body):
	var cam = body.get_parent().camera
	#cam.is_cinematic = true
	#cam.cinematic(anim_string)
	cam.move_cam(global_position)
	dummie.save_status()
	queue_free()
	pass # Replace with function body.
