extends Node2D

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	# Puedes agregar inicializaciones adicionales aquí si es necesario.
	pass

# Llamado cada cuadro. 'delta' es el tiempo transcurrido desde el cuadro anterior.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_scene"):
		get_tree().change_scene_to_file("res://Scenes/Mapa puzzle matriz post keypad.tscn")
