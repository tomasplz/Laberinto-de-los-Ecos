extends Area2D
@onready var camera_main = $"../Camera2D"
@onready var camera_secondary = $"../Camera2D2"

var mission_completed = false  # Bandera para saber si la misión se completó



func change_camera(to_secondary: bool):
	# En Godot 4, asignar `current` directamente con un booleano no es posible
	# En su lugar, se debe usar la función `Camera2D.make_current()`
	
	if to_secondary:
		camera_secondary.make_current()  # Activa la cámara secundaria
	else:
		camera_main.make_current()
# Llamado cuando la misión se complete
func complete_mission():
	mission_completed = true
	change_camera(false)  # Vuelve a la cámara principal


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el jugador tenga el grupo "player"
		change_camera(true)
	else:
		print("Algo más entró en el área.")
