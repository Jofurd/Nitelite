extends Area2D


var campfire = null

func can_see_campfire():
	return campfire != null

func _on_PlayerDetectionZone_body_entered(body):
	campfire = body


func _on_PlayerDetectionZone_body_exited(_body):
	campfire = null
