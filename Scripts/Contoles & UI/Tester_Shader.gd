extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var myVec = Vector2(-32.0,-32.0) - Vector2(0.0,0.0)
	print(myVec , "result vec")
	
	var a = (15.0)
	var b = myVec.x
	
	var P = step(-a,b) - step(a,b)
	print(P, ": resultado resta")
	var vec = Vector3(1.0,1.0,0.0) * P
	print(vec)
	
	pass # Replace with function body.


func step(a,b) -> float:
	var result :float
	if (b < a):
		print (0.0, " b  ", b ," es menor")
		result = 0.0
	else:
		print(1.0, " b  ", b ," es mayor")
		result = 1.0
	
	
	return result
