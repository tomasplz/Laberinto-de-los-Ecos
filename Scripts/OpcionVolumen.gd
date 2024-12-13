extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load saved settings or initialize slider values with consistent UI feedback
	var master_volume = get_stored_volume("master", AudioServer.get_bus_volume_db(0))
	var music_volume = get_stored_volume("music", AudioServer.get_bus_volume_db(1))

	$Audio/VBoxContainer/MasterSlider.min_value = -50
	$Audio/VBoxContainer/MasterSlider.max_value = 0
	$Audio/VBoxContainer/MasterSlider.value = master_volume


	# Verify nodes and connect signals for real-time updates
	if $Audio/VBoxContainer/MasterSlider:
		$Audio/VBoxContainer/MasterSlider.connect("value_changed", Callable(self, "_on_master_slider_value_changed"))
	else:
		print("Error: MasterSlider node not found.")


# Apply changes and ensure values persist
func _on_confirmar_pressed():
	AudioServer.set_bus_volume_db(0, $Audio/VBoxContainer/MasterSlider.value)

	save_volume("master", $Audio/VBoxContainer/MasterSlider.value)

	print("Settings applied: Master volume - ", $Audio/VBoxContainer/MasterSlider.value, ", Music volume - ")
	get_tree().change_scene_to_file("res://Scenes/opciones.tscn")
# Master slider value changed
func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	print("Master volume updated to: ", value, " dB")

# Music slider value changed
# Helper functions to save and retrieve volumes
func save_volume(key: String, value: float):
	var settings = ProjectSettings.globalize_path("user://volume_settings.cfg")
	var config = ConfigFile.new()
	config.load(settings)
	config.set_value("Volumes", key, value)
	config.save(settings)

func get_stored_volume(key: String, default_value: float) -> float:
	var settings = ProjectSettings.globalize_path("user://volume_settings.cfg")
	var config = ConfigFile.new()
	if config.load(settings) == OK:
		return config.get_value("Volumes", key, default_value)
	return default_value
