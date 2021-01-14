extends RigidBody2D

export var can_collide  = true 
var col: Color
export var direction = Vector2.ZERO

var vanish = false 
var life_time = 5.0
onready var lifeTimer = $lifeTimer

var time_to_collide = 0.5
var aplied_force = 800

export(bool) var is_life_infite = false

export(bool) var is_projectile = false

func _ready():
	add_to_group("Health")
	col = Color.aqua
	
	if !can_collide:
		#set_collision_mask_bit(1,false)
		set_collision_layer_bit(2,false)
		col = Color.darkblue
		
		$Timer.start(time_to_collide)
	
	# deafult life time seconds
	#lifeTime.start(5)
	if !is_life_infite:
		lifeTimer.wait_time = life_time
		lifeTimer.start()
	
	if is_projectile:
		connect("body_entered",self,"attack")
		contact_monitor = true
		
	
	pass

func _process(delta):
	update()
	pass

func _physics_process(delta):
	if !can_collide:
		apply_central_impulse(direction.normalized()*aplied_force*delta)
		pass
	else:
		linear_velocity = lerp(linear_velocity,Vector2.ZERO,0.1)
		pass
	
	if vanish:
		queue_free()
	pass

func _draw():
	draw_circle(Vector2.ZERO,15,col)
	pass

func _on_Timer_timeout():
	can_collide = true
	col = Color.aqua
	set_collision_layer_bit(2,true)
	pass 


func _on_lifeTimer_timeout():
	vanish = true
	pass # Replace with function body.

func attack(body):
	
	if body.is_in_group("Voticella"):
		body.toggle_disable()
		pass

