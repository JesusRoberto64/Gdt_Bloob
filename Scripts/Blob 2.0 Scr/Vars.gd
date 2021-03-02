extends Node

var inital_pos = Vector2(13487,1672)
var can_save = false
var first_time = false # use when you star a file for first time

func getVectorByLA (length, angle):
	angle = deg2rad(angle)
	var vector = Vector2(cos(angle), sin(angle)) * length
	return vector

func reload_vars():
	can_save = false
	print("reloded")
