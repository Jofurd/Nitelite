extends RigidBody2D

var velocity = Vector2.ZERO
onready var ballHitbox = $Hurtbox

func _ready():
	ballHitbox.knockback_vector = linear_velocity

func _on_Hurtbox_area_entered(_area):
	queue_free()


func _on_MagicBall_body_entered(_body):
	queue_free()
