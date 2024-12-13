extends Area2D

@onready var text_label = $"/root/World/Interaccion Keypad"
var player_inside = false


func _on_body_entered(body: Node) -> void:
	if body.name == "player2":
		text_label.visible = true
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body.name == "player2":
		text_label.visible = false
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("change_scene"):
		Global.player_positions["Player1"] = $"/root/World/Player1".global_position
		Global.player_positions["player2"] = $"/root/World/player2".global_position
		get_tree().change_scene_to_file("res://Scenes/Keypad.tscn")
