extends ColorRect


var open = false
func _process(_delta):
	if Input.is_action_just_pressed("Inventory"):
		if open == false:
			self.visible = true
			open = true
		else:
			self.visible = false
			open = false
		
