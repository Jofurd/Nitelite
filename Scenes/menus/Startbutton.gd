extends StaticBody2D


onready var sprite = $Sprite
onready var animationTree = $Sprite/AnimationTree
onready var animationPlayer = $Sprite/AnimationPlayer
onready var animationState = animationTree.get("parameters/playback")
onready var damageTint = $Sprite/damage
onready var hurtBox = $Hurtbox
onready var stats = $Stats

var damageNumbers = preload("res://Prefabs/DamageNumber.tscn")

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	var text = damageNumbers.instance()
	text.amount = area.damage
	text.position = global_position
	var world = get_tree().current_scene
	world.add_child(text)
	damageTint.play("DamageTint")
	hurtBox.start_invincibility(.1)
	animationState.travel("Hurt")

func exit_hurt():
	animationState.travel("Idle")

func _on_Stats_no_health():
	print("DED")
	animationTree.active = false
	animationPlayer.stop()
	animationPlayer.play("Death")
	

func start_game():
	get_tree().change_scene("res://Scenes/Forest.tscn")
