extends KinematicBody2D

signal disable
var vorti 
var timer: Timer

func _ready():
	vorti = get_parent().get_parent()
	connect("disable",vorti,"toggle_disable")
	timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout",self,"enable")
	add_child(timer)
	pass

func toggle_disable():
	emit_signal("disable")
	vorti.eating = true
	timer.start()
	
	pass

func enable():
	vorti.eating = false
	emit_signal("disable")
	
	pass
