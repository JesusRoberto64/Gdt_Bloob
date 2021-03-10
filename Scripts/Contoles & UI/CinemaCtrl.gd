extends Node2D

export var anim_string = "" 
onready var boss = get_tree().get_nodes_in_group("AnimBoss")[0]
onready var shield = $PushHazard_Ablt
onready var anim_door = $Anim_Door
var entry = true
onready var center_pos = $Position2D
var camera 
onready var timer = $Timer

func _on_Area2D_body_entered(body):
	if !entry:
		return
	anim_door.play("close")
	var cam = body.get_parent().camera
	cam.cur_anim = anim_string
	cam.move_cam(global_position)
	boss.play("Entry")
	entry = false
	camera = cam

func boss_defeated():
	camera.frame_cam(center_pos.global_position)
	camera.anim_cam.play("Zoom_Norm_Bars")
	shield.position = center_pos.position
	shield.appear_item()
	timer.start()
	pass

func back_control():
	camera.anim_cam.play("Hide_Bars")
	camera.frame_Planc = true
	
	pass
