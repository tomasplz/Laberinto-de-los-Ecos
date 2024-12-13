extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_positions["Player1"] != null:
		$"/root/Laberinto/Player1".global_position = Global.player_positions["Player1"]
	if Global.player_positions["player2"] != null:
		$"/root/Laberinto/player2".global_position = Global.player_positions["player2"]
	Music.stop()
	MusicLevelOne.stop()
	MusicLevelTwo.stop()
	MusicLevelThree.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("Estado p1: ", Global.potenciometro1)
	#print("Estado p2: ", Global.potenciometro2)
	#print("Estado p3: ", Global.potenciometro3)
	pass
