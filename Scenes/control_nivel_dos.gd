extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stop()
	MusicLevelOne.stop()
	MusicLevelThree.stop()
	
	MusicLevelTwo.play()
