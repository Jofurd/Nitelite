extends Particles2D



func _process(_delta):
	if emitting == false:
		queue_free()


