extends KinematicBody2D

var velocity = Vector2.ZERO
export var ACCELERATION = 300
export var MAX_SPEED = 100
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


enum{
	HURT,
	DEATH,
	IDLE,
	MOVING,
	SHOOTING
}


var state = IDLE
func _physics_process(_delta):
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
			pass
		
		SHOOTING:
			var farPlayer = farPlayerDetection.player
			if farPlayer == null:
				animationState.travel("Idle")
				state = IDLE
		
	
	velocity = move_and_slide(velocity)

func seek_player():
	if closePlayerDetection.can_see_player():
		musicZone.disabled = false
		animationState.travel("Shooting")
		state = SHOOTING



func hurt_state():	
	animationState.travel("Hurt")

func exit_hurt():
	stopHurtSound.playing = false
	if farPlayerDetection.can_see_player():
		musicZone.disabled = false
		animationState.travel("Shooting")
		state = SHOOTING
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
	flowerPointer.clear_chaser()
	
	var splinterEffect = load("res://enemy/LeafEffect.tscn")
	var splinter_instance = splinterEffect.instance()
	splinter_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(splinter_instance)
