extends CanvasLayer

signal tran_in
signal tran_out

onready var anim = $AnimationPlayer
onready var col = $ColorRect

func _ready():
	col.show()
	pass

func Transition_out():
	anim.play("fade_to_normal")
	
func Transition_in():
	
	col.show()
	anim.play("fade_to_black")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("tran_in")
		#anim.play("fade_to_normal")
		pass
	if anim_name == "fade_to_normal":
		emit_signal("tran_out")
		col.hide()
