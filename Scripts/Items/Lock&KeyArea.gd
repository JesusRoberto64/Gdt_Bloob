extends Area2D



func _on_LockKeyArea_body_entered(body):
	if body.is_in_group("keyes"):
		print("Unlocked")
	
	pass # Replace with function body.
