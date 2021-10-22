extends StaticBody2D

onready var offState = $off_state
onready var litState = $lit_state
onready var light = $Light2D

func _ready():
	litState.visible = false
	light.visible = false

func _on_Area2D_body_entered(body):
	if litState.visible == false:
		var onSound = load("res://Prefabs/Sounds/LightOnTemple.tscn")
		var onSound_instance = onSound.instance()
		self.add_child(onSound_instance)
	litState.visible = true
	light.visible = true
