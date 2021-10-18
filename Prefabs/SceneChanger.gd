extends Area2D

export var sceneDestination = ""


func _on_SceneChanger_body_entered(_body):
	get_tree().change_scene_to(load(sceneDestination))
