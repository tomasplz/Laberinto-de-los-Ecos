extends Control


func _ready() -> void:
	pass

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TransicionCatacumbas.tscn")


func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/opciones.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
