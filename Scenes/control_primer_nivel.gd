extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stop()
	MusicLevelThree.stop()
	MusicLevelTwo.stop()
	
	MusicLevelOne.play()
