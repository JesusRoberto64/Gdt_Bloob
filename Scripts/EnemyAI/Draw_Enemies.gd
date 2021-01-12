extends Node2D

var childs = []
var shapes = []
var shape_draw = preload("res://Prefabs/Enemies/GraphicVorti.tscn")

func _ready():
	for i in get_children():
		var inst = shape_draw.instance()
		inst.position = i.position
		add_child(inst)
		childs.append(i)
		shapes.append(inst)
		pass
	pass

func _process(delta):
	for i in childs.size():
		var move = childs[i].get_child(0).rotation_degrees
		#print(move)
		shapes[i].rotation_degrees = move 
		#shapes[i].get_transform().origin = childs[i].get_transform().origin
		#print(shapes[i].get_transform().origin, "shapes")
		#print(childs[i].get_transform().origin, "childs enemies")
		pass
	#get_transform().origin
	
	pass
