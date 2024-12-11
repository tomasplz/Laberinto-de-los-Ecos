extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta: float):
	pass


func _on_confirmar_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_db($Audio/VBoxContainer/MasterSlider.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($Audio/VBoxContainer/MusicaSlider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($Audio/VBoxContainer/EfectosSlider.value))
	
	get_tree().change_scene_to_file("res://Scenes/opciones.tscn")
