extends Control

func _ready():
	# Inicializar valores de los sliders basados en el estado actual de los buses
	$VBoxContainer/MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/MusicaSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/EfectosSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _process(delta):
	pass


func _on_master_slider_mouse_exited():
	release_focus()


func _on_musica_slider_mouse_exited():
	release_focus()


func _on_efectos_slider_mouse_exited():
	release_focus()
