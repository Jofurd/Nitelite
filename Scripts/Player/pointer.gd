extends Node2D

const BALL_SPEED = 300

var cooldown = false
onready var swingPosition = $SwingMarker
onready var timer = $Timer
onready var hitbox = $Hitbox/CollisionShape2D
onready var swingside = 1

func _physics_process(_delta):
	if cooldown != true:
		look_at(get_global_mouse_position())
	else:
		if swingside == 1:
			self.rotate(.3)
		else:
			self.rotate(-.3)
	if Input.is_action_just_pressed("primary_action"):
		if cooldown == false:
			attack()
	
	if Input.is_action_just_pressed("secondary_action"):
		pass
	

func attack():
	timer.start()
	hitbox.disabled = false
	if swingside == 1:
		self.rotate(45)
		swingside = 0
	else:
		self.rotate(-45)
		swingside = 1
	var swordSwing = load("res://Prefabs/Sounds/sword_swing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)
	
	cooldown = true
	

func cast():
	var magicBall = load("res://Prefabs/Player/MagicBall.tscn")
	var ball_instance = magicBall.instance()
	ball_instance.position = global_position
	ball_instance.rotation_degrees = rotation_degrees
	ball_instance.apply_impulse(Vector2(),Vector2(BALL_SPEED,0).rotated(rotation))
	var world = get_tree().current_scene
	world.add_child(ball_instance)
	



func _on_Timer_timeout():
	hitbox.disabled = true
	cooldown = false
