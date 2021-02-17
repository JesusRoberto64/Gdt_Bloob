extends Area2D

func _on_Gatelimit_body_entered(_body):
	#get_parent().is_opening = false
	get_parent().limit_gate = true
	pass # Replace with function body.
