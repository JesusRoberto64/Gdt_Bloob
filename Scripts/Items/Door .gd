extends Area2D

onready var poly = $Polygon2D

func _ready():
	add_to_group("Door")

func _process(delta):
	poly.rotation += delta


func _on_Door__body_entered(body):
	#print(body.name)
	body.get_parent().enter_door()
	
	pass # Replace with function body.
