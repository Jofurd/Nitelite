extends Node2D

const BALL_SPEED = 300

var cooldown = false
onready var swingPosition = $SwingMarker
onready var slashHitbox = $Sprite/SpinHitbox/CollisionShape2D
onready var slashArea = $Sprite/SpinHitbox
onready var stabHitbox = $Sprite/StabHitbox/CollisionShape2D
onready var stabArea= $Sprite/StabHitbox
onready var animationPlayer = $Sprite/AnimationPlayer


func _physics_process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("primary_action"):
		if cooldown == false:
			stab()
	
	if Input.is_action_just_pressed("secondary_action"):
		if cooldown == false:
			spin()
	

func spin():
	cooldown = true
	animationPlayer.stop()
	animationPlayer.play("Spin")
	
	var mouse_position = get_global_mouse_position()
	var knockback = (mouse_position - global_position).normalized()
	slashArea.knockback = knockback * 200

func stab():
	cooldown = true
	animationPlayer.stop()
	animationPlayer.play("Stab")
	stabArea.knockback = null
	
	var mouse_position = get_global_mouse_position()
	var knockback = (mouse_position - global_position).normalized()
	slashArea.knockback = knockback * 40
	
	var swordSwing = load("res://Prefabs/Sounds/sword_swing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)


func exit_spin():
	cooldown = false

func exit_stab():
	cooldown = false
