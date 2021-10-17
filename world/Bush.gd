extends Node2D



func _on_Hurtbox_area_entered(_area):
	var soundEffect = load("res://Prefabs/Sounds/small_grass_poof.tscn")
	var sound_instance = soundEffect.instance()
	sound_instance.position = global_position
	var world = get_tree().current_scene
	world.add_child(sound_instance)
	
	
	var splinterEffect = load("res://enemy/LeafEffect.tscn")
	var splinter_instance = splinterEffect.instance()
	splinter_instance.position = global_position
	world.add_child(splinter_instance)
	queue_free()
