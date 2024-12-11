extends Area2D
@onready var area=$"../Area2D"
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el jugador tenga el grupo "player"
		area.monitoring=true
		queue_free()
	else:	
		print("Algo más entró en el área.")
