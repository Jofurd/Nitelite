extends KinematicBody2D

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
export var ACCELERATION = 300
export var MAX_SPEED = 40
export var FRICTION = 600
export var DASH_SPEED = 10

var damageNumbers = preload("res://Prefabs/DamageNumber.tscn")

onready var stats = $Stats
onready var sprite = $sprite
onready var animationPlayer = $sprite/AnimationPlayer
onready var animationTree = $sprite/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetectionZone
onready var attackRange = $AttackRange
onready var damageTint = $sprite/damage
onready var hurtBox = $Hurtbox
onready var softCollision = $SoftCollision
onready var stopHurtSound = $hurt
onready var timer = $Timer



enum{
	ATTACK,
	DEATH,
	IDLE,
	CHASE
	
}

var state = IDLE
var timerCheck = false
func _physics_process(delta):
	match state:
		ATTACK:
			var targetPlayer = playerDetectionZone.player
			if targetPlayer != null:
				if timerCheck == true:
					animationState.travel("Attack")
					var direction = (targetPlayer.global_position - global_position).normalized()
					velocity = velocity.move_toward(direction * DASH_SPEED, ACCELERATION * delta)
					sprite.flip_h = velocity.x > 0
				else:
					state = CHASE
			
		
		DEATH:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			death_state()
		
		IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				animationState.travel("Move")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				if timerCheck == false:
					lunge_player()
			else:
				state = IDLE
			sprite.flip_h = velocity.x > 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 600
	velocity = move_and_slide(velocity)


func exit_attack():
	state = CHASE

func lunge_player():
	if attackRange.can_see_player():
		if timerCheck == false:
			timerCheck = true
			timer.start()
			state = ATTACK

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	var text = damageNumbers.instance()
	text.amount = area.damage
	text.position = global_position
	var world = get_tree().current_scene
	world.add_child(text)
	damageTint.play("DamageTint")
	hurtBox.start_invincibility(.1)
	
	var splinterEffect = load("res://enemy/SplinterEffect.tscn")
	var splinter_instance = splinterEffect.instance()
	splinter_instance.position = global_position
	world.add_child(splinter_instance)
	
	var leafEffect = load("res://enemy/LeafEffect.tscn")
	var leaves_instance = leafEffect.instance()
	leaves_instance.position = global_position
	world.add_child(leaves_instance)
	
	


func ground_smash():
	var groundSmash = load("res://Prefabs/Effects/GroundSmash.tscn")
	var smash_instance = groundSmash.instance()
	smash_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(smash_instance)
	
	groundSmash = load("res://Prefabs/Effects/GroundSmash2.tscn")
	smash_instance = groundSmash.instance()
	smash_instance.position = global_position
	world.add_child(smash_instance)



func _on_Stats_no_health():
	death_state()
	
func death_state():
	state = DEATH
	animationState.travel("Death")


func _on_Timer_timeout():
	timerCheck = false
