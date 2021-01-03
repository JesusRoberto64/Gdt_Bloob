extends TextureButton

export var reference_path = ""
export(bool) var start_focused = false
signal path_info(path)

func _ready ():
	if (start_focused):
		grab_focus()
		
	connect("mouse_entered", self, "on_Button_mouse_entered")
	connect("pressed", self, "on_Button_Pressed")
	
func on_Button_mouse_entered():
	grab_focus()

func on_Button_Pressed():
#	if (reference_path != ""):
#		get_tree().change_scene(reference_path)
#	else:
#		get_tree().quit()
	print("button pressed")
	emit_signal("path_info", reference_path)
	
	pass

