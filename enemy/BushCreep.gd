extends KinematicBody2D

var velocity = Vector2.ZERO
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 150
export var DASH_SPEED = 300

onready var stats = $Stats
onready var sprite = $bushcreep
onready var animationPlayer = $bushcreep/AnimationPlayer
onready var animationTree = $bushcreep/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var closePlayerDetect = $DetectClosePlayer
onready var farPlayerDetect = $DetectFarPlayer
onready var damageTint = $bushcreep/damage
onready var hurtBox = $Hurtbox
onready var softCollision = $SoftCollision
onready var stopHurtSound = $hurt
onready var musicZone =$MusicZone/CollisionShape2D
onready var hitbox = $Hitbox/CollisionShape2D


enum{
	HURT,
	DEATH,
	IDLE,
	CHASE
	
}

var state = IDLE

func _physics_process(delta):
	match state:
		
		HURT:
			velocity = velocity.move_toward(Vector2.ZERO, MAX_SPEED * delta)
			hurt_state()
		
		DEATH:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			death_state()
		
		IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		CHASE:
			var farPlayer = farPlayerDetect.player
			if farPlayer != null:
				animationState.travel("Move")
				var direction = (farPlayer.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				musicZone.disabled = true
				hitbox.disabled = true
				state = IDLE
			sprite.flip_h = velocity.x > 0
			if softCollision.is_colliding():
				velocity += softCollision.get_push_vector() * delta * 600
	
	
	velocity = move_and_slide(velocity)
	

func seek_player():
	if closePlayerDetect.can_see_player():
		musicZone.disabled = false
		hitbox.disabled = false
		state = CHASE

func hurt_state():	
	animationState.travel("Hurt")

func exit_hurt():
	stopHurtSound.playing = false
	if closePlayerDetect.can_see_player():
		musicZone.disabled = false
		hitbox.disabled = false
		state = CHASE
	else:
		state = IDLE

func _on_Stats_no_health():
	death_state()
	
func death_state():
	state = DEATH
	animationState.travel("Death")

func _on_Hurtbox_area_entered(area):
	state = HURT
	stats.health -= area.damage
	damageTint.play("DamageTint")
	hurtBox.start_invincibility(.5)
	
	var splinterEffect = load("res://enemy/LeafEffect.tscn")
	var splinter_instance = splinterEffect.instance()
	splinter_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(splinter_instance)