extends Node2D

const BALL_SPEED = 300

var cooldown = false
onready var swingPosition = $SwingMarker
onready var timer = $Timer
onready var slashHitbox = $Sprite/SlashHitbox/CollisionShape2D
onready var stabHitbox = $Sprite/StabHitbox/CollisionShape2D
onready var animationPlayer = $Sprite/AnimationPlayer


func _physics_process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("primary_action"):
		if cooldown == false:
			swing()
	
	if Input.is_action_just_pressed("secondary_action"):
		pass
	

func swing():
	cooldown = true
	animationPlayer.stop()
	animationPlayer.play("Swing")
	


func swing_sound():
	var swordSwing = load("res://Prefabs/Sounds/sword_swing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)

func exit_swing():
	cooldown = false

