extends Node2D

enum STATE {IDLE, MOVING, PUPPET, HURT, DYING}
var cur_state = STATE.PUPPET # defalut movment

var fill_color: Color
var line_color: Color
onready var line = $Line2D
onready var spr = $Sprite
onready var poly = $Polygon2D
onready var planc = get_parent()
var past_radius: float

var uv_points: PoolVector2Array = []

var cells = 15.0
var next_cell

# ghost system  

var ghost_time = 0.08
var ghost_conter: float 
var ghost = preload("res://Prefabs/Blob 2.0/ghost.tscn")
onready var particles = $Particles
#onready var ghosth_particles = $Particles/Particles_ghost
var Norm_col =  Vector3(0.25,0.58,0.58)

#shader change system
var can_Shader_Chan = false
var prev_state

#screen hurt 
onready var screen_hurt = get_parent().get_node("CanvasLayer/HurtRect")

# line width max 16.0
var width = 10
var factor = 0.1

# glow sahder 
onready var glow = $Glow_Circle
var glow_size = 1.5
onready var anim_glow = $AnimationPlayer

func _ready():
	fill_color = Color(0.0,0.0,0.0,1.0)
	line_color = Color(0.0,0.0,0.0,1.0)
	var points = planc.points
	past_radius = planc.radius
	cells = planc.radius*0.2
	cells = clamp(cells,5.0,15.0)
	next_cell = planc.radius*0.00002
	line.width = width
	
	#glow 
	#glow.hide()
	#glow.material.set("shader_param/glow",-0.045) #maximo 0.3 minomo
	#glow.scale = Vector2(5.5,5.5)
	shader_change()
	pass


func _process(delta):
	#var color = Color(0.0,0.0,0.0,0.0) # es verde
	match cur_state:
		STATE.IDLE:
			
			pass
		STATE.MOVING:
			
			ghost_conter += delta
			
			if ghost_conter >=  ghost_time:
				spawn_ghost()
				ghost_conter = 0.0
			pass
			
			pass
		STATE.HURT:
			
			ghost_conter += delta
			
			if ghost_conter >=  ghost_time:
				spawn_ghost()
				ghost_conter = 0.0
			pass
			
			pass
		STATE.PUPPET:
			pass
		STATE.DYING:
			pass
	
	if prev_state != cur_state:
		can_Shader_Chan = true
	
	if can_Shader_Chan:
		shader_change()
		can_Shader_Chan = false
	
	prev_state = cur_state
	
	#Ghost effect 
	if spr.position == planc.findCentroid():
		#print("igual")
		
		pass
	
#	ghost_conter += delta
#
#	if ghost_conter >=  ghost_time:
#		spawn_ghost()
#		ghost_conter = 0.0
#		pass
	
	
	spr.position = planc.findCentroid()
	glow.position = spr.position
	#=====sistme que maneja la animacion del shaders
	#usa el radiu y multiplier para modificar el ruido del sahder
	if past_radius != planc.radius:
		next_cell = planc.radius*0.002
		pass
	
	cells = lerp(cells,next_cell,0.06) #descelera la animacion
	cells = clamp(cells,0.01,10.0) # pone un tope a la velocidad de animacion
	
	spr.material.set("shader_param/u_time",cells) # seteo en shader
	#print(cells)
	var exponential = planc.radius*factor
	line.width = pow(0.3+1.5,exponential)
	line.width = clamp(line.width,9,17)
	
#	glow_size = pow(1.3,exponential)
#	glow_size = clamp(glow_size,1.5,5.2)
#	glow.scale = Vector2(glow_size,glow_size)
	
	pass

func show_glow():
	glow.show()
	var exponential = planc.radius*factor
	glow_size = pow(1.3,exponential)
	glow_size = clamp(glow_size,2.8,6.2)
	glow.scale = Vector2(glow_size,glow_size)
	
	anim_glow.play("glow")


func spawn_ghost():
	var inst = ghost.instance()
	inst.polygon = poly.polygon
	particles.add_child(inst)
	pass

func shader_change():
	match cur_state:
		STATE.HURT:
			fill_color = Color.red
			line_color = Color.black
			spr.material.set("shader_param/body_color",Vector3(1.0,0.4,0.4))
			spr.material.set("shader_param/back_color",Vector3(1.0,0.0,0.0)) #Change both to change the sahder body 
			poly.color = Color.red
			screen_hurt.show()
			pass
		STATE.MOVING:
			fill_color = Color(0.0,1.0,0.0,0.5)
			line_color = Color.greenyellow
			spr.material.set("shader_param/body_color",Norm_col)
			spr.material.set("shader_param/back_color",Vector3(0.0,1.0,0.0))
			poly.color = Color.green
			screen_hurt.hide()
			pass
		STATE.PUPPET:
			fill_color = Color(0.0,1.0,0.0,0.5)
			line_color = Color.greenyellow
			spr.material.set("shader_param/body_color",Norm_col)
			spr.material.set("shader_param/back_color",Vector3(0.0,1.0,0.0))
			poly.color = Color.green
			pass
	pass

