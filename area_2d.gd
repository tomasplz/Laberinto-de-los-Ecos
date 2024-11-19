extends Area2D
@onready var camera_main = $"../Camera2D"
@onready var camera_secondary = $"../Camera2D2"

var mission_completed = false  # Bandera para saber si la misión se completó



# Cambia entre las cámaras
func change_camera(to_secondary: bool):
	camera_main.current = !to_secondary  # Si 'to_secondary' es true, desactiva la cámara principal
	camera_secondary.current = to_secondary  # Si 'to_secondary' es true, activa la cámara secundaria

# Llamado cuando la misión se complete
func complete_mission():
	mission_completed = true
	change_camera(false)  # Vuelve a la cámara principal


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el jugador tenga el grupo "player"
		change_camera(true)
	else:
		print("Algo más entró en el área.")
