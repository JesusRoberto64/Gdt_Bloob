extends CanvasLayer

signal tran_in
signal tran_out

func _ready():
	pass

func Transition_out():
	$AnimationPlayer.play("fade_to_normal")
	
func Transition_in():
	print("trna in")
	$ColorRect.show()
	$AnimationPlayer.play("fade_to_black")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("tran_in")
		#$AnimationPlayer.play("fade_to_normal")
		pass
	if anim_name == "fade_to_normal":
		emit_signal("tran_out")
		$ColorRect.hide()
