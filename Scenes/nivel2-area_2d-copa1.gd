extends Area2D

var player_inside = false
var mensaje_mostrado = false

func _on_body_entered(body: Node) -> void:
	if body.name == "player2" or body.name == "Player1":
		player_inside = true
		mensaje_mostrado = false

func _on_body_exited(body: Node) -> void:
	if body.name == "player2" or body.name == "Player1":
		player_inside = false
		mensaje_mostrado = false  # Limpiar el estado al salir



func _process(delta):
	if player_inside:
		if Global.gotas_tomadas_lvl2 == 5:
			if Global.copa_1==false:
				Global.player_positions["Player1"] = $"/root/Mundo/Player1".global_position
				Global.player_positions["player2"] = $"/root/Mundo/player2".global_position
				get_tree().change_scene_to_file("res://Scenes/nivel2_copa1.tscn")
		elif not mensaje_mostrado:  # Solo mostrar el mensaje una vez
			print("Aun te faltan gotas")
			mensaje_mostrado = true  # Marcar como mostrado
			player_inside = false
