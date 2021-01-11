extends Area2D
signal unlocked 

# especific key 
export var needs_id_key = false
export var id_key = ""
func _ready():
	connect("unlocked",get_parent(),"unlocked_Gate")
	pass

func _on_LockKeyArea_body_entered(body):
	if needs_id_key:
		#logic from id
		if body.name == id_key:
			emit_signal("unlocked")
			#get_parent().is_opening = true
			#print("abrio con id")
		return
	
	if body.is_in_group("keyes"):
		emit_signal("unlocked")
		#get_parent().is_opening = true
	
	pass # Replace with function body.

