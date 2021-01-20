extends KinematicBody2D

onready var area = $Area2D
signal area_size(body)
signal hurt
signal enter_door

onready var planc = get_parent()
var is_hurt = false
onready var timer = $Timer
# push object force
var push = 0.5
const factor = 0.1
# puede mepujar rojos
var can_push = false

func _ready():
	connect("area_size",get_parent(),"grow")
	connect("hurt",get_parent(),"hurt")
	connect("enter_door",get_parent(),"enter_door")
	add_to_group("Collision")
	pass

func _process(delta):
	#print(planc.radius)
	var exponrntial = planc.radius*factor 
	
	
	if planc.radius <= 25:
		push = 0.5
	else:
		push = pow(0.3+1.5,exponrntial)
	#print(push)
	pass

func _physics_process(delta):
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		#collision.collider.apply_central_impulse(-collision.normal*push)
		if collision.collider.is_in_group("Push"):
			collision.collider.apply_central_impulse(-collision.normal*push)
		if collision.collider.is_in_group("Gate"):
			collision.collider.apply_central_impulse(Vector2.ZERO)
			
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Health"):
		body.queue_free()
		emit_signal("area_size",body)
	
	if body.is_in_group("Hazard"):
		#print("Touched Hazard")
		emit_signal("hurt")
		is_hurt = true
		timer.start()
		update()
		#body.mode = 0 # kinematic
		if can_push:
			
			if body.is_in_group("Brachi") or body.is_in_group("Voticella"):
				pass
			else:
				body.call_deferred("set_mode",0)
				body.update()
				body.life_timer.start()
		pass
	
	if body.is_in_group("Door"):
		
		emit_signal("enter_door")
		pass
	
	pass 

func _draw():
	if !is_hurt:
		if can_push:
			draw_circle(Vector2.ZERO,10.0,Color.green)
		else:
			draw_circle(Vector2.ZERO,10.0,Color.greenyellow)
	else:
		draw_circle(Vector2.ZERO,10.0,Color.red)
		
	pass

func _on_Timer_timeout():
	is_hurt = false
	update()
	pass # Replace with function body.
