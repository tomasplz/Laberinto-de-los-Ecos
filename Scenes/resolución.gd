extends Control

# Referencia al OptionButton en el árbol de la escena                                               
@onready var ResOptionButton: OptionButton = $Options/ResolutionsContainer/OptionButton

# Diccionario de resoluciones disponibles
var Resolutions: Dictionary = {
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440),
	"1600x900": Vector2i(1600, 900),
	"800x600":Vector2i(800, 600)
}

# Función que se ejecuta al inicializar la escena
func _ready():
	AddResolutions()
	# Conectar la señal `item_selected` del OptionButton al método correspondiente
	ResOptionButton.item_selected.connect(_on_option_button_item_selected)

# Función para agregar las resoluciones al OptionButton y seleccionar la actual
func AddResolutions():
	# Obtener la resolución actual de la ventana
	var current_resolution = DisplayServer.window_get_size()
	var index = 0

	# Agregar cada resolución al OptionButton
	for resolution in Resolutions.keys():
		ResOptionButton.add_item(resolution)  # Agregar la resolución al OptionButton
		# Seleccionar la opción que coincide con la resolución actual
		if Resolutions[resolution] == current_resolution:
			ResOptionButton.select(index)
		index += 1

# Función para cambiar la resolución al seleccionar una opción
func _on_option_button_item_selected(index: int):
	var size = Resolutions.get(ResOptionButton.get_item_text(index))
	if size:
		# Cambiar el tamaño de la ventana
		DisplayServer.window_set_size(size)
		# Configurar el aspecto y el modo de escalado
		ProjectSettings.set_setting("display/window/stretch/aspect", "keep")
		ProjectSettings.set_setting("display/window/stretch/mode", "viewport")
		
		ProjectSettings.save()
		


func _on_full_screen_toggle_toggled(button_pressed: bool):
	
	if button_pressed:
		# Cambiar a modo pantalla completa
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		# Cambiar a modo ventana
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		
		# Obtener el tamaño del viewport y ajustar el tamaño de la ventana
		var size = get_viewport().get_size()
		DisplayServer.window_set_size(size)
		
		# Centrar la ventana en la pantalla
		DisplayServer.window_set_position(Vector2(0, 0)) # Ajustar para que se centre manualmente si necesario
		
		# Centrar la ventana en la pantalla
		var screen_size = DisplayServer.screen_get_size()
		var window_position = (screen_size - size) / 2
		DisplayServer.window_set_position(window_position)
		


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/opciones.tscn")
