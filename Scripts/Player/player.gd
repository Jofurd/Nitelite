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

func can_see_campfire():
	return campfire != null

var respawnPoint = self.global_position
func _on_RespawnFinder_area_entered(area):
	campfire = area
	respawnPoint = area.global_position
	respawnPoint.y -= 20


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
	
	else:
		animationState.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("secondary_action"):
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("dash"):
		state = DASH


func dash_state(_delta):
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




func _on_respawn_pressed():
	self.position = respawnPoint
	stats.health = stats.max_health / 2
	get_tree().paused = false
	self.pause_mode = 0
	pauseHandler.pause_mode = 2
	self.visible = true
	deathScreen.visible = false
	state = MOVE
