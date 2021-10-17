extends Control

var paused = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if paused == false:
			get_tree().paused = true
			paused = true
			visible = true
		else:
			get_tree().paused = false
			paused = false
			visible = false

func unpause():
	get_tree().paused = false
	paused = false
	visible = false


func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	unpause()
