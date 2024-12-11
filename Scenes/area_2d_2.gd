extends Area2D
@onready var player = $"../Player1" 

func _on_body_entered(body: Node):
	if body == player:  # Verifica que sea el jugador
		get_tree().change_scene_to("res://Scenes/TransicionCatacumbasaPalacio.tscn")
		print("Jugador ha entrado en el área")
		
