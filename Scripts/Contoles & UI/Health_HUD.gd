extends Label

onready var graphic = $grafic_health
var health_graph = 0 # - 14 minum radius 76 maximun
var bg_Col = Color(0.0,0.0,0.0,0.5)

func _ready():
	text = "Health"
	
	pass

func update_display(amount):
	
	text = "Asteros: " + str(amount - 14)
	health_graph = amount - 14
	pass

func _draw():
	draw_circle(graphic.position,76-14,bg_Col)
	draw_circle(graphic.position,health_graph,Color.green)
