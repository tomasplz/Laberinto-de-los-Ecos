extends Node2D


func _ready():
	
	if Global.player_positions["Player1"] != null:
		$"/root/Laberinto/Player1".global_position = Global.player_positions["Player1"]
	if Global.player_positions["player2"] != null:
		$"/root/Laberinto/player2".global_position = Global.player_positions["player2"]
