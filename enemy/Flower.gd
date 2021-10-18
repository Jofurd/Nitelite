extends KinematicBody2D

var velocity = Vector2.ZERO
export var ACCELERATION = 200
export var MAX_SPEED = 70
export var FRICTION = 150
export var DASH_SPEED = 300


onready var stats = $Stats
onready var sprite = $Sprite
onready var animationPlayer = $Sprite/AnimationPlayer
onready var animationTree = $Sprite/AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var closePlayerDetection = $Sprite/flowerpointer/ClosePlayerDetection
onready var farPlayerDetection = $Sprite/flowerpointer/FarPlayerDetection
onready var musicZone = $MusicZone/CollisionShape2D
onready var flowerPointer = $Sprite/flowerpointer
onready var damageTint = $Sprite/damage
onready var hurtBox = $Hurtbox
onready var softCollision = $SoftCollision
onready var stopHurtSound = $hurt
onready var stopBeamSound = $startBeam
onready var burrowTimer = $BurrowTimer
onready var beamHitbox = $Sprite/flowerpointer/Hitbox/CollisionShape2D
onready var chaserHitbox = $Sprite/flowerpointer/ChaserBeam/Hitbox/CollisionShape2D


enum{
	HURT,
	DEATH,
	IDLE,
	MOVING,
	SHOOTING,
	BURROWING,
	EMERGING
}


var state = IDLE
var burrowTimerCheck = false
func _physics_process(delta):
	match state:
		HURT:
			sprite.flip_h = velocity.x > 0
			hurt_state()
		
		DEATH:
			sprite.flip_h = velocity.x > 0
			death_state()
		
		IDLE:
			sprite.flip_h = velocity.x > 0
			seek_player()
		
		MOVING:
			var burrowEffect = load("res://Prefabs/Effects/BurrowingFlower.tscn")
			var burrow_instance = burrowEffect.instance()
			burrow_instance.position = global_position
			var world = get_tree().current_scene
			world.add_child(burrow_instance)
			move_state(delta)
		
		SHOOTING:
			var farPlayer = farPlayerDetection.player
			if farPlayer == null:
				animationState.travel("Idle")
				state = IDLE
		
		BURROWING:
			var burrowEffect = load("res://Prefabs/Effects/BurrowingFlower.tscn")
			var burrow_instance = burrowEffect.instance()
			burrow_instance.position = global_position
			var world = get_tree().current_scene
			world.add_child(burrow_instance)
		
		EMERGING:
			velocity = Vector2.ZERO
		
	
	velocity = move_and_slide(velocity)

func seek_player():
	if closePlayerDetection.can_see_player():
		musicZone.disabled = false
		animationState.travel("Shooting")
		state = SHOOTING

func move_state(delta):
	var player = farPlayerDetection.player
	if burrowTimerCheck == true:
		if player != null:
			var direction = (player.global_position - global_position).normalized()
			velocity = velocity.move_toward(direction * (MAX_SPEED * -1), (ACCELERATION * -1) * delta)
	else:
		state = EMERGING
		animationState.travel("Idle")


func hurt_state():
	animationState.travel("Hurt")

func exit_hurt():
	state = BURROWING
	stopHurtSound.playing = false
	animationState.travel("Hidden")
	hurtBox.monitorable = false
	hurtBox.monitoring = false
	beamHitbox.disabled = true
	chaserHitbox.disabled = true
	

func burrowed():
	state = MOVING
	burrowTimer.start()
	burrowTimerCheck = true

func emerged():
	hurtBox.monitorable = true
	hurtBox.monitoring = true
	beamHitbox.disabled = false
	chaserHitbox.disabled = false
	if farPlayerDetection.can_see_player():
		animationState.travel("Shooting")
		state = SHOOTING
	else:
		state = IDLE

func _on_Stats_no_health():
	death_state()
	

var ispointerhere = true
func death_state():
	state = DEATH
	if ispointerhere == true:
		flowerPointer.queue_free()
		ispointerhere = false
	animationState.travel("Death")

func _on_Hurtbox_area_entered(area):
	state = HURT
	stats.health -= area.damage
	damageTint.play("DamageTint")
	hurtBox.start_invincibility(.5)
	flowerPointer.clear_chaser()
	
	var splinterEffect = load("res://enemy/LeafEffect.tscn")
	var splinter_instance = splinterEffect.instance()
	splinter_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(splinter_instance)


func _on_BurrowTimer_timeout():
	burrowTimerCheck = false
