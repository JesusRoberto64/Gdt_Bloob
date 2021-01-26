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
func _ready():
	fill_color = Color(0.0,0.0,0.0,1.0)
	line_color = Color(0.0,0.0,0.0,1.0)
	var points = planc.points
	past_radius = planc.radius
	cells = planc.radius*0.2
	cells = clamp(cells,5.0,15.0)
	next_cell = planc.radius*0.00002
	pass

func _process(_delta):
	#var color = Color(0.0,0.0,0.0,0.0) # es verde
	match cur_state:
		STATE.IDLE:
			pass
		STATE.MOVING:
			fill_color = Color(0.0,1.0,0.0,0.5)
			line_color = Color.greenyellow
			spr.material.set("shader_param/body_color",Vector3(0.25,0.58,0.58))
			
			pass
		STATE.HURT:
			fill_color = Color.red
			line_color = Color.black
			spr.material.set("shader_param/body_color",Vector3(1.0,0.4,0.4))
			pass
		STATE.PUPPET:
			pass
		STATE.DYING:
			pass
	
	#poly.uv = uv_points
	
	spr.position = planc.findCentroid()
	
	#cells = lerp(cells,cells*mult,0.5)
	if past_radius != planc.radius:
		next_cell = planc.radius*0.002
		pass
	
	cells = lerp(cells,next_cell,0.06)
	cells = clamp(cells,0.01,10.0)
	
	spr.material.set("shader_param/u_time",cells)
	#print(cells)
	pass


func ghost():
	pass
