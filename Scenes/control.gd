extends Control

func _ready() -> void:
	MusicLevelThree.stop()
	MusicLevelTwo.stop()
	MusicLevelOne.stop()
	
	Music.play()
