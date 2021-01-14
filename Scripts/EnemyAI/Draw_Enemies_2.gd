extends Node2D

var childs = []
var shapes = []
var bases: PoolVector2Array
var shape_draw = preload("res://Prefabs/Enemies/GraphicBrach.tscn")

func _ready():
	for i in get_children():
		bases.append(i.position)
		#var grand_child = i.get_child(1).get_child(0)
		var grand_child = i.find_node("Brachinous")
		#print(grand_child)
		var inst = shape_draw.instance()
		inst.position = i.position
		add_child(inst)
		childs.append(grand_child)
		shapes.append(inst)
		pass
	
	pass

func _process(delta):
	for i in childs.size():
		var rot = childs[i].get_child(0).rotation_degrees
		shapes[i].rotation_degrees = rot
		shapes[i].position = childs[i].position + bases[i]
		#print(shapes[i])
		pass
	pass



