extends Control

func _on_volumen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/volumen.tscn")

func _on_pantalla_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/resolución.tscn")

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
