extends Node2D

const BALL_SPEED = 300

var cooldown = false
onready var swingPosition = $SwingMarker
onready var timer = $Timer

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("primary_action"):
		if cooldown == false:
			attack()
	
	if Input.is_action_just_pressed("secondary_action"):
		cast()
	

func attack():
	
	var swordSwing = load("res://Prefabs/Player/SwordSwing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)
	
	self.cooldown = true
	timer.start()

func cast():
	var magicBall = load("res://Prefabs/Player/MagicBall.tscn")
	var ball_instance = magicBall.instance()
	ball_instance.position = global_position
	ball_instance.rotation_degrees = rotation_degrees
	ball_instance.apply_impulse(Vector2(),Vector2(BALL_SPEED,0).rotated(rotation))
	var world = get_tree().current_scene
	world.add_child(ball_instance)
	



func _on_Timer_timeout():
	self.cooldown = false
