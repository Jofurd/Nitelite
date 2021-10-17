extends Node2D

onready var audioPlayer = $AudioStreamPlayer2D

func _on_AudioStreamPlayer2D_finished():
	queue_free()
