extends Node2D

const STAB_SPEED = 300

var cooldown = false
onready var swingPosition = $SwingMarker
onready var hitbox = $Sprite/Hitbox/CollisionShape2D
onready var animationPlayer = $Sprite/AnimationPlayer
var velocity = Vector2.ZERO
var originPosition = get_position_in_parent()

func _physics_process(_delta):
	if cooldown != true:
		look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("primary_action"):
		if cooldown == false:
			attack()
	
	if Input.is_action_just_pressed("secondary_action"):
		pass
	

func attack():
	hitbox.disabled = false
	animationPlayer.stop()
	animationPlayer.play("Stab")
	
	var swordSwing = load("res://Prefabs/Sounds/sword_swing.tscn")
	var swing_instance = swordSwing.instance()
	swingPosition.add_child(swing_instance)
	
	cooldown = true
	




func exit_stab():
	hitbox.disabled = true
	cooldown = false
