extends Control

func _ready() -> void:
	Music.play()
	MusicLevelThree.stop()
	MusicLevelTwo.stop()
	MusicLevelOne.stop()
