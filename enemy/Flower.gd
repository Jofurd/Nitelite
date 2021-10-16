extends KinematicBody2D

var velocity = Vector2.ZERO
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 150
export var DASH_SPEED = 300


onready var animationPlayer = $Sprite/AnimationPlayer
onready var animationTree = $Sprite/AnimationTree
onready var animationState = animationTree.get("parameters/playback")


enum{
	HURT,
	DEATH,
	IDLE,
	MOVING,
	SHOOTING
}


var state = IDLE
func _physics_process(delta):
	match state:
		HURT:
			pass
		
		DEATH:
			pass
		
		IDLE:
			pass
		
		MOVING:
			pass
		
		SHOOTING:
			pass
		
	
	velocity = move_and_slide(velocity)


