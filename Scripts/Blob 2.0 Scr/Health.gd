extends RigidBody2D

export var can_collide  = true 
var col: Color
export var direction = Vector2.ZERO

func _ready():
	add_to_group("Health")
	col = Color.aqua
	
	if !can_collide:
		#set_collision_mask_bit(1,false)
		set_collision_layer_bit(2,false)
		col = Color.darkblue
		$Timer.start(0.5)
	
	pass

func _process(delta):
	update()
	pass

func _physics_process(delta):
	
	if !can_collide:
		apply_central_impulse(direction*800*delta)
		pass
	else:
		linear_velocity = lerp(linear_velocity,Vector2.ZERO,0.1)
		pass
	
	pass

func _draw():
	
	draw_circle(Vector2.ZERO,15,col)
	
	pass

func _on_Timer_timeout():
	can_collide = true
	col = Color.aqua
	set_collision_layer_bit(2,true)
	#set_collision_mask_bit(1,true)
	pass 
