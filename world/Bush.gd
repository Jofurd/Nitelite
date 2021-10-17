extends Node2D



func _on_Hurtbox_area_entered(_area):
	var splinterEffect = load("res://enemy/LeafEffect.tscn")
	var splinter_instance = splinterEffect.instance()
	splinter_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(splinter_instance)
	queue_free()
