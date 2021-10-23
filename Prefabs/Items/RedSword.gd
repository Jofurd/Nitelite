extends Node2D

const BALL_SPEED = 300

var cooldown = false
onready var swingPosition = $SwingMarker
onready var slashHitbox = $Sprite/SlashHitbox/CollisionShape2D
onready var stabHitbox = $Sprite/StabHitbox/CollisionShape2D
onready var animationPlayer = $Sprite/AnimationPlayer


func _physics_process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("primary_action"):
		if cooldown == false:
			swing()
	
	if Input.is_action_just_pressed("secondary_action"):
		if cooldown == false:
			stab()
	

func swing():
	cooldown = true
	slashHitbox.disabled = false
	animationPlayer.stop()
	animationPlayer.play("Swing")
	
	var swordSwing = load("res://Prefabs/Sounds/sword_swing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)

func stab():
	cooldown = true
	stabHitbox.disabled = false
	animationPlayer.stop()
	animationPlayer.play("Stab")
	
	var swordSwing = load("res://Prefabs/Sounds/sword_swing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)


func exit_swing():
	slashHitbox.disabled = true
	cooldown = false

func exit_stab():
	stabHitbox.disabled = true
	cooldown = false
