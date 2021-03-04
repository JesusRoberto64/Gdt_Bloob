extends Node2D

var item_pulled = preload("res://Prefabs/Blob 2.0/Health.tscn")
var deg = rad2deg(rotation)
onready var timer = $Timer
var one_shot = true
var item_direct = Vector2(0,-1) 
var deactivate = false
var player = null
var activate_dist = Vector2.ZERO

func _ready():
	item_direct = -(global_position - $Position2D.global_position)
	player = get_tree().get_nodes_in_group("Player")[0]
	
	pass

func _process(_delta):
	if one_shot:
		if !deactivate:
			life_instance()
#		var item_expulse_inst = item_pulled.instance()
#		item_expulse_inst.can_collide = false
#		item_expulse_inst.position = position
#		item_expulse_inst.time_to_collide = 0.1
#		item_expulse_inst.life_time = 1.0
#		item_expulse_inst.direction = item_direct
#		get_parent().add_child(item_expulse_inst)
#		one_shot = false
#		timer.start()
	pass
	activate_dist =  global_position.distance_to(player.global_position)
	
	if activate_dist < 680:
		deactivate = false
		pass
	else:
		deactivate = true
		pass
	

func life_instance():
	var item_expulse_inst = item_pulled.instance()
	item_expulse_inst.can_collide = false
	item_expulse_inst.position = position
	item_expulse_inst.time_to_collide = 0.1
	item_expulse_inst.life_time = 1.0
	item_expulse_inst.direction = item_direct
	get_parent().add_child(item_expulse_inst)
	one_shot = false
	timer.start()
	pass

func _on_Timer_timeout():
	one_shot = true
	pass # Replace with function body.
