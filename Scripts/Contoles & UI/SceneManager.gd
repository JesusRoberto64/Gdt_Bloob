extends Node2D

onready var tran = $TransitionScreen
var reference_path = ""

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		#tran.Transition_in()
		pass
	pass

func start_tran():
	tran.Transition_in()
	pass

func _on_Timer_timeout():
	tran.Transition_out()
	pass # Replace with function body.

func _on_TransitionScreen_tran_out():
	
	pass # Replace with function body.

func _on_TransitionScreen_tran_in():
	if reference_path != "":
		#get_tree().change_scene(reference_path) # cuando no hay sonido
		pass
	pass # Replace with function body.

func triger_tran(path: String):
	#print("cambio")
	reference_path = path
	tran.Transition_in()
#	if path != "":
#		get_tree().change_scene(path)
	pass

func _on_Audio_btn_finished():
	if reference_path != "":
		get_tree().change_scene(reference_path)
	pass # Replace with function body.
