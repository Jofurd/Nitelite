extends KinematicBody2D


var velocity = Vector2.ZERO
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 150


onready var playerDetectionZone = $PlayerDetectionZone
onready var burnPatch = $burnpatch
onready var animatedSprite = $AnimatedSprite
onready var smoke = $smoke
onready var audio = $AudioStreamPlayer2D

func _ready():
	self.set_as_toplevel(true)


enum{
	IDLE,
	ACTIVE
	}

var state = IDLE
func _physics_process(delta):
	match state:
		IDLE:
			audio.playing = false
			animatedSprite.scale.x = 0
			animatedSprite.scale.y = 0
			burnPatch.emitting = false
			smoke.emitting = false
			
			velocity = Vector2.ZERO
		
		ACTIVE:
			animatedSprite.scale.x = 1
			animatedSprite.scale.y = 1
			burnPatch.emitting = true
			smoke.emitting = true
			
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
		
		
	
	velocity = move_and_slide(velocity)
