extends Polygon2D

export var timer_end: float = 2.0
var counter: float = 0.0

func _process(delta):
	
	counter += delta
	color.a = lerp(color.a,0.0,0.1)
	#scale = lerp(scale,Vector2.ZERO,0.1)
	if counter >= timer_end:
		queue_free()
		pass
