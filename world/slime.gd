extends Node2D


func create_slime_death():
	var SlimeDeath = load("res://world/SlimeDeath.tscn")
	var slimeDeath = SlimeDeath.instance()
	var world = get_tree().current_scene
	world.add_child(slimeDeath)
	slimeDeath.global_position = global_position


func _on_Hurtbox_area_entered(_area):
	create_slime_death()
	queue_free()
