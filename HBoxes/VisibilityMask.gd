extends Area2D

onready var sprite = $Sprite

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0


func _process(_delta):
	var areas = get_overlapping_areas()
	if is_colliding():
		if areas.size() > 0:
			if sprite.self_modulate.a >= .5:
					sprite.self_modulate.a -= .05
	elif sprite.self_modulate.a <= .95:
		sprite.self_modulate.a += .05
