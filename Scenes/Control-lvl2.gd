extends Control

@onready var sprite_copa = $'../Area2D2/Sprite2D'  # Ajusta la ruta según tu estructura

func _ready():
	if Global.player_positions["Player1"] != null:
		$"/root/Mundo/Player1".global_position = Global.player_positions["Player1"]
	if Global.player_positions["player2"] != null:
		$"/root/Mundo/player2".global_position = Global.player_positions["player2"]
	# Verificar si el desafío ya fue completado
	if Global.copa_1:
		sprite_copa.visible = false

	Music.stop()
	MusicLevelOne.stop()
	MusicLevelTwo.play()
	MusicLevelThree.stop()
