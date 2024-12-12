extends Area2D

var player_inside = false

func _on_body_entered(body: Node) -> void:
	if body.name == "player2" or body.name =="Player1":
		player_inside = true

func _process(delta):
	if player_inside:
		get_tree().change_scene_to_file("res://Scenes/TransicionCatacumbasaPalacio.tscn")
