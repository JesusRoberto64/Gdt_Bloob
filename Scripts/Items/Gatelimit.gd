extends Area2D


func _on_Gatelimit_body_entered(body):
	get_parent().is_opening = false
	print("llego")
	pass # Replace with function body.
