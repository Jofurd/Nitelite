extends Node2D

const BALL_SPEED = 10

onready var beam = $Beam
onready var hitBox = $Hitbox
onready var hitBoxCollider = $Hitbox/CollisionShape2D
onready var hitBoxShape = preload("res://enemy/BeamShape.tres")
onready var closePlayerDetection = $ClosePlayerDetection
onready var farPlayerDetection = $FarPlayerDetection


var isBeamDisabled = false

var test = Vector2.ZERO

func _process(_delta):
	var chaserBeam = $ChaserBeam
	if chaserBeam != null:
		var farPlayer = farPlayerDetection.player
		if farPlayer != null:
			isBeamDisabled = false
			hitBoxCollider.disabled = false
			look_at(chaserBeam.global_position)
			var beamDistance = self.global_position.distance_to(chaserBeam.global_position)
			beam.position.x = (beamDistance / 2)
			beam.region_rect.size.x = (beamDistance)
			hitBox.position.x = (beamDistance / 2)
			hitBoxShape.extents.x = (beamDistance / 2)
		else:
			chaserBeam.queue_free()
	elif isBeamDisabled == false:
		beam.position.x = 0
		beam.region_rect.size.x = 0
		hitBox.position.x = 0
		hitBoxShape.extents.x = 0
		hitBoxCollider.disabled = true
		isBeamDisabled = true
			

func shoot():
	var magicBall = load("res://enemy/ChaserBeam.tscn")
	var ball_instance = magicBall.instance()
	ball_instance.position = self.global_position
	ball_instance.rotation_degrees = rotation_degrees
	self.add_child(ball_instance)

func clear_chaser():
	var chaserBeam = $ChaserBeam
	if chaserBeam != null:
		chaserBeam.queue_free()


