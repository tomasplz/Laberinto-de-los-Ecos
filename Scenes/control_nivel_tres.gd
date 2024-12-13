extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stop()
	MusicLevelTwo.stop()
	MusicLevelOne.stop()
	
	MusicLevelThree.play()
