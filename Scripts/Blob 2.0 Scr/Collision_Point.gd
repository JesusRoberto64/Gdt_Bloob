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

func _process(_delta):
	#print(planc.radius)
	var exponrntial = planc.radius*factor 
	if planc.radius <= 25:
		push = 0.5
	else:
		push = pow(0.3+1.5,exponrntial)
	#print(push)
	pass

func _physics_process(_delta):
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
		
		if can_push and body.is_in_group("Push"):
			body.call_deferred("set_mode",0)
			body.update()
			body.life_timer.start()
			return
		
		emit_signal("hurt")
		is_hurt = true
		timer.start()
		update()
		
	if body.is_in_group("InstaKill"):
		emit_signal("dead")
	if body.is_in_group("Door"):
		
		emit_signal("enter_door")
		print("doored")
		pass
	
	pass 

func _draw():
	if !is_hurt:
		#draw_circle(Vector2.ZERO,10.0,Color.greenyellow)
		pass
	else:
		#draw_circle(Vector2.ZERO,10.0,Color.red)
		pass
	pass

func _on_Timer_timeout():
	is_hurt = false
	update()
	pass # Replace with function body.
