extends Label

onready var graphic = $grafic_health
var health_graph = 0 # - 14 minum radius 76 maximun
var bg_Col = Color(0.0,0.0,0.0,0.5)

var min_asteros = 19
var max_asteros = 76.0
func _ready():
	text = "Health"
	
	pass

func update_display(amount):
	
	text = "Asteros: " + str(amount - min_asteros)
	health_graph = amount - min_asteros
	pass

func _draw():
	draw_circle(graphic.position,max_asteros-min_asteros,bg_Col)
	draw_circle(graphic.position,health_graph,Color.green)
