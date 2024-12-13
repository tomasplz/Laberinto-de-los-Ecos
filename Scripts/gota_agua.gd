extends Area2D
@onready var area=$"../Area2D"
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el jugador tenga el grupo "player"
		area.monitoring=true
		Global.gotas_tomadas_lvl2 = Global.gotas_tomadas_lvl2 + 1
		print("Cantidad de gotas: ", Global.gotas_tomadas_lvl2)
		queue_free()
	else:	
		print("Algo más entró en el área.")
