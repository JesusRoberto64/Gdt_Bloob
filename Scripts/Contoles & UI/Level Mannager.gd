extends Node2D

onready var target = $ScenDemo1
var area 

onready var queue = get_node("/root/ResourceQueue")
var area_to_load = ""
var timer: Timer
var can_instantate = false

### proto system 
onready var nest = $Nest
export var instnaces_path: PoolStringArray = []
var actual_inst: int = 0

func _ready():
	queue.start()
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",self,"intance_enemies")
	#timer.one_shot = true
	timer.wait_time = 0.5
	pass

func _process(delta):
	if can_instantate and actual_inst <= instnaces_path.size()-1:
		var inst_path = instnaces_path[actual_inst]
		queue.queue_resource(inst_path,true)
		timer.start()
		can_instantate = false
	
	pass

func intance_enemies():

	if queue.is_ready(instnaces_path[actual_inst]):
		var area = queue.get_resource(instnaces_path[actual_inst]).instance()
		nest.call_deferred("add_child",area)
		actual_inst += 1
		#actual_inst = clamp(actual_inst,0,instnaces_path.size()-1)
		can_instantate = true
		timer.stop()
	else:
		print(queue.get_progress(instnaces_path[actual_inst]))
	pass


func _on_Detector_body_entered(body):
	can_instantate = true
	pass # Replace with function body.


func _on_Detector_body_exited(body):
	for i in nest.get_children():
		i.queue_free()
		pass
	can_instantate = false
	actual_inst = 0
	pass # Replace with function body.
