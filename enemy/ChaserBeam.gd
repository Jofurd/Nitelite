extends KinematicBody2D


var velocity = Vector2.ZERO
export var ACCELERATION = 300
export var MAX_SPEED = 70
export var FRICTION = 150


onready var playerDetectionZone = $PlayerDetectionZone

func _ready():
	self.set_as_toplevel(true)

func _physics_process(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		pass
	
	velocity = move_and_slide(velocity)
