extends Node2D

var codigo = "A332B#";
@onready var arduino_control = $Control
var codigo_actual = ""

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	# Conectar la señal desde el script
	arduino_control.connect("KeypadInput", _on_keypad_input)


func _on_keypad_input(input: String):
	# numero maximo de caracteres en el codigo es 6
	# Procesar el input del keypad aquí
	print("Input recibido: ", input)
	# Aquí puedes agregar la lógica para validar el código
	
	codigo_actual += input
	print ("Codigo actual: ", codigo_actual)

	if codigo_actual.length() == 6:
		if codigo_actual == codigo:
			print("Codigo correcto")
			get_tree().change_scene_to_file("res://Scenes/Mapa puzzle matriz post keypad.tscn")
		else:
			print("Codigo incorrecto")
			codigo_actual = ""
			

# Llamado cada cuadro. 'delta' es el tiempo transcurrido desde el cuadro anterior.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("change_scene"):
		#get_tree().change_scene_to_file("res://Scenes/Mapa puzzle matriz post KeyPad.tscn")
		pass
