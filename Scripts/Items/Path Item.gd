extends Node2D

enum ITEM{HAZARD,HEALTH}

onready var points: Path2D = $Path2D 

var Health = preload("res://Prefabs/Blob 2.0/Health.tscn")
var Hazard = preload("res://Prefabs/Enemies/Hazard.tscn")

export (ITEM) var item_type

func _ready():
	
	var selected_item 
	match item_type:
		ITEM.HAZARD:
			selected_item = Hazard
		ITEM.HEALTH:
			selected_item = Health
	
	if points.curve == null:
		return
	
	for i in points.curve.get_point_count():
		var point = points.curve.get_point_position(i)
		var ints_Iteme = selected_item.instance()
		ints_Iteme.position = point
		if item_type == ITEM.HEALTH:
			ints_Iteme.is_life_infite = true
		add_child(ints_Iteme)
		pass
	
	pass
