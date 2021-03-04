extends Node

var box = preload("res://Prefabs/Items/Caja.tscn")

var hasBox = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Player"):
		
		if !hasBox:
			var b = box.instance()
			b.set_position(Vector2.ZERO)
			hasBox = true
			#self.add_child(b) # old system
			self.call_deferred("add_child",b)
			
		pass
	pass # Replace with function body.
