extends Area2D

export onready var actionTrack = $forest_action


func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0


#func _process(_delta):
#	if is_colliding():
#		if areas.size() > 0:
#			if actionTrack.volume_db <= -1:
#					actionTrack.volume_db += 1
#	elif actionTrack.volume_db >= -50:
#		actionTrack.volume_db -= 0.12
