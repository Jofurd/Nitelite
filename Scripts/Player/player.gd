extends KinematicBody2D

export var FRICTION = 500
export var ACCELERATION = 500
export var DASH_SPEED = 300
export var MAX_SPEED = 100


enum{
	MOVE,
	DASH,
	DEATH
	
}

var state = MOVE
var velocity = Vector2.ZERO
var dash_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var damageTint = $Sprite/damage
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtBox = $Hurtbox
onready var enemyDetect = $EnemyDetectionZone
onready var deathScreen = $CanvasLayer/DeathScreen
onready var pauseHandler = $CanvasLayer/PauseHandler
onready var walkingSound = $WalkingSound

func _ready():
	stats.connect("no_health", self, "death_state")
	animationTree.active = true
	


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		DASH:
			dash_state(delta)
		
		DEATH:
			death_state()
		
		
	
	
	

var campfire = null

var respawnPoint = global_position
var respawn_ID = 0
func _on_RespawnFinder_area_entered(area):
	campfire = area
	
	if campfire.get_parent().respawn_ID != self.respawn_ID:
		respawnPoint = campfire.global_position
		respawnPoint.y -= 20
		respawn_ID = campfire.get_parent().respawn_ID
	stats.health = stats.max_health
	var campfireActivate = load("res://Prefabs/Effects/CampfireActivate.tscn")
	var cfActivate_instance = campfireActivate.instance()
	cfActivate_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(cfActivate_instance)
	


func _on_RespawnFinder_area_exited(_area):
	campfire = null

func death_state():
	state = DEATH
	self.pause_mode = 2
	self.visible = false
	pauseHandler.pause_mode = 1
	get_tree().paused = true
	deathScreen.visible = true


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		dash_vector = input_vector
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/run/blend_position", input_vector)
		animationTree.set("parameters/dash/blend_position", input_vector)
		animationState.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		if walkingSound.playing == false:
			walkingSound.playing = true
	
	else:
		animationState.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if walkingSound.playing == true:
			walkingSound.playing = false
	
	move()
	
	if Input.is_action_just_pressed("secondary_action"):
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("dash"):
		state = DASH


func dash_state(_delta):
	if walkingSound.playing == true:
			walkingSound.playing = false
	var DashDust = load("res://Prefabs/Player/DashDust.tscn")
	var dust_instance = DashDust.instance()
	dust_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(dust_instance)
	
	velocity = dash_vector * DASH_SPEED
	animationState.travel("dash")
	move()

func dash_start():
	var dashSound = load("res://Prefabs/Sounds/dash.tscn")
	var dashSound_instance = dashSound.instance()
	dashSound_instance.position = global_position
	self.add_child(dashSound_instance)
	
	
	var startDash = load("res://Prefabs/Player/DashStartEffect.tscn")
	var startdash_instance = startDash.instance()
	startdash_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(startdash_instance)


func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	
	velocity = velocity / 2
	state = MOVE





func _on_Hurtbox_area_entered(area):
	damageTint.play("DamageTint")
	stats.health -= area.damage
	hurtBox.start_invincibility(.5)
	
	
	var hurtSound = load("res://Prefabs/Sounds/PlayerHurt.tscn")
	var hurtsound_instance = hurtSound.instance()
	hurtsound_instance.position = global_position
	self.add_child(hurtsound_instance)
	



func _on_respawn_pressed():
	self.position = respawnPoint
	stats.health = stats.max_health
	get_tree().paused = false
	self.pause_mode = 0
	pauseHandler.pause_mode = 2
	self.visible = true
	deathScreen.visible = false
	state = MOVE
