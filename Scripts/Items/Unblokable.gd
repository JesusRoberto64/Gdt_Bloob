extends Area2D

enum UPGRADE {SHIELD,ASTEROS}

export(UPGRADE) var upgrade

var ability = ""

onready var polygon_grph  = $CollisionShape2D/Polygon2D

func _ready():
	match upgrade:
		UPGRADE.SHIELD:
			ability = "Shield"
		UPGRADE.ASTEROS:
			ability = "Asteros"
	pass

func _process(delta):
	polygon_grph.rotation += delta

func _on_Unblokable_body_entered(body):
	
	body.get_parent().unlock_ability(ability)
	print("uogradeo")
	queue_free()
	pass # Replace with function body.
