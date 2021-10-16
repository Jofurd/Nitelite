extends Node2D

const BALL_SPEED = 10

onready var beam = $Beam
onready var hitBox = $Hitbox
onready var hitBoxCollider = $Hitbox/CollisionShape2D
onready var hitBoxShape = preload("res://enemy/BeamShape.tres")
onready var closePlayerDetection = $ClosePlayerDetection
onready var farPlayerDetection = $FarPlayerDetection
onready var chaserBeam = $ChaserBeam
onready var chaserBeamAudio = $ChaserBeam/AudioStreamPlayer2D


var isBeamDisabled = false

var test = Vector2.ZERO

func _ready():
	chaserBeam.position = self.global_position

func _process(_delta):
	
	if chaserBeam.state == 1:
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
			chaserBeam.state = 0
	elif isBeamDisabled == false:
		beam.position.x = 0
		beam.region_rect.size.x = 0
		hitBox.position.x = 0
		hitBoxShape.extents.x = 0
		hitBoxCollider.disabled = true
		isBeamDisabled = true
			

func shoot():
	chaserBeamAudio.playing = true
	chaserBeam.state = 1
	chaserBeam.position = self.global_position

func clear_chaser():
	chaserBeam.state = 0
	chaserBeam.position = self.global_position


